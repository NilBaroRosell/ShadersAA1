Shader "Hidden/Custom/Vignette"
{
    HLSLINCLUDE
        // StdLib.hlsl holds pre-configured vertex shaders (VertDefault), varying structs (VaryingsDefault), and most of the data you need to write common effects.
#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

        TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

    float _vignetteSize;

    float4 Frag(VaryingsDefault i) : SV_Target
    {
        float2 uv = i.texcoord;
        float4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv);
        uv -= 0.5;
        float vignette = 1.0 - pow(dot(uv, uv), 1);
        vignette = pow(vignette, _vignetteSize);
        col *= vignette;

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