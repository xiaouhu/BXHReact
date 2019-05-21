//
//  BXHReactNode.m
//  BXHReact
//
//  Created by 步晓虎 on 2019/5/18.
//  Copyright © 2019 步晓虎. All rights reserved.
//

#import "BXHReactNode.h"
#import "BXHMacros.h"

#define BXH_RET_GET(i) ret[i]
#define BXH_EXECUTE_RECEIVE(i) self.receive(BXHBlockFor(i, BXH_RET_GET));

@protocol BXHReactStream <NSObject>

- (void)node:(BXHReactNode *)node valueToNext:(id)value;

- (void)node:(BXHReactNode *)node valueToPre:(id)value;

@end

@interface BXHReactNode ()<BXHReactStream>

@property (nonatomic, strong) NSMutableArray<BXHReactNode *> *nextNodes;

@property (nonatomic, strong) NSHashTable<BXHReactNode *> *preNodes;

@property (nonatomic, assign) BOOL isBothWay;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
@property (nonatomic, copy) id (^filter)();
@property (nonatomic, copy) void (^receive)();
#pragma clang diagnostic pop
- (void)_node:(BXHReactNode *)node valueToNext:(id)value;
- (void)_node:(BXHReactNode *)node valueToPre:(id)value;

@end

@interface _BXHGroupNode : BXHReactNode
@property (nonatomic, strong) NSMutableArray *ret;
@property (nonatomic, strong) NSArray *hashIdentify;
@end
@implementation _BXHGroupNode

- (instancetype)initWithGroupNodes:(NSArray<BXHReactNode *> *)nodes
{
    if (self = [super init])
    {
        self.ret = [NSMutableArray array];
        NSMutableArray *hi = [NSMutableArray array];
        for (BXHReactNode *node in nodes)
        {
            [node linkToNode:self];
            [hi addObject:[NSString stringWithFormat:@"%ld",node.hash]];
            [self.ret addObject:[NSNull null]];
        }
        self.hashIdentify = hi.copy;
    }
    return self;
}

- (void)node:(BXHReactNode *)node valueToNext:(id)value
{
    NSString *hashStr = [NSString stringWithFormat:@"%ld",node.hash];
    NSInteger index = [self.hashIdentify indexOfObject:hashStr];
    [self.ret replaceObjectAtIndex:index withObject:value?:[NSNull null]];
}


@end

@interface _BXHCombineNode : _BXHGroupNode
@end
@implementation _BXHCombineNode
@synthesize statue = _statue;

- (void)dealloc
{
    
}


- (void)node:(BXHReactNode *)node valueToNext:(id)value
{
    [super node:node valueToNext:value];
    NSArray *ret = [self _dealValue];
    BOOL needSend = (ret != nil);
    if (!needSend)
    {
        self -> _statue = BXHReactNodeStatueReceiving;
    }
    else
    {
        self -> _statue = BXHReactNodeStatueReceived;
        if (self.receive) { BXHSWITCH(ret.count, BXH_EXECUTE_RECEIVE) }
        for (BXHReactNode *node in self.nextNodes)
        {
            [node _node:self valueToNext:ret];
        }
    }
}

- (NSArray *)_dealValue
{
    NSMutableArray *ret = [NSMutableArray array];
    for (id value in self.ret)
    {
        if ([value isKindOfClass:[NSNull class]])
        {
            return nil;
        }
        else
        {
            [ret addObject:value];
        }
    }
    return ret.copy;
}

@end

@interface _BXHMergeNode : _BXHGroupNode
@end
@implementation _BXHMergeNode
@synthesize statue = _statue;

- (void)node:(BXHReactNode *)node valueToNext:(id)value
{
    [super node:node valueToNext:value];
    NSArray *ret = [self _dealValue];
    self -> _statue = BXHReactNodeStatueReceived;
    if (self.receive) { BXHSWITCH(ret.count, BXH_EXECUTE_RECEIVE) }
    [self _node:node valueToNext:ret];
}

- (NSArray *)_dealValue
{
    NSMutableArray *ret = [NSMutableArray array];
    for (id value in self.ret)
    {
        [ret addObject:value?:[NSNull null]];
    }
    return ret.copy;
    
}

@end

@interface _BXHZipNode : _BXHGroupNode
@end
@implementation _BXHZipNode
@synthesize statue = _statue;


- (void)node:(BXHReactNode *)node valueToNext:(id)value
{
    [super node:node valueToNext:value];
    NSArray *ret = [self _dealValue];
    BOOL needSend = (ret != nil);
    if (!needSend)
    {
        self -> _statue = BXHReactNodeStatueReceiving;
    }
    else
    {
        self -> _statue = BXHReactNodeStatueReceived;
        if (self.receive) { BXHSWITCH(ret.count, BXH_EXECUTE_RECEIVE) }
        [self _node:node valueToNext:ret];
    }
}

- (NSArray *)_dealValue
{
    NSMutableArray *ret = [NSMutableArray array];
    for (id value in self.ret)
    {
        if ([value isKindOfClass:[NSNull class]])
        {
            return nil;
        }
        else
        {
            [ret addObject:value];
        }
    }
    for (int i = 0; i < self.ret.count; i ++)
    {
        [self.ret replaceObjectAtIndex:i withObject:[NSNull null]];
    }
    return ret.copy;
}

@end

@implementation BXHReactNode

- (void)dealloc
{
    
}

- (instancetype)init
{
    if (self = [super init])
    {
        _statue = BXHReactNodeStatueUnReceive;
        self.nextNodes = [NSMutableArray array];
        self.preNodes = [NSHashTable weakObjectsHashTable];
    }
    return self;
}

- (void)setValue:(id)value
{
    _statue = BXHReactNodeStatueReceived;
    id retValue = [self _receivedValueDeal:value];
    [self _node:nil valueToNext:retValue];
    if (self.isBothWay)
    {
        [self _node:nil valueToPre:retValue];
    }
}

- (void)node:(BXHReactNode *)node valueToNext:(id)value
{
    _statue = BXHReactNodeStatueReceived;
    id retValue = [self _receivedValueDeal:value];
    [self _node:node valueToNext:retValue];
}

- (void)_node:(BXHReactNode *)node valueToNext:(id)value
{
    for (BXHReactNode *node in self.nextNodes)
    {
        [node node:self valueToNext:value];
    }
}

- (void)node:(BXHReactNode *)node valueToPre:(id)value
{
    _statue = BXHReactNodeStatueReceived;
    id retValue = [self _receivedValueDeal:value];
    [self _node:node valueToPre:retValue];
}

- (void)_node:(BXHReactNode *)node valueToPre:(id)value
{
    for (BXHReactNode *node in self.preNodes)
    {
        [node node:self valueToPre:value];
    }
}

- (id)_receivedValueDeal:(id)value
{
    id retValue = value;
    if (self.filter) {  retValue = self.filter(retValue); }
    if (self.receive) { self.receive(retValue); }
    return retValue;
}

- (BXHReactNode *)linkToNode:(BXHReactNode *)node
{
    [node.preNodes addObject:self];
    [self.nextNodes addObject:node];
    return self;
}

- (BXHReactNode *)needBothway
{
    self.isBothWay = YES;
    return self;
}

- (void)breakLink
{
    for (BXHReactNode *preNode in self.preNodes)
    {
        [preNode.nextNodes removeObject:self];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
- (BXHReactNode *)receiveValue:(void (^)())receive
{
    self.receive = receive;
    return self;
}

- (BXHReactNode *)filterValue:(id (^)())filter
{
    self.filter = filter;
    return self;
}
#pragma clang diagnostic pop

+ (BXHReactNode *)combineNodes:(NSArray<BXHReactNode *> *)nodes
{
    _BXHCombineNode *node = [[_BXHCombineNode alloc] initWithGroupNodes:nodes];
    return node;
}

+ (BXHReactNode *)mergeNodes:(NSArray<BXHReactNode *> *)nodes
{
    _BXHMergeNode *node = [[_BXHMergeNode alloc] initWithGroupNodes:nodes];
    return node;
}

+ (BXHReactNode *)zipNodes: (NSArray<BXHReactNode *> *)nodes
{
    _BXHZipNode *node = [[_BXHZipNode alloc] initWithGroupNodes:nodes];
    return node;
}

@end
