Shader "Hidden/Custom/Blur"
{
	HLSLINCLUDE
	// StdLib.hlsl holds pre-configured vertex shaders (VertDefault), varying structs (VaryingsDefault), and most of the data you need to write common effects.
	#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
	
	TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);

	#define E 2.71828182846

	float _intensity;
	float _blend;
	float _deviation;
	float2 _dir;
	int _iterations;

	float4 Frag(VaryingsDefault i) : SV_Target
	{
		float4 originalColor = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);
		float4 color = originalColor;
		float sum = _iterations;

		for (float index = -1; index < _iterations; index++) 
		{
			float offset = ((index / _iterations - 1) - 0.5) * _intensity;
			float2 uv = i.texcoord + float2(_dir.x * offset, _dir.y * offset);
			float devSquared = _deviation * _deviation;
			float gauss = (1 / sqrt(2 * PI * devSquared)) * pow(E, -((offset * offset) / (2 * devSquared)));
			sum += gauss;
			color += SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, uv) * gauss;
		}

		color = color / sum;

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
