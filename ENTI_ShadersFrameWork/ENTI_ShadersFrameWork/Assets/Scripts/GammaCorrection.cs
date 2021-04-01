using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess(renderer: typeof(GammaCorrectionRender),
    PostProcessEvent.AfterStack,
    "Custom/GammaCorrection")]
public sealed class GammaCorrection : PostProcessEffectSettings
{
    [Range(0, 1), Tooltip("Linear to Gamma.")]
    public IntParameter linearToGamma = new IntParameter { value = 1 };
}

public class GammaCorrectionRender : PostProcessEffectRenderer<GammaCorrection>//<T> is the setting type
{
    public override void Render(PostProcessRenderContext context)
    {
        //We get the actual shader property sheet
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/GammaCorrection"));
        //Set the uniform value for our shader
        sheet.properties.SetInt("_linearToGamma", settings.linearToGamma);
        //We render the scene as a full screen triangle applying the specified shader
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}