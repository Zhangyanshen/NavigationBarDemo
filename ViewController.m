//
//  ViewController.m
//  NavigationBarDemo
//
//  Created by 张延深 on 2016/11/14.
//  Copyright © 2016年 宜信. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 躲开导航栏上的图片以防被遮挡
    self.tableView.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
    [self initData];
    [self.navigationBar addSubview:self.imageView];
    // [self.navigationController.navigationBar addSubview:self.imageView];
}

- (void)viewWillLayoutSubviews {
    [self.view bringSubviewToFront:self.navigationBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat contentOffsetY = scrollView.contentOffset.y;
    CGFloat scale = 1 - contentOffsetY / 300.0;
    if (scale < 0.5) {
        scale = 0.5;
    } else if (scale > 1.0) {
        scale = 1.0;
    }
    self.imageView.transform = CGAffineTransformMakeScale(scale, scale);
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID forIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor whiteColor];
    vc.title = self.dataArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Setters/Getters

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.bounds = CGRectMake(0, 0, 66, 66);
        _imageView.center = CGPointMake(self.navigationController.navigationBar.center.x, 5+20);
        // 设置锚点
        _imageView.layer.anchorPoint = CGPointMake(0.5, 0);
        _imageView.layer.cornerRadius = 33;
        _imageView.layer.masksToBounds = YES;
        _imageView.image = [UIImage imageNamed:@"222.jpg"];
    }
    return _imageView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark - Private methods

- (void)initData {
    for (int i = 0; i < 30; i ++) {
        NSString *str = [NSString stringWithFormat:@"row:%ld", (long)i + 1];
        [self.dataArray addObject:str];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    // 防止崩溃
    self.tableView.delegate = nil;
}

@end
