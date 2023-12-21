using Unity.VisualScripting;
using UnityEngine;

namespace SnS
{
    public class SquashAndStretchController : MonoBehaviour
    {

        public Vector2 currentDir;
        [SerializeField] float bias = 1f;
        [SerializeField] float maxDistance = 1.5f;
        [SerializeField] float anchorOffset = 3.75f;
        [SerializeField] Transform squasher;
        [SerializeField] Transform render;
        [SerializeField] Transform anchor;
        Camera cam;
        Vector2 startScale;

        private void Awake()
        {
            cam = Camera.main;
            startScale = squasher.localScale;

        }

        private void OnMouseDrag()
        {
            SquashAndStetch();
        }

        private void OnMouseDown()
        {
            SquashAndStetch();
        }

        private void OnMouseUp()
        {
            currentDir = Vector2.zero;
            squasher.localScale = startScale;
            anchor.localPosition = Vector2.zero;
            render.localPosition = Vector2.zero;
        }

        private void Update()
        {
            LookDir();
            ScaleByDir();
        }


        private void SquashAndStetch()
        {
            Vector3 worldPosition = cam.ScreenToWorldPoint(Input.mousePosition);
            currentDir = (worldPosition - transform.position);
            anchor.localPosition = -currentDir.normalized / anchorOffset;
        }

        private void LookDir()
        {
            var rotation = squasher.eulerAngles;

            var angle = Vector2.SignedAngle(Vector2.up, currentDir);
            rotation.z = angle;

            squasher.eulerAngles = rotation;
        }

        private void ScaleByDir()
        {
            var distance = currentDir.magnitude;
            Debug.LogError(distance);
            if (distance == 0 || distance > maxDistance)
                return;
            var amount = distance + bias;
            var inverseAmount = (1f / amount) * startScale.magnitude;
            squasher.localScale = new Vector3(inverseAmount, amount, 1f);
            render.position = -anchor.position * distance;

        }
    }
}