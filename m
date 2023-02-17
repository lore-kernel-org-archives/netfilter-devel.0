Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93E63C05027
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Feb 2023 13:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbjBQNqp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Feb 2023 08:46:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229991AbjBQNql (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Feb 2023 08:46:41 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F346B314
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Feb 2023 05:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yzyflbNQz1p9UnTHY7i5gd+oVk1uhrbPjcHJlEN8QUc=; b=leDsnN+RBN2VOyBh11RY6v7cAQ
        Hf0CJ8zibwTGWxfOKBipjfTA6TrNXC7BzC+WRvxw4gkEC5U6IAOTYXWmust++K7PzRnUWR41bbkJT
        j1GFfshVaxmJyrHOakpA/V/LsJwtFCueRD2NZjUSBcZHzc+zbdtVpvt0qowT7M/c0+heRr/+2fwC2
        +3nhW82sBMreLaPRYabMxifYRSOMvB32c6VtKzVU7KmMS1CMIM2m3Fk58tX7tmA9lOYHjApSOqWM4
        TadClDwi8IdZzPavNDtA4rdlEscocs/gu28qqGYvXa2oBjrxa66Nehg1YVFpJoXqfi3qcINY57jf5
        ahYnYu6Q==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pT142-0001uR-M6
        for netfilter-devel@vger.kernel.org; Fri, 17 Feb 2023 14:46:14 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 3/3] nft-shared: Simplify using nft_create_match()
Date:   Fri, 17 Feb 2023 14:46:00 +0100
Message-Id: <20230217134600.14433-3-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20230217134600.14433-1-phil@nwl.cc>
References: <20230217134600.14433-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Perform the nft_family_ops::parse_match call from inside
nft_create_match(). It frees callers from having to access the match
itself.
Then return a pointer to match data instead of the match itself.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 106 ++++++++++++++++--------------------------
 1 file changed, 40 insertions(+), 66 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 52e745fea85c2..1b22eb7afd305 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -301,7 +301,7 @@ static void parse_ifname(const char *name, unsigned int len, char *dst, unsigned
 		memset(mask, 0xff, len - 2);
 }
 
-static struct xtables_match *
+static void *
 nft_create_match(struct nft_xt_ctx *ctx,
 		 struct iptables_command_state *cs,
 		 const char *name, bool reuse);
@@ -319,15 +319,12 @@ static uint32_t get_meta_mask(struct nft_xt_ctx *ctx, enum nft_registers sreg)
 static int parse_meta_mark(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 {
 	struct xt_mark_mtinfo1 *mark;
-	struct xtables_match *match;
 	uint32_t value;
 
-	match = nft_create_match(ctx, ctx->cs, "mark", false);
-	if (!match)
+	mark = nft_create_match(ctx, ctx->cs, "mark", false);
+	if (!mark)
 		return -1;
 
-	mark = (void*)match->m->data;
-
 	if (nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_OP) == NFT_CMP_NEQ)
 		mark->invert = 1;
 
@@ -341,15 +338,12 @@ static int parse_meta_mark(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 static int parse_meta_pkttype(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 {
 	struct xt_pkttype_info *pkttype;
-	struct xtables_match *match;
 	uint8_t value;
 
-	match = nft_create_match(ctx, ctx->cs, "pkttype", false);
-	if (!match)
+	pkttype = nft_create_match(ctx, ctx->cs, "pkttype", false);
+	if (!pkttype)
 		return -1;
 
-	pkttype = (void*)match->m->data;
-
 	if (nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_OP) == NFT_CMP_NEQ)
 		pkttype->invert = 1;
 
@@ -659,7 +653,7 @@ nft_find_match_in_cs(struct iptables_command_state *cs, const char *name)
 	return NULL;
 }
 
-static struct xtables_match *
+static void *
 nft_create_match(struct nft_xt_ctx *ctx,
 		 struct iptables_command_state *cs,
 		 const char *name, bool reuse)
@@ -671,7 +665,7 @@ nft_create_match(struct nft_xt_ctx *ctx,
 	if (reuse) {
 		match = nft_find_match_in_cs(cs, name);
 		if (match)
-			return match;
+			return match->m->data;
 	}
 
 	match = xtables_find_match(name, XTF_TRY_LOAD,
@@ -689,32 +683,10 @@ nft_create_match(struct nft_xt_ctx *ctx,
 
 	xs_init_match(match);
 
-	return match;
-}
-
-static struct xt_udp *nft_udp_match(struct nft_xt_ctx *ctx,
-			            struct iptables_command_state *cs)
-{
-	struct xtables_match *match;
-
-	match = nft_create_match(ctx, cs, "udp", true);
-	if (!match)
-		return NULL;
-
-	return (struct xt_udp *)match->m->data;
-}
-
-static struct xt_tcp *nft_tcp_match(struct nft_xt_ctx *ctx,
-			            struct iptables_command_state *cs)
-{
-	struct xtables_match *match;
+	if (ctx->h->ops->parse_match)
+		ctx->h->ops->parse_match(match, cs);
 
-	match = nft_create_match(ctx, cs, "tcp", true);
-	if (!match) {
-		ctx->errmsg = "tcp match extension not found";
-		return NULL;
-	}
-	return (struct xt_tcp *)match->m->data;
+	return match->m->data;
 }
 
 static void nft_parse_udp_range(struct nft_xt_ctx *ctx,
@@ -723,10 +695,12 @@ static void nft_parse_udp_range(struct nft_xt_ctx *ctx,
 			        int dport_from, int dport_to,
 				uint8_t op)
 {
-	struct xt_udp *udp = nft_udp_match(ctx, cs);
+	struct xt_udp *udp = nft_create_match(ctx, cs, "udp", true);
 
-	if (!udp)
+	if (!udp) {
+		ctx->errmsg = "udp match extension not found";
 		return;
+	}
 
 	if (sport_from >= 0) {
 		switch (op) {
@@ -759,10 +733,12 @@ static void nft_parse_tcp_range(struct nft_xt_ctx *ctx,
 			        int dport_from, int dport_to,
 				uint8_t op)
 {
-	struct xt_tcp *tcp = nft_tcp_match(ctx, cs);
+	struct xt_tcp *tcp = nft_create_match(ctx, cs, "tcp", true);
 
-	if (!tcp)
+	if (!tcp) {
+		ctx->errmsg = "tcp match extension not found";
 		return;
+	}
 
 	if (sport_from >= 0) {
 		switch (op) {
@@ -823,10 +799,12 @@ static void nft_parse_udp(struct nft_xt_ctx *ctx,
 			  int sport, int dport,
 			  uint8_t op)
 {
-	struct xt_udp *udp = nft_udp_match(ctx, cs);
+	struct xt_udp *udp = nft_create_match(ctx, cs, "udp", true);
 
-	if (!udp)
+	if (!udp) {
+		ctx->errmsg = "udp match extension not found";
 		return;
+	}
 
 	port_match_single_to_range(udp->spts, &udp->invflags,
 				   op, sport, XT_UDP_INV_SRCPT);
@@ -839,10 +817,12 @@ static void nft_parse_tcp(struct nft_xt_ctx *ctx,
 			  int sport, int dport,
 			  uint8_t op)
 {
-	struct xt_tcp *tcp = nft_tcp_match(ctx, cs);
+	struct xt_tcp *tcp = nft_create_match(ctx, cs, "tcp", true);
 
-	if (!tcp)
+	if (!tcp) {
+		ctx->errmsg = "tcp match extension not found";
 		return;
+	}
 
 	port_match_single_to_range(tcp->spts, &tcp->invflags,
 				   op, sport, XT_TCP_INV_SRCPT);
@@ -855,11 +835,10 @@ static void nft_parse_icmp(struct nft_xt_ctx *ctx,
 			   struct nft_xt_ctx_reg *sreg,
 			   uint8_t op, const char *data, size_t dlen)
 {
-	struct xtables_match *match;
 	struct ipt_icmp icmp = {
 		.type = UINT8_MAX,
 		.code = { 0, UINT8_MAX },
-	};
+	}, *icmpp;
 
 	if (dlen < 1)
 		goto out_err_len;
@@ -884,25 +863,25 @@ static void nft_parse_icmp(struct nft_xt_ctx *ctx,
 
 	switch (ctx->h->family) {
 	case NFPROTO_IPV4:
-		match = nft_create_match(ctx, cs, "icmp", false);
+		icmpp = nft_create_match(ctx, cs, "icmp", false);
 		break;
 	case NFPROTO_IPV6:
 		if (icmp.type == UINT8_MAX) {
 			ctx->errmsg = "icmp6 code with any type match not supported";
 			return;
 		}
-		match = nft_create_match(ctx, cs, "icmp6", false);
+		icmpp = nft_create_match(ctx, cs, "icmp6", false);
 		break;
 	default:
 		ctx->errmsg = "unexpected family for icmp match";
 		return;
 	}
 
-	if (!match) {
+	if (!icmpp) {
 		ctx->errmsg = "icmp match extension not found";
 		return;
 	}
-	memcpy(match->m->data, &icmp, sizeof(icmp));
+	memcpy(icmpp, &icmp, sizeof(icmp));
 	return;
 
 out_err_len:
@@ -946,10 +925,12 @@ static void nft_parse_tcp_flags(struct nft_xt_ctx *ctx,
 				struct iptables_command_state *cs,
 				uint8_t op, uint8_t flags, uint8_t mask)
 {
-	struct xt_tcp *tcp = nft_tcp_match(ctx, cs);
+	struct xt_tcp *tcp = nft_create_match(ctx, cs, "tcp", true);
 
-	if (!tcp)
+	if (!tcp) {
+		ctx->errmsg = "tcp match extension not found";
 		return;
+	}
 
 	if (op == NFT_CMP_NEQ)
 		tcp->invflags |= XT_TCP_INV_FLAGS;
@@ -1202,7 +1183,6 @@ static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	__u32 burst = nftnl_expr_get_u32(e, NFTNL_EXPR_LIMIT_BURST);
 	__u64 unit = nftnl_expr_get_u64(e, NFTNL_EXPR_LIMIT_UNIT);
 	__u64 rate = nftnl_expr_get_u64(e, NFTNL_EXPR_LIMIT_RATE);
-	struct xtables_match *match;
 	struct xt_rateinfo *rinfo;
 
 	switch (ctx->h->family) {
@@ -1216,18 +1196,14 @@ static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		exit(EXIT_FAILURE);
 	}
 
-	match = nft_create_match(ctx, ctx->cs, "limit", false);
-	if (match == NULL) {
+	rinfo = nft_create_match(ctx, ctx->cs, "limit", false);
+	if (!rinfo) {
 		ctx->errmsg = "limit match extension not found";
 		return;
 	}
 
-	rinfo = (void *)match->m->data;
 	rinfo->avg = XT_LIMIT_SCALE * unit / rate;
 	rinfo->burst = burst;
-
-	if (ctx->h->ops->parse_match != NULL)
-		ctx->h->ops->parse_match(match, ctx->cs);
 }
 
 static void nft_parse_log(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
@@ -1599,7 +1575,6 @@ int nft_parse_hl(struct nft_xt_ctx *ctx,
 		 struct nftnl_expr *e,
 		 struct iptables_command_state *cs)
 {
-	struct xtables_match *match;
 	struct ip6t_hl_info *info;
 	uint8_t hl, mode;
 	int op;
@@ -1642,19 +1617,18 @@ int nft_parse_hl(struct nft_xt_ctx *ctx,
 	 */
 	switch (ctx->h->family) {
 	case NFPROTO_IPV4:
-		match = nft_create_match(ctx, ctx->cs, "ttl", false);
+		info = nft_create_match(ctx, ctx->cs, "ttl", false);
 		break;
 	case NFPROTO_IPV6:
-		match = nft_create_match(ctx, ctx->cs, "hl", false);
+		info = nft_create_match(ctx, ctx->cs, "hl", false);
 		break;
 	default:
 		return -1;
 	}
 
-	if (!match)
+	if (!info)
 		return -1;
 
-	info = (void*)match->m->data;
 	info->hop_limit = hl;
 	info->mode = mode;
 
-- 
2.38.0

