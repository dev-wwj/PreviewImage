//
//  ViewController.m
//  ImagePreviewDemo
//
//  Created by 王文建 on 16/6/13.
//  Copyright © 2016年 Scorp. All rights reserved.
//

#import "ViewController.h"
#import "ImagePreview.h"
@interface ViewController ()
@property (weak, nonatomic) IBOutlet ImagePreview *imagePreview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _imagePreview.imageView.image = [UIImage imageNamed:@"PlaceholderCar.png"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
