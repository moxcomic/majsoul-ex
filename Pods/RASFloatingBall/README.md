RASFloatingBall
===============

[![GitHub issues](https://img.shields.io/badge/platform-iOS%20-red.svg)](https://github.com/air1120/RASFloatingBall)

### 简介
一个轻量级的简单到爆炸的悬浮球（详细使用可参见Demo）

### 功能
- [x] 全局和指定View生效的悬浮球类型
- [x] 自动靠边
- [x] 自动靠边并缩进，自定义缩进状态
- [x] 设置图片内容
- [x] 设置文字内容
- [x] 设置自定义内容
- [x] 点击悬浮球回调
- [ ] 扩展视图，点击弹出（见游戏App中的悬浮球）
- [ ] 旋转适配

### 使用说明
* 导入

		pod 'RASFloatingBall'

* 或者指定版本

		pod 'RASFloatingBall', '1.0.0'

* 初始化
		
		RASFloatingBall *floatingBall = [[RASFloatingBall alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];// 全局作用
		RASFloatingBall *floatingBall = [[RASFloatingBall alloc] initWithFrame:CGRectMake(100, 100, 100, 100) inSpecifiedView:nil UIEdgeInsetsMake(64, 0, 0, 0)];	// 生成全局范围的悬浮球，并且有限制范围
		RASFloatingBall *floatingBall = [[RASFloatingBall alloc] initWithFrame:CGRectMake(100, 100, 100, 100) inSpecifiedView:self.view effectiveEdgeInsets:UIEdgeInsetsMake(64, 0, 0, 0)];	// 生成一个指定 view 生效的悬浮球，并且有限制范围
			
* 显示和隐藏
	
		[floatingBall show];	 	// 显示
		[floatingBall hide];		// 隐藏
			
* 生成后是否自动靠边

		floatingBall.autoCloseEdge = YES;
		
* 更改悬浮球的靠边策略（默认是上下左右都可以靠，默认时候的逻辑是和系统的assistiveTouch相同，接触到底部或顶部一定距离之后靠近上下边缘）

		floatingBall.edgePolicy = RASFloatingBallEdgePolicyLeftRight;
		
* 设置悬浮球显示的内容（内部自动居中）

		// 设置图片 
		[floatingBall setContent:[UIImage imageNamed:@"apple"] contentType:RASFloatingBallContentTypeImage];
		
		// 设置文字
		[floatingBall setContent:@"我是文字" contentType:RASFloatingBallContentTypeText];
		
* 如果想要添加一个自定义的视图到悬浮球中

		// 设置一个自定义的视图
		RASCustomButton *button = [[RASCustomButton alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
		button.titleLabel.textAlignment = NSTextAlignmentCenter;
		button.imageSize = CGSizeMake(44, 44);
		button.titleLabel.font = [UIFont systemFontOfSize:16.0f];
		button.backgroundColor = [UIColor redColor];

		[button setImage:[UIImage imageNamed:@"apple"] forState:UIControlStateNormal];
		[button setTitle:@"一个图片" forState:UIControlStateNormal];

		// 设置自定义视图
		[floatingBall setContent:button contentType:RASFloatingBallContentTypeCustomView];
		
* 当在autoCloseEdge为YES的时候，设置一段间隔后自动缩进边缘

		// 缩进的主要参数
		UIKIT_STATIC_INLINE RASEdgeRetractConfig RASEdgeOffsetConfigMake(CGPoint edgeRetractOffset, CGFloat edgeRetractAlpha) {
 		   RASEdgeRetractConfig config = {edgeRetractOffset, edgeRetractAlpha};
    	   return config;
		}
		
		// 设置缩进
		// 缩进时候如果靠的是左右边缘则x缩进20，如果上下则y缩进30，并且缩进后悬浮球透明度渐变为0.7f
		[floatingBall autoEdgeRetractDuration:3.0f edgeRetractConfigHander:^RASEdgeRetractConfig{
			return RASEdgeOffsetConfigMake(CGPointMake(20, 30), 0.7f);
		}];
		
* 悬浮球的点击

    	globallyBall.clickHandler = ^(RASFloatingBall * _Nonnull floatingBall) {
			[floatingBall disVisible];
	    };
    	    
	    // 或者设置代理，在实现代理方法，获取点击事件
	    - (void)didClickFloatingBall:(RASFloatingBall *)floatingBall {
	    	// 悬浮球点击
	    }
	    
### 系统要求
最低支持 `iOS 8.0` 和 `Xcode 8.0`。


