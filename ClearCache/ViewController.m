//
//  ViewController.m
//  ClearCache
//
//  Created by 谢霆锋 on 15/12/14.
//  Copyright © 2015年 lll. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //获取缓存大小。。
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    CGFloat fileSize = [self folderSizeAtPath:cachPath];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",[NSString stringWithFormat:@"原来缓存:%.2fMB",fileSize]);
        
    });
    [self myClearCacheAction];
}
#pragma mark === 暂时不用清除缓存=====
-(void)myClearCacheAction{
    dispatch_async(
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
                   , ^{
                       NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
                       
                       NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
                       NSLog(@"files :%lu",(unsigned long)[files count]);
                       for (NSString *p in files) {
                           NSError *error;
                           NSString *path = [cachPath stringByAppendingPathComponent:p];
                           if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                               [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                           }
                       }
                       [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];});
}
-(void)clearCacheSuccess
{
    NSLog(@"清理成功");
    //获取缓存大小。。
    NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    CGFloat fileSize = [self folderSizeAtPath:cachPath];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",[NSString stringWithFormat:@"清理之后缓存%.2fMB",fileSize]);
        
    });
    
}
- (CGFloat)folderSizeAtPath:(NSString *)folderPath
{
    NSFileManager *manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) {
        return 0;
    }
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString *fileName = nil;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil) {
        NSString *fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}

- (long long)fileSizeAtPath:(NSString *)filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
