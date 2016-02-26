/**
 *
 * RenderPipeline
 *
 * Copyright (c) 2014-2016 tobspr <tobias.springer1@gmail.com>
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 */

#version 430

// Shader used for the environment map

%DEFINES%

#define IS_ENVMAP_SHADER 1

#define USE_TIME_OF_DAY
#pragma include "render_pipeline_base.inc.glsl"
#pragma include "includes/shadows.inc.glsl"
#pragma include "includes/poisson_disk.inc.glsl"
#pragma include "includes/vertex_output.struct.glsl"
#pragma include "includes/material_output.struct.glsl"

%INCLUDES%
%INOUT%

uniform sampler2D p3d_Texture0;

layout(location=0) in VertexOutput vOutput;
layout(location=4) flat in MaterialOutput mOutput;

#pragma include "includes/forward_shading.inc.glsl"

layout(location=0) out vec4 result_specular;
layout(location=1) out vec4 result_diffuse;

void main() {

    vec3 basecolor = texture(p3d_Texture0, vOutput.texcoord).rgb * mOutput.color;
    // basecolor = pow(basecolor, vec3(2.2));

    %MATERIAL%

    vec3 ambient = get_forward_ambient(basecolor, mOutput.roughness);
    vec3 lighting = get_sun_shading(basecolor);

    // TODO: Forward shading for lights

    result_specular = vec4(ambient + lighting, 1);
    result_diffuse = vec4(lighting, 1);
    // result_diffuse = vec4(0,0 ,0, 1);
}
