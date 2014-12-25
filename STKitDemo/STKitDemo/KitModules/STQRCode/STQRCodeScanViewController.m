//
//  SSQRCodeScanViewController.m
//  STKitDemo
//
//  Created by SunJiangting on 14-2-20.
//  Copyright (c) 2014年 SunJiangting. All rights reserved.
//

#import "STQRCodeScanViewController.h"
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface STQRCodeScanViewController () <AVCaptureMetadataOutputObjectsDelegate> {
    // 是否在向下扫描
    BOOL _scanDown;
    CADisplayLink *_displayLink;
    BOOL _hasInitialCamera;
}

@property(nonatomic) AVCaptureDevice *device;
@property(nonatomic) AVCaptureDeviceInput *deviceInput;
@property(nonatomic) AVCaptureMetadataOutput *deviceOutput;
@property(nonatomic) AVCaptureSession *session;

@property(nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property(nonatomic) UIImageView *scanLineView;
@property   UIImageView *backgroundView;

@end

@implementation STQRCodeScanViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        if (STGetSystemVersion() < 7) {
            self = nil;
        }
        NSInteger count = [[AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo] count];
        if (count < 1) {
            self = nil;
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    
    CGFloat width = self.view.width, height = self.view.height;
    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.backgroundColor = [UIColor colorWithWhite:0x0 alpha:0.3];
    [dismissButton setTitle:@"取消" forState:UIControlStateNormal];
    dismissButton.frame = CGRectMake(0, height - 50, width, 50);
    dismissButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    [dismissButton addTarget:self action:@selector(dismissActionFired:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:dismissButton];

    UILabel *introductionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 40, width - 30, 50)];
    introductionLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    introductionLabel.backgroundColor = [UIColor clearColor];
    introductionLabel.numberOfLines = 2;
    introductionLabel.textColor = [UIColor whiteColor];
    introductionLabel.text = @"将二维码对准STLogServer中的二维码，可以接收指令";
    [self.view addSubview:introductionLabel];

    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((width - 300) / 2, (height - 350) / 2 , 300, 300)];
    imageView.image = [UIImage imageNamed:@"scan_background"];
    [self.view addSubview:imageView];
    self.backgroundView = imageView;
    
    _scanDown = YES;
    _scanLineView = [[UIImageView alloc] initWithFrame:CGRectMake((width - 220) / 2, imageView.top + 10, 220, 2)];
    _scanLineView.image = [UIImage imageNamed:@"scan_line"];
    [self.view addSubview:_scanLineView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(paintLoopFired)];
        [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_displayLink invalidate];
    if ([_session isRunning]) {
         [_session stopRunning];
    }
}

- (void)dismissActionFired:(id)sender {
    [self dismissAnimated:YES];
}

- (void)paintLoopFired {
    CGRect frame = _scanLineView.frame;
    if (_scanDown) {
        frame.origin.y += 2;
        if (frame.origin.y >= (self.backgroundView.bottom - 10)) {
            _scanDown = NO;
        }
    } else {
        frame.origin.y -= 2;
        if (frame.origin.y < (self.backgroundView.top + 10)) {
            _scanDown = YES;
        }
    }
    _scanLineView.frame = frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self _initialCamera];
}

- (void)_initialCamera {
    if (_hasInitialCamera) {
        if (![_session isRunning]) {
            [_session startRunning];
        }
        return;
    }
    // Device
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

    // Input
    self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:nil];

    // Output
    self.deviceOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.deviceOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];

    // Session
    _session = [[AVCaptureSession alloc] init];
    [_session setSessionPreset:AVCaptureSessionPresetHigh];
    if ([_session canAddInput:self.deviceInput]) {
        [_session addInput:self.deviceInput];
    }

    if ([_session canAddOutput:self.deviceOutput]) {
        [_session addOutput:self.deviceOutput];
    }

    // 条码类型 AVMetadataObjectTypeQRCode
    self.deviceOutput.metadataObjectTypes = @[AVMetadataObjectTypeQRCode];

    // Preview
    _previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = CGRectInset(self.backgroundView.frame, 5,5);
    [self.view.layer insertSublayer:_previewLayer atIndex:0];

    [_session startRunning];
    _hasInitialCamera = YES;
}


- (void)captureOutput:(AVCaptureOutput *)captureOutput
    didOutputMetadataObjects:(NSArray *)metadataObjects
              fromConnection:(AVCaptureConnection *)connection {
    NSString *stringValue=[metadataObjects.firstObject stringValue];
    if (!_continueWhenScaned) {
         [_session stopRunning];
    }
    if (self.scanCompletionHandler) {
        self.scanCompletionHandler(self, stringValue, nil);
    }
}

- (void)dismissAnimated:(BOOL)animated {
    [_displayLink invalidate];
    if ([_session isRunning]) {
        [_session stopRunning];
    }
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
