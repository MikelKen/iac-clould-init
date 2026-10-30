
import * as aws from "@pulumi/aws";
import { settings } from "./config";

function createSecurityGroup(role: string) {
  return new aws.ec2.SecurityGroup(`${role}-sg`, {
    vpcId: settings.vpcId,

    description: `SSH para ${role}`,

    ingress: [
      {
        protocol: "tcp",
        fromPort: 22,
        toPort: 22,
        cidrBlocks: [settings.sshCidr],
        description: "SSH desde IP autorizada",
      },
    ],

    egress: [
      {
        protocol: "-1",
        fromPort: 0,
        toPort: 0,
        cidrBlocks: ["0.0.0.0/0"],
        description: "Salida a Internet",
      },
    ],

    tags: {
      Project: settings.project,
      Environment: settings.environment,
      ManagedBy: "pulumi",
      Role: role,
    },
  });
}

export const frontendSG = createSecurityGroup("frontend");
export const backendSG = createSecurityGroup("backend");
