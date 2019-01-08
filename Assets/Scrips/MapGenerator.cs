using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapGenerator : MonoBehaviour {
    public int chunksVisibleInViewDst;

    public Transform viewer;

    public Material material;
    public Material instanceMaterial;

    private Chunk chunk;

    public int chunkSize = 200;

    void Start()
    {

        chunk = new Chunk(512.0f, chunksVisibleInViewDst, chunkSize, instanceMaterial, viewer);
    }

    void Update()
    {
        chunk.Update();
    }


}
