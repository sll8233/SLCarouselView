//
//  ViewController.m
//  SLCardScrollView
//
//  Created by sll on 2020/6/29.
//  Copyright © 2020 SLL. All rights reserved.
//

#import "ViewController.h"
#import "SLCarouselView.h"

#define KScreenWidth self.view.frame.size.width
#define KScreenHeight self.view.frame.size.height

@interface ViewController ()

@property (nonatomic,strong) SLCarouselView *scrollView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _scrollView = [SLCarouselView initWithFrame:CGRectMake(0, 100, KScreenWidth, 150) imageSpacing:10 imageWidth:KScreenWidth - 50];
    _scrollView.initAlpha = 0.5; // 设置两边卡片的透明度
    _scrollView.imageRadius = 10; // 设置卡片圆角
    _scrollView.imageHeightPoor = 10; // 设置中间卡片与两边卡片的高度差
    // 设置要加载的图片
    self.scrollView.data = @[@"http://d.hiphotos.baidu.com/image/pic/item/b7fd5266d016092408d4a5d1dd0735fae7cd3402.jpg",@"http://a.hiphotos.baidu.com/image/pic/item/b7fd5266d01609240bcda2d1dd0735fae7cd340b.jpg",@"http://h.hiphotos.baidu.com/image/pic/item/0d338744ebf81a4c5e4fed03de2a6059242da6fe.jpg",@"https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLt4cd7BYyu8fmCP1EicOOImt591KmjicaOztJA7xgllTHo6MGOJicKv4S4eCXgdoHjHvjM8yt9SxzhA/132",@"https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLt4cd7BYyu8fmCP1EicOOImt591KmjicaOztJA7xgllTHo6MGOJicKv4S4eCXgdoHjHvjM8yt9SxzhA/132",@"https://wx.qlogo.cn/mmopen/vi_32/Q0j4TwGTfTLt4cd7BYyu8fmCP1EicOOImt591KmjicaOztJA7xgllTHo6MGOJicKv4S4eCXgdoHjHvjM8yt9SxzhA/132"];
    _scrollView.placeHolderImage = [UIImage imageNamed:@""]; // 设置占位图片
    [self.view addSubview:self.scrollView];
    _scrollView.describeArray = @[@"123",@"12x",@"345",@"xxxa",@"dwa1"];
    _scrollView.clickImageBlock = ^(NSInteger currentIndex) { // 点击中间图片的回调
        NSLog(@"%ld",(long)currentIndex);
    };
}


@end
