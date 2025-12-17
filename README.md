# Setup Instructions

## Infrastructure Setup
The Jenkins server infrastructure is provisioned using **Terraform**. The following resources are created:

- **EC2 instance**
- **Security group** with inbound rules
- **IAM policy**
- **IAM role**
- **IAM Instance profile**

The EC2 instance comes pre-installed with Jenkins and is activated through the `user_data` feature of Terraform.

---

## Pipeline Setup
- Create the pipeline using the instructions provided in the **Pipeline Explanation** section.
- The pipeline is configured to **trigger automatically** on any push made to the Git repository.
- Verify the **Build status** after the trigger and ensure the build completes successfully.

---

## EKS Cluster Setup
- Create an **EKS cluster** for Jenkins to deploy the manifests.
- Once the pipeline runs successfully, you should see the **`trend-deployment`** in the EKS deployments section.
- This deployment will spin up pods based on the defined number of replicas.
- A **Load Balancer** will be created to serve traffic to the application pods.

---

## IAM Role Access
- In EKS, add the Jenkins EC2 instance’s **IAM role** to the Access list.

---

## Monitoring Setup
- Deploy **Prometheus** and **Grafana** in EKS using Helm:

  ```bash
  helm install kube-prometheus-stack

# Pipeline Explanation

This pipeline is constructed to run in **Jenkins** and consists of **5 stages**:

1. **Clone the Repo**
2. **Build the Docker image**
3. **Login to DockerHub**
4. **Push the image to DockerHub**
5. **Deploy the manifests to the EKS cluster**

---

## Credentials
- The **DockerHub credentials** are configured in Jenkins under the **Credentials** settings.

---

## Permissions
The EC2 instance running Jenkins must have the following **IAM permissions** to deploy to the EKS cluster:

```json
[
  "eks:DescribeCluster",
  "eks:ListClusters"
]

