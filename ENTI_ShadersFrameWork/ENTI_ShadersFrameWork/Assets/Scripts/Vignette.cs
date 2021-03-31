using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.Rendering.PostProcessing;

//Needed to let unity serialize this and extend PostProcessEffectSettings
[Serializable]
//Using [PostProcess()] attrib allows us to tell Unity that the class holds postproccessing data. 
[PostProcess(renderer: typeof(Vignette),//First parameter links settings with actual renderer
    PostProcessEvent.AfterStack,//Tells Unity when to execute this postpro in the stack
    "Custom/Vignette")] //Creates a menu entry for the effect
                       //Forth parameter that allows to decide if the effect should be shown in scene view
public sealed class VignetteSettings : PostProcessEffectSettings
{
    [Range(0, 10), Tooltip("Vignette size.")]
    public IntParameter VignetteSize = new IntParameter { value = 3 }; //Custom parameter class, full list at: /PostProcessing/Runtime/
                                                                       //The default value is important, since is the one that will be used for blending if only 1 of volume has this effect
}

public class Vignette : PostProcessEffectRenderer<VignetteSettings>//<T> is the setting type
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