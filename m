From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nft] tests: tests to include files
Date: Wed, 10 Aug 2016 20:21:42 +0200
Message-ID: <1470853302-1526-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50518 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933726AbcHJSWD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Aug 2016 14:22:03 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 25CA71DF880
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 20:21:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 16E63FF154
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 20:21:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EC583DA7E5
	for <netfilter-devel@vger.kernel.org>; Wed, 10 Aug 2016 20:21:53 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Four tests to cover file inclusion using:

1) Absolute path.
2) Relative path.
3) Default include directory path.

And one more test to cover endless file inclusion loop.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tests/shell/testcases/include/0001absolute_0    | 29 +++++++++++++++++++++++
 tests/shell/testcases/include/0002relative_0    | 29 +++++++++++++++++++++++
 tests/shell/testcases/include/0003includepath_0 | 31 +++++++++++++++++++++++++
 tests/shell/testcases/include/0004endlessloop_1 | 18 ++++++++++++++
 4 files changed, 107 insertions(+)
 create mode 100755 tests/shell/testcases/include/0001absolute_0
 create mode 100755 tests/shell/testcases/include/0002relative_0
 create mode 100755 tests/shell/testcases/include/0003includepath_0
 create mode 100755 tests/shell/testcases/include/0004endlessloop_1

diff --git a/tests/shell/testcases/include/0001absolute_0 b/tests/shell/testcases/include/0001absolute_0
new file mode 100755
index 0000000..4ad874f
--- /dev/null
+++ b/tests/shell/testcases/include/0001absolute_0
@@ -0,0 +1,29 @@
+#!/bin/bash
+
+set -e
+
+tmpfile1=$(mktemp)
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
+trap "rm -rf $tmpfile1 $tmpfile2" EXIT # cleanup if aborted
+
+RULESET1="add table x"
+RULESET2="include \"$tmpfile1\""
+
+echo "$RULESET1" > $tmpfile1
+echo "$RULESET2" > $tmpfile2
+
+$NFT -f $tmpfile2
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
diff --git a/tests/shell/testcases/include/0002relative_0 b/tests/shell/testcases/include/0002relative_0
new file mode 100755
index 0000000..a91cd8f
--- /dev/null
+++ b/tests/shell/testcases/include/0002relative_0
@@ -0,0 +1,29 @@
+#!/bin/bash
+
+set -e
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
+trap "rm -rf $tmpfile1 $tmpfile2" EXIT # cleanup if aborted
+
+RULESET1="add table x"
+RULESET2="include \"$tmpfile1\""
+
+echo "$RULESET1" > $tmpfile1
+echo "$RULESET2" > $tmpfile2
+
+$NFT -f $tmpfile2
+if [ $? -ne 0 ] ; then
+        echo "E: unable to load good ruleset" >&2
+        exit 1
+fi
diff --git a/tests/shell/testcases/include/0003includepath_0 b/tests/shell/testcases/include/0003includepath_0
new file mode 100755
index 0000000..ba72206
--- /dev/null
+++ b/tests/shell/testcases/include/0003includepath_0
@@ -0,0 +1,31 @@
+#!/bin/bash
+
+set -e
+
+tmpfile1=$(mktemp)
+if [ ! -w $tmpfile1 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+tmpfile3=$(echo "$tmpfile1" | cut -d'/' -f 3)
+
+tmpfile2=$(mktemp)
+if [ ! -w $tmpfile2 ] ; then
+        echo "Failed to create tmp file" >&2
+        exit 0
+fi
+
+trap "rm -rf $tmpfile1 $tmpfile2" EXIT # cleanup if aborted
+
+RULESET1="add table x"
+RULESET2="include \"$tmpfile3\""
+
+echo "$RULESET1" > $tmpfile1
+echo "$RULESET2" > $tmpfile2
+
+$NFT -I /tmp -f $tmpfile2
+if [ $? -ne 0 ] ; then
+	echo "E: unable to load good ruleset" >&2
+	exit 1
+fi
diff --git a/tests/shell/testcases/include/0004endlessloop_1 b/tests/shell/testcases/include/0004endlessloop_1
new file mode 100755
index 0000000..c4aba0c
--- /dev/null
+++ b/tests/shell/testcases/include/0004endlessloop_1
@@ -0,0 +1,18 @@
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
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+RULESET="include \"$tmpfile\""
+
+echo "$RULESET" > $tmpfile
+
+$NFT -f $tmpfile 2>/dev/null
+echo "E: endless include loop" >&2
-- 
2.1.4

