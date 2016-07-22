//
//  MultipleListTableView.h
//  MulpitleTableView
//
//  Created by zhao on 16/7/7.
//  Copyright © 2016年 zhao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@protocol MultipleListTableViewDelegate,MultipleListTableViewDataSource;
typedef void(^EmanMJRefreshHeader)(void);
typedef void(^EmanMJRefreshFooter)(void);

@interface MultipleListTableView : UIView <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) id <MultipleListTableViewDelegate> delegate;
@property (nonatomic, strong) id <MultipleListTableViewDataSource> dataSource;

@property (nonatomic, assign) BOOL isNeedTapHeader; /**<是否给tableViewHeader添加点击事件*/
//@property (nonatomic, assign) BOOL isNeedTapCell;/**<是否给tableViewCell添加点击事件*/

@property (nonatomic, strong) UIView *cellView;/**<第三级列表*/
@property (nonatomic, strong) UIColor *tableViewColor;/**< tableView的背景色*/
@property (nonatomic, strong) NSIndexPath *openOrCloseIndexPath;

/**
 *  初始化自定义的mlTabelView
 *  @param frame 坐标
 *  @param style 样式
 */
- (instancetype)initWithFrame:(CGRect)frame andTableViewStyle:(UITableViewStyle)style;

/**
 *  上拉刷新  下拉加载
 */
- (void)addNormalRefreshHeader:(EmanMJRefreshHeader) refreshHeader;
- (void)addNormalRefreshFooter:(EmanMJRefreshFooter) refreshFooter;

//开始刷新
- (void)beginHeaderRefresh;
- (void)beginFooterRefresh;

//结束刷新
- (void)endHeaderRefresh;
- (void)endFooterRefresh;

/**
 *  cell的重用机制
 *  @param identifier 重用标志符
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (id)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier;

/** 获取指定位置的cell*/
- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath;
/** 刷新数据*/
- (void)mlTableViewReload;

@end




/** delegate*/
@protocol MultipleListTableViewDelegate <NSObject>

@required
- (UIView *)mlTableView:(MultipleListTableView *)mlTableView viewForHeaderInSection:(NSInteger)section;

@optional
/** 三级列表的高度*/
- (CGFloat)mlTableView:(MultipleListTableView *)mlTableView heightForViewInCellAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)mlTableView:(MultipleListTableView *)mlTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (CGFloat)mlTableView:(MultipleListTableView *)mlTableView heightForHeaderInSection:(NSInteger)section;
- (CGFloat)mlTableView:(MultipleListTableView *)mlTableView heightForFooterInSection:(NSInteger)section;

- (UIView *)mlTableView:(MultipleListTableView *)mlTableView viewForFooterInSection:(NSInteger)section;

- (void)mlTableView:(MultipleListTableView *)mlTabelView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end






/** dataSource*/
@protocol MultipleListTableViewDataSource <NSObject>

@required
- (NSInteger)mlTableView:(MultipleListTableView *)mlTabelView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)mlTableView:(MultipleListTableView *)mlTabelView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)numberOfSectionInMlTableView:(MultipleListTableView *)mlTableView;
- (NSString *)mlTableView:(MultipleListTableView *)mlTabelView titleForHeaderInSection:(NSInteger)section;
- (NSString *)mlTableView:(MultipleListTableView *)mlTabelView titleForFooterInSection:(NSInteger)section;

@end