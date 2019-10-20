using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ProceduralTexture : MonoBehaviour
{
    public int widthHeight = 512;
    public Texture2D generatedTexure;

    private Material currentMaterial;
    private Vector2 centerPosition;
    private Renderer renderer;
    private void Start()
    {
        renderer = GetComponent<Renderer>();
        if (currentMaterial == null && renderer.sharedMaterial) currentMaterial = renderer.sharedMaterial;

        if (currentMaterial)
        {
            centerPosition = new Vector2(0.5f,0.5f);
            generatedTexure = GenerateAngleOfCenter();
            currentMaterial.SetTexture("_MainTex",generatedTexure);
        }
        
    }

    private Texture2D GenerateGradient()
    {
        Texture2D proceduralTexture = new Texture2D(widthHeight,widthHeight);

        Vector2 centerPixelPosition = centerPosition * widthHeight;

        for (int x = 0; x < widthHeight; x++)
        {
            for (int y = 0; y < widthHeight; y++)
            {
                Vector2 currentPosition = new Vector2(x,y);
                float pixelDistance = Vector2.Distance(currentPosition, centerPixelPosition) / (float)(widthHeight * 0.5);

                pixelDistance = Mathf.Abs(1 - Mathf.Clamp(pixelDistance, 0, 1));
                
                Color pixelColor = new Color(pixelDistance,pixelDistance,pixelDistance,1);
                proceduralTexture.SetPixel(x,y,pixelColor);
                
        
            }
            
        }
        
        proceduralTexture.Apply();
        return proceduralTexture;

    }
    
    
    private Texture2D GenerateSin()
    {
        Texture2D proceduralTexture = new Texture2D(widthHeight,widthHeight);

        Vector2 centerPixelPosition = centerPosition * widthHeight;

        for (int x = 0; x < widthHeight; x++)
        {
            for (int y = 0; y < widthHeight; y++)
            {
                Vector2 currentPosition = new Vector2(x,y);
                float pixelDistance = Vector2.Distance(currentPosition, centerPixelPosition) / (widthHeight * 0.5f);


                pixelDistance = Mathf.Abs(1 - Mathf.Clamp(pixelDistance, 0, 1));
                pixelDistance = Mathf.Sin(pixelDistance * 30f) * pixelDistance;

                Color pixelColor = new Color(pixelDistance,pixelDistance,pixelDistance,1);
                proceduralTexture.SetPixel(x,y,pixelColor);
                
        
            }
            
        }
        
        proceduralTexture.Apply();
        return proceduralTexture;

    }
    
    private Texture2D GenerateScalarMultyple()
    {
        Texture2D proceduralTexture = new Texture2D(widthHeight,widthHeight);

        Vector2 centerPixelPosition = centerPosition * widthHeight;

        for (int x = 0; x < widthHeight; x++)
        {
            for (int y = 0; y < widthHeight; y++)
            {
                Vector2 currentPosition = new Vector2(x,y);
                
                Vector2 pixelDirection = centerPixelPosition - currentPosition;
                pixelDirection.Normalize();
                float rightDirection = Vector2.Dot(pixelDirection, Vector2.right);
                float lefttDirection = Vector2.Dot(pixelDirection, -Vector2.right);
                float uptDirection = Vector2.Dot(pixelDirection, Vector2.up);
                
                Color pixelColor = new Color(rightDirection,lefttDirection,uptDirection,1);
                proceduralTexture.SetPixel(x,y,pixelColor);
                
        
            }
            
        }
        
        proceduralTexture.Apply();
        return proceduralTexture;

    }
    
    private Texture2D GenerateAngleOfCenter()
    {
        Texture2D proceduralTexture = new Texture2D(widthHeight,widthHeight);

        Vector2 centerPixelPosition = centerPosition * widthHeight;

        for (int x = 0; x < widthHeight; x++)
        {
            for (int y = 0; y < widthHeight; y++)
            {
                Vector2 currentPosition = new Vector2(x,y);
                
                Vector2 pixelDirection = centerPixelPosition - currentPosition;
                pixelDirection.Normalize();
                float rightDirection = Vector2.Angle(pixelDirection, Vector2.right)/ 360;
                float lefttDirection = Vector2.Angle(pixelDirection, -Vector2.right)/ 360;
                float uptDirection = Vector2.Angle(pixelDirection, Vector2.up)/ 360;
                
                Color pixelColor = new Color(rightDirection,lefttDirection,uptDirection,1);
                proceduralTexture.SetPixel(x,y,pixelColor);
                
        
            }
            
        }
        
        proceduralTexture.Apply();
        return proceduralTexture;

    }
    
    
    
    
}
