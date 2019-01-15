Shader "Unlit/NewUnlitShader"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;


				v.vertex.z -= 0.5f;
				float x = v.vertex.x*2;
				float y = v.vertex.y*2;
				float z = v.vertex.z*2;

				float dx = x * sqrt(1.0f - (y*y * 0.5f) - (z * z * 0.5f) + (y*y*z*z / 3.0f));
				float dy = y * sqrt(1.0f - (z*z * 0.5f) - (x * x * 0.5f) + (z*z*x*x / 3.0f));
				float dz = z * sqrt(1.0f - (x*x * 0.5f) - (y * y * 0.5f) + (x*x*y*y / 3.0f));

				v.vertex.xyz = float3(dx, dy, dz);
				//v.vertex.xz = float2(dx,dy);


				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 col = tex2D(_MainTex, i.uv);
				// apply fog
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
