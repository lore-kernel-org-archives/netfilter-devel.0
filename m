Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C716C4332F
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Oct 2022 10:02:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbiJUKCV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Oct 2022 06:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJUKCU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2022 06:02:20 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046902475D6
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2022 03:02:16 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oloqz-0005Gm-0m; Fri, 21 Oct 2022 12:02:13 +0200
From:   Florian Westphal <fw@strlen.de>
To:     netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft] nft: disscect basic icmp type/code match
Date:   Fri, 21 Oct 2022 12:02:08 +0200
Message-Id: <20221021100208.7654-1-fw@strlen.de>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft-shared.c                         | 114 ++++++++++++++++--
 .../nft-only/0010-iptables-nft-save.txt       |   6 +-
 2 files changed, 105 insertions(+), 15 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 996cff996c15..34e4053e60a9 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -876,6 +876,9 @@ static void nft_parse_th_port(struct nft_xt_ctx *ctx,
 	case IPPROTO_TCP:
 		nft_parse_tcp(ctx, cs, sport, dport, op);
 		break;
+	default:
+		ctx->errmsg = "unknown l4 proto";
+		break;
 	}
 }
 
@@ -910,6 +913,80 @@ static void nft_parse_tcp_flags(struct nft_xt_ctx *ctx,
 	tcp->flg_mask = mask;
 }
 
+static void nft_parse_icmp(struct nft_xt_ctx *ctx,
+			   struct nft_xt_ctx_reg *sreg,
+			   struct nftnl_expr *e,
+			   struct iptables_command_state *cs,
+			   const char *name)
+{
+	struct xtables_rule_match *m;
+	struct xtables_match *match;
+	struct ipt_icmp *icmp;
+	const uint8_t *v;
+	unsigned int len;
+	int op;
+
+	v = nftnl_expr_get(e, NFTNL_EXPR_CMP_DATA, &len);
+	switch (sreg->payload.offset) {
+	case 0:
+		if (len == 1 || len == 2)
+			break;
+		return;
+	case 1:
+		if (len == 1)
+			break;
+		return;
+	default:
+		ctx->errmsg = "unhandled icmp offset";
+		return;
+	}
+
+	for (m = cs->matches; m; m = m->next) {
+		match = m->match;
+
+		if (strcmp(match->m->u.user.name, name) == 0) {
+			icmp = (void *)match->m->data;
+			goto found;
+		}
+	}
+
+	match = nft_create_match(ctx, cs, name);
+	if (!match) {
+		ctx->errmsg = "failed to add icmp match";
+		return;
+	}
+	icmp = (void*)match->m->data;
+found:
+	op = nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_OP);
+
+	switch (sreg->payload.offset) {
+	case 0:
+		icmp->type = *v;
+		if (len == 1)
+			break;
+		v++;
+	case 1:
+		if (op == NFT_CMP_LTE) {
+			icmp->code[1] = *v;
+			break;
+		}
+
+		icmp->code[0] = *v;
+
+		if (op == NFT_CMP_GTE)
+			break;
+
+		icmp->code[1] = *v;
+		break;
+	default:
+		ctx->errmsg = "unhandled icmp offset";
+		break;
+	}
+
+	if (op == NFT_CMP_NEQ)
+		icmp->invflags |= IPT_ICMP_INV;
+}
+
 static void nft_parse_transport(struct nft_xt_ctx *ctx,
 				struct nftnl_expr *e,
 				struct iptables_command_state *cs)
@@ -921,18 +998,6 @@ static void nft_parse_transport(struct nft_xt_ctx *ctx,
 	uint8_t proto, op;
 	unsigned int len;
 
-	switch (ctx->h->family) {
-	case NFPROTO_IPV4:
-		proto = ctx->cs->fw.ip.proto;
-		break;
-	case NFPROTO_IPV6:
-		proto = ctx->cs->fw6.ipv6.proto;
-		break;
-	default:
-		proto = 0;
-		break;
-	}
-
 	nftnl_expr_get(e, NFTNL_EXPR_CMP_DATA, &len);
 	op = nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_OP);
 
@@ -946,6 +1011,22 @@ static void nft_parse_transport(struct nft_xt_ctx *ctx,
 		return;
 	}
 
+	switch (ctx->h->family) {
+	case NFPROTO_IPV4:
+		proto = ctx->cs->fw.ip.proto;
+		if (proto == IPPROTO_ICMP)
+			return nft_parse_icmp(ctx, sreg, e, cs, "icmp");
+		break;
+	case NFPROTO_IPV6:
+		proto = ctx->cs->fw6.ipv6.proto;
+		if (proto == IPPROTO_ICMPV6)
+			return nft_parse_icmp(ctx, sreg, e, cs, "icmp6");
+		break;
+	default:
+		proto = 0;
+		break;
+	}
+
 	switch(sreg->payload.offset) {
 	case 0: /* th->sport */
 		switch (len) {
@@ -957,6 +1038,9 @@ static void nft_parse_transport(struct nft_xt_ctx *ctx,
 			sdport = ntohl(nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_DATA));
 			nft_parse_th_port(ctx, cs, proto, sdport >> 16, sdport & 0xffff, op);
 			return;
+		default:
+			ctx->errmsg = "unhandled th slen";
+			break;
 		}
 		break;
 	case 2: /* th->dport */
@@ -965,6 +1049,9 @@ static void nft_parse_transport(struct nft_xt_ctx *ctx,
 			port = ntohs(nftnl_expr_get_u16(e, NFTNL_EXPR_CMP_DATA));
 			nft_parse_th_port(ctx, cs, proto, -1, port, op);
 			return;
+		default:
+			ctx->errmsg = "unhandled th dlen";
+			break;
 		}
 		break;
 	case 13: /* th->flags */
@@ -978,6 +1065,9 @@ static void nft_parse_transport(struct nft_xt_ctx *ctx,
 			nft_parse_tcp_flags(ctx, cs, op, flags, mask);
 		}
 		return;
+	default:
+		ctx->errmsg = "unhandled l4 offset";
+		break;
 	}
 }
 
diff --git a/iptables/tests/shell/testcases/nft-only/0010-iptables-nft-save.txt b/iptables/tests/shell/testcases/nft-only/0010-iptables-nft-save.txt
index 73d7108c5094..5ee4c23113aa 100644
--- a/iptables/tests/shell/testcases/nft-only/0010-iptables-nft-save.txt
+++ b/iptables/tests/shell/testcases/nft-only/0010-iptables-nft-save.txt
@@ -13,9 +13,9 @@
 -A INPUT -d 0.0.0.0/2 -m ttl --ttl-gt 2 -j ACCEPT
 -A INPUT -d 0.0.0.0/3 -m ttl --ttl-lt 254 -j ACCEPT
 -A INPUT -d 0.0.0.0/4 -m ttl ! --ttl-eq 255 -j DROP
--A INPUT -d 8.0.0.0/5 -p icmp -j ACCEPT
--A INPUT -d 8.0.0.0/6 -p icmp -j ACCEPT
--A INPUT -d 10.0.0.0/7 -p icmp -j ACCEPT
+-A INPUT -d 8.0.0.0/5 -p icmp -m icmp --icmp-type 1 -j ACCEPT
+-A INPUT -d 8.0.0.0/6 -p icmp -m icmp --icmp-type 2/3 -j ACCEPT
+-A INPUT -d 10.0.0.0/7 -p icmp -m icmp --icmp-type 8 -j ACCEPT
 -A INPUT -m pkttype --pkt-type broadcast -j ACCEPT
 -A INPUT -m pkttype ! --pkt-type unicast -j DROP
 -A INPUT -p tcp
-- 
2.37.3

