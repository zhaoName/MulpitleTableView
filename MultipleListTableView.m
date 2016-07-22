//
//  MultipleListTableView.m
//  MulpitleTableView
//
//  Created by zhao on 16/7/7.
//  Copyright © 2016年 zhao. All rights reserved.
//

#import "MultipleListTableView.h"


@interface MultipleListTableView ()

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation MultipleListTableView

- (instancetype)initWithFrame:(CGRect)frame andTableViewStyle:(UITableViewStyle)style
{
    if([super initWithFrame:frame])
    {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:style];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView.backgroundColor = [UIColor clearColor];
       
        [self addSubview:self.tableView];
        
        self.isNeedTapHeader = NO;
        self.openOrCloseIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.tableView.backgroundColor = self.tableViewColor;
}

#pragma mark -- MJRefresh

- (void)addNormalRefreshHeader:(EmanMJRefreshHeader)refreshHeader
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        refreshHeader();
    }];
}

- (void)addNormalRefreshFooter:(EmanMJRefreshFooter)refreshFooter
{
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        refreshFooter();
    }];
}

//开始上拉刷新
- (void)beginHeaderRefresh
{
    [self.tableView.mj_header beginRefreshing];
}

//开始下拉加载
- (void)beginFooterRefresh
{
    [self.tableView.mj_header beginRefreshing];
}

//结束下拉刷新
- (void)endHeaderRefresh
{
    [self.tableView.mj_header endRefreshing];
}

//结束上拉加载
- (void)endFooterRefresh
{
    [self.tableView.mj_footer endRefreshing];
}

#pragma mark -- 重用机制

- (UITableViewCell *)dequeueReusableCellWithIdentifier:(NSString *)identifier
{
    return [self.tableView dequeueReusableCellWithIdentifier:identifier];
}

-(id)dequeueReusableCellWithIdentifier:(NSString *)identifier forIndexPath:(NSIndexPath *)indexPath
{
    return [self.tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
}

- (id)dequeueReusableHeaderFooterViewWithIdentifier:(NSString *)identifier
{
    return [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
}

- (UITableViewCell *)cellAtIndexPath:(NSIndexPath *)indexPath
{
   return [self.tableView cellForRowAtIndexPath:indexPath];
}

- (void)mlTableViewReload
{
    self.openOrCloseIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    [self.tableView reloadData];
}

#pragma mark -- 给header或cell添加手势 移除手势

/**
 *  为视图添加手势
 *
 *  @param view 视图
 */
- (void)addGuetureWithView:(UIView *)view action:(SEL)action
{
    if(view)
    {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:action];
        
        [view addGestureRecognizer:tap];
    }
}

/**
 *  为视图移除手势
 *
 *  @param view 视图
 */
- (void)removeGestureFromView:(UIView *)view
{
    if(view)
    {
        for(UIGestureRecognizer *gesture in view.gestureRecognizers)
        {
            if([gesture.view isEqual:view])
            {
                [view removeGestureRecognizer:gesture];
            }
        }
    }
}

#pragma mark -- UITableViewDataSource
//section个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self call_NumberOfSectionInTableView];
}

//row个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //若需要点击header之后才能看见cell 则开始时只显示header
    if(self.isNeedTapHeader && (section != self.openOrCloseIndexPath.section))
    {
        return 0;
    }
    //若需要正常显示TableView 则正常返回row的个数
    return  [self call_NumberOfRowAtSection:section];
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    if([self.dataSource respondsToSelector:@selector(mlTableView:cellForRowAtIndexPath:)])
    {
        cell = [self.dataSource mlTableView:self cellForRowAtIndexPath:indexPath];
    }
    return cell;
}

//cell将要显示
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self addGuetureWithView:cell action:@selector(touchTableViewCellView:)];

    if([indexPath compare:self.openOrCloseIndexPath] == NSOrderedSame)
    {
        CGFloat cellViewHeight = [self call_HeightForCellViewInRow:indexPath];
        CGFloat cellHeight = [self call_HeightForRowAtIndexPath:indexPath];
        
        self.cellView.frame = CGRectMake(0, cellHeight, self.frame.size.width, cellViewHeight);
        [cell addSubview:self.cellView];
        
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeGestureFromView:cell];
    
    if([cell.subviews containsObject:self.cellView])
    {
        [self.cellView removeFromSuperview];
    }
}

//区头的title
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString * headerTitle = nil;
    if([self.dataSource respondsToSelector:@selector(mlTableView:titleForHeaderInSection:)])
    {
        headerTitle = [self.dataSource mlTableView:self titleForHeaderInSection:section];
    }
    return headerTitle;
}

//区尾的title
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    NSString *footerTitle = nil;
    if([self.dataSource respondsToSelector:@selector(mlTableView:titleForFooterInSection:)])
    {
        footerTitle = [self.dataSource mlTableView:self titleForFooterInSection:section];
    }
    return footerTitle;
}

#pragma mark -- UITableViewDelegate

//row的高度 默认44
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat hr = [self call_HeightForRowAtIndexPath:indexPath];
    
    if([indexPath compare:self.openOrCloseIndexPath] == NSOrderedSame)
    {
        CGFloat hc = [self call_HeightForCellViewInRow:indexPath];
        
        hr += hc;
    }
    
    return hr;
}

//区头的高度 默认18
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return [self call_HeightForHeaderInSection:section];
}

//区尾的高度 默认18
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [self call_HeightForFooterInSection:section];
}

//区头view
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = nil;
    if([self.delegate respondsToSelector:@selector(mlTableView:viewForHeaderInSection:)])
    {
        headerView = [self.delegate mlTableView:self viewForHeaderInSection:section];
    }
    //若需要 则添加点击事件
    if(self.isNeedTapHeader)
    {
        [self addGuetureWithView:headerView action:@selector(touchTableViewHeaderView:)];
    }
    return headerView;
}

//区尾view
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *footerView = nil;
    if([self.delegate respondsToSelector:@selector(mlTableView:viewForFooterInSection:)])
    {
        footerView  = [self.delegate mlTableView:self viewForFooterInSection:section];
    }
    return footerView;
}

#pragma mark -- 响应事件
/**
 *  点击tableViewCell的响应事件
 */
- (void)touchTableViewCellView:(UITapGestureRecognizer *)tap
{
    UITableViewCell * cell = (UITableViewCell *)tap.view;
    //点击cell的位置
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    //判断点击的区域  只有点击到cell才会响应事件
    CGFloat heightRow = [self call_HeightForRowAtIndexPath:indexPath];
    CGRect cellRect = CGRectMake(0, 0, cell.bounds.size.width, heightRow);
    
    //点击的位置
    CGPoint point = [tap locationInView:cell];
    if(CGRectContainsPoint(cellRect, point))
    {
        [self openOrCloseTableViewCellAtIndexPath:indexPath];
    }
    
    //触发didSelect事件
    if([self.delegate respondsToSelector:@selector(mlTableView:didSelectRowAtIndexPath:)])
    {
        [self.delegate mlTableView:self didSelectRowAtIndexPath:indexPath];
    }
}

/**
 *  点击tableViewHeader的响应事件
 */
- (void)touchTableViewHeaderView:(UITapGestureRecognizer *)tap
{
    UIView *headerView = tap.view;
    NSInteger section = headerView.tag;
    
    [self openOrCloseTableViewHeaderWithSection:section];
}

#pragma mark -- 点击cell显示或关闭cellView

/**
 *  点击cell显示或关闭cellView
 *
 *  @param indexPath 所点击的cell所在的indexPath
 */
- (void)openOrCloseTableViewCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *reloadIndexPaths = [NSMutableArray array];
    
    //第一次点击 cell未展开
    if(self.openOrCloseIndexPath.row <= -1)
    {
        reloadIndexPaths = [self InsertTableViewCellAtIndexPath:indexPath];
    }
    else
    {
        if([indexPath compare:self.openOrCloseIndexPath] == NSOrderedSame)//两次点击的是都一个cell
        {
            reloadIndexPaths = [self deleteTableViewCellAtIndexPath:self.openOrCloseIndexPath];
        }
        else//两次点击的不是同一个cell
        {
            [reloadIndexPaths addObjectsFromArray:[self deleteTableViewCellAtIndexPath:self.openOrCloseIndexPath]];
            [reloadIndexPaths addObjectsFromArray:[self InsertTableViewCellAtIndexPath:indexPath]];
        }
    }
    //更新特定row
    [self.tableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationFade];
}

/**
 *  点击创建三级列表
 *
 *  @param row 三级列表所在的indexPath
 */
- (NSMutableArray *)InsertTableViewCellAtIndexPath:(NSIndexPath *)indexPath
{
    self.openOrCloseIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section];
    
    return [NSMutableArray arrayWithObject:indexPath];
}

/**
 *  点击删除三级列表
 *
 *  @param row 三级列表所在的row
 */
- (NSMutableArray *)deleteTableViewCellAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath compare:self.openOrCloseIndexPath] == NSOrderedSame)
    {
        self.openOrCloseIndexPath = [NSIndexPath indexPathForRow:-1 inSection:indexPath.section];
    }
    return [NSMutableArray arrayWithObject:indexPath];
}

#pragma mark -- 点击header时展示或关闭cell
/**
 *  点击header时展示或关闭cell
 *
 *  @param section 所点击的header
 */
- (void)openOrCloseTableViewHeaderWithSection:(NSInteger)section
{
    NSMutableArray *insertIndexPaths = [[NSMutableArray alloc] init];
    NSMutableArray *deleteIndexPaths = [[NSMutableArray alloc] init];
    
    //上次点击的header
    NSInteger lastSection = self.openOrCloseIndexPath.section;
    //这次点击的header
    NSInteger newSection = section;
    
    //首次点击header 即header都是关闭状态
    if(lastSection <= -1)
    {
        insertIndexPaths = [self InsertTableViewHeaderWithSection:newSection];
    }
    else //header有一个是打开状态
    {
        if(lastSection == newSection) //两次点击的是同一个header
        {
            //关闭点击的header 并初始化openOrCloseIndexPath
            deleteIndexPaths = [self deleteTabelViewHeaderWithSection:lastSection];
        }
        else //两次点击的不是同一个header
        {
            //关闭上次点击header  展开本次点击的header
            insertIndexPaths = [self InsertTableViewHeaderWithSection:newSection];
            deleteIndexPaths = [self deleteTabelViewHeaderWithSection:lastSection];
        }
    }
    
    [self.tableView beginUpdates];
    if(insertIndexPaths.count)
    {
        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:UITableViewRowAnimationBottom];
    }
    if(deleteIndexPaths.count)
    {
        [self.tableView deleteRowsAtIndexPaths:deleteIndexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
    [self.tableView endUpdates];
    if(insertIndexPaths.count)
    {
        //tableView自动滚动到展开的section的 第一个cell位置
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:newSection] atScrollPosition:UITableViewScrollPositionNone animated:YES];
    }
}

/**
 *  待创建的cell的位置（点击header显示cell）
 */
- (NSMutableArray *)InsertTableViewHeaderWithSection:(NSInteger)section
{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    //记录点击header
    self.openOrCloseIndexPath = [NSIndexPath indexPathForRow:-1 inSection:section];
    
    NSInteger rowNum = [self call_NumberOfRowAtSection:section];
    
    if(rowNum <= 0) return nil;
    
    //获取section的row的个数 且合并成数组
    for(int i=0; i<rowNum; i++)
    {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    
    return indexPaths;
}

/**
 *  待删除cell的位置（点击header隐藏cell）
 */
- (NSMutableArray *)deleteTabelViewHeaderWithSection:(NSInteger)section
{
    NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
    
    //若两次点击是一个header 则初始化openOrCloseIndexPath
    if(section == self.openOrCloseIndexPath.section)
    {
        self.openOrCloseIndexPath = [NSIndexPath indexPathForRow:-1 inSection:-1];
    }
    
    NSInteger rowNum = [self call_NumberOfRowAtSection:section];
    if(rowNum <= 0) return nil;
    
    for(int i=0; i<rowNum; i++)
    {
        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
    }
    return indexPaths;
}


#pragma mark -- call   重复调用减少代码

- (NSInteger)call_NumberOfSectionInTableView
{
    NSInteger ns = 1;
    if([self.dataSource respondsToSelector:@selector(numberOfSectionInMlTableView:)])
    {
        ns = [self.dataSource numberOfSectionInMlTableView:self];
    }
    return ns;
}

- (NSInteger)call_NumberOfRowAtSection:(NSInteger)section
{
    NSInteger nr = 0;
    if([self.dataSource respondsToSelector:@selector(mlTableView:numberOfRowsInSection:)])
    {
        nr = [self.dataSource mlTableView:self numberOfRowsInSection:section];
    }
    return nr;
}

- (CGFloat)call_HeightForHeaderInSection:(NSInteger)section
{
    CGFloat hh = 18;
    if([self.delegate respondsToSelector:@selector(mlTableView:heightForHeaderInSection:)])
    {
        hh = [self.delegate mlTableView:self heightForHeaderInSection:section];
    }
    return hh;
}

- (CGFloat)call_HeightForFooterInSection:(NSInteger)section
{
    CGFloat hf = 18;
    if([self.delegate respondsToSelector:@selector(mlTableView:heightForFooterInSection:)])
    {
        hf = [self.delegate mlTableView:self heightForFooterInSection:section];
    }
    return hf;
}

- (CGFloat)call_HeightForCellViewInRow:(NSIndexPath *)indexPath
{
    CGFloat hv = 0;
    if([self.delegate respondsToSelector:@selector(mlTableView:heightForViewInCellAtIndexPath:)])
    {
        hv = [self.delegate mlTableView:self heightForViewInCellAtIndexPath:indexPath];
    }
    
    return hv;
}

- (CGFloat)call_HeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat hr = 44.0;
    if([self.delegate respondsToSelector:@selector(mlTableView:heightForRowAtIndexPath:)])
    {
        hr = [self.delegate mlTableView:self heightForRowAtIndexPath:indexPath];
    }
    return hr;
}


@end
