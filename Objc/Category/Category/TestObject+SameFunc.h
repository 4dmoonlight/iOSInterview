//
//  TestObject+SameFunc.h
//  Category
//
//  Created by Rui Hou on 2024/6/10.
//

#import "TestObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface TestObject (SameFunc)

// 注释掉声明，也会使分类方法执行
- (void)hello;

// 与主类函数名相同，但参数不同
- (void)diffParam:(TestObject *)obj;

@end

NS_ASSUME_NONNULL_END
