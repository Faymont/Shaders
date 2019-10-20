Shader "Custom/Layers"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        
        //Входные значения уровней
        _inBlack ("Input Black", Range(0,255)) = 0
        _inGamma ("Input Gamma", Range(0,2)) = 1.61
        _inWhite ("Input White", Range(0,255)) = 255
        
        //Выходные значения уровней
        _outWhite ("Output White", Range(0,255)) = 255
        _outBlack ("Output Black", Range(0,255)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        fixed4 _Color;
        
        float _inBlack;
        float _inGamma;
        float _inWhite;
        float _outWhite;
        float _outBlack;
        
        
        float GetPixelLevel(float pixelColor)
        {
            float outRPixel;
            outRPixel = (pixelColor * 255.0);
            outRPixel = max(0,outRPixel - _inBlack);
            outRPixel = saturate(pow(outRPixel / (_inWhite - _inBlack), _inGamma));
            outRPixel = (outRPixel * (_outWhite - _outBlack) + _outBlack) / 255.0;
            return outRPixel;
        }
        

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            fixed4 c = tex2D (_MainTex, IN.uv_MainTex) * _Color;
            o.Albedo = float3(GetPixelLevel(c.r), GetPixelLevel(c.g), GetPixelLevel(c.b));
            o.Alpha = c.a;
        }
        ENDCG
    }
    FallBack "Diffuse"
}
