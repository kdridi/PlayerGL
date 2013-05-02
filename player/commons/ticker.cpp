//
//  ticker.cpp
//  PlayerGL
//
//  Created by Karim DRIDI on 02/05/13.
//  Copyright (c) 2013 Karim DRIDI. All rights reserved.
//

#include <player/commons/ticker.h>

#include <sys/time.h>
#include <stdio.h>

static unsigned long now() {
    timeval time;
    gettimeofday(&time, NULL);
    return (time.tv_sec * 1000) + (time.tv_usec / 1000);
}

::player::commons::ticker::ticker(long i)
: _interval(i) {
    reset();
}

void ::player::commons::ticker::reset() {
    _start = now();
    _elapsed = _counter = 0;
}

float ::player::commons::ticker::tick() {
    float result = static_cast<float>(now() - _start);
    _counter += 1;
    float delay = result - _elapsed;
    if (delay > _interval) {
        printf("FPS: %.02f\n", static_cast<float>(1000 * _counter) / delay);
        _elapsed = result;
        _counter = 0;
    }
    
    return result / 1000.f;
}
