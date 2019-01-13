using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chunk
{
    const float viewerMoveThresholdForChunkUpdate = 50f;
    const float sqrViewerMoveThresholdForChunkUpdate = viewerMoveThresholdForChunkUpdate * viewerMoveThresholdForChunkUpdate;

    private List<Vector4> positionsList = new List<Vector4>();
    private List<Vector4> directionList = new List<Vector4>();

    private Vector4[] viewedChunkCoord;
    private Vector4[] directionArray;

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

    private Vector3[] directions;

    public Chunk(float scale, int chunkSize, Material instanceMaterial, Transform viewer)
    {
        directions = new Vector3[] { new Vector3(-1, 0, 0), new Vector3(1, 0, 0), new Vector3(0, 0, 1), new Vector3(0, 0, -1), new Vector3(0, 0, 1), new Vector3(0, 0, -1) };

        this.scale = scale;
        this.chunkSize = chunkSize;
        this.viewer = viewer;

        planetRadius = (chunkSize - 1) * scale / 2;

        viewerPosition = viewer.position;

        chunkFace = new ChunkFace(null, new Vector3(0, planetRadius, 0), this.scale, (chunkSize - 1), viewerPosition, directions[0]);
        meshData = MeshGenerator.GenerateTerrainMesh(chunkSize);
        meshData.CreateMesh();

        drawMesh = new DrawMesh(meshData.GetMesh(), instanceMaterial);
        
        positionsList = chunkFace.GetPositionList();
        directionList = chunkFace.GetDirectionList();

        viewedChunkCoord = positionsList.ToArray();
        directionArray = directionList.ToArray();

        drawMesh.UpdateData(positionsList.Count, viewedChunkCoord, directionArray) ;
      //  UpdateChunkMesh();
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
        directionList.Clear();

        positionsList = chunkFace.Update(viewerPosition);
        directionList = chunkFace.GetDirectionList();

        viewedChunkCoord = positionsList.ToArray();
        directionArray = directionList.ToArray();
        Debug.Log(positionsList.Count);
        if (viewedChunkCoord.Length > 0)
        {
            Debug.Log("console");
            drawMesh.UpdateData(positionsList.Count, viewedChunkCoord, directionArray);
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