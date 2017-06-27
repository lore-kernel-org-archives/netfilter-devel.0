From: Ismo Puustinen <ismo.puustinen@intel.com>
Subject: [PATCH 2/2] tests: update include directory tests to support wildcard syntax.
Date: Tue, 27 Jun 2017 15:14:59 +0300
Message-ID: <20170627121459.32608-2-ismo.puustinen@intel.com>
References: <20170627121459.32608-1-ismo.puustinen@intel.com>
Cc: Ismo Puustinen <ismo.puustinen@intel.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga04.intel.com ([192.55.52.120]:51620 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751524AbdF0MPF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Jun 2017 08:15:05 -0400
In-Reply-To: <20170627121459.32608-1-ismo.puustinen@intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Ismo Puustinen <ismo.puustinen@intel.com>
---
 .../include/{0005dir_empty_0 => 0005glob_empty_0}  |  4 +-
 .../{0006dir_single_0 => 0006glob_single_0}        |  2 +-
 .../{0007dir_double_0 => 0007glob_double_0}        |  2 +-
 ...08dir_no_slash_1 => 0008glob_nofile_wildcard_0} | 16 ++++---
 .../include/{0009dir_nodir_1 => 0009glob_nofile_1} |  4 +-
 ...010dir_broken_file_1 => 0010glob_broken_file_1} |  4 +-
 ...{0011dir_dependency_0 => 0011glob_dependency_0} |  4 +-
 ...{0012dir_dependency_1 => 0012glob_dependency_1} |  4 +-
 tests/shell/testcases/include/0013glob_dotfile_0   | 49 ++++++++++++++++++++
 tests/shell/testcases/include/0014glob_directory_0 | 43 ++++++++++++++++++
 .../testcases/include/0015doubleincludepath_0      | 52 ++++++++++++++++++++++
 11 files changed, 171 insertions(+), 13 deletions(-)
 rename tests/shell/testcases/include/{0005dir_empty_0 => 0005glob_empty_0} (83%)
 rename tests/shell/testcases/include/{0006dir_single_0 => 0006glob_single_0} (95%)
 rename tests/shell/testcases/include/{0007dir_double_0 => 0007glob_double_0} (96%)
 rename tests/shell/testcases/include/{0008dir_no_slash_1 => 0008glob_nofile_wildcard_0} (53%)
 rename tests/shell/testcases/include/{0009dir_nodir_1 => 0009glob_nofile_1} (81%)
 rename tests/shell/testcases/include/{0010dir_broken_file_1 => 0010glob_broken_file_1} (92%)
 rename tests/shell/testcases/include/{0011dir_dependency_0 => 0011glob_dependency_0} (91%)
 rename tests/shell/testcases/include/{0012dir_dependency_1 => 0012glob_dependency_1} (93%)
 create mode 100755 tests/shell/testcases/include/0013glob_dotfile_0
 create mode 100755 tests/shell/testcases/include/0014glob_directory_0
 create mode 100755 tests/shell/testcases/include/0015doubleincludepath_0

diff --git a/tests/shell/testcases/include/0005dir_empty_0 b/tests/shell/testcases/include/0005glob_empty_0
similarity index 83%
rename from tests/shell/testcases/include/0005dir_empty_0
rename to tests/shell/testcases/include/0005glob_empty_0
index f16acf8..0743d0d 100755
--- a/tests/shell/testcases/include/0005dir_empty_0
+++ b/tests/shell/testcases/include/0005glob_empty_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# Including files in an empty directory must not fail.
+
 set -e
 
 tmpdir=$(mktemp -d)
@@ -17,7 +19,7 @@ fi
 # cleanup if aborted
 trap "rm -rf $tmpfile1 && rmdir $tmpdir" EXIT
 
-RULESET1="include \"$tmpdir/\""
+RULESET1="include \"$tmpdir/*\""
 
 echo "$RULESET1" > $tmpfile1
 
diff --git a/tests/shell/testcases/include/0006dir_single_0 b/tests/shell/testcases/include/0006glob_single_0
similarity index 95%
rename from tests/shell/testcases/include/0006dir_single_0
rename to tests/shell/testcases/include/0006glob_single_0
index ae4fd5f..754db6f 100755
--- a/tests/shell/testcases/include/0006dir_single_0
+++ b/tests/shell/testcases/include/0006glob_single_0
@@ -24,7 +24,7 @@ fi
 trap "rm -rf $tmpfile1 $tmpfile2 && rmdir $tmpdir" EXIT
 
 RULESET1="add table x"
-RULESET2="include \"$tmpdir/\""
+RULESET2="include \"$tmpdir/*\""
 
 echo "$RULESET1" > $tmpfile1
 echo "$RULESET2" > $tmpfile2
diff --git a/tests/shell/testcases/include/0007dir_double_0 b/tests/shell/testcases/include/0007glob_double_0
similarity index 96%
rename from tests/shell/testcases/include/0007dir_double_0
rename to tests/shell/testcases/include/0007glob_double_0
index 0a14ade..9b45a62 100755
--- a/tests/shell/testcases/include/0007dir_double_0
+++ b/tests/shell/testcases/include/0007glob_double_0
@@ -31,7 +31,7 @@ trap "rm -rf $tmpfile1 $tmpfile2 $tmpfile3 && rmdir $tmpdir" EXIT
 
 RULESET1="add table x"
 RULESET2="add table y"
-RULESET3="include \"$tmpdir/\""
+RULESET3="include \"$tmpdir/*\""
 
 echo "$RULESET1" > $tmpfile1
 echo "$RULESET2" > $tmpfile2
diff --git a/tests/shell/testcases/include/0008dir_no_slash_1 b/tests/shell/testcases/include/0008glob_nofile_wildcard_0
similarity index 53%
rename from tests/shell/testcases/include/0008dir_no_slash_1
rename to tests/shell/testcases/include/0008glob_nofile_wildcard_0
index 2820dc9..f9c0aa1 100755
--- a/tests/shell/testcases/include/0008dir_no_slash_1
+++ b/tests/shell/testcases/include/0008glob_nofile_wildcard_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# When using wildcards, not having any match is not an error.
+
 set -e
 
 tmpdir=$(mktemp -d)
@@ -8,22 +10,24 @@ if [ ! -d $tmpdir ] ; then
         exit 0
 fi
 
-tmpfile1=$(mktemp -p $tmpdir)
+# remove the directory
+rmdir $tmpdir
+
+tmpfile1=$(mktemp)
 if [ ! -w $tmpfile1 ] ; then
         echo "Failed to create tmp file" >&2
         exit 0
 fi
 
 # cleanup if aborted
-trap "rm -rf $tmpfile1 && rmdir $tmpdir" EXIT
+trap "rm -rf $tmpfile1" EXIT
 
-RULESET1="include \"$tmpdir\""
+RULESET1="include \"$tmpdir/non_existent_file*.nft\""
 
 echo "$RULESET1" > $tmpfile1
 
 $NFT -f $tmpfile1
-
-if [ $? -eq 0 ] ; then
-        echo "E: did not catch missing slash in directory name" >&2
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
         exit 1
 fi
diff --git a/tests/shell/testcases/include/0009dir_nodir_1 b/tests/shell/testcases/include/0009glob_nofile_1
similarity index 81%
rename from tests/shell/testcases/include/0009dir_nodir_1
rename to tests/shell/testcases/include/0009glob_nofile_1
index d7407f4..bab5830 100755
--- a/tests/shell/testcases/include/0009dir_nodir_1
+++ b/tests/shell/testcases/include/0009glob_nofile_1
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# When not using wildcards, not having any match is an error.
+
 set -e
 
 tmpdir=$(mktemp -d)
@@ -20,7 +22,7 @@ fi
 # cleanup if aborted
 trap "rm -rf $tmpfile1" EXIT
 
-RULESET1="include \"$tmpdir/\""
+RULESET1="include \"$tmpdir/non_existent_file.nft\""
 
 echo "$RULESET1" > $tmpfile1
 
diff --git a/tests/shell/testcases/include/0010dir_broken_file_1 b/tests/shell/testcases/include/0010glob_broken_file_1
similarity index 92%
rename from tests/shell/testcases/include/0010dir_broken_file_1
rename to tests/shell/testcases/include/0010glob_broken_file_1
index c093974..9027f18 100755
--- a/tests/shell/testcases/include/0010dir_broken_file_1
+++ b/tests/shell/testcases/include/0010glob_broken_file_1
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# Loading broken files must fail.
+
 set -e
 
 tmpdir=$(mktemp -d)
@@ -33,7 +35,7 @@ RULESET1="add table x"
 
 # do an error in a file
 RULESET2="intentionally broken file"
-RULESET3="include \"$tmpdir/\""
+RULESET3="include \"$tmpdir/*\""
 
 echo "$RULESET1" > $tmpfile1
 echo "$RULESET2" > $tmpfile2
diff --git a/tests/shell/testcases/include/0011dir_dependency_0 b/tests/shell/testcases/include/0011glob_dependency_0
similarity index 91%
rename from tests/shell/testcases/include/0011dir_dependency_0
rename to tests/shell/testcases/include/0011glob_dependency_0
index 8ee193f..8786850 100755
--- a/tests/shell/testcases/include/0011dir_dependency_0
+++ b/tests/shell/testcases/include/0011glob_dependency_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# Files are included in alphabetical order.
+
 set -e
 
 tmpdir=$(mktemp -d)
@@ -34,7 +36,7 @@ trap "rm -rf $tmpfile1 $tmpfile2 $tmpfile3 && rmdir $tmpdir" EXIT
 # add interdependent rulesets
 RULESET1="add table x"
 RULESET2="add chain x y"
-RULESET3="include \"$tmpdir/\""
+RULESET3="include \"$tmpdir/*\""
 
 echo "$RULESET1" > $tmpfile1
 echo "$RULESET2" > $tmpfile2
diff --git a/tests/shell/testcases/include/0012dir_dependency_1 b/tests/shell/testcases/include/0012glob_dependency_1
similarity index 93%
rename from tests/shell/testcases/include/0012dir_dependency_1
rename to tests/shell/testcases/include/0012glob_dependency_1
index c81ca32..740f5ea 100755
--- a/tests/shell/testcases/include/0012dir_dependency_1
+++ b/tests/shell/testcases/include/0012glob_dependency_1
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# Files are included in alphabetical order.
+
 set -e
 
 tmpdir=$(mktemp -d)
@@ -34,7 +36,7 @@ trap "rm -rf $tmpfile1 $tmpfile2 $tmpfile3 && rmdir $tmpdir" EXIT
 # add interdependent rulesets
 RULESET1="add table x"
 RULESET2="add chain x y"
-RULESET3="include \"$tmpdir/\""
+RULESET3="include \"$tmpdir/*\""
 
 # Note different order when compared with 0011dir_depencency_0. The idea
 # here is to introduce wrong order to get the loading fail.
diff --git a/tests/shell/testcases/include/0013glob_dotfile_0 b/tests/shell/testcases/include/0013glob_dotfile_0
new file mode 100755
index 0000000..36cfe1c
--- /dev/null
+++ b/tests/shell/testcases/include/0013glob_dotfile_0
@@ -0,0 +1,49 @@
+#!/bin/bash
+
+# Must not load a dot file in globbed directory.
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
+tmpfile2=$(mktemp -p $tmpdir ".XXXXXXXX")
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
+# an error in a dot file
+RULESET2="intentionally broken file"
+RULESET3="include \"$tmpdir/*\""
+
+echo "$RULESET1" > $tmpfile1
+echo "$RULESET2" > $tmpfile2
+echo "$RULESET3" > $tmpfile3
+
+$NFT -f $tmpfile3
+
+if [ $? -ne 0 ] ; then
+        echo "E: tried to load a .dot file" >&2
+        exit 1
+fi
diff --git a/tests/shell/testcases/include/0014glob_directory_0 b/tests/shell/testcases/include/0014glob_directory_0
new file mode 100755
index 0000000..9a2443a
--- /dev/null
+++ b/tests/shell/testcases/include/0014glob_directory_0
@@ -0,0 +1,43 @@
+#!/bin/bash
+
+# Must not be confused in matched subdirectories.
+
+set -e
+
+tmpdir1=$(mktemp -d)
+if [ ! -d $tmpdir1 ] ; then
+        echo "Failed to create tmp directory" >&2
+        exit 0
+fi
+
+tmpfile1=$(mktemp -p $tmpdir1)
+if [ ! -w $tmpfile1 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+tmpdir2=$(mktemp -p $tmpdir1 -d)
+if [ ! -w $tmpdir2 ] ; then
+        echo "Failed to create the second tmp directory" >&2
+        exit 0
+fi
+
+tmpdir3=$(mktemp -p $tmpdir2 -d)
+if [ ! -w $tmpdir3 ] ; then
+        echo "Failed to create the third tmp directory" >&2
+        exit 0
+fi
+
+# cleanup if aborted
+trap "rm -rf $tmpfile1 && rmdir $tmpdir3 && rmdir $tmpdir2 && rmdir $tmpdir1" EXIT
+
+RULESET1="include \"$tmpdir2/*\""
+
+echo "$RULESET1" > $tmpfile1
+
+$NFT -f $tmpfile1
+
+if [ $? -ne 0 ] ; then
+        echo "E: tried to include a matched directory" >&2
+        exit 1
+fi
diff --git a/tests/shell/testcases/include/0015doubleincludepath_0 b/tests/shell/testcases/include/0015doubleincludepath_0
new file mode 100755
index 0000000..db70346
--- /dev/null
+++ b/tests/shell/testcases/include/0015doubleincludepath_0
@@ -0,0 +1,52 @@
+#!/bin/bash
+
+set -e
+
+tmpfile=$(mktemp)
+if [ ! -w $tmpfile ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+tmpdir1=$(mktemp -d)
+if [ ! -d $tmpdir1 ] ; then
+        echo "Failed to create tmp directory" >&2
+        exit 0
+fi
+
+tmpdir2=$(mktemp -d)
+if [ ! -d $tmpdir2 ] ; then
+        echo "Failed to create tmp directory" >&2
+        exit 0
+fi
+
+tmpfile1=$(mktemp -p $tmpdir1)
+if [ ! -w $tmpfile1 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+tmpfile2=$(mktemp -p $tmpdir2)
+if [ ! -w $tmpfile2 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+trap "rm -rf $tmpdfile $tmpfile1 $tmpfile2 && rmdir $tmpdir1 && rmdir $tmpdir2" EXIT # cleanup if aborted
+
+RULESET1="add table x"
+RULESET2="add chain x y"
+RULESET3=" \
+include \"$(basename $tmpfile1)\"
+include \"$(basename $tmpfile2)\"
+"
+
+echo "$RULESET1" > $tmpfile1
+echo "$RULESET2" > $tmpfile2
+echo "$RULESET3" > $tmpfile
+
+$NFT -I $tmpdir1 -I $tmpdir2 -f $tmpfile
+if [ $? -ne 0 ] ; then
+	echo "E: unable to load good ruleset" >&2
+	exit 1
+fi
-- 
2.9.4

