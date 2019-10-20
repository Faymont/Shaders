Shader "Unlit/Displacement_Wave"
{
    Properties
    {
		[PerRendererData]
        _MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (1,1,1,1)
		_DisplacementTexture("Displacement Texture", 2D) = "white" {}
		[PerRendererData]
		_DisplacementPower("Displacement Power" , Range(-.1,.1)) = 0
    }
    SubShader
    {
		Tags
		{
			"RenderType" = "Transparent"
			"Queue" = "Transparent"
		}

		Cull Off
		//Blend SrcAlpha OneMinusSrcAlpha
		Blend Off
		
		GrabPass{"_GrabTexture"}

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
				float color : COLOR;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float2 uv : TEXCOORD0;
				float4 color : COLOR;

				float4 grabPos : TEXCOORD1;
            };

            sampler2D _MainTex;
            sampler2D _GrabTexture;
            sampler2D _DisplacementTexture;
			fixed4 _Color;
			float _DisplacementPower;

            v2f vert (appdata v)
            {
                v2f o;
				o.uv = v.uv;
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.grabPos = ComputeGrabScreenPos(o.vertex);
				o.grabPos /= o.grabPos.w;
				return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
				
				fixed4 texColor = tex2D(_MainTex, i.uv);
				clip(texColor.a - 0.01);

				fixed4 displPos = tex2D(_DisplacementTexture, i.uv);

				fixed2 offset = (displPos.xy * 2 - 1) * _DisplacementPower * displPos.a;
				offset = mul(unity_ObjectToWorld, offset);
                fixed4 grabColor = tex2D(_GrabTexture, i.grabPos.xy + offset);

				fixed s = step(grabColor, 0.5);

				fixed4 color = (s * (2 * grabColor * texColor) + (1 - s) * (1 - 2 * (1 - texColor) * (1 - grabColor))) *_Color;
				color = lerp(grabColor, color, texColor.a);
                return color ;
            }
            ENDCG
        }
    }
}
