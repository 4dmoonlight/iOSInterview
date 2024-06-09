//
//  ViewController.m
//  Category
//
//  Created by Rui Hou on 2024/6/10.
//

#import "ViewController.h"
#import <objc/runtime.h>

// 只引入主类，依然会使分类方法执行
#import "TestObject.h"

// 只引入分类，会使分类方法执行
//#import "TestObject+SameFunc.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    TestObject *obj = [[TestObject alloc] init];
//    [obj hello];
    
    // 代码补全提示为NSString参数，但执行的是分类方法
//    [obj diffParam:@"123"];
    
    // 强制执行主类方法
    [self forceExcuteMainClassFunc:obj];
}

#pragma mark - 如何在分类和主类同名情况下，强制调用主类方法？
- (void)forceExcuteMainClassFunc:(TestObject *)obj {
    unsigned int methodCount;
    Class cls = obj.class;
    
    Method *methods = class_copyMethodList(cls, &methodCount);

    NSLog(@"Methods for class %s:", class_getName(cls));
    for (unsigned int i = methodCount - 1; i >= 0; i--) {
        // 唯一的方法，主类和分类不同
        Method method = methods[i];
        // 主类和分类获取到的SEL相同
        SEL selector = method_getName(method);
        
        // 可能会使带参数的函数崩溃，参数不一致错误
//        @try {
//            if ([obj respondsToSelector:selector]) {
//                [obj performSelector:selector];
//            }
//        } @catch (NSException *exception) {
//
//        } @finally {
//
//        }
        
        // 获取方法签名并检查
        // 依然是2次分类方法执行
//        NSMethodSignature *signature = [cls instanceMethodSignatureForSelector:selector];
//        if (signature != nil && strcmp([signature methodReturnType], "v") == 0 && [signature numberOfArguments] == 2) { // 无参数且返回void
//            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];
//            invocation.target = obj;
//            invocation.selector = selector;
//            [invocation invoke];
//        }
        
        // 先执行一次分类，再执行一次主类
        // diffParam : signature
//        <NSMethodSignature: 0xc7014248f09af422>
//            number of arguments = 3
//            frame size = 224
//            is special struct return? NO
//            return value: -------- -------- -------- --------
//                type encoding (v) 'v'
//                flags {}
//                modifiers {}
//                frame {offset = 0, offset adjust = 0, size = 0, size adjust = 0}
//                memory {offset = 0, size = 0}
//            argument 0: -------- -------- -------- --------
//                type encoding (@) '@'
//                flags {isObject}
//                modifiers {}
//                frame {offset = 0, offset adjust = 0, size = 8, size adjust = 0}
//                memory {offset = 0, size = 8}
//            argument 1: -------- -------- -------- --------
//                type encoding (:) ':'
//                flags {}
//                modifiers {}
//                frame {offset = 8, offset adjust = 0, size = 8, size adjust = 0}
//                memory {offset = 0, size = 8}
//            argument 2: -------- -------- -------- --------
//                type encoding (@) '@'
//                flags {isObject}
//                modifiers {}
//                frame {offset = 16, offset adjust = 0, size = 8, size adjust = 0}
//                memory {offset = 0, size = 8}
        // hello signature
//        <NSMethodSignature: 0xc7014248f09ae044>
//            number of arguments = 2
//            frame size = 224
//            is special struct return? NO
//            return value: -------- -------- -------- --------
//                type encoding (v) 'v'
//                flags {}
//                modifiers {}
//                frame {offset = 0, offset adjust = 0, size = 0, size adjust = 0}
//                memory {offset = 0, size = 0}
//            argument 0: -------- -------- -------- --------
//                type encoding (@) '@'
//                flags {isObject}
//                modifiers {}
//                frame {offset = 0, offset adjust = 0, size = 8, size adjust = 0}
//                memory {offset = 0, size = 8}
//            argument 1: -------- -------- -------- --------
//                type encoding (:) ':'
//                flags {}
//                modifiers {}
//                frame {offset = 8, offset adjust = 0, size = 8, size adjust = 0}
//                memory {offset = 0, size = 8}
        NSMethodSignature *signature = [obj methodSignatureForSelector:selector];
        if (signature && strcmp([signature methodReturnType], "v") == 0 && [signature numberOfArguments] == 2) {
            IMP imp = method_getImplementation(method);
            void (*func)(id, SEL) = (void *)imp;
            
            @try {
                func(obj, selector);
            } @catch (NSException *exception) {
                NSLog(@"Exception when calling selector %@: %@", NSStringFromSelector(selector), exception);
            }
            break;
        }
    }
    
    
    free(methods);

}

@end
