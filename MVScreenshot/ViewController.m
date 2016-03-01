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
    
    NSMutableArray *_imageArray;
    NSMutableArray *_videoArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _imageArray = [NSMutableArray array];
    _videoArray = [NSMutableArray array];
    
    /**
     *  cameraButton  调用摄像头
     */
    
    self.cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.cameraButton.frame = CGRectMake((self.view.frame.size.width-200)/2, 50, 200, 100);
    [self.cameraButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.cameraButton setBackgroundImage:[UIImage imageNamed:@"monkey.jpg"] forState:UIControlStateNormal];
    [self.cameraButton addTarget:self action:@selector(cameraButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.cameraButton];
    
    /**
     *  Media List TableView
     */
    self.videosTableView = [[UITableView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 500) / 2, 200, 500, self.view.frame.size.height - 250) style:UITableViewStyleGrouped];
    self.videosTableView.delegate = self;
    self.videosTableView.dataSource = self;
    self.videosTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.videosTableView];
 
    /**
     *  TEST CODE
     *
     *  @return NOTHING
     */
}

/**
 *  调用摄像头方法
 *
 *  @param sender cameraButton
 */
- (void)cameraButtonPress:(UIButton *)sender {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    imagePicker.allowsEditing = NO;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
    
}

/**
 *  获取视频的缩略图方法
 *
 *  @param filePath 视频的本地路径
 *
 *  @return 视频截图
 */
- (UIImage *)getScreenShotImageFromVideoPath:(NSString *)filePath{
    
    UIImage *shotImage;
    
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


#pragma mark imagePickerController Delegate Method
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
            [_imageArray addObject:card];
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
            
            [_videoArray addObject:card];
            [self.videosTableView reloadData];
        }else{
            NSLog(@"视频存储失败");
        }

    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - table DataSource & delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return _imageArray.count;
    }
    return _videoArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 300;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Image List";
    }
    return @"Video List";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"cellIdentifier";
    MediaCardCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        cell = [[MediaCardCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    
    MediaCard *card;
    if (indexPath.section == 0) {
        card = [_imageArray objectAtIndex:indexPath.row];
    }else{
        card = [_videoArray objectAtIndex:indexPath.row];
    }
    [cell setCardData:card];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
