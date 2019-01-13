using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapGenerator : MonoBehaviour
{

    public Transform viewer;
    public Material instanceMaterial;

    public float maxScale;

    private Chunk chunk;

    public int chunkSize = 50;

    public float maxTerrainHeight;

    private Vector3 planetInfo;

    public Texture2D[] planetTexture;
    [Range(0, 1)]
    public float[] planetTextureRange;
    private float[] planetTextureRangeOld;

    void Start()
    {

        planetInfo.x = (chunkSize - 1) * maxScale / 2;
        planetInfo.y = maxTerrainHeight;

        instanceMaterial.SetTexture("_Textures", LoadArrayTexture.DoTexture(planetTexture));

        instanceMaterial.SetInt("_TexturesArrayLength", planetTextureRange.Length);
        instanceMaterial.SetFloatArray("_TexturesArray", planetTextureRange);
        instanceMaterial.SetVector("_PlanetInfo", planetInfo);

        chunk = new Chunk(maxScale, chunkSize, instanceMaterial, viewer);
    }

    void Update()
    {
        instanceMaterial.SetInt("_TexturesArrayLength", planetTextureRange.Length);
        instanceMaterial.SetFloatArray("_TexturesArray", planetTextureRange);

        chunk.Update(instanceMaterial);
    }

    void OnDisable()
    {
        chunk.Disable();
    }


}