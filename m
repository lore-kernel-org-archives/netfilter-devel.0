Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0594ECAAD5
	for <netfilter-devel@archiver.kernel.org>; Mon, 12 Sep 2022 08:59:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbiILI7C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 12 Sep 2022 04:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229849AbiILI66 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2022 04:58:58 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF21A2AE17
        for <netfilter-devel@vger.kernel.org>; Mon, 12 Sep 2022 01:58:53 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oXfHG-0001ZX-TH; Mon, 12 Sep 2022 10:58:50 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft 1/2] nft: support ttl/hoplimit dissection
Date:   Mon, 12 Sep 2022 10:58:44 +0200
Message-Id: <20220912085846.9116-1-fw@strlen.de>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

xlate raw "nft ... ttl eq 1" and so on to the ttl/hl matches.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft-ipv4.c   |  3 ++
 iptables/nft-ipv6.c   |  3 ++
 iptables/nft-shared.c | 68 +++++++++++++++++++++++++++++++++++++++++++
 iptables/nft-shared.h |  2 ++
 4 files changed, 76 insertions(+)

diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 59c4a41f1a05..1865d1515296 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -206,6 +206,9 @@ static void nft_ipv4_parse_payload(struct nft_xt_ctx *ctx,
 		if (inv)
 			cs->fw.ip.invflags |= IPT_INV_FRAG;
 		break;
+	case offsetof(struct iphdr, ttl):
+		nft_parse_hl(ctx, e, cs);
+		break;
 	default:
 		DEBUGP("unknown payload offset %d\n", ctx->payload.offset);
 		break;
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 9a29d18bc215..0ab1f9719344 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -169,6 +169,9 @@ static void nft_ipv6_parse_payload(struct nft_xt_ctx *ctx,
 		cs->fw6.ipv6.proto = proto;
 		if (inv)
 			cs->fw6.ipv6.invflags |= IP6T_INV_PROTO;
+	case offsetof(struct ip6_hdr, ip6_hlim):
+		nft_parse_hl(ctx, e, cs);
+		break;
 	default:
 		DEBUGP("unknown payload offset %d\n", ctx->payload.offset);
 		break;
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 79c93fe82c60..71e2f18dab92 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -27,6 +27,8 @@
 #include <linux/netfilter/xt_mark.h>
 #include <linux/netfilter/xt_pkttype.h>
 
+#include <linux/netfilter_ipv6/ip6t_hl.h>
+
 #include <libmnl/libmnl.h>
 #include <libnftnl/rule.h>
 #include <libnftnl/expr.h>
@@ -1449,3 +1451,69 @@ void nft_check_xt_legacy(int family, bool is_ipt_save)
 			prefix, prefix, is_ipt_save ? "-save" : "");
 	fclose(fp);
 }
+
+int nft_parse_hl(struct nft_xt_ctx *ctx,
+		 struct nftnl_expr *e,
+		 struct iptables_command_state *cs)
+{
+	struct xtables_match *match;
+	struct ip6t_hl_info *info;
+	uint8_t hl, mode;
+	int op;
+
+	hl = nftnl_expr_get_u8(e, NFTNL_EXPR_CMP_DATA);
+	op = nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_OP);
+
+	switch (op) {
+	case NFT_CMP_NEQ:
+		mode = IP6T_HL_NE;
+		break;
+	case NFT_CMP_EQ:
+		mode = IP6T_HL_EQ;
+		break;
+	case NFT_CMP_LT:
+		mode = IP6T_HL_LT;
+		break;
+	case NFT_CMP_GT:
+		mode = IP6T_HL_GT;
+		break;
+	case NFT_CMP_LTE:
+		mode = IP6T_HL_LT;
+		if (hl == 255)
+			return -1;
+		hl++;
+		break;
+	case NFT_CMP_GTE:
+		mode = IP6T_HL_GT;
+		if (hl == 0)
+			return -1;
+		hl--;
+		break;
+	default:
+		return -1;
+	}
+
+	/* ipt_ttl_info and ip6t_hl_info have same layout,
+	 * IPT_TTL_x and IP6T_HL_x are aliases as well, so
+	 * just use HL for both ipv4 and ipv6.
+	 */
+	switch (ctx->h->family) {
+	case NFPROTO_IPV4:
+		match = nft_create_match(ctx, ctx->cs, "ttl");
+		break;
+	case NFPROTO_IPV6:
+		match = nft_create_match(ctx, ctx->cs, "hl");
+		break;
+	default:
+		return -1;
+	}
+
+	if (!match)
+		return -1;
+
+	info = (void*)match->m->data;
+	info->hop_limit = hl;
+	info->mode = mode;
+
+	return 0;
+}
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index b04049047116..0718dc23e8b7 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -212,6 +212,8 @@ void xtables_restore_parse(struct nft_handle *h,
 
 void nft_check_xt_legacy(int family, bool is_ipt_save);
 
+int nft_parse_hl(struct nft_xt_ctx *ctx, struct nftnl_expr *e, struct iptables_command_state *cs);
+
 #define min(x, y) ((x) < (y) ? (x) : (y))
 #define max(x, y) ((x) > (y) ? (x) : (y))
 
-- 
2.37.3

