//
//  ViewController.m
//  Runloop
//
//  Created by Rui Hou on 2024/6/10.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIButton *button = [[UIButton alloc] init];
    [button setTitle:@"线程保活" forState:UIControlStateNormal];
    button.frame = CGRectMake(100, 100, 200, 100);
    [button addTarget:self action:@selector(threadActive:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button];
}

- (void)threadActive:(id)sender {
    // 多次点击创建多个NSThread实例
    NSThread *thread = [[NSThread alloc] initWithTarget:self selector:@selector(threadExcute:) object:nil];
    [thread start];
}

- (void)threadExcute:(id)sender {
    NSLog(@"%@", [NSThread currentThread]);
    
    // 未添加任何代码时，2可以执行，1不能执行
    // ** 事实上这两个方法看起来相似，都不是一个类和分类中的方法，afterDelay在NSRunloop.h中
//    [self performSelector:@selector(hello:) withObject:nil afterDelay:0.5]; // 1
//    [self performSelector:@selector(hello:)]; // 2
    
    // 3和4 都可以执行
    // 3 打印 Runloop Mode : DefaultMode
//    [self performSelector:@selector(hello:) withObject:@3 afterDelay:0.5]; // 3
//    [self performSelector:@selector(hello:) withObject:@4]; // 4
//    [[NSRunLoop currentRunLoop] run];
    
    // 5不执行，6执行
//    [[NSRunLoop currentRunLoop] run]; // runUntilDate 也一样
//    [self performSelector:@selector(hello:) withObject:@5 afterDelay:0.5]; // 5
//    [self performSelector:@selector(hello:) withObject:@6]; // 6
    
//    [self performSelector:@selector(hello:) withObject:@5 afterDelay:0.5]; // 5
//    [self performSelector:@selector(hello:) withObject:@6]; // 6

    NSLog(@"thread end %@", [NSThread currentThread]);
}

- (void)hello:(NSNumber *)number {
    NSLog(@"hello, %@", number);
    NSLog(@"Runloop Mode: %@", [[NSRunLoop currentRunLoop] currentMode]);
}


@end
