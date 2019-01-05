using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapGenerator : MonoBehaviour {

    const float viewerMoveThresholdForChunkUpdate = 50f;
    const float sqrViewerMoveThresholdForChunkUpdate = viewerMoveThresholdForChunkUpdate * viewerMoveThresholdForChunkUpdate;

    public float scale = 2f;
    public int chunksVisibleInViewDst;

    public static Vector2 viewerPosition;
    public Transform viewer;
    public Texture2D mapTexture;

    public Material material;
    public Material instanceMaterial;
    public int subMeshIndex = 0;

    Dictionary<float, PreMesh> PreMeshDictionary = new Dictionary<float, PreMesh>();

    float oldScale;
    int instanceCount;

    static Vector2 viewerPositionOld;

    DrawMesh drawMesh;

    void Start()
    {  
        oldScale = scale;

        instanceCount = (chunksVisibleInViewDst * 2 + 1) * (chunksVisibleInViewDst * 2 + 1);
      //  CreatePreMesh();

        UpdateChunkMesh();
    }

    void Update()
    {
        if(oldScale != scale)
        {
            UpdateChunkMesh();
            oldScale = scale;
        }
        viewerPosition = new Vector3(viewer.position.x, viewer.position.y, viewer.position.z);

        if ((viewerPositionOld - viewerPosition).sqrMagnitude > sqrViewerMoveThresholdForChunkUpdate)
        {
            viewerPositionOld = viewerPosition;
            Debug.Log(viewerPosition);
        }

        drawMesh.Draw();
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

        int currentChunkCoordX = Mathf.RoundToInt(0);
        int currentChunkCoordY = Mathf.RoundToInt(0);

        Vector4[] viewedChunkCoord = new Vector4[instanceCount];
        int positionIndex = 0;

        for (int yOffset = -chunksVisibleInViewDst; yOffset <= chunksVisibleInViewDst; yOffset++)
        {
            for (int xOffset = -chunksVisibleInViewDst; xOffset <= chunksVisibleInViewDst; xOffset++)
            {
             
                viewedChunkCoord[positionIndex] = new Vector4((currentChunkCoordX + xOffset) * 5f , 0,(currentChunkCoordY + yOffset) * 5f, 5f);
                positionIndex++;
            }
        }
        
        drawMesh = new DrawMesh(instanceCount, MeshGenerator.GenerateTerrainMesh(1).CreateMesh(), instanceMaterial, viewedChunkCoord);  
    }

    void OnDisable()
    {
        drawMesh.Disable();
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

        public float GetScale()
        {
            return scale;
        }
        
    }

}
