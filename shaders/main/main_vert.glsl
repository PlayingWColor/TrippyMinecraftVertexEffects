//Copyright © 2024 David Draper Jr

uniform vec3 cameraPosition;
uniform mat4 gbufferModelViewInverse; 
uniform mat4 gbufferModelView; 

uniform float frameTimeCounter;

varying vec2 texcoord;
varying vec2 lightcoord;

varying vec3 normal;
varying vec4 vertexColor;
varying float dis;
varying vec4 localPos;

void main()
{
    gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;

    localPos = gbufferModelViewInverse * (gl_ModelViewMatrix * gl_Vertex);
#ifdef ENTITIES
    //localPos *= 0.5;
#endif
    vec3 worldPos = localPos.xyz + cameraPosition;

    dis = distance(vec3(worldPos.x,0,worldPos.z), vec3(cameraPosition.x,0,cameraPosition.z));

    float powDis = pow(dis,2)/100;

    float sinDis = sin(dis/10 + frameTimeCounter*0.25)*(powDis/4);

#ifdef CLOUDS
#else
    vec3 offsetWorldPos = vec3(worldPos.x, worldPos.y+sinDis, worldPos.z);

    vec4 offsetLocalPos = vec4(offsetWorldPos-cameraPosition, localPos.w);

    gl_Position = gl_ProjectionMatrix * gbufferModelView * offsetLocalPos;
#endif
    texcoord = gl_MultiTexCoord0.st;

    lightcoord = mat2(gl_TextureMatrix[1]) * gl_MultiTexCoord1.st;
    lightcoord = (lightcoord * 33.05f / 32.0f) - (1.05f / 32.0f);

    normal = gl_NormalMatrix * gl_Normal;

    vertexColor = gl_Color;

}