# 1.0版本已停止维护
基于Swift编写的WKWebview工程，能基本实现插件载入、替换立绘图片等功能，由于无法实现三方登陆后放弃转向2.0开发; 如果你对此项目感兴趣, 可以下载1.0的源码自行研究, 1.0在被放弃时并未开发完全所以代码并不完善且乱, 仅能够实现大致功能。

# 2.0全新版本
基于逆向实现插件的载入、立绘替换等功能， 由于采用逆向所以大部分的代码是官方进行操作所以可以进行第三方登陆操作; 逆向仅对插件载入、立绘替换做了支持, 并不会涉及您的账号安全问题。
- ✅微博登录支持
- ✅QQ登录支持
- ✅微信登录
- ✅支持「雀魂Plus」插件「mspe」以及mod「mspm」
注意：安装包未签名，请使用「Cydia Impactor」进行安装

# 3.0版本预想
```
由于2.0与1.0均采用NSURLProtocol进行拦截请求实现功能, 这样做的在UIWebview上并无任何问题, 但由于性能原因雀魂选择了性能更高的WKWebview而不是UIWebview, 在WKWebview上本应该是不支持NSURLProtocol的, 于是我在2.0与1.0的工程上均使用了苹果的私有API开启了WKWebview的NSURLProtocol协议, 这样做的后果就是在WKWebview的POST请求中会丢失Body, 这里主要是苹果本就不打算在WKWebview支持NSURLProtocol, 但是强行支持后苹果处于性能第一的原则把Body丢弃了, 所以这个POST的Body丢失一直也是2.0的一个缺点; 虽然这个缺点并不影响整体的使用, 实际上雀魂除了Tencent的bugly之外也并没有任何的POST请求; 不过不妨以后雀魂可能会改变请求方法, 于是就有了3.0的开发预想;

3.0按照预想会使用NetworkExtension进行实现, 不过使用NEKit后签名方式就比较麻烦了, 单纯的使用Cydia Impactor会无法签名; 目前2.0版本如果无重大BUG, 之后只会对官方的最新版本进行更新, 因为采用逆向注入的原因, 每次版本更新也无需修改代码, 也是挺省心的。
```
# Author
Email: moxcomic@gmail.com  
QQ：656469762  
QQ群：61012117  
[大佬辛苦, 犒赏一下](https://github.com/moxcomic/majsoul-x#赞助)🤕

# ScreenShot
![image](https://github.com/moxcomic/majsoul-x/blob/master/IMG_2677.PNG)
![image](https://github.com/moxcomic/majsoul-x/blob/master/IMG_2678.PNG)

# 赞助
![image](https://github.com/moxcomic/majsoul-x/blob/master/alipay.JPG)
![image](https://github.com/moxcomic/majsoul-x/blob/master/wechatpay.JPG)
