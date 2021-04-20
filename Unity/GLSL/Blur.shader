Shader "GLSL/Blur Shader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    { 
        Pass
        {
            GLSLPROGRAM
            uniform sampler2D _MainTex;
            uniform vec4 _MainTex_ST;

            #include "UnityCG.glslinc"
            #ifdef VERTEX
            void main(){
                gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
            }
            #endif

            #ifdef FRAGMENT
            precision mediump float; 
            vec2 u_resolution = vec2(1280., 720.);

            vec4 blur(sampler2D img, vec2 uv, vec2 resolution, vec2 direction){
                vec4 color = vec4(0.0);
                vec2 off1 = vec2(1.3333333333333333)* direction;
                color += texture(img, uv).rgba* 0.29411764705882354;
                color += texture(img, uv + (off1 / resolution)) * 0.35294117647058826;
                color += texture(img, uv - (off1 / resolution)) * 0.35294117647058826;
                return color;
            }


            void main(){
                // vec2 uv = gl_FragCoord.xy / u_resolution.xy;
                vec2 uv = gl_FragCoord.xy / _ScreenParams.xy;
                vec3 col = 0.5 + 0.5*cos(_Time.y+uv.xyx+vec3(0,2,4));
                vec4 color = blur(_MainTex, uv, u_resolution.xy, uv * 10.); 

                gl_FragColor = color;
            }
            #endif
            ENDGLSL
        }
    }
}
