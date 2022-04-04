Shader "Hidden/Custom/Blur"
{
	HLSLINCLUDE
	// StdLib.hlsl holds pre-configured vertex shaders (VertDefault), varying structs (VaryingsDefault), and most of the data you need to write common effects.
	#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
	
	TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
	
	float _intensity;
	float4 Frag(VaryingsDefault i) : SV_Target
	{
		float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

		for (float index = -1; index < 2; index++) {
			float2 uv = i.texcoord + float2(0, (index / 9 - 0.5) * _intensity);
			color += SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv) / 16;
		}

		for (float index = -1; index < 2; index++) {
			float2 uv = i.texcoord + float2((index / 9 - 0.5) * _intensity, 0);
			color += SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv) / 16;
		}

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
