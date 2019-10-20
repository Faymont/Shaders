using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class VertexEffect : MonoBehaviour
{

    public MeshRenderer meshRenderer;
    private float displacementAmount;

    // Start is called before the first frame update
    void Start()
    {
        meshRenderer = GetComponent<MeshRenderer>();
    }

    // Update is called once per frame
    void Update()
    {
        displacementAmount = Mathf.Lerp(displacementAmount, 0, Time.deltaTime);
        meshRenderer.material.SetFloat("_Amount", displacementAmount);
        if (Input.GetButtonDown("Jump"))
        {
            displacementAmount += 1;
        }
    }
}
