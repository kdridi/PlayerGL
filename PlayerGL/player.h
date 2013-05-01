//
//  Player.h
//  PlayerGL
//
//  Created by Karim DRIDI on 30/04/13.
//  Copyright (c) 2013 Karim DRIDI. All rights reserved.
//

#ifndef __PlayerGL__Player__
#define __PlayerGL__Player__


#include "shaders.h"

#include <sys/time.h>

class timer {
    long interval;
    long start;
    long elapsed;
    long counter;

    inline static long now() {
        timeval time;
        gettimeofday(&time, NULL);
        return (time.tv_sec * 1000) + (time.tv_usec / 1000);
    }
public:
    inline timer(long i = 1000)
    : interval(i) {
        reset();
    }
    inline void reset() {
        start = now();
        elapsed = counter = 0;
    }
    inline float get() {
        GLfloat result = static_cast<GLfloat>(now() - start);
        counter += 1;
        GLfloat delay = result - elapsed;
        if (delay > interval) {
            printf("FPS: %.02f\n", static_cast<GLfloat>(1000 * counter) / delay);
            elapsed = result;
            counter = 0;
        }

        return result / 1000.f;
    }
};

class player {
    timer t;
    player();
    opengl::shader::program program;
public:
    ~player();
    static player* instance();
    static std::string readFile(const char* name, const char* extension = nullptr);
    void prepareOpenGL(void);
    void reshape(GLfloat width, GLfloat height);
    void mouse(GLfloat x, GLfloat y);
    void update(void);
};

#endif /* defined(__PlayerGL__Player__) */
