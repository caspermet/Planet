using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChunkFace {
    private ChunkFace parentChunk;
    private ChunkFace[] chunkTree;

    private int chunkSize;
    private float scale;

    private Vector3 direction;
    private Vector3 position;
    private Vector4 positionToDraw;
    private List<Vector4> positionsList = new List<Vector4>();
    private List<Vector3> directionList = new List<Vector3>();

    private Bounds bounds;

    private Vector4[] chunkData;


    public ChunkFace(ChunkFace parent, Vector3 position, float scale, int chunkSize, Vector3 viewerPositon, Vector3 direction )
    {
        this.parentChunk = parent;
        this.position = position;
        this.scale = scale;
        this.chunkSize = chunkSize;
        this.direction = direction;




       // this.position.y += radius;
        bounds = new Bounds(position, new Vector3(1,0,1) * chunkSize * scale);
        positionToDraw = new Vector4((position.x) , 0, (position.z) , scale);
       // this.position.y += radius;

        Update(viewerPositon);
    }

    public List<Vector4> Update(Vector3 viewerPositon)
    {
        var dist = Vector3.Distance(viewerPositon, bounds.ClosestPoint(viewerPositon));
        
        if (parentChunk != null)
        {
            var distParent = Vector3.Distance(viewerPositon, parentChunk.GetBounds().ClosestPoint(viewerPositon));
           
            if (distParent > parentChunk.GetScale() * chunkSize)
            {
                parentChunk.MergeChunk();
                return positionsList;
            }
        }

        if (scale * chunkSize > dist)
        { 
            SubDivide(viewerPositon);
        }

        else
        {
            positionsList.Add(positionToDraw);
            directionList.Add(direction);
        }
    
        return positionsList;
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

    public List<Vector3> GetDirectionList()
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

        positionsList.Clear();
        positionsList.Add(positionToDraw);
        directionList.Clear();
        directionList.Add(direction);
    }

    public void SubDivide(Vector3 viewerPosition)
    {
        Vector3 stepLeft = new Vector3(chunkSize * scale / 4, 0, 0);
        Vector3 stepUp = new Vector3(0, 0, chunkSize * scale / 4);

        float newScale = scale / 2;

        chunkTree = new ChunkFace[] {
                new ChunkFace(this, position - stepLeft + stepUp, newScale, chunkSize, viewerPosition, direction),
                new ChunkFace(this, position + stepLeft + stepUp, newScale, chunkSize, viewerPosition, direction),
                new ChunkFace(this, position - stepLeft - stepUp, newScale, chunkSize, viewerPosition, direction),
                new ChunkFace(this, position + stepLeft - stepUp, newScale, chunkSize, viewerPosition, direction)
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
