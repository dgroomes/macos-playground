package main

import (
	"fmt"
	"net"
	"os"
	"os/exec"
	"path/filepath"
	"strings"
)

func main() {
	testWriteFileHome()
	testWriteFileTmp()
	testNetwork()
	testSubprocess()
}

func testWriteFileHome() {
	home, err := os.UserHomeDir()
	if err != nil {
		fmt.Printf("   ❌ Could not get home directory: %v\n", err)
		return
	}
	
	testFile := filepath.Join(home, "seatbelt-test.txt")
	err = os.WriteFile(testFile, []byte("Hello from macos-playground!"), 0644)
	if err != nil {
		fmt.Printf("   ❌ Failed to write to home directory: %v\n", err)
	} else {
		fmt.Println("   ✅ Wrote to home directory")
		os.Remove(testFile)
	}
}

func testWriteFileTmp() {
	testFile := "/tmp/seatbelt-test.txt"
	err := os.WriteFile(testFile, []byte("Hello from /tmp!"), 0644)
	if err != nil {
		fmt.Printf("   ❌ Failed to write to '/tmp': %v\n", err)
	} else {
		fmt.Println("   ✅ Wrote to /tmp")
		os.Remove(testFile)
	}
}

func testNetwork() {
	host := "wikipedia.org"
	port := "80"
	
	conn, err := net.Dial("tcp", net.JoinHostPort(host, port))
	if err != nil {
		fmt.Printf("   ❌ Could not connect to %s - %v\n", host, err)
	} else {
		fmt.Printf("   ✅ Connected to %s\n", host)
		conn.Close()
	}
}

func testSubprocess() {
	cmd := exec.Command("/bin/echo", "Hello from 'echo' in subprocess")
	output, err := cmd.CombinedOutput()
	if err != nil {
		fmt.Printf("   ❌ Failed to run 'echo': %v\n", err)
	} else {
		fmt.Printf("   ✅ %s", strings.TrimSpace(string(output)))
		fmt.Println()
	}
}