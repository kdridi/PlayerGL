//
//  program.h
//  PlayerGL
//
//  Created by Karim DRIDI on 02/05/13.
//  Copyright (c) 2013 Karim DRIDI. All rights reserved.
//

#ifndef __player_commons_shader_program__
#define __player_commons_shader_program__

#include <OpenGL/gl.h>

#include <boost/assert.hpp>
#include <boost/noncopyable.hpp>

#include <set>
#include <map>

namespace player {
    namespace commons {
        namespace shader {
            struct resource : public boost::noncopyable {
                const GLuint ref;
                const bool debug;
                inline resource(GLuint r, bool d)
                : ref(r)
                , debug(d) {
                }
                inline void assertNoError() {
                    GLenum error = glGetError();
                    if (debug && error != GL_NO_ERROR) {
                        
                        const GLsizei bufSize = 1024;
                        GLsizei length = 0;
                        GLchar infoLog[1024];
                        
                        if (glIsShader(ref)) {
                            glGetShaderInfoLog(ref, bufSize, &length, infoLog);
                        } else {
                            glGetProgramInfoLog(ref, bufSize, &length, infoLog);
                        }
                        
                        if (length > 0) {
                            std::cerr << infoLog << std::endl;
                        }
                    }
                    BOOST_ASSERT(error == GL_NO_ERROR);
                }
            };
            
            class program : public boost::noncopyable, private resource {
            public:
                inline program(bool debug = false)
                : boost::noncopyable()
                , resource(glCreateProgram(), debug)
                , linked(false)
                , shaders()
                , attachments()
                , uniformLocations()
                , attributeLocation() {
                    assertNoError();
                }
                inline ~program() {
                    glDeleteProgram(ref);
                    assertNoError();
                }
                inline void add(GLenum type, const std::string& source) {
                    BOOST_ASSERT(linked == false);
                    if (shaders.find(type) == shaders.end()) {
                        shaders[type] = std::shared_ptr<shader>(new shader(type, debug));
                    }
                    shaders[type]->insert(source);
                }
                inline void use(void) {
                    glUseProgram(link());
                    assertNoError();
                }
                inline GLint getUniformLocation(const char* name) {
                    if (uniformLocations.find(name) == uniformLocations.end()) {
                        uniformLocations[name] = glGetUniformLocation(link(), static_cast<const GLchar*>(name));
                    }
                    return uniformLocations[name];
                }
                inline GLint getAttributeLocation(const char* name) {
                    if (attributeLocation.find(name) == attributeLocation.end()) {
                        attributeLocation[name] = glGetAttribLocation(link(), static_cast<const GLchar*>(name));
                    }
                    return attributeLocation[name];
                }
                
            private:
                class shader;
                typedef std::shared_ptr<shader> shader_ptr;
                
                class attachment;
                typedef std::unique_ptr<attachment> attachment_ptr;
                
                bool linked;
                std::map<const GLenum, shader_ptr> shaders;
                std::map<const GLenum, attachment_ptr> attachments;
                std::map<const std::string, GLuint> uniformLocations;
                std::map<const std::string, GLuint> attributeLocation;
                
                inline GLuint link(void) {
                    if (linked == false) {
                        BOOST_ASSERT(shaders.size() > 0);
                        std::for_each(shaders.begin(), shaders.end(), [this](const std::pair<GLenum, shader_ptr>& it) {
                            attachment* ptr = new attachment(this, it.second);
                            BOOST_ASSERT(ptr != nullptr);
                            attachments[it.first] = attachment_ptr(ptr);
                        });
                        glLinkProgram(ref);
                        assertNoError();
                        
                        linked = true;
                    }
                    return ref;
                }
                
                class shader : public boost::noncopyable, public std::set<std::string>, private resource {
                    bool compiled;
                    
                public:
                    inline shader(GLenum type, bool debug)
                    : boost::noncopyable()
                    , std::set<std::string>()
                    , resource(glCreateShader(type), debug)
                    , compiled(false) {
                        assertNoError();
                    }
                    inline ~shader() {
                        glDeleteShader(ref);
                        assertNoError();
                    }
                    inline GLuint compile(void) {
                        if (compiled == false) {
                            BOOST_ASSERT(size() > 0);
                            
                            typedef const GLchar* source_t;
                            source_t* array = static_cast<source_t*>(calloc(size(), sizeof(source_t)));
                            BOOST_ASSERT(array != nullptr);
                            
                            GLuint count = 0;
                            std::for_each(begin(), end(), [&array, &count] (const std::string& source) {
                                array[count++] = static_cast<source_t>(source.c_str());
                            });
                            BOOST_ASSERT(size() == count);
                            
                            glShaderSource(ref, count, array, nullptr);
                            free(array);
                            assertNoError();
                            
                            glCompileShader(ref);
                            assertNoError();
                            
                            compiled = true;
                        }
                        return ref;
                    }
                };
                
                class attachment : public boost::noncopyable {
                    program* const program_ptr;
                    program::shader_ptr shader_ptr;
                public:
                    inline attachment(program* const program, const program::shader_ptr& shader)
                    : boost::noncopyable()
                    , program_ptr(program)
                    , shader_ptr(shader) {
                        glAttachShader(program_ptr->ref, shader_ptr->compile());
                        program_ptr->assertNoError();
                    }
                    inline ~attachment() {
                        glDetachShader(program_ptr->ref, shader_ptr->compile());
                        program_ptr->assertNoError();
                    }
                };
            };
            
        }
    }
}

#endif /* defined(__player_commons_shader_program__) */
