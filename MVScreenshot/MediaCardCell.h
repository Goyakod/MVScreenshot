//
//  MediaCardCell.h
//  MVScreenshot
//
//  Created by pro on 16/2/27.
//  Copyright © 2016年 vickyTest. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MediaCard.h"

@interface MediaCardCell : UITableViewCell

@property (nonatomic,strong) UIImageView *reviewImageView;

@property (nonatomic,strong) UILabel *nameLabel;

- (void)setCardData:(MediaCard *)card;

@end
