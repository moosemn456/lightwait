//
//  CustomOrderViewController.h
//  Lightwait
//
//  Created by Patrick Leopard II on 3/9/14.
//  Copyright (c) 2014 Patrick Leopard II. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSONConverter.h"
#import "SavedOrdersManager.h"
#import "REST_API.h"

@interface CustomOrderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
{
    NSArray *headerArray;
    NSArray *baseArray;
    NSArray *breadArray;
    NSArray *cheeseArray;
    NSArray *toppingsArray;
    NSArray *sauceArray;
    NSArray *friesArray;
    NSArray *menuDataArray;
    NSMutableArray *selectedToppings;
    NSMutableDictionary *orderDictionary;
}

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightButton;
@property (weak, nonatomic) IBOutlet UIPageControl *pageIndicator;

- (IBAction)pushLeftButton:(id)sender;
- (IBAction)pushRightButton:(id)sender;

@end
