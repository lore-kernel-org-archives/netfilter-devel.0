From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [PATCH 5/5] tests/shell: add test case for cache bug
Date: Fri, 11 Dec 2015 11:10:35 +0100
Message-ID: <144982863572.31246.7502516560404421735.stgit@r2d2.cica.es>
References: <144982857800.31246.3547570276555930070.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:36382 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752999AbbLKKKm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Dec 2015 05:10:42 -0500
In-Reply-To: <144982857800.31246.3547570276555930070.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This testcase for sets catch a cache bug.

By the time of this commit this test is failing, so the test suite shows:

% sudo ./run-tests.sh
I: using nft binary /usr/local/sbin/nft

I: [OK]		./testcases/maps/anonymous_snat_map_0
I: [OK]		./testcases/maps/named_snat_map_0
W: [FAILED]	./testcases/sets/cache_handling_0
I: [OK]		./testcases/optionals/comments_0
I: [OK]		./testcases/optionals/comments_handles_monitor_0
I: [OK]		./testcases/optionals/handles_1
I: [OK]		./testcases/optionals/handles_0
I: [OK]		./testcases/optionals/comments_handles_0

I: results: [OK] 7 [FAILED] 1 [TOTAL] 8

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 tests/shell/testcases/sets/cache_handling_0 |   35 +++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)
 create mode 100755 tests/shell/testcases/sets/cache_handling_0

diff --git a/tests/shell/testcases/sets/cache_handling_0 b/tests/shell/testcases/sets/cache_handling_0
new file mode 100755
index 0000000..c79e013
--- /dev/null
+++ b/tests/shell/testcases/sets/cache_handling_0
@@ -0,0 +1,35 @@
+#!/bin/bash
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
+table inet test {
+	set test {
+		type ipv4_addr
+		elements = { 1.1.1.1}
+	}
+
+	chain test {
+		ip saddr @test counter accept
+		ip daddr { 2.2.2.2} counter accept
+	}
+}" > $tmpfile
+
+set -e
+
+$NFT -f $tmpfile
+$NFT delete rule inet test test handle 2
+$NFT delete set inet test test
+$NFT -f $tmpfile

