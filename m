Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61D83C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 20 Dec 2022 20:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234116AbiLTUoy (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 20 Dec 2022 15:44:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbiLTUou (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Dec 2022 15:44:50 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 044BB1B794
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Dec 2022 12:44:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=jKqM3q46pbBlDym2ompNyZJ3O8qMlgvOpCFuT7fJ9WQ=; b=X/3zZP4zWmC2Gqq7B+Iqk2a6V3
        2zTCytB6MjF6zlZ0mk+sMYGEaGGoSeeZ8IFfFre7C+iFxTqjMaYFw2LI04f5Ghxz8bZv4Ac6oqBeE
        BTRY15d13BjowWNqMImRcuDaUzt6PUq5Lh2JF3mfX08167aHd6oluhif76fXJiEwQ0BgVABKvCcv8
        BROWk+7PId89sJPijFhZsoiHisbWINMebxahr4tsel8IUpRU6NRZEvp5QleBS+19wliuf4545NE7k
        OrAzXCFUWdOkLiShLJjGoH5sH0+LiIX/n/PZlnvyJd39N82Zgg38qUmY/A2gjYEFx5iRBFSb6iT4p
        ucByHLtA==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1p7jTi-0000ur-SE; Tue, 20 Dec 2022 21:44:46 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables RFC] ebtables: among: Embed meta protocol match into set lookup
Date:   Tue, 20 Dec 2022 21:44:38 +0100
Message-Id: <20221220204438.9443-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221130113718.85576-1-fw@strlen.de>
References: <20221130113718.85576-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This way the match will be consumed by among match parser and not
confused with explicit '-p IPv4' match.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
This is a bit of a hack to avoid the implicit vs. explicit confusion but
it works and is backwards compatible. WDYT?
---
 extensions/libebt_among.c |  1 +
 iptables/nft-bridge.c     | 65 ++++++++++++++++++++++++---------------
 iptables/nft-bridge.h     |  1 +
 iptables/nft.c            | 30 ++++++++++++------
 4 files changed, 62 insertions(+), 35 deletions(-)

diff --git a/extensions/libebt_among.c b/extensions/libebt_among.c
index a80fb80404ee1..49580ea6d3fc2 100644
--- a/extensions/libebt_among.c
+++ b/extensions/libebt_among.c
@@ -69,6 +69,7 @@ parse_nft_among_pair(char *buf, struct nft_among_pair *pair, bool have_ip)
 		if (!inet_pton(AF_INET, sep + 1, &pair->in))
 			xtables_error(PARAMETER_PROBLEM,
 				      "Invalid IP address '%s'", sep + 1);
+		pair->proto = htons(ETH_P_IP);
 	}
 	ether = ether_aton(buf);
 	if (!ether)
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index e223d19765f90..ebfc5de50b236 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -335,17 +335,26 @@ static int lookup_analyze_payloads(struct nft_xt_ctx *ctx,
 	const struct nft_xt_ctx_reg *reg;
 	int val, val2 = -1;
 
-	reg = nft_xt_ctx_get_sreg(ctx, sreg);
-	if (!reg)
-		return -1;
-
-	if (reg->type != NFT_XT_REG_PAYLOAD) {
-		ctx->errmsg = "lookup reg is not payload type";
+	switch (key_len) {
+	case 6:		/* ether */
+	case 12:	/* + ipv4addr */
+	case 16:	/* + meta protocol */
+		break;
+	default:
+		ctx->errmsg = "unsupported lookup key length";
 		return -1;
 	}
 
-	switch (key_len) {
-	case 12: /* ether + ipv4addr */
+	if (key_len >= 6) { /* ether */
+		reg = nft_xt_ctx_get_sreg(ctx, sreg);
+		if (!reg)
+			return -1;
+
+		if (reg->type != NFT_XT_REG_PAYLOAD) {
+			ctx->errmsg = "lookup reg is not payload type";
+			return -1;
+		}
+
 		val = lookup_check_ether_payload(reg->payload.base,
 						 reg->payload.offset,
 						 reg->payload.len);
@@ -355,7 +364,8 @@ static int lookup_analyze_payloads(struct nft_xt_ctx *ctx,
 			       reg->payload.len);
 			return -1;
 		}
-
+	}
+	if (key_len >= 12) { /* + ipv4addr */
 		sreg = nft_get_next_reg(sreg, ETH_ALEN);
 
 		reg = nft_xt_ctx_get_sreg(ctx, sreg);
@@ -381,23 +391,25 @@ static int lookup_analyze_payloads(struct nft_xt_ctx *ctx,
 			DEBUGP("mismatching payload match offsets\n");
 			return -1;
 		}
-		break;
-	case 6: /* ether */
-		val = lookup_check_ether_payload(reg->payload.base,
-						 reg->payload.offset,
-						 reg->payload.len);
-		if (val < 0) {
-			DEBUGP("unknown payload base/offset/len %d/%d/%d\n",
-			       reg->payload.base, reg->payload.offset,
-			       reg->payload.len);
+	}
+	if (key_len == 16) {
+		sreg = nft_get_next_reg(sreg, sizeof(struct in_addr));
+		reg = nft_xt_ctx_get_sreg(ctx, sreg);
+		if (!reg) {
+			ctx->errmsg = "next lookup register is invalid";
+			return -1;
+		}
+
+		if (reg->type != NFT_XT_REG_META_DREG) {
+			ctx->errmsg = "next lookup reg is not meta type";
 			return -1;
 		}
-		break;
-	default:
-		ctx->errmsg = "unsupported lookup key length";
-		return -1;
-	}
 
+		if (reg->meta_dreg.key != NFT_META_PROTOCOL) {
+			ctx->errmsg = "meta reg not protocol type";
+			return -1;
+		}
+	}
 	if (dst)
 		*dst = (val == 1);
 	if (ip)
@@ -422,15 +434,18 @@ static int set_elems_to_among_pairs(struct nft_among_pair *pairs,
 
 	while ((elem = nftnl_set_elems_iter_next(iter))) {
 		data = nftnl_set_elem_get(elem, NFTNL_SET_ELEM_KEY, &datalen);
+		struct nft_among_pair pair = {};
+
 		if (!data) {
 			fprintf(stderr, "BUG: set elem without key\n");
 			goto err;
 		}
-		if (datalen > sizeof(*pairs)) {
+		if (datalen > sizeof(pair)) {
 			fprintf(stderr, "BUG: overlong set elem\n");
 			goto err;
 		}
-		nft_among_insert_pair(pairs, &tmpcnt, data);
+		memcpy(&pair, data, datalen);
+		nft_among_insert_pair(pairs, &tmpcnt, &pair);
 	}
 	ret = 0;
 err:
diff --git a/iptables/nft-bridge.h b/iptables/nft-bridge.h
index eb1b3928b6543..c87065ef48195 100644
--- a/iptables/nft-bridge.h
+++ b/iptables/nft-bridge.h
@@ -125,6 +125,7 @@ int ebt_command_default(struct iptables_command_state *cs);
 struct nft_among_pair {
 	struct ether_addr ether;
 	struct in_addr in __attribute__((aligned (4)));
+	uint16_t proto __attribute__((aligned (4)));
 };
 
 struct nft_among_data {
diff --git a/iptables/nft.c b/iptables/nft.c
index 430888e864a5f..05422c91f3827 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1139,6 +1139,7 @@ gen_lookup(uint32_t sreg, const char *set_name, uint32_t set_id, uint32_t flags)
 /* from nftables:include/datatype.h, enum datatypes */
 #define NFT_DATATYPE_IPADDR	7
 #define NFT_DATATYPE_ETHERADDR	9
+#define NFT_DATATYPE_ETHERTYPE	10
 
 static int __add_nft_among(struct nft_handle *h, const char *table,
 			   struct nftnl_rule *r, struct nft_among_pair *pairs,
@@ -1164,6 +1165,11 @@ static int __add_nft_among(struct nft_handle *h, const char *table,
 		type = type << CONCAT_TYPE_BITS | NFT_DATATYPE_IPADDR;
 		len += sizeof(struct in_addr) + NETLINK_ALIGN - 1;
 		len &= ~(NETLINK_ALIGN - 1);
+
+		type = type << CONCAT_TYPE_BITS | NFT_DATATYPE_ETHERTYPE;
+		len += sizeof(uint16_t) + NETLINK_ALIGN - 1;
+		len &= ~(NETLINK_ALIGN - 1);
+
 		flags = NFT_SET_INTERVAL | NFT_SET_CONCAT;
 	}
 
@@ -1173,7 +1179,11 @@ static int __add_nft_among(struct nft_handle *h, const char *table,
 	set_id = nftnl_set_get_u32(s, NFTNL_SET_ID);
 
 	if (ip) {
-		uint8_t field_len[2] = { ETH_ALEN, sizeof(struct in_addr) };
+		uint8_t field_len[] = {
+			ETH_ALEN,
+			sizeof(struct in_addr),
+			sizeof(uint16_t),
+		};
 
 		nftnl_set_set_data(s, NFTNL_SET_DESC_CONCAT,
 				   field_len, sizeof(field_len));
@@ -1211,6 +1221,15 @@ static int __add_nft_among(struct nft_handle *h, const char *table,
 		if (!e)
 			return -ENOMEM;
 		nftnl_rule_add_expr(r, e);
+
+		/* FIXME: Fix add_meta() instead to accept a reg */
+		reg = nft_get_next_reg(reg, sizeof(struct in_addr));
+		e = nftnl_expr_alloc("meta");
+		if (!e)
+			return -ENOMEM;
+		nftnl_expr_set_u32(e, NFTNL_EXPR_META_KEY, NFT_META_PROTOCOL);
+		nftnl_expr_set_u32(e, NFTNL_EXPR_META_DREG, reg);
+		nftnl_rule_add_expr(r, e);
 	}
 
 	reg = NFT_REG_1;
@@ -1228,15 +1247,6 @@ static int add_nft_among(struct nft_handle *h,
 	struct nft_among_data *data = (struct nft_among_data *)m->data;
 	const char *table = nftnl_rule_get(r, NFTNL_RULE_TABLE);
 
-	if ((data->src.cnt && data->src.ip) ||
-	    (data->dst.cnt && data->dst.ip)) {
-		uint16_t eth_p_ip = htons(ETH_P_IP);
-		uint8_t reg;
-
-		add_meta(h, r, NFT_META_PROTOCOL, &reg);
-		add_cmp_ptr(r, NFT_CMP_EQ, &eth_p_ip, 2, reg);
-	}
-
 	if (data->src.cnt)
 		__add_nft_among(h, table, r, data->pairs, data->src.cnt,
 				false, data->src.inv, data->src.ip);
-- 
2.38.0

