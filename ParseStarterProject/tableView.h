//
//  tableView.h
//  Check-In
//
//  Created by Timothy Roe Jr. on 11/5/15.
//
//

#import <UIKit/UIKit.h>
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

@interface tableView : PFQueryTableViewController <UIAlertViewDelegate, UISearchDisplayDelegate>

@property (nonatomic, strong) NSString *objID;
@property (nonatomic, strong) NSString *student;
@property (nonatomic, strong) NSString *person;
@property (nonatomic, strong) NSString *tableInfo;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UISearchDisplayController *searchController;
@property (nonatomic, strong) NSMutableArray *searchResults;


@end
