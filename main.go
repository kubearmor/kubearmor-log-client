package main

import (
	"flag"
	"fmt"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/kubearmor/kubearmor-log-client/core"
)

// StopChan Channel
var StopChan chan struct{}

// init Function
func init() {
	StopChan = make(chan struct{})
}

// ==================== //
// == Signal Handler == //
// ==================== //

// GetOSSigChannel Function
func GetOSSigChannel() chan os.Signal {
	c := make(chan os.Signal, 1)

	signal.Notify(c,
		syscall.SIGKILL,
		syscall.SIGHUP,
		syscall.SIGINT,
		syscall.SIGTERM,
		syscall.SIGQUIT,
		os.Interrupt)

	return c
}

// ========== //
// == Main == //
// ========== //

func main() {
	// == //

	// get arguments
	gRPCPtr := flag.String("gRPC", "", "gRPC server information")
	msgPathPtr := flag.String("msgPath", "none", "Output location for messages, {path|stdout|none}")
	logPathPtr := flag.String("logPath", "stdout", "Output location for alerts and logs, {path|stdout|none}")
	logFilterPtr := flag.String("filter", "policy", "Filter for what kinds of alerts and logs to receive, {policy|system|all}")
	jsonPtr := flag.Bool("json", false, "Flag to print alerts and logs in the JSON format")
	flag.Parse()

	// == //

	gRPC := ""

	fmt.Println("== KubeArmor information ==")

	if *gRPCPtr != "" {
		gRPC = *gRPCPtr
	} else {
		if val, ok := os.LookupEnv("KUBEARMOR_SERVICE"); ok {
			gRPC = val
		} else {
			gRPC = "localhost:32767"
		}
	}

	fmt.Println("  gRPC server: " + gRPC)

	// == //

	if *msgPathPtr == "none" && *logPathPtr == "none" {
		flag.PrintDefaults()
		return
	}

	if *logFilterPtr != "all" && *logFilterPtr != "policy" && *logFilterPtr != "system" {
		flag.PrintDefaults()
		return
	}

	// == //

	// create a client
	logClient := core.NewClient(gRPC, *msgPathPtr, *logPathPtr, *logFilterPtr)
	if logClient == nil {
		fmt.Printf("Failed to connect to the gRPC server (%s)\n", gRPC)
		return
	}
	fmt.Printf("Created a gRPC client (%s)\n", gRPC)

	// do healthcheck
	if ok := logClient.DoHealthCheck(); !ok {
		fmt.Println("Failed to check the liveness of the gRPC server")
		return
	}
	fmt.Println("Checked the liveness of the gRPC server")

	if *msgPathPtr != "none" {
		// watch messages
		go logClient.WatchMessages(*msgPathPtr, *jsonPtr)
		fmt.Println("Started to watch messages")
	}

	if *logPathPtr != "none" {
		if *logFilterPtr == "all" || *logFilterPtr == "policy" {
			// watch alerts
			go logClient.WatchAlerts(*logPathPtr, *jsonPtr)
			fmt.Println("Started to watch alerts")
		}

		if *logFilterPtr == "all" || *logFilterPtr == "system" {
			// watch logs
			go logClient.WatchLogs(*logPathPtr, *jsonPtr)
			fmt.Println("Started to watch logs")
		}
	}

	// listen for interrupt signals
	sigChan := GetOSSigChannel()
	<-sigChan
	close(StopChan)

	logClient.Running = false
	time.Sleep(time.Second * 1)

	// destroy the client
	if err := logClient.DestroyClient(); err != nil {
		fmt.Printf("Failed to destroy the gRPC client (%s)\n", err.Error())
		return
	}
	fmt.Println("Destroyed the gRPC client")

	// == //
}
