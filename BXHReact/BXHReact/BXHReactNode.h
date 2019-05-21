//
//  BXHReactNode.h
//  BXHReact
//
//  Created by 步晓虎 on 2019/5/18.
//  Copyright © 2019 步晓虎. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,BXHReactNodeStatue) {
    BXHReactNodeStatueUnReceive,
    BXHReactNodeStatueReceiving,
    BXHReactNodeStatueReceived,
};

@interface BXHReactNode : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, readonly, assign) BXHReactNodeStatue statue;

- (void)setValue:(id)value;

- (void)breakLink;

- (BXHReactNode *)linkToNode:(BXHReactNode *)node;

- (BXHReactNode *)needBothway;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
- (BXHReactNode *)receiveValue:(void (^)())receive;
- (BXHReactNode *)filterValue:(id (^)())filter;
#pragma clang diagnostic pop

+ (BXHReactNode *)combineNodes:(NSArray<BXHReactNode *> *)nodes;

+ (BXHReactNode *)mergeNodes:(NSArray<BXHReactNode *> *)nodes;

+ (BXHReactNode *)zipNodes: (NSArray<BXHReactNode *> *)nodes;


@end

NS_ASSUME_NONNULL_END
