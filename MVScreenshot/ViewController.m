//
//  ViewController.m
//  MVScreenshot
//
//  Created by pro on 16/2/25.
//  Copyright © 2016年 vickyTest. All rights reserved.
//

#import "ViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController (){
    
    NSString *_imageFilePath;
    NSString *_videoFilePath;
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

/*
 *调用摄像头
 *录制视频
 */
- (IBAction)recordMediaVideoButtonPress:(id)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

/*
 *代理方法
 */
#pragma mark delegte methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *directPath = [documentsPaths objectAtIndex:0];
    CFUUIDRef uuidObj = CFUUIDCreate(kCFAllocatorDefault);
    NSString* cfuuidString = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObj));
    
    if ([info[@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"]) {
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.png",directPath,cfuuidString];
       
        
    }else if ([info[@"UIImagePickerControllerMediaType"] isEqualToString:@"public.movie"]){
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.mov",directPath,cfuuidString];
        
        NSString *videoURL = info[@"UIImagePickerControllerMediaURL"];
        
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - savefile method


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
