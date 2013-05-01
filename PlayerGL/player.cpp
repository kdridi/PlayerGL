//
//  Player.cpp
//  PlayerGL
//
//  Created by Karim DRIDI on 30/04/13.
//  Copyright (c) 2013 Karim DRIDI. All rights reserved.
//

#include "player.h"

#include <boost/assert.hpp>

player::player()
: program(true)
{
    
}

player::~player()
{
    
}

player* player::instance()
{
    static player instance;
    return &instance;
}

void player::prepareOpenGL(void)
{
    program.add(GL_VERTEX_SHADER, player::instance()->readFile("shader_player.vs"));
    program.add(GL_FRAGMENT_SHADER, player::instance()->readFile("shader_player.fs"));

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
    
    t.reset();
}

void player::reshape(GLfloat width, GLfloat height)
{
    glViewport(0, 0, width, height);
    glUniform2f( program.getUniformLocation("resolution"), width, height);
}

void player::update(void)
{
    glUniform1f( program.getUniformLocation("time"), t.get());
    
    glClear( GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT );
    glDrawArrays( GL_TRIANGLES, 0, 6 );

}

void player::mouse(GLfloat x, GLfloat y)
{
    glUniform2f( program.getUniformLocation("mouse"), x, y);
}
