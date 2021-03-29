Shader "Unlit/Phong"
{
    Properties
    {
        _ambientIntensity("Ambient Light Intensity", Range(0,1)) = 0.25
        _diffuseIntensity("Diffuse Light Intensity", Range(0,1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

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


            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                //o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToWorldNormal(v.normal);
                return o;
            }
            float _ambientIntensity; // how strong is it?
            float _diffuseIntensity; // how strong is it?

            fixed4 frag (v2f i) : SV_Target
            {
                // we assign color to the surfaces
                fixed4 colorObject = fixed4(1,0,0,1);
                // 3 phong model light components
                // we assign color to the ambient term
                fixed4 ambientLightCol = fixed4(1,1,1,1);
                // we calculate the ambient 
                fixed4 ambientComp = ambientLightCol * _ambientIntensity;

                //DiffusseComponent
                fixed4 lightColor = fixed4 (1, 1, 1, 1);
                float3 lightDirection = float3 (0, 1, 0);

                fixed4 diffuseComp = lightColor * _diffuseIntensity * dot(lightDirection, i.worldNormal);
                
                return colorObject * (ambientComp + diffuseComp);
            }
            ENDCG
        }
    }
}
