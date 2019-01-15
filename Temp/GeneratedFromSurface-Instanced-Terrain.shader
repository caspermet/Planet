// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Instanced/Terrain" {
	Properties{
		_HeightTex("Texture", 2D) = "white" {}

		_Textures("Textures", 2DArray) = "" {}


		_HeightMin("Height Min", Float) = -1
		_HeightMax("Height Max", Float) = 1
		_textureblend("bluer Texture", Range(0,0.1)) = 1
			_Angle("Angle", float) = 1

	}
		SubShader{

			Tags { "RenderType" = "Opaque"  }
			LOD 200

			
	// ------------------------------------------------------------
	// Surface shader code generated out of a CGPROGRAM block:
	

	// ---- forward rendering base pass:
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardBase" }

CGPROGRAM
// compile directives
#pragma vertex vert_surf
#pragma fragment frag_surf
#pragma multi_compile_instancing
#pragma instancing_options procedural:setup
#pragma target 3.0
#pragma multi_compile_fog
#pragma multi_compile_fwdbase
#include "HLSLSupport.cginc"
#define UNITY_INSTANCED_LOD_FADE
#define UNITY_INSTANCED_SH
#define UNITY_INSTANCED_LIGHTMAPSTS
#define UNITY_INSTANCING_PROCEDURAL_FUNC setup
#include "UnityShaderVariables.cginc"
#include "UnityShaderUtilities.cginc"
// -------- variant for: <when no other keywords are defined>
#if !defined(INSTANCING_ON) && !defined(PROCEDURAL_INSTANCING_ON)
// Surface shader code generated based on:
// vertex modifier: 'vert'
// writes to per-pixel normal: no
// writes to emission: no
// writes to occlusion: no
// needs world space reflection vector: no
// needs world space normal vector: no
// needs screen space position: no
// needs world space position: no
// needs view direction: no
// needs world space view direction: no
// needs world space position for lighting: YES
// needs world space view direction for lighting: YES
// needs world space view direction for lightmaps: no
// needs vertex color: no
// needs VFACE: no
// passes tangent-to-world matrix to pixel shader: no
// reads from normal: no
// 0 texcoords actually used
#include "UnityCG.cginc"
#include "UnityPBSLighting.cginc"
#include "AutoLight.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 21 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif
/* UNITY: Original start of shader */
			// Physically based Standard lighting model, and enable shadows on all light types
			//#pragma surface surf Standard addshadow fullforwardshadows vertex:vert
			//#pragma multi_compile_instancing
			//#pragma instancing_options procedural:setup
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			// Use shader model 3.0 target, to get nicer looking lighting
			//#pragma target 3.0

			sampler2D _HeightTex;
		/*****************************************************************
			Planet Info
			x -> planet Radius -> (chunkSize - 1) * MaxScale
			y -> Max terrain height
			********************************************************************/
			float3 _PlanetInfo;

			UNITY_DECLARE_TEX2DARRAY(_Textures);

			struct Input {
				float2 uv_MainTex;
				fixed2 uv_Textures;
				float3 worldPos;
			};

			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
			StructuredBuffer<float4> positionBuffer;
			StructuredBuffer<float4> directionsBuffer;		
			#endif

				void setup()
				{
				#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
					float4 data = positionBuffer[unity_InstanceID];
					data.xyz = 0;
					data.w = 1;
					unity_ObjectToWorld._11_21_31_41 = float4(data.w, 0, 0, 0);
					unity_ObjectToWorld._12_22_32_42 = float4(0, data.w, 0, 0);
					unity_ObjectToWorld._13_23_33_43 = float4(0, 0, data.w, 0);
					unity_ObjectToWorld._14_24_34_44 = float4(data.x, data.y, data.z, 1);
					unity_WorldToObject = unity_ObjectToWorld;
					unity_WorldToObject._14_24_34 *= -1;
					unity_WorldToObject._11_22_33 = 1.0f / unity_WorldToObject._11_22_33;
				#endif
				}

			int _TexturesArrayLength;
			float _TexturesArray[20];
			uniform float _Angle;

			float _HeightMin;
			float _HeightMax;

			float _textureblend;

			float3x3 RotateAroundYInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
			
				return float3x3(
					cosa, 0, -sina,
					0,    1, 0,
					sina, 0, cosa);
			}
			float3x3 RotateAroundXInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
				return float3x3(
					1, 0,		0,
					0, cosa,	sina,
					0, -sina,	cosa);

			}
			float3x3 RotateAroundZInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
				
				return float3x3(
					cosa,	sina,	0,
					-sina,	cosa,	0,
					0,		0,		1);

			}

			void vert(inout appdata_full v) {
			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
				float4 transform = directionsBuffer[unity_InstanceID];

				float4 data = positionBuffer[unity_InstanceID];

				float4 wolrldPosition = mul(unity_ObjectToWorld, v.vertex) / 5000;

				/*float x = wolrldPosition.x;
				float z = wolrldPosition.z;*/

				v.vertex.y = 1;
				float4 pos = v.vertex;
				float r = _PlanetInfo.x;

				if (transform.x != 0) {
					v.vertex.xyz = mul(RotateAroundXInDegrees(transform.x * 90), pos.xyz);
				}
				else if (transform.y != 0) {
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.y * 90), pos.xyz);	
				}
				else if(transform.z == -1){
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.z * 180), pos.xyz);
				}


				float x = (v.vertex.x+data.x)*data.w;
				float y = (v.vertex.y+data.y)*data.w;
				float z = (v.vertex.z+data.z)*data.w;

				float dx = x * sqrt(1.0f - (y*y * 0.5f) - (z * z * 0.5f) + (y*y*z*z / 3.0f));
				float dy = y * sqrt(1.0f - (z*z * 0.5f) - (x * x * 0.5f) + (z*z*x*x / 3.0f));
				float dz = z * sqrt(1.0f - (x*x * 0.5f) - (y * y * 0.5f) + (x*x*y*y / 3.0f));

				v.vertex.xyz = float3(dx, dy, dz);

				
				//v.vertex.xyz = normalize(UnityWorldSpaceViewDir(v.vertex.xyz);


				//v.vertex.y = (tex2Dlod(_HeightTex, float4(x , z , 0, 0) - 1) * _PlanetInfo.y + _PlanetInfo.x) / data.w;
				
				#endif
				}


			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// //#pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o) {

				float h = (_PlanetInfo.y + _PlanetInfo.x - IN.worldPos.y) / (_PlanetInfo.y);

				int index = 0;

				for (int i = 0; i < _TexturesArrayLength; i++) {
					if (h >= _TexturesArray[i]) {
						index = i;
						break;
					}
				}

				fixed4 c = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures,  index));


				/***********************
					Rozmazí krajních bodů textůr
				********************/

				if (((h - _textureblend) < _TexturesArray[index]) && index > 0) {
					float 	g = (_textureblend - h + _TexturesArray[index]) / (_textureblend * 2 + 0.001);
					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index + 1)));
					c = lerp(c, d, g);
				}
				else if ((index > 0) && ((h + _textureblend) > _TexturesArray[index - 1])) {
					float g;
					if (index == 1) {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend + 0.001);
					}
					else {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend * 2 + 0.001);
					}

					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index - 1)));
					c = lerp(c, d, g);
				}


				o.Albedo = 1;// c.rgb;
				o.Alpha = 1;


			}
			

// vertex-to-fragment interpolation data
// no lightmaps:
#ifndef LIGHTMAP_ON
// half-precision fragment shader registers:
#ifdef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
#define FOG_COMBINED_WITH_WORLD_POS
struct v2f_surf {
  UNITY_POSITION(pos);
  float3 worldNormal : TEXCOORD0;
  float4 worldPos : TEXCOORD1;
  #if UNITY_SHOULD_SAMPLE_SH
  half3 sh : TEXCOORD2; // SH
  #endif
  UNITY_LIGHTING_COORDS(3,4)
  #if SHADER_TARGET >= 30
  float4 lmap : TEXCOORD5;
  #endif
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};
#endif
// high-precision fragment shader registers:
#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
struct v2f_surf {
  UNITY_POSITION(pos);
  float3 worldNormal : TEXCOORD0;
  float3 worldPos : TEXCOORD1;
  #if UNITY_SHOULD_SAMPLE_SH
  half3 sh : TEXCOORD2; // SH
  #endif
  UNITY_FOG_COORDS(3)
  UNITY_SHADOW_COORDS(4)
  #if SHADER_TARGET >= 30
  float4 lmap : TEXCOORD5;
  #endif
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};
#endif
#endif
// with lightmaps:
#ifdef LIGHTMAP_ON
// half-precision fragment shader registers:
#ifdef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
#define FOG_COMBINED_WITH_WORLD_POS
struct v2f_surf {
  UNITY_POSITION(pos);
  float3 worldNormal : TEXCOORD0;
  float4 worldPos : TEXCOORD1;
  float4 lmap : TEXCOORD2;
  UNITY_LIGHTING_COORDS(3,4)
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};
#endif
// high-precision fragment shader registers:
#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
struct v2f_surf {
  UNITY_POSITION(pos);
  float3 worldNormal : TEXCOORD0;
  float3 worldPos : TEXCOORD1;
  float4 lmap : TEXCOORD2;
  UNITY_FOG_COORDS(3)
  UNITY_SHADOW_COORDS(4)
  #ifdef DIRLIGHTMAP_COMBINED
  float3 tSpace0 : TEXCOORD5;
  float3 tSpace1 : TEXCOORD6;
  float3 tSpace2 : TEXCOORD7;
  #endif
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};
#endif
#endif

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  UNITY_SETUP_INSTANCE_ID(v);
  v2f_surf o;
  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
  UNITY_TRANSFER_INSTANCE_ID(v,o);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
  vert (v);
  o.pos = UnityObjectToClipPos(v.vertex);
  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
  #if defined(LIGHTMAP_ON) && defined(DIRLIGHTMAP_COMBINED)
  fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
  fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
  fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
  #endif
  #if defined(LIGHTMAP_ON) && defined(DIRLIGHTMAP_COMBINED) && !defined(UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS)
  o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
  o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
  o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
  #endif
  o.worldPos.xyz = worldPos;
  o.worldNormal = worldNormal;
  #ifdef DYNAMICLIGHTMAP_ON
  o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
  #endif
  #ifdef LIGHTMAP_ON
  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
  #endif

  // SH/ambient and vertex lights
  #ifndef LIGHTMAP_ON
    #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
      o.sh = 0;
      // Approximated illumination from non-important point lights
      #ifdef VERTEXLIGHT_ON
        o.sh += Shade4PointLights (
          unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
          unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
          unity_4LightAtten0, worldPos, worldNormal);
      #endif
      o.sh = ShadeSHPerVertex (worldNormal, o.sh);
    #endif
  #endif // !LIGHTMAP_ON

  UNITY_TRANSFER_LIGHTING(o,v.texcoord1.xy); // pass shadow and, possibly, light cookie coordinates to pixel shader
  #ifdef FOG_COMBINED_WITH_TSPACE
    UNITY_TRANSFER_FOG_COMBINED_WITH_TSPACE(o,o.pos); // pass fog coordinates to pixel shader
  #elif defined FOG_COMBINED_WITH_WORLD_POS
    UNITY_TRANSFER_FOG_COMBINED_WITH_WORLD_POS(o,o.pos); // pass fog coordinates to pixel shader
  #else
    UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
  #endif
  return o;
}

// fragment shader
fixed4 frag_surf (v2f_surf IN) : SV_Target {
  UNITY_SETUP_INSTANCE_ID(IN);
  // prepare and unpack data
  Input surfIN;
  #ifdef FOG_COMBINED_WITH_TSPACE
    UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
  #elif defined FOG_COMBINED_WITH_WORLD_POS
    UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
  #else
    UNITY_EXTRACT_FOG(IN);
  #endif
  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
  surfIN.uv_MainTex.x = 1.0;
  surfIN.uv_Textures.x = 1.0;
  surfIN.worldPos.x = 1.0;
  float3 worldPos = IN.worldPos.xyz;
  #ifndef USING_DIRECTIONAL_LIGHT
    fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
  #else
    fixed3 lightDir = _WorldSpaceLightPos0.xyz;
  #endif
  float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
  #ifdef UNITY_COMPILER_HLSL
  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
  #else
  SurfaceOutputStandard o;
  #endif
  o.Albedo = 0.0;
  o.Emission = 0.0;
  o.Alpha = 0.0;
  o.Occlusion = 1.0;
  fixed3 normalWorldVertex = fixed3(0,0,1);
  o.Normal = IN.worldNormal;
  normalWorldVertex = IN.worldNormal;

  // call surface function
  surf (surfIN, o);

  // compute lighting & shadowing factor
  UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
  fixed4 c = 0;

  // Setup lighting environment
  UnityGI gi;
  UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
  gi.indirect.diffuse = 0;
  gi.indirect.specular = 0;
  gi.light.color = _LightColor0.rgb;
  gi.light.dir = lightDir;
  // Call GI (lightmaps/SH/reflections) lighting function
  UnityGIInput giInput;
  UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
  giInput.light = gi.light;
  giInput.worldPos = worldPos;
  giInput.worldViewDir = worldViewDir;
  giInput.atten = atten;
  #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
    giInput.lightmapUV = IN.lmap;
  #else
    giInput.lightmapUV = 0.0;
  #endif
  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
    giInput.ambient = IN.sh;
  #else
    giInput.ambient.rgb = 0.0;
  #endif
  giInput.probeHDR[0] = unity_SpecCube0_HDR;
  giInput.probeHDR[1] = unity_SpecCube1_HDR;
  #if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
    giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
  #endif
  #ifdef UNITY_SPECCUBE_BOX_PROJECTION
    giInput.boxMax[0] = unity_SpecCube0_BoxMax;
    giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
    giInput.boxMax[1] = unity_SpecCube1_BoxMax;
    giInput.boxMin[1] = unity_SpecCube1_BoxMin;
    giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
  #endif
  LightingStandard_GI(o, giInput, gi);

  // realtime lighting: call lighting function
  c += LightingStandard (o, worldViewDir, gi);
  UNITY_APPLY_FOG(_unity_fogCoord, c); // apply fog
  UNITY_OPAQUE_ALPHA(c.a);
  return c;
}


#endif

// -------- variant for: INSTANCING_ON 
#if defined(INSTANCING_ON) && !defined(PROCEDURAL_INSTANCING_ON)
// Surface shader code generated based on:
// vertex modifier: 'vert'
// writes to per-pixel normal: no
// writes to emission: no
// writes to occlusion: no
// needs world space reflection vector: no
// needs world space normal vector: no
// needs screen space position: no
// needs world space position: no
// needs view direction: no
// needs world space view direction: no
// needs world space position for lighting: YES
// needs world space view direction for lighting: YES
// needs world space view direction for lightmaps: no
// needs vertex color: no
// needs VFACE: no
// passes tangent-to-world matrix to pixel shader: no
// reads from normal: no
// 0 texcoords actually used
#include "UnityCG.cginc"
#include "UnityPBSLighting.cginc"
#include "AutoLight.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 21 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif
/* UNITY: Original start of shader */
			// Physically based Standard lighting model, and enable shadows on all light types
			//#pragma surface surf Standard addshadow fullforwardshadows vertex:vert
			//#pragma multi_compile_instancing
			//#pragma instancing_options procedural:setup
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			// Use shader model 3.0 target, to get nicer looking lighting
			//#pragma target 3.0

			sampler2D _HeightTex;
		/*****************************************************************
			Planet Info
			x -> planet Radius -> (chunkSize - 1) * MaxScale
			y -> Max terrain height
			********************************************************************/
			float3 _PlanetInfo;

			UNITY_DECLARE_TEX2DARRAY(_Textures);

			struct Input {
				float2 uv_MainTex;
				fixed2 uv_Textures;
				float3 worldPos;
			};

			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
			StructuredBuffer<float4> positionBuffer;
			StructuredBuffer<float4> directionsBuffer;		
			#endif

				void setup()
				{
				#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
					float4 data = positionBuffer[unity_InstanceID];
					data.xyz = 0;
					data.w = 1;
					unity_ObjectToWorld._11_21_31_41 = float4(data.w, 0, 0, 0);
					unity_ObjectToWorld._12_22_32_42 = float4(0, data.w, 0, 0);
					unity_ObjectToWorld._13_23_33_43 = float4(0, 0, data.w, 0);
					unity_ObjectToWorld._14_24_34_44 = float4(data.x, data.y, data.z, 1);
					unity_WorldToObject = unity_ObjectToWorld;
					unity_WorldToObject._14_24_34 *= -1;
					unity_WorldToObject._11_22_33 = 1.0f / unity_WorldToObject._11_22_33;
				#endif
				}

			int _TexturesArrayLength;
			float _TexturesArray[20];
			uniform float _Angle;

			float _HeightMin;
			float _HeightMax;

			float _textureblend;

			float3x3 RotateAroundYInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
			
				return float3x3(
					cosa, 0, -sina,
					0,    1, 0,
					sina, 0, cosa);
			}
			float3x3 RotateAroundXInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
				return float3x3(
					1, 0,		0,
					0, cosa,	sina,
					0, -sina,	cosa);

			}
			float3x3 RotateAroundZInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
				
				return float3x3(
					cosa,	sina,	0,
					-sina,	cosa,	0,
					0,		0,		1);

			}

			void vert(inout appdata_full v) {
			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
				float4 transform = directionsBuffer[unity_InstanceID];

				float4 data = positionBuffer[unity_InstanceID];

				float4 wolrldPosition = mul(unity_ObjectToWorld, v.vertex) / 5000;

				/*float x = wolrldPosition.x;
				float z = wolrldPosition.z;*/

				v.vertex.y = 1;
				float4 pos = v.vertex;
				float r = _PlanetInfo.x;

				if (transform.x != 0) {
					v.vertex.xyz = mul(RotateAroundXInDegrees(transform.x * 90), pos.xyz);
				}
				else if (transform.y != 0) {
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.y * 90), pos.xyz);	
				}
				else if(transform.z == -1){
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.z * 180), pos.xyz);
				}


				float x = (v.vertex.x+data.x)*data.w;
				float y = (v.vertex.y+data.y)*data.w;
				float z = (v.vertex.z+data.z)*data.w;

				float dx = x * sqrt(1.0f - (y*y * 0.5f) - (z * z * 0.5f) + (y*y*z*z / 3.0f));
				float dy = y * sqrt(1.0f - (z*z * 0.5f) - (x * x * 0.5f) + (z*z*x*x / 3.0f));
				float dz = z * sqrt(1.0f - (x*x * 0.5f) - (y * y * 0.5f) + (x*x*y*y / 3.0f));

				v.vertex.xyz = float3(dx, dy, dz);

				
				//v.vertex.xyz = normalize(UnityWorldSpaceViewDir(v.vertex.xyz);


				//v.vertex.y = (tex2Dlod(_HeightTex, float4(x , z , 0, 0) - 1) * _PlanetInfo.y + _PlanetInfo.x) / data.w;
				
				#endif
				}


			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// //#pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o) {

				float h = (_PlanetInfo.y + _PlanetInfo.x - IN.worldPos.y) / (_PlanetInfo.y);

				int index = 0;

				for (int i = 0; i < _TexturesArrayLength; i++) {
					if (h >= _TexturesArray[i]) {
						index = i;
						break;
					}
				}

				fixed4 c = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures,  index));


				/***********************
					Rozmazí krajních bodů textůr
				********************/

				if (((h - _textureblend) < _TexturesArray[index]) && index > 0) {
					float 	g = (_textureblend - h + _TexturesArray[index]) / (_textureblend * 2 + 0.001);
					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index + 1)));
					c = lerp(c, d, g);
				}
				else if ((index > 0) && ((h + _textureblend) > _TexturesArray[index - 1])) {
					float g;
					if (index == 1) {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend + 0.001);
					}
					else {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend * 2 + 0.001);
					}

					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index - 1)));
					c = lerp(c, d, g);
				}


				o.Albedo = 1;// c.rgb;
				o.Alpha = 1;


			}
			

// vertex-to-fragment interpolation data
// no lightmaps:
#ifndef LIGHTMAP_ON
// half-precision fragment shader registers:
#ifdef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
#define FOG_COMBINED_WITH_WORLD_POS
struct v2f_surf {
  UNITY_POSITION(pos);
  float3 worldNormal : TEXCOORD0;
  float4 worldPos : TEXCOORD1;
  #if UNITY_SHOULD_SAMPLE_SH
  half3 sh : TEXCOORD2; // SH
  #endif
  UNITY_LIGHTING_COORDS(3,4)
  #if SHADER_TARGET >= 30
  float4 lmap : TEXCOORD5;
  #endif
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};
#endif
// high-precision fragment shader registers:
#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
struct v2f_surf {
  UNITY_POSITION(pos);
  float3 worldNormal : TEXCOORD0;
  float3 worldPos : TEXCOORD1;
  #if UNITY_SHOULD_SAMPLE_SH
  half3 sh : TEXCOORD2; // SH
  #endif
  UNITY_FOG_COORDS(3)
  UNITY_SHADOW_COORDS(4)
  #if SHADER_TARGET >= 30
  float4 lmap : TEXCOORD5;
  #endif
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};
#endif
#endif
// with lightmaps:
#ifdef LIGHTMAP_ON
// half-precision fragment shader registers:
#ifdef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
#define FOG_COMBINED_WITH_WORLD_POS
struct v2f_surf {
  UNITY_POSITION(pos);
  float3 worldNormal : TEXCOORD0;
  float4 worldPos : TEXCOORD1;
  float4 lmap : TEXCOORD2;
  UNITY_LIGHTING_COORDS(3,4)
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};
#endif
// high-precision fragment shader registers:
#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
struct v2f_surf {
  UNITY_POSITION(pos);
  float3 worldNormal : TEXCOORD0;
  float3 worldPos : TEXCOORD1;
  float4 lmap : TEXCOORD2;
  UNITY_FOG_COORDS(3)
  UNITY_SHADOW_COORDS(4)
  #ifdef DIRLIGHTMAP_COMBINED
  float3 tSpace0 : TEXCOORD5;
  float3 tSpace1 : TEXCOORD6;
  float3 tSpace2 : TEXCOORD7;
  #endif
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};
#endif
#endif

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  UNITY_SETUP_INSTANCE_ID(v);
  v2f_surf o;
  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
  UNITY_TRANSFER_INSTANCE_ID(v,o);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
  vert (v);
  o.pos = UnityObjectToClipPos(v.vertex);
  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
  #if defined(LIGHTMAP_ON) && defined(DIRLIGHTMAP_COMBINED)
  fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
  fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
  fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
  #endif
  #if defined(LIGHTMAP_ON) && defined(DIRLIGHTMAP_COMBINED) && !defined(UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS)
  o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
  o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
  o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
  #endif
  o.worldPos.xyz = worldPos;
  o.worldNormal = worldNormal;
  #ifdef DYNAMICLIGHTMAP_ON
  o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
  #endif
  #ifdef LIGHTMAP_ON
  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
  #endif

  // SH/ambient and vertex lights
  #ifndef LIGHTMAP_ON
    #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
      o.sh = 0;
      // Approximated illumination from non-important point lights
      #ifdef VERTEXLIGHT_ON
        o.sh += Shade4PointLights (
          unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
          unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
          unity_4LightAtten0, worldPos, worldNormal);
      #endif
      o.sh = ShadeSHPerVertex (worldNormal, o.sh);
    #endif
  #endif // !LIGHTMAP_ON

  UNITY_TRANSFER_LIGHTING(o,v.texcoord1.xy); // pass shadow and, possibly, light cookie coordinates to pixel shader
  #ifdef FOG_COMBINED_WITH_TSPACE
    UNITY_TRANSFER_FOG_COMBINED_WITH_TSPACE(o,o.pos); // pass fog coordinates to pixel shader
  #elif defined FOG_COMBINED_WITH_WORLD_POS
    UNITY_TRANSFER_FOG_COMBINED_WITH_WORLD_POS(o,o.pos); // pass fog coordinates to pixel shader
  #else
    UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
  #endif
  return o;
}

// fragment shader
fixed4 frag_surf (v2f_surf IN) : SV_Target {
  UNITY_SETUP_INSTANCE_ID(IN);
  // prepare and unpack data
  Input surfIN;
  #ifdef FOG_COMBINED_WITH_TSPACE
    UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
  #elif defined FOG_COMBINED_WITH_WORLD_POS
    UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
  #else
    UNITY_EXTRACT_FOG(IN);
  #endif
  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
  surfIN.uv_MainTex.x = 1.0;
  surfIN.uv_Textures.x = 1.0;
  surfIN.worldPos.x = 1.0;
  float3 worldPos = IN.worldPos.xyz;
  #ifndef USING_DIRECTIONAL_LIGHT
    fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
  #else
    fixed3 lightDir = _WorldSpaceLightPos0.xyz;
  #endif
  float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
  #ifdef UNITY_COMPILER_HLSL
  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
  #else
  SurfaceOutputStandard o;
  #endif
  o.Albedo = 0.0;
  o.Emission = 0.0;
  o.Alpha = 0.0;
  o.Occlusion = 1.0;
  fixed3 normalWorldVertex = fixed3(0,0,1);
  o.Normal = IN.worldNormal;
  normalWorldVertex = IN.worldNormal;

  // call surface function
  surf (surfIN, o);

  // compute lighting & shadowing factor
  UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
  fixed4 c = 0;

  // Setup lighting environment
  UnityGI gi;
  UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
  gi.indirect.diffuse = 0;
  gi.indirect.specular = 0;
  gi.light.color = _LightColor0.rgb;
  gi.light.dir = lightDir;
  // Call GI (lightmaps/SH/reflections) lighting function
  UnityGIInput giInput;
  UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
  giInput.light = gi.light;
  giInput.worldPos = worldPos;
  giInput.worldViewDir = worldViewDir;
  giInput.atten = atten;
  #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
    giInput.lightmapUV = IN.lmap;
  #else
    giInput.lightmapUV = 0.0;
  #endif
  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
    giInput.ambient = IN.sh;
  #else
    giInput.ambient.rgb = 0.0;
  #endif
  giInput.probeHDR[0] = unity_SpecCube0_HDR;
  giInput.probeHDR[1] = unity_SpecCube1_HDR;
  #if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
    giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
  #endif
  #ifdef UNITY_SPECCUBE_BOX_PROJECTION
    giInput.boxMax[0] = unity_SpecCube0_BoxMax;
    giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
    giInput.boxMax[1] = unity_SpecCube1_BoxMax;
    giInput.boxMin[1] = unity_SpecCube1_BoxMin;
    giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
  #endif
  LightingStandard_GI(o, giInput, gi);

  // realtime lighting: call lighting function
  c += LightingStandard (o, worldViewDir, gi);
  UNITY_APPLY_FOG(_unity_fogCoord, c); // apply fog
  UNITY_OPAQUE_ALPHA(c.a);
  return c;
}


#endif

// -------- variant for: PROCEDURAL_INSTANCING_ON 
#if defined(PROCEDURAL_INSTANCING_ON) && !defined(INSTANCING_ON)
// Surface shader code generated based on:
// vertex modifier: 'vert'
// writes to per-pixel normal: no
// writes to emission: no
// writes to occlusion: no
// needs world space reflection vector: no
// needs world space normal vector: no
// needs screen space position: no
// needs world space position: no
// needs view direction: no
// needs world space view direction: no
// needs world space position for lighting: YES
// needs world space view direction for lighting: YES
// needs world space view direction for lightmaps: no
// needs vertex color: no
// needs VFACE: no
// passes tangent-to-world matrix to pixel shader: no
// reads from normal: no
// 0 texcoords actually used
#include "UnityCG.cginc"
#include "UnityPBSLighting.cginc"
#include "AutoLight.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 21 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif
/* UNITY: Original start of shader */
			// Physically based Standard lighting model, and enable shadows on all light types
			//#pragma surface surf Standard addshadow fullforwardshadows vertex:vert
			//#pragma multi_compile_instancing
			//#pragma instancing_options procedural:setup
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			// Use shader model 3.0 target, to get nicer looking lighting
			//#pragma target 3.0

			sampler2D _HeightTex;
		/*****************************************************************
			Planet Info
			x -> planet Radius -> (chunkSize - 1) * MaxScale
			y -> Max terrain height
			********************************************************************/
			float3 _PlanetInfo;

			UNITY_DECLARE_TEX2DARRAY(_Textures);

			struct Input {
				float2 uv_MainTex;
				fixed2 uv_Textures;
				float3 worldPos;
			};

			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
			StructuredBuffer<float4> positionBuffer;
			StructuredBuffer<float4> directionsBuffer;		
			#endif

				void setup()
				{
				#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
					float4 data = positionBuffer[unity_InstanceID];
					data.xyz = 0;
					data.w = 1;
					unity_ObjectToWorld._11_21_31_41 = float4(data.w, 0, 0, 0);
					unity_ObjectToWorld._12_22_32_42 = float4(0, data.w, 0, 0);
					unity_ObjectToWorld._13_23_33_43 = float4(0, 0, data.w, 0);
					unity_ObjectToWorld._14_24_34_44 = float4(data.x, data.y, data.z, 1);
					unity_WorldToObject = unity_ObjectToWorld;
					unity_WorldToObject._14_24_34 *= -1;
					unity_WorldToObject._11_22_33 = 1.0f / unity_WorldToObject._11_22_33;
				#endif
				}

			int _TexturesArrayLength;
			float _TexturesArray[20];
			uniform float _Angle;

			float _HeightMin;
			float _HeightMax;

			float _textureblend;

			float3x3 RotateAroundYInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
			
				return float3x3(
					cosa, 0, -sina,
					0,    1, 0,
					sina, 0, cosa);
			}
			float3x3 RotateAroundXInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
				return float3x3(
					1, 0,		0,
					0, cosa,	sina,
					0, -sina,	cosa);

			}
			float3x3 RotateAroundZInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
				
				return float3x3(
					cosa,	sina,	0,
					-sina,	cosa,	0,
					0,		0,		1);

			}

			void vert(inout appdata_full v) {
			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
				float4 transform = directionsBuffer[unity_InstanceID];

				float4 data = positionBuffer[unity_InstanceID];

				float4 wolrldPosition = mul(unity_ObjectToWorld, v.vertex) / 5000;

				/*float x = wolrldPosition.x;
				float z = wolrldPosition.z;*/

				v.vertex.y = 1;
				float4 pos = v.vertex;
				float r = _PlanetInfo.x;

				if (transform.x != 0) {
					v.vertex.xyz = mul(RotateAroundXInDegrees(transform.x * 90), pos.xyz);
				}
				else if (transform.y != 0) {
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.y * 90), pos.xyz);	
				}
				else if(transform.z == -1){
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.z * 180), pos.xyz);
				}


				float x = (v.vertex.x+data.x)*data.w;
				float y = (v.vertex.y+data.y)*data.w;
				float z = (v.vertex.z+data.z)*data.w;

				float dx = x * sqrt(1.0f - (y*y * 0.5f) - (z * z * 0.5f) + (y*y*z*z / 3.0f));
				float dy = y * sqrt(1.0f - (z*z * 0.5f) - (x * x * 0.5f) + (z*z*x*x / 3.0f));
				float dz = z * sqrt(1.0f - (x*x * 0.5f) - (y * y * 0.5f) + (x*x*y*y / 3.0f));

				v.vertex.xyz = float3(dx, dy, dz);

				
				//v.vertex.xyz = normalize(UnityWorldSpaceViewDir(v.vertex.xyz);


				//v.vertex.y = (tex2Dlod(_HeightTex, float4(x , z , 0, 0) - 1) * _PlanetInfo.y + _PlanetInfo.x) / data.w;
				
				#endif
				}


			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// //#pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o) {

				float h = (_PlanetInfo.y + _PlanetInfo.x - IN.worldPos.y) / (_PlanetInfo.y);

				int index = 0;

				for (int i = 0; i < _TexturesArrayLength; i++) {
					if (h >= _TexturesArray[i]) {
						index = i;
						break;
					}
				}

				fixed4 c = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures,  index));


				/***********************
					Rozmazí krajních bodů textůr
				********************/

				if (((h - _textureblend) < _TexturesArray[index]) && index > 0) {
					float 	g = (_textureblend - h + _TexturesArray[index]) / (_textureblend * 2 + 0.001);
					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index + 1)));
					c = lerp(c, d, g);
				}
				else if ((index > 0) && ((h + _textureblend) > _TexturesArray[index - 1])) {
					float g;
					if (index == 1) {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend + 0.001);
					}
					else {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend * 2 + 0.001);
					}

					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index - 1)));
					c = lerp(c, d, g);
				}


				o.Albedo = 1;// c.rgb;
				o.Alpha = 1;


			}
			

// vertex-to-fragment interpolation data
// no lightmaps:
#ifndef LIGHTMAP_ON
// half-precision fragment shader registers:
#ifdef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
#define FOG_COMBINED_WITH_WORLD_POS
struct v2f_surf {
  UNITY_POSITION(pos);
  float3 worldNormal : TEXCOORD0;
  float4 worldPos : TEXCOORD1;
  #if UNITY_SHOULD_SAMPLE_SH
  half3 sh : TEXCOORD2; // SH
  #endif
  UNITY_LIGHTING_COORDS(3,4)
  #if SHADER_TARGET >= 30
  float4 lmap : TEXCOORD5;
  #endif
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};
#endif
// high-precision fragment shader registers:
#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
struct v2f_surf {
  UNITY_POSITION(pos);
  float3 worldNormal : TEXCOORD0;
  float3 worldPos : TEXCOORD1;
  #if UNITY_SHOULD_SAMPLE_SH
  half3 sh : TEXCOORD2; // SH
  #endif
  UNITY_FOG_COORDS(3)
  UNITY_SHADOW_COORDS(4)
  #if SHADER_TARGET >= 30
  float4 lmap : TEXCOORD5;
  #endif
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};
#endif
#endif
// with lightmaps:
#ifdef LIGHTMAP_ON
// half-precision fragment shader registers:
#ifdef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
#define FOG_COMBINED_WITH_WORLD_POS
struct v2f_surf {
  UNITY_POSITION(pos);
  float3 worldNormal : TEXCOORD0;
  float4 worldPos : TEXCOORD1;
  float4 lmap : TEXCOORD2;
  UNITY_LIGHTING_COORDS(3,4)
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};
#endif
// high-precision fragment shader registers:
#ifndef UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS
struct v2f_surf {
  UNITY_POSITION(pos);
  float3 worldNormal : TEXCOORD0;
  float3 worldPos : TEXCOORD1;
  float4 lmap : TEXCOORD2;
  UNITY_FOG_COORDS(3)
  UNITY_SHADOW_COORDS(4)
  #ifdef DIRLIGHTMAP_COMBINED
  float3 tSpace0 : TEXCOORD5;
  float3 tSpace1 : TEXCOORD6;
  float3 tSpace2 : TEXCOORD7;
  #endif
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};
#endif
#endif

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  UNITY_SETUP_INSTANCE_ID(v);
  v2f_surf o;
  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
  UNITY_TRANSFER_INSTANCE_ID(v,o);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
  vert (v);
  o.pos = UnityObjectToClipPos(v.vertex);
  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
  #if defined(LIGHTMAP_ON) && defined(DIRLIGHTMAP_COMBINED)
  fixed3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
  fixed tangentSign = v.tangent.w * unity_WorldTransformParams.w;
  fixed3 worldBinormal = cross(worldNormal, worldTangent) * tangentSign;
  #endif
  #if defined(LIGHTMAP_ON) && defined(DIRLIGHTMAP_COMBINED) && !defined(UNITY_HALF_PRECISION_FRAGMENT_SHADER_REGISTERS)
  o.tSpace0 = float4(worldTangent.x, worldBinormal.x, worldNormal.x, worldPos.x);
  o.tSpace1 = float4(worldTangent.y, worldBinormal.y, worldNormal.y, worldPos.y);
  o.tSpace2 = float4(worldTangent.z, worldBinormal.z, worldNormal.z, worldPos.z);
  #endif
  o.worldPos.xyz = worldPos;
  o.worldNormal = worldNormal;
  #ifdef DYNAMICLIGHTMAP_ON
  o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
  #endif
  #ifdef LIGHTMAP_ON
  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
  #endif

  // SH/ambient and vertex lights
  #ifndef LIGHTMAP_ON
    #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
      o.sh = 0;
      // Approximated illumination from non-important point lights
      #ifdef VERTEXLIGHT_ON
        o.sh += Shade4PointLights (
          unity_4LightPosX0, unity_4LightPosY0, unity_4LightPosZ0,
          unity_LightColor[0].rgb, unity_LightColor[1].rgb, unity_LightColor[2].rgb, unity_LightColor[3].rgb,
          unity_4LightAtten0, worldPos, worldNormal);
      #endif
      o.sh = ShadeSHPerVertex (worldNormal, o.sh);
    #endif
  #endif // !LIGHTMAP_ON

  UNITY_TRANSFER_LIGHTING(o,v.texcoord1.xy); // pass shadow and, possibly, light cookie coordinates to pixel shader
  #ifdef FOG_COMBINED_WITH_TSPACE
    UNITY_TRANSFER_FOG_COMBINED_WITH_TSPACE(o,o.pos); // pass fog coordinates to pixel shader
  #elif defined FOG_COMBINED_WITH_WORLD_POS
    UNITY_TRANSFER_FOG_COMBINED_WITH_WORLD_POS(o,o.pos); // pass fog coordinates to pixel shader
  #else
    UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
  #endif
  return o;
}

// fragment shader
fixed4 frag_surf (v2f_surf IN) : SV_Target {
  UNITY_SETUP_INSTANCE_ID(IN);
  // prepare and unpack data
  Input surfIN;
  #ifdef FOG_COMBINED_WITH_TSPACE
    UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
  #elif defined FOG_COMBINED_WITH_WORLD_POS
    UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
  #else
    UNITY_EXTRACT_FOG(IN);
  #endif
  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
  surfIN.uv_MainTex.x = 1.0;
  surfIN.uv_Textures.x = 1.0;
  surfIN.worldPos.x = 1.0;
  float3 worldPos = IN.worldPos.xyz;
  #ifndef USING_DIRECTIONAL_LIGHT
    fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
  #else
    fixed3 lightDir = _WorldSpaceLightPos0.xyz;
  #endif
  float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
  #ifdef UNITY_COMPILER_HLSL
  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
  #else
  SurfaceOutputStandard o;
  #endif
  o.Albedo = 0.0;
  o.Emission = 0.0;
  o.Alpha = 0.0;
  o.Occlusion = 1.0;
  fixed3 normalWorldVertex = fixed3(0,0,1);
  o.Normal = IN.worldNormal;
  normalWorldVertex = IN.worldNormal;

  // call surface function
  surf (surfIN, o);

  // compute lighting & shadowing factor
  UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
  fixed4 c = 0;

  // Setup lighting environment
  UnityGI gi;
  UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
  gi.indirect.diffuse = 0;
  gi.indirect.specular = 0;
  gi.light.color = _LightColor0.rgb;
  gi.light.dir = lightDir;
  // Call GI (lightmaps/SH/reflections) lighting function
  UnityGIInput giInput;
  UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
  giInput.light = gi.light;
  giInput.worldPos = worldPos;
  giInput.worldViewDir = worldViewDir;
  giInput.atten = atten;
  #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
    giInput.lightmapUV = IN.lmap;
  #else
    giInput.lightmapUV = 0.0;
  #endif
  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
    giInput.ambient = IN.sh;
  #else
    giInput.ambient.rgb = 0.0;
  #endif
  giInput.probeHDR[0] = unity_SpecCube0_HDR;
  giInput.probeHDR[1] = unity_SpecCube1_HDR;
  #if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
    giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
  #endif
  #ifdef UNITY_SPECCUBE_BOX_PROJECTION
    giInput.boxMax[0] = unity_SpecCube0_BoxMax;
    giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
    giInput.boxMax[1] = unity_SpecCube1_BoxMax;
    giInput.boxMin[1] = unity_SpecCube1_BoxMin;
    giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
  #endif
  LightingStandard_GI(o, giInput, gi);

  // realtime lighting: call lighting function
  c += LightingStandard (o, worldViewDir, gi);
  UNITY_APPLY_FOG(_unity_fogCoord, c); // apply fog
  UNITY_OPAQUE_ALPHA(c.a);
  return c;
}


#endif


ENDCG

}

	// ---- forward rendering additive lights pass:
	Pass {
		Name "FORWARD"
		Tags { "LightMode" = "ForwardAdd" }
		ZWrite Off Blend One One

CGPROGRAM
// compile directives
#pragma vertex vert_surf
#pragma fragment frag_surf
#pragma multi_compile_instancing
#pragma instancing_options procedural:setup
#pragma target 3.0
#pragma multi_compile_fog
#pragma skip_variants INSTANCING_ON
#pragma multi_compile_fwdadd_fullshadows
#include "HLSLSupport.cginc"
#define UNITY_INSTANCED_LOD_FADE
#define UNITY_INSTANCED_SH
#define UNITY_INSTANCED_LIGHTMAPSTS
#define UNITY_INSTANCING_PROCEDURAL_FUNC setup
#include "UnityShaderVariables.cginc"
#include "UnityShaderUtilities.cginc"
// -------- variant for: <when no other keywords are defined>
#if !defined(INSTANCING_ON) && !defined(PROCEDURAL_INSTANCING_ON)
// Surface shader code generated based on:
// vertex modifier: 'vert'
// writes to per-pixel normal: no
// writes to emission: no
// writes to occlusion: no
// needs world space reflection vector: no
// needs world space normal vector: no
// needs screen space position: no
// needs world space position: no
// needs view direction: no
// needs world space view direction: no
// needs world space position for lighting: YES
// needs world space view direction for lighting: YES
// needs world space view direction for lightmaps: no
// needs vertex color: no
// needs VFACE: no
// passes tangent-to-world matrix to pixel shader: no
// reads from normal: no
// 0 texcoords actually used
#include "UnityCG.cginc"
#include "UnityPBSLighting.cginc"
#include "AutoLight.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 21 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif
/* UNITY: Original start of shader */
			// Physically based Standard lighting model, and enable shadows on all light types
			//#pragma surface surf Standard addshadow fullforwardshadows vertex:vert
			//#pragma multi_compile_instancing
			//#pragma instancing_options procedural:setup
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			// Use shader model 3.0 target, to get nicer looking lighting
			//#pragma target 3.0

			sampler2D _HeightTex;
		/*****************************************************************
			Planet Info
			x -> planet Radius -> (chunkSize - 1) * MaxScale
			y -> Max terrain height
			********************************************************************/
			float3 _PlanetInfo;

			UNITY_DECLARE_TEX2DARRAY(_Textures);

			struct Input {
				float2 uv_MainTex;
				fixed2 uv_Textures;
				float3 worldPos;
			};

			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
			StructuredBuffer<float4> positionBuffer;
			StructuredBuffer<float4> directionsBuffer;		
			#endif

				void setup()
				{
				#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
					float4 data = positionBuffer[unity_InstanceID];
					data.xyz = 0;
					data.w = 1;
					unity_ObjectToWorld._11_21_31_41 = float4(data.w, 0, 0, 0);
					unity_ObjectToWorld._12_22_32_42 = float4(0, data.w, 0, 0);
					unity_ObjectToWorld._13_23_33_43 = float4(0, 0, data.w, 0);
					unity_ObjectToWorld._14_24_34_44 = float4(data.x, data.y, data.z, 1);
					unity_WorldToObject = unity_ObjectToWorld;
					unity_WorldToObject._14_24_34 *= -1;
					unity_WorldToObject._11_22_33 = 1.0f / unity_WorldToObject._11_22_33;
				#endif
				}

			int _TexturesArrayLength;
			float _TexturesArray[20];
			uniform float _Angle;

			float _HeightMin;
			float _HeightMax;

			float _textureblend;

			float3x3 RotateAroundYInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
			
				return float3x3(
					cosa, 0, -sina,
					0,    1, 0,
					sina, 0, cosa);
			}
			float3x3 RotateAroundXInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
				return float3x3(
					1, 0,		0,
					0, cosa,	sina,
					0, -sina,	cosa);

			}
			float3x3 RotateAroundZInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
				
				return float3x3(
					cosa,	sina,	0,
					-sina,	cosa,	0,
					0,		0,		1);

			}

			void vert(inout appdata_full v) {
			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
				float4 transform = directionsBuffer[unity_InstanceID];

				float4 data = positionBuffer[unity_InstanceID];

				float4 wolrldPosition = mul(unity_ObjectToWorld, v.vertex) / 5000;

				/*float x = wolrldPosition.x;
				float z = wolrldPosition.z;*/

				v.vertex.y = 1;
				float4 pos = v.vertex;
				float r = _PlanetInfo.x;

				if (transform.x != 0) {
					v.vertex.xyz = mul(RotateAroundXInDegrees(transform.x * 90), pos.xyz);
				}
				else if (transform.y != 0) {
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.y * 90), pos.xyz);	
				}
				else if(transform.z == -1){
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.z * 180), pos.xyz);
				}


				float x = (v.vertex.x+data.x)*data.w;
				float y = (v.vertex.y+data.y)*data.w;
				float z = (v.vertex.z+data.z)*data.w;

				float dx = x * sqrt(1.0f - (y*y * 0.5f) - (z * z * 0.5f) + (y*y*z*z / 3.0f));
				float dy = y * sqrt(1.0f - (z*z * 0.5f) - (x * x * 0.5f) + (z*z*x*x / 3.0f));
				float dz = z * sqrt(1.0f - (x*x * 0.5f) - (y * y * 0.5f) + (x*x*y*y / 3.0f));

				v.vertex.xyz = float3(dx, dy, dz);

				
				//v.vertex.xyz = normalize(UnityWorldSpaceViewDir(v.vertex.xyz);


				//v.vertex.y = (tex2Dlod(_HeightTex, float4(x , z , 0, 0) - 1) * _PlanetInfo.y + _PlanetInfo.x) / data.w;
				
				#endif
				}


			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// //#pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o) {

				float h = (_PlanetInfo.y + _PlanetInfo.x - IN.worldPos.y) / (_PlanetInfo.y);

				int index = 0;

				for (int i = 0; i < _TexturesArrayLength; i++) {
					if (h >= _TexturesArray[i]) {
						index = i;
						break;
					}
				}

				fixed4 c = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures,  index));


				/***********************
					Rozmazí krajních bodů textůr
				********************/

				if (((h - _textureblend) < _TexturesArray[index]) && index > 0) {
					float 	g = (_textureblend - h + _TexturesArray[index]) / (_textureblend * 2 + 0.001);
					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index + 1)));
					c = lerp(c, d, g);
				}
				else if ((index > 0) && ((h + _textureblend) > _TexturesArray[index - 1])) {
					float g;
					if (index == 1) {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend + 0.001);
					}
					else {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend * 2 + 0.001);
					}

					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index - 1)));
					c = lerp(c, d, g);
				}


				o.Albedo = 1;// c.rgb;
				o.Alpha = 1;


			}
			

// vertex-to-fragment interpolation data
struct v2f_surf {
  UNITY_POSITION(pos);
  float3 worldNormal : TEXCOORD0;
  float3 worldPos : TEXCOORD1;
  UNITY_LIGHTING_COORDS(2,3)
  UNITY_FOG_COORDS(4)
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  UNITY_SETUP_INSTANCE_ID(v);
  v2f_surf o;
  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
  UNITY_TRANSFER_INSTANCE_ID(v,o);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
  vert (v);
  o.pos = UnityObjectToClipPos(v.vertex);
  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
  o.worldPos.xyz = worldPos;
  o.worldNormal = worldNormal;

  UNITY_TRANSFER_LIGHTING(o,v.texcoord1.xy); // pass shadow and, possibly, light cookie coordinates to pixel shader
  UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
  return o;
}

// fragment shader
fixed4 frag_surf (v2f_surf IN) : SV_Target {
  UNITY_SETUP_INSTANCE_ID(IN);
  // prepare and unpack data
  Input surfIN;
  #ifdef FOG_COMBINED_WITH_TSPACE
    UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
  #elif defined FOG_COMBINED_WITH_WORLD_POS
    UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
  #else
    UNITY_EXTRACT_FOG(IN);
  #endif
  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
  surfIN.uv_MainTex.x = 1.0;
  surfIN.uv_Textures.x = 1.0;
  surfIN.worldPos.x = 1.0;
  float3 worldPos = IN.worldPos.xyz;
  #ifndef USING_DIRECTIONAL_LIGHT
    fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
  #else
    fixed3 lightDir = _WorldSpaceLightPos0.xyz;
  #endif
  float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
  #ifdef UNITY_COMPILER_HLSL
  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
  #else
  SurfaceOutputStandard o;
  #endif
  o.Albedo = 0.0;
  o.Emission = 0.0;
  o.Alpha = 0.0;
  o.Occlusion = 1.0;
  fixed3 normalWorldVertex = fixed3(0,0,1);
  o.Normal = IN.worldNormal;
  normalWorldVertex = IN.worldNormal;

  // call surface function
  surf (surfIN, o);
  UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
  fixed4 c = 0;

  // Setup lighting environment
  UnityGI gi;
  UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
  gi.indirect.diffuse = 0;
  gi.indirect.specular = 0;
  gi.light.color = _LightColor0.rgb;
  gi.light.dir = lightDir;
  gi.light.color *= atten;
  c += LightingStandard (o, worldViewDir, gi);
  c.a = 0.0;
  UNITY_APPLY_FOG(_unity_fogCoord, c); // apply fog
  UNITY_OPAQUE_ALPHA(c.a);
  return c;
}


#endif

// -------- variant for: PROCEDURAL_INSTANCING_ON 
#if defined(PROCEDURAL_INSTANCING_ON) && !defined(INSTANCING_ON)
// Surface shader code generated based on:
// vertex modifier: 'vert'
// writes to per-pixel normal: no
// writes to emission: no
// writes to occlusion: no
// needs world space reflection vector: no
// needs world space normal vector: no
// needs screen space position: no
// needs world space position: no
// needs view direction: no
// needs world space view direction: no
// needs world space position for lighting: YES
// needs world space view direction for lighting: YES
// needs world space view direction for lightmaps: no
// needs vertex color: no
// needs VFACE: no
// passes tangent-to-world matrix to pixel shader: no
// reads from normal: no
// 0 texcoords actually used
#include "UnityCG.cginc"
#include "UnityPBSLighting.cginc"
#include "AutoLight.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 21 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif
/* UNITY: Original start of shader */
			// Physically based Standard lighting model, and enable shadows on all light types
			//#pragma surface surf Standard addshadow fullforwardshadows vertex:vert
			//#pragma multi_compile_instancing
			//#pragma instancing_options procedural:setup
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			// Use shader model 3.0 target, to get nicer looking lighting
			//#pragma target 3.0

			sampler2D _HeightTex;
		/*****************************************************************
			Planet Info
			x -> planet Radius -> (chunkSize - 1) * MaxScale
			y -> Max terrain height
			********************************************************************/
			float3 _PlanetInfo;

			UNITY_DECLARE_TEX2DARRAY(_Textures);

			struct Input {
				float2 uv_MainTex;
				fixed2 uv_Textures;
				float3 worldPos;
			};

			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
			StructuredBuffer<float4> positionBuffer;
			StructuredBuffer<float4> directionsBuffer;		
			#endif

				void setup()
				{
				#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
					float4 data = positionBuffer[unity_InstanceID];
					data.xyz = 0;
					data.w = 1;
					unity_ObjectToWorld._11_21_31_41 = float4(data.w, 0, 0, 0);
					unity_ObjectToWorld._12_22_32_42 = float4(0, data.w, 0, 0);
					unity_ObjectToWorld._13_23_33_43 = float4(0, 0, data.w, 0);
					unity_ObjectToWorld._14_24_34_44 = float4(data.x, data.y, data.z, 1);
					unity_WorldToObject = unity_ObjectToWorld;
					unity_WorldToObject._14_24_34 *= -1;
					unity_WorldToObject._11_22_33 = 1.0f / unity_WorldToObject._11_22_33;
				#endif
				}

			int _TexturesArrayLength;
			float _TexturesArray[20];
			uniform float _Angle;

			float _HeightMin;
			float _HeightMax;

			float _textureblend;

			float3x3 RotateAroundYInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
			
				return float3x3(
					cosa, 0, -sina,
					0,    1, 0,
					sina, 0, cosa);
			}
			float3x3 RotateAroundXInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
				return float3x3(
					1, 0,		0,
					0, cosa,	sina,
					0, -sina,	cosa);

			}
			float3x3 RotateAroundZInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
				
				return float3x3(
					cosa,	sina,	0,
					-sina,	cosa,	0,
					0,		0,		1);

			}

			void vert(inout appdata_full v) {
			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
				float4 transform = directionsBuffer[unity_InstanceID];

				float4 data = positionBuffer[unity_InstanceID];

				float4 wolrldPosition = mul(unity_ObjectToWorld, v.vertex) / 5000;

				/*float x = wolrldPosition.x;
				float z = wolrldPosition.z;*/

				v.vertex.y = 1;
				float4 pos = v.vertex;
				float r = _PlanetInfo.x;

				if (transform.x != 0) {
					v.vertex.xyz = mul(RotateAroundXInDegrees(transform.x * 90), pos.xyz);
				}
				else if (transform.y != 0) {
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.y * 90), pos.xyz);	
				}
				else if(transform.z == -1){
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.z * 180), pos.xyz);
				}


				float x = (v.vertex.x+data.x)*data.w;
				float y = (v.vertex.y+data.y)*data.w;
				float z = (v.vertex.z+data.z)*data.w;

				float dx = x * sqrt(1.0f - (y*y * 0.5f) - (z * z * 0.5f) + (y*y*z*z / 3.0f));
				float dy = y * sqrt(1.0f - (z*z * 0.5f) - (x * x * 0.5f) + (z*z*x*x / 3.0f));
				float dz = z * sqrt(1.0f - (x*x * 0.5f) - (y * y * 0.5f) + (x*x*y*y / 3.0f));

				v.vertex.xyz = float3(dx, dy, dz);

				
				//v.vertex.xyz = normalize(UnityWorldSpaceViewDir(v.vertex.xyz);


				//v.vertex.y = (tex2Dlod(_HeightTex, float4(x , z , 0, 0) - 1) * _PlanetInfo.y + _PlanetInfo.x) / data.w;
				
				#endif
				}


			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// //#pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o) {

				float h = (_PlanetInfo.y + _PlanetInfo.x - IN.worldPos.y) / (_PlanetInfo.y);

				int index = 0;

				for (int i = 0; i < _TexturesArrayLength; i++) {
					if (h >= _TexturesArray[i]) {
						index = i;
						break;
					}
				}

				fixed4 c = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures,  index));


				/***********************
					Rozmazí krajních bodů textůr
				********************/

				if (((h - _textureblend) < _TexturesArray[index]) && index > 0) {
					float 	g = (_textureblend - h + _TexturesArray[index]) / (_textureblend * 2 + 0.001);
					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index + 1)));
					c = lerp(c, d, g);
				}
				else if ((index > 0) && ((h + _textureblend) > _TexturesArray[index - 1])) {
					float g;
					if (index == 1) {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend + 0.001);
					}
					else {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend * 2 + 0.001);
					}

					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index - 1)));
					c = lerp(c, d, g);
				}


				o.Albedo = 1;// c.rgb;
				o.Alpha = 1;


			}
			

// vertex-to-fragment interpolation data
struct v2f_surf {
  UNITY_POSITION(pos);
  float3 worldNormal : TEXCOORD0;
  float3 worldPos : TEXCOORD1;
  UNITY_LIGHTING_COORDS(2,3)
  UNITY_FOG_COORDS(4)
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  UNITY_SETUP_INSTANCE_ID(v);
  v2f_surf o;
  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
  UNITY_TRANSFER_INSTANCE_ID(v,o);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
  vert (v);
  o.pos = UnityObjectToClipPos(v.vertex);
  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
  o.worldPos.xyz = worldPos;
  o.worldNormal = worldNormal;

  UNITY_TRANSFER_LIGHTING(o,v.texcoord1.xy); // pass shadow and, possibly, light cookie coordinates to pixel shader
  UNITY_TRANSFER_FOG(o,o.pos); // pass fog coordinates to pixel shader
  return o;
}

// fragment shader
fixed4 frag_surf (v2f_surf IN) : SV_Target {
  UNITY_SETUP_INSTANCE_ID(IN);
  // prepare and unpack data
  Input surfIN;
  #ifdef FOG_COMBINED_WITH_TSPACE
    UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
  #elif defined FOG_COMBINED_WITH_WORLD_POS
    UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
  #else
    UNITY_EXTRACT_FOG(IN);
  #endif
  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
  surfIN.uv_MainTex.x = 1.0;
  surfIN.uv_Textures.x = 1.0;
  surfIN.worldPos.x = 1.0;
  float3 worldPos = IN.worldPos.xyz;
  #ifndef USING_DIRECTIONAL_LIGHT
    fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
  #else
    fixed3 lightDir = _WorldSpaceLightPos0.xyz;
  #endif
  float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
  #ifdef UNITY_COMPILER_HLSL
  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
  #else
  SurfaceOutputStandard o;
  #endif
  o.Albedo = 0.0;
  o.Emission = 0.0;
  o.Alpha = 0.0;
  o.Occlusion = 1.0;
  fixed3 normalWorldVertex = fixed3(0,0,1);
  o.Normal = IN.worldNormal;
  normalWorldVertex = IN.worldNormal;

  // call surface function
  surf (surfIN, o);
  UNITY_LIGHT_ATTENUATION(atten, IN, worldPos)
  fixed4 c = 0;

  // Setup lighting environment
  UnityGI gi;
  UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
  gi.indirect.diffuse = 0;
  gi.indirect.specular = 0;
  gi.light.color = _LightColor0.rgb;
  gi.light.dir = lightDir;
  gi.light.color *= atten;
  c += LightingStandard (o, worldViewDir, gi);
  c.a = 0.0;
  UNITY_APPLY_FOG(_unity_fogCoord, c); // apply fog
  UNITY_OPAQUE_ALPHA(c.a);
  return c;
}


#endif


ENDCG

}

	// ---- deferred shading pass:
	Pass {
		Name "DEFERRED"
		Tags { "LightMode" = "Deferred" }

CGPROGRAM
// compile directives
#pragma vertex vert_surf
#pragma fragment frag_surf
#pragma multi_compile_instancing
#pragma instancing_options procedural:setup
#pragma target 3.0
#pragma exclude_renderers nomrt
#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
#pragma multi_compile_prepassfinal
#include "HLSLSupport.cginc"
#define UNITY_INSTANCED_LOD_FADE
#define UNITY_INSTANCED_SH
#define UNITY_INSTANCED_LIGHTMAPSTS
#define UNITY_INSTANCING_PROCEDURAL_FUNC setup
#include "UnityShaderVariables.cginc"
#include "UnityShaderUtilities.cginc"
// -------- variant for: <when no other keywords are defined>
#if !defined(INSTANCING_ON) && !defined(PROCEDURAL_INSTANCING_ON)
// Surface shader code generated based on:
// vertex modifier: 'vert'
// writes to per-pixel normal: no
// writes to emission: no
// writes to occlusion: no
// needs world space reflection vector: no
// needs world space normal vector: no
// needs screen space position: no
// needs world space position: no
// needs view direction: no
// needs world space view direction: no
// needs world space position for lighting: YES
// needs world space view direction for lighting: YES
// needs world space view direction for lightmaps: no
// needs vertex color: no
// needs VFACE: no
// passes tangent-to-world matrix to pixel shader: no
// reads from normal: YES
// 0 texcoords actually used
#include "UnityCG.cginc"
#include "UnityPBSLighting.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 21 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif
/* UNITY: Original start of shader */
			// Physically based Standard lighting model, and enable shadows on all light types
			//#pragma surface surf Standard addshadow fullforwardshadows vertex:vert
			//#pragma multi_compile_instancing
			//#pragma instancing_options procedural:setup
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			// Use shader model 3.0 target, to get nicer looking lighting
			//#pragma target 3.0

			sampler2D _HeightTex;
		/*****************************************************************
			Planet Info
			x -> planet Radius -> (chunkSize - 1) * MaxScale
			y -> Max terrain height
			********************************************************************/
			float3 _PlanetInfo;

			UNITY_DECLARE_TEX2DARRAY(_Textures);

			struct Input {
				float2 uv_MainTex;
				fixed2 uv_Textures;
				float3 worldPos;
			};

			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
			StructuredBuffer<float4> positionBuffer;
			StructuredBuffer<float4> directionsBuffer;		
			#endif

				void setup()
				{
				#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
					float4 data = positionBuffer[unity_InstanceID];
					data.xyz = 0;
					data.w = 1;
					unity_ObjectToWorld._11_21_31_41 = float4(data.w, 0, 0, 0);
					unity_ObjectToWorld._12_22_32_42 = float4(0, data.w, 0, 0);
					unity_ObjectToWorld._13_23_33_43 = float4(0, 0, data.w, 0);
					unity_ObjectToWorld._14_24_34_44 = float4(data.x, data.y, data.z, 1);
					unity_WorldToObject = unity_ObjectToWorld;
					unity_WorldToObject._14_24_34 *= -1;
					unity_WorldToObject._11_22_33 = 1.0f / unity_WorldToObject._11_22_33;
				#endif
				}

			int _TexturesArrayLength;
			float _TexturesArray[20];
			uniform float _Angle;

			float _HeightMin;
			float _HeightMax;

			float _textureblend;

			float3x3 RotateAroundYInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
			
				return float3x3(
					cosa, 0, -sina,
					0,    1, 0,
					sina, 0, cosa);
			}
			float3x3 RotateAroundXInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
				return float3x3(
					1, 0,		0,
					0, cosa,	sina,
					0, -sina,	cosa);

			}
			float3x3 RotateAroundZInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
				
				return float3x3(
					cosa,	sina,	0,
					-sina,	cosa,	0,
					0,		0,		1);

			}

			void vert(inout appdata_full v) {
			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
				float4 transform = directionsBuffer[unity_InstanceID];

				float4 data = positionBuffer[unity_InstanceID];

				float4 wolrldPosition = mul(unity_ObjectToWorld, v.vertex) / 5000;

				/*float x = wolrldPosition.x;
				float z = wolrldPosition.z;*/

				v.vertex.y = 1;
				float4 pos = v.vertex;
				float r = _PlanetInfo.x;

				if (transform.x != 0) {
					v.vertex.xyz = mul(RotateAroundXInDegrees(transform.x * 90), pos.xyz);
				}
				else if (transform.y != 0) {
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.y * 90), pos.xyz);	
				}
				else if(transform.z == -1){
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.z * 180), pos.xyz);
				}


				float x = (v.vertex.x+data.x)*data.w;
				float y = (v.vertex.y+data.y)*data.w;
				float z = (v.vertex.z+data.z)*data.w;

				float dx = x * sqrt(1.0f - (y*y * 0.5f) - (z * z * 0.5f) + (y*y*z*z / 3.0f));
				float dy = y * sqrt(1.0f - (z*z * 0.5f) - (x * x * 0.5f) + (z*z*x*x / 3.0f));
				float dz = z * sqrt(1.0f - (x*x * 0.5f) - (y * y * 0.5f) + (x*x*y*y / 3.0f));

				v.vertex.xyz = float3(dx, dy, dz);

				
				//v.vertex.xyz = normalize(UnityWorldSpaceViewDir(v.vertex.xyz);


				//v.vertex.y = (tex2Dlod(_HeightTex, float4(x , z , 0, 0) - 1) * _PlanetInfo.y + _PlanetInfo.x) / data.w;
				
				#endif
				}


			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// //#pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o) {

				float h = (_PlanetInfo.y + _PlanetInfo.x - IN.worldPos.y) / (_PlanetInfo.y);

				int index = 0;

				for (int i = 0; i < _TexturesArrayLength; i++) {
					if (h >= _TexturesArray[i]) {
						index = i;
						break;
					}
				}

				fixed4 c = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures,  index));


				/***********************
					Rozmazí krajních bodů textůr
				********************/

				if (((h - _textureblend) < _TexturesArray[index]) && index > 0) {
					float 	g = (_textureblend - h + _TexturesArray[index]) / (_textureblend * 2 + 0.001);
					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index + 1)));
					c = lerp(c, d, g);
				}
				else if ((index > 0) && ((h + _textureblend) > _TexturesArray[index - 1])) {
					float g;
					if (index == 1) {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend + 0.001);
					}
					else {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend * 2 + 0.001);
					}

					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index - 1)));
					c = lerp(c, d, g);
				}


				o.Albedo = 1;// c.rgb;
				o.Alpha = 1;


			}
			

// vertex-to-fragment interpolation data
struct v2f_surf {
  UNITY_POSITION(pos);
  float3 worldNormal : TEXCOORD0;
  float3 worldPos : TEXCOORD1;
#ifndef DIRLIGHTMAP_OFF
  half3 viewDir : TEXCOORD2;
#endif
  float4 lmap : TEXCOORD3;
#ifndef LIGHTMAP_ON
  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
    half3 sh : TEXCOORD4; // SH
  #endif
#else
  #ifdef DIRLIGHTMAP_OFF
    float4 lmapFadePos : TEXCOORD4;
  #endif
#endif
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  UNITY_SETUP_INSTANCE_ID(v);
  v2f_surf o;
  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
  UNITY_TRANSFER_INSTANCE_ID(v,o);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
  vert (v);
  o.pos = UnityObjectToClipPos(v.vertex);
  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
  o.worldPos.xyz = worldPos;
  o.worldNormal = worldNormal;
  float3 viewDirForLight = UnityWorldSpaceViewDir(worldPos);
  #ifndef DIRLIGHTMAP_OFF
  o.viewDir = viewDirForLight;
  #endif
#ifdef DYNAMICLIGHTMAP_ON
  o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
#else
  o.lmap.zw = 0;
#endif
#ifdef LIGHTMAP_ON
  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
  #ifdef DIRLIGHTMAP_OFF
    o.lmapFadePos.xyz = (mul(unity_ObjectToWorld, v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w;
    o.lmapFadePos.w = (-UnityObjectToViewPos(v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w);
  #endif
#else
  o.lmap.xy = 0;
    #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
      o.sh = 0;
      o.sh = ShadeSHPerVertex (worldNormal, o.sh);
    #endif
#endif
  return o;
}
#ifdef LIGHTMAP_ON
float4 unity_LightmapFade;
#endif
fixed4 unity_Ambient;

// fragment shader
void frag_surf (v2f_surf IN,
    out half4 outGBuffer0 : SV_Target0,
    out half4 outGBuffer1 : SV_Target1,
    out half4 outGBuffer2 : SV_Target2,
    out half4 outEmission : SV_Target3
#if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
    , out half4 outShadowMask : SV_Target4
#endif
) {
  UNITY_SETUP_INSTANCE_ID(IN);
  // prepare and unpack data
  Input surfIN;
  #ifdef FOG_COMBINED_WITH_TSPACE
    UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
  #elif defined FOG_COMBINED_WITH_WORLD_POS
    UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
  #else
    UNITY_EXTRACT_FOG(IN);
  #endif
  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
  surfIN.uv_MainTex.x = 1.0;
  surfIN.uv_Textures.x = 1.0;
  surfIN.worldPos.x = 1.0;
  float3 worldPos = IN.worldPos.xyz;
  #ifndef USING_DIRECTIONAL_LIGHT
    fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
  #else
    fixed3 lightDir = _WorldSpaceLightPos0.xyz;
  #endif
  float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
  #ifdef UNITY_COMPILER_HLSL
  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
  #else
  SurfaceOutputStandard o;
  #endif
  o.Albedo = 0.0;
  o.Emission = 0.0;
  o.Alpha = 0.0;
  o.Occlusion = 1.0;
  fixed3 normalWorldVertex = fixed3(0,0,1);
  o.Normal = IN.worldNormal;
  normalWorldVertex = IN.worldNormal;

  // call surface function
  surf (surfIN, o);
fixed3 originalNormal = o.Normal;
  half atten = 1;

  // Setup lighting environment
  UnityGI gi;
  UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
  gi.indirect.diffuse = 0;
  gi.indirect.specular = 0;
  gi.light.color = 0;
  gi.light.dir = half3(0,1,0);
  // Call GI (lightmaps/SH/reflections) lighting function
  UnityGIInput giInput;
  UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
  giInput.light = gi.light;
  giInput.worldPos = worldPos;
  giInput.worldViewDir = worldViewDir;
  giInput.atten = atten;
  #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
    giInput.lightmapUV = IN.lmap;
  #else
    giInput.lightmapUV = 0.0;
  #endif
  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
    giInput.ambient = IN.sh;
  #else
    giInput.ambient.rgb = 0.0;
  #endif
  giInput.probeHDR[0] = unity_SpecCube0_HDR;
  giInput.probeHDR[1] = unity_SpecCube1_HDR;
  #if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
    giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
  #endif
  #ifdef UNITY_SPECCUBE_BOX_PROJECTION
    giInput.boxMax[0] = unity_SpecCube0_BoxMax;
    giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
    giInput.boxMax[1] = unity_SpecCube1_BoxMax;
    giInput.boxMin[1] = unity_SpecCube1_BoxMin;
    giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
  #endif
  LightingStandard_GI(o, giInput, gi);

  // call lighting function to output g-buffer
  outEmission = LightingStandard_Deferred (o, worldViewDir, gi, outGBuffer0, outGBuffer1, outGBuffer2);
  #if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
    outShadowMask = UnityGetRawBakedOcclusions (IN.lmap.xy, worldPos);
  #endif
  #ifndef UNITY_HDR_ON
  outEmission.rgb = exp2(-outEmission.rgb);
  #endif
}


#endif

// -------- variant for: INSTANCING_ON 
#if defined(INSTANCING_ON) && !defined(PROCEDURAL_INSTANCING_ON)
// Surface shader code generated based on:
// vertex modifier: 'vert'
// writes to per-pixel normal: no
// writes to emission: no
// writes to occlusion: no
// needs world space reflection vector: no
// needs world space normal vector: no
// needs screen space position: no
// needs world space position: no
// needs view direction: no
// needs world space view direction: no
// needs world space position for lighting: YES
// needs world space view direction for lighting: YES
// needs world space view direction for lightmaps: no
// needs vertex color: no
// needs VFACE: no
// passes tangent-to-world matrix to pixel shader: no
// reads from normal: YES
// 0 texcoords actually used
#include "UnityCG.cginc"
#include "UnityPBSLighting.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 21 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif
/* UNITY: Original start of shader */
			// Physically based Standard lighting model, and enable shadows on all light types
			//#pragma surface surf Standard addshadow fullforwardshadows vertex:vert
			//#pragma multi_compile_instancing
			//#pragma instancing_options procedural:setup
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			// Use shader model 3.0 target, to get nicer looking lighting
			//#pragma target 3.0

			sampler2D _HeightTex;
		/*****************************************************************
			Planet Info
			x -> planet Radius -> (chunkSize - 1) * MaxScale
			y -> Max terrain height
			********************************************************************/
			float3 _PlanetInfo;

			UNITY_DECLARE_TEX2DARRAY(_Textures);

			struct Input {
				float2 uv_MainTex;
				fixed2 uv_Textures;
				float3 worldPos;
			};

			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
			StructuredBuffer<float4> positionBuffer;
			StructuredBuffer<float4> directionsBuffer;		
			#endif

				void setup()
				{
				#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
					float4 data = positionBuffer[unity_InstanceID];
					data.xyz = 0;
					data.w = 1;
					unity_ObjectToWorld._11_21_31_41 = float4(data.w, 0, 0, 0);
					unity_ObjectToWorld._12_22_32_42 = float4(0, data.w, 0, 0);
					unity_ObjectToWorld._13_23_33_43 = float4(0, 0, data.w, 0);
					unity_ObjectToWorld._14_24_34_44 = float4(data.x, data.y, data.z, 1);
					unity_WorldToObject = unity_ObjectToWorld;
					unity_WorldToObject._14_24_34 *= -1;
					unity_WorldToObject._11_22_33 = 1.0f / unity_WorldToObject._11_22_33;
				#endif
				}

			int _TexturesArrayLength;
			float _TexturesArray[20];
			uniform float _Angle;

			float _HeightMin;
			float _HeightMax;

			float _textureblend;

			float3x3 RotateAroundYInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
			
				return float3x3(
					cosa, 0, -sina,
					0,    1, 0,
					sina, 0, cosa);
			}
			float3x3 RotateAroundXInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
				return float3x3(
					1, 0,		0,
					0, cosa,	sina,
					0, -sina,	cosa);

			}
			float3x3 RotateAroundZInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
				
				return float3x3(
					cosa,	sina,	0,
					-sina,	cosa,	0,
					0,		0,		1);

			}

			void vert(inout appdata_full v) {
			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
				float4 transform = directionsBuffer[unity_InstanceID];

				float4 data = positionBuffer[unity_InstanceID];

				float4 wolrldPosition = mul(unity_ObjectToWorld, v.vertex) / 5000;

				/*float x = wolrldPosition.x;
				float z = wolrldPosition.z;*/

				v.vertex.y = 1;
				float4 pos = v.vertex;
				float r = _PlanetInfo.x;

				if (transform.x != 0) {
					v.vertex.xyz = mul(RotateAroundXInDegrees(transform.x * 90), pos.xyz);
				}
				else if (transform.y != 0) {
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.y * 90), pos.xyz);	
				}
				else if(transform.z == -1){
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.z * 180), pos.xyz);
				}


				float x = (v.vertex.x+data.x)*data.w;
				float y = (v.vertex.y+data.y)*data.w;
				float z = (v.vertex.z+data.z)*data.w;

				float dx = x * sqrt(1.0f - (y*y * 0.5f) - (z * z * 0.5f) + (y*y*z*z / 3.0f));
				float dy = y * sqrt(1.0f - (z*z * 0.5f) - (x * x * 0.5f) + (z*z*x*x / 3.0f));
				float dz = z * sqrt(1.0f - (x*x * 0.5f) - (y * y * 0.5f) + (x*x*y*y / 3.0f));

				v.vertex.xyz = float3(dx, dy, dz);

				
				//v.vertex.xyz = normalize(UnityWorldSpaceViewDir(v.vertex.xyz);


				//v.vertex.y = (tex2Dlod(_HeightTex, float4(x , z , 0, 0) - 1) * _PlanetInfo.y + _PlanetInfo.x) / data.w;
				
				#endif
				}


			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// //#pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o) {

				float h = (_PlanetInfo.y + _PlanetInfo.x - IN.worldPos.y) / (_PlanetInfo.y);

				int index = 0;

				for (int i = 0; i < _TexturesArrayLength; i++) {
					if (h >= _TexturesArray[i]) {
						index = i;
						break;
					}
				}

				fixed4 c = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures,  index));


				/***********************
					Rozmazí krajních bodů textůr
				********************/

				if (((h - _textureblend) < _TexturesArray[index]) && index > 0) {
					float 	g = (_textureblend - h + _TexturesArray[index]) / (_textureblend * 2 + 0.001);
					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index + 1)));
					c = lerp(c, d, g);
				}
				else if ((index > 0) && ((h + _textureblend) > _TexturesArray[index - 1])) {
					float g;
					if (index == 1) {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend + 0.001);
					}
					else {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend * 2 + 0.001);
					}

					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index - 1)));
					c = lerp(c, d, g);
				}


				o.Albedo = 1;// c.rgb;
				o.Alpha = 1;


			}
			

// vertex-to-fragment interpolation data
struct v2f_surf {
  UNITY_POSITION(pos);
  float3 worldNormal : TEXCOORD0;
  float3 worldPos : TEXCOORD1;
#ifndef DIRLIGHTMAP_OFF
  half3 viewDir : TEXCOORD2;
#endif
  float4 lmap : TEXCOORD3;
#ifndef LIGHTMAP_ON
  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
    half3 sh : TEXCOORD4; // SH
  #endif
#else
  #ifdef DIRLIGHTMAP_OFF
    float4 lmapFadePos : TEXCOORD4;
  #endif
#endif
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  UNITY_SETUP_INSTANCE_ID(v);
  v2f_surf o;
  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
  UNITY_TRANSFER_INSTANCE_ID(v,o);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
  vert (v);
  o.pos = UnityObjectToClipPos(v.vertex);
  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
  o.worldPos.xyz = worldPos;
  o.worldNormal = worldNormal;
  float3 viewDirForLight = UnityWorldSpaceViewDir(worldPos);
  #ifndef DIRLIGHTMAP_OFF
  o.viewDir = viewDirForLight;
  #endif
#ifdef DYNAMICLIGHTMAP_ON
  o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
#else
  o.lmap.zw = 0;
#endif
#ifdef LIGHTMAP_ON
  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
  #ifdef DIRLIGHTMAP_OFF
    o.lmapFadePos.xyz = (mul(unity_ObjectToWorld, v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w;
    o.lmapFadePos.w = (-UnityObjectToViewPos(v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w);
  #endif
#else
  o.lmap.xy = 0;
    #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
      o.sh = 0;
      o.sh = ShadeSHPerVertex (worldNormal, o.sh);
    #endif
#endif
  return o;
}
#ifdef LIGHTMAP_ON
float4 unity_LightmapFade;
#endif
fixed4 unity_Ambient;

// fragment shader
void frag_surf (v2f_surf IN,
    out half4 outGBuffer0 : SV_Target0,
    out half4 outGBuffer1 : SV_Target1,
    out half4 outGBuffer2 : SV_Target2,
    out half4 outEmission : SV_Target3
#if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
    , out half4 outShadowMask : SV_Target4
#endif
) {
  UNITY_SETUP_INSTANCE_ID(IN);
  // prepare and unpack data
  Input surfIN;
  #ifdef FOG_COMBINED_WITH_TSPACE
    UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
  #elif defined FOG_COMBINED_WITH_WORLD_POS
    UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
  #else
    UNITY_EXTRACT_FOG(IN);
  #endif
  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
  surfIN.uv_MainTex.x = 1.0;
  surfIN.uv_Textures.x = 1.0;
  surfIN.worldPos.x = 1.0;
  float3 worldPos = IN.worldPos.xyz;
  #ifndef USING_DIRECTIONAL_LIGHT
    fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
  #else
    fixed3 lightDir = _WorldSpaceLightPos0.xyz;
  #endif
  float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
  #ifdef UNITY_COMPILER_HLSL
  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
  #else
  SurfaceOutputStandard o;
  #endif
  o.Albedo = 0.0;
  o.Emission = 0.0;
  o.Alpha = 0.0;
  o.Occlusion = 1.0;
  fixed3 normalWorldVertex = fixed3(0,0,1);
  o.Normal = IN.worldNormal;
  normalWorldVertex = IN.worldNormal;

  // call surface function
  surf (surfIN, o);
fixed3 originalNormal = o.Normal;
  half atten = 1;

  // Setup lighting environment
  UnityGI gi;
  UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
  gi.indirect.diffuse = 0;
  gi.indirect.specular = 0;
  gi.light.color = 0;
  gi.light.dir = half3(0,1,0);
  // Call GI (lightmaps/SH/reflections) lighting function
  UnityGIInput giInput;
  UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
  giInput.light = gi.light;
  giInput.worldPos = worldPos;
  giInput.worldViewDir = worldViewDir;
  giInput.atten = atten;
  #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
    giInput.lightmapUV = IN.lmap;
  #else
    giInput.lightmapUV = 0.0;
  #endif
  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
    giInput.ambient = IN.sh;
  #else
    giInput.ambient.rgb = 0.0;
  #endif
  giInput.probeHDR[0] = unity_SpecCube0_HDR;
  giInput.probeHDR[1] = unity_SpecCube1_HDR;
  #if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
    giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
  #endif
  #ifdef UNITY_SPECCUBE_BOX_PROJECTION
    giInput.boxMax[0] = unity_SpecCube0_BoxMax;
    giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
    giInput.boxMax[1] = unity_SpecCube1_BoxMax;
    giInput.boxMin[1] = unity_SpecCube1_BoxMin;
    giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
  #endif
  LightingStandard_GI(o, giInput, gi);

  // call lighting function to output g-buffer
  outEmission = LightingStandard_Deferred (o, worldViewDir, gi, outGBuffer0, outGBuffer1, outGBuffer2);
  #if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
    outShadowMask = UnityGetRawBakedOcclusions (IN.lmap.xy, worldPos);
  #endif
  #ifndef UNITY_HDR_ON
  outEmission.rgb = exp2(-outEmission.rgb);
  #endif
}


#endif

// -------- variant for: PROCEDURAL_INSTANCING_ON 
#if defined(PROCEDURAL_INSTANCING_ON) && !defined(INSTANCING_ON)
// Surface shader code generated based on:
// vertex modifier: 'vert'
// writes to per-pixel normal: no
// writes to emission: no
// writes to occlusion: no
// needs world space reflection vector: no
// needs world space normal vector: no
// needs screen space position: no
// needs world space position: no
// needs view direction: no
// needs world space view direction: no
// needs world space position for lighting: YES
// needs world space view direction for lighting: YES
// needs world space view direction for lightmaps: no
// needs vertex color: no
// needs VFACE: no
// passes tangent-to-world matrix to pixel shader: no
// reads from normal: YES
// 0 texcoords actually used
#include "UnityCG.cginc"
#include "UnityPBSLighting.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 21 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif
/* UNITY: Original start of shader */
			// Physically based Standard lighting model, and enable shadows on all light types
			//#pragma surface surf Standard addshadow fullforwardshadows vertex:vert
			//#pragma multi_compile_instancing
			//#pragma instancing_options procedural:setup
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			// Use shader model 3.0 target, to get nicer looking lighting
			//#pragma target 3.0

			sampler2D _HeightTex;
		/*****************************************************************
			Planet Info
			x -> planet Radius -> (chunkSize - 1) * MaxScale
			y -> Max terrain height
			********************************************************************/
			float3 _PlanetInfo;

			UNITY_DECLARE_TEX2DARRAY(_Textures);

			struct Input {
				float2 uv_MainTex;
				fixed2 uv_Textures;
				float3 worldPos;
			};

			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
			StructuredBuffer<float4> positionBuffer;
			StructuredBuffer<float4> directionsBuffer;		
			#endif

				void setup()
				{
				#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
					float4 data = positionBuffer[unity_InstanceID];
					data.xyz = 0;
					data.w = 1;
					unity_ObjectToWorld._11_21_31_41 = float4(data.w, 0, 0, 0);
					unity_ObjectToWorld._12_22_32_42 = float4(0, data.w, 0, 0);
					unity_ObjectToWorld._13_23_33_43 = float4(0, 0, data.w, 0);
					unity_ObjectToWorld._14_24_34_44 = float4(data.x, data.y, data.z, 1);
					unity_WorldToObject = unity_ObjectToWorld;
					unity_WorldToObject._14_24_34 *= -1;
					unity_WorldToObject._11_22_33 = 1.0f / unity_WorldToObject._11_22_33;
				#endif
				}

			int _TexturesArrayLength;
			float _TexturesArray[20];
			uniform float _Angle;

			float _HeightMin;
			float _HeightMax;

			float _textureblend;

			float3x3 RotateAroundYInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
			
				return float3x3(
					cosa, 0, -sina,
					0,    1, 0,
					sina, 0, cosa);
			}
			float3x3 RotateAroundXInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
				return float3x3(
					1, 0,		0,
					0, cosa,	sina,
					0, -sina,	cosa);

			}
			float3x3 RotateAroundZInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
				
				return float3x3(
					cosa,	sina,	0,
					-sina,	cosa,	0,
					0,		0,		1);

			}

			void vert(inout appdata_full v) {
			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
				float4 transform = directionsBuffer[unity_InstanceID];

				float4 data = positionBuffer[unity_InstanceID];

				float4 wolrldPosition = mul(unity_ObjectToWorld, v.vertex) / 5000;

				/*float x = wolrldPosition.x;
				float z = wolrldPosition.z;*/

				v.vertex.y = 1;
				float4 pos = v.vertex;
				float r = _PlanetInfo.x;

				if (transform.x != 0) {
					v.vertex.xyz = mul(RotateAroundXInDegrees(transform.x * 90), pos.xyz);
				}
				else if (transform.y != 0) {
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.y * 90), pos.xyz);	
				}
				else if(transform.z == -1){
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.z * 180), pos.xyz);
				}


				float x = (v.vertex.x+data.x)*data.w;
				float y = (v.vertex.y+data.y)*data.w;
				float z = (v.vertex.z+data.z)*data.w;

				float dx = x * sqrt(1.0f - (y*y * 0.5f) - (z * z * 0.5f) + (y*y*z*z / 3.0f));
				float dy = y * sqrt(1.0f - (z*z * 0.5f) - (x * x * 0.5f) + (z*z*x*x / 3.0f));
				float dz = z * sqrt(1.0f - (x*x * 0.5f) - (y * y * 0.5f) + (x*x*y*y / 3.0f));

				v.vertex.xyz = float3(dx, dy, dz);

				
				//v.vertex.xyz = normalize(UnityWorldSpaceViewDir(v.vertex.xyz);


				//v.vertex.y = (tex2Dlod(_HeightTex, float4(x , z , 0, 0) - 1) * _PlanetInfo.y + _PlanetInfo.x) / data.w;
				
				#endif
				}


			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// //#pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o) {

				float h = (_PlanetInfo.y + _PlanetInfo.x - IN.worldPos.y) / (_PlanetInfo.y);

				int index = 0;

				for (int i = 0; i < _TexturesArrayLength; i++) {
					if (h >= _TexturesArray[i]) {
						index = i;
						break;
					}
				}

				fixed4 c = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures,  index));


				/***********************
					Rozmazí krajních bodů textůr
				********************/

				if (((h - _textureblend) < _TexturesArray[index]) && index > 0) {
					float 	g = (_textureblend - h + _TexturesArray[index]) / (_textureblend * 2 + 0.001);
					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index + 1)));
					c = lerp(c, d, g);
				}
				else if ((index > 0) && ((h + _textureblend) > _TexturesArray[index - 1])) {
					float g;
					if (index == 1) {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend + 0.001);
					}
					else {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend * 2 + 0.001);
					}

					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index - 1)));
					c = lerp(c, d, g);
				}


				o.Albedo = 1;// c.rgb;
				o.Alpha = 1;


			}
			

// vertex-to-fragment interpolation data
struct v2f_surf {
  UNITY_POSITION(pos);
  float3 worldNormal : TEXCOORD0;
  float3 worldPos : TEXCOORD1;
#ifndef DIRLIGHTMAP_OFF
  half3 viewDir : TEXCOORD2;
#endif
  float4 lmap : TEXCOORD3;
#ifndef LIGHTMAP_ON
  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
    half3 sh : TEXCOORD4; // SH
  #endif
#else
  #ifdef DIRLIGHTMAP_OFF
    float4 lmapFadePos : TEXCOORD4;
  #endif
#endif
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  UNITY_SETUP_INSTANCE_ID(v);
  v2f_surf o;
  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
  UNITY_TRANSFER_INSTANCE_ID(v,o);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
  vert (v);
  o.pos = UnityObjectToClipPos(v.vertex);
  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
  o.worldPos.xyz = worldPos;
  o.worldNormal = worldNormal;
  float3 viewDirForLight = UnityWorldSpaceViewDir(worldPos);
  #ifndef DIRLIGHTMAP_OFF
  o.viewDir = viewDirForLight;
  #endif
#ifdef DYNAMICLIGHTMAP_ON
  o.lmap.zw = v.texcoord2.xy * unity_DynamicLightmapST.xy + unity_DynamicLightmapST.zw;
#else
  o.lmap.zw = 0;
#endif
#ifdef LIGHTMAP_ON
  o.lmap.xy = v.texcoord1.xy * unity_LightmapST.xy + unity_LightmapST.zw;
  #ifdef DIRLIGHTMAP_OFF
    o.lmapFadePos.xyz = (mul(unity_ObjectToWorld, v.vertex).xyz - unity_ShadowFadeCenterAndType.xyz) * unity_ShadowFadeCenterAndType.w;
    o.lmapFadePos.w = (-UnityObjectToViewPos(v.vertex).z) * (1.0 - unity_ShadowFadeCenterAndType.w);
  #endif
#else
  o.lmap.xy = 0;
    #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
      o.sh = 0;
      o.sh = ShadeSHPerVertex (worldNormal, o.sh);
    #endif
#endif
  return o;
}
#ifdef LIGHTMAP_ON
float4 unity_LightmapFade;
#endif
fixed4 unity_Ambient;

// fragment shader
void frag_surf (v2f_surf IN,
    out half4 outGBuffer0 : SV_Target0,
    out half4 outGBuffer1 : SV_Target1,
    out half4 outGBuffer2 : SV_Target2,
    out half4 outEmission : SV_Target3
#if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
    , out half4 outShadowMask : SV_Target4
#endif
) {
  UNITY_SETUP_INSTANCE_ID(IN);
  // prepare and unpack data
  Input surfIN;
  #ifdef FOG_COMBINED_WITH_TSPACE
    UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
  #elif defined FOG_COMBINED_WITH_WORLD_POS
    UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
  #else
    UNITY_EXTRACT_FOG(IN);
  #endif
  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
  surfIN.uv_MainTex.x = 1.0;
  surfIN.uv_Textures.x = 1.0;
  surfIN.worldPos.x = 1.0;
  float3 worldPos = IN.worldPos.xyz;
  #ifndef USING_DIRECTIONAL_LIGHT
    fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
  #else
    fixed3 lightDir = _WorldSpaceLightPos0.xyz;
  #endif
  float3 worldViewDir = normalize(UnityWorldSpaceViewDir(worldPos));
  #ifdef UNITY_COMPILER_HLSL
  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
  #else
  SurfaceOutputStandard o;
  #endif
  o.Albedo = 0.0;
  o.Emission = 0.0;
  o.Alpha = 0.0;
  o.Occlusion = 1.0;
  fixed3 normalWorldVertex = fixed3(0,0,1);
  o.Normal = IN.worldNormal;
  normalWorldVertex = IN.worldNormal;

  // call surface function
  surf (surfIN, o);
fixed3 originalNormal = o.Normal;
  half atten = 1;

  // Setup lighting environment
  UnityGI gi;
  UNITY_INITIALIZE_OUTPUT(UnityGI, gi);
  gi.indirect.diffuse = 0;
  gi.indirect.specular = 0;
  gi.light.color = 0;
  gi.light.dir = half3(0,1,0);
  // Call GI (lightmaps/SH/reflections) lighting function
  UnityGIInput giInput;
  UNITY_INITIALIZE_OUTPUT(UnityGIInput, giInput);
  giInput.light = gi.light;
  giInput.worldPos = worldPos;
  giInput.worldViewDir = worldViewDir;
  giInput.atten = atten;
  #if defined(LIGHTMAP_ON) || defined(DYNAMICLIGHTMAP_ON)
    giInput.lightmapUV = IN.lmap;
  #else
    giInput.lightmapUV = 0.0;
  #endif
  #if UNITY_SHOULD_SAMPLE_SH && !UNITY_SAMPLE_FULL_SH_PER_PIXEL
    giInput.ambient = IN.sh;
  #else
    giInput.ambient.rgb = 0.0;
  #endif
  giInput.probeHDR[0] = unity_SpecCube0_HDR;
  giInput.probeHDR[1] = unity_SpecCube1_HDR;
  #if defined(UNITY_SPECCUBE_BLENDING) || defined(UNITY_SPECCUBE_BOX_PROJECTION)
    giInput.boxMin[0] = unity_SpecCube0_BoxMin; // .w holds lerp value for blending
  #endif
  #ifdef UNITY_SPECCUBE_BOX_PROJECTION
    giInput.boxMax[0] = unity_SpecCube0_BoxMax;
    giInput.probePosition[0] = unity_SpecCube0_ProbePosition;
    giInput.boxMax[1] = unity_SpecCube1_BoxMax;
    giInput.boxMin[1] = unity_SpecCube1_BoxMin;
    giInput.probePosition[1] = unity_SpecCube1_ProbePosition;
  #endif
  LightingStandard_GI(o, giInput, gi);

  // call lighting function to output g-buffer
  outEmission = LightingStandard_Deferred (o, worldViewDir, gi, outGBuffer0, outGBuffer1, outGBuffer2);
  #if defined(SHADOWS_SHADOWMASK) && (UNITY_ALLOWED_MRT_COUNT > 4)
    outShadowMask = UnityGetRawBakedOcclusions (IN.lmap.xy, worldPos);
  #endif
  #ifndef UNITY_HDR_ON
  outEmission.rgb = exp2(-outEmission.rgb);
  #endif
}


#endif


ENDCG

}

	// ---- shadow caster pass:
	Pass {
		Name "ShadowCaster"
		Tags { "LightMode" = "ShadowCaster" }
		ZWrite On ZTest LEqual

CGPROGRAM
// compile directives
#pragma vertex vert_surf
#pragma fragment frag_surf
#pragma multi_compile_instancing
#pragma instancing_options procedural:setup
#pragma target 3.0
#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
#pragma multi_compile_shadowcaster
#include "HLSLSupport.cginc"
#define UNITY_INSTANCED_LOD_FADE
#define UNITY_INSTANCED_SH
#define UNITY_INSTANCED_LIGHTMAPSTS
#define UNITY_INSTANCING_PROCEDURAL_FUNC setup
#include "UnityShaderVariables.cginc"
#include "UnityShaderUtilities.cginc"
// -------- variant for: <when no other keywords are defined>
#if !defined(INSTANCING_ON) && !defined(PROCEDURAL_INSTANCING_ON)
// Surface shader code generated based on:
// vertex modifier: 'vert'
// writes to per-pixel normal: no
// writes to emission: no
// writes to occlusion: no
// needs world space reflection vector: no
// needs world space normal vector: no
// needs screen space position: no
// needs world space position: no
// needs view direction: no
// needs world space view direction: no
// needs world space position for lighting: YES
// needs world space view direction for lighting: YES
// needs world space view direction for lightmaps: no
// needs vertex color: no
// needs VFACE: no
// passes tangent-to-world matrix to pixel shader: no
// reads from normal: no
// 0 texcoords actually used
#include "UnityCG.cginc"
#include "UnityPBSLighting.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 21 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif
/* UNITY: Original start of shader */
			// Physically based Standard lighting model, and enable shadows on all light types
			//#pragma surface surf Standard addshadow fullforwardshadows vertex:vert
			//#pragma multi_compile_instancing
			//#pragma instancing_options procedural:setup
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			// Use shader model 3.0 target, to get nicer looking lighting
			//#pragma target 3.0

			sampler2D _HeightTex;
		/*****************************************************************
			Planet Info
			x -> planet Radius -> (chunkSize - 1) * MaxScale
			y -> Max terrain height
			********************************************************************/
			float3 _PlanetInfo;

			UNITY_DECLARE_TEX2DARRAY(_Textures);

			struct Input {
				float2 uv_MainTex;
				fixed2 uv_Textures;
				float3 worldPos;
			};

			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
			StructuredBuffer<float4> positionBuffer;
			StructuredBuffer<float4> directionsBuffer;		
			#endif

				void setup()
				{
				#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
					float4 data = positionBuffer[unity_InstanceID];
					data.xyz = 0;
					data.w = 1;
					unity_ObjectToWorld._11_21_31_41 = float4(data.w, 0, 0, 0);
					unity_ObjectToWorld._12_22_32_42 = float4(0, data.w, 0, 0);
					unity_ObjectToWorld._13_23_33_43 = float4(0, 0, data.w, 0);
					unity_ObjectToWorld._14_24_34_44 = float4(data.x, data.y, data.z, 1);
					unity_WorldToObject = unity_ObjectToWorld;
					unity_WorldToObject._14_24_34 *= -1;
					unity_WorldToObject._11_22_33 = 1.0f / unity_WorldToObject._11_22_33;
				#endif
				}

			int _TexturesArrayLength;
			float _TexturesArray[20];
			uniform float _Angle;

			float _HeightMin;
			float _HeightMax;

			float _textureblend;

			float3x3 RotateAroundYInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
			
				return float3x3(
					cosa, 0, -sina,
					0,    1, 0,
					sina, 0, cosa);
			}
			float3x3 RotateAroundXInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
				return float3x3(
					1, 0,		0,
					0, cosa,	sina,
					0, -sina,	cosa);

			}
			float3x3 RotateAroundZInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
				
				return float3x3(
					cosa,	sina,	0,
					-sina,	cosa,	0,
					0,		0,		1);

			}

			void vert(inout appdata_full v) {
			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
				float4 transform = directionsBuffer[unity_InstanceID];

				float4 data = positionBuffer[unity_InstanceID];

				float4 wolrldPosition = mul(unity_ObjectToWorld, v.vertex) / 5000;

				/*float x = wolrldPosition.x;
				float z = wolrldPosition.z;*/

				v.vertex.y = 1;
				float4 pos = v.vertex;
				float r = _PlanetInfo.x;

				if (transform.x != 0) {
					v.vertex.xyz = mul(RotateAroundXInDegrees(transform.x * 90), pos.xyz);
				}
				else if (transform.y != 0) {
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.y * 90), pos.xyz);	
				}
				else if(transform.z == -1){
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.z * 180), pos.xyz);
				}


				float x = (v.vertex.x+data.x)*data.w;
				float y = (v.vertex.y+data.y)*data.w;
				float z = (v.vertex.z+data.z)*data.w;

				float dx = x * sqrt(1.0f - (y*y * 0.5f) - (z * z * 0.5f) + (y*y*z*z / 3.0f));
				float dy = y * sqrt(1.0f - (z*z * 0.5f) - (x * x * 0.5f) + (z*z*x*x / 3.0f));
				float dz = z * sqrt(1.0f - (x*x * 0.5f) - (y * y * 0.5f) + (x*x*y*y / 3.0f));

				v.vertex.xyz = float3(dx, dy, dz);

				
				//v.vertex.xyz = normalize(UnityWorldSpaceViewDir(v.vertex.xyz);


				//v.vertex.y = (tex2Dlod(_HeightTex, float4(x , z , 0, 0) - 1) * _PlanetInfo.y + _PlanetInfo.x) / data.w;
				
				#endif
				}


			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// //#pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o) {

				float h = (_PlanetInfo.y + _PlanetInfo.x - IN.worldPos.y) / (_PlanetInfo.y);

				int index = 0;

				for (int i = 0; i < _TexturesArrayLength; i++) {
					if (h >= _TexturesArray[i]) {
						index = i;
						break;
					}
				}

				fixed4 c = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures,  index));


				/***********************
					Rozmazí krajních bodů textůr
				********************/

				if (((h - _textureblend) < _TexturesArray[index]) && index > 0) {
					float 	g = (_textureblend - h + _TexturesArray[index]) / (_textureblend * 2 + 0.001);
					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index + 1)));
					c = lerp(c, d, g);
				}
				else if ((index > 0) && ((h + _textureblend) > _TexturesArray[index - 1])) {
					float g;
					if (index == 1) {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend + 0.001);
					}
					else {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend * 2 + 0.001);
					}

					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index - 1)));
					c = lerp(c, d, g);
				}


				o.Albedo = 1;// c.rgb;
				o.Alpha = 1;


			}
			

// vertex-to-fragment interpolation data
struct v2f_surf {
  V2F_SHADOW_CASTER;
  float3 worldPos : TEXCOORD1;
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  UNITY_SETUP_INSTANCE_ID(v);
  v2f_surf o;
  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
  UNITY_TRANSFER_INSTANCE_ID(v,o);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
  vert (v);
  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
  o.worldPos.xyz = worldPos;
  TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
  return o;
}

// fragment shader
fixed4 frag_surf (v2f_surf IN) : SV_Target {
  UNITY_SETUP_INSTANCE_ID(IN);
  // prepare and unpack data
  Input surfIN;
  #ifdef FOG_COMBINED_WITH_TSPACE
    UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
  #elif defined FOG_COMBINED_WITH_WORLD_POS
    UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
  #else
    UNITY_EXTRACT_FOG(IN);
  #endif
  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
  surfIN.uv_MainTex.x = 1.0;
  surfIN.uv_Textures.x = 1.0;
  surfIN.worldPos.x = 1.0;
  float3 worldPos = IN.worldPos.xyz;
  #ifndef USING_DIRECTIONAL_LIGHT
    fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
  #else
    fixed3 lightDir = _WorldSpaceLightPos0.xyz;
  #endif
  #ifdef UNITY_COMPILER_HLSL
  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
  #else
  SurfaceOutputStandard o;
  #endif
  o.Albedo = 0.0;
  o.Emission = 0.0;
  o.Alpha = 0.0;
  o.Occlusion = 1.0;
  fixed3 normalWorldVertex = fixed3(0,0,1);

  // call surface function
  surf (surfIN, o);
  SHADOW_CASTER_FRAGMENT(IN)
}


#endif

// -------- variant for: INSTANCING_ON 
#if defined(INSTANCING_ON) && !defined(PROCEDURAL_INSTANCING_ON)
// Surface shader code generated based on:
// vertex modifier: 'vert'
// writes to per-pixel normal: no
// writes to emission: no
// writes to occlusion: no
// needs world space reflection vector: no
// needs world space normal vector: no
// needs screen space position: no
// needs world space position: no
// needs view direction: no
// needs world space view direction: no
// needs world space position for lighting: YES
// needs world space view direction for lighting: YES
// needs world space view direction for lightmaps: no
// needs vertex color: no
// needs VFACE: no
// passes tangent-to-world matrix to pixel shader: no
// reads from normal: no
// 0 texcoords actually used
#include "UnityCG.cginc"
#include "UnityPBSLighting.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 21 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif
/* UNITY: Original start of shader */
			// Physically based Standard lighting model, and enable shadows on all light types
			//#pragma surface surf Standard addshadow fullforwardshadows vertex:vert
			//#pragma multi_compile_instancing
			//#pragma instancing_options procedural:setup
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			// Use shader model 3.0 target, to get nicer looking lighting
			//#pragma target 3.0

			sampler2D _HeightTex;
		/*****************************************************************
			Planet Info
			x -> planet Radius -> (chunkSize - 1) * MaxScale
			y -> Max terrain height
			********************************************************************/
			float3 _PlanetInfo;

			UNITY_DECLARE_TEX2DARRAY(_Textures);

			struct Input {
				float2 uv_MainTex;
				fixed2 uv_Textures;
				float3 worldPos;
			};

			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
			StructuredBuffer<float4> positionBuffer;
			StructuredBuffer<float4> directionsBuffer;		
			#endif

				void setup()
				{
				#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
					float4 data = positionBuffer[unity_InstanceID];
					data.xyz = 0;
					data.w = 1;
					unity_ObjectToWorld._11_21_31_41 = float4(data.w, 0, 0, 0);
					unity_ObjectToWorld._12_22_32_42 = float4(0, data.w, 0, 0);
					unity_ObjectToWorld._13_23_33_43 = float4(0, 0, data.w, 0);
					unity_ObjectToWorld._14_24_34_44 = float4(data.x, data.y, data.z, 1);
					unity_WorldToObject = unity_ObjectToWorld;
					unity_WorldToObject._14_24_34 *= -1;
					unity_WorldToObject._11_22_33 = 1.0f / unity_WorldToObject._11_22_33;
				#endif
				}

			int _TexturesArrayLength;
			float _TexturesArray[20];
			uniform float _Angle;

			float _HeightMin;
			float _HeightMax;

			float _textureblend;

			float3x3 RotateAroundYInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
			
				return float3x3(
					cosa, 0, -sina,
					0,    1, 0,
					sina, 0, cosa);
			}
			float3x3 RotateAroundXInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
				return float3x3(
					1, 0,		0,
					0, cosa,	sina,
					0, -sina,	cosa);

			}
			float3x3 RotateAroundZInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
				
				return float3x3(
					cosa,	sina,	0,
					-sina,	cosa,	0,
					0,		0,		1);

			}

			void vert(inout appdata_full v) {
			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
				float4 transform = directionsBuffer[unity_InstanceID];

				float4 data = positionBuffer[unity_InstanceID];

				float4 wolrldPosition = mul(unity_ObjectToWorld, v.vertex) / 5000;

				/*float x = wolrldPosition.x;
				float z = wolrldPosition.z;*/

				v.vertex.y = 1;
				float4 pos = v.vertex;
				float r = _PlanetInfo.x;

				if (transform.x != 0) {
					v.vertex.xyz = mul(RotateAroundXInDegrees(transform.x * 90), pos.xyz);
				}
				else if (transform.y != 0) {
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.y * 90), pos.xyz);	
				}
				else if(transform.z == -1){
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.z * 180), pos.xyz);
				}


				float x = (v.vertex.x+data.x)*data.w;
				float y = (v.vertex.y+data.y)*data.w;
				float z = (v.vertex.z+data.z)*data.w;

				float dx = x * sqrt(1.0f - (y*y * 0.5f) - (z * z * 0.5f) + (y*y*z*z / 3.0f));
				float dy = y * sqrt(1.0f - (z*z * 0.5f) - (x * x * 0.5f) + (z*z*x*x / 3.0f));
				float dz = z * sqrt(1.0f - (x*x * 0.5f) - (y * y * 0.5f) + (x*x*y*y / 3.0f));

				v.vertex.xyz = float3(dx, dy, dz);

				
				//v.vertex.xyz = normalize(UnityWorldSpaceViewDir(v.vertex.xyz);


				//v.vertex.y = (tex2Dlod(_HeightTex, float4(x , z , 0, 0) - 1) * _PlanetInfo.y + _PlanetInfo.x) / data.w;
				
				#endif
				}


			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// //#pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o) {

				float h = (_PlanetInfo.y + _PlanetInfo.x - IN.worldPos.y) / (_PlanetInfo.y);

				int index = 0;

				for (int i = 0; i < _TexturesArrayLength; i++) {
					if (h >= _TexturesArray[i]) {
						index = i;
						break;
					}
				}

				fixed4 c = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures,  index));


				/***********************
					Rozmazí krajních bodů textůr
				********************/

				if (((h - _textureblend) < _TexturesArray[index]) && index > 0) {
					float 	g = (_textureblend - h + _TexturesArray[index]) / (_textureblend * 2 + 0.001);
					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index + 1)));
					c = lerp(c, d, g);
				}
				else if ((index > 0) && ((h + _textureblend) > _TexturesArray[index - 1])) {
					float g;
					if (index == 1) {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend + 0.001);
					}
					else {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend * 2 + 0.001);
					}

					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index - 1)));
					c = lerp(c, d, g);
				}


				o.Albedo = 1;// c.rgb;
				o.Alpha = 1;


			}
			

// vertex-to-fragment interpolation data
struct v2f_surf {
  V2F_SHADOW_CASTER;
  float3 worldPos : TEXCOORD1;
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  UNITY_SETUP_INSTANCE_ID(v);
  v2f_surf o;
  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
  UNITY_TRANSFER_INSTANCE_ID(v,o);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
  vert (v);
  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
  o.worldPos.xyz = worldPos;
  TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
  return o;
}

// fragment shader
fixed4 frag_surf (v2f_surf IN) : SV_Target {
  UNITY_SETUP_INSTANCE_ID(IN);
  // prepare and unpack data
  Input surfIN;
  #ifdef FOG_COMBINED_WITH_TSPACE
    UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
  #elif defined FOG_COMBINED_WITH_WORLD_POS
    UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
  #else
    UNITY_EXTRACT_FOG(IN);
  #endif
  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
  surfIN.uv_MainTex.x = 1.0;
  surfIN.uv_Textures.x = 1.0;
  surfIN.worldPos.x = 1.0;
  float3 worldPos = IN.worldPos.xyz;
  #ifndef USING_DIRECTIONAL_LIGHT
    fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
  #else
    fixed3 lightDir = _WorldSpaceLightPos0.xyz;
  #endif
  #ifdef UNITY_COMPILER_HLSL
  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
  #else
  SurfaceOutputStandard o;
  #endif
  o.Albedo = 0.0;
  o.Emission = 0.0;
  o.Alpha = 0.0;
  o.Occlusion = 1.0;
  fixed3 normalWorldVertex = fixed3(0,0,1);

  // call surface function
  surf (surfIN, o);
  SHADOW_CASTER_FRAGMENT(IN)
}


#endif

// -------- variant for: PROCEDURAL_INSTANCING_ON 
#if defined(PROCEDURAL_INSTANCING_ON) && !defined(INSTANCING_ON)
// Surface shader code generated based on:
// vertex modifier: 'vert'
// writes to per-pixel normal: no
// writes to emission: no
// writes to occlusion: no
// needs world space reflection vector: no
// needs world space normal vector: no
// needs screen space position: no
// needs world space position: no
// needs view direction: no
// needs world space view direction: no
// needs world space position for lighting: YES
// needs world space view direction for lighting: YES
// needs world space view direction for lightmaps: no
// needs vertex color: no
// needs VFACE: no
// passes tangent-to-world matrix to pixel shader: no
// reads from normal: no
// 0 texcoords actually used
#include "UnityCG.cginc"
#include "UnityPBSLighting.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 21 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif
/* UNITY: Original start of shader */
			// Physically based Standard lighting model, and enable shadows on all light types
			//#pragma surface surf Standard addshadow fullforwardshadows vertex:vert
			//#pragma multi_compile_instancing
			//#pragma instancing_options procedural:setup
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			// Use shader model 3.0 target, to get nicer looking lighting
			//#pragma target 3.0

			sampler2D _HeightTex;
		/*****************************************************************
			Planet Info
			x -> planet Radius -> (chunkSize - 1) * MaxScale
			y -> Max terrain height
			********************************************************************/
			float3 _PlanetInfo;

			UNITY_DECLARE_TEX2DARRAY(_Textures);

			struct Input {
				float2 uv_MainTex;
				fixed2 uv_Textures;
				float3 worldPos;
			};

			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
			StructuredBuffer<float4> positionBuffer;
			StructuredBuffer<float4> directionsBuffer;		
			#endif

				void setup()
				{
				#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
					float4 data = positionBuffer[unity_InstanceID];
					data.xyz = 0;
					data.w = 1;
					unity_ObjectToWorld._11_21_31_41 = float4(data.w, 0, 0, 0);
					unity_ObjectToWorld._12_22_32_42 = float4(0, data.w, 0, 0);
					unity_ObjectToWorld._13_23_33_43 = float4(0, 0, data.w, 0);
					unity_ObjectToWorld._14_24_34_44 = float4(data.x, data.y, data.z, 1);
					unity_WorldToObject = unity_ObjectToWorld;
					unity_WorldToObject._14_24_34 *= -1;
					unity_WorldToObject._11_22_33 = 1.0f / unity_WorldToObject._11_22_33;
				#endif
				}

			int _TexturesArrayLength;
			float _TexturesArray[20];
			uniform float _Angle;

			float _HeightMin;
			float _HeightMax;

			float _textureblend;

			float3x3 RotateAroundYInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
			
				return float3x3(
					cosa, 0, -sina,
					0,    1, 0,
					sina, 0, cosa);
			}
			float3x3 RotateAroundXInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
				return float3x3(
					1, 0,		0,
					0, cosa,	sina,
					0, -sina,	cosa);

			}
			float3x3 RotateAroundZInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
				
				return float3x3(
					cosa,	sina,	0,
					-sina,	cosa,	0,
					0,		0,		1);

			}

			void vert(inout appdata_full v) {
			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
				float4 transform = directionsBuffer[unity_InstanceID];

				float4 data = positionBuffer[unity_InstanceID];

				float4 wolrldPosition = mul(unity_ObjectToWorld, v.vertex) / 5000;

				/*float x = wolrldPosition.x;
				float z = wolrldPosition.z;*/

				v.vertex.y = 1;
				float4 pos = v.vertex;
				float r = _PlanetInfo.x;

				if (transform.x != 0) {
					v.vertex.xyz = mul(RotateAroundXInDegrees(transform.x * 90), pos.xyz);
				}
				else if (transform.y != 0) {
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.y * 90), pos.xyz);	
				}
				else if(transform.z == -1){
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.z * 180), pos.xyz);
				}


				float x = (v.vertex.x+data.x)*data.w;
				float y = (v.vertex.y+data.y)*data.w;
				float z = (v.vertex.z+data.z)*data.w;

				float dx = x * sqrt(1.0f - (y*y * 0.5f) - (z * z * 0.5f) + (y*y*z*z / 3.0f));
				float dy = y * sqrt(1.0f - (z*z * 0.5f) - (x * x * 0.5f) + (z*z*x*x / 3.0f));
				float dz = z * sqrt(1.0f - (x*x * 0.5f) - (y * y * 0.5f) + (x*x*y*y / 3.0f));

				v.vertex.xyz = float3(dx, dy, dz);

				
				//v.vertex.xyz = normalize(UnityWorldSpaceViewDir(v.vertex.xyz);


				//v.vertex.y = (tex2Dlod(_HeightTex, float4(x , z , 0, 0) - 1) * _PlanetInfo.y + _PlanetInfo.x) / data.w;
				
				#endif
				}


			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// //#pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o) {

				float h = (_PlanetInfo.y + _PlanetInfo.x - IN.worldPos.y) / (_PlanetInfo.y);

				int index = 0;

				for (int i = 0; i < _TexturesArrayLength; i++) {
					if (h >= _TexturesArray[i]) {
						index = i;
						break;
					}
				}

				fixed4 c = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures,  index));


				/***********************
					Rozmazí krajních bodů textůr
				********************/

				if (((h - _textureblend) < _TexturesArray[index]) && index > 0) {
					float 	g = (_textureblend - h + _TexturesArray[index]) / (_textureblend * 2 + 0.001);
					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index + 1)));
					c = lerp(c, d, g);
				}
				else if ((index > 0) && ((h + _textureblend) > _TexturesArray[index - 1])) {
					float g;
					if (index == 1) {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend + 0.001);
					}
					else {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend * 2 + 0.001);
					}

					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index - 1)));
					c = lerp(c, d, g);
				}


				o.Albedo = 1;// c.rgb;
				o.Alpha = 1;


			}
			

// vertex-to-fragment interpolation data
struct v2f_surf {
  V2F_SHADOW_CASTER;
  float3 worldPos : TEXCOORD1;
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  UNITY_SETUP_INSTANCE_ID(v);
  v2f_surf o;
  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
  UNITY_TRANSFER_INSTANCE_ID(v,o);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
  vert (v);
  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
  o.worldPos.xyz = worldPos;
  TRANSFER_SHADOW_CASTER_NORMALOFFSET(o)
  return o;
}

// fragment shader
fixed4 frag_surf (v2f_surf IN) : SV_Target {
  UNITY_SETUP_INSTANCE_ID(IN);
  // prepare and unpack data
  Input surfIN;
  #ifdef FOG_COMBINED_WITH_TSPACE
    UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
  #elif defined FOG_COMBINED_WITH_WORLD_POS
    UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
  #else
    UNITY_EXTRACT_FOG(IN);
  #endif
  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
  surfIN.uv_MainTex.x = 1.0;
  surfIN.uv_Textures.x = 1.0;
  surfIN.worldPos.x = 1.0;
  float3 worldPos = IN.worldPos.xyz;
  #ifndef USING_DIRECTIONAL_LIGHT
    fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
  #else
    fixed3 lightDir = _WorldSpaceLightPos0.xyz;
  #endif
  #ifdef UNITY_COMPILER_HLSL
  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
  #else
  SurfaceOutputStandard o;
  #endif
  o.Albedo = 0.0;
  o.Emission = 0.0;
  o.Alpha = 0.0;
  o.Occlusion = 1.0;
  fixed3 normalWorldVertex = fixed3(0,0,1);

  // call surface function
  surf (surfIN, o);
  SHADOW_CASTER_FRAGMENT(IN)
}


#endif


ENDCG

}

	// ---- meta information extraction pass:
	Pass {
		Name "Meta"
		Tags { "LightMode" = "Meta" }
		Cull Off

CGPROGRAM
// compile directives
#pragma vertex vert_surf
#pragma fragment frag_surf
#pragma multi_compile_instancing
#pragma instancing_options procedural:setup
#pragma target 3.0
#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
#pragma skip_variants INSTANCING_ON
#pragma shader_feature EDITOR_VISUALIZATION

#include "HLSLSupport.cginc"
#define UNITY_INSTANCED_LOD_FADE
#define UNITY_INSTANCED_SH
#define UNITY_INSTANCED_LIGHTMAPSTS
#define UNITY_INSTANCING_PROCEDURAL_FUNC setup
#include "UnityShaderVariables.cginc"
#include "UnityShaderUtilities.cginc"
// -------- variant for: <when no other keywords are defined>
#if !defined(INSTANCING_ON) && !defined(PROCEDURAL_INSTANCING_ON)
// Surface shader code generated based on:
// vertex modifier: 'vert'
// writes to per-pixel normal: no
// writes to emission: no
// writes to occlusion: no
// needs world space reflection vector: no
// needs world space normal vector: no
// needs screen space position: no
// needs world space position: no
// needs view direction: no
// needs world space view direction: no
// needs world space position for lighting: YES
// needs world space view direction for lighting: YES
// needs world space view direction for lightmaps: no
// needs vertex color: no
// needs VFACE: no
// passes tangent-to-world matrix to pixel shader: no
// reads from normal: no
// 0 texcoords actually used
#include "UnityCG.cginc"
#include "UnityPBSLighting.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 21 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif
/* UNITY: Original start of shader */
			// Physically based Standard lighting model, and enable shadows on all light types
			//#pragma surface surf Standard addshadow fullforwardshadows vertex:vert
			//#pragma multi_compile_instancing
			//#pragma instancing_options procedural:setup
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			// Use shader model 3.0 target, to get nicer looking lighting
			//#pragma target 3.0

			sampler2D _HeightTex;
		/*****************************************************************
			Planet Info
			x -> planet Radius -> (chunkSize - 1) * MaxScale
			y -> Max terrain height
			********************************************************************/
			float3 _PlanetInfo;

			UNITY_DECLARE_TEX2DARRAY(_Textures);

			struct Input {
				float2 uv_MainTex;
				fixed2 uv_Textures;
				float3 worldPos;
			};

			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
			StructuredBuffer<float4> positionBuffer;
			StructuredBuffer<float4> directionsBuffer;		
			#endif

				void setup()
				{
				#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
					float4 data = positionBuffer[unity_InstanceID];
					data.xyz = 0;
					data.w = 1;
					unity_ObjectToWorld._11_21_31_41 = float4(data.w, 0, 0, 0);
					unity_ObjectToWorld._12_22_32_42 = float4(0, data.w, 0, 0);
					unity_ObjectToWorld._13_23_33_43 = float4(0, 0, data.w, 0);
					unity_ObjectToWorld._14_24_34_44 = float4(data.x, data.y, data.z, 1);
					unity_WorldToObject = unity_ObjectToWorld;
					unity_WorldToObject._14_24_34 *= -1;
					unity_WorldToObject._11_22_33 = 1.0f / unity_WorldToObject._11_22_33;
				#endif
				}

			int _TexturesArrayLength;
			float _TexturesArray[20];
			uniform float _Angle;

			float _HeightMin;
			float _HeightMax;

			float _textureblend;

			float3x3 RotateAroundYInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
			
				return float3x3(
					cosa, 0, -sina,
					0,    1, 0,
					sina, 0, cosa);
			}
			float3x3 RotateAroundXInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
				return float3x3(
					1, 0,		0,
					0, cosa,	sina,
					0, -sina,	cosa);

			}
			float3x3 RotateAroundZInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
				
				return float3x3(
					cosa,	sina,	0,
					-sina,	cosa,	0,
					0,		0,		1);

			}

			void vert(inout appdata_full v) {
			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
				float4 transform = directionsBuffer[unity_InstanceID];

				float4 data = positionBuffer[unity_InstanceID];

				float4 wolrldPosition = mul(unity_ObjectToWorld, v.vertex) / 5000;

				/*float x = wolrldPosition.x;
				float z = wolrldPosition.z;*/

				v.vertex.y = 1;
				float4 pos = v.vertex;
				float r = _PlanetInfo.x;

				if (transform.x != 0) {
					v.vertex.xyz = mul(RotateAroundXInDegrees(transform.x * 90), pos.xyz);
				}
				else if (transform.y != 0) {
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.y * 90), pos.xyz);	
				}
				else if(transform.z == -1){
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.z * 180), pos.xyz);
				}


				float x = (v.vertex.x+data.x)*data.w;
				float y = (v.vertex.y+data.y)*data.w;
				float z = (v.vertex.z+data.z)*data.w;

				float dx = x * sqrt(1.0f - (y*y * 0.5f) - (z * z * 0.5f) + (y*y*z*z / 3.0f));
				float dy = y * sqrt(1.0f - (z*z * 0.5f) - (x * x * 0.5f) + (z*z*x*x / 3.0f));
				float dz = z * sqrt(1.0f - (x*x * 0.5f) - (y * y * 0.5f) + (x*x*y*y / 3.0f));

				v.vertex.xyz = float3(dx, dy, dz);

				
				//v.vertex.xyz = normalize(UnityWorldSpaceViewDir(v.vertex.xyz);


				//v.vertex.y = (tex2Dlod(_HeightTex, float4(x , z , 0, 0) - 1) * _PlanetInfo.y + _PlanetInfo.x) / data.w;
				
				#endif
				}


			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// //#pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o) {

				float h = (_PlanetInfo.y + _PlanetInfo.x - IN.worldPos.y) / (_PlanetInfo.y);

				int index = 0;

				for (int i = 0; i < _TexturesArrayLength; i++) {
					if (h >= _TexturesArray[i]) {
						index = i;
						break;
					}
				}

				fixed4 c = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures,  index));


				/***********************
					Rozmazí krajních bodů textůr
				********************/

				if (((h - _textureblend) < _TexturesArray[index]) && index > 0) {
					float 	g = (_textureblend - h + _TexturesArray[index]) / (_textureblend * 2 + 0.001);
					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index + 1)));
					c = lerp(c, d, g);
				}
				else if ((index > 0) && ((h + _textureblend) > _TexturesArray[index - 1])) {
					float g;
					if (index == 1) {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend + 0.001);
					}
					else {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend * 2 + 0.001);
					}

					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index - 1)));
					c = lerp(c, d, g);
				}


				o.Albedo = 1;// c.rgb;
				o.Alpha = 1;


			}
			
#include "UnityMetaPass.cginc"

// vertex-to-fragment interpolation data
struct v2f_surf {
  UNITY_POSITION(pos);
  float3 worldPos : TEXCOORD0;
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  UNITY_SETUP_INSTANCE_ID(v);
  v2f_surf o;
  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
  UNITY_TRANSFER_INSTANCE_ID(v,o);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
  vert (v);
  o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST);
  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
  o.worldPos.xyz = worldPos;
  return o;
}

// fragment shader
fixed4 frag_surf (v2f_surf IN) : SV_Target {
  UNITY_SETUP_INSTANCE_ID(IN);
  // prepare and unpack data
  Input surfIN;
  #ifdef FOG_COMBINED_WITH_TSPACE
    UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
  #elif defined FOG_COMBINED_WITH_WORLD_POS
    UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
  #else
    UNITY_EXTRACT_FOG(IN);
  #endif
  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
  surfIN.uv_MainTex.x = 1.0;
  surfIN.uv_Textures.x = 1.0;
  surfIN.worldPos.x = 1.0;
  float3 worldPos = IN.worldPos.xyz;
  #ifndef USING_DIRECTIONAL_LIGHT
    fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
  #else
    fixed3 lightDir = _WorldSpaceLightPos0.xyz;
  #endif
  #ifdef UNITY_COMPILER_HLSL
  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
  #else
  SurfaceOutputStandard o;
  #endif
  o.Albedo = 0.0;
  o.Emission = 0.0;
  o.Alpha = 0.0;
  o.Occlusion = 1.0;
  fixed3 normalWorldVertex = fixed3(0,0,1);

  // call surface function
  surf (surfIN, o);
  UnityMetaInput metaIN;
  UNITY_INITIALIZE_OUTPUT(UnityMetaInput, metaIN);
  metaIN.Albedo = o.Albedo;
  metaIN.Emission = o.Emission;
  return UnityMetaFragment(metaIN);
}


#endif

// -------- variant for: PROCEDURAL_INSTANCING_ON 
#if defined(PROCEDURAL_INSTANCING_ON) && !defined(INSTANCING_ON)
// Surface shader code generated based on:
// vertex modifier: 'vert'
// writes to per-pixel normal: no
// writes to emission: no
// writes to occlusion: no
// needs world space reflection vector: no
// needs world space normal vector: no
// needs screen space position: no
// needs world space position: no
// needs view direction: no
// needs world space view direction: no
// needs world space position for lighting: YES
// needs world space view direction for lighting: YES
// needs world space view direction for lightmaps: no
// needs vertex color: no
// needs VFACE: no
// passes tangent-to-world matrix to pixel shader: no
// reads from normal: no
// 0 texcoords actually used
#include "UnityCG.cginc"
#include "UnityPBSLighting.cginc"

#define INTERNAL_DATA
#define WorldReflectionVector(data,normal) data.worldRefl
#define WorldNormalVector(data,normal) normal

// Original surface shader snippet:
#line 21 ""
#ifdef DUMMY_PREPROCESSOR_TO_WORK_AROUND_HLSL_COMPILER_LINE_HANDLING
#endif
/* UNITY: Original start of shader */
			// Physically based Standard lighting model, and enable shadows on all light types
			//#pragma surface surf Standard addshadow fullforwardshadows vertex:vert
			//#pragma multi_compile_instancing
			//#pragma instancing_options procedural:setup
			#include "UnityCG.cginc"
			#include "Lighting.cginc"

			// Use shader model 3.0 target, to get nicer looking lighting
			//#pragma target 3.0

			sampler2D _HeightTex;
		/*****************************************************************
			Planet Info
			x -> planet Radius -> (chunkSize - 1) * MaxScale
			y -> Max terrain height
			********************************************************************/
			float3 _PlanetInfo;

			UNITY_DECLARE_TEX2DARRAY(_Textures);

			struct Input {
				float2 uv_MainTex;
				fixed2 uv_Textures;
				float3 worldPos;
			};

			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
			StructuredBuffer<float4> positionBuffer;
			StructuredBuffer<float4> directionsBuffer;		
			#endif

				void setup()
				{
				#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
					float4 data = positionBuffer[unity_InstanceID];
					data.xyz = 0;
					data.w = 1;
					unity_ObjectToWorld._11_21_31_41 = float4(data.w, 0, 0, 0);
					unity_ObjectToWorld._12_22_32_42 = float4(0, data.w, 0, 0);
					unity_ObjectToWorld._13_23_33_43 = float4(0, 0, data.w, 0);
					unity_ObjectToWorld._14_24_34_44 = float4(data.x, data.y, data.z, 1);
					unity_WorldToObject = unity_ObjectToWorld;
					unity_WorldToObject._14_24_34 *= -1;
					unity_WorldToObject._11_22_33 = 1.0f / unity_WorldToObject._11_22_33;
				#endif
				}

			int _TexturesArrayLength;
			float _TexturesArray[20];
			uniform float _Angle;

			float _HeightMin;
			float _HeightMax;

			float _textureblend;

			float3x3 RotateAroundYInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
			
				return float3x3(
					cosa, 0, -sina,
					0,    1, 0,
					sina, 0, cosa);
			}
			float3x3 RotateAroundXInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
			
				return float3x3(
					1, 0,		0,
					0, cosa,	sina,
					0, -sina,	cosa);

			}
			float3x3 RotateAroundZInDegrees(float degrees)
			{
				float alpha = degrees * UNITY_PI / 180.0;
				float sina, cosa;
				sincos(alpha, sina, cosa);
				
				return float3x3(
					cosa,	sina,	0,
					-sina,	cosa,	0,
					0,		0,		1);

			}

			void vert(inout appdata_full v) {
			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
				float4 transform = directionsBuffer[unity_InstanceID];

				float4 data = positionBuffer[unity_InstanceID];

				float4 wolrldPosition = mul(unity_ObjectToWorld, v.vertex) / 5000;

				/*float x = wolrldPosition.x;
				float z = wolrldPosition.z;*/

				v.vertex.y = 1;
				float4 pos = v.vertex;
				float r = _PlanetInfo.x;

				if (transform.x != 0) {
					v.vertex.xyz = mul(RotateAroundXInDegrees(transform.x * 90), pos.xyz);
				}
				else if (transform.y != 0) {
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.y * 90), pos.xyz);	
				}
				else if(transform.z == -1){
					v.vertex.xyz = mul(RotateAroundZInDegrees(transform.z * 180), pos.xyz);
				}


				float x = (v.vertex.x+data.x)*data.w;
				float y = (v.vertex.y+data.y)*data.w;
				float z = (v.vertex.z+data.z)*data.w;

				float dx = x * sqrt(1.0f - (y*y * 0.5f) - (z * z * 0.5f) + (y*y*z*z / 3.0f));
				float dy = y * sqrt(1.0f - (z*z * 0.5f) - (x * x * 0.5f) + (z*z*x*x / 3.0f));
				float dz = z * sqrt(1.0f - (x*x * 0.5f) - (y * y * 0.5f) + (x*x*y*y / 3.0f));

				v.vertex.xyz = float3(dx, dy, dz);

				
				//v.vertex.xyz = normalize(UnityWorldSpaceViewDir(v.vertex.xyz);


				//v.vertex.y = (tex2Dlod(_HeightTex, float4(x , z , 0, 0) - 1) * _PlanetInfo.y + _PlanetInfo.x) / data.w;
				
				#endif
				}


			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// //#pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o) {

				float h = (_PlanetInfo.y + _PlanetInfo.x - IN.worldPos.y) / (_PlanetInfo.y);

				int index = 0;

				for (int i = 0; i < _TexturesArrayLength; i++) {
					if (h >= _TexturesArray[i]) {
						index = i;
						break;
					}
				}

				fixed4 c = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures,  index));


				/***********************
					Rozmazí krajních bodů textůr
				********************/

				if (((h - _textureblend) < _TexturesArray[index]) && index > 0) {
					float 	g = (_textureblend - h + _TexturesArray[index]) / (_textureblend * 2 + 0.001);
					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index + 1)));
					c = lerp(c, d, g);
				}
				else if ((index > 0) && ((h + _textureblend) > _TexturesArray[index - 1])) {
					float g;
					if (index == 1) {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend + 0.001);
					}
					else {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend * 2 + 0.001);
					}

					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index - 1)));
					c = lerp(c, d, g);
				}


				o.Albedo = 1;// c.rgb;
				o.Alpha = 1;


			}
			
#include "UnityMetaPass.cginc"

// vertex-to-fragment interpolation data
struct v2f_surf {
  UNITY_POSITION(pos);
  float3 worldPos : TEXCOORD0;
  UNITY_VERTEX_INPUT_INSTANCE_ID
  UNITY_VERTEX_OUTPUT_STEREO
};

// vertex shader
v2f_surf vert_surf (appdata_full v) {
  UNITY_SETUP_INSTANCE_ID(v);
  v2f_surf o;
  UNITY_INITIALIZE_OUTPUT(v2f_surf,o);
  UNITY_TRANSFER_INSTANCE_ID(v,o);
  UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(o);
  vert (v);
  o.pos = UnityMetaVertexPosition(v.vertex, v.texcoord1.xy, v.texcoord2.xy, unity_LightmapST, unity_DynamicLightmapST);
  float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
  float3 worldNormal = UnityObjectToWorldNormal(v.normal);
  o.worldPos.xyz = worldPos;
  return o;
}

// fragment shader
fixed4 frag_surf (v2f_surf IN) : SV_Target {
  UNITY_SETUP_INSTANCE_ID(IN);
  // prepare and unpack data
  Input surfIN;
  #ifdef FOG_COMBINED_WITH_TSPACE
    UNITY_EXTRACT_FOG_FROM_TSPACE(IN);
  #elif defined FOG_COMBINED_WITH_WORLD_POS
    UNITY_EXTRACT_FOG_FROM_WORLD_POS(IN);
  #else
    UNITY_EXTRACT_FOG(IN);
  #endif
  UNITY_INITIALIZE_OUTPUT(Input,surfIN);
  surfIN.uv_MainTex.x = 1.0;
  surfIN.uv_Textures.x = 1.0;
  surfIN.worldPos.x = 1.0;
  float3 worldPos = IN.worldPos.xyz;
  #ifndef USING_DIRECTIONAL_LIGHT
    fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
  #else
    fixed3 lightDir = _WorldSpaceLightPos0.xyz;
  #endif
  #ifdef UNITY_COMPILER_HLSL
  SurfaceOutputStandard o = (SurfaceOutputStandard)0;
  #else
  SurfaceOutputStandard o;
  #endif
  o.Albedo = 0.0;
  o.Emission = 0.0;
  o.Alpha = 0.0;
  o.Occlusion = 1.0;
  fixed3 normalWorldVertex = fixed3(0,0,1);

  // call surface function
  surf (surfIN, o);
  UnityMetaInput metaIN;
  UNITY_INITIALIZE_OUTPUT(UnityMetaInput, metaIN);
  metaIN.Albedo = o.Albedo;
  metaIN.Emission = o.Emission;
  return UnityMetaFragment(metaIN);
}


#endif


ENDCG

}

	// ---- end of surface shader generated code

#LINE 214

		}
			FallBack "Diffuse"
}