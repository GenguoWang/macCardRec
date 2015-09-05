//
//  App.cpp
//  testMacOc
//
//  Created by Kingo Wang on 15/9/3.
//  Copyright (c) 2015年 Kingo Wang. All rights reserved.
//

#include "App.h"
namespace kingo
{
    App::App():mainRect(0,0,100,100),rate(100.0/1280),stateManager(new StateManager()){}
    
    App::~App()
    {
        if(stateManager) delete stateManager;
    }
    void App::setMainRect(double left, double top, double right, double bottom)
    {
        mainRect.x = left;
        mainRect.y = top;
        mainRect.width = right-left;
        mainRect.height = bottom - top;
        rate = mainRect.width/1280.0;
    }
    
    cv::Rect App::getMainRect()
    {
        return mainRect;
    }
    
    cv::Rect App::cardRect()
    {
        cv::Rect rect;
        rect.x = 385*rate;
        rect.y = 270*rate;
        rect.width = 28*rate;
        rect.height = 40*rate;
        return rect;
    }
    double App::cardInterval()
    {
        return 103.5*rate;
    }
    void App::handleAction(Action act)
    {
        stateManager->handleAction(act);
    }
}
