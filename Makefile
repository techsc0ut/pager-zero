.PHONY: up down shop-pf argocd-pf status

PROFILE ?= pz
MEMORY ?= 16
CPUS ?= 8

up:
	colima start $(PROFILE) --kubernetes --vm-type vz --vz-rosetta --mount-type virtiofs --cpus $(CPUS) --memory $(MEMORY) --disk 80 || true
	kubectl apply -n argocd -f ../pager-zero-gitops/root.yaml

down:
	colima stop $(PROFILE)

shop-pf:
	kubectl -n shop port-forward svc/otel-demo-frontendproxy 8080:8080

argocd-pf:
	kubectl -n argocd port-forward svc/argocd-server 8443:443

status:
	kubectl get nodes
	kubectl get pods -A
