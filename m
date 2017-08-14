From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH 4/4] tests: Merge monitor and echo test suites
Date: Tue, 15 Aug 2017 01:43:05 +0200
Message-ID: <20170814234305.2829-5-phil@nwl.cc>
References: <20170814234305.2829-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:51831 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752651AbdHNXng (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Aug 2017 19:43:36 -0400
In-Reply-To: <20170814234305.2829-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The two test suites were pretty similar already, and since echo output
is supposed to be identical to monitor output apart from delete
commands, they can be merged together with litte effort.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/echo/run-tests.sh          |  45 ----------------
 tests/echo/testcases/simple.t    |  12 -----
 tests/monitor/run-tests.sh       | 107 +++++++++++++++++++++++++++------------
 tests/monitor/testcases/simple.t |  20 ++++++++
 4 files changed, 96 insertions(+), 88 deletions(-)
 delete mode 100755 tests/echo/run-tests.sh
 delete mode 100644 tests/echo/testcases/simple.t
 create mode 100644 tests/monitor/testcases/simple.t

diff --git a/tests/echo/run-tests.sh b/tests/echo/run-tests.sh
deleted file mode 100755
index da7934d16965f..0000000000000
--- a/tests/echo/run-tests.sh
+++ /dev/null
@@ -1,45 +0,0 @@
-#!/bin/bash
-
-cd $(dirname $0)
-nft=../../src/nft
-nft_opts="-nn -a --echo"
-debug=false
-
-debug_echo() {
-	$debug || return
-
-	echo "$@"
-}
-
-trap "$nft flush ruleset" EXIT
-
-for testcase in testcases/*.t; do
-	echo "running tests from file $(basename $testcase)"
-	# files are like this:
-	#
-	# <input command>[;;<output regexp>]
-
-	$nft flush ruleset
-
-	while read line; do
-		[[ -z "$line" || "$line" == "#"* ]] && continue
-
-		# XXX: this only works if there is no semicolon in output
-		input="${line%;;*}"
-		output="${line##*;;}"
-
-		[[ -z $output ]] && output="$input"
-
-		debug_echo "calling '$nft $nft_opts $input'"
-		cmd_out=$($nft $nft_opts $input)
-		# strip trailing whitespace (happens when adding a named set)
-		cmd_out="${cmd_out% }"
-		debug_echo "got output '$cmd_out'"
-		[[ $cmd_out == $output ]] || {
-			echo "Warning: Output differs:"
-			echo "# nft $nft_opts $input"
-			echo "- $output"
-			echo "+ $cmd_out"
-		}
-	done <$testcase
-done
diff --git a/tests/echo/testcases/simple.t b/tests/echo/testcases/simple.t
deleted file mode 100644
index 566fd7e0f8176..0000000000000
--- a/tests/echo/testcases/simple.t
+++ /dev/null
@@ -1,12 +0,0 @@
-add table ip t
-add chain ip t c
-
-# note the added handle output
-add rule ip t c accept;;add rule ip t c accept # handle *
-add rule ip t c tcp dport { 22, 80, 443 } accept;;add rule ip t c tcp dport { 22, 80, 443 } accept # handle *
-
-add set ip t ipset { type ipv4_addr; }
-add element ip t ipset { 192.168.0.1 }
-
-# counter output comes with statistics
-add counter ip t cnt;;add counter ip t cnt *
diff --git a/tests/monitor/run-tests.sh b/tests/monitor/run-tests.sh
index 9fd0e504d08c0..23d4e21288e27 100755
--- a/tests/monitor/run-tests.sh
+++ b/tests/monitor/run-tests.sh
@@ -1,8 +1,9 @@
 #!/bin/bash
 
 cd $(dirname $0)
-
 nft=../../src/nft
+debug=false
+
 mydiff() {
 	diff -w -I '^# ' "$@"
 }
@@ -20,20 +21,38 @@ output_file=$(mktemp -p $testdir)
 cmd_append() {
 	echo "$*" >>$command_file
 }
-output_append() {
+monitor_output_append() {
 	[[ "$*" == '-' ]] && {
 		cat $command_file >>$output_file
 		return
 	}
 	echo "$*" >>$output_file
 }
-run_test() {
+echo_output_append() {
+	# this is a bit tricky: for replace commands, nft prints a delete
+	# command - so in case there is a replace command in $command_file,
+	# just assume any other commands in the same file are sane
+	grep -q '^replace' $command_file >/dev/null 2>&1 && {
+		monitor_output_append "$*"
+		return
+	}
+	[[ "$*" == '-' ]] && {
+		grep '^\(add\|replace\|insert\)' $command_file >>$output_file
+		return
+	}
+	[[ "$*" =~ ^add|replace|insert ]] && echo "$*" >>$output_file
+}
+monitor_run_test() {
 	monitor_output=$(mktemp -p $testdir)
-	$nft monitor >$monitor_output &
+	$nft -nn monitor >$monitor_output &
 	monitor_pid=$!
 
 	sleep 0.5
 
+	$debug && {
+		echo "command file:"
+		cat $command_file
+	}
 	$nft -f $command_file || {
 		echo "nft command failed!"
 		kill $monitor_pid
@@ -54,33 +73,59 @@ run_test() {
 	touch $output_file
 }
 
-for testcase in testcases/*.t; do
-	echo "running tests from file $(basename $testcase)"
-	# files are like this:
-	#
-	# I add table ip t
-	# O add table ip t
-	# I add chain ip t c
-	# O add chain ip t c
+echo_run_test() {
+	echo_output=$(mktemp -p $testdir)
+	$debug && {
+		echo "command file:"
+		cat $command_file
+	}
+	$nft -nn -e -f $command_file >$echo_output || {
+		echo "nft command failed!"
+		exit 1
+	}
+	if ! mydiff -q $echo_output $output_file >/dev/null 2>&1; then
+		echo "echo output differs!"
+		mydiff -u $output_file $echo_output
+		exit 1
+	fi
+	rm $command_file
+	rm $output_file
+	touch $command_file
+	touch $output_file
+}
+
+for variant in monitor echo; do
+	run_test=${variant}_run_test
+	output_append=${variant}_output_append
+
+	for testcase in testcases/*.t; do
+		echo "$variant: running tests from file $(basename $testcase)"
+		# files are like this:
+		#
+		# I add table ip t
+		# O add table ip t
+		# I add chain ip t c
+		# O add chain ip t c
 
-	$nft flush ruleset
+		$nft flush ruleset
 
-	input_complete=false
-	while read dir line; do
-		case $dir in
-		I)
-			$input_complete && run_test
-			input_complete=false
-			cmd_append "$line"
-			;;
-		O)
-			input_complete=true
-			output_append "$line"
-			;;
-		'#'|'')
-			# ignore comments and empty lines
-			;;
-		esac
-	done <$testcase
-	$input_complete && run_test
+		input_complete=false
+		while read dir line; do
+			case $dir in
+			I)
+				$input_complete && $run_test
+				input_complete=false
+				cmd_append "$line"
+				;;
+			O)
+				input_complete=true
+				$output_append "$line"
+				;;
+			'#'|'')
+				# ignore comments and empty lines
+				;;
+			esac
+		done <$testcase
+		$input_complete && $run_test
+	done
 done
diff --git a/tests/monitor/testcases/simple.t b/tests/monitor/testcases/simple.t
new file mode 100644
index 0000000000000..e4dc073e14b65
--- /dev/null
+++ b/tests/monitor/testcases/simple.t
@@ -0,0 +1,20 @@
+# first the setup
+I add table ip t
+I add chain ip t c
+O -
+
+I add rule ip t c accept
+O -
+
+I add rule ip t c tcp dport { 22, 80, 443 } accept
+O -
+
+I insert rule ip t c counter accept
+O add rule ip t c counter packets 0 bytes 0 accept
+
+I replace rule ip t c handle 2 accept comment "foo bar"
+O delete rule ip t c handle 2
+O add rule ip t c accept comment "foo bar"
+
+I add counter ip t cnt
+O add counter ip t cnt { packets 0 bytes 0 }
-- 
2.13.1

