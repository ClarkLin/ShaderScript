Shader "Custom/RoundRect" {
	Properties {
		//图片模式
		_MainTex ("Base (RGB)", 2D) = "white" {}
		//圆角半径，默认为0.1 
		_RADIUSBUCE ("_RADIUSBUCE", Range(0,0.5)) = 0.14
		_Color("color", Color) = (0,1,1,0)
	}
	SubShader {
		pass {
			CGPROGRAM

			#pragma exclude_renderers gles
			#pragma vertex vert
			#pragma fragment frag
			#include "unitycg.cginc"

			float _RADIUSBUCE;
			sampler2D _MainTex;
			fixed4 _Color;

			struct v2f {
				float4 pos : SV_POSITION ;
				float2 ModeUV: TEXCOORD0;
				float2 RadiusBuceVU : TEXCOORD1;
			};
			v2f vert(appdata_base v) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP,v.vertex); //v.vertex;
				o.ModeUV = v.texcoord;
				o.RadiusBuceVU = v.texcoord - float2(0.5, 0.5);       //将模型UV坐标原点置为中心原点,为了方便计算

				return o;
			}

			fixed4 frag(v2f i) : COLOR
			{
				fixed4 col = _Color;

				if(abs(i.RadiusBuceVU.x)<0.5-_RADIUSBUCE||abs(i.RadiusBuceVU.y)<0.5-_RADIUSBUCE)    //即上面说的|x|<(0.5-r)或|y|<(0.5-r)
				{
					col=tex2D(_MainTex,i.ModeUV);
				}
				else
				{
					if(length( abs( i.RadiusBuceVU)-float2(0.5-_RADIUSBUCE,0.5-_RADIUSBUCE)) <_RADIUSBUCE)
					{
						col=tex2D(_MainTex,i.ModeUV);
					}
					else
					{
						discard;
					} 
				}
			return col;  
			}
			ENDCG
		}
	}
}
