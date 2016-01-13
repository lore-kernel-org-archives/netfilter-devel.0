From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH] tests/shell: add first `nft -f' tests
Date: Wed, 13 Jan 2016 19:25:46 +0100
Message-ID: <145270953832.16020.12195858279695519271.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:50112 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755975AbcAMSZz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2016 13:25:55 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch add some basic initial tests.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/shell/testcases/nft-f/0001define_slash_0 |   25 ++++++++++++++++++++++++
 1 file changed, 25 insertions(+)
 create mode 100755 tests/shell/testcases/nft-f/0001define_slash_0

diff --git a/tests/shell/testcases/nft-f/0001define_slash_0 b/tests/shell/testcases/nft-f/0001define_slash_0
new file mode 100755
index 0000000..4ce7089
--- /dev/null
+++ b/tests/shell/testcases/nft-f/0001define_slash_0
@@ -0,0 +1,25 @@
+#!/bin/bash
+
+# tests for commit 85d6803 (parser_bison: initializer_expr must use rhs_expr)
+
+MKTEMP=$(which mktemp)
+if [ -x $MKTEMP ] ; then
+	tmpfile=$(${MKTEMP})
+else
+	tmpfile=$(/tmp/${RANDOM})
+fi
+
+if [ ! -w $tmpfile ] ; then
+	echo "Failed to create tmp file" >&2
+	exit 0
+fi
+
+trap "rm -rf $tmpfile" EXIT # cleanup if aborted
+
+echo "
+define net = 1.1.1.1/24
+" > $tmpfile
+
+set -e
+
+$NFT -f $tmpfile

