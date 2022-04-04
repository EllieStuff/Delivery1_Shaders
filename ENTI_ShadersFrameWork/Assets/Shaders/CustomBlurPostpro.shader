Shader "Hidden/Custom/Blur"
{
	HLSLINCLUDE
	// StdLib.hlsl holds pre-configured vertex shaders (VertDefault), varying structs (VaryingsDefault), and most of the data you need to write common effects.
	#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
	
	TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
	
	float _intensity;
	float4 Frag(VaryingsDefault i) : SV_Target
	{
		int power = 2;

		float4 color = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);
		//float4 color2 = color * 2;
		//float2 coord = i.texcoord + float2(1, 1);
		//for (int i = -1; i < 2; i++) {
		//	if (i == 0)
		//		i.texcoord = pow(i.texcoord, power + 1);
		//	else
		//		i.texcoord = pow(i.texcoord + float2(i, 0), power);
		//}
		//for (int i = -1; i < 2; i++) {
		//	if (i == 0)
		//		i.texcoord = pow(i.texcoord, power + 1);
		//	else
		//		i.texcoord = pow(i.texcoord + float2(0, i), power);
		//}
		
		float horVal;
		float vertVal;

		i.texcoord = pow(i.texcoord, power + 1);
		i.texcoord = pow(i.texcoord - float2(1, 0), power);
		i.texcoord = pow(i.texcoord + float2(1, 0), power);

		i.texcoord = pow(i.texcoord, power + 1);
		i.texcoord = pow(i.texcoord - float2(0, 1), power);
		i.texcoord = pow(i.texcoord + float2(0, 1), power);

		float4 color2 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

		color.rgb = lerp(color.rgb, color2.rgb, _intensity.xxx);
		// Return the result
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
