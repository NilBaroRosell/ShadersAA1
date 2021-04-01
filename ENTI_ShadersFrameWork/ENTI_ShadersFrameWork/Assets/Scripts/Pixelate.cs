using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.Rendering.PostProcessing;

[Serializable]

[PostProcess(renderer: typeof(PixelateRender),
    PostProcessEvent.AfterStack,
    "Custom/Pixelate")] 
public sealed class Pixelate : PostProcessEffectSettings
{
    [Range(0f, 1920f), Tooltip("X Resolution.")]
    public FloatParameter XResolution = new FloatParameter { value = 320.0f };
    [Range(0f, 1080f), Tooltip("Y Resolution.")]
    public FloatParameter YResolution = new FloatParameter { value = 180.0f };
}

public class PixelateRender : PostProcessEffectRenderer<Pixelate>//<T> is the setting type
{
    public override void Render(PostProcessRenderContext context)
    {
        //We get the actual shader property sheet
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/Pixelate"));
        //Set the uniform value for our shader
        sheet.properties.SetFloat("_xRes", settings.XResolution);
        sheet.properties.SetFloat("_yRes", settings.YResolution);
        //We render the scene as a full screen triangle applying the specified shader
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}