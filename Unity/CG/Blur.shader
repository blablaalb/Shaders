Shader "Custom/Effects/Blur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Offset ("Offset", Range(1, 100)) = 10
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                fixed2 uv : TEXCOORD0;
            };

            struct v2f
            {
                fixed2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION; 
            };

            half _Offset;
            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            { 
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 blur(sampler2D img, fixed2 uvv, half2 resolution, half2 direction){ 
                fixed4 color = fixed4(0.0, 0.0, 0.0, 0.0);
                half2 off1 = half2(1.3333333333333333, 1.3333333333333333)* direction;
                color += tex2D(img, uvv).rgba* 0.29411764705882354;
                color += tex2D(img, uvv + (off1 / resolution)) * 0.35294117647058826;
                color += tex2D(img, uvv - (off1 / resolution)) * 0.35294117647058826;
                return color; 
            }


            fixed4 frag (v2f i) : SV_Target
            {
                fixed2 uv  = i.uv;
                half f =  0.5 + 0.5 * cos(_Time.y + uv.xyx + half3(0., 0.2, 4.));
                half3 col =half3(f, f, f);

                // sample the texture
                fixed4 color = tex2D(_MainTex, i.uv);
                color = blur(_MainTex, uv, _ScreenParams.xy, uv * _Offset);
                return color;
            }
            ENDCG
        }
    }
}
