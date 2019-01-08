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

        bounds = new Bounds(position, Vector2.one * chunkSize);
        positionToDraw = new Vector4((position.x) * (chunkSize - 1) * scale, position.y, (position.z) * (chunkSize - 1) * scale, scale);
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
        Vector3 stepLeft = new Vector3(chunkSize * scale / 4, 0, 0);
        Vector3 stepUp = new Vector3(0, 0, chunkSize * scale / 4);

        float newScale = scale / 2;

        generated = false;

        Debug.Log(position);
        Debug.Log(position - stepLeft + stepUp);

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
