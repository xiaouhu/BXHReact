//
//  ViewController.m
//  BXHReact
//
//  Created by 步晓虎 on 2019/5/18.
//  Copyright © 2019 步晓虎. All rights reserved.
//

#import "ViewController.h"
#import "BXHReact/BXHReactNode.h"
#import "BXHReact/BXHMacros.h"
#import "BXHReact/NSObject+BXHReact.h"

@interface ViewController ()

@property (nonatomic, copy) NSString *text1;

@property (nonatomic, copy) NSString *text2;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[BXHObserver(self, text1) linkToNode:BXHNode(self, text2)] filterValue:^id (NSString *str1){
        return [NSString stringWithFormat:@"%@---change",str1];
    }];
    
    self.text1 = @"wo zai gai bian";
    
    // Do any additional setup after loading the view, typically from a nib.
}


@end
