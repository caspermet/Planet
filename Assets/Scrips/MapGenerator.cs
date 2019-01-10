using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapGenerator : MonoBehaviour {

    public Transform viewer;

    public Material material;
    public Material instanceMaterial;

    public float maxScale;

    private Chunk chunk;



    public int chunkSize = 50;

    void Start()
    {
        chunk = new Chunk(maxScale,  chunkSize, instanceMaterial, viewer);
    }

    void Update()
    {
        chunk.Update();
    }

    void OnDisable()
    {
        chunk.Disable();
    }


}
