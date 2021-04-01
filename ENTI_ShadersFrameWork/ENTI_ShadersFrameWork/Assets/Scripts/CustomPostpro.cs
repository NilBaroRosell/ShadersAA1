using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess(renderer: typeof(CustomPostproRender),
    PostProcessEvent.AfterStack,
    "Custom/InvertColors")]

public sealed class CustomPostpro : PostProcessEffectSettings
{
    [Range(0f, 1f), Tooltip("Effect Intensity.")]
    public FloatParameter blend = new FloatParameter { value = 0.0f }; //Custom parameter class, full list at: /PostProcessing/Runtime/
                                                                        //The default value is important, since is the one that will be used for blending if only 1 of volume has this effect
}

public class CustomPostproRender : PostProcessEffectRenderer<CustomPostpro>//<T> is the setting type
{
    public override void Render(PostProcessRenderContext context)
    {
        //We get the actual shader property sheet
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/InvertColors"));
        //Set the uniform value for our shader
        sheet.properties.SetFloat("_intensity", settings.blend);
        //We render the scene as a full screen triangle applying the specified shader
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}

