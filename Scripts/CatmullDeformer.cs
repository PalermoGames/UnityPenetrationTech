using System.Collections;
using System.Collections.Generic;
using Unity.Collections;
using UnityEngine;

namespace PenetrationTech {

    public class CatmullDeformer : CatmullDisplay {
        public const int splineCount = 1;
        [SerializeField]
        private List<Renderer> targetRenderers;
        private HashSet<Material> targetMaterials;
        private int catmullSplinesID;
        private int catmullSplineCountID;
        private ComputeBuffer catmullBuffer;
        private NativeArray<CatmullSplineData> data;
        public System.Collections.ObjectModel.ReadOnlyCollection<Renderer> GetTargetRenderers() => targetRenderers.AsReadOnly();
        private unsafe struct CatmullSplineData {
            private const int subSplineCount = 6;
            private const int binormalCount = 16;
            private const int distanceCount = 32;
            public int pointCount;
            public float arcLength;
            public fixed float weights[subSplineCount*4*3];
            public fixed float distanceLUT[distanceCount];
            public fixed float binormalLUT[binormalCount*3];
            public CatmullSplineData(CatmullSpline spline) {
                pointCount = spline.GetWeights().Count/4;
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
            catmullBuffer = new ComputeBuffer(splineCount, CatmullSplineData.GetSize());
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
            catmullSplinesID = Shader.PropertyToID("_CatmullSplines");
            catmullSplineCountID = Shader.PropertyToID("_CatmullSplineCount");
        }
        protected virtual void Update() {
            data[0] = new CatmullSplineData(path);
            catmullBuffer.SetData<CatmullSplineData>(data, 0, 0, 1);
            foreach(Material material in targetMaterials) {
                material.SetInt(catmullSplineCountID, 1);
                material.SetBuffer(catmullSplinesID, catmullBuffer);
            }
        }
    }

}