# psychic_robot_battle

This repo contains code behind Psychic Robot Battle game currently hosted at https://rlyapin/psychic_robot_battle

The game itself is quite simple: the player has to click some buttons and the robot has to predict which buttons will be clicked - player's goal is staying unpredictable from robot's POV

However, the implementation of this game is more complicated and involves a kubernetes cluster running the following services:
* **psychic** model to predict clicks
* SvetleKit app to handle **frontend**
* **timescaledb** to store game logs
* **redis** to store aggregated stats for psychic model
* **airflow** to retrain psychic model and calculate aggregated stats

## Local development

To deploy the game locally do the following:

1. Install [Tilt](https://tilt.dev/)

2. Clone this repository

```
git clone https://github.com/rlyapin/psychic_robot_battle.git
cd psychic_robot_battle/
```

3. Run Tilt

```
tilt up
```

When services are initialized the following ports will be used:
* localhost:10350 for Tilt UI (to check all services)
* localhost:3000 for frontend (to play the game)
* localhost:8080 for psychic model (FastAPI endpoint)
* localhost:30165 for pgadmin (to check timescaledb logs)
* localhost:6379 for redis
* localhost:8000 for airflow webserver

Credentials to access these services (when necessary) lie in kubernetes/secrets folder

## Production deployment

### Differences from local setup

* Provisioning k8s cluster
* Adding a local registry service to store built docker images
* Adding load balancer (via MetalLB-Nginx ingress combo)
* Adding Cert Manager service to enable HTTPS

### Installation

0. Setup cluster

* 3 CX21 instances from Hetzner cloud running Ubuntu 20.04
* Additional floating IP (not tied to specific instance) with a dedicated domain pointing to it

1. Configure firewall

* open ports for [kubernetes](https://kubernetes.io/docs/reference/ports-and-protocols/)
* open UDP ports 8285 and 8472 to enable flannel / canal
* open ports 80 and 433 to handle HTTP(S) requests

2. Clone this repository to all cluster nodes

```
git clone https://github.com/rlyapin/psychic_robot_battle.git
cd psychic_robot_battle/production
```

3. Install docker and kubeadm on all cluster nodes

```
bash worker-setup.sh
```

4. Pick one node to be a control plane and initialize a kubernetes cluster

```
bash control-plane-setup.sh
```

5. Connect worker nodes to control plane

After `control-plane-setup.sh` script is done it prints `kubeadm join` instructions which should be run in remaining worker nodes

6. Initialize necessary services from control plane node

```
bash cluster-setup.sh FLOATING-IP EMAIL DEPLOYMODE
```
* FLOATING-IP is external IP for the service which DNS is pointing to
* EMAIL is email used to get TLS certificate
* DEPLOYMODE is either `staging` or `prod` and determines which environment to use for TLS certificates

7. Assign floating IP to a node running pod with ingress-nginx-controller

Such node can be found in the outputs of the following command
```
kubectl get pods -o wide --all-namespaces
```
In case of Hetzner cloud floating IP can be assigned to a target node in WebUI

8. Check deployed application at https://[your-domain-name]/psychic_robot_battle

## Concept art

Current art for the game was generated in collaboration with OpenAI DALL·E 2 model

WIP involves experiments with Midjourney and Stable Diffusion so this section might get updated in the future
