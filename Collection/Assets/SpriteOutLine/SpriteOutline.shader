Shader "Sprites/SpriteOutline"
{
    Properties
    {
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" { }
        _Color ("Tint", Color) = (1, 1, 1, 1)
        [MaterialToggle] PixelSnap ("Pixel snap", Float) = 0
        [HideInInspector] _RendererColor ("RendererColor", Color) = (1, 1, 1, 1)
        [HideInInspector] _Flip ("Flip", Vector) = (1, 1, 1, 1)
        [PerRendererData] _AlphaTex ("External Alpha", 2D) = "white" { }
        [PerRendererData] _EnableExternalAlpha ("Enable External Alpha", Float) = 0

        _OutlineColor ("Outline Color", Color) = (1, 1, 1, 1)
        _OutlineSize ("_Outline Size", Range(1, 10)) = 1
    }

    SubShader
    {
        Tags { "Queue" = "Transparent" "IgnoreProjector" = "True" "RenderType" = "Transparent" "PreviewType" = "Plane" "CanUseSpriteAtlas" = "True" }

        Cull Off
        Lighting Off
        ZWrite Off
        Blend One OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex SpriteVert
            #pragma fragment frag
            #pragma target 2.0
            #pragma multi_compile_instancing
            #pragma multi_compile _ PIXELSNAP_ON
            #pragma multi_compile _ ETC1_EXTERNAL_ALPHA
            #pragma shader_feature _OnlyOutline

            #include "UnitySprites.cginc"

            float _Outline;
            float4 _OutlineColor;
            float4 _MainTex_TexelSize;
            float _OutlineSize; //outline size

            fixed4 frag(v2f IN) : SV_Target
            {
                fixed4 col = SampleSpriteTexture(IN.texcoord);
                col.rgb *= col.a;

                if (col.a == 0)
                {
                    fixed4 pixelUp = tex2D(_MainTex, IN.texcoord + fixed2(0, _MainTex_TexelSize.y * _OutlineSize));
                    fixed4 pixelDown = tex2D(_MainTex, IN.texcoord - fixed2(0, _MainTex_TexelSize.y * _OutlineSize));
                    fixed4 pixelRight = tex2D(_MainTex, IN.texcoord + fixed2(_MainTex_TexelSize.x * _OutlineSize, 0));
                    fixed4 pixelLeft = tex2D(_MainTex, IN.texcoord - fixed2(_MainTex_TexelSize.x * _OutlineSize, 0));
                    
                    if (pixelUp.a != 0 || pixelDown.a != 0 || pixelRight.a != 0 || pixelLeft.a != 0)
                    {
                        col = _OutlineColor;
                    }
                }

                #if _OnlyOutline
                    else
                    {
                        discard;
                    }
                #endif
                return col;
            }
            ENDCG
        }
    }
    CustomEditor "ShaderFeatureCustom"
}
