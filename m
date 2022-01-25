Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71FDEC433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jan 2022 16:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355816AbiAYQ6a (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jan 2022 11:58:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356071AbiAYQz7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jan 2022 11:55:59 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 773D9C06174E
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Jan 2022 08:53:16 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nCP4E-0001dL-Vr; Tue, 25 Jan 2022 17:53:15 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH iptables-nft 2/7] nft-shared: support native tcp port range delinearize
Date:   Tue, 25 Jan 2022 17:52:56 +0100
Message-Id: <20220125165301.5960-3-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220125165301.5960-1-fw@strlen.de>
References: <20220125165301.5960-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

adds support for
nft ... tcp dport != min-max

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft-shared.c | 113 ++++++++++++++++++++++++++++++++++++++++++
 iptables/nft-shared.h |   1 +
 iptables/nft.c        |   1 +
 3 files changed, 115 insertions(+)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 674c72b35ae7..7f6b4ff392d9 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -513,6 +513,43 @@ static struct xt_tcp *nft_tcp_match(struct nft_xt_ctx *ctx,
 	return tcp;
 }
 
+static void nft_complete_tcp_range(struct nft_xt_ctx *ctx,
+			           struct iptables_command_state *cs,
+			           int sport_from, int sport_to,
+			           int dport_from, int dport_to,
+				   uint8_t op)
+{
+	struct xt_tcp *tcp = nft_tcp_match(ctx, cs);
+
+	if (!tcp)
+		return;
+
+	if (sport_from >= 0) {
+		switch (op) {
+		case NFT_RANGE_NEQ:
+			tcp->invflags |= XT_TCP_INV_SRCPT;
+			/* fallthrough */
+		case NFT_RANGE_EQ:
+			tcp->spts[0] = sport_from;
+			tcp->spts[1] = sport_to;
+			break;
+		}
+	}
+
+	if (dport_to >= 0) {
+		switch (op) {
+		case NFT_CMP_NEQ:
+			tcp->invflags |= XT_TCP_INV_DSTPT;
+			/* fallthrough */
+		case NFT_CMP_EQ:
+			tcp->dpts[0] = dport_from;
+			tcp->dpts[1] = dport_to;
+			break;
+		}
+	}
+}
+
+
 static void nft_complete_tcp(struct nft_xt_ctx *ctx,
 			     struct iptables_command_state *cs,
 			     int sport, int dport,
@@ -584,6 +621,20 @@ static void nft_complete_th_port(struct nft_xt_ctx *ctx,
 	}
 }
 
+static void nft_complete_th_port_range(struct nft_xt_ctx *ctx,
+				       struct iptables_command_state *cs,
+				       uint8_t proto,
+				       int sport_from, int sport_to,
+				       int dport_from, int dport_to, uint8_t op)
+{
+	switch (proto) {
+	case IPPROTO_TCP:
+		nft_complete_tcp_range(ctx, cs, sport_from, sport_to, dport_from, dport_to, op);
+		break;
+	}
+}
+
+
 static void nft_complete_transport(struct nft_xt_ctx *ctx,
 				   struct nftnl_expr *e, void *data)
 {
@@ -632,6 +683,47 @@ static void nft_complete_transport(struct nft_xt_ctx *ctx,
 	}
 }
 
+static void nft_complete_transport_range(struct nft_xt_ctx *ctx,
+					 struct nftnl_expr *e,
+					 struct iptables_command_state *cs)
+{
+	unsigned int len_from, len_to;
+	uint8_t proto, op;
+	uint16_t from, to;
+
+	switch (ctx->h->family) {
+	case NFPROTO_IPV4:
+		proto = ctx->cs->fw.ip.proto;
+		break;
+	case NFPROTO_IPV6:
+		proto = ctx->cs->fw6.ipv6.proto;
+		break;
+	default:
+		proto = 0;
+		break;
+	}
+
+	nftnl_expr_get(e, NFTNL_EXPR_RANGE_FROM_DATA, &len_from);
+	nftnl_expr_get(e, NFTNL_EXPR_RANGE_FROM_DATA, &len_to);
+	if (len_to != len_from || len_to != 2)
+		return;
+
+	op = nftnl_expr_get_u32(e, NFTNL_EXPR_RANGE_OP);
+
+	from = ntohs(nftnl_expr_get_u16(e, NFTNL_EXPR_RANGE_FROM_DATA));
+	to = ntohs(nftnl_expr_get_u16(e, NFTNL_EXPR_RANGE_TO_DATA));
+
+	switch(ctx->payload.offset) {
+	case 0:
+		nft_complete_th_port_range(ctx, cs, proto, from, to, -1, -1, op);
+		return;
+	case 2:
+		to = ntohs(nftnl_expr_get_u16(e, NFTNL_EXPR_RANGE_TO_DATA));
+		nft_complete_th_port_range(ctx, cs, proto, -1, -1, from, to, op);
+		return;
+	}
+}
+
 static void nft_parse_cmp(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 {
 	void *data = ctx->cs;
@@ -811,6 +903,25 @@ static void nft_parse_lookup(struct nft_xt_ctx *ctx, struct nft_handle *h,
 		ctx->h->ops->parse_lookup(ctx, e, NULL);
 }
 
+static void nft_parse_range(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
+{
+	uint32_t reg;
+
+	reg = nftnl_expr_get_u32(e, NFTNL_EXPR_RANGE_SREG);
+	if (reg != ctx->reg)
+		return;
+
+	if (ctx->flags & NFT_XT_CTX_PAYLOAD) {
+		switch (ctx->payload.base) {
+		case NFT_PAYLOAD_TRANSPORT_HEADER:
+			nft_complete_transport_range(ctx, e, ctx->cs);
+			break;
+		default:
+			break;
+		}
+	}
+}
+
 void nft_rule_to_iptables_command_state(struct nft_handle *h,
 					const struct nftnl_rule *r,
 					struct iptables_command_state *cs)
@@ -855,6 +966,8 @@ void nft_rule_to_iptables_command_state(struct nft_handle *h,
 			nft_parse_lookup(&ctx, h, expr);
 		else if (strcmp(name, "log") == 0)
 			nft_parse_log(&ctx, expr);
+		else if (strcmp(name, "range") == 0)
+			nft_parse_range(&ctx, expr);
 
 		expr = nftnl_expr_iter_next(iter);
 	}
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 0a8be7099aa2..1468d5608158 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -45,6 +45,7 @@ enum {
 	NFT_XT_CTX_BITWISE	= (1 << 2),
 	NFT_XT_CTX_IMMEDIATE	= (1 << 3),
 	NFT_XT_CTX_PREV_PAYLOAD	= (1 << 4),
+	NFT_XT_CTX_RANGE	= (1 << 5),
 };
 
 struct nft_xt_ctx {
diff --git a/iptables/nft.c b/iptables/nft.c
index b5de687c5c4c..f7f5950625d0 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -3529,6 +3529,7 @@ static const char *supported_exprs[] = {
 	"counter",
 	"immediate",
 	"lookup",
+	"range",
 };
 
 
-- 
2.34.1

