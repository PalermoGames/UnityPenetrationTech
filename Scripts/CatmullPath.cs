using System.Collections;
using System.Collections.Generic;
using UnityEngine;

namespace PenetrationTech {
    
    public static class ExtensionFloat {
        public static float Remap (this float value, float from1, float to1, float from2, float to2) {
            return (value - from1) / (to1 - from1) * (to2 - from2) + from2;
        }
    }

    public class CatmullPath {

        private static Vector3 GetPosition(Vector3 start, Vector3 tanPoint1, Vector3 tanPoint2, Vector3 end, float t) {
            // Using the expanded form of a Hermite basis functions
            // https://en.wikipedia.org/wiki/Cubic_Hermite_spline
            // p(t) = (2t³ - 3t² + 1)p₀ + (t³ - 2t² + t)m₀ + (-2t³ + 3t²)p₁ + (t³ - t²)m₁
            Vector3 position = (2f * t * t * t - 3f * t * t + 1f) * start
                + (t * t * t - 2f * t * t + t) * tanPoint1
                + (-2f * t * t * t + 3f * t * t) * end
                + (t * t * t - t * t) * tanPoint2;
            return position;
        }
        private static Vector3 GetVelocity(Vector3 start, Vector3 tanPoint1, Vector3 tanPoint2, Vector3 end, float t) {
            // First derivative (velocity)
            // p'(t) = (6t² - 6t)p₀ + (3t² - 4t + 1)m₀ + (-6t² + 6t)p₁ + (3t² - 2t)m₁
            Vector3 tangent = (6f * t * t - 6f * t) * start
                + (3f * t * t - 4f * t + 1f) * tanPoint1
                + (-6f * t * t + 6f * t) * end
                + (3f * t * t - 2f * t) * tanPoint2;
            return tangent;
        }
        private static Vector3 GetAcceleration(Vector3 start, Vector3 tanPoint1, Vector3 tanPoint2, Vector3 end, float t) {
            // Second derivative (jerk)
            // p''(t) = (12t - 6)p₀ + (6t - 4)m₀ + (-12t + 6)p₁ + (6t - 2)m₁
            Vector3 curvature = (12f * t - 6f) * start
                + (6f * t - 4f) * tanPoint1
                + (-12f * t + 6f) * end
                + (6f * t - 2f) * tanPoint2;
            return curvature;
        }
        
        private List<Vector3> weights;
        private List<Vector3> points;
        private List<float> LUT;
        public float arcLength {get; private set;}

        public List<Vector3> GetWeights() => weights;
        public List<float> GetDistanceLUT() => LUT;

        public CatmullPath(Vector3[] newPoints) {
            points = new List<Vector3>();
            weights = new List<Vector3>();
            LUT = new List<float>();
            SetWeightsFromPoints(newPoints);
        }

        private Vector3 SampleCurveSegmentPosition(int curveSegmentIndex, float t) {
            return GetPosition(weights[curveSegmentIndex*4], weights[curveSegmentIndex*4+1], weights[curveSegmentIndex*4+2], weights[curveSegmentIndex*4+3], t);
        }
        private Vector3 SampleCurveSegmentTangent(int curveSegmentIndex, float t) {
            return GetVelocity(weights[curveSegmentIndex*4], weights[curveSegmentIndex*4+1], weights[curveSegmentIndex*4+2], weights[curveSegmentIndex*4+3], t);
        }
        private Vector3 SampleCurveSegmentAcceleration(int curveSegmentIndex, float t) {
            return GetAcceleration(weights[curveSegmentIndex*4], weights[curveSegmentIndex*4+1], weights[curveSegmentIndex*4+2], weights[curveSegmentIndex*4+3], t);
        }

        private float GetCurveSegmentTimeFromCurveTime(out int curveSegmentIndex, float t) {
            curveSegmentIndex = Mathf.FloorToInt(t*(points.Count-1));
            float offseted = t-((float)curveSegmentIndex/(float)(points.Count-1));
            return offseted * (float)(points.Count-1);
        }
        
        private float DistToTime(float distance) {
            if (distance > 0f && distance < arcLength) {
                for(int i=0;i<LUT.Count-1;i++) {
                    if (distance>LUT[i] && distance<LUT[i+1]) {
                        return distance.Remap(LUT[i],LUT[i+1],(float)i/(LUT.Count-1f),(float)(i+1)/(LUT.Count-1f));
                    }
                }
            }
            return distance/arcLength;
        }
        private void GenerateLUT(int resolution) {
            float dist = 0f;
            Vector3 lastPosition = SampleCurveSegmentPosition(0, 0f);
            LUT.Clear();
            for(int i=0;i<resolution;i++) {
                float t = (((float)i)/(float)resolution);
                Vector3 position = GetPositionFromT(t);
                dist += Vector3.Distance(lastPosition, position);
                lastPosition = position;
                LUT.Add(dist);
            }
            arcLength = dist;
        }
        public void SetWeightsFromPoints(Vector3[] newPoints) {
            points.Clear();
            points.AddRange(newPoints);
            weights.Clear();
            for (int i=0;i<points.Count-1;i++) {
                Vector3 p0 = points[i];
                Vector3 p1 = points[i+1];

                Vector3 m0;
                if (i==0) {
                    m0 = (p1 - p0)*0.5f;
                } else {
                    m0 = (p1 - points[i-1])*0.5f;
                }
                Vector3 m1;
                if (i < points.Count - 2) {
                    m1 = (points[(i + 2) % points.Count] - p0)*0.5f;
                } else {
                    m1 = (p1 - p0)*0.5f;
                }
                weights.Add(p0);
                weights.Add(m0);
                weights.Add(m1);
                weights.Add(p1);
            }
            GenerateLUT(32);
        }
        public Vector3 GetPositionFromDistance(float distance) {
            float t = DistToTime(distance);
            return GetPositionFromT(t);
        }
        public Vector3 GetPositionFromT(float t) {
            int curveSegmentIndex;
            float subT = GetCurveSegmentTimeFromCurveTime(out curveSegmentIndex, t);
            return SampleCurveSegmentPosition(curveSegmentIndex, subT);
        }
        public Vector3 GetTangentFromDistance(float distance) {
            float t = DistToTime(distance);
            return GetTangentFromT(t);
        }
        public Vector3 GetAccelerationFromDistance(float distance) {
            float t = DistToTime(distance);
            return GetAccelerationFromT(t);
        }
        public Vector3 GetTangentFromT(float t) {
            int curveSegmentIndex;
            float subT = GetCurveSegmentTimeFromCurveTime(out curveSegmentIndex, t);
            return SampleCurveSegmentTangent(curveSegmentIndex, subT);
        }
        public Vector3 GetAccelerationFromT(float t) {
            int curveSegmentIndex;
            float subT = GetCurveSegmentTimeFromCurveTime(out curveSegmentIndex, t);
            return SampleCurveSegmentAcceleration(curveSegmentIndex, subT);
        }

    }

}