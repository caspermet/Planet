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

        chunkFace = new ChunkFace(null, new Vector3(0, 0, 0), this.scale, chunkSize);
        meshData = MeshGenerator.GenerateTerrainMesh(chunkSize);
        meshData.CreateMesh();

        drawMesh = new DrawMesh(meshData.GetMesh(), instanceMaterial);

        UpdateChunkMesh();
    }

    public void Update()
    {
        viewerPosition = new Vector3(viewer.position.x, viewer.position.y, viewer.position.z);

        if (viewerPositionOld != viewerPosition)
        {
            viewerPositionOld = viewerPosition;
            UpdateChunkMesh();
        }
       // UpdateChunkMesh();
        if (positionsList.Count > 0)
        {
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

            var dist = Vector3.Distance(viewer.position, item.GetBounds().ClosestPoint(viewer.position));
            if (item.GetParrent() != null)
            {
                var distParent = Vector3.Distance(viewer.position, item.GetParrent().GetBounds().ClosestPoint(viewer.position));

                if (item.GetParrent() != null && distParent > item.GetParrent().GetScale() * chunkSize)
                {
                    Debug.Log("merge");
                    if (item.GetParrent() != null)
                    {
                        item.GetParrent().MergeChunk();
                        positionsList.Add(item.GetParrent().GetPositionToDraw());
                    }
                    else
                    {
                        positionsList.Add(item.GetPositionToDraw());
                    }
                }
            }

            Debug.Log(item.GetPositionToDraw());

            
            if(item.GetScale() * chunkSize > dist)
            {
                Debug.Log("divide");
                item.SubDivide();
                foreach (var child in item.getChunkTree())
                {
                    positionsList.Add(child.GetPositionToDraw());
                }
            }
            else
            {
                positionsList.Add(item.GetPositionToDraw());
            }

        }

        Vector4[] viewedChunkCoord = positionsList.ToArray();
        if (viewedChunkCoord.Length > 0)
        {
            drawMesh.UpdateData(positionsList.Count, viewedChunkCoord);
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
