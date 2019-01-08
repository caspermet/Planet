using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chunk {
    const float viewerMoveThresholdForChunkUpdate = 50f;
    const float sqrViewerMoveThresholdForChunkUpdate = viewerMoveThresholdForChunkUpdate * viewerMoveThresholdForChunkUpdate;

    private List<Vector4> positionsList = new List<Vector4>();

    private float scale;
    private int chunkSize = 200;

    private Material material;
    private Material instanceMaterial;

    private DrawMesh drawMesh;

    private static Vector2 viewerPosition;
    private static Vector2 viewerPositionOld;
    private Transform viewer;

    private ChunkFace chunkFace;

    private MeshData meshData;

    public Chunk(float scale, int chunkSize,  Material instanceMaterial, Transform viewer)
    {
        this.scale = scale;
        this.chunkSize = chunkSize;
        this.instanceMaterial = instanceMaterial;
        this.viewer = viewer;

        chunkFace = new ChunkFace(null, new Vector3(0, 0, 0), this.scale, chunkSize);
        meshData = MeshGenerator.GenerateTerrainMesh(chunkSize);
        meshData.CreateMesh();

        drawMesh = new DrawMesh();
    }

    public void Update()
    {
        viewerPosition = new Vector3(viewer.position.x, viewer.position.y, viewer.position.z);

        if ((viewerPositionOld - viewerPosition).sqrMagnitude > sqrViewerMoveThresholdForChunkUpdate)
        {
            viewerPositionOld = viewerPosition;
            UpdateChunkMesh();
        }

        if (positionsList.Count > 0)
        {
           // Debug.Log(positionsList.Count);
            drawMesh.Draw();
        }
    }

    private void UpdateChunkMesh()
    {      
        List<ChunkFace> chunkFacesList = new List<ChunkFace>();
        positionsList.Clear();

        GetActiveChunksFromChunkTree(ref chunkFacesList, chunkFace);
        foreach (var item in chunkFacesList)
        {
            
            var dist = Vector3.Distance(viewer.transform.position, item.GetBounds().ClosestPoint(viewer.transform.position));
            Debug.Log(item.GetPositionToDraw());
          /*  Debug.Log(dist);
            Debug.Log(item.GetScale());*/

            if (dist > item.GetScale())
            {
                item.MergeChunk();
            }
            else if(item.GetScale() > chunkSize)
            {
                item.SubDivide();
            }
            else if(item.GetGenerate())
            {
                positionsList.Add(item.GetPositionToDraw());
            }
        }

        Vector4[] viewedChunkCoord = positionsList.ToArray();
        if (viewedChunkCoord.Length > 0)
        {
            drawMesh.UpdateData(positionsList.Count, meshData.GetMesh(), instanceMaterial, viewedChunkCoord);
        }
    }

    private void GetActiveChunksFromChunkTree(ref List<ChunkFace> chunkFaceList, ChunkFace chunkTree)
    {
        if(chunkTree.getChunkTree() != null)
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
