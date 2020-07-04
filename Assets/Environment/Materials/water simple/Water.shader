// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Water"
{
	Properties
	{
		_Wavespeed1("Wave speed", Float) = 1
		_WaveTile1("Wave Tile", Float) = 1
		_WaveHeight1("Wave Height", Float) = 1
		_Smoothness1("Smoothness", Float) = 0.9
		_TextureSample1("Texture Sample 0", 2D) = "white" {}
		_WaterColor1("Water Color", Color) = (0.1431114,0.2895418,0.6320754,0)
		_TopColor1("Top Color", Color) = (0.08810966,0.4981066,0.8490566,0)
		_EdgeDistance1("Edge Distance", Float) = 1
		_EdgePower1("Edge Power", Range( 0 , 1)) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" "IsEmissive" = "true"  }
		Cull Back
		CGPROGRAM
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "Tessellation.cginc"
		#pragma target 4.6
		#pragma surface surf Standard keepalpha noshadow vertex:vertexDataFunc tessellate:tessFunction 
		struct Input
		{
			float3 worldPos;
			float2 uv_texcoord;
			float4 screenPos;
		};

		uniform float _WaveHeight1;
		uniform float _Wavespeed1;
		uniform float _WaveTile1;
		uniform sampler2D _TextureSample1;
		uniform float4 _TextureSample1_ST;
		uniform float4 _WaterColor1;
		uniform float4 _TopColor1;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _EdgeDistance1;
		uniform float _EdgePower1;
		uniform float _Smoothness1;


		float3 mod2D289( float3 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float2 mod2D289( float2 x ) { return x - floor( x * ( 1.0 / 289.0 ) ) * 289.0; }

		float3 permute( float3 x ) { return mod2D289( ( ( x * 34.0 ) + 1.0 ) * x ); }

		float snoise( float2 v )
		{
			const float4 C = float4( 0.211324865405187, 0.366025403784439, -0.577350269189626, 0.024390243902439 );
			float2 i = floor( v + dot( v, C.yy ) );
			float2 x0 = v - i + dot( i, C.xx );
			float2 i1;
			i1 = ( x0.x > x0.y ) ? float2( 1.0, 0.0 ) : float2( 0.0, 1.0 );
			float4 x12 = x0.xyxy + C.xxzz;
			x12.xy -= i1;
			i = mod2D289( i );
			float3 p = permute( permute( i.y + float3( 0.0, i1.y, 1.0 ) ) + i.x + float3( 0.0, i1.x, 1.0 ) );
			float3 m = max( 0.5 - float3( dot( x0, x0 ), dot( x12.xy, x12.xy ), dot( x12.zw, x12.zw ) ), 0.0 );
			m = m * m;
			m = m * m;
			float3 x = 2.0 * frac( p * C.www ) - 1.0;
			float3 h = abs( x ) - 0.5;
			float3 ox = floor( x + 0.5 );
			float3 a0 = x - ox;
			m *= 1.79284291400159 - 0.85373472095314 * ( a0 * a0 + h * h );
			float3 g;
			g.x = a0.x * x0.x + h.x * x0.y;
			g.yz = a0.yz * x12.xz + h.yz * x12.yw;
			return 130.0 * dot( m, g );
		}


		float4 tessFunction( appdata_full v0, appdata_full v1, appdata_full v2 )
		{
			float4 temp_cast_3 = (8.0).xxxx;
			return temp_cast_3;
		}

		void vertexDataFunc( inout appdata_full v )
		{
			float temp_output_16_0 = ( _Time.y * _Wavespeed1 );
			float2 _Wavedirection1 = float2(-1,0);
			float3 ase_worldPos = mul( unity_ObjectToWorld, v.vertex );
			float4 appendResult3 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float4 WorldSpaceTile5 = appendResult3;
			float4 WaveTileUV11 = ( ( WorldSpaceTile5 * float4( float2( 0.15,0.02 ), 0.0 , 0.0 ) ) * _WaveTile1 );
			float2 panner21 = ( temp_output_16_0 * _Wavedirection1 + WaveTileUV11.xy);
			float simplePerlin2D22 = snoise( panner21 );
			simplePerlin2D22 = simplePerlin2D22*0.5 + 0.5;
			float2 panner20 = ( temp_output_16_0 * _Wavedirection1 + ( WaveTileUV11 * float4( 0,0,0,0 ) ).xy);
			float simplePerlin2D23 = snoise( panner20 );
			simplePerlin2D23 = simplePerlin2D23*0.5 + 0.5;
			float temp_output_24_0 = ( simplePerlin2D22 + simplePerlin2D23 );
			float3 WaveHeight37 = ( ( float3(0,1,0) * _WaveHeight1 ) * temp_output_24_0 );
			v.vertex.xyz += WaveHeight37;
		}

		void surf( Input i , inout SurfaceOutputStandard o )
		{
			float2 uv_TextureSample1 = i.uv_texcoord * _TextureSample1_ST.xy + _TextureSample1_ST.zw;
			o.Normal = tex2D( _TextureSample1, uv_TextureSample1 ).rgb;
			float temp_output_16_0 = ( _Time.y * _Wavespeed1 );
			float2 _Wavedirection1 = float2(-1,0);
			float3 ase_worldPos = i.worldPos;
			float4 appendResult3 = (float4(ase_worldPos.x , ase_worldPos.z , 0.0 , 0.0));
			float4 WorldSpaceTile5 = appendResult3;
			float4 WaveTileUV11 = ( ( WorldSpaceTile5 * float4( float2( 0.15,0.02 ), 0.0 , 0.0 ) ) * _WaveTile1 );
			float2 panner21 = ( temp_output_16_0 * _Wavedirection1 + WaveTileUV11.xy);
			float simplePerlin2D22 = snoise( panner21 );
			simplePerlin2D22 = simplePerlin2D22*0.5 + 0.5;
			float2 panner20 = ( temp_output_16_0 * _Wavedirection1 + ( WaveTileUV11 * float4( 0,0,0,0 ) ).xy);
			float simplePerlin2D23 = snoise( panner20 );
			simplePerlin2D23 = simplePerlin2D23*0.5 + 0.5;
			float temp_output_24_0 = ( simplePerlin2D22 + simplePerlin2D23 );
			float WavePattern25 = temp_output_24_0;
			float clampResult32 = clamp( WavePattern25 , 0.0 , 1.0 );
			float4 lerpResult35 = lerp( _WaterColor1 , _TopColor1 , clampResult32);
			float4 Albedo36 = lerpResult35;
			o.Albedo = Albedo36.rgb;
			float4 ase_screenPos = float4( i.screenPos.xyz , i.screenPos.w + 0.00000000001 );
			float4 ase_screenPosNorm = ase_screenPos / ase_screenPos.w;
			ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
			float screenDepth41 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm.xy ));
			float distanceDepth41 = abs( ( screenDepth41 - LinearEyeDepth( ase_screenPosNorm.z ) ) / ( _EdgeDistance1 ) );
			float clampResult51 = clamp( ( ( 1.0 - distanceDepth41 ) * _EdgePower1 ) , 0.0 , 1.0 );
			float Edge49 = clampResult51;
			float3 temp_cast_5 = (Edge49).xxx;
			o.Emission = temp_cast_5;
			o.Smoothness = _Smoothness1;
			o.Alpha = 1;
		}

		ENDCG
	}
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=17101
0;72.66667;2116;959;-268.2555;1064.164;1;True;False
Node;AmplifyShaderEditor.CommentaryNode;1;-2225.893,-503.5774;Inherit;False;702;245;World Space UVs;3;5;3;2;;1,1,1,1;0;0
Node;AmplifyShaderEditor.WorldPosInputsNode;2;-2197.893,-438.5774;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.DynamicAppendNode;3;-1935.893,-437.5774;Inherit;False;FLOAT4;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;4;-1403.126,-479.8928;Inherit;False;1934.525;466.3044;Wave UVs and Height;11;37;34;30;28;27;11;10;9;8;7;6;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;5;-1770.893,-427.5774;Inherit;False;WorldSpaceTile;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;6;-1353.126,-145.0001;Inherit;False;Constant;_WaveStretch1;Wave Stretch;2;0;Create;True;0;0;False;0;0.15,0.02;0.23,0.01;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.GetLocalVarNode;7;-1339.958,-415.7303;Inherit;True;5;WorldSpaceTile;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RangedFloatNode;8;-1055.967,-155.5754;Inherit;False;Property;_WaveTile1;Wave Tile;1;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-1066.26,-409.6145;Inherit;True;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT2;0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-786.703,-332.0398;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;11;-597.3152,-429.8928;Inherit;False;WaveTileUV;-1;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.CommentaryNode;12;-1415.252,95.42407;Inherit;False;1555.713;879.7657;Wave Pattern;14;40;25;24;23;22;21;20;19;18;17;16;15;14;13;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;13;-1341.839,719.2279;Inherit;False;Property;_Wavespeed1;Wave speed;0;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleTimeNode;14;-1338.603,577.8367;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;15;-1365.252,847.7396;Inherit;False;11;WaveTileUV;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;16;-1106.379,679.9112;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;17;-1049.137,849.5883;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0,0,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;18;-1330.644,150.2622;Inherit;True;11;WaveTileUV;1;0;OBJECT;0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.Vector2Node;19;-1333.59,411.6318;Inherit;False;Constant;_Wavedirection1;Wave direction;0;0;Create;True;0;0;False;0;-1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.PannerNode;20;-819.3216,694.9254;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.PannerNode;21;-845.9748,315.1722;Inherit;True;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;22;-560.3683,315.0756;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.NoiseGeneratorNode;23;-543.1149,689.2286;Inherit;True;Simplex2D;True;False;2;0;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;46;799.058,-750.3824;Inherit;False;Property;_EdgeDistance1;Edge Distance;7;0;Create;True;0;0;False;0;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;24;-200.2982,465.811;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;25;-89.98758,640.612;Inherit;False;WavePattern;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;41;1051.401,-764.9894;Inherit;False;True;False;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;26;-388.773,-1269.886;Inherit;False;856.0535;690.1164;Color;6;36;35;33;32;31;29;;1,1,1,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;47;1369.326,-637.3174;Inherit;False;Property;_EdgePower1;Edge Power;8;0;Create;True;0;0;False;0;1;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector3Node;28;-306.3058,-429.6874;Inherit;True;Constant;_Waveup1;Wave up;3;0;Create;True;0;0;False;0;0,1,0;0,1,0;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.GetLocalVarNode;29;-338.773,-818.2934;Inherit;True;25;WavePattern;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;27;-305.352,-111.1529;Inherit;False;Property;_WaveHeight1;Wave Height;2;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;42;1354.326,-759.3174;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;32;-22.8476,-779.6774;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;48;1597.326,-695.3174;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;31;-276.9166,-1037.557;Inherit;False;Property;_TopColor1;Top Color;6;0;Create;True;0;0;False;0;0.08810966,0.4981066,0.8490566,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;33;-284.2455,-1219.886;Inherit;False;Property;_WaterColor1;Water Color;5;0;Create;True;0;0;False;0;0.1431114,0.2895418,0.6320754,0;0,0,0,0;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;30;-54.55377,-319.7763;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.LerpOp;35;41.8078,-1059.137;Inherit;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;51;1795.255,-691.1636;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;34;136.8888,-238.3288;Inherit;False;2;2;0;FLOAT3;0,0,0;False;1;FLOAT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;49;1990.539,-702.4185;Inherit;False;Edge;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;36;266.3007,-989.0574;Inherit;False;Albedo;-1;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;37;311.9686,-195.8852;Inherit;False;WaveHeight;-1;True;1;0;FLOAT3;0,0,0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.RangedFloatNode;50;1510.255,40.83649;Inherit;False;Constant;_Tesselation;Tesselation;9;0;Create;True;0;0;False;0;8;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;45;1285.105,-382.4607;Inherit;False;36;Albedo;1;0;OBJECT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;44;766.142,-315.8113;Inherit;True;Property;_TextureSample1;Texture Sample 0;4;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;38;873.1421,38.18869;Inherit;False;Property;_Smoothness1;Smoothness;3;0;Create;True;0;0;False;0;0.9;0.9;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;40;-1034.175,145.4242;Inherit;False;2;2;0;FLOAT4;0,0,0,0;False;1;FLOAT4;0.1,0.1,0,0;False;1;FLOAT4;0
Node;AmplifyShaderEditor.GetLocalVarNode;43;1093.326,-173.7294;Inherit;False;49;Edge;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;39;1449.288,-95.03552;Inherit;False;37;WaveHeight;1;0;OBJECT;0;False;1;FLOAT3;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1800.374,-365.8012;Float;False;True;6;ASEMaterialInspector;0;0;Standard;Water;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Back;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;False;0;False;Opaque;;Geometry;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;True;2;15;10;25;False;0.5;False;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;3;0;2;1
WireConnection;3;1;2;3
WireConnection;5;0;3;0
WireConnection;9;0;7;0
WireConnection;9;1;6;0
WireConnection;10;0;9;0
WireConnection;10;1;8;0
WireConnection;11;0;10;0
WireConnection;16;0;14;0
WireConnection;16;1;13;0
WireConnection;17;0;15;0
WireConnection;20;0;17;0
WireConnection;20;2;19;0
WireConnection;20;1;16;0
WireConnection;21;0;18;0
WireConnection;21;2;19;0
WireConnection;21;1;16;0
WireConnection;22;0;21;0
WireConnection;23;0;20;0
WireConnection;24;0;22;0
WireConnection;24;1;23;0
WireConnection;25;0;24;0
WireConnection;41;0;46;0
WireConnection;42;0;41;0
WireConnection;32;0;29;0
WireConnection;48;0;42;0
WireConnection;48;1;47;0
WireConnection;30;0;28;0
WireConnection;30;1;27;0
WireConnection;35;0;33;0
WireConnection;35;1;31;0
WireConnection;35;2;32;0
WireConnection;51;0;48;0
WireConnection;34;0;30;0
WireConnection;34;1;24;0
WireConnection;49;0;51;0
WireConnection;36;0;35;0
WireConnection;37;0;34;0
WireConnection;40;0;18;0
WireConnection;0;0;45;0
WireConnection;0;1;44;0
WireConnection;0;2;43;0
WireConnection;0;4;38;0
WireConnection;0;11;39;0
WireConnection;0;14;50;0
ASEEND*/
//CHKSM=A686A901AC76D0B6866E3A84A5684B597E7C23CC