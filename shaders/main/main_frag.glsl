//Copyright © 2024 David Draper Jr

varying vec2 texcoord;
varying vec2 lightcoord;

varying vec3 normal;
varying vec4 vertexColor;
varying float dis;
varying vec4 localPos;

uniform sampler2D texture;

void main()
{

    vec4 color = texture2D(texture, texcoord) * vertexColor;
    
    float depth = gl_FragCoord.z / gl_FragCoord.w / 100;

    gl_FragData[0] = color;//vec4(depth,depth,depth,color.a);// * dis;
    gl_FragData[1] = vec4(normal*0.5+0.5,1.0);
#ifdef CLOUDS
    gl_FragData[0] = vec4(color.rgb, 0.0);
#endif

#ifdef ENTITIES
    if(vertexColor.a < 1.0)
        return;
#endif
    gl_FragData[2] = vec4(lightcoord, 0.0, 1.0);

}