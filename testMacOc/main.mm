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

std::string DataPrefix = "/Users/kingo/Documents/Projects/learnCV/learnCV/data/";
std::string TmpPrefix = "/Users/kingo/Documents/Projects/learnCV/learnCV/tmp/";

extern "C" {
#include <lua.h>
#include <lauxlib.h>
#include <lualib.h>
}

lua_State *g_L;
char labelName[] = {'2','3','4','5','6','7','8','9','T','J','Q','K','A','B'};
int getLabel(const char *name);
int getLabel(lua_State *L,const char *name);
int getLabel(const char *name){
    return getLabel(g_L,name);
}

int getLabel(lua_State *L, const char *name) {
    double z;
    /* push functions and arguments */
    lua_getglobal(L, "getLabel");  /* function to be called */
    lua_pushstring(L,name);
    /* do the call (1 arguments, 1 result) */
    if (lua_pcall(L, 1, 1, 0) != 0)
    {
        fprintf(stderr, "%s\n", lua_tostring(L, -1));
        lua_pop(L, 1);  /* pop error message from the stack */
    }
    /* retrieve result */
    z = lua_tonumber(L, -1);
    lua_pop(L, 1);  /* pop returned value */
    return z;
}

void setUpLua()
{
    lua_State *L = luaL_newstate();
    g_L = L;
    luaopen_io(L);
    luaopen_base(L);
    luaopen_table(L);
    luaopen_string(L);
    luaopen_math(L);
    luaL_openlibs(L);
    int s = luaL_dofile(L, (DataPrefix+"getLabel.lua").c_str());
    if(s){
        fprintf(stderr, "%s\n", lua_tostring(L, -1));
        lua_pop(L, 1);  /* pop error message from the stack */
    }
}

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
        //NSPoint mousePoint = [NSEvent ]
            CGEventRef event = CGEventCreate(nil);
            CGPoint loc = CGEventGetLocation(event);
            NSLog(@"%f %f",loc.x,loc.y);
            CFRelease(event);
        
         */
        Mat screenShot = getScreenShot();
        showMat = screenShot(cv::Rect(0,0,100,100));
        CGFloat height = screenShot.size[0];
        imshow("main",showMat);//must before add global monitor
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
            gApp->handleAction(act);
        }];
        
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
        setUpLua();
        while(true)
        {
            int key = waitKey(500);
            if(key == 27) break; //ESC
            //cout << "key: " << key << endl;
            if(key > 0)
            {
                kingo::Action act;
                act.type = kingo::Action::KEY;
                act.keyVal = key;
                gApp->handleAction(act);
            }
            Mat screenShot = getScreenShot();
            Mat show = screenShot(gApp->getMainRect());
            
            cv::Rect cardRect = gApp->cardRect();
            double interval = gApp->cardInterval();
            string label;
            for (int i = 0; i < 5; ++i)
            {
                if(cardRect.x+cardRect.width > show.size[1]) break;
                if(cardRect.y+cardRect.height > show.size[0]) break;
                Mat card = show(cardRect);
                Mat gray;
                cvtColor(card, gray, CV_RGB2GRAY);
                threshold(gray, gray, 80, 255, THRESH_BINARY);
                resize(gray, gray, cv::Size(12,18), 0.5, 0.5);
                imshow(string("out")+char('0'+i),gray);
                string outFileName = TmpPrefix + string("out") + char('0'+i) +".jpg";
                imwrite(outFileName,gray);
                int idx = getLabel(outFileName.c_str());
                if(idx >=1 && idx <= 14)
                {
                    std::cout << labelName[idx-1] << std::endl;
                    label += labelName[idx-1];
                }
                else{
                    std::cout << "unknow" << std::endl;
                }
                cardRect.x += interval;
            }
            
            cv::resize(show,show,cv::Size(),0.25,0.25);
            imshow("main",show);
            
        }
    }
    return 0;
}
