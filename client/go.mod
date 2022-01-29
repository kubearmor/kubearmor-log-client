module github.com/kubearmor/kubearmor-log-client/client

go 1.15

replace (
	github.com/kubearmor/kubearmor-log-client => ../
	github.com/kubearmor/kubearmor-log-client/client => ./
	github.com/kubearmor/kubearmor-log-client/common => ../common
)

require (
	github.com/kubearmor/KubeArmor/protobuf v0.0.0-20210706103022-a88ee52bbf8a
	google.golang.org/grpc v1.35.0
)
