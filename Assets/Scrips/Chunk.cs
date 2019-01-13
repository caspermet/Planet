using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Chunk
{
    const float viewerMoveThresholdForChunkUpdate = 50f;
    const float sqrViewerMoveThresholdForChunkUpdate = viewerMoveThresholdForChunkUpdate * viewerMoveThresholdForChunkUpdate;

    private List<Vector4> positionsList = new List<Vector4>();
    private List<Vector4> directionList = new List<Vector4>();

    private Vector4[] viewedChunkCoord;
    private Vector4[] directionArray;

    private float scale;
    private int chunkSize = 200;

    private float planetRadius;

    private Material material;

    private DrawMesh[] drawMesh;

    private static Vector3 viewerPosition;
    private static Vector3 viewerPositionOld;
    private Transform viewer;

    private ChunkFace[] chunkFace;

    private MeshData meshData;

    private Vector3[] directions;
    private Vector3[] directions2;

    private Mesh[] mesh;

    int stany = 3;

    public Chunk(float scale, int chunkSize, Material instanceMaterial, Transform viewer)
    {
        this.scale = scale;
        this.chunkSize = chunkSize;
        this.viewer = viewer;

        planetRadius = (chunkSize - 1) * scale / 2;

        viewerPosition = viewer.position;
        viewerPositionOld = viewerPosition;
        directions = new Vector3[]{ new Vector3(-1,0, 0), new Vector3(1, 0, 0), new Vector3(0, 0, 1), new Vector3(0, 0, -1), new Vector3(0, 0, 1), new Vector3(0, 0, -1) };
        directions2 = new Vector3[] { new Vector3(0, -1, 0), new Vector3(0, -1, 0), new Vector3(0, -1, 0), new Vector3(0, -1, 0), new Vector3(-1, 0, 0), new Vector3(-1, 0, 0) };

        CreateMeshArray();

        chunkFace = new ChunkFace[6];
        drawMesh = new DrawMesh[6];

        chunkFace[0] = new ChunkFace(null, new Vector3(0, 0, 100), this.scale, (chunkSize - 1), viewerPosition, directions[0], directions2[0]);
        chunkFace[1] = new ChunkFace(null, new Vector3(0, 0, 500), this.scale, (chunkSize - 1), viewerPosition, directions[1], directions2[1]);
        chunkFace[2] = new ChunkFace(null, new Vector3(0, 500, 0), this.scale, (chunkSize - 1), viewerPosition, directions[2], directions2[2]);
       /* chunkFace[3] = new ChunkFace(null, new Vector3(planetRadius, 0, 0), this.scale, (chunkSize - 1), viewerPosition, directions[3], directions2[3]);
        chunkFace[4] = new ChunkFace(null, new Vector3(0, planetRadius, 0), this.scale, (chunkSize - 1), viewerPosition, directions[4], directions2[4]);
        chunkFace[5] = new ChunkFace(null, new Vector3(0, -planetRadius, 0), this.scale, (chunkSize - 1), viewerPosition, directions[5], directions2[5]);
        */
        for (int i = 0; i < stany; i++)
        {
            drawMesh[i] = new DrawMesh(mesh[0], instanceMaterial);          
        }
        finalize();


    }

    private void finalize()
    {
        for (int i = 0; i < stany; i++)
        {
            positionsList.Clear();
            directionList.Clear();
            chunkFace[i].Update(viewerPosition);

            positionsList = chunkFace[i].GetPositionList();
            directionList = chunkFace[i].GetDirectionList();

            viewedChunkCoord = positionsList.ToArray();
            directionArray = directionList.ToArray();

            for (int o = 0; o < viewedChunkCoord.Length; o++)
            {
               
                Debug.Log(viewedChunkCoord[o]);
            }
            Debug.Log(viewedChunkCoord.Length);
            if (chunkFace[i].GetPositionList().Count > 0)
            {
                drawMesh[i].UpdateData(chunkFace[i].GetPositionList().Count, viewedChunkCoord, directionArray);
            }
        }
    }

    public void Update(Material instanceMaterial)
    {
        viewerPosition = new Vector3(viewer.position.x, viewer.position.y, viewer.position.z);

        if (viewerPositionOld != viewerPosition)
        {
           viewerPositionOld = viewerPosition;
          // finalize();
        }

        for (int i = 0; i < stany; i++)
        {
            drawMesh[i].Draw();           
        }
    }

    private void UpdateChunkMesh()
    {
        finalize();
    }



    public void Disable()
    {
        for (int i = 0; i < stany; i++)
        {
            drawMesh[i].Disable();
        }
    }

    private void CreateMeshArray()
    {
        MeshData meshData;
        mesh = new Mesh[6];

        for (int i = 0; i < directions.Length; i++)
        {
            meshData = MeshGenerator.GenerateTerrainMesh(chunkSize, directions[i], directions2[i]);
            mesh[i] = meshData.CreateMesh();
        }
    }

}
