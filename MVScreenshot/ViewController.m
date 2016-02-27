//
//  ViewController.m
//  MVScreenshot
//
//  Created by pro on 16/2/25.
//  Copyright © 2016年 vickyTest. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "MediaCard.h"
#import "MediaCardCell.h"

@interface ViewController (){
    
    NSString *_imageFilePath;
    NSString *_videoFilePath;
    
    NSMutableArray *_dataArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _dataArray = [NSMutableArray array];
    
    self.videosTableView.delegate = self;
    self.videosTableView.dataSource = self;
//    self.videosTableView.transform = CGAffineTransformMakeRotation(-M_PI_2);
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
    
    MediaCard *card = [[MediaCard alloc] init];
    card.name = cfuuidString;
    
    if ([info[@"UIImagePickerControllerMediaType"] isEqualToString:@"public.image"]) {
        
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.png",directPath,cfuuidString];
        UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
        NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
        
        if ([imageData writeToFile:filePath atomically:YES]) {
            NSLog(@"图片存储成功");
            card.reviewImage = image;
            [_dataArray addObject:card];
            [self.videosTableView reloadData];
        }else{
            NSLog(@"图片存储失败");
        }
        
        
        
    }else if ([info[@"UIImagePickerControllerMediaType"] isEqualToString:@"public.movie"]){
        NSString *filePath = [NSString stringWithFormat:@"%@/%@.mov",directPath,cfuuidString];
        
        NSURL *videoURL = info[@"UIImagePickerControllerMediaURL"];
        NSData *videoData = [NSData dataWithContentsOfURL:videoURL];
        if ([videoData writeToFile:filePath atomically:YES]) {
            NSLog(@"视频存储成功");
            card.reviewImage = [self getScreenShotImageFromVideoPath:filePath];
            
            [_dataArray addObject:card];
            [self.videosTableView reloadData];
        }else{
            NSLog(@"视频存储失败");
        }
        //card.reviewImage = [UIImage imageNamed:@"monkey.jpg"];

    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath{

    UIImage *shotImage;
    
//    MPMoviePlayerController *MPMoviePC = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL fileURLWithPath:filePath]];
//    shotImage = [MPMoviePC thumbnailImageAtTime:0.0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:filePath] options:nil];
    
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    gen.appliesPreferredTrackTransform = YES;
    
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    
    NSError *error = nil;
    
    CMTime actualTime;
    
    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    
    shotImage = [[UIImage alloc] initWithCGImage:image];
    
    CGImageRelease(image);
    
    return shotImage;
    
}

#pragma mark - table DataSource & delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellIdentifier";
    MediaCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MediaCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    MediaCard *card = [_dataArray objectAtIndex:indexPath.row];
    [cell setCardData:card];
    
    return cell;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
