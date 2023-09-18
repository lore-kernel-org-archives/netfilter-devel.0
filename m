Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DAB48C46CA1
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 10:34:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241479AbjIRKeC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 06:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241129AbjIRKaw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 06:30:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B268CD9
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 03:30:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695033002;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=V93miNxkavBAJ4Yu5rfJ//6VcJcK3fZbOCiKWUuISQI=;
        b=TNSp8zV+dPlEur2f7caSuEavzbYBoShDOqXmsR79R7dowAjG08zjnFqAKxc6vqJi3m5AFa
        Vgu9XBltOdH7h7pICbkr22GdH64WXOo5nbixqsXtFOR9cD8/8EWj1Gi/O6ePF74QI7veNn
        h53m2N0FM5qo8xxWq92l719uPPMmUfs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-382-R1-ZpdRXMXSd-VNuhSvQGA-1; Mon, 18 Sep 2023 06:29:59 -0400
X-MC-Unique: R1-ZpdRXMXSd-VNuhSvQGA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 27BDF185A790;
        Mon, 18 Sep 2023 10:29:59 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2B7B1C15BB8;
        Mon, 18 Sep 2023 10:29:58 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 01/14] tests/shell: add and use chain binding feature probe
Date:   Mon, 18 Sep 2023 12:28:15 +0200
Message-ID: <20230918102947.2125883-2-thaller@redhat.com>
In-Reply-To: <20230918102947.2125883-1-thaller@redhat.com>
References: <20230918102947.2125883-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Alter 30s-stress to suppress anon chains when its unuspported.

Note that 30s-stress is optionally be run standalone, so also update
the test script.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/features/chain_binding.nft        |  7 +++
 .../testcases/cache/0010_implicit_chain_0     |  2 +
 .../testcases/chains/0041chain_binding_0      |  5 ++
 tests/shell/testcases/transactions/30s-stress | 55 ++++++++++++++++---
 4 files changed, 62 insertions(+), 7 deletions(-)
 create mode 100644 tests/shell/features/chain_binding.nft

diff --git a/tests/shell/features/chain_binding.nft b/tests/shell/features/chain_binding.nft
new file mode 100644
index 000000000000..b381ec540fae
--- /dev/null
+++ b/tests/shell/features/chain_binding.nft
@@ -0,0 +1,7 @@
+# d0e2c7de92c7 ("netfilter: nf_tables: add NFT_CHAIN_BINDING")
+# v5.9-rc1~133^2~302^2~1
+table ip t {
+	chain c {
+		jump { counter; }
+	}
+}
diff --git a/tests/shell/testcases/cache/0010_implicit_chain_0 b/tests/shell/testcases/cache/0010_implicit_chain_0
index 0ab0db957cf2..834dc6e4036c 100755
--- a/tests/shell/testcases/cache/0010_implicit_chain_0
+++ b/tests/shell/testcases/cache/0010_implicit_chain_0
@@ -1,5 +1,7 @@
 #!/bin/bash
 
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_chain_binding)
+
 set -e
 
 EXPECTED="table ip f {
diff --git a/tests/shell/testcases/chains/0041chain_binding_0 b/tests/shell/testcases/chains/0041chain_binding_0
index 4b541bb55c30..141a4b6d2c59 100755
--- a/tests/shell/testcases/chains/0041chain_binding_0
+++ b/tests/shell/testcases/chains/0041chain_binding_0
@@ -6,6 +6,11 @@ if [ $? -ne 1 ]; then
 	exit 1
 fi
 
+if [ $NFT_TEST_HAVE_chain_binding = "n" ] ; then
+	echo "Test partially skipped due to NFT_TEST_HAVE_chain_binding=n"
+	exit 77
+fi
+
 set -e
 
 EXPECTED="table inet x {
diff --git a/tests/shell/testcases/transactions/30s-stress b/tests/shell/testcases/transactions/30s-stress
index 4d5d1d8bface..4c3c6a275941 100755
--- a/tests/shell/testcases/transactions/30s-stress
+++ b/tests/shell/testcases/transactions/30s-stress
@@ -27,6 +27,17 @@ if [ "$NFT_TEST_HAS_SOCKET_LIMITS" = y ] ; then
 	exit 77
 fi
 
+if [ -z "${NFT_TEST_HAVE_chain_binding+x}" ] ; then
+	NFT_TEST_HAVE_chain_binding=n
+	mydir="$(dirname "$0")"
+	$NFT --check -f "$mydir/../../features/chain_binding.nft"
+	if [ $? -eq 0 ];then
+		NFT_TEST_HAVE_chain_binding=y
+	else
+		echo "Assuming anonymous chains are not supported"
+	fi
+fi
+
 testns=testns-$(mktemp -u "XXXXXXXX")
 tmp=""
 
@@ -42,8 +53,8 @@ failslab_defaults() {
 	# allow all slabs to fail (if process is tagged).
 	find /sys/kernel/slab/ -wholename '*/kmalloc-[0-9]*/failslab' -type f -exec sh -c 'echo 1 > {}' \;
 
-	# no limit on the number of failures
-	echo -1 > /sys/kernel/debug/failslab/times
+	# no limit on the number of failures, or clause works around old kernels that reject negative integer.
+	echo -1 > /sys/kernel/debug/failslab/times 2>/dev/null || printf '%#x -1' > /sys/kernel/debug/failslab/times
 
 	# Set to 2 for full dmesg traces for each injected error
 	echo 0 > /sys/kernel/debug/failslab/verbose
@@ -102,6 +113,15 @@ nft_with_fault_inject()
 trap cleanup EXIT
 tmp=$(mktemp)
 
+jump_or_goto()
+{
+	if [ $((RANDOM & 1)) -eq 0 ] ;then
+		echo -n "jump"
+	else
+		echo -n "goto"
+	fi
+}
+
 random_verdict()
 {
 	max="$1"
@@ -113,7 +133,8 @@ random_verdict()
 	rnd=$((RANDOM%max))
 
 	if [ $rnd -gt 0 ];then
-		printf "jump chain%03u" "$((rnd+1))"
+		jump_or_goto
+		printf " chain%03u" "$((rnd+1))"
 		return
 	fi
 
@@ -422,6 +443,21 @@ stress_all()
 	randmonitor &
 }
 
+gen_anon_chain_jump()
+{
+	echo -n "insert rule inet $@ "
+	jump_or_goto
+
+	if [ "$NFT_TEST_HAVE_chain_binding" = n ] ; then
+		echo " defaultchain"
+		return
+	fi
+
+	echo -n " { "
+	jump_or_goto
+	echo " defaultchain; counter; }"
+}
+
 gen_ruleset() {
 echo > "$tmp"
 for table in $tables; do
@@ -463,12 +499,13 @@ for table in $tables; do
 	echo "insert rule inet $table $chain ip6 saddr { ::1, dead::beef } counter" comment hash >> "$tmp"
 	echo "insert rule inet $table $chain ip saddr { 1.2.3.4 - 5.6.7.8, 127.0.0.1 } comment rbtree" >> "$tmp"
 	# bitmap 1byte, with anon chain jump
-	echo "insert rule inet $table $chain ip protocol { 6, 17 } jump { jump defaultchain; counter; }" >> "$tmp"
+	gen_anon_chain_jump "$table $chain ip protocol { 6, 17 }" >> "$tmp"
+
 	# bitmap 2byte
 	echo "insert rule inet $table $chain tcp dport != { 22, 23, 80 } goto defaultchain" >> "$tmp"
 	echo "insert rule inet $table $chain tcp dport { 1-1024, 8000-8080 } jump defaultchain comment rbtree" >> "$tmp"
 	# pipapo (concat + set), with goto anonymous chain.
-	echo "insert rule inet $table $chain ip saddr . tcp dport { 1.2.3.4 . 1-1024, 1.2.3.6 - 1.2.3.10 . 8000-8080, 1.2.3.4 . 8080, 1.2.3.6 - 1.2.3.10 . 22 } goto { jump defaultchain; counter; }" >> "$tmp"
+	gen_anon_chain_jump "$table $chain ip saddr . tcp dport { 1.2.3.4 . 1-1024, 1.2.3.6 - 1.2.3.10 . 8000-8080, 1.2.3.4 . 8080, 1.2.3.6 - 1.2.3.10 . 22 }" >> "$tmp"
 
 	# add a few anonymous sets. rhashtable is convered by named sets below.
 	c=$((RANDOM%$count))
@@ -477,12 +514,12 @@ for table in $tables; do
 	echo "insert rule inet $table $chain ip6 saddr { ::1, dead::beef } counter" comment hash >> "$tmp"
 	echo "insert rule inet $table $chain ip saddr { 1.2.3.4 - 5.6.7.8, 127.0.0.1 } comment rbtree" >> "$tmp"
 	# bitmap 1byte, with anon chain jump
-	echo "insert rule inet $table $chain ip protocol { 6, 17 } jump { jump defaultchain; counter; }" >> "$tmp"
+	gen_anon_chain_jump "$table $chain ip protocol { 6, 17 }" >> "$tmp"
 	# bitmap 2byte
 	echo "insert rule inet $table $chain tcp dport != { 22, 23, 80 } goto defaultchain" >> "$tmp"
 	echo "insert rule inet $table $chain tcp dport { 1-1024, 8000-8080 } jump defaultchain comment rbtree" >> "$tmp"
 	# pipapo (concat + set), with goto anonymous chain.
-	echo "insert rule inet $table $chain ip saddr . tcp dport { 1.2.3.4 . 1-1024, 1.2.3.6 - 1.2.3.10 . 8000-8080, 1.2.3.4 . 8080, 1.2.3.6 - 1.2.3.10 . 22 } goto { jump defaultchain; counter; }" >> "$tmp"
+	gen_anon_chain_jump "$table $chain ip saddr . tcp dport { 1.2.3.4 . 1-1024, 1.2.3.6 - 1.2.3.10 . 8000-8080, 1.2.3.4 . 8080, 1.2.3.6 - 1.2.3.10 . 22 }" >> "$tmp"
 
 	# add constant/immutable sets
 	size=$((RANDOM%5120000))
@@ -594,3 +631,7 @@ run_test
 rm -f "$tmp"
 tmp=""
 sleep 4
+
+if [ "$NFT_TEST_HAVE_chain_binding" = n ] ; then
+	echo "Ran a modified version of the test due to NFT_TEST_HAVE_chain_binding=n"
+fi
-- 
2.41.0

