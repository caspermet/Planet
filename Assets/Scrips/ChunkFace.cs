using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChunkFace {
    private ChunkFace parentChunk;
    private ChunkFace[] chunkTree;

    private int chunkSize;
    private float scale;

    private Vector3 directionX;
    private Vector3 directionZ;
    private Vector3 position;
    private Vector4 positionToDraw;

    private List<Vector4> positionsList = new List<Vector4>();
    private List<Vector4> directionList = new List<Vector4>();

    private Bounds bounds;

    private Vector4[] chunkData;

    public Transform chunkTrunsform;

    private Vector3 directionnn;

    public ChunkFace(ChunkFace parent, Vector3 position, float scale, int chunkSize, Vector3 viewerPositon, Vector3 directionX, Vector3 directionZ)
    {
       
        this.parentChunk = parent;
        this.position = position;
        this.scale = scale;
        this.chunkSize = chunkSize;
        this.directionX = directionX;
        this.directionZ = directionZ;

        bounds = new Bounds(position, new Vector3(1,0,1) * chunkSize * scale);
        positionToDraw = new Vector4((position.x) , 0, (position.z) , scale);
    

        //Update(viewerPositon);
    }

    public void Update(Vector3 viewerPositon)
    {
        var dist = Vector3.Distance(viewerPositon, bounds.ClosestPoint(viewerPositon));
        Debug.Log(dist);
        if (parentChunk != null)
        {

            var distParent = Vector3.Distance(viewerPositon, parentChunk.GetBounds().ClosestPoint(viewerPositon));
           
            if (distParent > parentChunk.GetScale() * chunkSize)
            {
                parentChunk.MergeChunk();
                return;
            }
        }

        if (scale * chunkSize > dist)
        {
  
            SubDivide(viewerPositon);
        }

        else
        {
            Debug.Log("test1");
            positionsList.Clear();
            directionList.Clear();
            positionsList.Add(positionToDraw);
            directionList.Add(directionX);
        }
    }

    public ChunkFace[] getChunkTree()
    {
        return chunkTree;
    }

    public Bounds GetBounds()
    {
        return bounds;
    }

    public float GetScale()
    {
        return scale;
    }

    public Vector4 GetPositionToDraw()
    {
        return positionToDraw;
    }

    public Vector3 GetPosition()
    {
        return position;
    }

    public ChunkFace GetParrent()
    {
        return parentChunk;
    }

    public List<Vector4> GetPositionList()
    {
        return positionsList;
    }

    public List<Vector4> GetDirectionList()
    {
        return directionList;
    }

    public void MergeChunk()
    {
        if (chunkTree == null)
            return;

        for (int i = 0; i < chunkTree.Length; i++)
        {
            chunkTree[i].MergeChunk();
        }

        chunkTree = null;
        Debug.Log("test1");
        positionsList.Clear();
        positionsList.Add(positionToDraw);
        directionList.Clear();
        directionList.Add(directionX);
    }

    public void SubDivide(Vector3 viewerPosition)
    {
        Vector3 stepLeft = new Vector3(chunkSize * scale / 4, 0, 0);
        Vector3 stepUp = new Vector3(0, 0, chunkSize * scale / 4);

        float newScale = scale / 2;

        chunkTree = new ChunkFace[] {
                new ChunkFace(this, position - stepLeft + stepUp, newScale, chunkSize, viewerPosition, directionX, directionZ),
                new ChunkFace(this, position + stepLeft + stepUp, newScale, chunkSize, viewerPosition, directionX, directionZ),
                new ChunkFace(this, position - stepLeft - stepUp, newScale, chunkSize, viewerPosition, directionX, directionZ),
                new ChunkFace(this, position + stepLeft - stepUp, newScale, chunkSize, viewerPosition, directionX, directionZ),
        };

        positionsList.Clear();
        directionList.Clear();
       
        foreach (var chunk in chunkTree)
        {
            positionsList.AddRange(chunk.GetPositionList());
            directionList.AddRange(chunk.GetDirectionList());
        }
    }
}
