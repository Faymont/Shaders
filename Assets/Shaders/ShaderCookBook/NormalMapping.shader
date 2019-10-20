Shader "Custom/NormalMapping"
{
    Properties
    {
        _MainTint ("Color", Color) = (1,1,1,1)
        _NormalTex ("Normal map", 2D) = "bump" {}
        _NormalIntensity ("Normal Map intensity", Range(0,10)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        struct Input
        {
            float2 uv_NormalTex;
        };
        
        float4 _MainTint;
        float _NormalIntensity;
        sampler2D _NormalTex;
        
        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            float3 normalMap = UnpackNormal(tex2D(_NormalTex, IN.uv_NormalTex));
            
            normalMap = float3(normalMap.x * _NormalIntensity, normalMap.y * _NormalIntensity, normalMap.z);
            
            o.Normal = normalMap.rgb;
            o.Albedo = _MainTint.rgb;
            o.Alpha = _MainTint.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
