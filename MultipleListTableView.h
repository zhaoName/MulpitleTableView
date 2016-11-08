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
@property (nonatomic, assign) BOOL isNeedTapCell;/**<是否给tableViewCell添加点击事件*/

@property (nonatomic, strong) NSArray<UIView *> *cellViewArray;/**<第三级列表*/
@property (nonatomic, strong) UIColor *tableViewColor;/**< tableView的背景色*/
@property (nonatomic, strong) NSIndexPath *openOrCloseIndexPath;

@property (nonatomic, strong) MJRefreshHeader *zMJHeader; /**< 下拉刷新*/
@property (nonatomic, strong) MJRefreshFooter *zMJFooter; /**< 上拉加载*/

@property (nonatomic, strong) UITableView *tableView;

/**
 *  初始化自定义的mlTabelView
 *  @param frame 坐标
 *  @param style 样式
 */
- (instancetype)initWithFrame:(CGRect)frame andTableViewStyle:(UITableViewStyle)style;
/** 更新MultipleListTableView的frame是，也要同步更新其上子控件tableView的frame*/
- (void)refreshTableViewFrame:(CGRect)selfFrame;

/** 上拉刷新*/
- (void)addNormalRefreshHeader:(EmanMJRefreshHeader)refreshHeader;
/** 下拉加载*/
- (void)addNormalRefreshFooter:(EmanMJRefreshFooter)efreshFooter;

/**
 *  cell的重用机制
 *  @param identifier 重用标志符
 */
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier;
- (id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath;
- (id)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier;

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
/** 三级列表的个数*/
- (NSInteger)mlTableView:(MultipleListTableView *)mlTabelView numberOfCellViewInRow:(NSInteger)row;
- (NSInteger)mlTableView:(MultipleListTableView *)mlTabelView numberOfRowsInSection:(NSInteger)section;
- (UITableViewCell *)mlTableView:(MultipleListTableView *)mlTabelView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@optional
- (NSInteger)numberOfSectionInMlTableView:(MultipleListTableView *)mlTableView;
- (NSString *)mlTableView:(MultipleListTableView *)mlTabelView titleForHeaderInSection:(NSInteger)section;
- (NSString *)mlTableView:(MultipleListTableView *)mlTabelView titleForFooterInSection:(NSInteger)section;

@end