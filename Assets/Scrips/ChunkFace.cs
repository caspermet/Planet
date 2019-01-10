using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ChunkFace {
    private ChunkFace parentChunk;
    private ChunkFace[] chunkTree;

    private int chunkSize;
    private float scale;

    private Vector3 position;
    private Vector4 positionToDraw;

    private Bounds bounds;

    public bool generated;

    public ChunkFace(ChunkFace parent, Vector3 position, float scale, int chunkSize)
    {
        this.parentChunk = parent;
        this.position = position;
        this.scale = scale;
        this.chunkSize = chunkSize;

        generated = true;
        
        bounds = new Bounds(position, new Vector3(1,0,1) * chunkSize * scale);
        positionToDraw = new Vector4((position.x) , position.y, (position.z) , scale);
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

    public void MergeChunk()
    {
        if (chunkTree == null)
            return;

        for (int i = 0; i < chunkTree.Length; i++)
        {
            chunkTree[i].MergeChunk();
        }

        generated = true;

        chunkTree = null;
    }

    public void SubDivide()
    {
        Vector3 stepLeft = new Vector3((chunkSize - 1) * scale / 4, 0, 0);
        Vector3 stepUp = new Vector3(0, 0, (chunkSize - 1) * scale / 4);

        float newScale = scale / 2;

        generated = false;

        chunkTree = new ChunkFace[] {
                new ChunkFace(this, position - stepLeft + stepUp, newScale, chunkSize),
                new ChunkFace(this, position + stepLeft + stepUp, newScale, chunkSize),
                new ChunkFace(this, position - stepLeft - stepUp, newScale, chunkSize),
                new ChunkFace(this, position + stepLeft - stepUp, newScale, chunkSize)
            };
    }

    public bool GetGenerate()
    {
        return generated;
    }

    public void SetGenerated(bool isGenerate)
    {
        generated = isGenerate;
    }
}
