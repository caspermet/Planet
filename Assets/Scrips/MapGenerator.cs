using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapGenerator : MonoBehaviour {

    public float scale = 2f;
    public int chunksVisibleInViewDst;

    public static Vector2 viewerPosition;
    public Transform viewer;
    public Texture2D mapTexture;

    private float oldScale;

    public int size;

    public Material material;

    Dictionary<Vector2, TerrainChunk> terrainChunkDictionary = new Dictionary<Vector2, TerrainChunk>();
    Dictionary<float, PreObjects> preTerrainChunkDictionary = new Dictionary<float, PreObjects>();
    Dictionary<float, PreMesh> PreMeshDictionary = new Dictionary<float, PreMesh>();


    public Material instanceMaterial;
    public int subMeshIndex = 0;


    private int cachedInstanceCount = -1;
    private int cachedSubMeshIndex = -1;
    private ComputeBuffer positionBuffer;
    private ComputeBuffer argsBuffer;
    private uint[] args = new uint[5] { 0, 0, 0, 0, 0 };

    void Start()
    {
        oldScale = scale;
        CreatePreMesh();
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

    void CreatePreMesh()
    {
        float relativeScale = 0.5f;

        while (relativeScale < 10)
        {
            PreMeshDictionary.Add(relativeScale, new PreMesh(relativeScale));
            relativeScale += relativeScale;
        }
    }

    void UpdateChunkMesh()
    {
        Debug.Log("Hello");
        viewerPosition = new Vector2(viewer.position.x, viewer.position.z);

        int currentChunkCoordX = Mathf.RoundToInt(0);
        int currentChunkCoordY = Mathf.RoundToInt(0);

        int instanceCount = (chunksVisibleInViewDst * 2 + 1) * (chunksVisibleInViewDst * 2 + 1);

        Vector4[] viewedChunkCoord = new Vector4[instanceCount];
        int positionIndex = 0;

        for (int yOffset = -chunksVisibleInViewDst; yOffset <= chunksVisibleInViewDst; yOffset++)
        {
            for (int xOffset = -chunksVisibleInViewDst; xOffset <= chunksVisibleInViewDst; xOffset++)
            {
                Debug.Log(positionIndex);
                viewedChunkCoord[positionIndex] = new Vector4(currentChunkCoordX + xOffset, 0,currentChunkCoordY + yOffset, 1) * (size - 1);
                positionIndex++;
            }
        }
        UpdateBuffers(viewedChunkCoord, instanceCount, PreMeshDictionary[1].GetMesh());
        Debug.Log("Hello");
        Graphics.DrawMeshInstancedIndirect(PreMeshDictionary[1].GetMesh(), subMeshIndex, instanceMaterial, new Bounds(Vector3.zero, new Vector3(100.0f, 100.0f, 100.0f)), argsBuffer);
    }

    void UpdateBuffers(Vector4[] positions, int instanceCount, Mesh instanceMesh)
    {
        // Ensure submesh index is in range
        if (instanceMesh != null)
            subMeshIndex = Mathf.Clamp(subMeshIndex, 0, instanceMesh.subMeshCount - 1);

        // Positions
        if (positionBuffer != null)
            positionBuffer.Release();
        positionBuffer = new ComputeBuffer(instanceCount, 16);

        positionBuffer.SetData(positions);
        instanceMaterial.SetBuffer("positionBuffer", positionBuffer);

        // Indirect args
        if (instanceMesh != null)
        {
            args[0] = (uint)instanceMesh.GetIndexCount(subMeshIndex);
            args[1] = (uint)instanceCount;
            args[2] = (uint)instanceMesh.GetIndexStart(subMeshIndex);
            args[3] = (uint)instanceMesh.GetBaseVertex(subMeshIndex);
        }
        else
        {
            args[0] = args[1] = args[2] = args[3] = 0;
        }
        argsBuffer.SetData(args);

        cachedInstanceCount = instanceCount;
        cachedSubMeshIndex = subMeshIndex;
    }

    public class TerrainChunk
    {
        GameObject meshObject;
        Vector3 position;

        MeshRenderer meshRenderer;
        MeshFilter meshFilter;
        MeshCollider meshCollider;

        float scale;
       

        public TerrainChunk(GameObject meshObject, Vector2 coord, float scale)
        {
            this.meshObject = meshObject;
            this.scale = scale;

            meshRenderer = meshObject.AddComponent<MeshRenderer>();
            meshFilter = meshObject.AddComponent<MeshFilter>();
            meshCollider = meshObject.AddComponent<MeshCollider>();
            position = meshObject.transform.position;
            meshObject.transform.localScale = Vector3.one;
            SetVisible(true);
        }

        public void SetVisible(bool visible)
        {
            meshObject.SetActive(visible);

        }
    }

    public class PreMesh
    {
        Mesh preMesh;
        float scale;

        public PreMesh(float scale)
        {
            this.scale = scale;
            preMesh = MeshGenerator.GenerateTerrainMesh(scale).CreateMesh();
        }

        public Mesh GetMesh()
        {
            return preMesh;
        }
        
    }

    public class PreObjects
    {
        GameObject meshObject;
        Vector2 position;
        Vector3 position3d;

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
