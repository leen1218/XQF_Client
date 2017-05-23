//
//  XQFImageDownloadManager.h
//  XueQuFang
//
//  Created by en li on 2017/5/23.
//  Copyright © 2017年 xqf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface XQFImageDownloadManager : NSObject

// singleton
+(XQFImageDownloadManager*) sharedManager;

// download image for UIImage
-(void) downloadImage:(UIImageView*)imageview fromURL:(NSString*) urlString;

-(void) downloadImage:(UIImageView*)imageview withName:(NSString*) imageName;

@end
