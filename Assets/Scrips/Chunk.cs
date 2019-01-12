using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chunk {
    const float viewerMoveThresholdForChunkUpdate = 50f;
    const float sqrViewerMoveThresholdForChunkUpdate = viewerMoveThresholdForChunkUpdate * viewerMoveThresholdForChunkUpdate;

    private List<Vector4> positionsList = new List<Vector4>();
    private List<Vector3> directionList = new List<Vector3>();

    private Vector4[] viewedChunkCoord;
    private Vector3[] directionArray;

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

    public Chunk(float scale, int chunkSize,  Material instanceMaterial, Transform viewer)
    {
        this.scale = scale;
        this.chunkSize = chunkSize;
        this.viewer = viewer;

        planetRadius = (chunkSize - 1) * scale / 2;

        viewerPosition = viewer.position;

        Vector3[] directions = { Vector3.up, Vector3.down, Vector3.left, Vector3.right, Vector3.forward, Vector3.back };



       /* for (int i = 0; i < 6; i++)
        {
            chunkFace[i] = new ChunkFace(null, new Vector3(0, planetRadius, 0), this.scale, (chunkSize - 1), viewerPosition, directions[i]);
        }*/

        chunkFace = new ChunkFace(null, new Vector3(0, planetRadius, 0), this.scale, (chunkSize - 1), viewerPosition, directions[0]);

        meshData = MeshGenerator.GenerateTerrainMesh(chunkSize);
        meshData.CreateMesh();

        drawMesh = new DrawMesh(meshData.GetMesh(), instanceMaterial);

        positionsList = chunkFace.GetPositionList();
        directionList = chunkFace.GetDirectionList();

        viewedChunkCoord = positionsList.ToArray();
        directionArray = directionList.ToArray();

        drawMesh.UpdateData(positionsList.Count, viewedChunkCoord, directionArray);
    }

    public void Update(Material instanceMaterial)
    {
        viewerPosition = new Vector3(viewer.position.x, viewer.position.y, viewer.position.z);

        if (viewerPositionOld != viewerPosition)
        {
            viewerPositionOld = viewerPosition;

            UpdateChunkMesh();
        }
         
        if (positionsList.Count > 0)
        {
           
            drawMesh.Draw();
        }
    }

    private void UpdateChunkMesh()
    {      
        positionsList.Clear();
        directionList.Clear();

        chunkFace.Update(viewerPosition);
        positionsList = chunkFace.GetPositionList();
        directionList = chunkFace.GetDirectionList();

        viewedChunkCoord = positionsList.ToArray();
        directionArray = directionList.ToArray();

        if (viewedChunkCoord.Length > 0)
        {
            drawMesh.UpdateData(positionsList.Count, viewedChunkCoord, directionArray);
        }
    }


    public void Disable()
    {
        drawMesh.Disable();
    }
}
