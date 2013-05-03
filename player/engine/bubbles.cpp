//
//  bubbles.cpp
//  PlayerGL
//
//  Created by Karim DRIDI on 02/05/13.
//  Copyright (c) 2013 Karim DRIDI. All rights reserved.
//

#include <player/engine/bubbles.h>

#include <player/commons/file.h>
#include <player/commons/http.h>

player::engine::bubbles::bubbles()
: program(true)
{
}

player::engine::bubbles::~bubbles()
{
}

void player::engine::bubbles::initialize(void)
{
    char filename[1024];
    
    sprintf(filename, "shaders/%s", "bubbles");
    program.add(GL_VERTEX_SHADER, player::commons::file::read(filename, "vs"));
    program.add(GL_FRAGMENT_SHADER, player::commons::file::read(filename, "fs"));
    
    const GLfloat data[] = { - 1.0, - 1.0, 1.0, - 1.0, - 1.0, 1.0, 1.0, - 1.0, 1.0, 1.0, - 1.0, 1.0 };
    
    GLuint buffer;
    glGenBuffers(1, &buffer);
    glBindBuffer( GL_ARRAY_BUFFER, buffer );
    glBufferData( GL_ARRAY_BUFFER, GL_FLOAT, data, GL_STATIC_DRAW );
    
    GLuint position = program.getAttributeLocation("position");
    glBindBuffer(GL_ARRAY_BUFFER, buffer);
    glVertexAttribPointer( position, 2, GL_FLOAT, false, 0, 0 );
    glEnableVertexAttribArray( position );
    
    program.use();
}

#include <math.h>


void player::engine::bubbles::reshape(GLfloat width, GLfloat height)
{
    printf("%d, %d\n", int(width), int(height));
    glViewport(0, 0, width, height);
    glUniform2f( program.getUniformLocation("resolution"), width, height);
    GLint size = static_cast<GLint>(width * height / 5000.0);
    
    {
#define N 100
        size = 10;
        glUniform1i( program.getUniformLocation("size"), size );
        
        static int n = 100;


        static GLfloat bubbles[4 * 100];
        for (int i = 0; i < n; ++i) {
            
            float pha =     sin(float(i) * 548.13 + 1.0) * 0.5 + 0.5;
            float siz =     sin(float(i) * 851.15 + 5.0) * 0.5 + 0.5;
            float pox =     sin(float(i) * 322.55 + 4.1) * width / height;
            float rad = 0.05 + 0.25 * siz;

            bubbles[4 * i + 0] = pha;
            bubbles[4 * i + 1] = siz;
            bubbles[4 * i + 2] = pox;
            bubbles[4 * i + 3] = rad;
        }
        glUniform4fv( program.getUniformLocation("bubbles"), n, bubbles );

        static GLfloat col_values[3 * N];
        static double v1[] = { 0.94, 0.3, 0.0 };
        static double v2[] = { 0.10, 0.4, 0.8 };
        for (int i = 0; i < n; ++i) {
            auto mix = [] (const double x, const double y, const double a) -> double {
                return x * (1. - a) + y * a;
            };
            double a = 0.5 + 0.5 * sin(float(i) * 1.2 + 1.9);
            double x = mix(v1[0], v2[0], a);
            double y = mix(v1[1], v2[1], a);
            double z = mix(v1[2], v2[2], a);
            col_values[3 * i + 0] = float(x);
            col_values[3 * i + 1] = float(y);
            col_values[3 * i + 2] = float(z);
        }
        glUniform3fv( program.getUniformLocation("colors"), n, col_values );

        // 1080 x 1920
        // 9 x 16
        // 640 / 360

#undef N
    }

}

void player::engine::bubbles::update(float dt)
{
    static float time = 0.f;
    time += dt;
    
    glUniform1f( program.getUniformLocation("time"), time);
    
}

void player::engine::bubbles::draw(void)
{
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    glDrawArrays( GL_TRIANGLES, 0, 6 );
}