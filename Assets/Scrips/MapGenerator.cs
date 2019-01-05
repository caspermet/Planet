using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapGenerator : MonoBehaviour {

    public float scale = 2f;
    public int chunksVisibleInViewDst;

    public static Vector2 viewerPosition;
    public Transform viewer;
    public Texture2D mapTexture;

    int chunkSize = 254;

    private float oldScale;

    public int size;

    public Material material;

    Dictionary<Vector2, PreObjects> terrainChunkDictionary = new Dictionary<Vector2, PreObjects>();
    Dictionary<float, PreObjects> preTerrainChunkDictionary = new Dictionary<float, PreObjects>();

    void Start()
    {
        oldScale = scale;
        UpdateChunkMesh();
    }

    void Update()
    {
        if(oldScale != scale)
        {
            UpdateChunkMesh();
            oldScale = scale;
        }
    }

    public void UpdateChunkMesh()
    {
        viewerPosition = new Vector2(viewer.position.x, viewer.position.z);
        PreObjects clone;

        int currentChunkCoordX = Mathf.RoundToInt(0);
        int currentChunkCoordY = Mathf.RoundToInt(0);

        //DeleteObject();

        float relativeScale = 0.5f;

        while(relativeScale < 10){
            preTerrainChunkDictionary.Add(relativeScale, new PreObjects(material, relativeScale, mapTexture));
            relativeScale += relativeScale;
        }

        for (int yOffset = -chunksVisibleInViewDst; yOffset <= chunksVisibleInViewDst; yOffset++)
        {
            for (int xOffset = -chunksVisibleInViewDst; xOffset <= chunksVisibleInViewDst; xOffset++)
            {
                Vector2 viewedChunkCoord = new Vector2(currentChunkCoordX + xOffset, currentChunkCoordY + yOffset) * (size - 1);
                Debug.Log(viewedChunkCoord);
                clone = Instantiate(preTerrainChunkDictionary[1] , new Vector3(viewedChunkCoord.x, 0, viewedChunkCoord.y), Quaternion.identity);

                terrainChunkDictionary.Add(viewedChunkCoord, clone);

            }
        }
    }


    void DeleteObject()
    {
        foreach (var entry in terrainChunkDictionary)
        {
           // entry.Value.DeleteObject();        
       //     terrainChunkDictionary.Remove(entry.Key);
        }
    }


    public class TerrainChunk
    {
        GameObject meshObject;
        Vector2 position;
        Vector3 position3d;

        MeshRenderer meshRenderer;
        MeshFilter meshFilter;
        MeshCollider meshCollider;
       

        public TerrainChunk(Material material, Vector2 coord, int size, float scale,Texture2D mapTexture)
        {

            position = coord * (size - 1);

            Vector3 positionV3 = new Vector3(position.x, 0, position.y);       

            meshObject = new GameObject("Terrain Chunk");
            meshRenderer = meshObject.AddComponent<MeshRenderer>();
            meshFilter = meshObject.AddComponent<MeshFilter>();
            meshCollider = meshObject.AddComponent<MeshCollider>();
            meshRenderer.material = material;

            meshRenderer.material.mainTexture = mapTexture;

            meshObject.transform.position = positionV3 * scale;        
            meshObject.transform.localScale = Vector3.one ;


            meshFilter.mesh = MeshGenerator.GenerateTerrainMesh(scale).CreateMesh();
        }

        public void DeleteObject()
        {
            Destroy(meshObject);
        }

        public void NewTerrainCHunk(Material material, Vector2 coord, int size, float scale, Texture2D mapTexture)
        {
            position = coord * (size - 1);

            Vector3 positionV3 = new Vector3(position.x, 0, position.y);

            meshObject = new GameObject("Terrain Chunk");
            meshRenderer = meshObject.AddComponent<MeshRenderer>();
            meshFilter = meshObject.AddComponent<MeshFilter>();
            meshCollider = meshObject.AddComponent<MeshCollider>();
            meshRenderer.material = material;

            meshRenderer.material.mainTexture = mapTexture;

            meshObject.transform.position = positionV3 * scale;
            meshObject.transform.localScale = Vector3.one;


            meshFilter.mesh = MeshGenerator.GenerateTerrainMesh(scale).CreateMesh();
        }
    }

    public class PreObjects
    {
        GameObject meshObject;
        Vector2 position;
        Vector3 position3d;

        Bounds bounds;

        MeshRenderer meshRenderer;
        MeshFilter meshFilter;
        MeshCollider meshCollider;


        public PreObjects(Material material, float scale, Texture2D mapTexture)
        {
            meshObject = new GameObject("Terrain Chunk");
            meshRenderer = meshObject.AddComponent<MeshRenderer>();
            meshFilter = meshObject.AddComponent<MeshFilter>();
            meshCollider = meshObject.AddComponent<MeshCollider>();
            meshRenderer.material = material;

            meshRenderer.material.mainTexture = mapTexture;

            meshObject.transform.localScale = Vector3.one;

            meshFilter.mesh = MeshGenerator.GenerateTerrainMesh(scale).CreateMesh();

            SetVisible(false);
        }

        public GameObject GetGameObject()
        {
            return meshObject;
        }

        public void DeleteObject()
        {
            Destroy(meshObject);
        }

        public void SetVisible(bool visible)
        {
            meshObject.SetActive(visible);

        }
    }
}
