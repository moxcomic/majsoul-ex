# 关于雀魂Ex
`雀魂Ex`是由`神崎·H·亚里亚`个人兴趣爱好所编写的`第三方移动平台(iOS/Android)雀魂客户端`, 并且支持加载`雀魂Plus`的扩展包。`雀魂Ex`双端开发均由`一人`完成所以后续更新及维护并不会那么及时, 此项目完全出于兴趣爱好所写, 并且非开源项目, 后续维护看情况`(至少保证能用)`。

# 免责声明
在您使用`雀魂Ex`进行游戏时造成的`包含但不局限于限制登录、封号等`后果`均由用户自行承担`, `雀魂Ex`不对此承担任何责任!

# 开发进度
- iOS: `3.1.6 正式版`  
- Android: `1.0.0 正式版`

# 开发语言
- iOS: `Swift & Objective-C`  
- Android: `Kotlin & Java`

# 下载地址
- 最新发布版本: [点我进入最新版本页面](https://github.com/moxcomic/majsoul-ex/releases/tag/iOS%2FAndroid)  
- 安卓版本下载: [点我下载最新安卓版本](https://github.com/moxcomic/majsoul-ex/releases/download/iOS%2FAndroid/majsoulex_android_1.0.0.apk)  
- iOS版本下载: [点我下载最新iOS版本](https://github.com/moxcomic/majsoul-ex/releases/download/iOS%2FAndroid/majsoulex_ios_3.1.6.ipa)

# 制作扩展
`待更新...`

# 制作扩展源
1. Github IO Pages
2. 主体文件 src.ex
3. 参考 [src.ex](https://moxcomic.github.io/src.ex)文件编写
    - 点击后会下载到本地
    - 下载完成后使用文本方式打开

## src.ex文件字段解释
- info -> 源的介绍部分
    - id: String -> 用于识别源的ID
    - name: String -> 源的名称, 用于显示在源列表上的名称
    - author: String -> 作者名
    - description: String -> 源的介绍
    - icon: String -> 源的图标, 用于显示在源列表上的图标
        - 可以是http地址
        - 如果只指定名称则默认指向src文件所在的仓库目录下同名文件
- release -> 源的扩展部分
    - id: String -> 用于识别插件的ID
    - name: String -> 插件的名称
    - description: String -> 插件的简介
    - author: String -> 插件作者
    - version: String -> 插件版本
    - preview: String -> 插件的图标
        - 可以是http地址
        - 如果只指定名称则默认指向homepage所在的仓库目录下同名文件
    - homepage: String -> 插件所在的仓库git地址
        - 必须以.git结尾的链接
    - update: [Key: Value] -> 暂时未使用
        - time: String -> 暂时未使用
        - message: String -> 暂时未使用
    - source: [Key: Value] -> 用于指定插件下载方式, 如不指定默认archive模式下载
        - type: String -> 插件下载模式
            - archive -> 下载git仓库下对应version的tag包(zip包)
            - release -> 下载git仓库手动发布版本的file文件
            - http -> 下载指定地址的http文件
            - raw -> 下载仓库下的指定file
        - tag: String -> 用于release下载模式指定tag
        - file: String -> 用于release/http/raw下载模式指定下载文件名

## 插件仓库存放
按照正常Git仓库方式存储即可, 只需将`.git`的地址填入`src.ex`中`release`里对应的`homepage`字段即可识别。

# 联系方式
- B站ID: [神崎·H·亚里亚](https://space.bilibili.com/898411/)  
- B站ID: [关野萝可](https://space.bilibili.com/612462792/)
- QQ交流群: [991568358](https://jq.qq.com/?_wv=1027&k=3gaKRwqg)
- Twitter: @MajsoulEx

# 赞助
如果对您有所帮助，欢迎您的赞赏
![](https://gitee.com/moxcomic/majsoul-ex/raw/master/wechat.JPG)
![](https://gitee.com/moxcomic/majsoul-ex/raw/master/alipay.JPG)
![](https://gitee.com/moxcomic/majsoul-ex/raw/master/qq.JPG)