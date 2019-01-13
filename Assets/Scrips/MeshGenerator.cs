using UnityEngine;
using System.Collections;

public static class MeshGenerator
{

    public static MeshData GenerateTerrainMesh(int chunkSize, Vector3 localUp, Vector3 localUp2)
    {

        int width = chunkSize;
        int height = chunkSize;
        float topLeftX = (width - 1) / -2f;
        float topLeftZ = (height - 1) / 2f;
        Vector3 position = new Vector3(0, 0, 0);

        position -= localUp * chunkSize * 0.5f;
        position -= localUp2 * chunkSize * 0.5f;

        MeshData meshData = new MeshData(width, height);
        int vertexIndex = 0;

        Vector3 axisA = new Vector3(localUp.y, localUp.z, localUp.x);
        Vector3 axisB = Vector3.Cross(localUp, axisA);
        Vector3 vertex;

        for (int y = 0; y < height; y++)
        {
            for (int x = 0; x < width; x++)
            {

                var vx = localUp * x;
                var vz = localUp2 * y;
   
                meshData.vertices[vertexIndex] = position + vx + vz;
                meshData.uvs[vertexIndex] = new Vector2(x / (float)width, y / (float)height);

                if (x < width - 1 && y < height - 1)
                {
                    meshData.AddTriangle(vertexIndex, vertexIndex + width + 1, vertexIndex + width);
                    meshData.AddTriangle(vertexIndex + width + 1, vertexIndex, vertexIndex + 1);
                }

                vertexIndex++;
            }
        }
        meshData.CreateMesh();


        return meshData;

    }
}

public class MeshData
{
    public Vector3[] vertices;
    public int[] triangles;
    public Vector2[] uvs;

    public float scale;

    private Mesh mesh;

    int triangleIndex;

    public MeshData(int meshWidth, int meshHeight)
    {
        vertices = new Vector3[meshWidth * meshHeight];
        uvs = new Vector2[meshWidth * meshHeight];
        triangles = new int[(meshWidth - 1) * (meshHeight - 1) * 6];
    }

    public void AddTriangle(int a, int b, int c)
    {
        triangles[triangleIndex] = a;
        triangles[triangleIndex + 1] = b;
        triangles[triangleIndex + 2] = c;
        triangleIndex += 3;
    }

    public Mesh CreateMesh()
    {
        mesh = new Mesh();
        mesh.vertices = vertices;
        mesh.triangles = triangles;
        mesh.uv = uvs;
        mesh.RecalculateNormals();

        return mesh;
    }

    public Mesh GetMesh()
    {
        return mesh;
    }

}