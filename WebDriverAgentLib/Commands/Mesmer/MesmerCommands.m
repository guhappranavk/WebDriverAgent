//
//  MesmerCommands.m
//  WebDriverAgentLib
//
//  Created by Guhappranav Karthikeyan on 20/03/20.
//  Copyright © 2020 Facebook. All rights reserved.
//

#import "MesmerCommands.h"

#import "FBAlert.h"
#import "FBApplication.h"
#import "FBRouteRequest.h"
#import "FBSession.h"
#import "XCUIDevice+MesmerHelpers.h"
#import "BSWDataModelHandler.h"


@implementation MesmerCommands

#pragma mark - <FBCommandHandler>

+ (NSArray *)routes
{
  return
  @[
    [[FBRoute GET:@"/screenshotHigh"].withoutSession respondWithTarget:self action:@selector(handleGetScreenshotHigh:)],
    [[FBRoute GET:@"/screenshotHigh/width/:width/height/:height"].withoutSession respondWithTarget:self action:@selector(handleGetScreenshotHigh:)],
    [[FBRoute GET:@"/screenClassification"].withoutSession respondWithTarget:self action:@selector(handleGetScreenshotClassification:)]
  ];
}

+ (id<FBResponsePayload>)handleGetScreenshotHigh:(FBRouteRequest *)request
{
  CGFloat width = [request.arguments[@"width"] floatValue];
  CGFloat height = [request.arguments[@"height"] floatValue];
  NSError *error;
  NSData *screenshotData = [[XCUIDevice sharedDevice] fb_screenshotHighWithError:&error width:width height:height];
  
  if (nil == screenshotData) {
    return FBResponseWithUnknownError(error);
  }
  NSString *screenshot = [screenshotData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
  return FBResponseWithObject(screenshot);
}

+ (id<FBResponsePayload>)handleGetScreenshotClassification:(FBRouteRequest *)request
{
  NSError *error;
  UIImage *image  = [[XCUIDevice sharedDevice] fb_screenshotImageWithError:&error];
  if (nil == image) {
    return FBResponseWithUnknownError(error);
  }
  NSDictionary *_values = [[BSWDataModelHandler sharedInstance] runModelOnImage:image];
  NSMutableDictionary *values = [_values mutableCopy];
  
  double threshold = 0.501;
  double loadingConfScore = ((NSNumber *)_values[@"loading"]).doubleValue;
  double loadedConfScore = ((NSNumber *)_values[@"loaded"]).doubleValue;
  
  if (loadedConfScore > loadingConfScore && loadedConfScore > threshold) {
    values[@"result"] = @"loaded";
  }
  else if (loadingConfScore > loadedConfScore && loadingConfScore > threshold) {
    values[@"result"] = @"loading";
  }
  else {
    values[@"result"] = @"UNKNOWN";
  }
  
  return FBResponseWithObject(values);
}


@end
