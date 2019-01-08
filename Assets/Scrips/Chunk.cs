using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chunk {
    const float viewerMoveThresholdForChunkUpdate = 50f;
    const float sqrViewerMoveThresholdForChunkUpdate = viewerMoveThresholdForChunkUpdate * viewerMoveThresholdForChunkUpdate;

    private float scale;
    private int chunksVisibleInViewDst;
    private int chunkSize = 200;

    private List<Vector4> positionsList = new List<Vector4>();

    private Material material;
    private Material instanceMaterial;

    private DrawMesh drawMesh;

    private static Vector2 viewerPosition;
    private static Vector2 viewerPositionOld;
    private Transform viewer;

    public Chunk(float scale, int chunksVisibleInViewDst, int chunkSize,  Material instanceMaterial, Transform viewer)
    {
        this.scale = scale;
        this.chunksVisibleInViewDst = chunksVisibleInViewDst;
        this.chunkSize = chunkSize;
        this.positionsList = positionsList;
        this.instanceMaterial = instanceMaterial;
        this.viewer = viewer;

        UpdateChunkMesh();
    }

    public void Update()
    {
        viewerPosition = new Vector3(viewer.position.x, viewer.position.y, viewer.position.z);

        if ((viewerPositionOld - viewerPosition).sqrMagnitude > sqrViewerMoveThresholdForChunkUpdate)
        {
            viewerPositionOld = viewerPosition;
            UpdateChunkMesh();
        }

        drawMesh.Draw();
    }

    private void UpdateChunkMesh()
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
