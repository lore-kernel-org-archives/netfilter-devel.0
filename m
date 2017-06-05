From: Ismo Puustinen <ismo.puustinen@intel.com>
Subject: [PATCH v2 2/2] tests: test include directories
Date: Mon,  5 Jun 2017 18:12:33 +0300
Message-ID: <20170605151233.1689-2-ismo.puustinen@intel.com>
References: <20170605151233.1689-1-ismo.puustinen@intel.com>
Cc: Ismo Puustinen <ismo.puustinen@intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:41403 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751322AbdFEPMj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Jun 2017 11:12:39 -0400
In-Reply-To: <20170605151233.1689-1-ismo.puustinen@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add tests for:
  * including an empty directory
  * including directory with one or two files in it
  * testing for required trailing slash in directory name
  * testing for detecting non-existent directory
  * testing for a broken file in included directory

Signed-off-by: Ismo Puustinen <ismo.puustinen@intel.com>
---
 tests/shell/testcases/include/0005dir_empty_0      | 29 +++++++++++++
 tests/shell/testcases/include/0006dir_single_0     | 36 +++++++++++++++++
 tests/shell/testcases/include/0007dir_double_0     | 45 +++++++++++++++++++++
 tests/shell/testcases/include/0008dir_no_slash_1   | 29 +++++++++++++
 tests/shell/testcases/include/0009dir_nodir_1      | 31 ++++++++++++++
 .../shell/testcases/include/0010dir_broken_file_1  | 47 ++++++++++++++++++++++
 6 files changed, 217 insertions(+)
 create mode 100755 tests/shell/testcases/include/0005dir_empty_0
 create mode 100755 tests/shell/testcases/include/0006dir_single_0
 create mode 100755 tests/shell/testcases/include/0007dir_double_0
 create mode 100755 tests/shell/testcases/include/0008dir_no_slash_1
 create mode 100755 tests/shell/testcases/include/0009dir_nodir_1
 create mode 100755 tests/shell/testcases/include/0010dir_broken_file_1

diff --git a/tests/shell/testcases/include/0005dir_empty_0 b/tests/shell/testcases/include/0005dir_empty_0
new file mode 100755
index 0000000..f16acf8
--- /dev/null
+++ b/tests/shell/testcases/include/0005dir_empty_0
@@ -0,0 +1,29 @@
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
+tmpfile1=$(mktemp)
+if [ ! -w $tmpfile1 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+# cleanup if aborted
+trap "rm -rf $tmpfile1 && rmdir $tmpdir" EXIT
+
+RULESET1="include \"$tmpdir/\""
+
+echo "$RULESET1" > $tmpfile1
+
+$NFT -f $tmpfile1
+
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
diff --git a/tests/shell/testcases/include/0006dir_single_0 b/tests/shell/testcases/include/0006dir_single_0
new file mode 100755
index 0000000..ae4fd5f
--- /dev/null
+++ b/tests/shell/testcases/include/0006dir_single_0
@@ -0,0 +1,36 @@
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
+tmpfile1=$(mktemp -p $tmpdir)
+if [ ! -w $tmpfile1 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+tmpfile2=$(mktemp)
+if [ ! -w $tmpfile2 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+# cleanup if aborted
+trap "rm -rf $tmpfile1 $tmpfile2 && rmdir $tmpdir" EXIT
+
+RULESET1="add table x"
+RULESET2="include \"$tmpdir/\""
+
+echo "$RULESET1" > $tmpfile1
+echo "$RULESET2" > $tmpfile2
+
+$NFT -f $tmpfile2
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
diff --git a/tests/shell/testcases/include/0007dir_double_0 b/tests/shell/testcases/include/0007dir_double_0
new file mode 100755
index 0000000..0a14ade
--- /dev/null
+++ b/tests/shell/testcases/include/0007dir_double_0
@@ -0,0 +1,45 @@
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
+tmpfile1=$(mktemp -p $tmpdir)
+if [ ! -w $tmpfile1 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+tmpfile2=$(mktemp -p $tmpdir)
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
+RULESET1="add table x"
+RULESET2="add table y"
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
diff --git a/tests/shell/testcases/include/0008dir_no_slash_1 b/tests/shell/testcases/include/0008dir_no_slash_1
new file mode 100755
index 0000000..2820dc9
--- /dev/null
+++ b/tests/shell/testcases/include/0008dir_no_slash_1
@@ -0,0 +1,29 @@
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
+tmpfile1=$(mktemp -p $tmpdir)
+if [ ! -w $tmpfile1 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+# cleanup if aborted
+trap "rm -rf $tmpfile1 && rmdir $tmpdir" EXIT
+
+RULESET1="include \"$tmpdir\""
+
+echo "$RULESET1" > $tmpfile1
+
+$NFT -f $tmpfile1
+
+if [ $? -eq 0 ] ; then
+        echo "E: did not catch missing slash in directory name" >&2
+        exit 1
+fi
diff --git a/tests/shell/testcases/include/0009dir_nodir_1 b/tests/shell/testcases/include/0009dir_nodir_1
new file mode 100755
index 0000000..d7407f4
--- /dev/null
+++ b/tests/shell/testcases/include/0009dir_nodir_1
@@ -0,0 +1,31 @@
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
+# remove the directory
+rmdir $tmpdir
+
+tmpfile1=$(mktemp)
+if [ ! -w $tmpfile1 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+# cleanup if aborted
+trap "rm -rf $tmpfile1" EXIT
+
+RULESET1="include \"$tmpdir/\""
+
+echo "$RULESET1" > $tmpfile1
+
+$NFT -f $tmpfile1
+if [ $? -eq 0 ] ; then
+        echo "E: Failed to catch a missing include directory/file" >&2
+        exit 1
+fi
diff --git a/tests/shell/testcases/include/0010dir_broken_file_1 b/tests/shell/testcases/include/0010dir_broken_file_1
new file mode 100755
index 0000000..c093974
--- /dev/null
+++ b/tests/shell/testcases/include/0010dir_broken_file_1
@@ -0,0 +1,47 @@
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
+tmpfile1=$(mktemp -p $tmpdir)
+if [ ! -w $tmpfile1 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+tmpfile2=$(mktemp -p $tmpdir)
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
+RULESET1="add table x"
+
+# do an error in a file
+RULESET2="intentionally broken file"
+RULESET3="include \"$tmpdir/\""
+
+echo "$RULESET1" > $tmpfile1
+echo "$RULESET2" > $tmpfile2
+echo "$RULESET3" > $tmpfile3
+
+$NFT -f $tmpfile3
+
+if [ $? -eq 0 ] ; then
+        echo "E: didn't catch a broken file in directory" >&2
+        exit 1
+fi
-- 
2.9.4

