using UnityEngine;
namespace SnS
{
    public class ForceRotationIdentity : MonoBehaviour
    {
        private void Update()
        {
            transform.rotation = Quaternion.identity;
        }
    }
}
