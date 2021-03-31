using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.Rendering.PostProcessing;

//Needed to let unity serialize this and extend PostProcessEffectSettings
[Serializable]
//Using [PostProcess()] attrib allows us to tell Unity that the class holds postproccessing data. 
[PostProcess(renderer: typeof(GammaCorrection),//First parameter links settings with actual renderer
    PostProcessEvent.AfterStack,//Tells Unity when to execute this postpro in the stack
    "Custom/GammaCorrection")] //Creates a menu entry for the effect
                        //Forth parameter that allows to decide if the effect should be shown in scene view
public sealed class GammaCorrectionSettings : PostProcessEffectSettings
{
    [Range(0, 1), Tooltip("Linear to Gamma.")]
    public IntParameter linearToGamma = new IntParameter { value = 1 }; //Custom parameter class, full list at: /PostProcessing/Runtime/
                                                                               //The default value is important, since is the one that will be used for blending if only 1 of volume has this effect
}

public class GammaCorrection : PostProcessEffectRenderer<GammaCorrectionSettings>//<T> is the setting type
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