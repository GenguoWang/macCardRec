//
//  ControlState.h
//  testMacOc
//
//  Created by Kingo Wang on 15/9/3.
//  Copyright (c) 2015年 Kingo Wang. All rights reserved.
//

#ifndef __testMacOc__ControlState__
#define __testMacOc__ControlState__

#include <stdio.h>
namespace kingo
{
    class Action
    {
    public:
        enum ActionType{KEY,MOUSE};
        enum KeyValue{
            KEY_ESC,
            KEY_O,
            KEY_LEFT,
            KEY_RIGHT,
            KEY_UP,
            KEY_DOWN
        };
        ActionType type;
        int keyVal;
        double mouseX,mouseY;
    };
    
    class State
    {
    public:
        virtual State *handleAction(Action act) = 0;
        virtual ~State();
    };
    
    class InitState:public State
    {
    public:
        virtual State *handleAction(Action act);
    };
    
    class MainCaptureState:public State
    {
    private:
        int step;
        double left,top,right,bottom;
    public:
        MainCaptureState();
        virtual State *handleAction(Action act);
    };
    
    class StateManager{
    private:
        State *currentState;
    public:
        StateManager();
        void handleAction(Action act);
    };
}

#endif /* defined(__testMacOc__ControlState__) */
