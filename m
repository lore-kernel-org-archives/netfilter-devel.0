Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9E5EC004C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 23 Oct 2023 16:14:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230480AbjJWQOX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 23 Oct 2023 12:14:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjJWQOX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Oct 2023 12:14:23 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94488C1
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 09:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698077618;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=3soh3D7vz2NMcbYnjLKObHZ73nZvCEdl1wN6YThF6W4=;
        b=gjhSehuZSFOOquQXJ84ql+BdwM+xmQYldCjlKWDWXHa1XppiILAsL1R3igql/vStWnR+v2
        2AD4QmiXHXiH+xACohqn47lWWP84EQXGsCmb68bnjnsbIGsgpfXalnIkN4gyocPL6ty34F
        qKVt2IINwq49Sm6Ii1aznnN7lNi2WVs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-520-DmlMWvecMlaQD_6U4vT8-A-1; Mon, 23 Oct 2023 12:13:30 -0400
X-MC-Unique: DmlMWvecMlaQD_6U4vT8-A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3D163185A7A2
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Oct 2023 16:13:30 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.193.226])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B0D99503B;
        Mon, 23 Oct 2023 16:13:29 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 1/2] tests/shell: inline input data in "single_anon_set" test
Date:   Mon, 23 Oct 2023 18:13:15 +0200
Message-ID: <20231023161319.781725-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The file "optimizations/dumps/single_anon_set.nft.input" was laying
around, and it was unclear how it was used.

Let's extend "check-patch.sh" to flag all unused files. But the script
cannot understand how "single_anon_set.nft.input" is used (aside allow
listing it).

Instead, inline the script to keep it inside the test (script).

We still write the data to a separate file and don't use `nft -f -`
(because reading stdin uses a different code path we want to cover).

Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 .../dumps/single_anon_set.nft.input           | 38 ---------------
 .../testcases/optimizations/single_anon_set   | 47 ++++++++++++++++++-
 2 files changed, 45 insertions(+), 40 deletions(-)
 delete mode 100644 tests/shell/testcases/optimizations/dumps/single_anon_set.nft.input

diff --git a/tests/shell/testcases/optimizations/dumps/single_anon_set.nft.input b/tests/shell/testcases/optimizations/dumps/single_anon_set.nft.input
deleted file mode 100644
index ecc5691ba581..000000000000
--- a/tests/shell/testcases/optimizations/dumps/single_anon_set.nft.input
+++ /dev/null
@@ -1,38 +0,0 @@
-table ip test {
-	chain test {
-		# Test cases where anon set can be removed:
-		ip saddr { 127.0.0.1 } accept
-		iif { "lo" } accept
-
-		# negation, can change to != 22.
-		tcp dport != { 22 } drop
-
-		# single prefix, can remove anon set.
-		ip saddr { 127.0.0.0/8 } accept
-
-		# range, can remove anon set.
-		ip saddr { 127.0.0.1-192.168.7.3 } accept
-		tcp sport { 1-1023 } drop
-
-		# Test cases where anon set must be kept.
-
-		# 2 elements, cannot remove the anon set.
-		ip daddr { 192.168.7.1, 192.168.7.5 } accept
-		tcp dport { 80, 443 } accept
-
-		# single element, but concatenation which is not
-		# supported outside of set/map context at this time.
-		ip daddr . tcp dport { 192.168.0.1 . 22 } accept
-
-		# single element, but a map.
-		meta mark set ip daddr map { 192.168.0.1 : 1 }
-
-		# 2 elements.  This could be converted because
-		# ct state cannot be both established and related
-		# at the same time, but this needs extra work.
-		ct state { established, related } accept
-
-		# with stateful statement
-		meta mark { 0x0000000a counter }
-	}
-}
diff --git a/tests/shell/testcases/optimizations/single_anon_set b/tests/shell/testcases/optimizations/single_anon_set
index 7275e3606900..84fc2a7f03a8 100755
--- a/tests/shell/testcases/optimizations/single_anon_set
+++ b/tests/shell/testcases/optimizations/single_anon_set
@@ -2,12 +2,55 @@
 
 set -e
 
+test -d "$NFT_TEST_TESTTMPDIR"
+
 # Input file contains rules with anon sets that contain
 # one element, plus extra rule with two elements (that should be
 # left alone).
 
 # Dump file has the simplified rules where anon sets have been
 # replaced by equality tests where possible.
-dumpfile=$(dirname $0)/dumps/$(basename $0).nft
+file_input1="$NFT_TEST_TESTTMPDIR/input1.nft"
+
+cat <<EOF > "$file_input1"
+table ip test {
+	chain test {
+		# Test cases where anon set can be removed:
+		ip saddr { 127.0.0.1 } accept
+		iif { "lo" } accept
+
+		# negation, can change to != 22.
+		tcp dport != { 22 } drop
+
+		# single prefix, can remove anon set.
+		ip saddr { 127.0.0.0/8 } accept
+
+		# range, can remove anon set.
+		ip saddr { 127.0.0.1-192.168.7.3 } accept
+		tcp sport { 1-1023 } drop
+
+		# Test cases where anon set must be kept.
+
+		# 2 elements, cannot remove the anon set.
+		ip daddr { 192.168.7.1, 192.168.7.5 } accept
+		tcp dport { 80, 443 } accept
+
+		# single element, but concatenation which is not
+		# supported outside of set/map context at this time.
+		ip daddr . tcp dport { 192.168.0.1 . 22 } accept
+
+		# single element, but a map.
+		meta mark set ip daddr map { 192.168.0.1 : 1 }
+
+		# 2 elements.  This could be converted because
+		# ct state cannot be both established and related
+		# at the same time, but this needs extra work.
+		ct state { established, related } accept
+
+		# with stateful statement
+		meta mark { 0x0000000a counter }
+	}
+}
+EOF
 
-$NFT -f "$dumpfile".input
+$NFT -f "$file_input1"
-- 
2.41.0

