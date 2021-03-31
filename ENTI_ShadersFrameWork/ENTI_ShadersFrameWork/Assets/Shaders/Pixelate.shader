Shader "Hidden/Custom/Pixelate"
{
    HLSLINCLUDE
        // StdLib.hlsl holds pre-configured vertex shaders (VertDefault), varying structs (VaryingsDefault), and most of the data you need to write common effects.
#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

        TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

    float _xRes;
    float _yRes;
    float4 Frag(VaryingsDefault i) : SV_Target
    {
        float2 uv = i.texcoord;
        uv.x = floor(uv.x * _xRes) / _xRes;
        uv.y = floor(uv.y * _yRes) / _yRes;
        float4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv);
        // Return the result
        return col;
    }
        ENDHLSL

        SubShader
    {
        Cull Off ZWrite Off ZTest Always
            Pass
        {
            HLSLPROGRAM
                #pragma vertex VertDefault
                #pragma fragment Frag
            ENDHLSL
        }
    }
}

