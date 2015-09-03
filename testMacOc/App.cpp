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
    App::App():mainRect(0,0,100,100),stateManager(new StateManager()){}
    
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
    }
    
    cv::Rect App::getMainRect()
    {
        return mainRect;
    }
    void App::handleAction(Action act)
    {
        stateManager->handleAction(act);
    }
}
