Shader "Unlit/ForceField"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		_Color("Color", Color) = (1,1,1,1)

		_IntersectionColor("Intersection Color", Color) = (1,1,1,1)
		_Offset("Intersection Range", Range(0,5)) = 2.8

    }
    SubShader
    {
		Tags { "Queue" = "Transparent" "RenderType" = "Transparent"  }
		ZWrite Off
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
				float4 screenPos : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
			
			sampler2D _CameraDepthTexture;
			float4 _Color;
			float4 _IntersectionColor;
			float _Offset;
            
			v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
				// Вычисляет координаты данной вершины в пространстве экрана
				o.screenPos = ComputeScreenPos(o.vertex);
				// Необходимо для модификации тайлинга и оффсета текстуры (необходимо дополнительно объявить *NameOfTex*_ST
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				//Вычисляем где на экране находится вершина
				float2 screenuv = i.vertex.xy / _ScreenParams.xy;
				// Берём цвет текстуры глубины камеры tex2D и получаем значение глубины в пределах [0,1] 
				float screenDepth = Linear01Depth(tex2D(_CameraDepthTexture, screenuv));
				
				// Считаем разницу между глубиной пикселя и глубины вершины	
				float diff = screenDepth  - Linear01Depth(i.vertex.z);

				// _ProjectionParams.w это 1/FarPlane камеры  
				float intersect = 1 - smoothstep(0,  _ProjectionParams.w * _Offset, diff);

				//fixed4 glowColor = fixed4(lerp(_Color.rgb, _IntersectionColor, pow(intersect, 4)), 1);
				
				// возвращает линейную интерполяцию двух скаляров или векторов на основе веса lerp(a,b,w) a - когда w =0 b - когда w=1 формула a + w*(b-a)
				fixed4 glowColor = fixed4(lerp(_Color.rgb, _IntersectionColor, intersect),0);

				// Берём цвет пикселя тектуры
				fixed4 texCol = tex2D(_MainTex, i.uv);

				fixed4 col = texCol * _Color.a  + glowColor;
				return col;
            }
            ENDCG
        }
    }
}
