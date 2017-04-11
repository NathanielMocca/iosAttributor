//
//  ViewController.h
//  week5_attributor
//
//  Created by Mocca Yang on 2017/4/11.
//  Copyright © 2017年 Mocca Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText;

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;

@end

