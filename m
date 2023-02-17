Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2B4CC6379F
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Feb 2023 13:46:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbjBQNqo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Feb 2023 08:46:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229978AbjBQNqj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Feb 2023 08:46:39 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C7320D13
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Feb 2023 05:46:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=oQ0Wsg4FK/x8iKjwNwZmNIX+kJmlW8fkhOwhq/kBGEU=; b=DLaFsXnLpNHDmGlGHh6wqsrxx5
        LHPmWWCG3CVY7csqUluvROU27H6PX973r6xwbtlkZH/xtjBaFDPta9SzelZkkHvkd0YsyVLswID1z
        a/E25Tqwcxqe4Mly/lfHARSbGipSEvnTsddZSfcnwt+hMxxsiCcgI3QejvJq8+jCZl/UzYhB+pyro
        skALbm1W9xamLxQnbqiqdGcd1JriRmF/jRj0Ds1rx/QqyUMe9wHIMLYVGUV5KHMThXLjuKu+yeJTx
        bWf6f2eiicYgEVJOrAic2Pl3til3fq0cYbg6gqTmz9wk8kmuKfGxyOmagzcvvmsZFaZfyWTsjzMH0
        yxJuV3fw==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1pT13x-0001uG-Bh
        for netfilter-devel@vger.kernel.org; Fri, 17 Feb 2023 14:46:09 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/3] nft-shared: Lookup matches in iptables_command_state
Date:   Fri, 17 Feb 2023 14:45:58 +0100
Message-Id: <20230217134600.14433-1-phil@nwl.cc>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Some matches may turn into multiple nft statements (naturally or via
translation). Such statements must parse into a single extension again
in order to rebuild the rule as it was.

Introduce nft_find_match_in_cs() to iterate through the lists and drop
tcp/udp port match caching in struct nft_xt_ctx which is not needed
anymore.

Note: Match reuse is not enabled unconditionally for all matches,
because iptables supports having multiple instances of the same
extension.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.c | 70 +++++++++++++++++++++++++------------------
 iptables/nft-shared.h |  4 ---
 2 files changed, 41 insertions(+), 33 deletions(-)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 4a7b5406892c4..df3cc6ac994cf 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -304,7 +304,7 @@ static void parse_ifname(const char *name, unsigned int len, char *dst, unsigned
 static struct xtables_match *
 nft_create_match(struct nft_xt_ctx *ctx,
 		 struct iptables_command_state *cs,
-		 const char *name);
+		 const char *name, bool reuse);
 
 static uint32_t get_meta_mask(struct nft_xt_ctx *ctx, enum nft_registers sreg)
 {
@@ -322,7 +322,7 @@ static int parse_meta_mark(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	struct xtables_match *match;
 	uint32_t value;
 
-	match = nft_create_match(ctx, ctx->cs, "mark");
+	match = nft_create_match(ctx, ctx->cs, "mark", false);
 	if (!match)
 		return -1;
 
@@ -344,7 +344,7 @@ static int parse_meta_pkttype(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	struct xtables_match *match;
 	uint8_t value;
 
-	match = nft_create_match(ctx, ctx->cs, "pkttype");
+	match = nft_create_match(ctx, ctx->cs, "pkttype", false);
 	if (!match)
 		return -1;
 
@@ -641,15 +641,39 @@ static void nft_parse_bitwise(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	dreg->bitwise.set = true;
 }
 
+static struct xtables_match *
+nft_find_match_in_cs(struct iptables_command_state *cs, const char *name)
+{
+	struct xtables_rule_match *rm;
+	struct ebt_match *ebm;
+
+	for (ebm = cs->match_list; ebm; ebm = ebm->next) {
+		if (ebm->ismatch &&
+		    !strcmp(ebm->u.match->m->u.user.name, name))
+			return ebm->u.match;
+	}
+	for (rm = cs->matches; rm; rm = rm->next) {
+		if (!strcmp(rm->match->m->u.user.name, name))
+			return rm->match;
+	}
+	return NULL;
+}
+
 static struct xtables_match *
 nft_create_match(struct nft_xt_ctx *ctx,
 		 struct iptables_command_state *cs,
-		 const char *name)
+		 const char *name, bool reuse)
 {
 	struct xtables_match *match;
 	struct xt_entry_match *m;
 	unsigned int size;
 
+	if (reuse) {
+		match = nft_find_match_in_cs(cs, name);
+		if (match)
+			return match;
+	}
+
 	match = xtables_find_match(name, XTF_TRY_LOAD,
 				   &cs->matches);
 	if (!match)
@@ -671,38 +695,26 @@ nft_create_match(struct nft_xt_ctx *ctx,
 static struct xt_udp *nft_udp_match(struct nft_xt_ctx *ctx,
 			            struct iptables_command_state *cs)
 {
-	struct xt_udp *udp = ctx->tcpudp.udp;
 	struct xtables_match *match;
 
-	if (!udp) {
-		match = nft_create_match(ctx, cs, "udp");
-		if (!match)
-			return NULL;
-
-		udp = (void*)match->m->data;
-		ctx->tcpudp.udp = udp;
-	}
+	match = nft_create_match(ctx, cs, "udp", true);
+	if (!match)
+		return NULL;
 
-	return udp;
+	return (struct xt_udp *)match->m->data;
 }
 
 static struct xt_tcp *nft_tcp_match(struct nft_xt_ctx *ctx,
 			            struct iptables_command_state *cs)
 {
-	struct xt_tcp *tcp = ctx->tcpudp.tcp;
 	struct xtables_match *match;
 
-	if (!tcp) {
-		match = nft_create_match(ctx, cs, "tcp");
-		if (!match) {
-			ctx->errmsg = "tcp match extension not found";
-			return NULL;
-		}
-		tcp = (void*)match->m->data;
-		ctx->tcpudp.tcp = tcp;
+	match = nft_create_match(ctx, cs, "tcp", true);
+	if (!match) {
+		ctx->errmsg = "tcp match extension not found";
+		return NULL;
 	}
-
-	return tcp;
+	return (struct xt_tcp *)match->m->data;
 }
 
 static void nft_parse_udp_range(struct nft_xt_ctx *ctx,
@@ -872,14 +884,14 @@ static void nft_parse_icmp(struct nft_xt_ctx *ctx,
 
 	switch (ctx->h->family) {
 	case NFPROTO_IPV4:
-		match = nft_create_match(ctx, cs, "icmp");
+		match = nft_create_match(ctx, cs, "icmp", false);
 		break;
 	case NFPROTO_IPV6:
 		if (icmp.type == UINT8_MAX) {
 			ctx->errmsg = "icmp6 code with any type match not supported";
 			return;
 		}
-		match = nft_create_match(ctx, cs, "icmp6");
+		match = nft_create_match(ctx, cs, "icmp6", false);
 		break;
 	default:
 		ctx->errmsg = "unexpected family for icmp match";
@@ -1640,10 +1652,10 @@ int nft_parse_hl(struct nft_xt_ctx *ctx,
 	 */
 	switch (ctx->h->family) {
 	case NFPROTO_IPV4:
-		match = nft_create_match(ctx, ctx->cs, "ttl");
+		match = nft_create_match(ctx, ctx->cs, "ttl", false);
 		break;
 	case NFPROTO_IPV6:
-		match = nft_create_match(ctx, ctx->cs, "hl");
+		match = nft_create_match(ctx, ctx->cs, "hl", false);
 		break;
 	default:
 		return -1;
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 07d39131cb0d6..b8bc1a6ce2e93 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -76,10 +76,6 @@ struct nft_xt_ctx {
 	struct nft_handle *h;
 	uint32_t flags;
 	const char *table;
-	union {
-		struct xt_tcp *tcp;
-		struct xt_udp *udp;
-	} tcpudp;
 
 	struct nft_xt_ctx_reg regs[1 + 16];
 
-- 
2.38.0

