//
//  MGBooksListController.m
//  Moonlite
//
//  Created by Admin on 8/5/16.
//  Copyright © 2016 Midgets. All rights reserved.
//

#import "MGBooksListController.h"
#import "MGBookListCell.h"
#import "MGNetworkManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import "Book.h"
#import "CPDFDocumentViewController.h"
#import "FlashLightUtil.h"
#import "SAMHUDView.h"


@interface MGBooksListController () <UISearchBarDelegate, MGBookListCellDelegate>

@property (strong, nonatomic) NSArray *booksArray;
@property (strong, nonatomic) UISearchBar *searchBar;

@end

static NSString *reuseIdentifier = @"bookListCell";

@implementation MGBooksListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"backImage"]];
    self.tableView.backgroundView = backgroundImageView;
    self.tableView.backgroundView.layer.zPosition -= 1;
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self action:@selector(refreshTable:) forControlEvents:UIControlEventValueChanged];
    
    [self refreshTable:self.refreshControl];
    
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
    _searchBar.delegate = self;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.placeholder = @"Search books by name";
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.navigationItem.titleView = _searchBar;
    self.navigationItem.title = @"";
   
    
    UINib *nib = [UINib nibWithNibName:@"MGBookListCell" bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuseIdentifier];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapOnView)];
    tapGesture.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGesture];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (void)handleTapOnView {
    
    [self.searchBar resignFirstResponder];

}

#pragma mark - API

- (void)refreshTable:(UIRefreshControl *) refreshControl {
    
    [self searchBooksWithString:@""];
}

- (void) searchBooksWithString:(NSString *) searchString {
    
    __weak typeof(self) weakSelf = self;
    
    [weakSelf.refreshControl beginRefreshing];
    
    
    self.booksArray = [weakSelf make2DArrayFromArray:[Book MR_findAllSortedBy:@"id_" ascending:YES] withColumnsNumber:3];
    [self.tableView reloadData];
    
    [MGNetworkManager getAllBooksWithCompletion:^(NSArray *array, NSError *error) {
        
        if (array) {
            
            weakSelf.booksArray = [weakSelf make2DArrayFromArray:array withColumnsNumber:3];
            [weakSelf.tableView reloadData];
        }
        
        [weakSelf.refreshControl endRefreshing];
        
    }];
}
#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    

    return [_booksArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MGBookListCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.booksArray = _booksArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        
        return self.tableView.frame.size.height / 2.5f;
    }
    
    return self.tableView.frame.size.height / 2.2f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    MGBooksCollectionController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MGBooksCollectionController"];
//    
//    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private methods

- (NSArray *)make2DArrayFromArray:(NSArray *) array withColumnsNumber:(NSInteger)columns {
    
    NSMutableArray *lBooksArray = [NSMutableArray array];
    
    NSInteger rowsNumbers = ceil(array.count / 3.0);
    
    for (NSInteger i = 0; i < rowsNumbers; i++) {
        
        NSMutableArray *subArray = [NSMutableArray array];
        
        for (NSInteger j = 0;  j < 3; j++) {
            
            if (columns * i + j == [array count]) {
                break;
            }
            
            [subArray addObject:array[columns * i + j]];
        }
        
        [lBooksArray addObject:subArray];
    }
    
    return lBooksArray;
}

#pragma mark - MGBookListCellDelegate

- (void)bookListCellDelegateTappedOnBook:(Book *)book {
    
    if ([book.fileURL hasPrefix:@"http"]) {
        
        SAMHUDView *hd = [[SAMHUDView alloc] initWithTitle:@"Downolading..." loading:YES];
        
        [hd show];
        
        NSURL *fileURL = [NSURL URLWithString:book.fileURL];
        NSURLSession *session = [NSURLSession sharedSession];
        [[session dataTaskWithURL:fileURL completionHandler:^(NSData *data,
                                                              NSURLResponse *response,
                                                              NSError *error)
          {
              if(!error)
              {
                  NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
                  documentsURL = [documentsURL URLByAppendingPathComponent:[response suggestedFilename]];
                  [data writeToURL:documentsURL atomically:YES];

                  book.fileURL = [documentsURL absoluteString];
                  
                  CPDFDocumentViewController *viewer = [self.storyboard instantiateViewControllerWithIdentifier:@"CPDFDocumentViewController"];
                
                  viewer.documentURL = documentsURL;
                  
                  dispatch_async(dispatch_get_main_queue(), ^{
                      [FlashLightUtil turnTorchOn:YES];
                      [self.navigationController pushViewController:viewer animated:NO];
                  });

                  [hd dismiss];
              } else {
                  
                  [hd failQuicklyWithTitle:@"Something went wrong!"];
              }
              
          }] resume];
    } else {

        CPDFDocumentViewController *viewer = [self.storyboard instantiateViewControllerWithIdentifier:@"CPDFDocumentViewController"];
        
        viewer.documentURL = [NSURL URLWithString:book.fileURL];
        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.navigationController presentViewController:viewer animated:YES completion:nil];
              [self.navigationController pushViewController:viewer animated:YES];
              [FlashLightUtil turnTorchOn:YES];
        });
        
    }
 
 
}

@end
