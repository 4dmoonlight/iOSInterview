//
//  ViewController.m
//  StringTest
//
//  Created by Rui Hou on 2024/6/14.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 打印的地址是否相同？
    NSString *dou = @"dou";
    NSMutableString *mdou = [NSMutableString stringWithString:dou];
    NSMutableString *mdou1 = mdou;
    NSString *fdou = @"dou";
    
    NSLog(@"%p, %p, %p, %p", dou, mdou, mdou1, fdou);
    
    mdou = nil;
    dou = nil;
    NSLog(@"%p, %p, %p, %p", dou, mdou, mdou1, fdou);
}


@end
