// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/PBR"
{
    Properties
    {
        _ambientIntensity("Ambient Light Intensity", Range(0,1)) = 0.25
        _diffuseIntensity("Diffuse Light Intensity", Range(0,1)) = 0.5
        _roughness("Roughness", Range(0,1)) = 1
        _fresnelParam("Fresnel parameter", Range(0,1)) = 1
        _r("R", Range(0,1)) = 1
        _g("G", Range(0,1)) = 0
        _b("B", Range(0,1)) = 0
        _x("Light Direction X", Range(-1,1)) = -0.5
        _y("Light Direction Y", Range(-1,1)) = 1
        _z("Light Direction Z", Range(-1,1)) = -0.5
    }
        SubShader
    {
        Tags { "RenderType" = "Opaque" }

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
                float3 normal: NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 worldNormal: TEXCOORD1;
            };

            float _fresnelParam;
            float3 worldPos;

            float3 halfVector(float3 v, float3 v2)
            {
                return normalize((v + v2) / 2.0);
            }

            float Distribution(float3 h, float3 n, float rough)
            {
                float aa = rough * rough;
                float dotV = dot(n, h);
                dotV = dotV * dotV;
                return aa / (3.14159265f * pow(((dotV * (aa - 1.0) + 1.0)), 2.0));
            }

            float Fresnel(float3 l, float3 h)
            {
                return pow((_fresnelParam + (1.0 - _fresnelParam) * (1.0 - dot(h, l))), 5.0);
            }

            float Geometry(fixed3 l, fixed3 n, fixed3 h, fixed3 v)
            {
                float dotNL = dot(n, l);
                float dotNV = dot(n, v);
                float dotVH = dot(v, h);
                dotVH = dotVH * dotVH;
                return dotNL * dotNV / dotVH;
            }

            float BRDF(float3 l, float3 n, float3 h, float3 v, float rough)
            {
                return Distribution(h, n, rough) * Fresnel(l, n) * Geometry(l, n, h, v) / (4.0 * dot(n, l) * dot(n, v));
            }

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }

            float _ambientIntensity; // how strong is it?
            float _diffuseIntensity; // how strong is it?
            float _roughness;
            float _r;
            float _g;
            float _b;
            float _x;
            float _y;
            float _z;

            fixed4 frag(v2f i) : SV_Target
            {
                // we assign color to the surfaces
                fixed4 colorObject = fixed4(_r,_g,_b,1);
                // 3 phong model light components
                // we assign color to the ambient term
                fixed4 ambientLightCol = fixed4(1,1,1,1);
                // we calculate the ambient 
                fixed4 ambientComp = ambientLightCol * _ambientIntensity;

                float3 camPos = _WorldSpaceCameraPos;
                float3 view = normalize(_WorldSpaceCameraPos.xyz - worldPos.xyz);

                //DiffusseComponent
                fixed4 lightColor = fixed4(1, 1, 1, 1);
                float3 lightDirection = float3 (_x, _y, _z);

                fixed4 diffuseComp = lightColor * _diffuseIntensity * dot(lightDirection, i.worldNormal);

                fixed4 specularComp = lightColor * BRDF(lightDirection, i.worldNormal, halfVector(lightDirection, view), view, _roughness);

                return colorObject * (ambientComp + diffuseComp + specularComp);
            }
            ENDCG
        }
    }
}
