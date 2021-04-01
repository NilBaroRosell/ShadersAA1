using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess(renderer: typeof(VignetteRender),
    PostProcessEvent.AfterStack,
    "Custom/Vignette")]
public sealed class Vignette : PostProcessEffectSettings
{
    [Range(0, 10), Tooltip("Vignette size.")]
    public IntParameter VignetteSize = new IntParameter { value = 3 }; 
}

public class VignetteRender : PostProcessEffectRenderer<Vignette>//<T> is the setting type
{
    public override void Render(PostProcessRenderContext context)
    {
        //We get the actual shader property sheet
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/Vignette"));
        //Set the uniform value for our shader
        sheet.properties.SetInt("_vignetteSize", settings.VignetteSize);
        //We render the scene as a full screen triangle applying the specified shader
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}