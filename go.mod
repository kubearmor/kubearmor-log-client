module github.com/kubearmor/kubearmor-log-client

go 1.15

replace (
	github.com/kubearmor/kubearmor-log-client => ./
	github.com/kubearmor/kubearmor-log-client/client => ./client
	github.com/kubearmor/kubearmor-log-client/common => ./common
)

require github.com/kubearmor/kubearmor-log-client/client v0.0.0-00010101000000-000000000000
