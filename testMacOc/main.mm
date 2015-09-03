//
//  main.m
//  testMacOc
//
//  Created by Kingo Wang on 15/8/31.
//  Copyright (c) 2015年 Kingo Wang. All rights reserved.
//

#import <opencv2/opencv.hpp>
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

Mat showMat;

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // insert code here...
        std::string DataPrefix = "/Users/kingo/Documents/Projects/learnCV/learnCV/data/";
        std::string filename = DataPrefix+"card0.png";
        CGEventRef event = CGEventCreateMouseEvent(NULL, kCGEventMouseMoved, CGPointMake(10,10), kCGMouseButtonLeft);
        CGEventPost(kCGHIDEventTap, event);
        NSLog(@"Hello, World!");
        NSLog(@"Wgg Hello, World!");
        Mat org = imread(filename);
//        imshow("org", org);
        CGImageRef screenShot = CGWindowListCreateImage(CGRectInfinite, kCGWindowListOptionOnScreenOnly, kCGNullWindowID, kCGWindowImageDefault);
        Mat screenMat = matFromCGImageRef(screenShot);
        CGImageRelease(screenShot);
        cout << screenMat.size[0] << " " << screenMat.size[1] << endl;
        CGFloat height = screenMat.size[0];
        showMat = screenMat(cv::Rect(0,0,100,100));
        imshow("org",showMat);
        //id globalHandler =
        [NSEvent addGlobalMonitorForEventsMatchingMask:NSLeftMouseUpMask handler:^(NSEvent *) {
            NSLog(@"left click");
            NSPoint mouseLoc;
            mouseLoc = [NSEvent mouseLocation]; //get current mouse position
            NSLog(@"Mouse location:");
            NSLog(@"x = %f",  mouseLoc.x);
            NSLog(@"y = %f",  mouseLoc.y);
            CGFloat orignX = mouseLoc.x*2-100;
            CGFloat orignY = height - mouseLoc.y*2-100;
            if(orignX < 0) orignX = 0;
            if(orignY < 0) orignY = 0;
            showMat = screenMat(cv::Rect(orignX,orignY,200,200));
            imshow("org",showMat);
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
        while(true)
        {
            int key = waitKey(500);
            if(key == 27) break; //ESC
            cout << "key: " << key << endl;
            //NSPoint mousePoint = [NSEvent ]
            /*
            CGEventRef event = CGEventCreate(nil);
            CGPoint loc = CGEventGetLocation(event);
            NSLog(@"%f %f",loc.x,loc.y);
            CFRelease(event);
             */
            
        }
    }
    return 0;
}
