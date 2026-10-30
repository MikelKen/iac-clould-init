
import * as pulumi from "@pulumi/pulumi";

const config = new pulumi.Config();

export const settings = {
  project: "iac-cloud-init",
  environment: "lab",

  vpcId: config.require("vpcId"),

  frontendSubnetId: config.require("frontendSubnetId"),
  backendSubnetId: config.require("backendSubnetId"),

  ubuntuAmi: config.require("ubuntuAmi"),

  instanceType: "t3.micro",
  volumeSize: 20,
  volumeType: "gp3" as const,

  sshCidr: config.require("sshCidr"),
  sshPublicKey: config.require("sshPublicKey"),
};
