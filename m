From: Ismo Puustinen <ismo.puustinen@intel.com>
Subject: [PATCH 3/3] tests: added tests for ordering files in include dirs.
Date: Wed,  7 Jun 2017 11:35:59 +0300
Message-ID: <20170607083559.10051-3-ismo.puustinen@intel.com>
References: <20170607083559.10051-1-ismo.puustinen@intel.com>
Cc: Ismo Puustinen <ismo.puustinen@intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:14579 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751653AbdFGIiL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 7 Jun 2017 04:38:11 -0400
In-Reply-To: <20170607083559.10051-1-ismo.puustinen@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Test that the files are ordered properly by introducing included files
which have internal dependencies.

Signed-off-by: Ismo Puustinen <ismo.puustinen@intel.com>
---
 tests/shell/testcases/include/0011dir_dependency_0 | 48 ++++++++++++++++++++
 tests/shell/testcases/include/0012dir_dependency_1 | 51 ++++++++++++++++++++++
 2 files changed, 99 insertions(+)
 create mode 100755 tests/shell/testcases/include/0011dir_dependency_0
 create mode 100755 tests/shell/testcases/include/0012dir_dependency_1

diff --git a/tests/shell/testcases/include/0011dir_dependency_0 b/tests/shell/testcases/include/0011dir_dependency_0
new file mode 100755
index 0000000..8ee193f
--- /dev/null
+++ b/tests/shell/testcases/include/0011dir_dependency_0
@@ -0,0 +1,48 @@
+#!/bin/bash
+
+set -e
+
+tmpdir=$(mktemp -d)
+if [ ! -d $tmpdir ] ; then
+        echo "Failed to create tmp directory" >&2
+        exit 0
+fi
+
+tmpfile1="$tmpdir/01_file.nft"
+touch $tmpfile1
+if [ ! -w $tmpfile1 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+tmpfile2="$tmpdir/02_file.nft"
+touch $tmpfile2
+if [ ! -w $tmpfile2 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+tmpfile3=$(mktemp)
+if [ ! -w $tmpfile3 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+# cleanup if aborted
+trap "rm -rf $tmpfile1 $tmpfile2 $tmpfile3 && rmdir $tmpdir" EXIT
+
+# add interdependent rulesets
+RULESET1="add table x"
+RULESET2="add chain x y"
+RULESET3="include \"$tmpdir/\""
+
+echo "$RULESET1" > $tmpfile1
+echo "$RULESET2" > $tmpfile2
+echo "$RULESET3" > $tmpfile3
+
+$NFT -f $tmpfile3
+
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
diff --git a/tests/shell/testcases/include/0012dir_dependency_1 b/tests/shell/testcases/include/0012dir_dependency_1
new file mode 100755
index 0000000..bd27e2a
--- /dev/null
+++ b/tests/shell/testcases/include/0012dir_dependency_1
@@ -0,0 +1,51 @@
+#!/bin/bash
+
+set -e
+
+tmpdir=$(mktemp -d)
+if [ ! -d $tmpdir ] ; then
+        echo "Failed to create tmp directory" >&2
+        exit 0
+fi
+
+tmpfile1="$tmpdir/01_file.nft"
+touch $tmpfile1
+if [ ! -w $tmpfile1 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+tmpfile2="$tmpdir/02_file.nft"
+touch $tmpfile2
+if [ ! -w $tmpfile2 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+tmpfile3=$(mktemp)
+if [ ! -w $tmpfile3 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+# cleanup if aborted
+trap "rm -rf $tmpfile1 $tmpfile2 $tmpfile3 && rmdir $tmpdir" EXIT
+
+# add interdependent rulesets
+RULESET1="add table x"
+RULESET2="add chain x y"
+RULESET3="include \"$tmpdir/\""
+
+# Note different order when compared with 0011dir_depencency_0. The idea
+# here is to introduce wrong order to get the loading fail.
+echo "$RULESET1" > $tmpfile2
+echo "$RULESET2" > $tmpfile1
+echo "$RULESET3" > $tmpfile3
+
+$NFT -f $tmpfile3
+
+if [ $? -eq 0 ] ; then
+        echo "E: did not catch wrong file order in include directory" >&2
+        exit 1
+fi
+
-- 
2.9.4

