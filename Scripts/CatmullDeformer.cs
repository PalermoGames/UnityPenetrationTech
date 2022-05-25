using System.Collections.Generic;
using Unity.Collections;
using UnityEngine;

namespace PenetrationTech {

    public class CatmullDeformer : CatmullDisplay {
        [SerializeField]
        protected Vector3 localRootUp = Vector3.forward;
        [SerializeField]
        protected Vector3 localRootForward = -Vector3.up;
        [SerializeField]
        protected Vector3 localRootRight = Vector3.right;
        [SerializeField]
        protected Transform rootBone;
        [SerializeField]
        protected Transform tipTarget;
        [SerializeField]
        private List<Renderer> targetRenderers;
        private HashSet<Material> targetMaterials;
        private static readonly int catmullSplinesID = Shader.PropertyToID("_CatmullSplines");
        private static readonly int dickForwardID = Shader.PropertyToID("_DickForwardWorld");
        private static readonly int dickRightID = Shader.PropertyToID("_DickRightWorld");
        private static readonly int dickUpID = Shader.PropertyToID("_DickUpWorld");
        private ComputeBuffer catmullBuffer;
        private NativeArray<CatmullSplineData> data;
        protected List<Renderer> GetTargetRenderers() => targetRenderers;
        public unsafe struct CatmullSplineData {
            private const int subSplineCount = 6;
            private const int binormalCount = 16;
            private const int distanceCount = 32;
            int pointCount;
            float arcLength;
            fixed float weights[subSplineCount*4*3];
            fixed float distanceLUT[distanceCount];
            fixed float binormalLUT[binormalCount*3];
            public CatmullSplineData(CatmullSpline spline) {
                pointCount = (spline.GetWeights().Count/4)+1;
                arcLength = spline.arcLength;
                for(int i=0;i<subSplineCount*4&&i<spline.GetWeights().Count;i++) {
                    Vector3 weight = spline.GetWeights()[i];
                    weights[i*3] = weight.x;
                    weights[i*3+1] = weight.y;
                    weights[i*3+2] = weight.z;
                }
                UnityEngine.Assertions.Assert.AreEqual(spline.GetDistanceLUT().Count, distanceCount);
                for(int i=0;i<distanceCount;i++) {
                    distanceLUT[i] = spline.GetDistanceLUT()[i];
                }
                UnityEngine.Assertions.Assert.AreEqual(spline.GetBinormalLUT().Count, binormalCount);
                for(int i=0;i<binormalCount;i++) {
                    Vector3 binormal = spline.GetBinormalLUT()[i];
                    binormalLUT[i*3] = binormal.x;
                    binormalLUT[i*3+1] = binormal.y;
                    binormalLUT[i*3+2] = binormal.z;
                }
            }
            public static int GetSize() {
                return sizeof(float)*(subSplineCount*3*4+1+binormalCount*3+distanceCount) + sizeof(int);
            }
        }
        public void AddTargetRenderer(Renderer renderer) {
            List<Material> tempMaterials = new List<Material>();
            renderer.GetMaterials(tempMaterials);
            foreach(Material m in tempMaterials) {
                targetMaterials.Add(m);
            }
        }
        public void RemoveTargetRenderer(Renderer renderer) {
            List<Material> tempMaterials = new List<Material>();
            renderer.GetMaterials(tempMaterials);
            foreach(Material m in tempMaterials) {
                targetMaterials.Remove(m);
            }
        }
        protected virtual void OnEnable() {
            catmullBuffer = new ComputeBuffer(1, CatmullSplineData.GetSize());
            data = new NativeArray<CatmullSplineData>(1, Allocator.Persistent);
        }
        protected virtual void OnDisable() {
            catmullBuffer.Release();
            data.Dispose();
        }
        protected virtual void Start() {
            targetMaterials = new HashSet<Material>();
            List<Material> tempMaterials = new List<Material>();
            foreach(Renderer renderer in targetRenderers) {
                renderer.GetMaterials(tempMaterials);
                foreach(Material m in tempMaterials) {
                    targetMaterials.Add(m);
                }
            }
        }
        protected virtual void LateUpdate() {
            data[0] = new CatmullSplineData(path);
            catmullBuffer.SetData(data, 0, 0, 1);
            foreach(Material material in targetMaterials) {
                material.SetVector(dickForwardID, rootBone.TransformDirection(localRootForward));
                material.SetVector(dickRightID, rootBone.TransformDirection(localRootRight));
                material.SetVector(dickUpID, rootBone.TransformDirection(localRootUp));
                material.SetBuffer(catmullSplinesID, catmullBuffer);
            }
        }
    }

}