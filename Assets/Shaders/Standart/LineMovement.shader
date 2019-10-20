Shader "Unlit/LineMovement"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color ("Color", Color) = (0,0,0,0)
		_Speed ("Speed", Float) = 1.0
		//_Direction("Direction", Vector) = (0,0,0)
    }
    SubShader
    {
		Tags { "RenderType" = "Transparent" "Queue" = "Transparent" "IgnoreProjector" = "True"}
		Cull Off
		Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

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
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
				float4 oVertex : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			float4 _Color;
			//float4 _Direction;

            v2f vert (appdata v)
            {
                v2f o;
				o.oVertex = v.vertex;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

			fixed4 frag(v2f i) : SV_Target
			{
				// sample the texture

				float pos = sin((i.oVertex.y + _Time * 20) * 20);
				_Color.a = sign(pos);
                return _Color;
            }
            ENDCG
        }
    }
}
