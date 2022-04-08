Shader "Hidden/Custom/Vignette"
{
	HLSLINCLUDE
		// StdLib.hlsl holds pre-configured vertex shaders (VertDefault), varying structs (VaryingsDefault), and most of the data you need to write common effects.
#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);


	float _intensity;
	float _strength;
	float2 _center;
	float2 _axisEffect;
	float4 _colorInside;
	float4 _colorOutside;
	int _roundness;
	float _blend;
	//float factor;
	float4 Frag(VaryingsDefault i) : SV_Target
	{
		float4 originalColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

		float2 darkCoord = ((i.texcoord + _center) * 2.0f) - 1.0f;
		darkCoord = pow(abs(darkCoord), _roundness); //Squares Vignette shape --> //For some reason it doesn't work with variables???
		float factor = length(darkCoord * _axisEffect) * _intensity;
		factor = pow(factor, _strength); //Makes transition stronger
		//factor = 1 - clamp(0, 1, factor);
		factor = smoothstep(1, -1, factor); //Can use instead of clamp

		float4 color = originalColor * _colorInside * factor;
		color.rgb = lerp(originalColor.rgb, color.rgb, _blend.xxx);
		float factorColorThreshold = 0.4;
		//if(color.r < colorThreshold && color.g < colorThreshold && color.b < colorThreshold)
		
		float dist = distance(float2(0.5, 0.5), i.texcoord);
		color.rgb = lerp(color.rgb, _colorOutside.rgb, dist);
		//if (factor < factorColorThreshold) {
		//	color.rgb = lerp(color.rgb, _colorOutside.rgb, 1 - factor);
		//	//color = _colorOutside;
		//}

		//// Return the result
		return color;
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
