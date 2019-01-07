using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MapGenerator : MonoBehaviour {

    const float viewerMoveThresholdForChunkUpdate = 50f;
    const float sqrViewerMoveThresholdForChunkUpdate = viewerMoveThresholdForChunkUpdate * viewerMoveThresholdForChunkUpdate;

    public int chunksVisibleInViewDst;

    public static Vector2 viewerPosition;
    public Transform viewer;
    public Texture2D mapTexture;

    public Material material;
    public Material instanceMaterial;
    public int subMeshIndex = 0;

    List<Vector4> positionsList = new List<Vector4>();

    float oldScale;

    static Vector2 viewerPositionOld;

    DrawMesh drawMesh;

    public int chunkSize = 200;

    void Start()
    {  
        UpdateChunkMesh();
    }

    void Update()
    {

        viewerPosition = new Vector3(viewer.position.x, viewer.position.y, viewer.position.z);

        if ((viewerPositionOld - viewerPosition).sqrMagnitude > sqrViewerMoveThresholdForChunkUpdate)
        {
            viewerPositionOld = viewerPosition;
            UpdateChunkMesh();
        }

        drawMesh.Draw();
    }

    void UpdateChunkMesh()
    {

        for (int yOffset = -chunksVisibleInViewDst; yOffset <= chunksVisibleInViewDst; yOffset++)
        {
            for (int xOffset = -chunksVisibleInViewDst; xOffset <= chunksVisibleInViewDst; xOffset++)
            {
                float scale = 1.0f;
                                        
                positionsList.Add(new Vector4((xOffset) * (chunkSize - 1) * scale, 0, (yOffset) * (chunkSize - 1) * scale, scale));          
            
            }
        }

        Vector4[] viewedChunkCoord = positionsList.ToArray();

        drawMesh = new DrawMesh(positionsList.Count, MeshGenerator.GenerateTerrainMesh(chunkSize).CreateMesh(), instanceMaterial, viewedChunkCoord);  
    }

    void OnDisable()
    {
        drawMesh.Disable();
    }
}
