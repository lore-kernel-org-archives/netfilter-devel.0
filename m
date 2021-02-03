Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98DE6C433DB
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Feb 2021 16:59:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 565FB64E46
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Feb 2021 16:59:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhBCQ6r (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Feb 2021 11:58:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231759AbhBCQ6B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Feb 2021 11:58:01 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D27C0613ED
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Feb 2021 08:57:21 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1l7LSy-0005LS-D6; Wed, 03 Feb 2021 17:57:20 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nft 1/3] tests: extend dtype test case to cover expression with integer type
Date:   Wed,  3 Feb 2021 17:57:05 +0100
Message-Id: <20210203165707.21781-3-fw@strlen.de>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210203165707.21781-1-fw@strlen.de>
References: <20210203165707.21781-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

... nft doesn't handle this correctly at the moment: they are added
as netowkr byte order (invalid byte order).

ct zone has integer_type, the byte order has to be taken from the expression.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 .../testcases/sets/0029named_ifname_dtype_0   | 41 +++++++++++++++++
 .../sets/dumps/0029named_ifname_dtype_0.nft   | 44 ++++++++++++++++++-
 2 files changed, 83 insertions(+), 2 deletions(-)

diff --git a/tests/shell/testcases/sets/0029named_ifname_dtype_0 b/tests/shell/testcases/sets/0029named_ifname_dtype_0
index 39b3c90cf8dc..2dbcd22bb2ce 100755
--- a/tests/shell/testcases/sets/0029named_ifname_dtype_0
+++ b/tests/shell/testcases/sets/0029named_ifname_dtype_0
@@ -13,12 +13,53 @@ EXPECTED="table inet t {
 		elements = { \"ssh\" . \"eth0\" }
 	}
 
+	set nv {
+		type ifname . mark
+	}
+
+	set z {
+		typeof ct zone
+		elements = { 1 }
+	}
+
+	set m {
+		typeof meta mark
+		elements = { 1 }
+	}
+
+	map cz {
+		typeof meta iifname : ct zone
+		elements = { \"veth4\" : 1 }
+	}
+
+	map cm {
+		typeof meta iifname : ct mark
+		elements = { \"veth4\" : 1 }
+	}
+
 	chain c {
 		iifname @s accept
 		oifname @s accept
 		tcp dport . meta iifname @sc accept
+		meta iifname . meta mark @nv accept
 	}
 }"
 
 set -e
 $NFT -f - <<< "$EXPECTED"
+$NFT add element inet t s '{ "eth1" }'
+$NFT add element inet t s '{ "eth2", "eth3", "veth1" }'
+
+$NFT add element inet t sc '{ 80 . "eth0" }'
+$NFT add element inet t sc '{ 80 . "eth0" }' || true
+$NFT add element inet t sc '{ 80 . "eth1" }'
+$NFT add element inet t sc '{ 81 . "eth0" }'
+
+$NFT add element inet t nv '{ "eth0" . 1 }'
+$NFT add element inet t nv '{ "eth0" . 2 }'
+
+$NFT add element inet t z '{ 2, 3, 4, 5, 6 }'
+$NFT add element inet t cz '{ "eth0" : 1,  "eth1" : 2 }'
+
+$NFT add element inet t m '{ 2, 3, 4, 5, 6 }'
+$NFT add element inet t cm '{ "eth0" : 1,  "eth1" : 2 }'
diff --git a/tests/shell/testcases/sets/dumps/0029named_ifname_dtype_0.nft b/tests/shell/testcases/sets/dumps/0029named_ifname_dtype_0.nft
index 23ff89bb90e4..55cd4f262b35 100644
--- a/tests/shell/testcases/sets/dumps/0029named_ifname_dtype_0.nft
+++ b/tests/shell/testcases/sets/dumps/0029named_ifname_dtype_0.nft
@@ -1,17 +1,57 @@
 table inet t {
 	set s {
 		type ifname
-		elements = { "eth0" }
+		elements = { "eth0",
+			     "eth1",
+			     "eth2",
+			     "eth3",
+			     "veth1" }
 	}
 
 	set sc {
 		type inet_service . ifname
-		elements = { 22 . "eth0" }
+		elements = { 22 . "eth0",
+			     80 . "eth0",
+			     81 . "eth0",
+			     80 . "eth1" }
+	}
+
+	set nv {
+		type ifname . mark
+		elements = { "eth0" . 0x00000001,
+			     "eth0" . 0x00000002 }
+	}
+
+	set z {
+		typeof ct zone
+		elements = { 1, 2, 3, 4, 5,
+			     6 }
+	}
+
+	set m {
+		typeof meta mark
+		elements = { 0x00000001, 0x00000002, 0x00000003, 0x00000004, 0x00000005,
+			     0x00000006 }
+	}
+
+	map cz {
+		typeof iifname : ct zone
+		elements = { "eth0" : 1,
+			     "eth1" : 2,
+			     "veth4" : 1 }
+	}
+
+	map cm {
+		typeof iifname : ct mark
+		elements = { "eth0" : 0x00000001,
+			     "eth1" : 0x00000002,
+			     "veth4" : 0x00000001 }
 	}
 
 	chain c {
 		iifname @s accept
 		oifname @s accept
 		tcp dport . iifname @sc accept
+		iifname . meta mark @nv accept
 	}
 }
-- 
2.26.2

