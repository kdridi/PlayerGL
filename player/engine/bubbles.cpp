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

void player::engine::bubbles::setSize(int size) {
    size = 10;
    glUniform1i( program.getUniformLocation("size"), size );
}


void player::engine::bubbles::reshape(GLfloat width, GLfloat height)
{
    glViewport(0, 0, width, height);
    glUniform2f( program.getUniformLocation("resolution"), width, height);
    setSize(static_cast<GLint>(width * height / 5000.0));
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