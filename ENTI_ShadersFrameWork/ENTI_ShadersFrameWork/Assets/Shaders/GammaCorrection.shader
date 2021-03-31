Shader "Hidden/Custom/GammaCorrection"
{
    HLSLINCLUDE
        // StdLib.hlsl holds pre-configured vertex shaders (VertDefault), varying structs (VaryingsDefault), and most of the data you need to write common effects.
#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

        TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

    int _linearToGamma;
    float4 Frag(VaryingsDefault i) : SV_Target
    {
        float2 uv = i.texcoord;
        float powValue;
        if (_linearToGamma == 1) powValue = 2.2f;
        else powValue = 0.45f;
        float4 col = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv);
        col.x = pow(col.x, powValue);
        col.y = pow(col.y, powValue);
        col.z = pow(col.z, powValue);
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

