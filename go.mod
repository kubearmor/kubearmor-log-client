module github.com/kubearmor/kubearmor-log-client

go 1.15

replace (
	github.com/kubearmor/kubearmor-log-client => ./
	github.com/kubearmor/kubearmor-log-client/client => ./client
)

require (
	github.com/kubearmor/KubeArmor/protobuf v0.0.0-20220128124414-a9d4b4910046
	google.golang.org/grpc v1.44.0
)
