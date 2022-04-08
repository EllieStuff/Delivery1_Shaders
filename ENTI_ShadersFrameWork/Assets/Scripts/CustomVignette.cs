using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System;
using UnityEngine.Rendering.PostProcessing;

//Needed to let unity serialize this and extend PostProcessEffectSettings
[Serializable]
//Using [PostProcess()] attrib allows us to tell Unity that the class holds postproccessing data. 
[PostProcess(renderer: typeof(CustomPostproVignette),//First parameter links settings with actual renderer
            PostProcessEvent.AfterStack,//Tells Unity when to execute this postpro in the stack
            "Custom/Vignette")] //Creates a menu entry for the effect
                                    //Forth parameter that allows to decide if the effect should be shown in scene view
public sealed class VignetteSettings : PostProcessEffectSettings
{
    [Range(0.0f, 10.0f), Tooltip("Vignette Effect Intensity.")]
    public FloatParameter intensity = new FloatParameter { value = 0.8f };

    [Range(0.0f, 5.0f), Tooltip("Vignette Effect Strength.")]
    public FloatParameter strength = new FloatParameter { value = 1.0f };

    [Tooltip("Vignette Effect Center")]
    public Vector2Parameter center = new Vector2Parameter { value = new Vector2(0, 0) };
    
    [Tooltip("Vignette Effect AffectedAxis")]
    public Vector2Parameter axisEffect = new Vector2Parameter { value = new Vector2(1, 1) };
    
    [Tooltip("Vignette Effect ColorInside")]
    public ColorParameter colorInside = new ColorParameter { value = new Color(1, 1, 1, 1) };

    [Range(1, 5), Tooltip("Vignette Effect Roundness.")]
    public IntParameter roundness = new IntParameter { value = 1 };

    [Range(0.0f, 1.0f), Tooltip("Vignette Effect Blend.")]
    public FloatParameter blend = new FloatParameter { value = 1.0f };
}

public class CustomPostproVignette : PostProcessEffectRenderer<VignetteSettings>//<T> is the setting type
{
    public override void Render(PostProcessRenderContext context)
    {
        //We get the actual shader property sheet
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/Vignette"));

        //Set the uniform value for our shader
        sheet.properties.SetFloat("_intensity", settings.intensity);
        sheet.properties.SetFloat("_strength", settings.strength);
        sheet.properties.SetVector("_center", settings.center);
        sheet.properties.SetVector("_axisEffect", settings.axisEffect);
        sheet.properties.SetColor("_colorInside", settings.colorInside);
        sheet.properties.SetFloat("_roundness", settings.roundness);
        sheet.properties.SetFloat("_blend", settings.blend);

        //We render the scene as a full screen triangle applying the specified shader
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}

