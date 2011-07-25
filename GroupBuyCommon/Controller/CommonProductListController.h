//
//  CommonProductListController.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewController.h"
#import "ProductService.h"

@class CommonProductListController;

@protocol ProductDataLoader <NSObject>

- (NSArray*)requestProductListFromDB;
- (void)requestProductListFromServer:(BOOL)isRequestLastest controller:(CommonProductListController*)controller;

- (BOOL)supportRemote;

@end

@interface CommonProductListController : PPTableViewController <ProductServiceDelegate> {
    
    UIViewController                *superController;
    NSObject<ProductDataLoader>     *dataLoader;
}

@property (nonatomic, retain) UIViewController                *superController;
@property (nonatomic, retain) NSObject<ProductDataLoader>     *dataLoader;

@end
