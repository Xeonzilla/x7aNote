# x7aNote

基于[空栈顶](https://emptystack.top/)样式的个人博客。

## 使用

不建议直接使用此项目，因为包含大量个性化功能与非标准实现。如果一定要直接使用，应当在使用前移除 `content` 中的内容。

欢迎在遵守开源协议的前提下，基于此项目进行二次开发。

## 预览

```powershell
hugo server
```

## 构建

```powershell
hugo --environment production --cleanDestinationDir --panicOnWarning --printI18nWarnings --printPathWarnings --printUnusedTemplates --minify --gc
```

## 许可

本站源代码使用 [MPL-2.0](LICENSE) 协议发布。

除特别说明外，本站原创文字内容使用 [CC BY-NC-SA 4.0](https://creativecommons.org/licenses/by-nc-sa/4.0/) 许可协议，原创图像保留所有权利。转载文章、引用内容和第三方图像版权归原作者所有。
