//
//  ViewController.m
//  AppleStoreTopApplications
//
//  Created by HsuKit on 2021/6/1.
//

#import "ViewController.h"
#import "recommendScrollView.h"
#import "recommendAppModel.h"
#import "recommendViewModel.h"
#import "topFreeViewModel.h"
#import "TopFreeAppCell.h"
#import "SearchResultViewController.h"
@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UISearchResultsUpdating,UISearchBarDelegate>
@property(nonatomic,strong)UITableView *myTableView;
@property(nonatomic,strong)NSArray *recommendAppInfoArray;
@property(nonatomic,strong)NSMutableArray *topFreeAppInfoArray;
@property(nonatomic,strong)SearchResultViewController *resultVC;
@property(nonatomic,strong)NSMutableArray  *searchList;
@property(nonatomic, strong)UISearchController *searchController;
@end

@implementation ViewController
-(NSMutableArray *)searchList
{
    if (!_searchList) {
        _searchList = [[NSMutableArray alloc]init];
    }
    return _searchList;
}
-(NSMutableArray *)topFreeAppInfoArray
{
    if (!_topFreeAppInfoArray) {
        _topFreeAppInfoArray = [[NSMutableArray alloc]init];
    }
    return _topFreeAppInfoArray;
}
-(UITableView *)myTableView
{
    if (!_myTableView) {
        _myTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kStatusHight, kScreenWidth, kScreenHeight - kStatusHight - kSafeBottomHeight) style:UITableViewStyleGrouped];
        
        _myTableView.showsVerticalScrollIndicator = NO;
        _myTableView.showsHorizontalScrollIndicator = NO;
        _myTableView.delegate = self;
        _myTableView.dataSource = self;
    }
    return _myTableView;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    self.resultVC = [[SearchResultViewController alloc] init];
    [self.view addSubview:self.myTableView];
    [self setupSearchVC];
}
-(void)setupSearchVC{
    
    //搜索之后的结果就显示在当前这个控制器上
    _searchController = [[UISearchController alloc] initWithSearchResultsController:self.resultVC];
    
    //搜索时，背景变暗色
    _searchController.dimsBackgroundDuringPresentation = NO;
    //隐藏导航栏
    _searchController.hidesNavigationBarDuringPresentation = NO;
    
    _searchController.searchBar.frame = CGRectMake(self.searchController.searchBar.frame.origin.x, self.searchController.searchBar.frame.origin.y, self.searchController.searchBar.frame.size.width, 44.0);
    self.myTableView.tableHeaderView = self.searchController.searchBar;
    
    _searchController.searchResultsUpdater = self;
    _searchController.searchBar.delegate = self;
    
}
#pragma mark - Table view data source

-(void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController{
    NSString *searchString = [self.searchController.searchBar text];
    
    if (self.searchList != nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    self.searchList= [[DataBaseTool sharedDataBaseTool] searchTopFreeAppWithKeyWord:searchString];
    
    //刷新表格
    SearchResultViewController *searchResultsViewController = (SearchResultViewController *)self.searchController.searchResultsController;
    searchResultsViewController.searchDataArray = [NSMutableArray arrayWithArray:self.searchList];
    [searchResultsViewController.tableView reloadData];
}

#pragma mark - UISearchBar的代理方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder]; // 丢弃第一使用者
}
#pragma mark - 实现键盘上Search按钮的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self.searchController dismissViewControllerAnimated:YES completion:^{
        [self setupSearchVC];
    }];
    
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    for (id cencelButton in [searchBar.subviews[0] subviews])
    {
        if([cencelButton isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)cencelButton;
            [btn setTitle:@"取消"  forState:UIControlStateNormal];
        }
    }
    
}
- (void)getData
{
    dispatch_group_t group =  dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    topFreeViewModel *tpfVm = [[topFreeViewModel alloc]init];
    tpfVm.page = 1;
    recommendViewModel *recVm = [[recommendViewModel alloc]init];
    NSMutableArray *topFreeArray = [[DataBaseTool sharedDataBaseTool] getAllTopFreeCache];
    NSMutableArray *recommendArray = [[DataBaseTool sharedDataBaseTool] getAllRecommendCache];
    if (topFreeArray.count != 0) {
        self.topFreeAppInfoArray = topFreeArray;
        tpfVm.appInfoArrays = topFreeArray;
        [self.myTableView reloadData];
    }else{
        dispatch_group_async(group, queue, ^{
            
            [tpfVm getDataWithMode:RequestModeRefresh completionHandler:^(NSError * _Nonnull error) {
                self.topFreeAppInfoArray = tpfVm.appInfoArrays;
                [self.myTableView reloadData];
            }];
        });
    }
    
    if (recommendArray.count != 0) {
        self.recommendAppInfoArray = recommendArray;
        [self.myTableView reloadData];
    }else{
        dispatch_group_async(group, queue, ^{
            
            [recVm getDataWithMode:RequestModeRefresh completionHandler:^(NSError * _Nonnull error) {
                self.recommendAppInfoArray = recVm.appInfoArrays;
                [self.myTableView reloadData];
            }];
        });
    }
    __weak __typeof__(self) weakSelf = self;
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [tpfVm getDataWithMode:RequestModeRefresh completionHandler:^(NSError * _Nonnull error) {
            weakSelf.topFreeAppInfoArray = tpfVm.appInfoArrays;
            [weakSelf.myTableView.mj_header endRefreshing];
            [weakSelf.myTableView reloadData];
        }];
    }];
    self.myTableView.mj_header = header;
    
    MJRefreshAutoStateFooter *footer = [MJRefreshAutoStateFooter footerWithRefreshingBlock:^{
        
        tpfVm.page++;
        [tpfVm getDataWithMode:RequestModeMore completionHandler:^(NSError * _Nonnull error) {
            weakSelf.topFreeAppInfoArray = tpfVm.appInfoArrays;
            [weakSelf.myTableView.mj_footer endRefreshing];
            [weakSelf.myTableView reloadData];
        }];
    }];
    self.myTableView.mj_footer = footer;
}
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.topFreeAppInfoArray.count;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    recommendScrollView *rs = [[recommendScrollView alloc]init];
    rs.contentArray = self.recommendAppInfoArray;
    return rs;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (kScreenWidth - 60) / 3.5 + 83;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"cell";
    
    TopFreeAppCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        
        cell = [[TopFreeAppCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    cell.model = self.topFreeAppInfoArray[indexPath.row];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
@end
