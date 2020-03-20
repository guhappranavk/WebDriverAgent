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

@implementation MesmerCommands

#pragma mark - <FBCommandHandler>

+ (NSArray *)routes
{
  return
  @[
//    [[FBRoute GET:@"/alert/text"] respondWithTarget:self action:@selector(handleAlertGetTextCommand:)],
//    [[FBRoute GET:@"/alert/text"].withoutSession respondWithTarget:self action:@selector(handleAlertGetTextCommand:)],
//    [[FBRoute POST:@"/alert/text"] respondWithTarget:self action:@selector(handleAlertSetTextCommand:)],
//    [[FBRoute POST:@"/alert/accept"] respondWithTarget:self action:@selector(handleAlertAcceptCommand:)],
//    [[FBRoute POST:@"/alert/accept"].withoutSession respondWithTarget:self action:@selector(handleAlertAcceptCommand:)],
//    [[FBRoute POST:@"/alert/dismiss"] respondWithTarget:self action:@selector(handleAlertDismissCommand:)],
//    [[FBRoute POST:@"/alert/dismiss"].withoutSession respondWithTarget:self action:@selector(handleAlertDismissCommand:)],
//    [[FBRoute GET:@"/wda/alert/buttons"] respondWithTarget:self action:@selector(handleGetAlertButtonsCommand:)],
  ];
}

@end
