### What is `MajSoul Ex`?

MajSoul Ex is a third-party client that supports all platforms, supports the installation of custom extensions, and its experience is roughly the same as the official client.

### Version Information

[![VersionLatest](https://img.shields.io/github/release/moxcomic/majsoul-ex) ![DownloadsLatest](https://img.shields.io/github/downloads/moxcomic/majsoul-ex/latest/total)](https://github.com/moxcomic/majsoul-ex/releases/latest)  
[![Windows](https://img.shields.io/badge/Windows-1.0.38-ff69b4)](https://github.com/moxcomic/majsoul-ex/releases/latest) [![macOS](https://img.shields.io/badge/macOS-1.0.38-ff69b4)](https://github.com/moxcomic/majsoul-ex/releases/latest) [![macOS M1](https://img.shields.io/badge/macOS%20M1-1.0.38-ff69b4)](https://github.com/moxcomic/majsoul-ex/releases/latest) [![Linux](https://img.shields.io/badge/Linux-1.0.38-ff69b4)](https://github.com/moxcomic/majsoul-ex/releases/latest) [![Android](https://img.shields.io/badge/Android-1.2.4-ff69b4)](https://github.com/moxcomic/majsoul-ex/releases/latest) [![iOS](https://img.shields.io/badge/iOS-3.2.0-ff69b4)](https://github.com/moxcomic/majsoul-ex/releases/latest)

### Important update and description

If your version is lower than [![Windows](https://img.shields.io/badge/Windows-1.0.33-ff69b4)](https://github.com/moxcomic/majsoul-ex/releases/latest) or [![Android](https://img.shields.io/badge/Android-1.2.2-ff69b4)](https://github.com/moxcomic/majsoul-ex/releases/latest) please Upgrade as soon as possible to achieve a stable conversion plug-in effect  
The PC version needs to install the `Chrome browser` by yourself, otherwise the game will not start

What are the `differences` compared to `MajSoul Plus`?
[![1](https://img.shields.io/static/v1?label=New%20Concept&message=The%20extension%20no%20longer%20distinguishes%20mspe/mspm/mspr,%20and%20the%20unified%20concept%20is%20extension&color=ff69b4)](https://github.com/moxcomic/majsoul-ex/releases/latest)
[![2](https://img.shields.io/static/v1?label=New%20Extension&message=The%20new%20extension%20standard%20is%20clearer%20and%20more%20intuitive,%20and%20various%20suffixes%20are%20removed,%20and%20the%20extension%20suffix%20name%20is%20zip,%20which%20is%20convenient%20for%20users%20to%20use%20and%20convenient%20for%20developers%20to%20expand%20and%20develop.&color=ff69b4)](https://github.com/moxcomic/majsoul-ex/releases/latest)
[![3](https://img.shields.io/static/v1?label=Faster%20Speed&message=Using%20new%20technology%20for%20development,%20the%20user%20experience%20is%20close%20to%20the%20browser%20and%20the%20loading%20speed%20is%20optimized,%20and%20the%20loading%20speed%20far%20exceeds%20the%20MajSoul%20Plus&color=ff69b4)](https://github.com/moxcomic/majsoul-ex/releases/latest)
[![4](https://img.shields.io/static/v1?label=Better%20Performance&message=Written%20in%20Go%20language%20and%20C,%20it%20far%20surpasses%20the%20Sparrow%20Soul%20Plus%20developed%20by%20Electron%20in%20terms%20of%20operating%20efficiency%20and%20performance.&color=ff69b4)](https://github.com/moxcomic/majsoul-ex/releases/latest)
[![5](<https://img.shields.io/static/v1?label=New%20Kernel&message=The%20new%20external%20browser%20mechanism%20allows%20you%20to%20use%20the%20updated%20Chromium%2090%20kernel%20version%20(Currently,%20the%20Chromium%20kernel%20version%20of%20Majsoul%20Plus%20is%2078)&color=ff69b4>)](https://github.com/moxcomic/majsoul-ex/releases/latest)
[![6](https://img.shields.io/static/v1?label=Less%20lag&message=The%20performance%20of%20software%20written%20in%20Go%20language%20and%20C%20far%20exceeds%20that%20of%20Sparrow%20Soul%20Plus%20written%20in%20Electron,%20which%20can%20effectively%20reduce%20the%20occurrence%20of%20stalls%20and%20bugs.&color=ff69b4)](https://github.com/moxcomic/majsoul-ex/releases/latest)

### New standard for plug-ins

`All content listed below must exist`  
assets folder: Used to store all resource files  
scripts folder: Used to store all JavaScript scripts, all the scripts in this folder  
mainscripts folder: Used to store all JavaScript scripts  
preview.png: Plug-in preview image, `must` be a png image  
manifest.json: Plug-in manifest file, used to identify the plug-in author, version number, etc.

### Plug-in manifest file

The plugin manifest file must be `manifest.json`  
`MajSoul Ex` simplified the list file. Just write the following fields in this file

```JSON
{
    "name": "Plug-in Name",
    "author": "Plug-in Author",
    "version": "Plug-in Version",
    "description": "Plug-in Description"
}
```

All fields are `string` and cannot have other attribute values. For example, `"author": ["foo", "bar"]` is not allowed format, the correct format should be `"author": "foo, bar" `  
`Someone must have asked at this time, so where to declare the resource file? Please see the description below`

### Extended resource file

`MajSoul Ex` automatically reads the `assets` directory and automatically matches the resource files in the same path, so `does not need` in the manifest file to be long...long...long...very long The replace and resourpack field declaration `, `As long as resources are placed in the assets folder, they will be automatically read and recognized`

### Resource matching rules

The resources of the sparrow soul need to be stored strictly in accordance with the path before it will be replaced  
Example: `/1/v.0.8.188.w/extendRes/charactor/yiji/full.png` needs to be stored in the assets directory as `extendRes/charactor/yiji/full.png`  
If you need to adapt `chs_t`, `jp`, `en`, you also need to add it in front, such as replacing the traditional one Ji `chs_t/extendRes/charactor/yiji/full.png`

The resources loaded by the extension author can not be stored in the full path  
Example: The request path sent by `fetch('./foo/bar/yiji.png')` is `/foo/bar/yiji.png` This will match `foo/bar/yiji.png`, `bar /yiji.png`, `yiji.png`  
Whether to store in the full path depends on the extension developer. To prevent conflicts with other plugins, try to store in the full path.

### Majsoul Ex Official

- bilibili: [神崎·H·亚里亚](https://space.bilibili.com/898411/)
- bilibili: [关野萝可](https://space.bilibili.com/612462792/)
- QQ Group: [991568358](https://jq.qq.com/?_wv=1027&k=3gaKRwqg)

### Sponsor this project

Invite the author to have a cup of coffee

<figure class="third">
    <img src="https://moxcomic.github.io/wechat.png" width=170>
    <img src="https://moxcomic.github.io/alipay.png" width=170>
    <img src="https://moxcomic.github.io/qq.png" width=170>
</figure>
