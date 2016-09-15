//
//  AWSTask+CheckExceptions.m
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-objc v0.5
//
#import <Foundation/Foundation.h>
#import "AWSTask+CheckExceptions.h"
#import <AWSCore/AWSCore.h>

@implementation AWSTask (CheckExceptions)

- (void)continueWithExceptionCheckingBlock:(void (^)(id result, NSError *error))completionBlock {
    [self continueWithBlock:^id(AWSTask *task) {
        if (task.exception) {
            AWSLogError(@"Exception: %@", task.exception);
            @throw task.exception;
        }
        id result = task.result;
        NSError *error = task.error;

        completionBlock(result, error);
        return nil;
    }];
}

@end
