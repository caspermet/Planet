// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Instanced/Terrain" {
	Properties{
		_HeightTex("Texture", 2D) = "white" {}

		_Textures("Textures", 2DArray) = "" {}

		_textureblend("bluer Texture", Range(0,0.1)) = 1
			
	}
		SubShader{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
// Upgrade NOTE: excluded shader from DX11, OpenGL ES 2.0 because it uses unsized arrays
#pragma exclude_renderers d3d11 gles
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Standard addshadow fullforwardshadows vertex:vert
			#pragma multi_compile_instancing
			#pragma instancing_options procedural:setup

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

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
			#endif

				void rotate2D(inout float2 v, float r)
				{
					float s, c;
					sincos(r, s, c);
					v = float2(v.x * c - v.y * s, v.x * s + v.y * c);
				}

				void setup()
				{
				#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED
					float4 data = positionBuffer[unity_InstanceID];

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

			float _textureblend;

			void vert(inout appdata_full v) {
			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED

				float4 data = positionBuffer[unity_InstanceID];

				float4 wolrldPosition = mul(unity_ObjectToWorld, v.vertex) / 5000;

				float x = wolrldPosition.x;
				float z = wolrldPosition.z;
		
				v.vertex.y = (tex2Dlod(_HeightTex, float4(x, z, 0, 0) - 1) * _PlanetInfo.y + _PlanetInfo.x) / data.w;
			#endif
			}

			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// #pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o) {

				float h = (_PlanetInfo.y + _PlanetInfo.x - IN.worldPos.y) / (_PlanetInfo.y );

				int index = 0;
			
				for (int i = 0; i < _TexturesArrayLength; i++) {
					if (h >= _TexturesArray[i]) {
						index = i;
						break;
					}
				}

				
			

				fixed4 c = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index)));


				/***********************				
					Rozmazí krajních bodů textůr
				********************/

				if (((h - _textureblend) < _TexturesArray[index]) && index > 0){
					float 	g = (_textureblend - h + _TexturesArray[index]) / (_textureblend * 2 + 0.001);
					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index + 1)));
					c = lerp(c, d, g);
				}
				else if ((index > 0) && ((h + _textureblend) > _TexturesArray[index - 1])) {
					float g;
					if (index == 1) {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend  + 0.001);
					}
					else {
						g = (_textureblend + h - _TexturesArray[index - 1]) / (_textureblend * 2 + 0.001);
					}
				
					fixed4 d = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index - 1))); 
					c = lerp(c, d, g);
				}


				o.Albedo = c.rgb;
				o.Alpha = 1;
			

			}
			ENDCG
		}
			FallBack "Diffuse"
}
