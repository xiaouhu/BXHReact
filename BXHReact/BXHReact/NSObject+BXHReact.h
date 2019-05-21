//
//  NSObject+BXHReact.h
//  BXHReact
//
//  Created by 步晓虎 on 2019/5/21.
//  Copyright © 2019 步晓虎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BXHReactNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (BXHReact)

- (BXHReactNode *)bxh_deallocNode;

- (BXHReactNode *)bxh_node:(NSString *)path;

- (BXHReactNode *)bxh_observer:(NSString *)path;

- (BXHReactNode *)bxh_observer:(NSString *)path options:(NSKeyValueObservingOptions)options;


@end

NS_ASSUME_NONNULL_END
