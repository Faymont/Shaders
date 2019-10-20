Shader "CookBookShaders/BasicDiffuse"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _AmbientColor("Ambient Color", Color) = (1,1,1,1)
        _EmissiveColor ("Emmisiv eColor ", Color) = (1,1,1,1)
        _RampTex ("Ramp Texture", 2D) = "white" {}
        _BRDFTex ("BRDF Texture", 2D) = "white" {}
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
		_Range("Range", Range(0,20)) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf BasicDiffuse

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;
        sampler2D _RampTex;
        sampler2D _BRDFTex;
		float4 _AmbientColor;
		float4 _EmissiveColor;
		float _Range;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;

		inline float4 LightingBasicDiffuse(SurfaceOutput s, fixed3 lightDir, fixed3 viewDir, fixed atten)
		{
			float diffLight = dot(s.Normal, lightDir);
			float rimLight = dot(s.Normal, viewDir);
		    float HalfLambert = diffLight * 0.5 + 0.5;
			float3 ramp = tex2D(_RampTex, float2(HalfLambert,rimLight)).rgb;
            //float3 brdf = tex2D(_BRDFTex, float2(1-viewDif,viewDif)).rgb;
			
			
			
			float4 col;
			//col.rgb= s.Albedo * _LightColor0.rgb * (diffLight * atten * 2); 
			//col.rgb= s.Albedo * _LightColor0.rgb * (HalfLambert * atten * 2);
			//col.rgb= s.Albedo * _LightColor0.rgb * ramp;
			col.rgb= s.Albedo * _LightColor0.rgb * ramp;
			col.a = s.Alpha;
			return col;
		}


        void surf (Input IN, inout SurfaceOutput o)
        {
            // Albedo comes from a texture tinted by color
            //fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color + pow((_AmbientColor + _EmissiveColor), _Range);
            fixed4 c = tex2D(_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = c.rgb;
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
