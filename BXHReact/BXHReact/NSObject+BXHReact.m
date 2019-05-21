//
//  NSObject+BXHReact.m
//  BXHReact
//
//  Created by 步晓虎 on 2019/5/21.
//  Copyright © 2019 步晓虎. All rights reserved.
//

#import "NSObject+BXHReact.h"
@import ObjectiveC.runtime;

@interface _BXHReactDealloc : NSObject

@property (nonatomic, strong) BXHReactNode *deallocNode;

@end

@implementation _BXHReactDealloc

- (instancetype)init
{
    if (self = [super init])
    {
        self.deallocNode = [[BXHReactNode alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self.deallocNode setValue:[NSNull null]];
}

@end

@interface _BXHReactProxy : NSObject

@property (nonatomic, weak) id target;

@property (nonatomic, copy) NSString *keypath;

@property (nonatomic, strong) BXHReactNode *retNode;

@end

@implementation _BXHReactProxy

- (instancetype)initWithTarget:(id)target keypath:(NSString *)keypath
{
    if (self = [super init])
    {
        self.target = target;
        self.keypath = keypath;
    }
    return self;
}

- (BXHReactNode *)kvcNode
{
    self.retNode = [[BXHReactNode alloc] init];
    self.retNode.name = [NSString stringWithFormat:@"%@-%@-%p",NSStringFromClass([self.target class]),self.keypath,self.target];
    __weak typeof(self) weakSelf = self;
    [self.retNode receiveValue:^(id  _Nonnull value) {
        __strong typeof(weakSelf) self = weakSelf;
        [self.target setValue:value forKey:self.keypath];
    }];
    [[self.target bxh_deallocNode] receiveValue:^(id value){
        __strong typeof(weakSelf) self = weakSelf;
        [self.retNode breakLink];
    }];
    return self.retNode;
}

- (BXHReactNode *)kvoNode:(NSKeyValueObservingOptions)options
{
    self.retNode = [[BXHReactNode alloc] init];
    self.retNode.name = [NSString stringWithFormat:@"%@-%@-%p",NSStringFromClass([self.target class]),self.keypath,self.target];
    __weak typeof(self) weakSelf = self;
    [[self.target bxh_deallocNode] receiveValue:^(id value){
        __strong typeof(weakSelf) self = weakSelf;
        [self.target removeObserver:self forKeyPath:self.keypath];
        [self.retNode breakLink];
    }];
    [self.target addObserver:self forKeyPath:self.keypath options:options context:NULL];
    return self.retNode;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    id valueForPath = change[NSKeyValueChangeNewKey];
    if ([valueForPath isKindOfClass:NSNull.class])
    {
        valueForPath = nil;
    }
    [self.retNode setValue:valueForPath];
}

@end

@implementation NSObject (BXHReact)

- (BXHReactNode *)bxh_deallocNode
{
    _BXHReactDealloc *jrd = [[_BXHReactDealloc alloc] init];
    NSMutableArray *jrds = objc_getAssociatedObject(self, _cmd);
    if (!jrds)
    {
        jrds = [NSMutableArray arrayWithObject:jrd];
    }
    else
    {
        [jrds addObject:jrd];
    }
    objc_setAssociatedObject(self, _cmd, jrds, OBJC_ASSOCIATION_RETAIN);
    return jrd.deallocNode;
}

- (BXHReactNode *)bxh_node:(NSString *)path
{
    _BXHReactProxy *proxy = [[_BXHReactProxy alloc] initWithTarget:self keypath:path];
    [self _addProxy:proxy];
    return [proxy kvcNode];
}

- (BXHReactNode *)bxh_observer:(NSString *)path
{
    return [self bxh_observer:path options:NSKeyValueObservingOptionNew];
}

- (BXHReactNode *)bxh_observer:(NSString *)path options:(NSKeyValueObservingOptions)options
{
    _BXHReactProxy *proxy = [[_BXHReactProxy alloc] initWithTarget:self keypath:path];
    [self _addProxy:proxy];
    return [proxy kvoNode:options];
}

- (void)_addProxy:(_BXHReactProxy *)proxy
{
    [[self proxies] addObject:proxy];
}

- (void)setProxies:(NSMutableArray<_BXHReactProxy *> *)ary
{
    objc_setAssociatedObject(self, @selector(proxies), ary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSMutableArray<_BXHReactProxy *> *)proxies
{
    NSMutableArray *proxies = objc_getAssociatedObject(self, _cmd);
    if (!proxies)
    {
        proxies = [NSMutableArray array];
    }
    [self setProxies:proxies];
    return proxies;
}


@end
