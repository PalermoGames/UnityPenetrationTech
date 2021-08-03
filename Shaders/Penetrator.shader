// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "PenetrationTech/Standard/Penetrator"
{
	Properties
	{
		_PenetratorOrigin("PenetratorOrigin", Vector) = (0,0,0,0)
		_PenetratorForward("PenetratorForward", Vector) = (0,0,1,0)
		_PenetratorLength("PenetratorLength", Float) = 1
		_PenetratorUp("PenetratorUp", Vector) = (0,1,0,0)
		_PenetratorRight("PenetratorRight", Vector) = (1,0,0,0)
		_OrificeOutWorldPosition1("OrificeOutWorldPosition1", Vector) = (0,0,0,0)
		_OrificeOutWorldPosition3("OrificeOutWorldPosition3", Vector) = (0,0,0,0)
		_OrificeWorldPosition("OrificeWorldPosition", Vector) = (0,0,0,0)
		_OrificeOutWorldPosition2("OrificeOutWorldPosition2", Vector) = (0,0,0,0)
		_OrificeWorldNormal("OrificeWorldNormal", Vector) = (0,0,0,0)
		_PenetrationDepth("PenetrationDepth", Range( -1 , 10)) = 0
		_PenetratorBlendshapeMultiplier("PenetratorBlendshapeMultiplier", Range( 0 , 100)) = 1
		_OrificeLength("OrificeLength", Float) = 0
		_PenetratorBulgePercentage("PenetratorBulgePercentage", Range( 0 , 1)) = 0
		_PenetratorCumProgress("PenetratorCumProgress", Range( -1 , 2)) = 0
		_PenetratorSquishPullAmount("PenetratorSquishPullAmount", Range( -1 , 1)) = 0
		_PenetratorCumActive("PenetratorCumActive", Range( 0 , 1)) = 0
		[Toggle(_DEFORM_BALLS_ON)] _DEFORM_BALLS("DEFORM_BALLS", Float) = 0
		[Toggle(_CLIP_DICK_ON)] _CLIP_DICK("CLIP_DICK", Float) = 0
		[Toggle(_NOBLENDSHAPES_ON)] _NOBLENDSHAPES("NOBLENDSHAPES", Float) = 0
		[Toggle(_INVISIBLE_WHEN_INSIDE_ON)] _INVISIBLE_WHEN_INSIDE("INVISIBLE_WHEN_INSIDE", Float) = 0
		_Cutoff( "Mask Clip Value", Float ) = 0.5
		_MainTex("MainTex", 2D) = "white" {}
		_MaskMap("MaskMap", 2D) = "gray" {}
		_BumpMap("BumpMap", 2D) = "bump" {}
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "TransparentCutout"  "Queue" = "Geometry+0" }
		Cull Back
		CGPROGRAM
		#pragma target 3.0
		#pragma shader_feature_local _DEFORM_BALLS_ON
		#pragma multi_compile_local __ _CLIP_DICK_ON
		#pragma multi_compile_local __ _INVISIBLE_WHEN_INSIDE_ON
		#pragma multi_compile_local __ _NOBLENDSHAPES_ON
		#pragma surface surf Standard keepalpha addshadow fullforwardshadows vertex:vertexDataFunc 
		struct Input
		{
			float2 uv_texcoord;
			float vertexToFrag250_g979;
		};

		uniform float _PenetratorBlendshapeMultiplier;
		uniform float _PenetratorLength;
		uniform float _PenetrationDepth;
		uniform float3 _PenetratorOrigin;
		uniform float3 _OrificeWorldPosition;
		uniform float3 _PenetratorUp;
		uniform float3 _PenetratorForward;
		uniform float _PenetratorBulgePercentage;
		uniform float _PenetratorSquishPullAmount;
		uniform float _PenetratorCumProgress;
		uniform float _PenetratorCumActive;
		uniform float _OrificeLength;
		uniform float3 _PenetratorRight;
		uniform float3 _OrificeWorldNormal;
		uniform float3 _OrificeOutWorldPosition1;
		uniform float3 _OrificeOutWorldPosition2;
		uniform float3 _OrificeOutWorldPosition3;
		uniform sampler2D _BumpMap;
		uniform float4 _BumpMap_ST;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _MaskMap;
		uniform float4 _MaskMap_ST;
		uniform float _Cutoff = 0.5;


		float3 MyCustomExpression20_g993( float3 bezierDerivitive, float3 forward, float3 up )
		{
			float bezierUpness = dot( bezierDerivitive , up);
			float3 bezierUp = lerp( up , -forward , saturate( bezierUpness ));
			float bezierDownness = dot( bezierDerivitive , -up );
			return normalize( lerp( bezierUp , forward , saturate( bezierDownness )) );
		}


		float3 MyCustomExpression20_g981( float3 bezierDerivitive, float3 forward, float3 up )
		{
			float bezierUpness = dot( bezierDerivitive , up);
			float3 bezierUp = lerp( up , -forward , saturate( bezierUpness ));
			float bezierDownness = dot( bezierDerivitive , -up );
			return normalize( lerp( bezierUp , forward , saturate( bezierDownness )) );
		}


		float3 MyCustomExpression20_g987( float3 bezierDerivitive, float3 forward, float3 up )
		{
			float bezierUpness = dot( bezierDerivitive , up);
			float3 bezierUp = lerp( up , -forward , saturate( bezierUpness ));
			float bezierDownness = dot( bezierDerivitive , -up );
			return normalize( lerp( bezierUp , forward , saturate( bezierDownness )) );
		}


		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertexNormal = v.normal.xyz;
			float3 VertexNormal259_g979 = ase_vertexNormal;
			float3 normalizeResult27_g991 = normalize( VertexNormal259_g979 );
			float3 temp_output_35_0_g979 = normalizeResult27_g991;
			float4 ase_vertexTangent = v.tangent;
			float3 normalizeResult31_g991 = normalize( ase_vertexTangent.xyz );
			float3 normalizeResult29_g991 = normalize( cross( normalizeResult27_g991 , normalizeResult31_g991 ) );
			float3 temp_output_35_1_g979 = cross( normalizeResult29_g991 , normalizeResult27_g991 );
			float3 temp_output_35_2_g979 = normalizeResult29_g991;
			float3 SquishDelta85_g979 = ( ( ( temp_output_35_0_g979 * v.texcoord2.x ) + ( temp_output_35_1_g979 * v.texcoord2.y ) + ( temp_output_35_2_g979 * v.texcoord2.z ) ) * _PenetratorBlendshapeMultiplier );
			float temp_output_234_0_g979 = length( SquishDelta85_g979 );
			float temp_output_11_0_g979 = max( _PenetrationDepth , 0.0 );
			float VisibleLength25_g979 = ( _PenetratorLength * ( 1.0 - temp_output_11_0_g979 ) );
			float3 DickOrigin16_g979 = _PenetratorOrigin;
			float4 appendResult132_g979 = (float4(_OrificeWorldPosition , 1.0));
			float4 transform140_g979 = mul(unity_WorldToObject,appendResult132_g979);
			float3 OrifacePosition170_g979 = (transform140_g979).xyz;
			float DickLength19_g979 = _PenetratorLength;
			float3 DickUp172_g979 = _PenetratorUp;
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 VertexPosition254_g979 = ase_vertex3Pos;
			float3 temp_output_27_0_g979 = ( VertexPosition254_g979 - DickOrigin16_g979 );
			float3 DickForward18_g979 = _PenetratorForward;
			float dotResult42_g979 = dot( temp_output_27_0_g979 , DickForward18_g979 );
			float BulgePercentage37_g979 = _PenetratorBulgePercentage;
			float temp_output_1_0_g985 = saturate( ( abs( ( dotResult42_g979 - VisibleLength25_g979 ) ) / ( DickLength19_g979 * BulgePercentage37_g979 ) ) );
			float temp_output_94_0_g979 = sqrt( ( 1.0 - ( temp_output_1_0_g985 * temp_output_1_0_g985 ) ) );
			float3 PullDelta91_g979 = ( ( ( temp_output_35_0_g979 * v.texcoord3.x ) + ( temp_output_35_1_g979 * v.texcoord3.y ) + ( temp_output_35_2_g979 * v.texcoord3.z ) ) * _PenetratorBlendshapeMultiplier );
			float dotResult32_g979 = dot( temp_output_27_0_g979 , DickForward18_g979 );
			float temp_output_1_0_g990 = saturate( ( abs( ( dotResult32_g979 - ( DickLength19_g979 * _PenetratorCumProgress ) ) ) / ( DickLength19_g979 * BulgePercentage37_g979 ) ) );
			float3 CumDelta90_g979 = ( ( ( temp_output_35_0_g979 * v.texcoord1.w ) + ( temp_output_35_1_g979 * v.texcoord2.w ) + ( temp_output_35_2_g979 * v.texcoord3.w ) ) * _PenetratorBlendshapeMultiplier );
			#ifdef _NOBLENDSHAPES_ON
				float3 staticSwitch390_g979 = VertexPosition254_g979;
			#else
				float3 staticSwitch390_g979 = ( VertexPosition254_g979 + ( SquishDelta85_g979 * temp_output_94_0_g979 * saturate( -_PenetratorSquishPullAmount ) ) + ( temp_output_94_0_g979 * PullDelta91_g979 * saturate( _PenetratorSquishPullAmount ) ) + ( sqrt( ( 1.0 - ( temp_output_1_0_g990 * temp_output_1_0_g990 ) ) ) * CumDelta90_g979 * _PenetratorCumActive ) );
			#endif
			float dotResult118_g979 = dot( ( staticSwitch390_g979 - DickOrigin16_g979 ) , DickForward18_g979 );
			float PenetrationDepth39_g979 = _PenetrationDepth;
			float temp_output_65_0_g979 = ( PenetrationDepth39_g979 * DickLength19_g979 );
			float OrifaceLength34_g979 = _OrificeLength;
			float temp_output_73_0_g979 = ( 0.25 * OrifaceLength34_g979 );
			float dotResult80_g979 = dot( ( staticSwitch390_g979 - DickOrigin16_g979 ) , DickForward18_g979 );
			float temp_output_112_0_g979 = ( -( ( ( temp_output_65_0_g979 - temp_output_73_0_g979 ) + dotResult80_g979 ) - DickLength19_g979 ) * 10.0 );
			#ifdef _CLIP_DICK_ON
				float staticSwitch117_g979 = temp_output_112_0_g979;
			#else
				float staticSwitch117_g979 = max( temp_output_112_0_g979 , ( ( ( temp_output_65_0_g979 + dotResult80_g979 + temp_output_73_0_g979 ) - ( OrifaceLength34_g979 + DickLength19_g979 ) ) * 10.0 ) );
			#endif
			float InsideLerp123_g979 = saturate( staticSwitch117_g979 );
			float3 lerpResult124_g979 = lerp( ( ( DickForward18_g979 * dotResult118_g979 ) + DickOrigin16_g979 ) , staticSwitch390_g979 , InsideLerp123_g979);
			#ifdef _INVISIBLE_WHEN_INSIDE_ON
				float3 staticSwitch125_g979 = lerpResult124_g979;
			#else
				float3 staticSwitch125_g979 = staticSwitch390_g979;
			#endif
			float3 temp_output_354_0_g979 = ( staticSwitch125_g979 - DickOrigin16_g979 );
			float dotResult373_g979 = dot( DickUp172_g979 , temp_output_354_0_g979 );
			float3 DickRight184_g979 = _PenetratorRight;
			float dotResult374_g979 = dot( DickRight184_g979 , temp_output_354_0_g979 );
			float dotResult375_g979 = dot( temp_output_354_0_g979 , DickForward18_g979 );
			float3 lerpResult343_g979 = lerp( ( ( ( saturate( ( ( VisibleLength25_g979 - distance( DickOrigin16_g979 , OrifacePosition170_g979 ) ) / DickLength19_g979 ) ) + 1.0 ) * dotResult373_g979 * DickUp172_g979 ) + ( ( saturate( ( ( VisibleLength25_g979 - distance( DickOrigin16_g979 , OrifacePosition170_g979 ) ) / DickLength19_g979 ) ) + 1.0 ) * dotResult374_g979 * DickRight184_g979 ) + ( DickForward18_g979 * dotResult375_g979 ) + DickOrigin16_g979 ) , staticSwitch125_g979 , saturate( PenetrationDepth39_g979 ));
			float3 originalPosition126_g979 = lerpResult343_g979;
			float dotResult177_g979 = dot( ( originalPosition126_g979 - DickOrigin16_g979 ) , DickForward18_g979 );
			float temp_output_178_0_g979 = max( VisibleLength25_g979 , 0.05 );
			float temp_output_42_0_g992 = ( dotResult177_g979 / temp_output_178_0_g979 );
			float temp_output_26_0_g996 = temp_output_42_0_g992;
			float temp_output_19_0_g996 = ( 1.0 - temp_output_26_0_g996 );
			float4 appendResult130_g979 = (float4(_OrificeWorldNormal , 0.0));
			float4 transform135_g979 = mul(unity_WorldToObject,appendResult130_g979);
			float3 OrifaceNormal155_g979 = (transform135_g979).xyz;
			float temp_output_396_0_g979 = min( temp_output_178_0_g979 , distance( DickOrigin16_g979 , OrifacePosition170_g979 ) );
			float dotResult398_g979 = dot( ( DickOrigin16_g979 - OrifacePosition170_g979 ) , OrifaceNormal155_g979 );
			float3 lerpResult401_g979 = lerp( ( OrifacePosition170_g979 + ( OrifaceNormal155_g979 * temp_output_396_0_g979 * 0.5 ) ) , DickOrigin16_g979 , saturate( sign( dotResult398_g979 ) ));
			float3 temp_output_8_0_g992 = lerpResult401_g979;
			float3 temp_output_9_0_g992 = ( lerpResult401_g979 + ( DickForward18_g979 * temp_output_396_0_g979 * 0.25 ) );
			float3 temp_output_10_0_g992 = ( OrifacePosition170_g979 + ( OrifaceNormal155_g979 * 0.25 * temp_output_396_0_g979 ) );
			float3 temp_output_11_0_g992 = OrifacePosition170_g979;
			float temp_output_1_0_g994 = temp_output_42_0_g992;
			float temp_output_8_0_g994 = ( 1.0 - temp_output_1_0_g994 );
			float3 temp_output_3_0_g994 = temp_output_9_0_g992;
			float3 temp_output_4_0_g994 = temp_output_10_0_g992;
			float3 temp_output_7_0_g993 = ( ( 3.0 * temp_output_8_0_g994 * temp_output_8_0_g994 * ( temp_output_3_0_g994 - temp_output_8_0_g992 ) ) + ( 6.0 * temp_output_8_0_g994 * temp_output_1_0_g994 * ( temp_output_4_0_g994 - temp_output_3_0_g994 ) ) + ( 3.0 * temp_output_1_0_g994 * temp_output_1_0_g994 * ( temp_output_11_0_g992 - temp_output_4_0_g994 ) ) );
			float3 normalizeResult27_g995 = normalize( temp_output_7_0_g993 );
			float3 bezierDerivitive20_g993 = temp_output_7_0_g993;
			float3 temp_output_3_0_g992 = DickForward18_g979;
			float3 forward20_g993 = temp_output_3_0_g992;
			float3 temp_output_4_0_g992 = DickUp172_g979;
			float3 up20_g993 = temp_output_4_0_g992;
			float3 localMyCustomExpression20_g993 = MyCustomExpression20_g993( bezierDerivitive20_g993 , forward20_g993 , up20_g993 );
			float3 normalizeResult31_g995 = normalize( localMyCustomExpression20_g993 );
			float3 normalizeResult29_g995 = normalize( cross( normalizeResult27_g995 , normalizeResult31_g995 ) );
			float3 temp_output_65_22_g992 = normalizeResult29_g995;
			float3 temp_output_2_0_g992 = ( originalPosition126_g979 - DickOrigin16_g979 );
			float3 temp_output_5_0_g992 = DickRight184_g979;
			float dotResult15_g992 = dot( temp_output_2_0_g992 , temp_output_5_0_g992 );
			float3 temp_output_65_0_g992 = cross( normalizeResult29_g995 , normalizeResult27_g995 );
			float dotResult18_g992 = dot( temp_output_2_0_g992 , temp_output_4_0_g992 );
			float dotResult142_g979 = dot( ( originalPosition126_g979 - DickOrigin16_g979 ) , DickForward18_g979 );
			float temp_output_152_0_g979 = ( dotResult142_g979 - VisibleLength25_g979 );
			float temp_output_157_0_g979 = ( temp_output_152_0_g979 / OrifaceLength34_g979 );
			#ifdef _CLIP_DICK_ON
				float staticSwitch197_g979 = min( temp_output_157_0_g979 , 1.0 );
			#else
				float staticSwitch197_g979 = temp_output_157_0_g979;
			#endif
			float temp_output_42_0_g980 = staticSwitch197_g979;
			float temp_output_26_0_g984 = temp_output_42_0_g980;
			float temp_output_19_0_g984 = ( 1.0 - temp_output_26_0_g984 );
			float3 temp_output_8_0_g980 = OrifacePosition170_g979;
			float4 appendResult145_g979 = (float4(_OrificeOutWorldPosition1 , 1.0));
			float4 transform151_g979 = mul(unity_WorldToObject,appendResult145_g979);
			float3 OrifaceOutPosition1183_g979 = (transform151_g979).xyz;
			float3 temp_output_9_0_g980 = OrifaceOutPosition1183_g979;
			float4 appendResult144_g979 = (float4(_OrificeOutWorldPosition2 , 1.0));
			float4 transform154_g979 = mul(unity_WorldToObject,appendResult144_g979);
			float3 OrifaceOutPosition2182_g979 = (transform154_g979).xyz;
			float3 temp_output_10_0_g980 = OrifaceOutPosition2182_g979;
			float4 appendResult143_g979 = (float4(_OrificeOutWorldPosition3 , 1.0));
			float4 transform147_g979 = mul(unity_WorldToObject,appendResult143_g979);
			float3 OrifaceOutPosition3175_g979 = (transform147_g979).xyz;
			float3 temp_output_11_0_g980 = OrifaceOutPosition3175_g979;
			float temp_output_1_0_g982 = temp_output_42_0_g980;
			float temp_output_8_0_g982 = ( 1.0 - temp_output_1_0_g982 );
			float3 temp_output_3_0_g982 = temp_output_9_0_g980;
			float3 temp_output_4_0_g982 = temp_output_10_0_g980;
			float3 temp_output_7_0_g981 = ( ( 3.0 * temp_output_8_0_g982 * temp_output_8_0_g982 * ( temp_output_3_0_g982 - temp_output_8_0_g980 ) ) + ( 6.0 * temp_output_8_0_g982 * temp_output_1_0_g982 * ( temp_output_4_0_g982 - temp_output_3_0_g982 ) ) + ( 3.0 * temp_output_1_0_g982 * temp_output_1_0_g982 * ( temp_output_11_0_g980 - temp_output_4_0_g982 ) ) );
			float3 normalizeResult27_g983 = normalize( temp_output_7_0_g981 );
			float3 bezierDerivitive20_g981 = temp_output_7_0_g981;
			float3 temp_output_3_0_g980 = DickForward18_g979;
			float3 forward20_g981 = temp_output_3_0_g980;
			float3 temp_output_4_0_g980 = DickUp172_g979;
			float3 up20_g981 = temp_output_4_0_g980;
			float3 localMyCustomExpression20_g981 = MyCustomExpression20_g981( bezierDerivitive20_g981 , forward20_g981 , up20_g981 );
			float3 normalizeResult31_g983 = normalize( localMyCustomExpression20_g981 );
			float3 normalizeResult29_g983 = normalize( cross( normalizeResult27_g983 , normalizeResult31_g983 ) );
			float3 temp_output_65_22_g980 = normalizeResult29_g983;
			float3 temp_output_2_0_g980 = ( originalPosition126_g979 - DickOrigin16_g979 );
			float3 temp_output_5_0_g980 = DickRight184_g979;
			float dotResult15_g980 = dot( temp_output_2_0_g980 , temp_output_5_0_g980 );
			float3 temp_output_65_0_g980 = cross( normalizeResult29_g983 , normalizeResult27_g983 );
			float dotResult18_g980 = dot( temp_output_2_0_g980 , temp_output_4_0_g980 );
			float temp_output_208_0_g979 = saturate( sign( temp_output_152_0_g979 ) );
			float3 lerpResult221_g979 = lerp( ( ( ( temp_output_19_0_g996 * temp_output_19_0_g996 * temp_output_19_0_g996 * temp_output_8_0_g992 ) + ( temp_output_19_0_g996 * temp_output_19_0_g996 * 3.0 * temp_output_26_0_g996 * temp_output_9_0_g992 ) + ( 3.0 * temp_output_19_0_g996 * temp_output_26_0_g996 * temp_output_26_0_g996 * temp_output_10_0_g992 ) + ( temp_output_26_0_g996 * temp_output_26_0_g996 * temp_output_26_0_g996 * temp_output_11_0_g992 ) ) + ( temp_output_65_22_g992 * dotResult15_g992 ) + ( temp_output_65_0_g992 * dotResult18_g992 ) ) , ( ( ( temp_output_19_0_g984 * temp_output_19_0_g984 * temp_output_19_0_g984 * temp_output_8_0_g980 ) + ( temp_output_19_0_g984 * temp_output_19_0_g984 * 3.0 * temp_output_26_0_g984 * temp_output_9_0_g980 ) + ( 3.0 * temp_output_19_0_g984 * temp_output_26_0_g984 * temp_output_26_0_g984 * temp_output_10_0_g980 ) + ( temp_output_26_0_g984 * temp_output_26_0_g984 * temp_output_26_0_g984 * temp_output_11_0_g980 ) ) + ( temp_output_65_22_g980 * dotResult15_g980 ) + ( temp_output_65_0_g980 * dotResult18_g980 ) ) , temp_output_208_0_g979);
			float3 temp_output_42_0_g986 = DickForward18_g979;
			float NonVisibleLength165_g979 = ( temp_output_11_0_g979 * _PenetratorLength );
			float3 temp_output_52_0_g986 = ( ( temp_output_42_0_g986 * ( ( NonVisibleLength165_g979 - OrifaceLength34_g979 ) - DickLength19_g979 ) ) + ( originalPosition126_g979 - DickOrigin16_g979 ) );
			float dotResult53_g986 = dot( temp_output_42_0_g986 , temp_output_52_0_g986 );
			float temp_output_1_0_g988 = 1.0;
			float temp_output_8_0_g988 = ( 1.0 - temp_output_1_0_g988 );
			float3 temp_output_3_0_g988 = OrifaceOutPosition1183_g979;
			float3 temp_output_4_0_g988 = OrifaceOutPosition2182_g979;
			float3 temp_output_7_0_g987 = ( ( 3.0 * temp_output_8_0_g988 * temp_output_8_0_g988 * ( temp_output_3_0_g988 - OrifacePosition170_g979 ) ) + ( 6.0 * temp_output_8_0_g988 * temp_output_1_0_g988 * ( temp_output_4_0_g988 - temp_output_3_0_g988 ) ) + ( 3.0 * temp_output_1_0_g988 * temp_output_1_0_g988 * ( OrifaceOutPosition3175_g979 - temp_output_4_0_g988 ) ) );
			float3 normalizeResult27_g989 = normalize( temp_output_7_0_g987 );
			float3 temp_output_85_23_g986 = normalizeResult27_g989;
			float3 temp_output_4_0_g986 = DickUp172_g979;
			float dotResult54_g986 = dot( temp_output_4_0_g986 , temp_output_52_0_g986 );
			float3 bezierDerivitive20_g987 = temp_output_7_0_g987;
			float3 forward20_g987 = temp_output_42_0_g986;
			float3 up20_g987 = temp_output_4_0_g986;
			float3 localMyCustomExpression20_g987 = MyCustomExpression20_g987( bezierDerivitive20_g987 , forward20_g987 , up20_g987 );
			float3 normalizeResult31_g989 = normalize( localMyCustomExpression20_g987 );
			float3 normalizeResult29_g989 = normalize( cross( normalizeResult27_g989 , normalizeResult31_g989 ) );
			float3 temp_output_85_0_g986 = cross( normalizeResult29_g989 , normalizeResult27_g989 );
			float3 temp_output_43_0_g986 = DickRight184_g979;
			float dotResult55_g986 = dot( temp_output_43_0_g986 , temp_output_52_0_g986 );
			float3 temp_output_85_22_g986 = normalizeResult29_g989;
			float temp_output_222_0_g979 = saturate( sign( ( temp_output_157_0_g979 - 1.0 ) ) );
			float3 lerpResult224_g979 = lerp( lerpResult221_g979 , ( ( ( dotResult53_g986 * temp_output_85_23_g986 ) + ( dotResult54_g986 * temp_output_85_0_g986 ) + ( dotResult55_g986 * temp_output_85_22_g986 ) ) + OrifaceOutPosition3175_g979 ) , temp_output_222_0_g979);
			#ifdef _CLIP_DICK_ON
				float3 staticSwitch229_g979 = lerpResult221_g979;
			#else
				float3 staticSwitch229_g979 = lerpResult224_g979;
			#endif
			float temp_output_226_0_g979 = saturate( -PenetrationDepth39_g979 );
			float3 lerpResult232_g979 = lerp( staticSwitch229_g979 , originalPosition126_g979 , temp_output_226_0_g979);
			float3 ifLocalVar237_g979 = 0;
			if( temp_output_234_0_g979 <= 0.0 )
				ifLocalVar237_g979 = originalPosition126_g979;
			else
				ifLocalVar237_g979 = lerpResult232_g979;
			#ifdef _DEFORM_BALLS_ON
				float3 staticSwitch239_g979 = lerpResult232_g979;
			#else
				float3 staticSwitch239_g979 = ifLocalVar237_g979;
			#endif
			v.vertex.xyz = staticSwitch239_g979;
			v.vertex.w = 1;
			float3 temp_output_21_0_g992 = VertexNormal259_g979;
			float dotResult55_g992 = dot( temp_output_21_0_g992 , temp_output_3_0_g992 );
			float dotResult56_g992 = dot( temp_output_21_0_g992 , temp_output_4_0_g992 );
			float dotResult57_g992 = dot( temp_output_21_0_g992 , temp_output_5_0_g992 );
			float3 normalizeResult31_g992 = normalize( ( ( dotResult55_g992 * normalizeResult27_g995 ) + ( dotResult56_g992 * temp_output_65_0_g992 ) + ( dotResult57_g992 * temp_output_65_22_g992 ) ) );
			float3 temp_output_21_0_g980 = VertexNormal259_g979;
			float dotResult55_g980 = dot( temp_output_21_0_g980 , temp_output_3_0_g980 );
			float dotResult56_g980 = dot( temp_output_21_0_g980 , temp_output_4_0_g980 );
			float dotResult57_g980 = dot( temp_output_21_0_g980 , temp_output_5_0_g980 );
			float3 normalizeResult31_g980 = normalize( ( ( dotResult55_g980 * normalizeResult27_g983 ) + ( dotResult56_g980 * temp_output_65_0_g980 ) + ( dotResult57_g980 * temp_output_65_22_g980 ) ) );
			float3 lerpResult227_g979 = lerp( normalizeResult31_g992 , normalizeResult31_g980 , temp_output_208_0_g979);
			float3 temp_output_24_0_g986 = VertexNormal259_g979;
			float dotResult61_g986 = dot( temp_output_42_0_g986 , temp_output_24_0_g986 );
			float dotResult62_g986 = dot( temp_output_4_0_g986 , temp_output_24_0_g986 );
			float dotResult60_g986 = dot( temp_output_43_0_g986 , temp_output_24_0_g986 );
			float3 normalizeResult33_g986 = normalize( ( ( dotResult61_g986 * temp_output_85_23_g986 ) + ( dotResult62_g986 * temp_output_85_0_g986 ) + ( dotResult60_g986 * temp_output_85_22_g986 ) ) );
			float3 lerpResult233_g979 = lerp( lerpResult227_g979 , normalizeResult33_g986 , temp_output_222_0_g979);
			#ifdef _CLIP_DICK_ON
				float3 staticSwitch236_g979 = lerpResult227_g979;
			#else
				float3 staticSwitch236_g979 = lerpResult233_g979;
			#endif
			float3 lerpResult238_g979 = lerp( staticSwitch236_g979 , VertexNormal259_g979 , temp_output_226_0_g979);
			float3 ifLocalVar391_g979 = 0;
			if( temp_output_234_0_g979 <= 0.0 )
				ifLocalVar391_g979 = VertexNormal259_g979;
			else
				ifLocalVar391_g979 = lerpResult238_g979;
			v.normal = ifLocalVar391_g979;
			#ifdef _INVISIBLE_WHEN_INSIDE_ON
				float staticSwitch249_g979 = InsideLerp123_g979;
			#else
				float staticSwitch249_g979 = 1.0;
			#endif
			o.vertexToFrag250_g979 = staticSwitch249_g979;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_BumpMap = i.uv_texcoord * _BumpMap_ST.xy + _BumpMap_ST.zw;
			o.Normal = UnpackNormal( tex2D( _BumpMap, uv_BumpMap ) );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			o.Albedo = tex2D( _MainTex, uv_MainTex ).rgb;
			float2 uv_MaskMap = i.uv_texcoord * _MaskMap_ST.xy + _MaskMap_ST.zw;
			float4 tex2DNode102 = tex2D( _MaskMap, uv_MaskMap );
			o.Metallic = tex2DNode102.r;
			o.Smoothness = tex2DNode102.a;
			o.Alpha = 1;
			clip( i.vertexToFrag250_g979 - _Cutoff );
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18912
149;164;1675;699;-5908.111;2014.983;2.675143;True;False
Node;AmplifyShaderEditor.SamplerNode;100;7108.375,-1682.497;Inherit;True;Property;_MainTex;MainTex;23;0;Create;True;0;0;0;False;0;False;-1;None;a7fd0f05ef2dbbd43ac64dff86a86708;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;102;7105.585,-1265.636;Inherit;True;Property;_MaskMap;MaskMap;24;0;Create;True;0;0;0;False;0;False;-1;None;b6ba1a4a299c969449e3ec084c188366;True;0;False;gray;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;101;7104.496,-1467.525;Inherit;True;Property;_BumpMap;BumpMap;25;0;Create;True;0;0;0;False;0;False;-1;None;22df23dcaaa4c974888f14b0f36d484f;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;676;7008.464,-1016.773;Inherit;False;PenetrationTechDeformation;0;;979;cb4db099da64a8846a0c6877ff8e2b5f;0;3;253;FLOAT3;0,0,0;False;258;FLOAT3;0,0,0;False;265;FLOAT3;0,0,0;False;3;FLOAT3;0;FLOAT;251;FLOAT3;252
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;552;7623.605,-1459.329;Float;False;True;-1;2;ASEMaterialInspector;0;0;Standard;PenetrationTech/Standard/Penetrator;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;TransparentCutout;;Geometry;All;18;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Absolute;0;;22;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;552;0;100;0
WireConnection;552;1;101;0
WireConnection;552;3;102;1
WireConnection;552;4;102;4
WireConnection;552;10;676;251
WireConnection;552;11;676;0
WireConnection;552;12;676;252
ASEEND*/
//CHKSM=04A88FFE3E2695B1C0F9F9C70D48006138785B81