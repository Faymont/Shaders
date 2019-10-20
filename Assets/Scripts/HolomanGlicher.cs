using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HolomanGlicher : MonoBehaviour
{
    public float glichChance = 0.1f;

    private Renderer holoRenderer;
    private WaitForSeconds glitchLoopWait = new WaitForSeconds(.1f);
    private WaitForSeconds glitchDuration = new WaitForSeconds(.1f);


    private void Awake()
    {
        holoRenderer = GetComponent<Renderer>();
    }

    // Start is called before the first frame update
    IEnumerator Start()
    {
        while (true)
        {
            float glitchTest = Random.Range(0f, 1f);
            if (glitchTest <= glichChance) StartCoroutine(Glitch());
            yield return glitchLoopWait;
        }
    }

    IEnumerator Glitch()
    {
        glitchDuration = new WaitForSeconds(Random.Range(.05f, .25f));
        holoRenderer.material.SetFloat("_Amount", 1f);
        holoRenderer.material.SetFloat("_CutoutThresh", 0.29f);
        holoRenderer.material.SetFloat("_Distance", 0.3f);
        holoRenderer.material.SetFloat("_Amplitude", Random.Range(15,250));
        holoRenderer.material.SetFloat("_Speed", Random.Range(10, 20));
        yield return glitchDuration;
        holoRenderer.material.SetFloat("_Amount", 0f);
        holoRenderer.material.SetFloat("_CutoutThresh", 0f);
    }


}
