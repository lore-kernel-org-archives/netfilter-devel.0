Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E09D3C32771
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Sep 2022 13:55:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233713AbiI1Nzi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Sep 2022 09:55:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbiI1Nzh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Sep 2022 09:55:37 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D837932067
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Sep 2022 06:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=2LB4R909MwnmCHOS1L+GuEUTlcx25NDQD7ZTyOk/AXM=; b=qWL6lsb19+ZSIX8n1jH+/WVqMR
        /C/GV7hQL/At+nWTW/WI4XCSKCtaQ+2+dY2EBDbi9Lg9IS/4SNmNt/qbae4xTKKAjZpkuwXj8Ue2J
        i/1I5S0qg4QMMhCFU6v2JIe/bdzNmTgZR7Aed3EtEB4kORnrsGlbcv1+e/H0U1WXoxXcXYIJbYeP8
        Q92U2aNoDYd3C3hM5vHKf4p88UjCP+0OVH3YvQOgKjWxO3s/5NNE1zTW1VjM6m1tLE4MXrXSvxHVS
        pMWynpqEa5OcumfbsNyyP2ptKuIc3txbWq5XD2PSI7bJ0+3EDZGSSWE+14SUZcSfrLWIqszSnYWnz
        +OUGbHKg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1odXXB-0000HF-0A; Wed, 28 Sep 2022 15:55:33 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] ebtables: Fix among match
Date:   Wed, 28 Sep 2022 15:55:24 +0200
Message-Id: <20220928135524.22822-1-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Fixed commit broke among match in two ways:

1) The two lookup sizes are 12 and 6, not 12 and 4 - among supports
   either ether+IP or ether only, not IP only.

2) Adding two to sreg_count to get the second register is too simple: It
   works only for four byte regs, not the 16 byte ones. The first
   register is always a 16 byte one, though.

Fixing (1) is trivial, fix (2) by introduction of nft_get_next_reg()
doing the right thing. For consistency, use it for among match creation,
too.

Fixes: f315af1cf8871 ("nft: track each register individually")
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-bridge.c |  4 ++--
 iptables/nft-shared.c | 16 ++++++++++++++++
 iptables/nft-shared.h |  5 +++++
 iptables/nft.c        |  6 ++----
 4 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 659c5b58ba633..596dfdf8991f1 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -349,7 +349,7 @@ static int lookup_analyze_payloads(struct nft_xt_ctx *ctx,
 			return -1;
 		}
 
-		sreg_count += 2;
+		sreg_count = nft_get_next_reg(sreg_count, ETH_ALEN);
 
 		reg = nft_xt_ctx_get_sreg(ctx, sreg_count);
 		if (!reg) {
@@ -375,7 +375,7 @@ static int lookup_analyze_payloads(struct nft_xt_ctx *ctx,
 			return -1;
 		}
 		break;
-	case 4: /* ipv4addr */
+	case 6: /* ether */
 		val = lookup_check_ether_payload(reg->payload.base,
 						 reg->payload.offset,
 						 reg->payload.len);
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index f8de2b715dd61..909fe6483205c 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -10,6 +10,7 @@
  * This code has been sponsored by Sophos Astaro <http://www.sophos.com>
  */
 
+#include <assert.h>
 #include <string.h>
 #include <stdio.h>
 #include <stdlib.h>
@@ -1603,3 +1604,18 @@ int nft_parse_hl(struct nft_xt_ctx *ctx,
 
 	return 0;
 }
+
+enum nft_registers nft_get_next_reg(enum nft_registers reg, size_t size)
+{
+	/* convert size to NETLINK_ALIGN-sized chunks */
+	size = (size + NETLINK_ALIGN - 1) / NETLINK_ALIGN;
+
+	/* map 16byte reg to 4byte one */
+	if (reg < __NFT_REG_MAX)
+		reg = NFT_REG32_00 + (reg - 1) * NFT_REG_SIZE / NFT_REG32_SIZE;
+
+	reg += size;
+	assert(reg <= NFT_REG32_15);
+
+	return reg;
+}
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 8fcedcdd78fbe..c07d3270a407e 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -276,4 +276,9 @@ int nft_parse_hl(struct nft_xt_ctx *ctx, struct nftnl_expr *e, struct iptables_c
 #define min(x, y) ((x) < (y) ? (x) : (y))
 #define max(x, y) ((x) > (y) ? (x) : (y))
 
+/* simplified nftables:include/netlink.h, netlink_padded_len() */
+#define NETLINK_ALIGN		4
+
+enum nft_registers nft_get_next_reg(enum nft_registers reg, size_t size);
+
 #endif
diff --git a/iptables/nft.c b/iptables/nft.c
index 2165733ff74e9..09cb19c987322 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1133,9 +1133,6 @@ gen_lookup(uint32_t sreg, const char *set_name, uint32_t set_id, uint32_t flags)
 	return e;
 }
 
-/* simplified nftables:include/netlink.h, netlink_padded_len() */
-#define NETLINK_ALIGN		4
-
 /* from nftables:include/datatype.h, TYPE_BITS */
 #define CONCAT_TYPE_BITS	6
 
@@ -1208,8 +1205,9 @@ static int __add_nft_among(struct nft_handle *h, const char *table,
 	nftnl_rule_add_expr(r, e);
 
 	if (ip) {
+		reg = nft_get_next_reg(reg, ETH_ALEN);
 		e = __gen_payload(NFT_PAYLOAD_NETWORK_HEADER, ip_addr_off[dst],
-				sizeof(struct in_addr), NFT_REG32_02);
+				  sizeof(struct in_addr), reg);
 		if (!e)
 			return -ENOMEM;
 		nftnl_rule_add_expr(r, e);
-- 
2.34.1

