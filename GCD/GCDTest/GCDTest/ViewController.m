//
//  ViewController.m
//  GCDTest
//
//  Created by Rui Hou on 2024/6/11.
//

#import "ViewController.h"
#import "GCDPerson.h"

@interface ViewController ()

@property (nonatomic, strong) NSLock *lock;
@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, strong) dispatch_queue_t concurrentQueue;

@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) dispatch_queue_t globalQueue;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dic = [[NSMutableDictionary alloc] init];
    self.lock = [[NSLock alloc] init];
    self.concurrentQueue = dispatch_queue_create("com.rui.concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    self.serialQueue = dispatch_queue_create("com.rui.serialQueue", DISPATCH_QUEUE_SERIAL);
    self.globalQueue = dispatch_get_global_queue(0, 0);
    
    UIButton *button1 = [[UIButton alloc] init];
    [button1 addTarget:self action:@selector(glabal:) forControlEvents:UIControlEventTouchUpInside];
    button1.frame = CGRectMake(100, 100, 200, 50);
    [button1 setTitle:@"全局队列" forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button1];
    
    UIButton *button2 = [[UIButton alloc] init];
    [button2 addTarget:self action:@selector(glabalReadLock:) forControlEvents:UIControlEventTouchUpInside];
    button2.frame = CGRectMake(100, 150, 200, 50);
    [button2 setTitle:@"全局队列和读NSLock" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button2];
    
    UIButton *button3 = [[UIButton alloc] init];
    [button3 addTarget:self action:@selector(multiReadSingleWrite:) forControlEvents:UIControlEventTouchUpInside];
    button3.frame = CGRectMake(100, 200, 200, 50);
    [button3 setTitle:@"栅栏函数实现多读单写" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button3];
    
    UIButton *button4 = [[UIButton alloc] init];
    [button4 addTarget:self action:@selector(barrierOnGlobal:) forControlEvents:UIControlEventTouchUpInside];
    button4.frame = CGRectMake(100, 250, 200, 50);
    [button4 setTitle:@"全局队列+栅栏函数" forState:UIControlStateNormal];
    [button4 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button4];
    
    UIButton *button5 = [[UIButton alloc] init];
    [button5 addTarget:self action:@selector(barrierOnSerial:) forControlEvents:UIControlEventTouchUpInside];
    button5.frame = CGRectMake(100, 300, 200, 50);
    [button5 setTitle:@"串行队列+栅栏函数" forState:UIControlStateNormal];
    [button5 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:button5];
}

- (void)glabal:(id)sender {
    // 全局任务，会打印多个不同的Person
    // 面试题：这段代码的问题？
    // crash，会出现Thread 10: EXC_BAD_ACCESS (code=EXC_I386_GPFLT)，没有适当的同步机制导致数据竞争问题
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger i = 0;
        while (i < 1000) {
            [self.lock lock];
            GCDPerson *person = [[GCDPerson alloc] init];
            person.age = i;
            self.dic[@"0"] = person;
            i++;
            [self.lock unlock];
        }
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger i = 0;
        while (i < 1000) {
            GCDPerson *person = self.dic[@"0"];
            NSLog(@"%@ %@", person, @(person.age));
            i++;
        }
    });
}

- (void)glabalReadLock:(id)sender {
    // 会打印中间的一个值 38或者308或者其他
    // 不会crash
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger i = 0;
        while (i < 1000) {
            [self.lock lock];
            GCDPerson *person = [[GCDPerson alloc] init];
            person.age = i;
            self.dic[@"0"] = person;
            i++;
            [self.lock unlock];
        }
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger i = 0;
        while (i < 1000) {
            [self.lock lock];
            GCDPerson *person = self.dic[@"0"];
            NSLog(@"%@ %@", person, @(person.age));
            [self.lock unlock];
            // 思考题：i++在lock中和lock外面是否有区别
            i++;
        }
    });
}

- (void)multiReadSingleWrite:(id)sender {
    // 相比NSLock性能更高
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger i = 0;
        while (i < 1000) {
            ///写要求:
            ///1.和读互斥:栅栏函数
            ///2.等所有读操作完成之后
            ///3.写操作不用等待结果:async
            dispatch_barrier_async(self.concurrentQueue, ^{
                GCDPerson *person = [[GCDPerson alloc] init];
                person.age = i;
                NSLog(@"%@", @(i));
                self.dic[@"0"] = person;
            });
            i++;
        }
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger i = 0;
        while (i < 1000) {
            ///读要求:
            ///1. 读操作要等结果:sync
            ///2.要和写操作互斥:在同一线程
            ///3.多读:concurrent_queue 并发线程
            dispatch_sync(self.concurrentQueue, ^{
                GCDPerson *person = self.dic[@"0"];
                NSLog(@"%@ %@", person, @(person.age));
            });
            i++;
        }
    });
}

- (void)barrierOnGlobal:(id)sender {
    // 可能不会按顺序执行，不可控，达不到栅栏函数效果
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger i = 0;
        while (i < 1000) {
            dispatch_barrier_async(self.globalQueue, ^{
                GCDPerson *person = [[GCDPerson alloc] init];
                person.age = i;
                NSLog(@"%@", @(i));
                self.dic[@"0"] = person;
            });
            i++;
        }
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger i = 0;
        while (i < 1000) {
            dispatch_sync(self.globalQueue, ^{
                GCDPerson *person = self.dic[@"0"];
                NSLog(@"%@ %@", person, @(person.age));
            });
            i++;
        }
    });
}

- (void)barrierOnSerial:(id)sender {
    // 单是这个case，看起来没什么问题，但执行时间较长，因为读写都是串行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger i = 0;
        while (i < 1000) {
            dispatch_barrier_async(self.serialQueue, ^{
                GCDPerson *person = [[GCDPerson alloc] init];
                person.age = i;
                NSLog(@"%@", @(i));
                self.dic[@"0"] = person;
            });
            i++;
        }
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSInteger i = 0;
        while (i < 1000) {
            dispatch_sync(self.serialQueue, ^{
                GCDPerson *person = self.dic[@"0"];
                NSLog(@"%@ %@", person, @(person.age));
            });
            i++;
        }
    });
}

@end
