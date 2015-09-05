//
//  Util.cpp
//  testMacOc
//
//  Created by Kingo Wang on 15/9/3.
//  Copyright (c) 2015年 Kingo Wang. All rights reserved.
//

#include "Util.h"
bool is_border(cv::Mat& edge, uchar color)
{
    cv::Mat im = edge.clone().reshape(0,1);
    
    bool res = true;
    for (int i = 0; i < im.cols; ++i)
        res &= (color == im.at<uchar>(0,i));
    
    return res;
}

/**
 * Function to auto-cropping image
 *
 * Parameters:
 *   src   The source image
 *   dst   The destination image
 */
void autocrop(cv::Mat& src, cv::Mat& dst)
{
    cv::Rect win(0, 0, src.cols, src.rows);
    
    std::vector<cv::Rect> edges;
    edges.push_back(cv::Rect(0, 0, src.cols, 1));
    edges.push_back(cv::Rect(src.cols-2, 0, 1, src.rows));
    edges.push_back(cv::Rect(0, src.rows-2, src.cols, 1));
    edges.push_back(cv::Rect(0, 0, 1, src.rows));
    
    cv::Mat edge;
    int nborder = 0;
    uchar color = 255;
    
    bool next;
    
    do {
        edge = src(cv::Rect(win.x, win.height-2, win.width, 1));
        if (next = is_border(edge, color))
            win.height--;
    }
    while (next && win.height > 0);
    
    do {
        edge = src(cv::Rect(win.width-2, win.y, 1, win.height));
        if (next = is_border(edge, color))
            win.width--;
    }
    while (next && win.width > 0);
    
    do {
        edge = src(cv::Rect(win.x, win.y, win.width, 1));
        if (next = is_border(edge, color))
            win.y++, win.height--;
    }
    while (next && win.y <= src.rows);
    
    do {
        edge = src(cv::Rect(win.x, win.y, 1, win.height));
        if (next = is_border(edge, color))
            win.x++, win.width--;
    }
    while (next && win.x <= src.cols);
    
    dst = src(win);
}