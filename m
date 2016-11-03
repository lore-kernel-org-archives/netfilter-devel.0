From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft PATCH 2/3] tests: shell: introduce the cache testcases
 directory
Date: Thu, 03 Nov 2016 13:04:42 +0100
Message-ID: <147817468263.6881.17616137517734880570.stgit@nfdev2.cica.es>
References: <147817467643.6881.13545899574878544844.stgit@nfdev2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:35059 "EHLO smtp.cica.es"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751136AbcKCMEj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Nov 2016 08:04:39 -0400
Received: from localhost (unknown [127.0.0.1])
        by smtp.cica.es (Postfix) with ESMTP id D29B451F310
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 12:04:35 +0000 (UTC)
Received: from smtp.cica.es ([127.0.0.1])
        by localhost (mail.cica.es [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id svbjzSv-DL7y for <netfilter-devel@vger.kernel.org>;
        Thu,  3 Nov 2016 13:04:30 +0100 (CET)
Received: from nfdev2.cica.es (nfdev2.cica.es [IPv6:2a00:9ac0:c1ca:31::221])
        (Authenticated sender: servers@cica.es)
        by smtp.cica.es (Postfix) with ESMTP id CC7AC51F2A7
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2016 13:04:30 +0100 (CET)
In-Reply-To: <147817467643.6881.13545899574878544844.stgit@nfdev2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Arturo Borrero Gonzalez <arturo@debian.org>

This directory is for testcases related to the nft cache.

Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
---
 tests/shell/testcases/cache/0001_cache_handling_0 |   29 +++++++++++++++++++++
 tests/shell/testcases/sets/cache_handling_0       |   29 ---------------------
 2 files changed, 29 insertions(+), 29 deletions(-)
 create mode 100755 tests/shell/testcases/cache/0001_cache_handling_0
 delete mode 100755 tests/shell/testcases/sets/cache_handling_0

diff --git a/tests/shell/testcases/cache/0001_cache_handling_0 b/tests/shell/testcases/cache/0001_cache_handling_0
new file mode 100755
index 0000000..9a73769
--- /dev/null
+++ b/tests/shell/testcases/cache/0001_cache_handling_0
@@ -0,0 +1,29 @@
+#!/bin/bash
+
+tmpfile=$(mktemp)
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
diff --git a/tests/shell/testcases/sets/cache_handling_0 b/tests/shell/testcases/sets/cache_handling_0
deleted file mode 100755
index 9a73769..0000000
--- a/tests/shell/testcases/sets/cache_handling_0
+++ /dev/null
@@ -1,29 +0,0 @@
-#!/bin/bash
-
-tmpfile=$(mktemp)
-if [ ! -w $tmpfile ] ; then
-	echo "Failed to create tmp file" >&2
-	exit 0
-fi
-
-trap "rm -rf $tmpfile" EXIT # cleanup if aborted
-
-echo "
-table inet test {
-	set test {
-		type ipv4_addr
-		elements = { 1.1.1.1}
-	}
-
-	chain test {
-		ip saddr @test counter accept
-		ip daddr { 2.2.2.2} counter accept
-	}
-}" > $tmpfile
-
-set -e
-
-$NFT -f $tmpfile
-$NFT delete rule inet test test handle 2
-$NFT delete set inet test test
-$NFT -f $tmpfile

