Shader "Hidden/Custom/Vignette"
{
	HLSLINCLUDE
		// StdLib.hlsl holds pre-configured vertex shaders (VertDefault), varying structs (VaryingsDefault), and most of the data you need to write common effects.
#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"

		TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);


	float _intensity;
	float _strength;
	int _roundness;
	float4 Frag(VaryingsDefault i) : SV_Target
	{
		float2 darkCoord = (i.texcoord * 2.0f) - 1.0f;
		darkCoord = pow(abs(darkCoord), _roundness); //Squares Vignette shape --> //For some reason it doesn't work with variables???
		float factor = length(darkCoord) * _intensity;
		factor = pow(factor, _strength); //Makes transition stronger
		factor = 1 - clamp(0, 1, factor);
		//factor = smoothstep(1, -1, factor); //Can use instead of clamp

		float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord) * factor;


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
