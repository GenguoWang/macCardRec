//
//  App.h
//  testMacOc
//
//  Created by Kingo Wang on 15/9/3.
//  Copyright (c) 2015年 Kingo Wang. All rights reserved.
//

#ifndef __testMacOc__App__
#define __testMacOc__App__

#include <stdio.h>
#include <opencv2/opencv.hpp>
#include "ControlState.h"
namespace kingo
{
    class App{
    private:
        cv::Rect mainRect;
        StateManager *stateManager;
        
    public:
        App();
        ~App();
        cv::Rect getMainRect();
        void setMainRect(double left,double top,double right, double bottom);
        void handleAction(Action act);
    };
}

#endif /* defined(__testMacOc__App__) */
