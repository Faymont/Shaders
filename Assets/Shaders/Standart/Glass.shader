Shader "Custom/Glass"
{
	Properties
	{
		_MainTex("Base (RGB) Trans (A)", 2D) = "white" {}
		_Colour("Colour", Color) = (1,1,1,1)
		_BumpMap("Noise text", 2D) = "bump" {}
		_Magnitude("Magnitude", Range(0,1)) = 0.05
	}


	SubShader
	{
		Tags{"Queue"="Transparent" "IgnoreProjector"="True" "RenderType"="Opaque"}
		ZWrite On Lighting Off Cull Off Fog {Mode Off} Blend One Zero

		// берём всё что отредереллось в тестуре модели (по сути что находится за этой моделью когда на ней ещё ничего нету)
		GrabPass {"_GrabTexture"}

		Pass 
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#include "UnityCG.cginc"
			
			// прокидываем переменные
			sampler2D _GrabTexture;
		
			sampler2D _MainTex;
			fixed4 _Colour;

			sampler2D _BumpMap;
			float  _Magnitude;


			struct vin_vtc
			{
				// В структуру кладутся такие данные модели как позиция в координатах модели, цвет и UV вершины
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f_vtc
			{
				// тут хранятся уже преобразованные данные вершины, позиция в координатах камеры
				float4 vertex : POSITION;
				float4 color : COLOR;
				float2 texcoord : TEXCOORD0;
				
				// uv координаты для текстуры первого прохода
				float4 uvgrab : TEXCOORD1;
			};
			

			v2f_vtc vert(vin_vtc v)
			{
				v2f_vtc o;
				// переводим вершины из координат модели в координаты камеры
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.color = v.color;
				o.texcoord = v.texcoord;
				
				// рассчитываем uv для граб тектуры т.к. изначально она не является текстурой модели и у неё нету  uv 
				o.uvgrab = ComputeGrabScreenPos(o.vertex);
				return o;
			}
			

			half4 frag(v2f_vtc i) : COLOR
			{
				// берём цвет фрагмента из главной текстуры
				half4 mainColour = tex2D(_MainTex, i.texcoord);

				// рассчитываем влияние нормали
				half4 bump = tex2D(_BumpMap, i.texcoord);
				half2 distortion = UnpackNormal(bump).rg;

				// накладываем шум нормали на uv и используем модификатор	
				i.uvgrab.xy += distortion * _Magnitude;

				// tex2Dproj Чтение цвета из двумерной проективной текстуры.
				fixed4 col = tex2Dproj(_GrabTexture, UNITY_PROJ_COORD(i.uvgrab));
				// получившийся цвет умножаем на цвет главной текстуры и модификатора 
				return col * mainColour * _Colour;
			}


			ENDCG


		}

	}
}
