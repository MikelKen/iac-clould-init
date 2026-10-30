
import { frontend, backend } from "./compute";

export const infrastructureOutputs = {
  frontendInstanceId: frontend.id,
  frontendPublicIp: frontend.publicIp,
  frontendPrivateIp: frontend.privateIp,

  backendInstanceId: backend.id,
  backendPublicIp: backend.publicIp,
  backendPrivateIp: backend.privateIp,
};
