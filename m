From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH RFC v2 4/4] tests: Add a simple test suite for --echo option
Date: Thu, 27 Jul 2017 18:21:44 +0200
Message-ID: <20170727162144.28703-5-phil@nwl.cc>
References: <20170727162144.28703-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:43969 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751554AbdG0QWP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 27 Jul 2017 12:22:15 -0400
In-Reply-To: <20170727162144.28703-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The fancy thing about this is that it uses the actual echo output to
undo the changes to the rule set.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 tests/echo/run-tests.sh       | 53 +++++++++++++++++++++++++++++++++++++++++++
 tests/echo/testcases/simple.t |  8 +++++++
 2 files changed, 61 insertions(+)
 create mode 100755 tests/echo/run-tests.sh
 create mode 100644 tests/echo/testcases/simple.t

diff --git a/tests/echo/run-tests.sh b/tests/echo/run-tests.sh
new file mode 100755
index 0000000000000..c10eb47b0d1bb
--- /dev/null
+++ b/tests/echo/run-tests.sh
@@ -0,0 +1,53 @@
+#!/bin/bash
+
+cd $(dirname $0)
+nft=../../src/nft
+debug=false
+
+debug_echo() {
+	$debug || return
+
+	echo "$@"
+}
+
+undo_file=$(mktemp)
+
+undo() {
+	[[ -f $undo_file ]] || return
+	tac $undo_file | while read line; do
+		debug_echo "undo: '$nft delete $line'"
+		$nft delete $line || {
+			echo "Warning: undo failed for line '$line'"
+		}
+	done
+	rm $undo_file
+}
+
+trap undo EXIT
+
+for testcase in testcases/*.t; do
+	echo "running tests from file $(basename $testcase)"
+	# files are like this:
+	#
+	# <input command>;<output regexp>
+
+	while read line; do
+		[[ -z "$line" || "$line" == "#"* ]] && continue
+
+		# XXX: this only works if there is no semicolon in output
+		input="${line%;*}"
+		output="${line##*;}"
+
+		debug_echo "calling '$nft --echo $input'"
+		cmd_out=$($nft --echo $input)
+		debug_echo "got output '$cmd_out'"
+		[[ $cmd_out == $output ]] || {
+			echo "Warning: Output differs:"
+			echo "# nft --echo $input"
+			echo "- $output"
+			echo "+ $cmd_out"
+		}
+		echo "$cmd_out" >> $undo_file
+	done <$testcase
+	undo
+done
diff --git a/tests/echo/testcases/simple.t b/tests/echo/testcases/simple.t
new file mode 100644
index 0000000000000..bf8857dc5e858
--- /dev/null
+++ b/tests/echo/testcases/simple.t
@@ -0,0 +1,8 @@
+add table ip t;table ip t
+add chain ip t c;chain ip t c
+add rule ip t c accept;rule ip t c handle *
+
+add set ip t ipset {type ipv4_addr; };set ip t ipset
+add element ip t ipset { 192.168.0.1 };element ip t ipset { 192.168.0.1 }
+
+add counter ip t cnt;counter ip t cnt
-- 
2.13.1

