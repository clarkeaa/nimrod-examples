//
//  NRViewController.m
//  NimrodIOS
//
//  Created by Aaron Clarke on 9/12/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "NRViewController.h"

#import "test.h"

@interface NRViewController ()

@end

@implementation NRViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

void NRViewControllerDoSomething(void)
{
    printf("%s\n", __func__);
}

-(void)viewDidAppear:(BOOL)animated
{
    printf("%d\n", adder(122, 123));
    Foobar* x = newFoobar("what!?", 1234);
    printf("%s\n", name(x));
    freeFoobar(x);
    nimDoSomething();
}

@end
