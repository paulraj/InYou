//
//  AWSUserFileManager.h
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-objc v0.5
//
#import "AWSContentManager.h"

@class AWSLocalContent;

/**
 * `AWSUserFileManager` inherits from `AWSContentManager` and adds the upload capabilities.
 *
 * The User File Manager uploads and downloads files from Amazon S3. It caches downloaded
 * files locally on the device in a size-limited cache. Downloaded files may be pinned
 * to the cache, so that they are not automatically removed when the cache size limit
 * is exceeded. The User File Manager provides access to two folders in the Amazon S3 bucket,
 * one called "public/" for public files, which are accessible to any user of the app,
 * and one called "private/" which contains a sub-folder for each Amazon Cognito
 * identified user. Files in the user's private folder can only be accessed by that user.
 * The User File Manager serves as the application's interface into the file-related
 * functionality of the User Data Storage feature.
 */
@interface AWSUserFileManager : AWSContentManager

/**
 *  The list of currently uploading contents.
 */
@property (nonatomic, readonly) NSArray *uploadingContents;

/**
 *  Returns a singleton instance of `AWSUserFileManager`.
 *
 *  @return A singleton instance of `AWSUserFileManager`.
 */
+ (instancetype)sharedManager;

/**
 *  Returns an instance of `AWSLocalContent`. You use this method to create an instance of `AWSLocalContent` to upload data to an Amazon S3 bucket with the specified key.
 *
 *  @param data The data to be uploaded.
 *  @param key  The Amazon S3 key.
 *
 *  @return An instance of `AWSLocalContent` that represents data to be uploaded.
 */
- (AWSLocalContent *)localContentWithData:(NSData *)data
                                      key:(NSString *)key;

@end

/**
 *  A category to add remote file removal to `AWSContent`.
 */
@interface AWSContent(AWSUserFileManager)

/**
 *  Removes the remote file associated with `AWSContent`.
 *
 *  @param completionHandler The completion handler block.
 */
- (void)removeRemoteContentWithCompletionHandler:(void(^)(AWSContent *content, NSError *error))completionHandler;

@end

/**
 *  A representation of the local content that may not exist in the Amazon S3 bucket yet. When uploading data to an S3 bucket, you first need to create an instance of this class.
 */
@interface AWSLocalContent : AWSContent

/**
 *  Uploads data associated with the local content.
 *
 *  @param pinOnCompletion   When set to `YES`, it pins the content after finishing uploading it.
 *  @param progressBlock     The upload progress block.
 *  @param completionHandler The completion handler block.
 */
- (void)uploadWithPinOnCompletion:(BOOL)pinOnCompletion
                    progressBlock:(void(^)(AWSLocalContent *content, NSProgress *progress))progressBlock
                completionHandler:(void(^)(AWSLocalContent *content, NSError *error))completionHandler;

@end
