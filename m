From: Shyam Saini <mayhs11saini@gmail.com>
Subject: [PATCH 2/2] tests: shell: Test input descriptors for included files
Date: Fri, 23 Jun 2017 17:35:56 +0530
Message-ID: <1498219556-25179-2-git-send-email-mayhs11saini@gmail.com>
References: <1498219556-25179-1-git-send-email-mayhs11saini@gmail.com>
Cc: Shyam Saini <mayhs11saini@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f66.google.com ([74.125.83.66]:35491 "EHLO
        mail-pg0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753734AbdFWMGn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 23 Jun 2017 08:06:43 -0400
Received: by mail-pg0-f66.google.com with SMTP id f127so5887961pgc.2
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jun 2017 05:06:43 -0700 (PDT)
In-Reply-To: <1498219556-25179-1-git-send-email-mayhs11saini@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Before the [Test] commit, nft error message was pointing to wrong
file.

But after the commit it points to right file.
This commit test the changes made in the [Test] commit.

Test:b14572f72aac (" erec: Fix input descriptors for included files ")
Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
---
 .../include/0013input_descriptors_included_files_0 | 52 ++++++++++++++++++++++
 1 file changed, 52 insertions(+)
 create mode 100755 tests/shell/testcases/include/0013input_descriptors_included_files_0

diff --git a/tests/shell/testcases/include/0013input_descriptors_included_files_0 b/tests/shell/testcases/include/0013input_descriptors_included_files_0
new file mode 100755
index 000000000000..26f43faf3145
--- /dev/null
+++ b/tests/shell/testcases/include/0013input_descriptors_included_files_0
@@ -0,0 +1,52 @@
+#!/bin/bash
+
+# This test the changes made in commit id "b14572f72aac".
+# When the commit was not applied, nft pointed to wrong files name.
+# As the commit only fixes the error messages and hence does not change the
+# return value so, we need to compare the "file name" in the error message
+# instead of return value of nft.
+
+
+tmpfile1=$(mktemp -p .)
+if [ ! -w $tmpfile1 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+tmpfile2=$(mktemp -p .)
+if [ ! -w $tmpfile2 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+tmpfile3=$(mktemp -p .)
+if [ ! -w $tmpfile3 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+tmpfile4=$(mktemp -p .)
+if [ ! -w $tmpfile4 ]; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+trap "rm -rf $tmpfile1 $tmpfile2 $tmpfile3 $tmpfile4" EXIT # cleanup if aborted
+
+RULESET1="include \"$tmpfile2\""
+RULESET2="include \"$tmpfile3\""
+RULESET3="add rule x y anything everything"			# wrong nft syntax
+
+
+echo "$RULESET1" > $tmpfile1
+echo "$RULESET2" >> $tmpfile1
+echo "$RULESET3" > $tmpfile2
+
+$NFT -f $tmpfile1 2> $tmpfile4
+
+var=$(awk -F: '$4==" Error"{print $1;exit;}' $tmpfile4)
+
+if [ $var == "$tmpfile3" ]; then
+	echo "E: Test failed" >&2
+	exit 1
+fi
-- 
1.9.1

