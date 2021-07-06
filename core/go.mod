module github.com/kubearmor/kubearmor-log-client/core

go 1.15

replace (
	github.com/kubearmor/kubearmor-log-client => ../
	github.com/kubearmor/kubearmor-log-client/core => ./
	github.com/kubearmor/kubearmor-log-client/common => ../common
)
