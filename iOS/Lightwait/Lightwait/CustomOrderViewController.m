//
//  CustomOrderViewController.m
//  Lightwait
//
//  Created by Patrick Leopard II on 3/9/14.
//  Copyright (c) 2014 Patrick Leopard II. All rights reserved.
//

#import "CustomOrderViewController.h"

@interface CustomOrderViewController ()

@end

@implementation CustomOrderViewController

#pragma mark - View Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSString *jsonString = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"custommenu" ofType:@"json"]
                                                     encoding:NSUTF8StringEncoding
                                                        error:nil];
    NSDictionary *menuDictionary = [JSONConverter convertJSONToNSDictionary:jsonString];
    
    // Hard-coded menu data
    headerArray = [[NSArray alloc] initWithObjects:@"Meat", @"Bread", @"Cheese", @"Toppings", @"Sauce", @"Fries", nil];
    meatArray = [menuDictionary objectForKey:@"Meat"];
    breadArray = [menuDictionary objectForKey:@"Bread"];
    cheeseArray = [menuDictionary objectForKey:@"Cheese"];
    toppingsArray = [menuDictionary objectForKey:@"Toppings"];
    sauceArray = [menuDictionary objectForKey:@"Sauce"];
    friesArray = [menuDictionary objectForKey:@"Fries"];
    menuDataArray = [[NSArray alloc] initWithObjects:meatArray, breadArray, cheeseArray, toppingsArray, sauceArray, friesArray, nil];
    selectedToppings = [[NSMutableArray alloc] init];
    
    // Set the properties of the page indicator
    self.pageIndicator.numberOfPages=[headerArray count];
    self.pageIndicator.currentPage=0;
    self.pageIndicator.enabled=NO;

    [self initializeOrderDictionary];
    [self createPagingScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIScrollView Delegate

- (void)createPagingScrollView
{
    // Creates a table page for each menu category
    for (int i = 0; i < [headerArray count]; i++)
    {
        //Creates a new frame that will contain the table
        CGRect frame;
        
        // Sets the origin location of each page by multiplying the width by the number of frames
        frame.origin.x = self.scrollView.frame.size.width * i;
        
        // Sets the size of each page to be the size of the scroll view
        frame.size = self.scrollView.frame.size;
        
        // Creates a new tableView and sets the delegate and data souce to self
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag=i;
        
        // If the table is the toppings table, allow multiple selections
        if (i == [headerArray indexOfObject:@"Toppings"]) {
            tableView.allowsMultipleSelection=TRUE;
        }
        
        // Sets the view of each page and background color
        [self.scrollView addSubview:tableView];
        
        // Reload the table data
        [tableView reloadData];
    }
    
    // Enables horizontal scrolling
    self.scrollView.pagingEnabled = YES;
    
    // Makes the contentSize as wide as the number of pages * the width of the screen, with height of the view
    self.scrollView.contentSize =  CGSizeMake(self.scrollView.frame.size.width * [headerArray count], self.scrollView.frame.size.height);
    
    // Hides the horizontal scroll bar
    self.scrollView.showsHorizontalScrollIndicator = FALSE;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // Calculate the page number the user scrolled to
    CGFloat pageWidth = scrollView.frame.size.width;
    CGFloat contentOffset = self.scrollView.contentOffset.x;
    int currentPageNumber = floor((contentOffset - pageWidth / 2) / pageWidth) + 1;
    
    // Set the indicator
    self.pageIndicator.currentPage=currentPageNumber;
    
    [self updateRightButton];
}

- (void)scrollToNextPage
{
    CGFloat contentOffset = self.scrollView.contentOffset.x;
    
    // Calculate the location of the next page
    int nextPage = (int)(contentOffset/self.scrollView.frame.size.width) + 1;
    
    // Scroll the page to the right
    [self.scrollView scrollRectToVisible:CGRectMake(nextPage*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    
    // Increment the indicator
    self.pageIndicator.currentPage +=1;
}

- (void)scrollToPreviousPage
{
    CGFloat contentOffset = self.scrollView.contentOffset.x;
    
    // Calculate the location of the previous page
    int prevPage = (int)(contentOffset/self.scrollView.frame.size.width) - 1;
    
    // Scroll the page to the left
    [self.scrollView scrollRectToVisible:CGRectMake(prevPage*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    
    // Decrement the indicator
    self.pageIndicator.currentPage -=1;
}

- (void)scrollToPage:(int)pageNumber
{
    // Scroll to the page number
    [self.scrollView scrollRectToVisible:CGRectMake(pageNumber*self.scrollView.frame.size.width, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height) animated:YES];
    
    // Set the indicator
    self.pageIndicator.currentPage = pageNumber;
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Each table has one section
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Retrieve the table tag and then set the number of rows
    // to the count of items in the array
    return [[menuDataArray objectAtIndex:tableView.tag] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Initialize each cell
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    // Use the table's tag to retrieve the index of the array within menuDataArray, then set the
    // cell's title to be the object at the index of the table's row
    cell.textLabel.text = [[menuDataArray objectAtIndex:tableView.tag] objectAtIndex:[indexPath row]];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [headerArray objectAtIndex:tableView.tag];
}

#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If not selecting from the toppings page, only one selection allowed
    if (tableView.allowsMultipleSelection == FALSE) {
        // Add the selected item as the object and the type of item for the key
        [orderDictionary setObject:[[menuDataArray objectAtIndex:tableView.tag] objectAtIndex:[indexPath row]] forKey:[headerArray objectAtIndex:tableView.tag]];
        [self scrollToNextPage];
    }
    else {
        // Add the toppings to an array and add it to the order dictionary
        [selectedToppings addObject:[[menuDataArray objectAtIndex:tableView.tag] objectAtIndex:[indexPath row]]];
        [orderDictionary setObject:selectedToppings forKey:[headerArray objectAtIndex:tableView.tag]];
    }
    
    [self updateRightButton];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // If deselecting from the toppings page
    if (tableView.allowsMultipleSelection == TRUE) {
        // Remove the deselected item from the toppings array
        [selectedToppings removeObject:[[menuDataArray objectAtIndex:tableView.tag] objectAtIndex:[indexPath row]]];
        
        // Re-add the updated array to the dictionary
        [orderDictionary setObject:selectedToppings forKey:[headerArray objectAtIndex:tableView.tag]];
    }
}

#pragma mark - Buttons

- (IBAction)pushLeftButton:(id)sender
{
    // Scroll to the previous page and then set the right button label
    [self scrollToPreviousPage];
    [self updateRightButton];
}

- (IBAction)pushRightButton:(id)sender
{
    // If the user is on the last page and selected all required items
    if (self.pageIndicator.currentPage == 5 && [self checkForCompleteOrder]) {
        [self showAlert:@"Order" message:[JSONConverter convertNSMutableDictionaryToJSON:orderDictionary]];
        NSLog(@"%@", [JSONConverter convertNSMutableDictionaryToJSON:orderDictionary]);
    }
    else {
        // Scroll to the previous page and then set the right button label
        [self scrollToNextPage];
        [self updateRightButton];
    }
}

- (void)updateRightButton
{
    // Check to see if the user is on the last page - TRUE when selecting fries
    // Update the next button to equal done if true or next if false
    if (self.pageIndicator.currentPage == 5) {
        self.rightButton.title = @"Done";
    }
    else {
        self.rightButton.title = @"Next";
    }
}

#pragma mark - Miscellaneous

- (void)initializeOrderDictionary
{
    // Initialize order dictionary
    orderDictionary = [[NSMutableDictionary alloc] init];
    
    // Set values that can be none to none so that the user does not have to
    // should they not want a particular item
    // Set meat and bread to null so that they can later be checked if they
    // were selected or not
    [orderDictionary setObject:[NSNull null] forKey:@"Meat"];
    [orderDictionary setObject:[NSNull null] forKey:@"Bread"];
    [orderDictionary setObject:@"None" forKey:@"Cheese"];
    [orderDictionary setObject:@"None" forKey:@"Toppings"];
    [orderDictionary setObject:@"None" forKey:@"Sauce"];
    [orderDictionary setObject:@"No Fries" forKey:@"Fries"];
}

- (BOOL)checkForCompleteOrder
{
    // Check if either meat or bread are null
    // If either are true, alert the user and then scroll to that page
    // Otherwise, the order is complete
    if ([[orderDictionary objectForKey:@"Meat"] isEqual: [NSNull null]]) {
        [self showAlert:@"Alert" message:@"Please select a type of meat"];
        [self scrollToPage:[headerArray indexOfObject:@"Meat"]];
        return FALSE;
    }
    else if ([[orderDictionary objectForKey:@"Bread"] isEqual: [NSNull null]]) {
        [self showAlert:@"Alert" message:@"Please select a type of bread"];
        [self scrollToPage:[headerArray indexOfObject:@"Bread"]];
        return FALSE;
    }
    else {
        return TRUE;
    }
}

- (void)showAlert:(NSString *)title message:(NSString *)messageString
{
    // Show an alert on the screen
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:messageString delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil, nil];
    [alertView show];
}

@end