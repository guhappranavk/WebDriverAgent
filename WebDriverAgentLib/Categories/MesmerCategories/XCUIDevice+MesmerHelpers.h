//
//  NSObject+XCUIDevice_MesmerHelpers.h
//  WebDriverAgentLib
//
//  Created by Guhappranav Karthikeyan on 20/03/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import <XCTest/XCTest.h>

NS_ASSUME_NONNULL_BEGIN

@interface XCUIDevice (MesmerHelpers)

/**
 Returns screenshot at high resolution
 @param error If there is an error, upon return contains an NSError object that describes the problem.
 @return Device screenshot as PNG-encoded data or nil in case of failure
 */
- (nullable NSData *)fb_screenshotHighWithError:(NSError*__autoreleasing*)error width:(CGFloat)width height:(CGFloat)height;

/**
 Returns screenshot image object
 @param error If there is an error, upon return contains an NSError object that describes the problem.
 @return Device screenshot image or nil in case of failure
 */
- (nullable UIImage *)fb_screenshotImageWithError:(NSError*__autoreleasing*)error;

/**
 Returns screenshot at high resolution
 @param error If there is an error, upon return contains an NSError object that describes the problem.
 @return Device screenshot as PNG-encoded data or nil in case of failure
 */
- (nullable NSData *)fb_screenshotHighWithError:(NSError*__autoreleasing*)error quality:(double)quality type:(NSString *)type;


@end

NS_ASSUME_NONNULL_END
