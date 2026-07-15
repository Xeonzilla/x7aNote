---
title: "为Fuwari定制图像服务"
date: 2025-11-16
cover: true
tags:
  - "astro"
---

## 前言

因为Cloudflare Workers存在20分钟的构建限制，在迁移至Workers后，我被迫使用了WebP，但是我一直没有放弃AVIF。在仔细研究Astro文档后，我决定构建一个自定义图像处理服务，该服务能够跳过对AVIF格式的图像处理，同时将所有其他格式的图像转换为WebP。

为了更好地理解本文的背景和探索过程，我建议先阅读姊妹篇[为Fuwari启用响应式图像](/fuwari-responsive-images/)，以了解我在进行本次修改前所做的修改。同样地，本文侧重于过程记录而非详尽的教程，因此文中可能存在不严谨之处或信息缺漏。

## 筛选格式

Astro的图像服务专注于处理图像本身，而不直接介入格式筛选，因此在图像服务内部筛选AVIF是不可行的。由于在之前的修改中，所有图像都由`ImageWrapper.astro`包装，所以我们可以在包装器中进行筛选，并显式标记`format="avif"`。

```astro
---
const isAvif = /\.avif$/i.test(src);
---

<Image {...isAvif && { format: "avif" }} />
```

核心逻辑非常简单，识别`.avif`的文件名即可。对于其他格式的图像，我们不必标记格式，因为所有其他格式的图像都会被转换为WebP。鉴于WebP的转换速度很快，且我在源文件中不使用WebP格式，因此，构建过程中少量从WebP到WebP的冗余转换是可以接受的。

## 转换图像

经过包装器的分类后，我们的自定义图像服务就能够根据是否存在`format="avif"`，对不同格式的图像采取不同的处理流程。

```typescript
import type { LocalImageService } from "astro";
import { baseService } from "astro/assets";
import sharp from "sharp";

// AVIF passthrough, others convert to WebP
const customImageService: LocalImageService = {
  validateOptions: baseService.validateOptions,
  getHTMLAttributes: baseService.getHTMLAttributes,
  getURL: baseService.getURL,
  parseURL: baseService.parseURL,

  async transform(inputBuffer, transformOptions) {
    if (!inputBuffer || inputBuffer.length === 0) {
      throw new Error("Invalid input buffer: buffer is empty");
    }

    // Return original data
    if (transformOptions.format === "avif") {
      return {
        data: inputBuffer,
        format: "avif" as const,
      };
    }

    try {
      const { width, height, quality } = transformOptions;

      // Validate dimensions
      if ((width !== undefined && width < 0) || (height !== undefined && height < 0)) {
        throw new Error("Invalid dimensions: width and height must be non-negative");
      }

      // Clamp quality to 1-100
      const validQuality = quality ? Math.max(1, Math.min(100, quality)) : undefined;

      // Create Sharp instance with optimized config
      let sharpInstance = sharp(inputBuffer, {
        failOnError: false,
        pages: -1,
        limitInputPixels: 268402689,
        sequentialRead: true,
      });

      // Resize if needed
      if (width || height) {
        sharpInstance = sharpInstance.resize({
          width,
          height,
          fit: "inside",
          withoutEnlargement: true,
        });
      }

      // Convert to WebP
      const buffer = await sharpInstance
        .webp(validQuality ? { quality: validQuality } : undefined)
        .toBuffer();
      const data = new Uint8Array(buffer);

      return {
        data,
        format: "webp",
      };
    } catch (error) {
      console.error("Image transform failed:", error);
      console.error("Transform options:", transformOptions);

      // Return original data as fallback
      return {
        data: inputBuffer,
        format: transformOptions.format || "webp",
      };
    }
  },

  getSrcSet(options, imageConfig) {
    if (options.format === "avif") {
      return [];
    }

    return baseService.getSrcSet?.(options, imageConfig) ?? [];
  },
};

export default customImageService;
```

对于传入的AVIF，我们不进行任何处理，直接输出原始图像；对于其他格式的图像，我们使用`sharp`模拟原始的图像处理流程，在不进行额外设置的情况下，默认生成质量为80的WebP，而在接收到配置的`sizes`与`widths`时，此服务也能够生成一系列对应尺寸与质量的响应式图像。Astro在内部设置了一系列预设值，使得用户能够在不同格式之间自动标准化，但是我们的图像处理服务只输出WebP，所以也没有必要重新实现这一功能。

现在所有的AVIF都会被拉取到本地，并在文件名添加哈希标识。为什么选择拉取图像而不直接使用远程URL，并且拉取后又不进行优化呢？因为拉取后，所有图像都将位于站点的`/_astro`路径下。这样做有两个好处：首先，可以一定程度上隐藏原始的远程图像URL；其次，资源与主站处于同一域名，有利于缓存优化。Cloudflare Workers环境下，拉取一张来自Cloudflare R2的图像用时15毫秒以内，相较于此方案带来的安全与性能优化，增加少许的构建时间是完全可接受的。

## 清理代码

完成了自定义图像处理服务的构建后，先前新增的响应式图像相关代码已无必要，可以安全地回滚代码。

最终我只保留了追番页与友链页的相关配置，因为这些页面的图像均为外部来源，我无法直接优化图像本身，因此构建时优化便非常有必要。

## 小结

总结一下，我们本次修改的核心是：保留站点内所有的AVIF图像，不对其进行转换或生成响应式尺寸，仅通过Astro的`<Image />`组件来避免CLS（累积布局偏移）。在大多数情况下，AVIF已经足够高效，将其转换为WebP不仅影响图像的准确性，还增加了无谓的体积。

对于其他的Astro主题，如果出于同样的绕过AVIF的需求，可以直接使用本文的自定义图像服务，但需要一个类似`ImageWrapper.astro`的包装器或是分类器，又或是手动标记所使用的AVIF，在图像处理前完成分类的工作。

## 图像优化效率学

我始终建议所有站点维护者提前优化由自己控制的图像资源，因为构建前的优化仅需一次，就能得到永久的收益；依靠每次的构建时转换，耗费了远超单次转换所需的时间，仅能得到相同的收益，显然是不划算的。现代的图像格式，例如WebP与AVIF，能够在不损失画面素质的情况下大幅减小图像体积，对于没有特殊需求的使用者，根本没有坚持在站点使用JPG与PNG的理由。

同样，对于目前的WebP使用者，我建议逐步迁移至AVIF。同为现代图像格式，AVIF在压缩性能上比WebP要好上不少；而对比尚在发展中的下一代图像格式，如WebP2与JPEG XL，AVIF在当前的普及度和浏览器兼容性上更具优势。而AVIF唯一的劣势是转换速度，在构建前单次转换的前提下，也不算什么大问题。
