Shader "Unlit/BlurCSShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
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
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float4 blur(sampler2D img, float2 uvv, float2 resolution, float2 direction){ 
                float4 color = float4(0.01,0.01,0.1, 01);
                float2 off1 = float2(1.3333333333333333, 1.3333333333333333)* direction;
                color += tex2D(img, uvv).rgba* 0.29411764705882354;
                color += tex2D(img, uvv + (off1 / resolution)) * 0.35294117647058826;
                color += tex2D(img, uvv - (off1 / resolution)) * 0.35294117647058826;
                return color; 
            }


            fixed4 frag (v2f i) : SV_Target
            {
                float2 uv  = i.uv;
                float f =  0.5 + 0.5 * cos(_Time.y + uv.xyx + float3(0., 0.2, 4.));
                float3 col =float3(f, f, f);

                // sample the texture
                fixed4 color = tex2D(_MainTex, i.uv);
                color = blur(_MainTex, uv, _ScreenParams.xy, uv * 10.);
                return color;
            }
            ENDCG
        }
    }
}
