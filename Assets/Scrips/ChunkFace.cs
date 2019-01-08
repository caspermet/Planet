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

    private bool isGenerate;

    public ChunkFace(ChunkFace parent, Vector3 position, float scale, int chunkSize)
    {
        this.parentChunk = parent;
        this.position = position;
        this.scale = scale;
        this.chunkSize = chunkSize;

        positionToDraw = new Vector4((position.x) * (chunkSize - 1) * scale, position.y, (position.z) * (chunkSize - 1) * scale, scale);

        isGenerate = true;

        if (parent != null)
            parent.Dispose();
    }

    public void MergeChunk()
    {
        if (chunkTree == null)
            return;

        for (int i = 0; i < chunkTree.Length; i++)
        {
            chunkTree[i].MergeChunk();
            chunkTree[i].Dispose();
        }

        chunkTree = null;
    }

    public void SubDivide()
    {
        Vector3 stepLeft = new Vector3(chunkSize * scale / 4, 0, 0);
        Vector3 stepUp = new Vector3(0, 0, chunkSize * scale / 4);

        float newScale = scale / 2;


        chunkTree = new ChunkFace[] {
                new ChunkFace(this, position - stepLeft + stepUp, newScale, chunkSize),
                new ChunkFace(this, position + stepLeft + stepUp, newScale, chunkSize),
                new ChunkFace(this, position - stepLeft - stepUp, newScale, chunkSize),
                new ChunkFace(this, position + stepLeft - stepUp, newScale, chunkSize)
            };

        Dispose();
    }

    public void Dispose()
    {
        isGenerate = false;
    }
}
