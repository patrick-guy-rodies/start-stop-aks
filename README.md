# start-stop-aks
Start and Stop AKS cluster using Azure functionality
Stop and Start an Azure Kubernetes Service (AKS) cluster (preview)

 
Your AKS workloads may not need to run continuously, for example a development cluster that is used only during business hours. This leads to times where your Azure Kubernetes Service (AKS) cluster might be idle, running no more than the system components. You can reduce the cluster footprint by scaling all the User node pools to 0, but your System pool is still required to run the system components while the cluster is running. To optimize your costs further during these periods, you can completely turn off (stop) your cluster. This action will stop your control plane and agent nodes altogether, allowing you to save on all the compute costs, while maintaining all your objects and cluster state stored for when you start it again. You can then pick up right where you left of after a weekend or to have your cluster running only while you run your batch jobs.

 #### Important

AKS preview features are available on a self-service, opt-in basis. Previews are provided "as is" and "as available," and they're excluded from the service-level agreements and limited warranty. AKS previews are partially covered by customer support on a best-effort basis. As such, these features aren't meant for production use. AKS preview features aren't available in Azure Government or Azure China 21Vianet clouds. 

#### Limitations
When using the cluster start/stop feature, the following restrictions apply:

This feature is only supported for Virtual Machine Scale Sets backed clusters.
During preview, this feature is not supported for Private clusters.
The cluster state of a stopped AKS cluster is preserved for up to 12 months. If your cluster is stopped for more than 12 months, the cluster state cannot be recovered. For more information, see the AKS Support Policies.
During preview, you need to stop the cluster autoscaler (CA) before attempting to stop the cluster.
You can only start or delete a stopped AKS cluster. To perform any operation like scale or upgrade, start your cluster first.
Install the aks-preview Azure CLI
You also need the aks-preview Azure CLI extension version 0.4.64 or later. Install the aks-preview Azure CLI extension by using the az extension add command. Or install any available updates by using the az extension update command.


## Install the aks-preview extension

```zsh
az extension add --name aks-preview
```

## Update the extension to make sure you have the latest version installed

```zsh
az extension update --name aks-preview
```

Register the StartStopPreview preview feature
To use the start/stop cluster feature, you must enable the StartStopPreview feature flag on your subscription.

Register the StartStopPreview feature flag by using the az feature register command, as shown in the following example:

## Register feature

```zsh
az feature register --namespace "Microsoft.ContainerService" --name "StartStopPreview" --subscription "MySubID"
```

It takes a few minutes for the status to show Registered. Verify the registration status by using the az feature list command:

```zsh
az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/StartStopPreview')].{Name:name,State:properties.state}" --subscription "MySubID"
```

When ready, refresh the registration of the Microsoft.ContainerService resource provider by using the az provider register command:

```zsh
az provider register --namespace Microsoft.ContainerService --subscription "MySubID"
```

## Stop an AKS Cluster
You can use the az aks stop command to stop a running AKS cluster's nodes and control plane. The following example stops a cluster named myAKSCluster:

```zsh
az aks stop --name myAKSCluster --resource-group myResourceGroup --subscription "MySubID"
```

You can verify when your cluster is stopped by using the az aks show command 
```zsh
az aks show --name cstaticevent  --resource-group yourResourceGroup --subscription "MySubID" | grep -e 'code'
```

and confirming the powerState shows as Stopped as on the below output:

```json

{
[...]
  "code": "Stopped"
    "code": "Stopped"
[...]
}
```

If the provisioningState shows Stopping that means your cluster hasn't fully stopped yet.

#### Important

If you are using Pod Disruption Budgets the stop operation can take longer as the drain process will take more time to complete.

## Start an AKS Cluster
You can use the az aks start command to start a stopped AKS cluster's nodes and control plane. The cluster is restarted with the previous control plane state and number of agent nodes.
The following example starts a cluster named myAKSCluster:

```zsh
az aks start --name myAKSCluster --resource-group myResourceGroup
```

You can verify when your cluster has started by using the az aks show command 

```zsh
az aks show --name cstaticevent  --resource-group "yourResourceGroup" --subscription "MySubID" | grep -e 'code'
```

and confirming the powerState shows Running as on the below output:


```json

{
[...]
  "code": "Stopped"
    "code": "Stopped"
[...]
}
```

If the provisioningState shows Starting that means your cluster hasn't fully started yet.

## Result for own cluster

Cost for October: 
![Azure Cost Analysis](https://github.com/patrick-guy-rodies/start-stop-aks/blob/main/images/cost_october.png "Azure Cost Analysis")

## Shell Script to automatise this operation

The script is a simple bash script to Start, Stop or Show your AKS cluster.
Argument needed are start|stop|show as first argument and cluster name as second. The script used environment variables for subscription and resource group: $SUB_ID_NP $RG_SANDBOX

```bash

./start_stop_aks.sh stop cstaticevent

```

## References 
[Azure reference](https://docs.microsoft.com/en-us/azure/aks/start-stop-cluster)

