//
//  ViewController.m
//  MulpitleTableView
//
//  Created by zhao on 16/7/7.
//  Copyright © 2016年 zhao. All rights reserved.
//

#import "ViewController.h"
#import "MultipleListTableView.h"

@interface ViewController ()<MultipleListTableViewDelegate, MultipleListTableViewDataSource>

@property (nonatomic, strong) NSMutableArray *dataArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    MultipleListTableView *mlTableView = [[MultipleListTableView alloc] initWithFrame:[UIScreen mainScreen].bounds andTableViewStyle:UITableViewStyleGrouped];
    
    mlTableView.delegate = self;
    mlTableView.dataSource = self;
    
    mlTableView.isNeedTapHeader = NO;
    mlTableView.isNeedTapCell = YES;
    
    UIView *view1 = [[UIView alloc] init];
    view1.backgroundColor = [UIColor greenColor];
    UIView *view2 = [[UIView alloc] init];
    view2.backgroundColor = [UIColor blueColor];
    mlTableView.cellViewArray = @[view1, view2];
    
    [self.view addSubview: mlTableView];
}

#pragma mark -- MultipleListTableViewDelegate

- (CGFloat)mlTableView:(MultipleListTableView *)mlTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 35;
}

//三级列表的高度
- (CGFloat)mlTableView:(MultipleListTableView *)mlTableView heightForViewInCellAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (CGFloat)mlTableView:(MultipleListTableView *)mlTableView heightForHeaderInSection:(NSInteger)section
{
    return 30.f;
}

- (CGFloat)mlTableView:(MultipleListTableView *)mlTableView heightForFooterInSection:(NSInteger)section
{
    return 0.1f;
}

- (void)mlTableView:(MultipleListTableView *)mlTabelView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"点击了第%lu个section的第%lu个row", indexPath.section, indexPath.row);
}

#pragma mark -- MultipleListTableViewDataSource

- (NSInteger)numberOfSectionInMlTableView:(MultipleListTableView *)mlTableView
{
    return self.dataArray.count;
}

- (NSInteger)mlTableView:(MultipleListTableView *)mlTabelView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArray[section] count];
}

//三级列表的个数
- (NSInteger)mlTableView:(MultipleListTableView *)mlTabelView numberOfCellViewInRow:(NSInteger)row
{
    return 2;
}

- (UITableViewCell *)mlTableView:(MultipleListTableView *)mlTabelView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [mlTabelView dequeueReusableHeaderFooterViewWithIdentifier:@"mlTabelView"];
    if(cell ==  nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"mlTabelView"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.backgroundColor = [UIColor lightGrayColor];
    if(indexPath.row%2 == 0)
    {
        cell.backgroundColor = [UIColor redColor];
    }
    return cell;
}

- (UIView *)mlTableView:(MultipleListTableView *)mlTableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30)];
    
    view.tag = section;
    view.backgroundColor = [UIColor colorWithRed:74/255.0 green:133/255.0 blue:189/255.0 alpha:1];
    view.userInteractionEnabled = YES;
    
    view.layer.borderWidth = 1.0;
    view.layer.borderColor = [UIColor purpleColor].CGColor;
    
    return view;
}


#pragma mark -- setter getter

- (NSMutableArray *)dataArray
{
    if(!_dataArray)
    {
        _dataArray = [[NSMutableArray alloc] initWithArray:@[@[@"1", @"2", @"3"], @[@"1",@"2"], @[@"1",@"2",@"3",@"4"]]];
    }
    return _dataArray;
}

@end
