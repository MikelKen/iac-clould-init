
import * as aws from "@pulumi/aws";
import * as fs from "fs";
import * as path from "path";

import { settings } from "./config";
import { frontendSG, backendSG } from "./network";

// Clave pública de acceso SSH
const keyPair = new aws.ec2.KeyPair("lab-key", {
  publicKey: settings.sshPublicKey,

  tags: {
    Project: settings.project,
    ManagedBy: "pulumi",
  },
});

// Leer los archivos cloud-init compartidos
function readCloudInit(filename: string): string {
  const filePath = path.resolve(
    __dirname,
    "../../cloud-init",
    filename
  );

  return fs.readFileSync(filePath, "utf8");
}

function createServer(
  role: string,
  subnetId: string,
  securityGroup: aws.ec2.SecurityGroup,
  cloudInitFile: string
) {
  return new aws.ec2.Instance(`${role}-ec2`, {
    ami: settings.ubuntuAmi,
    instanceType: settings.instanceType,

    subnetId,
    associatePublicIpAddress: true,

    vpcSecurityGroupIds: [securityGroup.id],
    keyName: keyPair.keyName,

    rootBlockDevice: {
      volumeSize: settings.volumeSize,
      volumeType: settings.volumeType,
      deleteOnTermination: true,
    },

    userData: readCloudInit(cloudInitFile),

    tags: {
      Name: `iac-cloud-init-${role}`,
      Project: settings.project,
      Environment: settings.environment,
      ManagedBy: "pulumi",
      Role: role,
    },
  });
}

export const frontend = createServer(
  "frontend",
  settings.frontendSubnetId,
  frontendSG,
  "frontend.yaml"
);

export const backend = createServer(
  "backend",
  settings.backendSubnetId,
  backendSG,
  "backend.yaml"
);
