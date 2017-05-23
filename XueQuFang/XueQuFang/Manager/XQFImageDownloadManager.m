//
//  XQFImageDownloadManager.m
//  XueQuFang
//
//  Created by en li on 2017/5/23.
//  Copyright © 2017年 xqf. All rights reserved.
//

#import "XQFImageDownloadManager.h"

#import <Foundation/Foundation.h>
#import <UIImageView+AFNetworking.h>
#import <QiniuSDK.h>

static XQFImageDownloadManager* mSharedManager = nil;
static NSString* bucket = @"http://oi2mkhmod.bkt.clouddn.com/";

@implementation XQFImageDownloadManager

+(XQFImageDownloadManager*) sharedManager
{
	if (!mSharedManager) {
		mSharedManager = [[XQFImageDownloadManager alloc] init];
	}
	
	return mSharedManager;
}

-(void) downloadImage:(UIImageView*)imageview fromURL:(NSString*) urlString {
	NSURL *lSourceURL = [NSURL URLWithString:urlString];
	[imageview setImageWithURL:lSourceURL];
}

-(void) downloadImage:(UIImageView*)imageview withName:(NSString*) imageName {
	NSString* urlString = [NSString stringWithFormat:@"%@%@", bucket, imageName];
	urlString =[urlString stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
	NSURL *lSourceURL = [NSURL URLWithString:urlString];
	[imageview setImageWithURL:lSourceURL];
}

@end
