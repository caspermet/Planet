using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chunk
{
    const float viewerMoveThresholdForChunkUpdate = 50f;
    const float sqrViewerMoveThresholdForChunkUpdate = viewerMoveThresholdForChunkUpdate * viewerMoveThresholdForChunkUpdate;

    private List<Vector4> positionsList = new List<Vector4>();
    private Vector4[] viewedChunkCoord;

    private float scale;
    private int chunkSize = 200;

    private float planetRadius;

    private Material material;

    private DrawMesh drawMesh;

    private static Vector3 viewerPosition;
    private static Vector3 viewerPositionOld;
    private Transform viewer;

    private ChunkFace chunkFace;

    private MeshData meshData;

    public Chunk(float scale, int chunkSize, Material instanceMaterial, Transform viewer)
    {
        this.scale = scale;
        this.chunkSize = chunkSize;
        this.viewer = viewer;

        planetRadius = (chunkSize - 1) * scale / 2;

        viewerPosition = viewer.position;

        chunkFace = new ChunkFace(null, new Vector3(0, planetRadius, 0), this.scale, (chunkSize - 1), viewerPosition);
        meshData = MeshGenerator.GenerateTerrainMesh(chunkSize);
        meshData.CreateMesh();

        drawMesh = new DrawMesh(meshData.GetMesh(), instanceMaterial);
        positionsList = chunkFace.GetPositionList();
        viewedChunkCoord = positionsList.ToArray();

        drawMesh.UpdateData(positionsList.Count, viewedChunkCoord);
        //UpdateChunkMesh();
    }

    public void Update(Material instanceMaterial)
    {
        viewerPosition = new Vector3(viewer.position.x, viewer.position.y, viewer.position.z);

        if (viewerPositionOld != viewerPosition)
        {
            viewerPositionOld = viewerPosition;

            UpdateChunkMesh();
            viewedChunkCoord = positionsList.ToArray();
        }

        if (positionsList.Count > 0)
        {

            drawMesh.Draw();
        }
    }

    private void UpdateChunkMesh()
    {
        positionsList.Clear();

        positionsList = chunkFace.Update(viewerPosition);

        Vector4[] viewedChunkCoord = positionsList.ToArray();
        if (viewedChunkCoord.Length > 0)
        {
            drawMesh.UpdateData(positionsList.Count, viewedChunkCoord);
        }
    }

    private void GetActiveChunksFromChunkTree(ref List<ChunkFace> chunkFaceList, ChunkFace chunkTree)
    {
        if (chunkTree.getChunkTree() != null)
        {
            for (int i = 0; i < chunkTree.getChunkTree().Length; i++)
            {
                GetActiveChunksFromChunkTree(ref chunkFaceList, chunkTree.getChunkTree()[i]);
            }
        }
        else
        {
            chunkFaceList.Add(chunkTree);
        }
    }

    public void Disable()
    {
        drawMesh.Disable();
    }
}