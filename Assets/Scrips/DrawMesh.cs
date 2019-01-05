using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class DrawMesh : MonoBehaviour {

    int instanceCount = 100000;
    Mesh instanceMesh;
    Material instanceMaterial;
    int subMeshIndex = 0;
    Vector4[] positions;

    int cachedInstanceCount = -1;
    int cachedSubMeshIndex = -1;
    ComputeBuffer positionBuffer;
    ComputeBuffer argsBuffer;
    uint[] args = new uint[5] { 0, 0, 0, 0, 0 };

    public DrawMesh (int instanceCount, Mesh instanceMesh, Material instanceMaterial, Vector4[] positions)
    {
        this.instanceMesh = instanceMesh;
        this.instanceCount = instanceCount;
        this.instanceMaterial = instanceMaterial;
        this.positions = positions;
    }   

    void UpdateBuffers()
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

    void Disable()
    {
        if (positionBuffer != null)
            positionBuffer.Release();
        positionBuffer = null;

    }
}
