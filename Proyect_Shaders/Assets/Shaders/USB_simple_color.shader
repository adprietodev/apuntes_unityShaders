Shader "Unlit/USB_simple_color"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}

        //Propiedades para números y sliders
        _Specular ("Specular", Range(0.0, 1.1)) = 0.3
        _Factor ("Color Factor", Float) = 0.3
        _Cid ("Color id", Int) = 2

        //Propiedades para colores y vectores
        _Color ("Tint", Color) = (1,1,1,1)
        _VPos ("Vertex Position", Vector) = (0,0,0,1)

        //Propiedades para texturas
        _Reflection ("Reflection", Cube) = "black" {}
        _3DTexture ("3D Texture", 3D) = "white" {}

        // Declaramos drawer Toggle
        [Toggle] _Enable ("Enable ?", Float) = 0

        [KeywordEnum(Off, Red, Blue)]
        _Options ("Color Options", Float) = 0

        [Enum(Off,0, Front, 1, Back, 2)]
        _Face ("Face Culling", Float) = 0

        [PowerSlider(3.0)]
        _Brightness ("Brightness", Range(0.01, 1)) = 0.08

        [IntRange]
        _Samples ("Samples", Range(0, 255)) = 100
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        //Pasamos la propiedad al comando
        Cull[_Face]

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            //Declaramos pragma
            #pragma shader_feature _ENABLE_ON
            #pragma multi_compile _OPTIONS_OFF _OPTIONS_RED _OPTIONS_BLUE

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

            // Inicializamos variables globales
            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;

            float _Brightness;
            int _Samples;

            half4 frag (v2f i) : SV_Target 
            {
                // Utilizamos las variables
                half4 col = tex2D(_MainTex, i.uv);
                
                //Generamos condición
                #if _ENABLE_ON
                    return col;
                #else
                    return col * _Color;
                #endif

                #if _OPTIONS_OFF
                    return col;
                #elif _OPTIONS_RED
                    return col * float4(1,0,0,1);
                #elif _OPTIONS_BLUE
                    return col * float4(0,0,1,1);
                #endif
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                UNITY_TRANSFER_FOG(o,o.vertex);
                return o;
            }

            /*fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                // apply fog
                UNITY_APPLY_FOG(i.fogCoord, col);
                return col;

            }*/

            ENDCG
        }
    }
}
