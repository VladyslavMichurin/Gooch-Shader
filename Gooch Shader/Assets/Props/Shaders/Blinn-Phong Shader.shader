Shader "_MyShaders/02)Blinn-Phong Shader"
{
   Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Tint ("Tint", Color) = (1, 1, 1, 1)

        _Smoothness ("Smoothness", Range(0.01,1)) = 0.2
    }
    SubShader
    {
        Tags 
        { 
            "RenderType"="Opaque" 
        }

        Pass
        {
            Name "Blinn-Phong"

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityPBSLighting.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;

                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;

                float3 normal : TEXCOORD1;
                float3 viewDir : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float3 _Tint;

            float _Smoothness;

            v2f vert (appdata v)
            {
                v2f o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                o.normal = UnityObjectToWorldNormal(v.normal);
                o.viewDir = normalize(WorldSpaceViewDir(v.vertex));

                return o;
            }

            float3 GetAlbedo(v2f i)
            {
                return tex2D(_MainTex, i.uv) * _Tint;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                 i.normal = normalize(i.normal);

                float NdotL = DotClamped(i.normal, _WorldSpaceLightPos0);
                float3 diffuse = GetAlbedo(i) * NdotL;

                float3 halfwayVec = normalize(_WorldSpaceLightPos0 + i.viewDir);
                float3 specular = DotClamped(halfwayVec, i.normal);
                specular = pow(specular, _Smoothness * 100);

                return float4(diffuse + specular, 1);
            }
            ENDCG
        }
    }
}
