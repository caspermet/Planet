// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Custom/Terrain" {
	Properties{
		_Color("Color", Color) = (1,1,1,1)
		_MainTex("Albedo (RGB)", 2D) = "white" {}
		_Glossiness("Smoothness", Range(0,1)) = 0.5
		_Metallic("Metallic", Range(0,1)) = 0.0
		_Scale("Scale", float) = 1.0
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

			struct Input {
				float2 uv_MainTex;
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

					float rotation = data.w * data.w * _Time.y * 0.5f;
					rotate2D(data.xz, rotation);

					unity_ObjectToWorld._11_21_31_41 = float4(data.w, 0, 0, 0);
					unity_ObjectToWorld._12_22_32_42 = float4(0, data.w, 0, 0);
					unity_ObjectToWorld._13_23_33_43 = float4(0, 0, data.w, 0);
					unity_ObjectToWorld._14_24_34_44 = float4(data.xyz, 1);
					unity_WorldToObject = unity_ObjectToWorld;
					unity_WorldToObject._14_24_34 *= -1;
					unity_WorldToObject._11_22_33 = 1.0f / unity_WorldToObject._11_22_33;
#endif
				}

			half _Glossiness;
			half _Metallic;
			fixed4 _Color;
			float _Scale;

			void vert(inout appdata_full v) {

				float4 wolrldPosition = mul(unity_ObjectToWorld, v.vertex);
				v.vertex.y = tex2Dlod(_MainTex, float4(wolrldPosition.xz / 100, 0, 0)) * 3 / _Scale;
			}

			// Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
			// See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
			// #pragma instancing_options assumeuniformscaling
			UNITY_INSTANCING_BUFFER_START(Props)
				// put more per-instance properties here
			UNITY_INSTANCING_BUFFER_END(Props)

			void surf(Input IN, inout SurfaceOutputStandard o) {
				// Albedo comes from a texture tinted by color

				float4 wolrldPosition = mul(unity_ObjectToWorld, float4(IN.worldPos, 0));
				fixed4 c = tex2D(_MainTex, wolrldPosition.xz / 1000);
				o.Albedo = c.rgb;

				// Metallic and smoothness come from slider variables
				o.Metallic = _Metallic;
				o.Smoothness = _Glossiness;
				o.Alpha = c.a;
			}
			ENDCG
		}
			FallBack "Diffuse"
}
