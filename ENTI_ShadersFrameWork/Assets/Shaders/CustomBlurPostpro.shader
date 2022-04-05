Shader "Hidden/Custom/Blur"
{
	HLSLINCLUDE
	// StdLib.hlsl holds pre-configured vertex shaders (VertDefault), varying structs (VaryingsDefault), and most of the data you need to write common effects.
	#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
	
	TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
	
	float _intensity;
	float _blend;
	float4 Frag(VaryingsDefault i) : SV_Target
	{
		float4 originalColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);
		float4 color = originalColor;

		int iterations = 10;

		for (float index = -1; index < iterations; index++) {
			float2 uv = i.texcoord + float2(0, ((index / iterations-1) - 0.5) * _intensity);
			color += SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv);
		}

		color = color / iterations;

		color.rgb = lerp(originalColor.rgb, color.rgb, _blend.xxx);

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
