export interface LatLng {
  lat: number;
  lng: number;
}

const earthRadius = 6370.994 * 1000;

const { sin, cos, sqrt } = Math;

export function computeDistanceBetween(
  p1: LatLng,
  p2: LatLng,
  unit: "km" | "m" = "km"
) {
  const f1 = degToRad(p1.lat);
  const f2 = degToRad(p2.lat);
  const l1 = degToRad(p1.lng);
  const l2 = degToRad(p2.lng);

  const dx = cos(f2) * cos(l2) - cos(f1) * cos(l1);
  const dy = cos(f2) * sin(l2) - cos(f1) * sin(l1);
  const dz = sin(f2) - sin(f1);

  return (
    sqrt(dx * dx + dy * dy + dz * dz) *
    (unit == "m" ? earthRadius : earthRadius / 1000)
  );
}

function degToRad(v: number) {
  return (Math.PI / 180.0) * v;
}
