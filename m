Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7749BC7618E
	for <netfilter-devel@archiver.kernel.org>; Fri, 21 Apr 2023 17:40:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233156AbjDURkL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 21 Apr 2023 13:40:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbjDURkK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Apr 2023 13:40:10 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24D613864
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Apr 2023 10:40:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=wCLfagmr/0IHGbagbWgQHERO3yVCdf/D+7f9Pe7YEeA=; b=oCK6Jbuhb9lty1/WQs9Kh2Zgce
        MEBH1teYj3y9c4IvpVkkodjk9YHdNnD1Yt/D4kfsa2bgsedookmDqi5bJxm14xGTEsYfgu/WOEDvK
        6EsCJ1hMWJS8uXvsBci1u3SzFKfm8+hQtq+wjYq7FQ3nHbo4IqjMxO0UrboH01TPFgJMo6UQfSEg6
        u6/1ZFQ+tGtWb2UN1wVdJMb0UD18qDoeAUibuaXD+VGwoAuRHW+pOYq10oXWa3M7+yaw8+HnuIDvw
        DvBdrelkLVGl3Q7D11gBmWqYJReUSo4LwIHL7you41EbP4qFW1TI6e+U355M2qq5sFaPTlgP9x0Bw
        d4laZt6g==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1ppuju-00089P-JT; Fri, 21 Apr 2023 19:40:06 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH 2/3] nft: Extract rule parsing callbacks from nft_family_ops
Date:   Fri, 21 Apr 2023 19:40:13 +0200
Message-Id: <20230421174014.17014-3-phil@nwl.cc>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230421174014.17014-1-phil@nwl.cc>
References: <20230421174014.17014-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce struct nft_ruleparse_ops holding the family-specific
expression parsers and integrate it into nft_family_ops for now.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c       |  9 ++++++---
 iptables/nft-bridge.c    | 18 +++++++++++-------
 iptables/nft-ipv4.c      | 10 +++++++---
 iptables/nft-ipv6.c      | 10 +++++++---
 iptables/nft-ruleparse.c | 24 ++++++++++++------------
 iptables/nft-ruleparse.h | 16 ++++++++++++++++
 iptables/nft-shared.h    | 14 +-------------
 7 files changed, 60 insertions(+), 41 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 8963573a72e9e..7c7122374bb63 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -779,23 +779,26 @@ nft_arp_replace_entry(struct nft_handle *h,
 	return nft_cmd_rule_replace(h, chain, table, cs, rulenum, verbose);
 }
 
+static struct nft_ruleparse_ops nft_ruleparse_ops_arp = {
+	.meta		= nft_arp_parse_meta,
+	.payload	= nft_arp_parse_payload,
+	.target		= nft_ipv46_parse_target,
+};
 struct nft_family_ops nft_family_ops_arp = {
 	.add			= nft_arp_add,
 	.is_same		= nft_arp_is_same,
 	.print_payload		= NULL,
-	.parse_meta		= nft_arp_parse_meta,
-	.parse_payload		= nft_arp_parse_payload,
 	.print_header		= nft_arp_print_header,
 	.print_rule		= nft_arp_print_rule,
 	.save_rule		= nft_arp_save_rule,
 	.save_chain		= nft_arp_save_chain,
+	.rule_parse		= &nft_ruleparse_ops_arp,
 	.cmd_parse		= {
 		.post_parse	= nft_arp_post_parse,
 	},
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.init_cs		= nft_arp_init_cs,
 	.clear_cs		= xtables_clear_iptables_command_state,
-	.parse_target		= nft_ipv46_parse_target,
 	.add_entry		= nft_arp_add_entry,
 	.delete_entry		= nft_arp_delete_entry,
 	.check_entry		= nft_arp_check_entry,
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 22860d6b91a6f..0c9e1238f4c21 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -560,8 +560,8 @@ static void nft_bridge_parse_lookup(struct nft_xt_ctx *ctx,
 		match->m->u.user.revision = match->revision;
 		xs_init_match(match);
 
-		if (ctx->h->ops->parse_match != NULL)
-			ctx->h->ops->parse_match(match, ctx->cs);
+		if (ctx->h->ops->rule_parse->match != NULL)
+			ctx->h->ops->rule_parse->match(match, ctx->cs);
 	}
 	if (!match)
 		return;
@@ -984,15 +984,19 @@ static int nft_bridge_xlate(const struct iptables_command_state *cs,
 	return ret;
 }
 
+static struct nft_ruleparse_ops nft_ruleparse_ops_bridge = {
+	.meta		= nft_bridge_parse_meta,
+	.payload	= nft_bridge_parse_payload,
+	.lookup		= nft_bridge_parse_lookup,
+	.match		= nft_bridge_parse_match,
+	.target		= nft_bridge_parse_target,
+};
+
 struct nft_family_ops nft_family_ops_bridge = {
 	.add			= nft_bridge_add,
 	.is_same		= nft_bridge_is_same,
 	.print_payload		= NULL,
-	.parse_meta		= nft_bridge_parse_meta,
-	.parse_payload		= nft_bridge_parse_payload,
-	.parse_lookup		= nft_bridge_parse_lookup,
-	.parse_match		= nft_bridge_parse_match,
-	.parse_target		= nft_bridge_parse_target,
+	.rule_parse		= &nft_ruleparse_ops_bridge,
 	.print_table_header	= nft_bridge_print_table_header,
 	.print_header		= nft_bridge_print_header,
 	.print_rule		= nft_bridge_print_rule,
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index fadadd2eb9ed6..3f769e88663ac 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -440,21 +440,25 @@ nft_ipv4_replace_entry(struct nft_handle *h,
 	return nft_cmd_rule_replace(h, chain, table, cs, rulenum, verbose);
 }
 
+static struct nft_ruleparse_ops nft_ruleparse_ops_ipv4 = {
+	.meta		= nft_ipv4_parse_meta,
+	.payload	= nft_ipv4_parse_payload,
+	.target		= nft_ipv46_parse_target,
+};
+
 struct nft_family_ops nft_family_ops_ipv4 = {
 	.add			= nft_ipv4_add,
 	.is_same		= nft_ipv4_is_same,
-	.parse_meta		= nft_ipv4_parse_meta,
-	.parse_payload		= nft_ipv4_parse_payload,
 	.set_goto_flag		= nft_ipv4_set_goto_flag,
 	.print_header		= print_header,
 	.print_rule		= nft_ipv4_print_rule,
 	.save_rule		= nft_ipv4_save_rule,
 	.save_chain		= nft_ipv46_save_chain,
+	.rule_parse		= &nft_ruleparse_ops_ipv4,
 	.cmd_parse		= {
 		.proto_parse	= ipv4_proto_parse,
 		.post_parse	= ipv4_post_parse,
 	},
-	.parse_target		= nft_ipv46_parse_target,
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.clear_cs		= xtables_clear_iptables_command_state,
 	.xlate			= nft_ipv4_xlate,
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 85bb683f4862b..962aaf0d13831 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -409,21 +409,25 @@ nft_ipv6_replace_entry(struct nft_handle *h,
 	return nft_cmd_rule_replace(h, chain, table, cs, rulenum, verbose);
 }
 
+static struct nft_ruleparse_ops nft_ruleparse_ops_ipv6 = {
+	.meta		= nft_ipv6_parse_meta,
+	.payload	= nft_ipv6_parse_payload,
+	.target		= nft_ipv46_parse_target,
+};
+
 struct nft_family_ops nft_family_ops_ipv6 = {
 	.add			= nft_ipv6_add,
 	.is_same		= nft_ipv6_is_same,
-	.parse_meta		= nft_ipv6_parse_meta,
-	.parse_payload		= nft_ipv6_parse_payload,
 	.set_goto_flag		= nft_ipv6_set_goto_flag,
 	.print_header		= print_header,
 	.print_rule		= nft_ipv6_print_rule,
 	.save_rule		= nft_ipv6_save_rule,
 	.save_chain		= nft_ipv46_save_chain,
+	.rule_parse		= &nft_ruleparse_ops_ipv6,
 	.cmd_parse		= {
 		.proto_parse	= ipv6_proto_parse,
 		.post_parse	= ipv6_post_parse,
 	},
-	.parse_target		= nft_ipv46_parse_target,
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.clear_cs		= xtables_clear_iptables_command_state,
 	.xlate			= nft_ipv6_xlate,
diff --git a/iptables/nft-ruleparse.c b/iptables/nft-ruleparse.c
index 2d84241a16819..edbbfa40e9c43 100644
--- a/iptables/nft-ruleparse.c
+++ b/iptables/nft-ruleparse.c
@@ -78,8 +78,8 @@ nft_create_match(struct nft_xt_ctx *ctx,
 
 	xs_init_match(match);
 
-	if (ctx->h->ops->parse_match)
-		ctx->h->ops->parse_match(match, cs);
+	if (ctx->h->ops->rule_parse->match)
+		ctx->h->ops->rule_parse->match(match, cs);
 
 	return match->m->data;
 }
@@ -168,7 +168,7 @@ static void nft_parse_meta_set(struct nft_xt_ctx *ctx,
 
 	target->t = t;
 
-	ctx->h->ops->parse_target(target, ctx->cs);
+	ctx->h->ops->rule_parse->target(target, ctx->cs);
 }
 
 static void nft_parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
@@ -488,16 +488,16 @@ static void nft_parse_cmp(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		ctx->errmsg = "cmp sreg undef";
 		break;
 	case NFT_XT_REG_META_DREG:
-		ctx->h->ops->parse_meta(ctx, sreg, e, ctx->cs);
+		ctx->h->ops->rule_parse->meta(ctx, sreg, e, ctx->cs);
 		break;
 	case NFT_XT_REG_PAYLOAD:
 		switch (sreg->payload.base) {
 		case NFT_PAYLOAD_LL_HEADER:
 			if (ctx->h->family == NFPROTO_BRIDGE)
-				ctx->h->ops->parse_payload(ctx, sreg, e, ctx->cs);
+				ctx->h->ops->rule_parse->payload(ctx, sreg, e, ctx->cs);
 			break;
 		case NFT_PAYLOAD_NETWORK_HEADER:
-			ctx->h->ops->parse_payload(ctx, sreg, e, ctx->cs);
+			ctx->h->ops->rule_parse->payload(ctx, sreg, e, ctx->cs);
 			break;
 		case NFT_PAYLOAD_TRANSPORT_HEADER:
 			nft_parse_transport(ctx, e, ctx->cs);
@@ -615,8 +615,8 @@ static void nft_parse_match(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 
 	match->m = m;
 
-	if (ctx->h->ops->parse_match != NULL)
-		ctx->h->ops->parse_match(match, ctx->cs);
+	if (ctx->h->ops->rule_parse->match != NULL)
+		ctx->h->ops->rule_parse->match(match, ctx->cs);
 }
 
 static void nft_parse_target(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
@@ -644,7 +644,7 @@ static void nft_parse_target(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 
 	target->t = t;
 
-	ctx->h->ops->parse_target(target, ctx->cs);
+	ctx->h->ops->rule_parse->target(target, ctx->cs);
 }
 
 static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
@@ -678,8 +678,8 @@ static void nft_parse_limit(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 static void nft_parse_lookup(struct nft_xt_ctx *ctx, struct nft_handle *h,
 			     struct nftnl_expr *e)
 {
-	if (ctx->h->ops->parse_lookup)
-		ctx->h->ops->parse_lookup(ctx, e);
+	if (ctx->h->ops->rule_parse->lookup)
+		ctx->h->ops->rule_parse->lookup(ctx, e);
 }
 
 static void nft_parse_log(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
@@ -729,7 +729,7 @@ static void nft_parse_log(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 
 	memcpy(&target->t->data, &info, sizeof(info));
 
-	ctx->h->ops->parse_target(target, ctx->cs);
+	ctx->h->ops->rule_parse->target(target, ctx->cs);
 }
 
 static void nft_parse_udp_range(struct nft_xt_ctx *ctx,
diff --git a/iptables/nft-ruleparse.h b/iptables/nft-ruleparse.h
index 7fac6c7969645..69e98817bb6e1 100644
--- a/iptables/nft-ruleparse.h
+++ b/iptables/nft-ruleparse.h
@@ -93,6 +93,22 @@ static inline struct nft_xt_ctx_reg *nft_xt_ctx_get_dreg(struct nft_xt_ctx *ctx,
 	return r;
 }
 
+struct nft_ruleparse_ops {
+	void (*meta)(struct nft_xt_ctx *ctx,
+		     const struct nft_xt_ctx_reg *sreg,
+		     struct nftnl_expr *e,
+		     struct iptables_command_state *cs);
+	void (*payload)(struct nft_xt_ctx *ctx,
+			const struct nft_xt_ctx_reg *sreg,
+			struct nftnl_expr *e,
+			struct iptables_command_state *cs);
+	void (*lookup)(struct nft_xt_ctx *ctx, struct nftnl_expr *e);
+	void (*match)(struct xtables_match *m,
+		      struct iptables_command_state *cs);
+	void (*target)(struct xtables_target *t,
+		       struct iptables_command_state *cs);
+};
+
 void *nft_create_match(struct nft_xt_ctx *ctx,
 		       struct iptables_command_state *cs,
 		       const char *name, bool reuse);
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 2edee64920e8b..a06b263d77c1d 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -46,15 +46,6 @@ struct nft_family_ops {
 			const struct iptables_command_state *cs_b);
 	void (*print_payload)(struct nftnl_expr *e,
 			      struct nftnl_expr_iter *iter);
-	void (*parse_meta)(struct nft_xt_ctx *ctx,
-			   const struct nft_xt_ctx_reg *sreg,
-			   struct nftnl_expr *e,
-			   struct iptables_command_state *cs);
-	void (*parse_payload)(struct nft_xt_ctx *ctx,
-			      const struct nft_xt_ctx_reg *sreg,
-			      struct nftnl_expr *e,
-			      struct iptables_command_state *cs);
-	void (*parse_lookup)(struct nft_xt_ctx *ctx, struct nftnl_expr *e);
 	void (*set_goto_flag)(struct iptables_command_state *cs);
 
 	void (*print_table_header)(const char *tablename);
@@ -67,11 +58,8 @@ struct nft_family_ops {
 	void (*save_rule)(const struct iptables_command_state *cs,
 			  unsigned int format);
 	void (*save_chain)(const struct nftnl_chain *c, const char *policy);
+	struct nft_ruleparse_ops *rule_parse;
 	struct xt_cmd_parse_ops cmd_parse;
-	void (*parse_match)(struct xtables_match *m,
-			    struct iptables_command_state *cs);
-	void (*parse_target)(struct xtables_target *t,
-			     struct iptables_command_state *cs);
 	void (*init_cs)(struct iptables_command_state *cs);
 	bool (*rule_to_cs)(struct nft_handle *h, const struct nftnl_rule *r,
 			   struct iptables_command_state *cs);
-- 
2.40.0

