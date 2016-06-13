//
//  ImagePreview.m
//  ImagePreviewDemo
//
//  Created by 王文建 on 16/6/1.
//  Copyright © 2016年 Scorp. All rights reserved.
//

#import "ImagePreview.h"

@interface ImagePreview ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) NSMutableArray *customConstraints;

@property (strong, nonatomic) UIScrollView *scrollView;
@property (retain, nonatomic) UIImageView *sImgView;

@end;
@implementation ImagePreview

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
        
        
    }
    return self;
}

-(void)commonInit{
    
    _customConstraints = [[NSMutableArray alloc]init];
    UIView *view = nil;
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"ImagePreview" owner:self options:nil];
    //    for(id object in objs ) {
    //        if ([object isKindOfClass:[UIView class]]) {
    //            view = object;
    //        }
    //    }
    view = [objs objectAtIndex:0];
    if (view) {
        _containerView = view;
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:view];
        [self setNeedsUpdateConstraints];
    }
}

-(void)updateConstraints{
    [super updateConstraints];
    [self removeConstraints:self.customConstraints];
    [self.customConstraints removeAllObjects];
    if (self.containerView != nil) {
        UIView *view = self.containerView;
        NSDictionary *views = NSDictionaryOfVariableBindings(view);
        [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:views]];
        [self.customConstraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:views]];
        [self addConstraints:self.customConstraints];
    }
    
    [self initScrollView];
   
}

-(void)initScrollView{
    UIWindow *window = self.window;
    _scrollView =[[UIScrollView alloc] initWithFrame:window.frame];
    _scrollView.bounces = true;    //反弹
    _scrollView.scrollEnabled = true ; //滚动
//    _scrollView.minimumZoomScale = 0.5;
//    _scrollView.maximumZoomScale = 2.0;
    _scrollView.delegate = self;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(closeView:)];
    [_scrollView addGestureRecognizer:tapGes];
    
    _sImgView = [[UIImageView alloc] init];
//    _sImgView.frame = _scrollView.frame;
//    _sImgView.contentMode = UIViewContentModeScaleAspectFit;
//    _sImgView.userInteractionEnabled = YES;
    [_scrollView addSubview:_sImgView];
    
//    UIPinchGestureRecognizer *pinchGes =
//    [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGesAction:)] ;
//    [_sImgView addGestureRecognizer:pinchGes];
}

- (IBAction)tapView:(id)sender {
//    NSLog(@"Tap");
    [self initialSImgView];
//    _sImgView.image = self.imageView.image;
}

-(void)closeView:(UITapGestureRecognizer*)tap{
    [_scrollView removeFromSuperview];
}


-(void)initialSImgView{
    UIWindow *window = self.window;
    UIImage *image = self.imageView.image;
    CGSize maxSize = _scrollView.frame.size;
    CGFloat widthRatio = maxSize.width/image.size.width;
    CGFloat heightRatio = maxSize.height / image.size.height;
    CGFloat initialZoon = (widthRatio > heightRatio)? heightRatio:widthRatio;
    _scrollView.maximumZoomScale = 5.0;
    _scrollView.minimumZoomScale = initialZoon;
    [_scrollView setContentSize:image.size];
    [_scrollView setZoomScale:1];
    [window addSubview:_scrollView];
    CGRect imageViewRect=[_imageView convertRect: _imageView.bounds  toView:window];
    _sImgView.frame = imageViewRect;
    _sImgView.image = image;
    _scrollView.backgroundColor = [UIColor clearColor];

    [UIView animateWithDuration:0.3 animations:^{
        _scrollView.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.8];

        if(_scrollView.frame.size.width/_scrollView.frame.size.height > image.size.width/image.size.height){
            _sImgView.frame = CGRectMake(0,0,image.size.width / image.size.height * _scrollView.frame.size.height  ,_scrollView.frame.size.height);
            _sImgView.center = CGPointMake(_scrollView.frame.size.width/2.0, _scrollView.center.y);
        }else {
            _sImgView.frame = CGRectMake(0, 0, _scrollView.frame.size.width, image.size.height/image.size.width*_scrollView.frame.size.width);
            _sImgView.center = CGPointMake(_scrollView.center.x, _scrollView.frame.size.height/2.0);
        }
    }];
}


-(void)pinchGesAction:(UIPinchGestureRecognizer*)recognizer{
    NSLog(@"Pinch scale: %f", recognizer.scale);
    if (_scrollView.contentSize.width / _scrollView.frame.size.width > 4 && recognizer.scale >1) {
        return ;
    }
    if (recognizer.scale < 1 && _sImgView.frame.size.width / _scrollView.frame.size.width < 1  ) {
        NSLog(@"%f",_sImgView.frame.size.width / _scrollView.frame.size.width);
        _sImgView.frame = _scrollView.frame;
        return ;
    }
    _sImgView.transform = CGAffineTransformScale(_sImgView.transform, recognizer.scale, recognizer.scale);
    _scrollView.contentSize = recognizer.view.frame.size ;
    CGPoint point = CGPointMake(_scrollView.contentSize.width/2, _scrollView.contentSize.height/2);

    _sImgView.center = point;
    [_scrollView setContentOffset:CGPointMake(point.x - _scrollView.frame.size.width /2 , point.y - _scrollView.frame.size.height/2)];
    recognizer.scale = 1;
}

- (nullable UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return _sImgView;
}     // return a view that will be scaled. if delegate returns nil, nothing happens

-(void)scrollViewDidZoom:(UIScrollView *)scrollView{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    _sImgView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                    scrollView.contentSize.height * 0.5 + offsetY);
}

@end
