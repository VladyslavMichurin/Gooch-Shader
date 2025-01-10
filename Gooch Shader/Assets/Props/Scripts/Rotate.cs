using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Rotate : MonoBehaviour
{
    public List<Transform> objToRotate;

    [Range(0f, 20f)]
    public float speed = 10;

    private void FixedUpdate()
    {
        foreach (Transform t in objToRotate)
        {
            t.RotateAround(t.transform.position, Vector3.up, -Time.deltaTime * speed);
        }    
    }
}
