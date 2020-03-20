//
//  NSObject+XCUIDevice_MesmerHelpers.m
//  WebDriverAgentLib
//
//  Created by Guhappranav Karthikeyan on 20/03/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "XCUIDevice+MesmerHelpers.h"

#import <arpa/inet.h>
#import <ifaddrs.h>
#include <notify.h>
#import <objc/runtime.h>

#import "XCUIDevice.h"
#import "XCUIScreen.h"
#import "XCAXClient_iOS.h"

#import "FBErrorBuilder.h"

@implementation XCUIDevice (MesmerHelpers)

- (NSData *)fb_screenshotHighWithError:(NSError*__autoreleasing*)error width:(CGFloat)width height:(CGFloat)height
{
  Class xcScreenClass = objc_lookUpClass("XCUIScreen");
  if (nil == xcScreenClass) {
    NSData *result = [[XCAXClient_iOS sharedClient] screenshotData];
    if (nil == result) {
      if (error) {
        *error = [[FBErrorBuilder.builder withDescription:@"Cannot take a screenshot of the current screen state"] build];
      }
      return nil;
    }
    return result;
  }
  
  //  XCUIApplication *app = FBApplication.fb_activeApplication;
  //  CGSize screenSize = FBAdjustDimensionsForApplication(app.frame.size, app.interfaceOrientation);
  //  NSUInteger quality = 0;
  //  CGRect screenRect = CGRectMake(0, 0, screenSize.width, screenSize.height);
  //
  XCUIScreen *mainScreen = (XCUIScreen *)[xcScreenClass mainScreen];
  //  return [mainScreen screenshotDataForQuality:quality rect:screenRect error:error];
  
  XCUIScreenshot *screenshot = [mainScreen screenshot];
  
  UIImage *screenImage = [screenshot image];

  if (width <= 0.0 || height <= 0.0) {
    if (screenImage.size.height > screenImage.size.width) {
          return UIImagePNGRepresentation(screenImage);
    }
  }
  width = width <= 0.0 ? screenImage.size.width : width/[UIScreen mainScreen].nativeScale;
  height = height <= 0.0 ? screenImage.size.height : height/[UIScreen mainScreen].nativeScale;
  UIImage *scaledImage = [self scaleToSize:screenImage size:CGSizeMake(width, height)];
  return UIImagePNGRepresentation(scaledImage);
}

- (UIImage *)fb_screenshotImageWithError:(NSError*__autoreleasing*)error
{

  Class xcScreenClass = objc_lookUpClass("XCUIScreen");
  if (nil == xcScreenClass) {
    XCUIScreenshot *screenshotResult = [[XCAXClient_iOS sharedClient] screenshot];
    
    if (nil == screenshotResult) {
      if (error) {
        *error = [[FBErrorBuilder.builder withDescription:@"Cannot take a screenshot of the current screen state"] build];
      }
      return nil;
    }
    UIImage *screenImage = [screenshotResult image];
    if (screenImage.size.height <= 1.0) {
      return nil;
    }
    return screenImage;
  }

  XCUIScreen *mainScreen = (XCUIScreen* )[xcScreenClass mainScreen];
  
  @try {
    XCUIScreenshot *screenshot = [mainScreen screenshot];
    UIImage *screenImage = [screenshot image];
    if (screenImage.size.height <= 1.0) {
      return nil;
    }
    return screenImage;
  }
  @catch (NSException *exception) {
    NSLog(@"failed to get screenshot: %@", exception);
  }
  return nil;
}

- (NSData *)fb_screenshotHighWithError:(NSError*__autoreleasing*)error quality:(double)quality type:(NSString *)type
{
  Class xcScreenClass = objc_lookUpClass("XCUIScreen");
  if (nil == xcScreenClass) {
    NSData *result = [[XCAXClient_iOS sharedClient] screenshotData];
    if (nil == result) {
      if (error) {
        *error = [[FBErrorBuilder.builder withDescription:@"Cannot take a screenshot of the current screen state"] build];
      }
      return nil;
    }
    return result;
  }
  
  //  XCUIApplication *app = FBApplication.fb_activeApplication;
  //  CGSize screenSize = FBAdjustDimensionsForApplication(app.frame.size, app.interfaceOrientation);
  //  NSUInteger quality = 0;
  //  CGRect screenRect = CGRectMake(0, 0, screenSize.width, screenSize.height);
  //
  XCUIScreen *mainScreen = (XCUIScreen *)[xcScreenClass mainScreen];
  //  return [mainScreen screenshotDataForQuality:quality rect:screenRect error:error];
  
  NSData *result = nil;
  
  @try {
    XCUIScreenshot *screenshot = [mainScreen screenshot];
    if (type == nil || [type caseInsensitiveCompare:@"jpeg"] == NSOrderedSame) {
      UIImage *screenImage = [screenshot image];
      if (screenImage.size.height <= 1.0) {
        return nil;
      }
      result = UIImageJPEGRepresentation(screenImage, (CGFloat)quality);
    }
    else {
      result = [screenshot PNGRepresentation];
    }
  }
  @catch (NSException *exception) {
    NSLog(@"failed to get screenshot: %@", exception);
  }
  return result;
}

- (UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size {
  UIGraphicsBeginImageContextWithOptions(size, false, [UIScreen mainScreen].nativeScale);
  [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return newImage;
}

@end
