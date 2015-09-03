//
//  ControlState.cpp
//  testMacOc
//
//  Created by Kingo Wang on 15/9/3.
//  Copyright (c) 2015年 Kingo Wang. All rights reserved.
//

#include "ControlState.h"
#include "App.h"
namespace kingo
{
    State::~State(){}
    
    State * InitState::handleAction(Action act)
    {
        if(act.type == Action::KEY && act.keyVal == Action::KEY_O)
        {
            return new MainCaptureState();
        }
        return this;
    }
    
    MainCaptureState::MainCaptureState():step(0){}
    
    State * MainCaptureState::handleAction(Action act)
    {
        if(act.type == Action::MOUSE)
        {
            if(step == 0)
            {
                step = 1;
                left = act.mouseX;
                top = act.mouseY;
                return this;
            }
            else if(step == 1)
            {
                right = act.mouseX;
                bottom = act.mouseY;
                gApp->setMainRect(left, top, right, bottom);
                return new InitState();
            }
        }
        return this;
    }
    
    StateManager::StateManager()
    {
        currentState = new InitState();
    }
    
    StateManager::~StateManager()
    {
        if(currentState) delete currentState;
    }
    
    void StateManager::handleAction(Action act)
    {
        State *next = currentState->handleAction(act);
        if(next != currentState)
        {
            delete currentState;
            currentState = next;
        }
    }
}
