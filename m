Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EDB64CD37B0
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 10:31:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239700AbjIRKbW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 06:31:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240944AbjIRKav (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 06:30:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9FE109
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 03:30:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695033006;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IXvyT3IZWtfWmeeJYU1wyD0nzlAB24NdUbTo7qEApKQ=;
        b=MkbHpAQcNlRdnWMMifMeRudDuDs0UHgChNdssxrWHeHDRghhmtmh5f6z8hW9A9q9Sczeu/
        C1AIOKooY0n/UxgZAgVgDYMz4MXscBxbthd0R2Ld6ucnyOfZclTl1q7zvnFoVSpKp1HGio
        Ac+iHq1AQ8zMXd1qMoBE1Sb7YPmtark=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-k8ev3CszMZ6p2MbWMMYWuA-1; Mon, 18 Sep 2023 06:30:04 -0400
X-MC-Unique: k8ev3CszMZ6p2MbWMMYWuA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8AB5C811E7B;
        Mon, 18 Sep 2023 10:30:04 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DED05C15BB8;
        Mon, 18 Sep 2023 10:30:03 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 07/14] tests/shell: skip inet ingress tests if kernel lacks support
Date:   Mon, 18 Sep 2023 12:28:21 +0200
Message-ID: <20230918102947.2125883-8-thaller@redhat.com>
In-Reply-To: <20230918102947.2125883-1-thaller@redhat.com>
References: <20230918102947.2125883-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Split the bridge autoremove test to a new file.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/features/inet_ingress.nft                    | 7 +++++++
 tests/shell/testcases/chains/0043chain_ingress_0         | 9 ++-------
 .../testcases/chains/dumps/netdev_chain_autoremove.nft   | 0
 tests/shell/testcases/chains/netdev_chain_autoremove     | 9 +++++++++
 4 files changed, 18 insertions(+), 7 deletions(-)
 create mode 100644 tests/shell/features/inet_ingress.nft
 create mode 100644 tests/shell/testcases/chains/dumps/netdev_chain_autoremove.nft
 create mode 100755 tests/shell/testcases/chains/netdev_chain_autoremove

diff --git a/tests/shell/features/inet_ingress.nft b/tests/shell/features/inet_ingress.nft
new file mode 100644
index 000000000000..944a5c77d27b
--- /dev/null
+++ b/tests/shell/features/inet_ingress.nft
@@ -0,0 +1,7 @@
+# d3519cb89f6d ("netfilter: nf_tables: add inet ingress support")
+# v5.10-rc1~107^2~17^2~1
+table inet t {
+        chain c {
+                type filter hook ingress device "lo" priority filter; policy accept;
+        }
+}
diff --git a/tests/shell/testcases/chains/0043chain_ingress_0 b/tests/shell/testcases/chains/0043chain_ingress_0
index bff464687a6f..a6973b99e514 100755
--- a/tests/shell/testcases/chains/0043chain_ingress_0
+++ b/tests/shell/testcases/chains/0043chain_ingress_0
@@ -1,7 +1,8 @@
 #!/bin/bash
 
-set -e
+# NFT_TEST_REQUIRES(NFT_TEST_HAVE_inet_ingress)
 
+set -e
 RULESET="table inet filter {
 	chain ingress {
 		type filter hook ingress device \"lo\" priority filter; policy accept;
@@ -14,11 +15,5 @@ RULESET="table inet filter {
 	}
 }"
 
-# Test auto-removal of chain hook on netns removal
-unshare -n bash -c "ip link add br0 type bridge; \
- $NFT add table netdev test; \
- $NFT add chain netdev test ingress { type filter hook ingress device \"br0\" priority 0\; policy drop\; } ; \
-" || exit 1
-
 $NFT -f - <<< "$RULESET" && exit 0
 exit 1
diff --git a/tests/shell/testcases/chains/dumps/netdev_chain_autoremove.nft b/tests/shell/testcases/chains/dumps/netdev_chain_autoremove.nft
new file mode 100644
index 000000000000..e69de29bb2d1
diff --git a/tests/shell/testcases/chains/netdev_chain_autoremove b/tests/shell/testcases/chains/netdev_chain_autoremove
new file mode 100755
index 000000000000..21f3ad2966cb
--- /dev/null
+++ b/tests/shell/testcases/chains/netdev_chain_autoremove
@@ -0,0 +1,9 @@
+#!/bin/bash
+
+set -e
+
+# Test auto-removal of chain hook on netns removal
+unshare -n bash -e -c "ip link add br0 type bridge; \
+ $NFT add table netdev test; \
+ $NFT add chain netdev test ingress { type filter hook ingress device \"br0\" priority 0\; policy drop\; } ; \
+"
-- 
2.41.0

