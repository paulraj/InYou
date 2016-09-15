// Private headers from AWSCore.framework.
//
//  AWSCorePrivateHeader.h
//
//
// Copyright 2016 Amazon.com, Inc. or its affiliates (Amazon). All Rights Reserved.
//
// Code generated by AWS Mobile Hub. Amazon gives unlimited permission to 
// copy, distribute and modify it.
//
// Source code generated from template: aws-my-sample-app-ios-objc v0.5
//
@class AWSTMCache;
@class AWSTMDiskCache;
@class AWSTMMemoryCache;

typedef void (^AWSTMCacheBlock)(AWSTMCache *cache);
typedef void (^AWSTMCacheObjectBlock)(AWSTMCache *cache, NSString *key, id object);

@interface AWSTMCache : NSObject

#pragma mark -
/// @name Core

/**
 The name of this cache, used to create the <diskCache> and also appearing in stack traces.
 */
@property (readonly) NSString *name;

/**
 A concurrent queue on which blocks passed to the asynchronous access methods are run.
 */
@property (readonly) dispatch_queue_t queue;

/**
 Synchronously retrieves the total byte count of the <diskCache> on the shared disk queue.
 */
@property (readonly) NSUInteger diskByteCount;

/**
 The underlying disk cache, see <TMDiskCache> for additional configuration and trimming options.
 */
@property (readonly) AWSTMDiskCache *diskCache;

/**
 The underlying memory cache, see <TMMemoryCache> for additional configuration and trimming options.
 */
@property (readonly) AWSTMMemoryCache *memoryCache;

#pragma mark -
/// @name Initialization

/**
 A shared cache.

 @result The shared singleton cache instance.
 */
+ (instancetype)sharedCache;

/**
 Multiple instances with the same name are allowed and can safely access
 the same data on disk thanks to the magic of seriality. Also used to create the <diskCache>.

 @see name
 @param name The name of the cache.
 @result A new cache with the specified name.
 */
- (instancetype)initWithName:(NSString *)name;

/**
 The designated initializer. Multiple instances with the same name are allowed and can safely access
 the same data on disk thanks to the magic of seriality. Also used to create the <diskCache>.

 @see name
 @param name The name of the cache.
 @param rootPath The path of the cache on disk.
 @result A new cache with the specified name.
 */
- (instancetype)initWithName:(NSString *)name rootPath:(NSString *)rootPath;

#pragma mark -
/// @name Asynchronous Methods

/**
 Retrieves the object for the specified key. This method returns immediately and executes the passed
 block after the object is available, potentially in parallel with other blocks on the <queue>.

 @param key The key associated with the requested object.
 @param block A block to be executed concurrently when the object is available.
 */
- (void)objectForKey:(NSString *)key block:(AWSTMCacheObjectBlock)block;

/**
 Stores an object in the cache for the specified key. This method returns immediately and executes the
 passed block after the object has been stored, potentially in parallel with other blocks on the <queue>.

 @param object An object to store in the cache.
 @param key A key to associate with the object. This string will be copied.
 @param block A block to be executed concurrently after the object has been stored, or nil.
 */
- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key block:(AWSTMCacheObjectBlock)block;

/**
 Removes the object for the specified key. This method returns immediately and executes the passed
 block after the object has been removed, potentially in parallel with other blocks on the <queue>.

 @param key The key associated with the object to be removed.
 @param block A block to be executed concurrently after the object has been removed, or nil.
 */
- (void)removeObjectForKey:(NSString *)key block:(AWSTMCacheObjectBlock)block;

/**
 Removes all objects from the cache that have not been used since the specified date. This method returns immediately and
 executes the passed block after the cache has been trimmed, potentially in parallel with other blocks on the <queue>.

 @param date Objects that haven't been accessed since this date are removed from the cache.
 @param block A block to be executed concurrently after the cache has been trimmed, or nil.
 */
- (void)trimToDate:(NSDate *)date block:(AWSTMCacheBlock)block;

/**
 Removes all objects from the cache.This method returns immediately and executes the passed block after the
 cache has been cleared, potentially in parallel with other blocks on the <queue>.

 @param block A block to be executed concurrently after the cache has been cleared, or nil.
 */
- (void)removeAllObjects:(AWSTMCacheBlock)block;

#pragma mark -
/// @name Synchronous Methods

/**
 Retrieves the object for the specified key. This method blocks the calling thread until the object is available.

 @see objectForKey:block:
 @param key The key associated with the object.
 @result The object for the specified key.
 */
- (id)objectForKey:(NSString *)key;

/**
 Stores an object in the cache for the specified key. This method blocks the calling thread until the object has been set.

 @see setObject:forKey:block:
 @param object An object to store in the cache.
 @param key A key to associate with the object. This string will be copied.
 */
- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key;

/**
 Removes the object for the specified key. This method blocks the calling thread until the object
 has been removed.

 @param key The key associated with the object to be removed.
 */
- (void)removeObjectForKey:(NSString *)key;

/**
 Removes all objects from the cache that have not been used since the specified date.
 This method blocks the calling thread until the cache has been trimmed.

 @param date Objects that haven't been accessed since this date are removed from the cache.
 */
- (void)trimToDate:(NSDate *)date;

/**
 Removes all objects from the cache. This method blocks the calling thread until the cache has been cleared.
 */
- (void)removeAllObjects;

@end

typedef void (^AWSTMDiskCacheBlock)(AWSTMDiskCache *cache);
typedef void (^AWSTMDiskCacheObjectBlock)(AWSTMDiskCache *cache, NSString *key, id <NSCoding> object, NSURL *fileURL);

@interface AWSTMDiskCache : NSObject

#pragma mark -
/// @name Core

/**
 The name of this cache, used to create a directory under Library/Caches and also appearing in stack traces.
 */
@property (readonly) NSString *name;

/**
 The URL of the directory used by this cache, usually `Library/Caches/com.tumblr.TMDiskCache.(name)`

 @warning Do not interact with files under this URL except on the <sharedQueue>.
 */
@property (readonly) NSURL *cacheURL;

/**
 The total number of bytes used on disk, as reported by `NSURLTotalFileAllocatedSizeKey`.

 @warning This property is technically safe to access from any thread, but it reflects the value *right now*,
 not taking into account any pending operations. In most cases this value should only be read from a block on the
 <sharedQueue>, which will ensure its accuracy and prevent it from changing during the lifetime of the block.

 For example:

 // some background thread, not a block already running on the shared queue

 dispatch_sync([TMDiskCache sharedQueue], ^{
 NSLog(@"accurate, unchanging byte count: %d", [[TMDiskCache sharedCache] byteCount]);
 });
 */
@property (readonly) NSUInteger byteCount;

/**
 The maximum number of bytes allowed on disk. This value is checked every time an object is set, if the written
 size exceeds the limit a trim call is queued. Defaults to `0.0`, meaning no practical limit.

 @warning Do not read this property on the <sharedQueue> (including asynchronous method blocks).
 */
@property (assign) NSUInteger byteLimit;

/**
 The maximum number of seconds an object is allowed to exist in the cache. Setting this to a value
 greater than `0.0` will start a recurring GCD timer with the same period that calls <trimToDate:>.
 Setting it back to `0.0` will stop the timer. Defaults to `0.0`, meaning no limit.

 @warning Do not read this property on the <sharedQueue> (including asynchronous method blocks).
 */
@property (assign) NSTimeInterval ageLimit;

#pragma mark -
/// @name Event Blocks

/**
 A block to be executed just before an object is added to the cache. The queue waits during execution.
 */
@property (copy) AWSTMDiskCacheObjectBlock willAddObjectBlock;

/**
 A block to be executed just before an object is removed from the cache. The queue waits during execution.
 */
@property (copy) AWSTMDiskCacheObjectBlock willRemoveObjectBlock;

/**
 A block to be executed just before all objects are removed from the cache as a result of <removeAllObjects:>.
 The queue waits during execution.
 */
@property (copy) AWSTMDiskCacheBlock willRemoveAllObjectsBlock;

/**
 A block to be executed just after an object is added to the cache. The queue waits during execution.
 */
@property (copy) AWSTMDiskCacheObjectBlock didAddObjectBlock;

/**
 A block to be executed just after an object is removed from the cache. The queue waits during execution.
 */
@property (copy) AWSTMDiskCacheObjectBlock didRemoveObjectBlock;

/**
 A block to be executed just after all objects are removed from the cache as a result of <removeAllObjects:>.
 The queue waits during execution.
 */
@property (copy) AWSTMDiskCacheBlock didRemoveAllObjectsBlock;

#pragma mark -
/// @name Initialization

/**
 A shared cache.

 @result The shared singleton cache instance.
 */
+ (instancetype)sharedCache;

/**
 A shared serial queue, used by all instances of this class. Use `dispatch_set_target_queue` to integrate
 this queue with an exisiting serial I/O queue.

 @result The shared singleton queue instance.
 */
+ (dispatch_queue_t)sharedQueue;

/**
 Empties the trash with `DISPATCH_QUEUE_PRIORITY_BACKGROUND`. Does not block the <sharedQueue>.
 */
+ (void)emptyTrash;


/**
 Multiple instances with the same name are allowed and can safely access
 the same data on disk thanks to the magic of seriality.

 @see name
 @param name The name of the cache.
 @result A new cache with the specified name.
 */
- (instancetype)initWithName:(NSString *)name;

/**
 The designated initializer. Multiple instances with the same name are allowed and can safely access
 the same data on disk thanks to the magic of seriality.

 @see name
 @param name The name of the cache.
 @param rootPath The path of the cache.
 @result A new cache with the specified name.
 */
- (instancetype)initWithName:(NSString *)name rootPath:(NSString *)rootPath;

#pragma mark -
/// @name Asynchronous Methods

/**
 Retrieves the object for the specified key. This method returns immediately and executes the passed
 block as soon as the object is available on the serial <sharedQueue>.

 @warning The fileURL is only valid for the duration of this block, do not use it after the block ends.

 @param key The key associated with the requested object.
 @param block A block to be executed serially when the object is available.
 */
- (void)objectForKey:(NSString *)key block:(AWSTMDiskCacheObjectBlock)block;

/**
 Retrieves the fileURL for the specified key without actually reading the data from disk. This method
 returns immediately and executes the passed block as soon as the object is available on the serial
 <sharedQueue>.

 @warning Access is protected for the duration of the block, but to maintain safe disk access do not
 access this fileURL after the block has ended. Do all work on the <sharedQueue>.

 @param key The key associated with the requested object.
 @param block A block to be executed serially when the file URL is available.
 */
- (void)fileURLForKey:(NSString *)key block:(AWSTMDiskCacheObjectBlock)block;

/**
 Stores an object in the cache for the specified key. This method returns immediately and executes the
 passed block as soon as the object has been stored.

 @param object An object to store in the cache.
 @param key A key to associate with the object. This string will be copied.
 @param block A block to be executed serially after the object has been stored, or nil.
 */
- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key block:(AWSTMDiskCacheObjectBlock)block;

/**
 Removes the object for the specified key. This method returns immediately and executes the passed block
 as soon as the object has been removed.

 @param key The key associated with the object to be removed.
 @param block A block to be executed serially after the object has been removed, or nil.
 */
- (void)removeObjectForKey:(NSString *)key block:(AWSTMDiskCacheObjectBlock)block;

/**
 Removes all objects from the cache that have not been used since the specified date.
 This method returns immediately and executes the passed block as soon as the cache has been trimmed.

 @param date Objects that haven't been accessed since this date are removed from the cache.
 @param block A block to be executed serially after the cache has been trimmed, or nil.
 */
- (void)trimToDate:(NSDate *)date block:(AWSTMDiskCacheBlock)block;

/**
 Removes objects from the cache, largest first, until the cache is equal to or smaller than the specified byteCount.
 This method returns immediately and executes the passed block as soon as the cache has been trimmed.

 @param byteCount The cache will be trimmed equal to or smaller than this size.
 @param block A block to be executed serially after the cache has been trimmed, or nil.
 */
- (void)trimToSize:(NSUInteger)byteCount block:(AWSTMDiskCacheBlock)block;

/**
 Removes objects from the cache, ordered by date (least recently used first), until the cache is equal to or smaller
 than the specified byteCount. This method returns immediately and executes the passed block as soon as the cache has
 been trimmed.

 @param byteCount The cache will be trimmed equal to or smaller than this size.
 @param block A block to be executed serially after the cache has been trimmed, or nil.
 */
- (void)trimToSizeByDate:(NSUInteger)byteCount block:(AWSTMDiskCacheBlock)block;

/**
 Removes all objects from the cache. This method returns immediately and executes the passed block as soon as the
 cache has been cleared.

 @param block A block to be executed serially after the cache has been cleared, or nil.
 */
- (void)removeAllObjects:(AWSTMDiskCacheBlock)block;

/**
 Loops through all objects in the cache (reads and writes are suspended during the enumeration). Data is not actually
 read from disk, the `object` parameter of the block will be `nil` but the `fileURL` will be available.
 This method returns immediately.

 @param block A block to be executed for every object in the cache.
 @param completionBlock An optional block to be executed after the enumeration is complete.
 */
- (void)enumerateObjectsWithBlock:(AWSTMDiskCacheObjectBlock)block completionBlock:(AWSTMDiskCacheBlock)completionBlock;

#pragma mark -
/// @name Synchronous Methods

/**
 Retrieves the object for the specified key. This method blocks the calling thread until the
 object is available.

 @see objectForKey:block:
 @param key The key associated with the object.
 @result The object for the specified key.
 */
- (id <NSCoding>)objectForKey:(NSString *)key;

/**
 Retrieves the file URL for the specified key. This method blocks the calling thread until the
 url is available. Do not use this URL anywhere but on the <sharedQueue>. This method probably
 shouldn't even exist, just use the asynchronous one.

 @see fileURLForKey:block:
 @param key The key associated with the object.
 @result The file URL for the specified key.
 */
- (NSURL *)fileURLForKey:(NSString *)key;

/**
 Stores an object in the cache for the specified key. This method blocks the calling thread until
 the object has been stored.

 @see setObject:forKey:block:
 @param object An object to store in the cache.
 @param key A key to associate with the object. This string will be copied.
 */
- (void)setObject:(id <NSCoding>)object forKey:(NSString *)key;

/**
 Removes the object for the specified key. This method blocks the calling thread until the object
 has been removed.

 @param key The key associated with the object to be removed.
 */
- (void)removeObjectForKey:(NSString *)key;

/**
 Removes all objects from the cache that have not been used since the specified date.
 This method blocks the calling thread until the cache has been trimmed.

 @param date Objects that haven't been accessed since this date are removed from the cache.
 */
- (void)trimToDate:(NSDate *)date;

/**
 Removes objects from the cache, largest first, until the cache is equal to or smaller than the
 specified byteCount. This method blocks the calling thread until the cache has been trimmed.

 @param byteCount The cache will be trimmed equal to or smaller than this size.
 */
- (void)trimToSize:(NSUInteger)byteCount;

/**
 Removes objects from the cache, ordered by date (least recently used first), until the cache is equal to or
 smaller than the specified byteCount. This method blocks the calling thread until the cache has been trimmed.

 @param byteCount The cache will be trimmed equal to or smaller than this size.
 */
- (void)trimToSizeByDate:(NSUInteger)byteCount;

/**
 Removes all objects from the cache. This method blocks the calling thread until the cache has been cleared.
 */
- (void)removeAllObjects;

/**
 Loops through all objects in the cache (reads and writes are suspended during the enumeration). Data is not actually
 read from disk, the `object` parameter of the block will be `nil` but the `fileURL` will be available.
 This method blocks the calling thread until all objects have been enumerated.

 @param block A block to be executed for every object in the cache.

 @warning Do not call this method within the event blocks (<didRemoveObjectBlock>, etc.)
 Instead use the asynchronous version, <enumerateObjectsWithBlock:completionBlock:>.
 */
- (void)enumerateObjectsWithBlock:(AWSTMDiskCacheObjectBlock)block;

@end

typedef void (^AWSTMMemoryCacheBlock)(AWSTMMemoryCache *cache);
typedef void (^AWSTMMemoryCacheObjectBlock)(AWSTMMemoryCache *cache, NSString *key, id object);

@interface AWSTMMemoryCache : NSObject

#pragma mark -
/// @name Core

/**
 A concurrent queue on which all work is done. It is exposed here so that it can be set to target some
 other queue, such as a global concurrent queue with a priority other than the default.
 */
@property (readonly) dispatch_queue_t queue;

/**
 The total accumulated cost.
 */
@property (readonly) NSUInteger totalCost;

/**
 The maximum cost allowed to accumulate before objects begin to be removed with <trimToCostByDate:>.
 */
@property (assign) NSUInteger costLimit;

/**
 The maximum number of seconds an object is allowed to exist in the cache. Setting this to a value
 greater than `0.0` will start a recurring GCD timer with the same period that calls <trimToDate:>.
 Setting it back to `0.0` will stop the timer. Defaults to `0.0`.
 */
@property (assign) NSTimeInterval ageLimit;

/**
 When `YES` on iOS the cache will remove all objects when the app receives a memory warning.
 Defaults to `YES`.
 */
@property (assign) BOOL removeAllObjectsOnMemoryWarning;

/**
 When `YES` on iOS the cache will remove all objects when the app enters the background.
 Defaults to `YES`.
 */
@property (assign) BOOL removeAllObjectsOnEnteringBackground;

#pragma mark -
/// @name Event Blocks

/**
 A block to be executed just before an object is added to the cache. This block will be excuted within
 a barrier, i.e. all reads and writes are suspended for the duration of the block.
 */
@property (copy) AWSTMMemoryCacheObjectBlock willAddObjectBlock;

/**
 A block to be executed just before an object is removed from the cache. This block will be excuted
 within a barrier, i.e. all reads and writes are suspended for the duration of the block.
 */
@property (copy) AWSTMMemoryCacheObjectBlock willRemoveObjectBlock;

/**
 A block to be executed just before all objects are removed from the cache as a result of <removeAllObjects:>.
 This block will be excuted within a barrier, i.e. all reads and writes are suspended for the duration of the block.
 */
@property (copy) AWSTMMemoryCacheBlock willRemoveAllObjectsBlock;

/**
 A block to be executed just after an object is added to the cache. This block will be excuted within
 a barrier, i.e. all reads and writes are suspended for the duration of the block.
 */
@property (copy) AWSTMMemoryCacheObjectBlock didAddObjectBlock;

/**
 A block to be executed just after an object is removed from the cache. This block will be excuted
 within a barrier, i.e. all reads and writes are suspended for the duration of the block.
 */
@property (copy) AWSTMMemoryCacheObjectBlock didRemoveObjectBlock;

/**
 A block to be executed just after all objects are removed from the cache as a result of <removeAllObjects:>.
 This block will be excuted within a barrier, i.e. all reads and writes are suspended for the duration of the block.
 */
@property (copy) AWSTMMemoryCacheBlock didRemoveAllObjectsBlock;

/**
 A block to be executed upon receiving a memory warning (iOS only) potentially in parallel with other blocks on the <queue>.
 This block will be executed regardless of the value of <removeAllObjectsOnMemoryWarning>. Defaults to `nil`.
 */
@property (copy) AWSTMMemoryCacheBlock didReceiveMemoryWarningBlock;

/**
 A block to be executed when the app enters the background (iOS only) potentially in parallel with other blocks on the <queue>.
 This block will be executed regardless of the value of <removeAllObjectsOnEnteringBackground>. Defaults to `nil`.
 */
@property (copy) AWSTMMemoryCacheBlock didEnterBackgroundBlock;

#pragma mark -
/// @name Shared Cache

/**
 A shared cache.

 @result The shared singleton cache instance.
 */
+ (instancetype)sharedCache;

#pragma mark -
/// @name Asynchronous Methods

/**
 Retrieves the object for the specified key. This method returns immediately and executes the passed
 block after the object is available, potentially in parallel with other blocks on the <queue>.

 @param key The key associated with the requested object.
 @param block A block to be executed concurrently when the object is available.
 */
- (void)objectForKey:(NSString *)key block:(AWSTMMemoryCacheObjectBlock)block;

/**
 Stores an object in the cache for the specified key. This method returns immediately and executes the
 passed block after the object has been stored, potentially in parallel with other blocks on the <queue>.

 @param object An object to store in the cache.
 @param key A key to associate with the object. This string will be copied.
 @param block A block to be executed concurrently after the object has been stored, or nil.
 */
- (void)setObject:(id)object forKey:(NSString *)key block:(AWSTMMemoryCacheObjectBlock)block;

/**
 Stores an object in the cache for the specified key and the specified cost. If the cost causes the total
 to go over the <costLimit> the cache is trimmed (oldest objects first). This method returns immediately
 and executes the passed block after the object has been stored, potentially in parallel with other blocks
 on the <queue>.

 @param object An object to store in the cache.
 @param key A key to associate with the object. This string will be copied.
 @param cost An amount to add to the <totalCost>.
 @param block A block to be executed concurrently after the object has been stored, or nil.
 */
- (void)setObject:(id)object forKey:(NSString *)key withCost:(NSUInteger)cost block:(AWSTMMemoryCacheObjectBlock)block;

/**
 Removes the object for the specified key. This method returns immediately and executes the passed
 block after the object has been removed, potentially in parallel with other blocks on the <queue>.

 @param key The key associated with the object to be removed.
 @param block A block to be executed concurrently after the object has been removed, or nil.
 */
- (void)removeObjectForKey:(NSString *)key block:(AWSTMMemoryCacheObjectBlock)block;

/**
 Removes all objects from the cache that have not been used since the specified date.
 This method returns immediately and executes the passed block after the cache has been trimmed,
 potentially in parallel with other blocks on the <queue>.

 @param date Objects that haven't been accessed since this date are removed from the cache.
 @param block A block to be executed concurrently after the cache has been trimmed, or nil.
 */
- (void)trimToDate:(NSDate *)date block:(AWSTMMemoryCacheBlock)block;

/**
 Removes objects from the cache, costliest objects first, until the <totalCost> is below the specified
 value. This method returns immediately and executes the passed block after the cache has been trimmed,
 potentially in parallel with other blocks on the <queue>.

 @param cost The total accumulation allowed to remain after the cache has been trimmed.
 @param block A block to be executed concurrently after the cache has been trimmed, or nil.
 */
- (void)trimToCost:(NSUInteger)cost block:(AWSTMMemoryCacheBlock)block;

/**
 Removes objects from the cache, ordered by date (least recently used first), until the <totalCost> is below
 the specified value. This method returns immediately and executes the passed block after the cache has been
 trimmed, potentially in parallel with other blocks on the <queue>.

 @param cost The total accumulation allowed to remain after the cache has been trimmed.
 @param block A block to be executed concurrently after the cache has been trimmed, or nil.
 */
- (void)trimToCostByDate:(NSUInteger)cost block:(AWSTMMemoryCacheBlock)block;

/**
 Removes all objects from the cache. This method returns immediately and executes the passed block after
 the cache has been cleared, potentially in parallel with other blocks on the <queue>.

 @param block A block to be executed concurrently after the cache has been cleared, or nil.
 */
- (void)removeAllObjects:(AWSTMMemoryCacheBlock)block;

/**
 Loops through all objects in the cache within a memory barrier (reads and writes are suspended during the enumeration).
 This method returns immediately.

 @param block A block to be executed for every object in the cache.
 @param completionBlock An optional block to be executed concurrently when the enumeration is complete.
 */
- (void)enumerateObjectsWithBlock:(AWSTMMemoryCacheObjectBlock)block completionBlock:(AWSTMMemoryCacheBlock)completionBlock;

#pragma mark -
/// @name Synchronous Methods

/**
 Retrieves the object for the specified key. This method blocks the calling thread until the
 object is available.

 @see objectForKey:block:
 @param key The key associated with the object.
 @result The object for the specified key.
 */
- (id)objectForKey:(NSString *)key;

/**
 Stores an object in the cache for the specified key. This method blocks the calling thread until the object
 has been set.

 @see setObject:forKey:block:
 @param object An object to store in the cache.
 @param key A key to associate with the object. This string will be copied.
 */
- (void)setObject:(id)object forKey:(NSString *)key;

/**
 Stores an object in the cache for the specified key and the specified cost. If the cost causes the total
 to go over the <costLimit> the cache is trimmed (oldest objects first). This method blocks the calling thread
 until the object has been stored.

 @param object An object to store in the cache.
 @param key A key to associate with the object. This string will be copied.
 @param cost An amount to add to the <totalCost>.
 */
- (void)setObject:(id)object forKey:(NSString *)key withCost:(NSUInteger)cost;

/**
 Removes the object for the specified key. This method blocks the calling thread until the object
 has been removed.

 @param key The key associated with the object to be removed.
 */
- (void)removeObjectForKey:(NSString *)key;

/**
 Removes all objects from the cache that have not been used since the specified date.
 This method blocks the calling thread until the cache has been trimmed.

 @param date Objects that haven't been accessed since this date are removed from the cache.
 */
- (void)trimToDate:(NSDate *)date;

/**
 Removes objects from the cache, costliest objects first, until the <totalCost> is below the specified
 value. This method blocks the calling thread until the cache has been trimmed.

 @param cost The total accumulation allowed to remain after the cache has been trimmed.
 */
- (void)trimToCost:(NSUInteger)cost;

/**
 Removes objects from the cache, ordered by date (least recently used first), until the <totalCost> is below
 the specified value. This method blocks the calling thread until the cache has been trimmed.

 @param cost The total accumulation allowed to remain after the cache has been trimmed.
 */
- (void)trimToCostByDate:(NSUInteger)cost;

/**
 Removes all objects from the cache. This method blocks the calling thread until the cache has been cleared.
 */
- (void)removeAllObjects;

/**
 Loops through all objects in the cache within a memory barrier (reads and writes are suspended during the enumeration).
 This method blocks the calling thread until all objects have been enumerated.

 @param block A block to be executed for every object in the cache.

 @warning Do not call this method within the event blocks (<didReceiveMemoryWarningBlock>, etc.)
 Instead use the asynchronous version, <enumerateObjectsWithBlock:completionBlock:>.

 */
- (void)enumerateObjectsWithBlock:(AWSTMMemoryCacheObjectBlock)block;

@end