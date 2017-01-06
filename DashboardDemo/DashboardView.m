//
//  DashboardView.m
//  DashboardDemo
//
//  Created by AXAET_APPLE on 17/1/6.
//  Copyright © 2017年 axaet. All rights reserved.
//

#import "DashboardView.h"

static CGFloat kDefaultRingWidth = 10;
static CGFloat kDefaultDialLength = 10;
static CGFloat kDefaultDialPieceCount = 5;

@interface DashboardView()
{
    CGPoint _center; // 中心点
    CGFloat _radius; // 外环半径
    NSInteger _dialCount; // 刻度线的个数
}
@end

@implementation DashboardView

- (CGFloat)ringWidth {
    return _ringWidth ? _ringWidth : kDefaultRingWidth;
}

- (CGFloat)dialLength {
    return _dialLength ? _dialLength : kDefaultDialLength;
}

- (NSInteger)dialPieceCount {
    return _dialPieceCount ? _dialPieceCount : kDefaultDialPieceCount;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }

    _center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    _radius = self.bounds.size.width / 2 - self.ringWidth / 2;
    _dialCount = 6 * self.dialPieceCount;

    // 添加外环
    [self addCircleLayer];
    [self addSubview:self.pointerView];
    [self addSubview:self.infoLabel];

    return self;
}

- (void)addCircleLayer {
    CGFloat startAngle = M_PI_2 + (M_PI / 4); // 开始角度
    CGFloat endAngle = M_PI * 2 + (M_PI / 4); // 结束角度
    BOOL clockwise = YES; // 顺时针

    CALayer *containerLayer = [CALayer layer];

    // 环形Layer层
    CAShapeLayer *circleLayer = [CAShapeLayer layer];
    circleLayer.lineWidth = self.ringWidth;
    circleLayer.lineCap = kCALineCapRound;
    circleLayer.lineJoin = kCALineJoinRound;
    circleLayer.fillColor = [UIColor clearColor].CGColor;
    circleLayer.strokeColor = [UIColor whiteColor].CGColor;
    circleLayer.shadowColor = [UIColor yellowColor].CGColor; // 阴影颜色
    circleLayer.shadowOffset = CGSizeMake(1, 1); // 阴影偏移量
    circleLayer.shadowOpacity = 0.5; // 阴影透明度
    circleLayer.shadowRadius = 5;
    // path
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:_center radius:_radius startAngle:startAngle endAngle:endAngle clockwise:clockwise];
    circleLayer.path = circlePath.CGPath;

    [containerLayer addSublayer:circleLayer];

    for (int i = 0; i <= _dialCount; i++) {
        [self containerLayer:containerLayer addDialWithIndex:i]; // 添加刻度
    }
    [self.layer addSublayer:containerLayer];

    // 渐变层
    CALayer *gradientLayer = [CALayer new];// 渐变层的组合
    // 生成左边渐变色
    CAGradientLayer *leftLayer = [CAGradientLayer layer];
    leftLayer.frame = CGRectMake(0, 0, self.bounds.size.width/2, self.bounds.size.height);
    leftLayer.colors = @[(id)[UIColor yellowColor].CGColor, (id)[UIColor greenColor].CGColor];
    [gradientLayer addSublayer:leftLayer];
    // 生成右边渐变色
    CAGradientLayer *rightLayer = [CAGradientLayer layer];
    rightLayer.frame = CGRectMake(self.bounds.size.width / 2, 0, self.bounds.size.width / 2, self.bounds.size.height);
    rightLayer.colors = @[(id)[UIColor yellowColor].CGColor, (id)[UIColor redColor].CGColor];
    [gradientLayer addSublayer:rightLayer];
    // 添加遮罩层
    [gradientLayer setMask:containerLayer];
    [self.layer addSublayer:gradientLayer];
}

- (void)containerLayer:(CALayer *)containerLayer addDialWithIndex:(NSInteger)index {
    CAShapeLayer *dialItemLayer = [CAShapeLayer layer]; // 刻度层
    dialItemLayer.lineWidth = 1;
    dialItemLayer.lineCap = kCALineCapSquare;
    dialItemLayer.lineJoin = kCALineJoinRound;
    dialItemLayer.strokeColor = [UIColor greenColor].CGColor;
    dialItemLayer.fillColor = [UIColor clearColor].CGColor;

    // path
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat outsideRadius = _radius - self.ringWidth / 2; // 刻度 外点半径
    CGFloat insideRadius = outsideRadius - self.dialLength; // 刻度 内点半径

    if (index % self.dialPieceCount == 0) {
        dialItemLayer.strokeColor = [UIColor redColor].CGColor;
        insideRadius -= 5;
    }

    CGFloat angle = M_PI_2 + M_PI / 4 - index * (M_PI_2 + M_PI/4) *2 / _dialCount;// 角度
    CGPoint insidePoint = CGPointMake(_center.x - (insideRadius * sin(angle)), _center.y - (insideRadius * cos(angle)));// 刻度内点
    CGPoint outsidePoint = CGPointMake(_center.x - (outsideRadius * sin(angle)), _center.y - (outsideRadius * cos(angle)));// 刻度外点

    [path moveToPoint:insidePoint];
    [path addLineToPoint:outsidePoint];

    dialItemLayer.path = path.CGPath;
    [containerLayer addSublayer:dialItemLayer];
}

// 绘制文字
- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 1.0);
    CGContextSetRGBFillColor(context, 0.5, 0.5, 0.5, 0.5);
    UIFont *font = [UIFont boldSystemFontOfSize:15.0];
    UIColor *foregroundColor = [UIColor whiteColor];
    NSDictionary *attributes = @{NSFontAttributeName: font, NSForegroundColorAttributeName: foregroundColor};

    CGFloat outsideRadius = _radius - self.ringWidth/2;// 刻度外点半径
    CGFloat insideRadius = outsideRadius - self.dialLength; // 刻度内点半径

    // 需要显示的文字数组
    NSArray *textArr = @[@"0", @"400", @"800", @"1200", @"1600", @"2000", @"2400"];

    // 计算所得各个文字显示的位置相对于其insidePoint的偏移量,
    NSArray *xOffsetArr = @[@(5), @(7), @(5), @(-16), @(-40), @(-46), @(-30)];
    NSArray *yOffsetArr = @[@(-20), @(-10), @(0), @(5), @(0), @(-10), @(-20)];

    for (int i = 0; i < textArr.count; i++) {
        CGFloat angle =  M_PI_2 + M_PI / 4 - 5 * i * (M_PI_2 + M_PI/4) *2 / _dialCount;
        CGPoint insidePoint = CGPointMake(_center.x - (insideRadius * sin(angle)), _center.y - (insideRadius * cos(angle)));
        CGFloat xOffset = [xOffsetArr[i] floatValue];
        CGFloat yOffset = [yOffsetArr[i] floatValue];
        CGRect rect = CGRectMake(insidePoint.x + xOffset, insidePoint.y + yOffset, 60, 20);
        NSString *text = textArr[i];
        [text drawInRect:rect withAttributes:attributes];
    }
}


#pragma mark - PointerView
- (UIImageView *)pointerView {
    if (!_pointerView) {
        _pointerView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pointerV2.png"]];
        _pointerView.frame =  CGRectMake(_center.x - 10, _center.y - self.bounds.size.width/6, 20, self.bounds.size.width/3);
        _pointerView.contentMode = UIViewContentModeScaleAspectFit;
        _pointerView.layer.anchorPoint = CGPointMake(0.5f, 0.9f); // 锚点
        _pointerView.transform = CGAffineTransformMakeRotation(-(M_PI/2 + M_PI_4));
    }
    return _pointerView;
}

#pragma mark - InfoLabe;
- (UILabel *)infoLabel {
    if (!_infoLabel) {
        _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(_center.x - 50, _center.y + 53, 100, 30)];
        _infoLabel.font = [UIFont boldSystemFontOfSize:17];
        _infoLabel.textColor = [UIColor whiteColor];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.text = @"0";
    }
    return _infoLabel;
}

@end
