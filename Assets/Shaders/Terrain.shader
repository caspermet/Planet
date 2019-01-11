// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Instanced/Terrain" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Texture", 2D) = "white" {}
		_HeightTex("Texture", 2D) = "white" {}
		_ColorWater("water Texture", 2D) = "white" {}
		_Textures("Textures", 2DArray) = "" {}

		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_Scale("Scale", float) = 1.0
		_HeightMin("Height Min", Float) = -1
		_HeightMax("Height Max", Float) = 1
		_ColorMin("Tint Color At Min", Color) = (0,0,0,1)
		_ColorMax("Tint Color At Max", Color) = (1,1,1,1)
			
	}
		SubShader{
			Tags { "RenderType" = "Opaque" }
			LOD 200

			CGPROGRAM
			// Physically based Standard lighting model, and enable shadows on all light types
			#pragma surface surf Standard addshadow fullforwardshadows vertex:vert
			#pragma multi_compile_instancing
			#pragma instancing_options procedural:setup

			// Use shader model 3.0 target, to get nicer looking lighting
			#pragma target 3.0

			sampler2D _MainTex;
			sampler2D _HeightTex;
			sampler2D _ColorWater;

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

			half _Glossiness;
			half _Metallic;
			fixed4 _Color;
			float _Scale;

			fixed4 _ColorMin;
			fixed4 _ColorMax;

			float _HeightMin;
			float _HeightMax;
			

			void vert(inout appdata_full v) {
			#ifdef UNITY_PROCEDURAL_INSTANCING_ENABLED

				float4 data = positionBuffer[unity_InstanceID];

				float4 wolrldPosition = mul(unity_ObjectToWorld, v.vertex) / 50000;

				float x = wolrldPosition.x;
				float z = wolrldPosition.z;
		
				v.vertex.y = (tex2Dlod(_HeightTex, float4(x , z , 0, 0)) * 800 / data.w); // -some;
			#endif
			}

			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// #pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o) {

			//	fixed4 c = tex2D(_MainTex, IN.worldPos.xz/100);

				//fixed4 c = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, 0));

				
				//float h = (_HeightMax - IN.worldPos.y) / (_HeightMax - _HeightMin);
				float h = (_HeightMax - IN.worldPos.y) / (_HeightMax - _HeightMin);

			
				
				int index = 0;

				if (h == 1) {
					index = 0;
				}
				else if (h > 0.9) {
					index = 1;
				}
				else if (h > 0.6) {
					index = 2;
				}
				else if (h > 0.3) {
					index = 3;
				}
				else {
					index = 4;
				}
				fixed4 c = UNITY_SAMPLE_TEX2DARRAY(_Textures, float3(IN.uv_Textures, UNITY_ACCESS_INSTANCED_PROP(index_arr, index)));
				o.Albedo = c.rgb;
				o.Alpha = 1;
			

			}
			ENDCG
		}
			FallBack "Diffuse"
}
