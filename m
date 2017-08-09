From: Phil Sutter <phil@nwl.cc>
Subject: [nft PATCH v4 3/3] tests: Add a simple test suite for --echo option
Date: Wed,  9 Aug 2017 13:16:43 +0200
Message-ID: <20170809111643.18906-4-phil@nwl.cc>
References: <20170809111643.18906-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:57617 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752396AbdHILQ4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Aug 2017 07:16:56 -0400
In-Reply-To: <20170809111643.18906-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The fancy thing about this is that it uses the actual echo output to
undo the changes to the rule set.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v3:
- Dropped undo logic completely, it is not feasible anymore.
- Changed testcase syntax to accommodate for rules which contain
  semi-colons.
- Call nft with '-nna' flags to avoid translating numbers into names and
  enable handle output for rules.
- Extend simple.t to test named sets as well.
---
 tests/echo/run-tests.sh       | 45 +++++++++++++++++++++++++++++++++++++++++++
 tests/echo/testcases/simple.t | 12 ++++++++++++
 2 files changed, 57 insertions(+)
 create mode 100755 tests/echo/run-tests.sh
 create mode 100644 tests/echo/testcases/simple.t

diff --git a/tests/echo/run-tests.sh b/tests/echo/run-tests.sh
new file mode 100755
index 0000000000000..da7934d16965f
--- /dev/null
+++ b/tests/echo/run-tests.sh
@@ -0,0 +1,45 @@
+#!/bin/bash
+
+cd $(dirname $0)
+nft=../../src/nft
+nft_opts="-nn -a --echo"
+debug=false
+
+debug_echo() {
+	$debug || return
+
+	echo "$@"
+}
+
+trap "$nft flush ruleset" EXIT
+
+for testcase in testcases/*.t; do
+	echo "running tests from file $(basename $testcase)"
+	# files are like this:
+	#
+	# <input command>[;;<output regexp>]
+
+	$nft flush ruleset
+
+	while read line; do
+		[[ -z "$line" || "$line" == "#"* ]] && continue
+
+		# XXX: this only works if there is no semicolon in output
+		input="${line%;;*}"
+		output="${line##*;;}"
+
+		[[ -z $output ]] && output="$input"
+
+		debug_echo "calling '$nft $nft_opts $input'"
+		cmd_out=$($nft $nft_opts $input)
+		# strip trailing whitespace (happens when adding a named set)
+		cmd_out="${cmd_out% }"
+		debug_echo "got output '$cmd_out'"
+		[[ $cmd_out == $output ]] || {
+			echo "Warning: Output differs:"
+			echo "# nft $nft_opts $input"
+			echo "- $output"
+			echo "+ $cmd_out"
+		}
+	done <$testcase
+done
diff --git a/tests/echo/testcases/simple.t b/tests/echo/testcases/simple.t
new file mode 100644
index 0000000000000..566fd7e0f8176
--- /dev/null
+++ b/tests/echo/testcases/simple.t
@@ -0,0 +1,12 @@
+add table ip t
+add chain ip t c
+
+# note the added handle output
+add rule ip t c accept;;add rule ip t c accept # handle *
+add rule ip t c tcp dport { 22, 80, 443 } accept;;add rule ip t c tcp dport { 22, 80, 443 } accept # handle *
+
+add set ip t ipset { type ipv4_addr; }
+add element ip t ipset { 192.168.0.1 }
+
+# counter output comes with statistics
+add counter ip t cnt;;add counter ip t cnt *
-- 
2.13.1

