using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class USBReplacementController : MonoBehaviour
{

    public Shader m_replacementShader;
    // Start is called before the first frame update
    private void OnEnable()
    {
        if(m_replacementShader != null)
        {
            //la cámara va a remplazar todos los shaders en la
            //escena por aquel de remplazo la configuración
            //del render type debe coincidir en ambos shaders

            GetComponent<Camera>().SetReplacementShader(m_replacementShader, "RenderType");
        }
    }

    // Update is called once per frame
    private void OnDisable()
    {
        //reseteamos shader asignado
        GetComponent<Camera>().ResetReplacementShader();
    }
}
