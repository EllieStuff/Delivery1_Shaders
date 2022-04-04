Shader "Hidden/Custom/Blur"
{
	HLSLINCLUDE
	// StdLib.hlsl holds pre-configured vertex shaders (VertDefault), varying structs (VaryingsDefault), and most of the data you need to write common effects.
	#include "Packages/com.unity.postprocessing/PostProcessing/Shaders/StdLib.hlsl"
	
	TEXTURE2D_SAMPLER2D(_MainTex, sampler_MainTex);
	
	float _intensity;
	float4 Frag(VaryingsDefault i) : SV_Target
	{
		float power = 1.0f;

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
		
		float4 colors[4];
		colors[0] = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord + float2(1, 0)) / 16;
		colors[1] = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord + float2(-1, 0)) / 16;
		colors[2] = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord + float2(0, 1)) / 16;
		colors[3] = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord + float2(0, -1)) / 16;
		
		color.rgb = color.rgb / 16;
		color.rgb = pow(color.rgb, power + 1);
		color.rgb = lerp(color.rgb, pow(colors[0].rgb, power), _intensity.xxx);
		color.rgb = lerp(color.rgb, pow(colors[1].rgb, power), _intensity.xxx);
		color.rgb = lerp(color.rgb, pow(colors[2].rgb, power), _intensity.xxx);
		color.rgb = lerp(color.rgb, pow(colors[3].rgb, power), _intensity.xxx);


		//i.texcoord = pow(i.texcoord, power);
		//i.texcoord = pow(i.texcoord + float2(1, 0), power);
		//i.texcoord = pow(i.texcoord - float2(1, 0), power);

		////color2 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);
		////color.rgb = lerp(color.rgb, color2.rgb, _intensity.xxx);


		//i.texcoord = pow(i.texcoord, power);
		//i.texcoord = pow(i.texcoord + float2(0, 1), power);
		//i.texcoord = pow(i.texcoord - float2(0, 1), power);

		////color2 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);
		////color.rgb = lerp(color.rgb, color2.rgb, _intensity.xxx);

		///*i.texcoord = pow(i.texcoord + float2(1, 0), power);

		//i.texcoord = pow(i.texcoord, power + 1);
		//i.texcoord = pow(i.texcoord - float2(0, 1), power);
		//i.texcoord = pow(i.texcoord + float2(0, 1), power);*/

		//float4 color2 = SAMPLE_TEXTURE2D(_MainTex, sampler_MainTex, i.texcoord);

		//color.rgb = lerp(color.rgb, color2.rgb, _intensity.xxx);
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
