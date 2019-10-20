Shader "Hidden/BWDiffuse"
{
    Properties
    {
        _MainTex ("Base (RGB)", 2D) = "white" {}
        _bwBlend ("Black & White blend", Range(0,1)) = 0
    }
    SubShader
    {
        // No culling or depth
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert_img
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float _bwBlend;

            fixed4 frag (v2f_img  i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

				float lum = col.r*.3 + col.g*.59 + col.b*.11;
				float bw = float3(lum, lum, lum);

				float4 result = col;
				result.rgb = lerp(col.rgb, bw, _bwBlend);

                return result;
            }
            ENDCG
        }
    }
}
