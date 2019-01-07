using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chunk {

    private float scale;
    private int size;
    private int chunksVisibleInViewDst;
    private int chunkSize = 200;

    private List<Vector4> positionsList = new List<Vector4>();

    private Material material;
    private Material instanceMaterial;

    DrawMesh drawMesh;

    public Chunk(float scale, int size)
    {
        this.scale = scale;
        this.size = size;
    }

    void UpdateChunkMesh()
    {
        for (int yOffset = -chunksVisibleInViewDst; yOffset <= chunksVisibleInViewDst; yOffset++)
        {
            for (int xOffset = -chunksVisibleInViewDst; xOffset <= chunksVisibleInViewDst; xOffset++)
            {
                float scale = 1.0f;

                positionsList.Add(new Vector4((xOffset) * (chunkSize - 1) * scale, 0, (yOffset) * (chunkSize - 1) * scale, scale));

            }
        }

        Vector4[] viewedChunkCoord = positionsList.ToArray();

        drawMesh = new DrawMesh(positionsList.Count, MeshGenerator.GenerateTerrainMesh(chunkSize).CreateMesh(), instanceMaterial, viewedChunkCoord);
    }

    void OnDisable()
    {
        drawMesh.Disable();
    }
}
