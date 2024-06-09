//
//  TestObject.m
//  Category
//
//  Created by Rui Hou on 2024/6/10.
//

#import "TestObject.h"

@implementation TestObject

- (void)hello {
    NSLog(@"主类方法执行");
}

- (void)diffParam:(NSString *)name {
    NSLog(@"主类 参数：%@", name);
}

@end
