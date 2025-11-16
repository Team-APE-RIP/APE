Includes = {
    "posteffect_base.fxh"
}

PixelShader =
{
    Samplers =
    {
        MapTexture =
        {
            Index = 0
            MagFilter = "Linear"
            MinFilter = "Linear"
            MipFilter = "None"
            AddressU = "Clamp"
            AddressV = "Clamp"
        }
    }

    VertexStruct VS_OUTPUT
    {
        float4  vPosition : PDX_POSITION;
        float2  vTexCoord : TEXCOORD0;
    };

    VertexShader =
    {
        MainCode VertexShader
        [[
            VS_OUTPUT main(const VS_INPUT v )
            {
                VS_OUTPUT Out;
                Out.vPosition  = mul( WorldViewProjectionMatrix, float4( v.vPosition.xyz, 1.0 ) );
                Out.vTexCoord = v.vTexCoord;
                return Out;
            }
        ]]
    }

    MainCode PixelShaderUp
    [[
        float4 main( VS_OUTPUT v ) : PDX_COLOR
        {
            float2 containerSize = float2(Offset.x, Offset.y);
            float2 tileSize = float2(Color.r, Color.g);

            float2 invWin = InvWindowSize;
            float2 winSize = float2(0.0, 0.0);
            if(invWin.x > 0.0 && invWin.y > 0.0)
            {
                winSize = float2(1.0 / invWin.x, 1.0 / invWin.y);
            }

            if(containerSize.x <= 0.0 && winSize.x > 0.0) containerSize.x = winSize.x;
            if(containerSize.y <= 0.0 && winSize.y > 0.0) containerSize.y = winSize.y;

            float repeatsX = (tileSize.x > 0.0) ? (containerSize.x / tileSize.x) : 1.0;
            float repeatsY = (tileSize.y > 0.0) ? (containerSize.y / tileSize.y) : 1.0;

            float u = v.vTexCoord.x / repeatsX;
            float vcoord = v.vTexCoord.y / repeatsY;

            u = saturate(u);
            vcoord = saturate(vcoord);

            float4 colour = tex2D( MapTexture, float2(u, vcoord) );
            return colour;
        }
    ]]
}


Effect Up
{
    VertexShader = "VertexShader"
    PixelShader = "PixelShaderUp"
}

Effect Down
{
	VertexShader = "VertexShader"
	PixelShader = "PixelShaderUp"
}

Effect Disable
{
	VertexShader = "VertexShader"
	PixelShader = "PixelShaderUp"
}

Effect Over
{
	VertexShader = "VertexShader"
	PixelShader = "PixelShaderUp"
}

