
load('ext://nerdctl', 'nerdctl_build')

nerdctl_build(
    ref="vfarcic/crossplane-idp",
    context=".",
)

k8s_yaml(kustomize("kustomize/overlays/dev"))

k8s_resource("crossplane-idp", port_forwards="8080:8080")
