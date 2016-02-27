//
//  MediaCardCell.m
//  MVScreenshot
//
//  Created by pro on 16/2/27.
//  Copyright © 2016年 vickyTest. All rights reserved.
//

#import "MediaCardCell.h"

@implementation MediaCardCell

- (void)awakeFromNib {
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.frame = CGRectMake(0, 0, 250, 150);
        
        self.reviewImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 230, 100)];
        self.reviewImageView.image = [UIImage imageNamed:@"monkey.jpg"];
        self.reviewImageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:self.reviewImageView];
        
        self.nameLabel = [[UILabel alloc] init];
        self.nameLabel.frame = CGRectMake(0, 120, 250, 30);
        self.nameLabel.text = @"默认Text";
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        
//        self.transform = CGAffineTransformMakeRotation(M_PI_2);
        
        [self.contentView addSubview:self.imageView];
        
    }
    return self;
}

- (void)setCardData:(MediaCard *)card
{
    self.reviewImageView.image = card.reviewImage;
    self.nameLabel.text = card.name;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
