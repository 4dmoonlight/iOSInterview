//
//  TestObject+SameFunc.m
//  Category
//
//  Created by Rui Hou on 2024/6/10.
//

#import "TestObject+SameFunc.h"

@implementation TestObject (SameFunc)

// 实现主类方法会有Warning，但默认不会有Error
// Category is implementing a method which will also be implemented by its primary class
- (void)hello {
    NSLog(@"分类方法执行");
}

- (void)diffParam:(TestObject *)obj {
    // 因为NSString也是这样打印，没有问题
    NSLog(@"分类 参数：%@", obj);
    
    // 会崩溃，因为传进来的实际上是主类的NSString类型
    // *** Terminating app due to uncaught exception 'NSInvalidArgumentException', reason: '-[__NSCFConstantString hello]: unrecognized selector sent to instance 0x106dc80b0'
//    [obj hello];
}

@end
