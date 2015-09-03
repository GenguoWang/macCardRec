//
//  main.m
//  testMacOc
//
//  Created by Kingo Wang on 15/8/31.
//  Copyright (c) 2015年 Kingo Wang. All rights reserved.
//

#include <opencv2/opencv.hpp>
#include "App.h"
#import <Foundation/Foundation.h>
#import <AppKit/AppKit.h>
#include <string>
using namespace cv;
using std::ifstream;
using std::ofstream;
using std::fstream;
using std::string;
using std::cout;
using std::endl;

kingo::App *gApp;

Mat matFromCGImageRef(CGImageRef imageRef)
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGFloat cols = CGImageGetWidth(imageRef);
    CGFloat rows = CGImageGetHeight(imageRef);
    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    
    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,                 // Pointer to backing data
                                                    cols,                      // Width of bitmap
                                                    rows,                     // Height of bitmap
                                                    8,                          // Bits per component
                                                    cvMat.step[0],              // Bytes per row
                                                    colorSpace,                 // Colorspace
                                                    kCGImageAlphaNoneSkipLast |
                                                    kCGBitmapByteOrderDefault); // Bitmap info flags
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), imageRef);
    CGContextRelease(contextRef);
    return cvMat;
}

Mat getScreenShot()
{
    CGImageRef screenShot = CGWindowListCreateImage(CGRectInfinite, kCGWindowListOptionOnScreenOnly, kCGNullWindowID, kCGWindowImageDefault);
    Mat screenMat = matFromCGImageRef(screenShot);
    CGImageRelease(screenShot);
    return screenMat;
}

Mat showMat;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        /*
        std::string DataPrefix = "/Users/kingo/Documents/Projects/learnCV/learnCV/data/";
        std::string filename = DataPrefix+"card0.png";
        CGEventRef event = CGEventCreateMouseEvent(NULL, kCGEventMouseMoved, CGPointMake(10,10), kCGMouseButtonLeft);
        CGEventPost(kCGHIDEventTap, event);
        NSLog(@"Hello, World!");
        NSLog(@"Wgg Hello, World!");
        Mat org = imread(filename);
//        imshow("org", org);
        
        
        cout << screenMat.size[0] << " " << screenMat.size[1] << endl;
        showMat = screenMat(cv::Rect(0,0,100,100));
        imshow("org",showMat);
        
        
         */
        Mat screenShot = getScreenShot();
        showMat = screenShot(cv::Rect(0,0,100,100));
        CGFloat height = screenShot.size[0];
        id globalHandler =
        [NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseUpMask handler:^(NSEvent *) {
            NSLog(@"left click");
            NSPoint mouseLoc;
            mouseLoc = [NSEvent mouseLocation]; //get current mouse position
            NSLog(@"Mouse location:");
            NSLog(@"x = %f",  mouseLoc.x);
            NSLog(@"y = %f",  mouseLoc.y);
            kingo::Action act;
            act.type = kingo::Action::MOUSE;
            act.mouseX = mouseLoc.x*2;
            act.mouseY = height - mouseLoc.y*2;
            imshow("org",showMat);
            //gApp->handleAction(act);
        }];
        //[NSEvent removeMonitor:globalHandler];
        
        [NSEvent addLocalMonitorForEventsMatchingMask:NSLeftMouseUpMask handler:^NSEvent *(NSEvent * aa) {
            NSLog(@"local left click");
            NSPoint mouseLoc;
            mouseLoc = [NSEvent mouseLocation]; //get current mouse position
            NSLog(@"Mouse location:");
            NSLog(@"x = %f",  mouseLoc.x);
            NSLog(@"y = %f",  mouseLoc.y);
            return aa;
        }];
        gApp = new kingo::App();
        while(true)
        {
            int key = waitKey(500);
            if(key == 27) break; //ESC
            cout << "key: " << key << endl;
            Mat screenShot = getScreenShot();
            Mat show = screenShot(gApp->getMainRect());
            imshow("main",show);
            //NSPoint mousePoint = [NSEvent ]
            /*o
            CGEventRef event = CGEventCreate(nil);
            CGPoint loc = CGEventGetLocation(event);
            NSLog(@"%f %f",loc.x,loc.y);
            CFRelease(event);
             */
            
        }
    }
    return 0;
}
