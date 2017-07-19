From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v2 3/3] tests: Add basic monitor testing framework
Date: Wed, 19 Jul 2017 15:05:29 +0200
Message-ID: <20170719130529.25398-4-phil@nwl.cc>
References: <20170719130529.25398-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org,
        Arturo Borrero Gonzalez <arturo@netfilter.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:60659 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753017AbdGSNFz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jul 2017 09:05:55 -0400
In-Reply-To: <20170719130529.25398-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This implements testing of 'nft monitor' output correctness and adds a
number of testcases for named sets.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Drop unused chain creation in testcases.
- Add testcase for mappings.
---
 tests/monitor/run-tests.sh             | 78 ++++++++++++++++++++++++++++++++++
 tests/monitor/testcases/set-maps.t     | 11 +++++
 tests/monitor/testcases/set-mixed.t    | 19 +++++++++
 tests/monitor/testcases/set-multiple.t | 13 ++++++
 tests/monitor/testcases/set-simple.t   | 47 ++++++++++++++++++++
 5 files changed, 168 insertions(+)
 create mode 100755 tests/monitor/run-tests.sh
 create mode 100644 tests/monitor/testcases/set-maps.t
 create mode 100644 tests/monitor/testcases/set-mixed.t
 create mode 100644 tests/monitor/testcases/set-multiple.t
 create mode 100644 tests/monitor/testcases/set-simple.t

diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
new file mode 100755
index 0000000000000..7447adf1febd6
--- /dev/null
+++ b/tests/monitor/run-tests.sh
@@ -0,0 +1,78 @@
+#!/bin/bash
+
+cd $(dirname $0)
+
+testdir=$(mktemp -d)
+if [ ! -d $testdir ]; then
+	echo "Failed to create test directory" >&2
+	exit 0
+fi
+trap "rm -rf $testdir" EXIT
+
+nft=../../src/nft
+command_file=$(mktemp -p $testdir)
+output_file=$(mktemp -p $testdir)
+
+cmd_append() {
+	echo "$*" >>$command_file
+}
+output_append() {
+	echo "$*" >>$output_file
+}
+run_test() {
+	monitor_output=$(mktemp -p $testdir)
+	$nft monitor >$monitor_output &
+	monitor_pid=$!
+
+	sleep 0.5
+
+	$nft -f $command_file || {
+		echo "nft command failed!"
+		kill $monitor_pid
+		wait >/dev/null 2>&1
+		exit 1
+	}
+	sleep 0.5
+	kill $monitor_pid
+	wait >/dev/null 2>&1
+	if ! diff -Z -q $monitor_output $output_file >/dev/null 2>&1; then
+		echo "monitor output differs!"
+		diff -Z -u $output_file $monitor_output
+		exit 1
+	fi
+	rm $command_file
+	rm $output_file
+	touch $command_file
+	touch $output_file
+}
+
+for testcase in testcases/*.t; do
+	echo "running tests from file $(basename $testcase)"
+	# files are like this:
+	#
+	# I add table ip t
+	# O add table ip t
+	# I add chain ip t c
+	# O add chain ip t c
+
+	$nft flush ruleset
+
+	input_complete=false
+	while read dir line; do
+		case $dir in
+		I)
+			$input_complete && run_test
+			input_complete=false
+			cmd_append "$line"
+			;;
+		O)
+			input_complete=true
+			output_append "$line"
+			;;
+		'#'|'')
+			# ignore comments and empty lines
+			;;
+		esac
+	done <$testcase
+	$input_complete && run_test
+done
diff --git a/tests/monitor/testcases/set-maps.t b/tests/monitor/testcases/set-maps.t
new file mode 100644
index 0000000000000..d94016beb0767
--- /dev/null
+++ b/tests/monitor/testcases/set-maps.t
@@ -0,0 +1,11 @@
+# first the setup
+I add table ip t
+O add table ip t
+I add map ip t portip { type inet_service: ipv4_addr; flags interval; }
+O add map ip t portip { type inet_service : ipv4_addr;flags interval }
+
+I add element ip t portip { 80-100: 10.0.0.1 }
+O add element ip t portip { 80-100 : 10.0.0.1 }
+
+I add element ip t portip { 1024-65535: 10.0.0.1 }
+O add element ip t portip { 1024-65535 : 10.0.0.1 }
diff --git a/tests/monitor/testcases/set-mixed.t b/tests/monitor/testcases/set-mixed.t
new file mode 100644
index 0000000000000..c4699edacec11
--- /dev/null
+++ b/tests/monitor/testcases/set-mixed.t
@@ -0,0 +1,19 @@
+# first the setup
+I add table ip t
+O add table ip t
+I add set ip t portrange { type inet_service; flags interval; }
+O add set ip t portrange { type inet_service;flags interval }
+I add set ip t ports { type inet_service; }
+O add set ip t ports { type inet_service;}
+
+# make sure concurrent adds work
+I add element ip t portrange { 1024-65535 }
+I add element ip t ports { 10 }
+O add element ip t portrange { 1024-65535 }
+O add element ip t ports { 10 }
+
+# delete items again
+I delete element ip t portrange { 1024-65535 }
+I delete element ip t ports { 10 }
+O delete element ip t portrange { 1024-65535 }
+O delete element ip t ports { 10 }
diff --git a/tests/monitor/testcases/set-multiple.t b/tests/monitor/testcases/set-multiple.t
new file mode 100644
index 0000000000000..d94f941b39693
--- /dev/null
+++ b/tests/monitor/testcases/set-multiple.t
@@ -0,0 +1,13 @@
+# first the setup
+I add table ip t
+O add table ip t
+I add set ip t portrange { type inet_service; flags interval; }
+O add set ip t portrange { type inet_service;flags interval }
+I add set ip t portrange2 { type inet_service; flags interval; }
+O add set ip t portrange2 { type inet_service;flags interval }
+
+# make sure concurrent adds work
+I add element ip t portrange { 1024-65535 }
+I add element ip t portrange2 { 10-20 }
+O add element ip t portrange { 1024-65535 }
+O add element ip t portrange2 { 10-20 }
diff --git a/tests/monitor/testcases/set-simple.t b/tests/monitor/testcases/set-simple.t
new file mode 100644
index 0000000000000..22f648dbfa232
--- /dev/null
+++ b/tests/monitor/testcases/set-simple.t
@@ -0,0 +1,47 @@
+# first the setup
+I add table ip t
+O add table ip t
+I add set ip t portrange { type inet_service; flags interval; }
+O add set ip t portrange { type inet_service;flags interval }
+
+# adding some ranges
+I add element ip t portrange { 1-10 }
+O add element ip t portrange { 1-10 }
+I add element ip t portrange { 1024-65535 }
+O add element ip t portrange { 1024-65535 }
+I add element ip t portrange { 20-30, 40-50 }
+O add element ip t portrange { 20-30 }
+O add element ip t portrange { 40-50 }
+
+# test flushing -> elements are removed in reverse
+I flush set ip t portrange
+O delete element ip t portrange { 1024-65535 }
+O delete element ip t portrange { 40-50 }
+O delete element ip t portrange { 20-30 }
+O delete element ip t portrange { 1-10 }
+
+# make sure lower scope boundary works
+I add element ip t portrange { 0-10 }
+O add element ip t portrange { 0-10 }
+
+# make sure half open before other element works
+I add element ip t portrange { 1024-65535 }
+I add element ip t portrange { 100-200 }
+O add element ip t portrange { 1024-65535 }
+O add element ip t portrange { 100-200 }
+
+# make sure deletion of elements works
+I delete element ip t portrange { 0-10 }
+O delete element ip t portrange { 0-10 }
+I delete element ip t portrange { 100-200 }
+I delete element ip t portrange { 1024-65535 }
+O delete element ip t portrange { 100-200 }
+O delete element ip t portrange { 1024-65535 }
+
+# make sure mixed add/delete works
+I add element ip t portrange { 10-20 }
+I add element ip t portrange { 1024-65535 }
+I delete element ip t portrange { 10-20 }
+O add element ip t portrange { 10-20 }
+O add element ip t portrange { 1024-65535 }
+O delete element ip t portrange { 10-20 }
-- 
2.13.1

