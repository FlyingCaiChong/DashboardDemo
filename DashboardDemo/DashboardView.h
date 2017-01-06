//
//  DashboardView.h
//  DashboardDemo
//
//  Created by AXAET_APPLE on 17/1/6.
//  Copyright © 2017年 axaet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DashboardView : UIView

/*
 * 环形宽度
 */
@property (nonatomic, assign) CGFloat ringWidth;

/*
 * 刻度线长度
 */
@property (nonatomic, assign) CGFloat dialLength;

/*
 * 每一个扇形块的刻度个数
 */
@property (nonatomic, assign) NSInteger dialPieceCount;

/*
 * 指针视图
 */
@property (nonatomic, strong) UIImageView *pointerView;

/*
 * 显示信息的label
 */
@property (nonatomic, strong) UILabel *infoLabel;


@end
