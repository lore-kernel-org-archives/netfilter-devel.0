Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57163CD3421
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Sep 2023 10:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241025AbjIRKbZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Sep 2023 06:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241243AbjIRKa5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2023 06:30:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32ED3DB
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Sep 2023 03:30:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695033003;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9NKRNG+ZmKftOOxhCbQGEUbwAIHLxT2y7QYSGpJaPpI=;
        b=JjtYxuxvh06456L47JIO155WNWDBJi4eOkovCMrrWfeRNq4xQCCF1fTEbmGQXkOSf4iwLq
        k5+uIg2CeT2af2yu34a9HDA/n7IMGn+b/sHiY8ARVh8QtVStlfi+lvna9OGJqoROPQJG7u
        5XWKmHOuXU0iMfhg3L0s3qezV/KaSbc=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-279-WJ0xwMMoOH6dYkRphnVHWw-1; Mon, 18 Sep 2023 06:30:01 -0400
X-MC-Unique: WJ0xwMMoOH6dYkRphnVHWw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id EADE929AA3B0;
        Mon, 18 Sep 2023 10:30:00 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.39.192.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4A855C15BB8;
        Mon, 18 Sep 2023 10:30:00 +0000 (UTC)
From:   Thomas Haller <thaller@redhat.com>
To:     NetFilter <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Thomas Haller <thaller@redhat.com>
Subject: [PATCH nft 03/14] tests/shell: skip map query if kernel lacks support
Date:   Mon, 18 Sep 2023 12:28:17 +0200
Message-ID: <20230918102947.2125883-4-thaller@redhat.com>
In-Reply-To: <20230918102947.2125883-1-thaller@redhat.com>
References: <20230918102947.2125883-1-thaller@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

On recent kernels one can perform a lookup in a map without a destination
register (i.e., treat the map like a set -- pure existence check).

Add a feature probe and work around the missing feature in
typeof_maps_add_delete: do the test with a simplified ruleset,

Indicate skipped even though a reduced test was run (earlier errors
cause a failure) to not trigger dump validation error.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Thomas Haller <thaller@redhat.com>
---
 tests/shell/features/map_lookup.nft           | 11 ++++++
 .../testcases/maps/typeof_maps_add_delete     | 35 ++++++++++++++-----
 2 files changed, 38 insertions(+), 8 deletions(-)
 create mode 100644 tests/shell/features/map_lookup.nft

diff --git a/tests/shell/features/map_lookup.nft b/tests/shell/features/map_lookup.nft
new file mode 100644
index 000000000000..06c4c9d9c82d
--- /dev/null
+++ b/tests/shell/features/map_lookup.nft
@@ -0,0 +1,11 @@
+# a4878eeae390 ("netfilter: nf_tables: relax set/map validation checks")
+# v6.5-rc1~163^2~256^2~8
+table ip t {
+        map m {
+                typeof ip daddr : meta mark
+        }
+
+        chain c {
+                ip saddr @m
+        }
+}
diff --git a/tests/shell/testcases/maps/typeof_maps_add_delete b/tests/shell/testcases/maps/typeof_maps_add_delete
index 341de538e90e..5e2f8ecc473f 100755
--- a/tests/shell/testcases/maps/typeof_maps_add_delete
+++ b/tests/shell/testcases/maps/typeof_maps_add_delete
@@ -1,6 +1,15 @@
 #!/bin/bash
 
-EXPECTED='table ip dynset {
+CONDMATCH="ip saddr @dynmark"
+NCONDMATCH="ip saddr != @dynmark"
+
+# use reduced feature set
+if [ "$NFT_TEST_HAVE_map_lookup" = n ] ; then
+	CONDMATCH=""
+	NCONDMATCH=""
+fi
+
+EXPECTED="table ip dynset {
 	map dynmark {
 		typeof ip daddr : meta mark
 		counter
@@ -9,20 +18,20 @@ EXPECTED='table ip dynset {
 	}
 
 	chain test_ping {
-		ip saddr @dynmark counter comment "should not increment"
-		ip saddr != @dynmark add @dynmark { ip saddr : 0x1 } counter
-		ip saddr @dynmark counter comment "should increment"
-		ip saddr @dynmark delete @dynmark { ip saddr : 0x1 }
-		ip saddr @dynmark counter comment "delete should be instant but might fail under memory pressure"
+		$CONDMATCH counter comment \"should not increment\"
+		$NCONDMATCH add @dynmark { ip saddr : 0x1 } counter
+		$CONDMATCH counter comment \"should increment\"
+		$CONDMATCH delete @dynmark { ip saddr : 0x1 }
+		$CONDMATCH counter comment \"delete should be instant but might fail under memory pressure\"
 	}
 
 	chain input {
 		type filter hook input priority 0; policy accept;
 
-		add @dynmark { 10.2.3.4 timeout 1s : 0x2 } comment "also check timeout-gc"
+		add @dynmark { 10.2.3.4 timeout 1s : 0x2 } comment \"also check timeout-gc\"
 		meta l4proto icmp ip daddr 127.0.0.42 jump test_ping
 	}
-}'
+}"
 
 set -e
 $NFT -f - <<< $EXPECTED
@@ -31,5 +40,15 @@ $NFT list ruleset
 ip link set lo up
 ping -c 1 127.0.0.42
 
+$NFT get element ip dynset dynmark { 10.2.3.4 }
+
 # wait so that 10.2.3.4 times out.
 sleep 2
+
+set +e
+$NFT get element ip dynset dynmark { 10.2.3.4 } && exit 1
+
+if [ "$NFT_TEST_HAVE_map_lookup" = n ] ; then
+	echo "Only tested a subset due to NFT_TEST_HAVE_map_lookup=n. Skipped."
+	exit 77
+fi
-- 
2.41.0

