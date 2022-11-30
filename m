Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6832FC352A1
	for <netfilter-devel@archiver.kernel.org>; Wed, 30 Nov 2022 11:37:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiK3Lh0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Nov 2022 06:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230006AbiK3LhZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Nov 2022 06:37:25 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9660ED2D9
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Nov 2022 03:37:24 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1p0LP1-0003gE-2S; Wed, 30 Nov 2022 12:37:23 +0100
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [RFC ebtables-nft] unify ether type and meta protocol decoding
Date:   Wed, 30 Nov 2022 12:37:18 +0100
Message-Id: <20221130113718.85576-1-fw@strlen.de>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Handle "ether protocol" and "meta protcol" the same.

Problem is that this breaks the test case *again*:

I: [EXECUTING]   iptables/tests/shell/testcases/ebtables/0006-flush_0
--A FORWARD --among-dst fe:ed:ba:be:13:37=10.0.0.1 -j ACCEPT
--A OUTPUT --among-src c0:ff:ee:90:0:0=192.168.0.1 -j DROP
+-A FORWARD -p IPv4 --among-dst fe:ed:ba:be:13:37=10.0.0.1 -j ACCEPT
+-A OUTPUT -p IPv4 --among-src c0:ff:ee:90:0:0=192.168.0.1 -j DROP

... because ebtables-nft will now render meta protocol as "-p IPv4".

ebtables-legacy does not have any special handling for this.

Solving this would need more internal annotations during decode, so
we can suppress/ignore "meta protocol" once a "among-type" set is
encountered.

Any (other) suggestions?

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft-bridge.c | 74 +++++++++++++++++++++++++++++++++++--------
 1 file changed, 61 insertions(+), 13 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 50e90b22cf2f..4488ff172c2e 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -188,6 +188,64 @@ static int nft_bridge_add(struct nft_handle *h,
 	return _add_action(r, cs);
 }
 
+static bool nft_bridge_parse_ethproto(struct nft_xt_ctx *ctx,
+				      struct nftnl_expr *e,
+				      struct iptables_command_state *cs)
+{
+	struct ebt_entry *fw = &cs->eb;
+	bool already_seen;
+	uint16_t ethproto;
+	uint8_t op;
+
+	already_seen = (fw->bitmask & EBT_NOPROTO) == 0;
+
+	__get_cmp_data(e, &ethproto, sizeof(ethproto), &op);
+
+	switch (op) {
+	case NFT_CMP_EQ:
+		if (already_seen && fw->invflags & EBT_IPROTO) {
+			ctx->errmsg = "ethproto eq test contradicts previous";
+			return false;
+		}
+		break;
+	case NFT_CMP_NEQ:
+		if (already_seen && (fw->invflags & EBT_IPROTO) == 0) {
+			ctx->errmsg = "ethproto ne test contradicts previous";
+			return false;
+		}
+		fw->invflags |= EBT_IPROTO;
+		break;
+	case NFT_CMP_GTE:
+		if (already_seen && (fw->invflags & EBT_IPROTO) == 0) {
+			ctx->errmsg = "ethproto gte test contradicts previous";
+			return false;
+		}
+		fw->invflags |= EBT_IPROTO;
+		/* fallthrough */
+	case NFT_CMP_LT:
+		/* -p Length mode */
+		if (ethproto == htons(0x0600))
+			fw->bitmask |= EBT_802_3;
+		break;
+	default:
+		ctx->errmsg = "ethproto only supports eq/ne test";
+		return false;
+	}
+
+	if (already_seen) {
+		if (fw->ethproto != ethproto) {
+			ctx->errmsg = "ethproto ne test contradicts previous";
+			return false;
+		}
+	} else if ((fw->bitmask & EBT_802_3) == 0) {
+		fw->ethproto = ethproto;
+	}
+
+	fw->bitmask &= ~EBT_NOPROTO;
+
+	return true;
+}
+
 static void nft_bridge_parse_meta(struct nft_xt_ctx *ctx,
 				  const struct nft_xt_ctx_reg *reg,
 				  struct nftnl_expr *e,
@@ -199,6 +257,7 @@ static void nft_bridge_parse_meta(struct nft_xt_ctx *ctx,
 
 	switch (reg->meta_dreg.key) {
 	case NFT_META_PROTOCOL:
+		nft_bridge_parse_ethproto(ctx, e, cs);
 		return;
 	}
 
@@ -241,8 +300,6 @@ static void nft_bridge_parse_payload(struct nft_xt_ctx *ctx,
 {
 	struct ebt_entry *fw = &cs->eb;
 	unsigned char addr[ETH_ALEN];
-	unsigned short int ethproto;
-	uint8_t op;
 	bool inv;
 	int i;
 
@@ -275,17 +332,8 @@ static void nft_bridge_parse_payload(struct nft_xt_ctx *ctx,
 		fw->bitmask |= EBT_ISOURCE;
 		break;
 	case offsetof(struct ethhdr, h_proto):
-		__get_cmp_data(e, &ethproto, sizeof(ethproto), &op);
-		if (ethproto == htons(0x0600)) {
-			fw->bitmask |= EBT_802_3;
-			inv = (op == NFT_CMP_GTE);
-		} else {
-			fw->ethproto = ethproto;
-			inv = (op == NFT_CMP_NEQ);
-		}
-		if (inv)
-			fw->invflags |= EBT_IPROTO;
-		fw->bitmask &= ~EBT_NOPROTO;
+		if (!nft_bridge_parse_ethproto(ctx, e, cs))
+			return;
 		break;
 	}
 }
-- 
2.38.1

