//
//  AdProductTextCell.h
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PPTableViewCell.h"
#import "HJManagedImageV.h"
#import "OHAttributedLabel.h"
#import "CommonProductTextCell.h"

@class Product;
@class ActionHandler;

@interface AdProductTextCell : PPTableViewCell <HJManagedImageVDelegate, CommonProductTextCell> {
    
    IBOutlet UILabel *siteNameLabel;
    UILabel *productDescLabel;
    UILabel *valueLabel;
    OHAttributedLabel *priceLabel;
    UILabel *rebateLabel;
    UILabel *leftTimeLabel;
    UILabel *distanceLabel;
    UILabel *boughtLabel;
    HJManagedImageV *imageView;
    Product *_product;
    ActionHandler *_handler;
}

@property (nonatomic, retain) IBOutlet HJManagedImageV *imageView;
@property (nonatomic, retain) Product *product;

+ (PPTableViewCell<CommonProductTextCell>*)createCell:(id)delegate;
+ (NSString*)getCellIdentifier;
+ (CGFloat)getCellHeight;
+ (BOOL)needReloadVisiableCellTimer;
- (IBAction)clickSave:(id)sender;
- (IBAction)clickForward:(id)sender;

- (void)setCellInfoWithProduct:(Product*)product indexPath:(NSIndexPath*)indexPath;
- (void)setCellInfoWithProductDictionary:(NSDictionary*)product indexPath:(NSIndexPath*)indexPath;
@property (retain, nonatomic) IBOutlet UILabel *offsetLabel;

@property (nonatomic, retain) IBOutlet UILabel *productDescLabel;
@property (nonatomic, retain) IBOutlet UILabel *valueLabel;
@property (nonatomic, retain) IBOutlet OHAttributedLabel *priceLabel;
@property (nonatomic, retain) IBOutlet UILabel *rebateLabel;
@property (nonatomic, retain) IBOutlet UILabel *leftTimeLabel;
@property (nonatomic, retain) IBOutlet UILabel *distanceLabel;
@property (nonatomic, retain) IBOutlet UILabel *boughtLabel;
@property (nonatomic, retain) IBOutlet UILabel *siteNameLabel;
@property (nonatomic, retain, getter = actionHander, setter = setActionHandler:) ActionHandler *actionHandler;


@end

