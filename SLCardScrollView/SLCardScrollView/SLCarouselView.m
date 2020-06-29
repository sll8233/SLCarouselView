//
//  SLCarouselView.m
//  SLCardScrollView
//
//  Created by sll on 2020/6/29.
//  Copyright © 2020 SLL. All rights reserved.
//

#import "SLCarouselView.h"
#import "UIView+CardScroll.h"
#import "UIImageView+WebCache.h"
#define SLMainScrollWidth self.mainScrollView.frame.size.width
#define SLMainScrollHeight self.mainScrollView.frame.size.height
@interface SLCarouselView()
@property (nonatomic,strong) UIPageControl *pageControl;
@property (nonatomic,strong) UIScrollView *mainScrollView;
@property (nonatomic,strong) UIImageView *leftIV;
@property (nonatomic,strong) UIImageView *centerIV;
@property (nonatomic,strong) UIImageView *rightIV;
@property (nonatomic,strong) UILabel *showLabel;
@property (nonatomic,assign) NSUInteger currentImageIndex;
@property (nonatomic,assign) CGFloat imgWidth;//图片宽度
@property (nonatomic,assign) CGFloat itemMargnPadding;//间距 2张图片间的间距  默认0
@property (nonatomic,assign) NSInteger imgCount;//数量
@property (nonatomic,weak) NSTimer *timer;

@end


@implementation SLCarouselView
-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.imgWidth = SLMainScrollWidth;
        [self initialization];
        [self setUpUI];
    }
    return self;
}
+(instancetype)initWithFrame:(CGRect)frame
                imageSpacing:(CGFloat)imageSpacing
                  imageWidth:(CGFloat)imageWidth {
    SLCarouselView *scrollView = [[self alloc] initWithFrame:frame];
    scrollView.imgWidth = imageWidth;
    scrollView.itemMargnPadding = imageSpacing;
    return scrollView;
}


-(void)initialization{
    _initAlpha = 1;
    _autoScrollTimeInterval = 2.0;
    _imageHeightPoor = 0;
    self.otherPageControlColor = [UIColor grayColor];
    self.curPageControlColor = [UIColor whiteColor];
    _showPageControl = YES;
    _showDescribeLabel = YES;
    _hidesForSinglePage = YES;
    _autoScroll = YES;
    self.data = [NSArray array];
    self.describeArray = [NSArray array];
}

-(void)setUpUI{
    [self addSubview:self.mainScrollView];
    //图片视图；左边
    self.leftIV = [[UIImageView alloc] init];
    self.leftIV.contentMode = UIViewContentModeScaleToFill;
    self.leftIV.userInteractionEnabled = YES;
    [self.leftIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftTapGes)]];
    [self.mainScrollView addSubview:self.leftIV];
    
    //图片视图；中间
    self.centerIV = [[UIImageView alloc] init];
    self.centerIV.contentMode = UIViewContentModeScaleToFill;
    self.centerIV.userInteractionEnabled = YES;
    [self.centerIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(centerTapGes)]];
    [self.mainScrollView addSubview:self.centerIV];
    
    //图片视图；右边
    self.rightIV = [[UIImageView alloc] init];
    self.rightIV.contentMode = UIViewContentModeScaleToFill;
    self.rightIV.userInteractionEnabled = YES;
    [self.rightIV addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(rightTapGes)]];
    [self.mainScrollView addSubview:self.rightIV];
    
    [self updateViewFrameSetting];
}
- (void)setImageHeightPoor:(CGFloat)imageHeightPoor {
    _imageHeightPoor = imageHeightPoor;
    [self updateViewFrameSetting];
}

//创建页码指示器
-(void)createPageControl{
    if (_pageControl) [_pageControl removeFromSuperview];
    if (self.data.count == 0) return;
    if ((self.data.count == 1) && self.hidesForSinglePage) return;
    
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((self.frame.size.width - 200)/2, SLMainScrollHeight - 16, 200, 16)];
    _pageControl.userInteractionEnabled = NO;
    _pageControl.currentPage = 0;
    _pageControl.backgroundColor = [UIColor orangeColor];
    _pageControl.numberOfPages = self.data.count;
    [self addSubview:_pageControl];
    _pageControl.pageIndicatorTintColor = self.otherPageControlColor;
    _pageControl.currentPageIndicatorTintColor = self.curPageControlColor;
    
    _pageControl.hidden = !_showPageControl;
}
//创建描述label
-(void)createDescribeLabel{
    if(_showLabel) [_showLabel removeFromSuperview];
    if (self.describeArray.count == 0) return ;
    _showLabel = [[UILabel alloc]initWithFrame:CGRectMake((self.frame.size.width - 200)/2, SLMainScrollHeight - 16-22, 200, 22)];
    _showLabel.font = [UIFont systemFontOfSize:15];
    _showLabel.backgroundColor = [UIColor grayColor];
    _showLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_showLabel];

    _showLabel.hidden = !_showDescribeLabel;
}

#pragma mark - 设置初始尺寸
-(void)updateViewFrameSetting{
    //设置偏移量
    self.mainScrollView.contentSize = CGSizeMake(SLMainScrollWidth * 3, SLMainScrollHeight);
    self.mainScrollView.contentOffset = CGPointMake(SLMainScrollWidth, 0.0);
    //图片视图；左边
    self.leftIV.frame = CGRectMake(self.itemMargnPadding/2, self.imageHeightPoor, self.imgWidth, SLMainScrollHeight-self.imageHeightPoor*2);
    //图片视图；中间
    self.centerIV.frame = CGRectMake(SLMainScrollWidth + self.itemMargnPadding/2, 0.0, self.imgWidth, SLMainScrollHeight);
    //图片视图；右边
    self.rightIV.frame = CGRectMake(SLMainScrollWidth * 2.0 + self.itemMargnPadding/2, self.imageHeightPoor, self.imgWidth, SLMainScrollHeight-self.imageHeightPoor*2);
    
}
- (void)setImageRadius:(CGFloat)imageRadius {
    _imageRadius = imageRadius;
    [self.leftIV addRoundedCornersWithRadius:imageRadius];
    [self.centerIV addRoundedCornersWithRadius:imageRadius];
    [self.rightIV addRoundedCornersWithRadius:imageRadius];
    [self.leftIV addProjectionWithShadowOpacity:0.4];
    [self.centerIV addProjectionWithShadowOpacity:0.4];
    [self.rightIV addProjectionWithShadowOpacity:0.4];
}
- (void)setData:(NSArray *)data {
    if (data.count < _data.count) {
        [_mainScrollView setContentOffset:CGPointMake(SLMainScrollWidth, 0) animated:NO];
    }
    _data = data;
    self.currentImageIndex = 0;
    self.imgCount = data.count;
    self.pageControl.numberOfPages = self.imgCount;
    [self setInfoByCurrentImageIndex:self.currentImageIndex];
    
    if (data.count != 1) {
        self.mainScrollView.scrollEnabled = YES;
        [self setAutoScroll:self.autoScroll];
    } else {
        [self invalidateTimer];
        // SLMainScrollWidth < self.frame.size.width    这样的 说明是 图片有间距 卡片 翻页效果那种布局
        self.mainScrollView.scrollEnabled = SLMainScrollWidth < self.frame.size.width ?YES : NO;
    }
    [self createPageControl];
    
}

-(void)setDescribeArray:(NSArray *)describeArray{
    _describeArray = describeArray;
    [self createDescribeLabel];
    [self reloadLabel:self.currentImageIndex];
}

- (void)setInfoByCurrentImageIndex:(NSUInteger)currentImageIndex {
    if(self.self.imgCount == 0){
        return;
    }
    if([self isHttpString:self.data[currentImageIndex]]){
        [self.centerIV sd_setImageWithURL:[NSURL URLWithString:self.data[currentImageIndex]] placeholderImage:self.placeHolderImage];
    }else {
        self.centerIV.image = self.data[currentImageIndex];
    }
    
    NSInteger leftIndex = (unsigned long)((_currentImageIndex - 1 + self.imgCount) % self.imgCount);
    if([self isHttpString:self.data[leftIndex]]){
        [self.leftIV sd_setImageWithURL:[NSURL URLWithString:self.data[leftIndex]] placeholderImage:self.placeHolderImage];
    }else {
        self.leftIV.image = self.data[leftIndex];
    }
    
    NSInteger rightIndex = (unsigned long)((_currentImageIndex + 1) % self.imgCount);
    if([self isHttpString:self.data[rightIndex]]){
        [self.rightIV sd_setImageWithURL:[NSURL URLWithString:self.data[rightIndex]] placeholderImage:self.placeHolderImage];
    }else {
        self.rightIV.image = self.data[rightIndex];
    }
    
    _pageControl.currentPage = currentImageIndex;
}

- (void)reloadImage {
    // 避免0
    if(self.imgCount == 0) {
        return;
    }
    CGPoint contentOffset = [self.mainScrollView contentOffset];
    if (contentOffset.x > SLMainScrollWidth) { //向左滑动
        _currentImageIndex = (_currentImageIndex + 1) % self.imgCount;
    } else if (contentOffset.x < SLMainScrollWidth) { //向右滑动
        _currentImageIndex = (_currentImageIndex - 1 + self.imgCount) % self.imgCount;
    }
    
    [self setInfoByCurrentImageIndex:_currentImageIndex];
    [self reloadLabel:_currentImageIndex];
}
-(void)reloadLabel:(NSUInteger)currentImageIndex{
    if (self.describeArray.count <= currentImageIndex){
        self.showLabel.text = @"";
        return ;
    }
    
    
    self.showLabel.text = self.describeArray[currentImageIndex];
}

#pragma mark - UIScrollViewDelegate 滚动事件
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.autoScroll) {
        [self invalidateTimer];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self reloadImage];
    [self.mainScrollView setContentOffset:CGPointMake(SLMainScrollWidth, 0) animated:NO] ;
    self.pageControl.currentPage = self.currentImageIndex;
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.autoScroll) {
        [self createTimer];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self scrollViewDidEndDecelerating:scrollView];
}


#pragma mark -- action
-(void)leftTapGes{
    
}

-(void)rightTapGes{
    
}

-(void)centerTapGes{
    if (self.clickImageBlock) {
        self.clickImageBlock(self.currentImageIndex);
    }
}

-(void)createTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:self.autoScrollTimeInterval target:self selector:@selector(automaticScroll) userInfo:nil repeats:YES];
    _timer = timer;
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)invalidateTimer {
    if(_timer){
        [_timer invalidate];
        _timer = nil;
    }
}

- (void)automaticScroll {
    if (0 == _imgCount) return;
    if(self.mainScrollView.scrollEnabled == NO) return;
    [self.mainScrollView setContentOffset:CGPointMake(SLMainScrollWidth*2, 0.0) animated:YES];
}

#pragma mark -- properties
-(void)setItemMargnPadding:(CGFloat)itemMargnPadding {
    _itemMargnPadding = itemMargnPadding;
    self.mainScrollView.frame = CGRectMake((SLMainScrollWidth - (self.imgWidth + itemMargnPadding))/2, 0, self.imgWidth + itemMargnPadding, SLMainScrollHeight);
    [self updateViewFrameSetting];
}

-(void)setCurPageControlColor:(UIColor *)curPageControlColor {
    _curPageControlColor = curPageControlColor;
    _pageControl.currentPageIndicatorTintColor = curPageControlColor;
}

-(void)setOtherPageControlColor:(UIColor *)otherPageControlColor {
    _otherPageControlColor = otherPageControlColor;
    _pageControl.pageIndicatorTintColor = otherPageControlColor;
}

- (void)setAutoScrollTimeInterval:(CGFloat)autoScrollTimeInterval {
    _autoScrollTimeInterval = autoScrollTimeInterval;
    
    [self setAutoScroll:self.autoScroll];
}

-(void)setAutoScroll:(BOOL)autoScroll{
    _autoScroll = autoScroll;
    
    [self invalidateTimer];
    
    if (_autoScroll) {
        [self createTimer];
    }
}

-(void)setPlaceHolderImage:(UIImage *)placeHolderImage {
    _placeHolderImage = placeHolderImage;
    self.centerIV.image = placeHolderImage;
    self.leftIV.image = placeHolderImage;
    self.rightIV.image = placeHolderImage;
}

-(void)setShowPageControl:(BOOL)showPageControl{
    _showPageControl = showPageControl;
    self.pageControl.hidden = !_showPageControl;
}
-(void)setShowDescribeLabel:(BOOL)showDescribeLabel{
    _showDescribeLabel = showDescribeLabel;
    self.showLabel.hidden = !_showDescribeLabel;
}

- (void)setInitAlpha:(CGFloat)initAlpha {
    _initAlpha = initAlpha;
    self.leftIV.alpha = self.initAlpha;
    self.centerIV.alpha = 1;
    self.rightIV.alpha = self.initAlpha;
}

-(UIScrollView *)mainScrollView {
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _mainScrollView.delegate = self;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.clipsToBounds = NO;
        _mainScrollView.showsVerticalScrollIndicator = NO;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
    }
    return _mainScrollView;
}

-(BOOL)isHttpString:(NSString *)urlStr {
    if([urlStr hasPrefix:@"http:"] || [urlStr hasPrefix:@"https:"]){
        return YES;
    }else {
        return NO;
    }
}
#pragma mark - life circles
//当父View释放时，当前视图因为被Timer强引用而不能释放的问题
- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self invalidateTimer];
    }
}
//当timer释放后 回调scrollViewDidScroll时访问野指针导致崩溃
- (void)dealloc {
    _mainScrollView.delegate = nil;
    [self invalidateTimer];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.itemMargnPadding > 0) {
        CGFloat currentX = scrollView.contentOffset.x - SLMainScrollWidth;
        CGFloat bl = currentX/SLMainScrollWidth*(1-self.initAlpha);
        CGFloat variableH = currentX/SLMainScrollWidth*self.imageHeightPoor*2;
        if (currentX > 0) { //左滑
            self.centerIV.alpha = 1 - bl;
            self.rightIV.alpha = self.initAlpha + bl;
            self.centerIV.height = SLMainScrollHeight - variableH;
            self.centerIV.y = currentX/SLMainScrollWidth*self.imageHeightPoor;
            self.rightIV.height = SLMainScrollHeight-2*self.imageHeightPoor+variableH;
            self.rightIV.y = self.imageHeightPoor-currentX/SLMainScrollWidth*self.imageHeightPoor;
        } else if (currentX < 0){  // 右滑
            self.centerIV.alpha = 1 + bl;
            self.leftIV.alpha = self.initAlpha - bl;
            self.centerIV.height = SLMainScrollHeight + variableH;
            self.centerIV.y = -currentX/SLMainScrollWidth*self.imageHeightPoor;
            self.leftIV.height = SLMainScrollHeight-2*self.imageHeightPoor-variableH;
            self.leftIV.y = self.imageHeightPoor+currentX/SLMainScrollWidth*self.imageHeightPoor;
        } else {
            self.leftIV.alpha = self.initAlpha;
            self.centerIV.alpha = 1;
            self.rightIV.alpha = self.initAlpha;
            self.leftIV.height = SLMainScrollHeight-2*self.imageHeightPoor;
            self.centerIV.height = SLMainScrollHeight;
            self.rightIV.height = SLMainScrollHeight-2*self.imageHeightPoor;
            self.leftIV.y = self.imageHeightPoor;
            self.centerIV.y = 0;
            self.rightIV.y = self.imageHeightPoor;
        }
    }
}


@end
