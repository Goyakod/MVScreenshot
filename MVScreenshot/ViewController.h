//
//  ViewController.h
//  MVScreenshot
//
//  Created by pro on 16/2/25.
//  Copyright © 2016年 vickyTest. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *videosTableView;

@end

