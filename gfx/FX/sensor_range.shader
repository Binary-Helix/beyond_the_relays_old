BlendState BlendState
{
	BlendEnable = yes
	AlphaTest = no
	SourceBlend = "SRC_ALPHA"
	DestBlend = "INV_SRC_ALPHA"
	WriteMask = "RED|GREEN|BLUE"
}

DepthStencilState DepthStencilState
{
	DepthEnable = no
}

VertexStruct VS_INPUT
{
    float2 	vPosition  	: POSITION;
    float 	vMedium 	: TEXCOORD0;
};

VertexStruct VS_OUTPUT
{
    float4  vPosition 	: PDX_POSITION;
    float 	vMedium 	: TEXCOORD0;
};

ConstantBuffer( Common, 0, 0 )
{
	float4x4 ViewProjectionMatrix;
};

VertexShader =
{
	MainCode VertexShader
		ConstantBuffers = { Common }
	[[
		VS_OUTPUT main(const VS_INPUT v )
		{
			VS_OUTPUT Out;
			Out.vPosition  	= mul( ViewProjectionMatrix, float4( v.vPosition.x, -0.3, v.vPosition.y, 1.0 ) );
			Out.vMedium		= v.vMedium;
			return Out;
		}
		
	]]
}

PixelShader =
{
	MainCode PixelShader
	[[
		float4 main( VS_OUTPUT v ) : PDX_COLOR
		{
			float vMedium = saturate( ( v.vMedium - 1.9 ) * 1000.0 );
			float4 vColor = float4( 0.0, 0.5, 0.8, 0.5 ) * vMedium + 			// Medium color
							float4( 0.0, 0.5, 0.8, 0.5 ) * ( 1.0 - vMedium );	// Low color
			return vColor;
		}
		
	]]
}

Effect SensorRange
{
	VertexShader = "VertexShader"
	PixelShader = "PixelShader"
}
