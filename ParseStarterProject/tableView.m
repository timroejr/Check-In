//
//  tableView.m
//  Check-In
//
//  Created by Timothy Roe Jr. on 11/5/15.
//
//

#import "tableView.h"

@implementation tableView

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.parseClassName = @"hcParseData";
        self.pullToRefreshEnabled = YES;
        self.paginationEnabled = NO;
        self.objectsPerPage = 300;
        self.student = @"";
    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated {
    
}

-(void)viewDidLoad {
    [super viewDidLoad];


}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(PFQuery *)queryForTable {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query whereKey:@"checkIn" notEqualTo:@"YES"];
    [query whereKey:@"studentName" hasPrefix:self.student];
    [query orderByAscending:@"studentName"];
    return query;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath object:(PFObject *)object
{
    static NSString *idCell = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idCell];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idCell];
    }
    
    cell.textLabel.text = [object objectForKey:@"studentName"];

    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Check-In" message:[NSString stringWithFormat:@"Are you sure you want to Check-In %@", cell.textLabel.text] delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [alert show];
    PFObject *object = [self.objects objectAtIndex:indexPath.row];
    self.objID = [object objectId];
    
    
}

-(void)checkInUser {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query getObjectInBackgroundWithId:self.objID block:^(PFObject *object, NSError *error) {
        object[@"checkIn"] = @"YES";
        NSLog(@"Checked In Student");
        [object saveInBackground];
        [self loadObjects];
    }];
    [self checkInData];
}

-(void)checkInData {
    PFQuery *query = [PFQuery queryWithClassName:self.parseClassName];
    [query getObjectInBackgroundWithId:self.objID block:^(PFObject *object, NSError *error) {
        NSString *personData = object[@"studentName"];
        NSString *tableInfoData = object[@"tableNumber"];
        NSLog(@"Table Data: %@", tableInfoData);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Checked In!" message:[NSString stringWithFormat:@"%@ was Checked In. Table Number: %@", personData, tableInfoData] delegate:self cancelButtonTitle:@"Awesome!" otherButtonTitles:nil, nil];
        [alert show];
    }];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.objects.count;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == [alertView cancelButtonIndex]) {
        //Canceled
    } else {
        [self checkInUser];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    self.student = searchText;
    if (self.student.length>0) {
        [self loadObjects];
    }
}

@end
