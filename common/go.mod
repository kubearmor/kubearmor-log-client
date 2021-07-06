module github.com/kubearmor/kubearmor-log-client/common

go 1.15

replace (
	github.com/kubearmor/kubearmor-log-client => ../
	github.com/kubearmor/kubearmor-log-client/common => ./
)
