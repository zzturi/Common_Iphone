//
//  ProductTextCell.m
//  groupbuy
//
//  Created by qqn_pipi on 11-7-23.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "ProductTextCell.h"
#import "Product.h"
#import "LocationService.h"
#import "Product.h"
#import "ProductManager.h"
#import "TimeUtils.h"
#import "GroupBuyNetworkConstants.h"
#import "PPApplication.h"
#import "Reachability.h"
#import "NSAttributedString+Attributes.h"
#import "NumberUtil.h"
#import "FontUtils.h"


@implementation ProductTextCell

@synthesize imageView;
@synthesize productDescLabel;
@synthesize valueLabel;
@synthesize priceLabel;
@synthesize rebateLabel;
@synthesize leftTimeLabel;
@synthesize distanceLabel;
@synthesize boughtLabel;
@synthesize siteNameLabel;



// just replace PPTableViewCell by the new Cell Class Name
+ (PPTableViewCell<CommonProductTextCell>*)createCell:(id)delegate
{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"ProductTextCell" 
                                                             owner:self options:nil];
    // Grab a pointer to the first object (presumably the custom cell, as that's all the XIB should contain).  
    if (topLevelObjects == nil || [topLevelObjects count] <= 0){
        NSLog(@"create <ProductTextCell> but cannot find cell object from Nib");
        return nil;
    }
    
    ((ProductTextCell*)[topLevelObjects objectAtIndex:0]).delegate = delegate;
    
    return (ProductTextCell*)[topLevelObjects objectAtIndex:0];
}

- (void)setCellStyle
{
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.leftTimeLabel.hidden = YES;
    self.valueLabel.hidden = YES;
//    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}

+ (NSString*)getCellIdentifier
{
    return @"ProductTextCell";
}

+ (CGFloat)getCellHeight
{
    return 116.0f;
}

+ (BOOL)needReloadVisiableCellTimer
{
    return NO;
}

- (NSString*)getTimeInfo:(int)seconds
{
    if (seconds <=0 ){
        return @"已结束";
    }
    else if (seconds < 60){
        return [NSString stringWithFormat:@"还有%d秒", seconds];
    }
    else if (seconds < 60*60){
        return [NSString stringWithFormat:@"还有%d分钟", seconds/60];        
    }
    else if (seconds < 60*60*24){
        return [NSString stringWithFormat:@"还有%d小时", seconds/(60*60)];        
    }
    else{
        return [NSString stringWithFormat:@"还有%d天", seconds/(60*60*24)];                
    }
}

- (NSString*)getBoughtInfo:(NSNumber*)bought
{
    return [bought description];
//    if (bought < 1000){
//        return [NSString stringWithFormat:@"%@", bought];
//    }
//    else if (bought < 10000){
//        return [NSString stringWithFormat:@"%@千", bought];        
//    }
//    else{
//        return [NSString stringWithFormat:@"%@万", bought];
//    }
}

- (NSString *)getDistance:(double)distance
{
    NSString *distanceString = nil;
    if(distance < 1000){
        int d = (int) distance;
        distanceString = [NSString stringWithFormat:@"%d米",d];
    }else if (distance < 1000*1000){
        float d = distance/1000;
        distanceString = [NSString stringWithFormat:@"%0.1f公里",d];
    }
    else{
        float d = distance/(1000*1000);
        distanceString = [NSString stringWithFormat:@"%0.1f千公里",d];        
    }
    return distanceString;
}

- (NSString*)getValue:(NSNumber*)value
{
    if ([value doubleValue] == -1){
        return @"0";
    }
    else{
        return [value description];
    }
}

- (NSString*)getRebateString:(NSNumber*)rebate
{
    int intValue = [rebate integerValue];
    int decimalValue = getDecimal([rebate floatValue]);
    
    if (decimalValue == 0){
        return [NSString stringWithFormat:@"%d", intValue];
    }
    else{
        return [NSString stringWithFormat:@"%d.%d", intValue, decimalValue];
    }
}

- (void)setCellInfoWithProductInfo:(NSDate*)endDate
                          siteName:(NSString*)siteName
                             title:(NSString*)title
                             value:(NSNumber*)value
                             price:(NSNumber*)price
                            bought:(NSNumber*)bought
                            rebate:(NSNumber*)rebate
                          distance:(double)distance
                               image:(NSString*)image

{
    int leftSeconds = [endDate timeIntervalSinceNow];
    NSString* timeInfo = [self getTimeInfo:leftSeconds];
    
    UIColor* textColor = [UIColor colorWithRed:111/255.0 green:104/255.0 blue:94/255.0 alpha:1.0];
    UIColor* textColor2 = [UIColor colorWithRed:183/255.0 green:177/255.0 blue:169/255.0 alpha:1.0];
    
    productDescLabel.textColor = textColor;
    priceLabel.textColor = [UIColor colorWithRed:245/255.0 green:109/255.0 blue:42/255.0 alpha:1.0];
    siteNameLabel.textColor = textColor;
    rebateLabel.textColor = textColor2;
    distanceLabel.textColor = textColor2;
    boughtLabel.textColor = textColor2;
    
    
    self.productDescLabel.text = [NSString stringWithFormat:@"%@ - %@", siteName, title];    
    self.valueLabel.text = [NSString stringWithFormat:@"原价: %@元", [self getValue:value]];        
    
    NSInteger priceInteger = [price integerValue];
    NSInteger priceDecimal = getDecimal([price floatValue]);
    NSString* priceText = nil;
    if (priceDecimal == 0) {
        priceText = [NSString stringWithFormat:@"%d元", priceInteger];
    }else{
        priceText = [NSString stringWithFormat:@"%d.%d元", priceInteger,priceDecimal];
    }

    NSMutableAttributedString* attrStr = [NSMutableAttributedString attributedStringWithString:priceText];

    [attrStr setFont:[FontUtils HeitiSC:24]];
	[attrStr setTextColor:[UIColor colorWithRed:245/255.0 green:109/255.0 blue:42/255.0 alpha:1.0f]];    
	[attrStr setTextColor:[UIColor colorWithRed:111/255.0f green:104/255.0f blue:94/255.0f alpha:1.f] range:[priceText rangeOfString:@"元"]];
	[attrStr setFont:[FontUtils HeitiSC:12] range:[priceText rangeOfString:@"元"]];
        
    if (priceDecimal != 0) {
        NSString *text = [NSString stringWithFormat:@".%d",priceDecimal];
        [attrStr setFont:[FontUtils HeitiSC:18] range:[priceText rangeOfString:text]];
    }
    self.priceLabel.attributedText = attrStr;
    self.priceLabel.backgroundColor = [UIColor clearColor];
    
    
    self.leftTimeLabel.text = [NSString stringWithFormat:@"时间: %@", timeInfo];
    
    if (distance > 0.0f && distance < MAXFLOAT){
        NSString *distanceStr = [self getDistance:distance];    
        self.distanceLabel.text = [NSString stringWithFormat:@"距离: %@",distanceStr];
    }
    else{
        self.distanceLabel.text = @"";         
    }
    
    self.siteNameLabel.text = siteName;
    self.boughtLabel.text = [NSString stringWithFormat:@"售出: %@", [self getBoughtInfo:bought]]; 
    
    if ([price isEqualToNumber:value]){
        self.rebateLabel.text = @"";
    }
    else{
        self.rebateLabel.text = [NSString stringWithFormat:@"折扣: %@折", [self getRebateString:rebate]]; 
    }
    
//    NSLog(@"rebate=%f, rebate=%@", [rebate doubleValue], [rebate description]);
    
//    if ([[Reachability reachabilityForInternetConnection] currentReachabilityStatus] == ReachableViaWiFi){
        self.imageView.hidden = NO;
        self.imageView.callbackOnSetImage = self;
        [self.imageView clear];
        self.imageView.url = [NSURL URLWithString:image];
        [GlobalGetImageCache() manage:self.imageView];
        
        
        self.productDescLabel.hidden = NO;        
//    }
//    else{
//        self.imageView.hidden = YES;
//        self.productDescLabel.hidden = NO;        
//    }
}

#define MIN_HEIGHT 70

- (void) managedImageSet:(HJManagedImageV*)mi
{
    CGRect textFrame = CGRectMake(5, 3, 200, 106);     // default , need to align with Cell.xib
    CGRect imageFrame = textFrame;
//    CGSize actualImageSize = mi.image.size;
    if (mi.image.size.height < MIN_HEIGHT){    
        CGRect frame = mi.frame;
        frame.size.width = mi.image.size.width;
        frame.size.height = mi.image.size.height;
        imageView.imageView.frame = frame;
        self.imageView.frame = frame;
                
        textFrame.size.height = textFrame.size.height - mi.frame.size.height;
        textFrame.origin.y = mi.frame.origin.y + mi.frame.size.height + 3;
        self.productDescLabel.frame = textFrame;
        self.productDescLabel.numberOfLines = 2;
    }
    else{    
        self.imageView.frame = imageFrame;
        
        self.productDescLabel.text = @"";
        self.productDescLabel.frame = textFrame;
        self.productDescLabel.numberOfLines = 6;    // need to align with cell xib
    }
}

- (void) managedImageCancelled:(HJManagedImageV*)mi
{
}

- (void)setCellInfoWithProductDictionary:(NSDictionary*)product indexPath:(NSIndexPath*)indexPath
{
    NSDate* endDate = dateFromUTCStringByFormat([product objectForKey:PARA_END_DATE], DEFAULT_DATE_FORMAT);
    NSString* siteName = [product objectForKey:PARA_SITE_NAME];
    NSString* title = [product objectForKey:PARA_TITLE];
    NSNumber* value = [product objectForKey:PARA_VALUE];
    NSNumber* price = [product objectForKey:PARA_PRICE];
    NSNumber* bought = [product objectForKey:PARA_BOUGHT];
    NSNumber* rebate = [product objectForKey:PARA_REBATE];    
    NSString* image = [product objectForKey:PARA_IMAGE];
    
    LocationService *locationService = GlobalGetLocationService();
    CLLocation *location = [locationService currentLocation];
    
    double distance = [ProductManager calcShortestDistance:[ProductManager gpsArray:[product objectForKey:PARA_GPS]]
                                           currentLocation:location];
    
    [self setCellInfoWithProductInfo:endDate siteName:siteName title:title value:value price:price bought:bought rebate:rebate distance:distance image:image];
}


- (void)setCellInfoWithProduct:(Product*)product indexPath:(NSIndexPath*)indexPath
{
    LocationService *locationService = GlobalGetLocationService();
    CLLocation *location = [locationService currentLocation];

    double distance = [ProductManager calcShortestDistance:[product gpsArray] currentLocation:location];
    
    [self setCellInfoWithProductInfo:product.endDate siteName:product.siteName title:product.title value:product.value price:product.price bought:product.bought rebate:product.rebate distance:distance image:product.image];
}

- (void)dealloc {
    
    [productDescLabel release];
    [valueLabel release];
    [priceLabel release];
    [rebateLabel release];
    [leftTimeLabel release];
    [distanceLabel release];
    [boughtLabel release];
    [imageView release];
    [siteNameLabel release];
    [super dealloc];
}

@end

