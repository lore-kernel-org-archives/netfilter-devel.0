Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D99DFC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Mar 2022 15:18:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243423AbiCBPTR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Mar 2022 10:19:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233839AbiCBPTP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Mar 2022 10:19:15 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8388C21803
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Mar 2022 07:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+tHNBkBBprRYgMd4KCz3xgIRZutJ9oDTo2Dnw2fiee0=; b=QKm5grtTHwaSeSaltoyj4FavmB
        +2fyun1XK75g2XydnADNQuFPjMGmugHtTwq8UBJX0FXeANiakF0yK4nTMrA2F2UTBgiaKOY9eEjNp
        IEWgEl7DGLDsibIgzcbhhkZoh5HvDJI5upTtfyg5uAXyBcVV/2YmCSnuPcpIsLeL0P1fLaIztHIfF
        GifpU0onXYF2Q0tCDyBQvDUaza3BIXpSyWkrFOVWwqqciOB8SAc/xgjf2OiYuj7ISBVm0+/36xpIu
        U4aeG7YvDsgFYKydzMEyOdadyaodVFVzuLsFDaZ8b2C50cDQCYezMMR391n+9H74BFoVISXc8011E
        qtdlP6Fg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nPQkH-00034u-Ua; Wed, 02 Mar 2022 16:18:30 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/4] nft: Don't pass command state opaque to family ops callbacks
Date:   Wed,  2 Mar 2022 16:18:07 +0100
Message-Id: <20220302151807.12185-5-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220302151807.12185-1-phil@nwl.cc>
References: <20220302151807.12185-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There are no family-specific versions of struct iptables_command_state
anymore, so no need to hide it behind void pointer. Pass the type as-is
and save a few casts.

While at it, drop unused callbacks parse_bitwise and parse_cmp.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c    | 23 ++++++++++------------
 iptables/nft-bridge.c | 45 +++++++++++++++++++++----------------------
 iptables/nft-ipv4.c   | 28 +++++++++++----------------
 iptables/nft-ipv6.c   | 28 +++++++++++----------------
 iptables/nft-shared.c | 23 ++++++++++------------
 iptables/nft-shared.h | 33 ++++++++++++++++---------------
 iptables/nft.c        |  4 ++--
 iptables/nft.h        |  2 +-
 8 files changed, 84 insertions(+), 102 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 78509ce9d87e8..028b06a608e4e 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -54,9 +54,9 @@ static bool need_devaddr(struct arpt_devaddr_info *info)
 	return false;
 }
 
-static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
+static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r,
+		       struct iptables_command_state *cs)
 {
-	struct iptables_command_state *cs = data;
 	struct arpt_entry *fw = &cs->arp;
 	uint32_t op;
 	int ret = 0;
@@ -169,9 +169,8 @@ static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
 }
 
 static void nft_arp_parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
-			       void *data)
+			       struct iptables_command_state *cs)
 {
-	struct iptables_command_state *cs = data;
 	struct arpt_entry *fw = &cs->arp;
 	uint8_t flags = 0;
 
@@ -213,9 +212,9 @@ static bool nft_arp_parse_devaddr(struct nft_xt_ctx *ctx,
 }
 
 static void nft_arp_parse_payload(struct nft_xt_ctx *ctx,
-				  struct nftnl_expr *e, void *data)
+				  struct nftnl_expr *e,
+				  struct iptables_command_state *cs)
 {
-	struct iptables_command_state *cs = data;
 	struct arpt_entry *fw = &cs->arp;
 	struct in_addr addr;
 	uint16_t ar_hrd, ar_pro, ar_op;
@@ -464,10 +463,8 @@ after_devdst:
 }
 
 static void
-nft_arp_save_rule(const void *data, unsigned int format)
+nft_arp_save_rule(const struct iptables_command_state *cs, unsigned int format)
 {
-	const struct iptables_command_state *cs = data;
-
 	format |= FMT_NUMERIC;
 
 	printf(" ");
@@ -504,11 +501,11 @@ nft_arp_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 	nft_clear_iptables_command_state(&cs);
 }
 
-static bool nft_arp_is_same(const void *data_a,
-			    const void *data_b)
+static bool nft_arp_is_same(const struct iptables_command_state *cs_a,
+			    const struct iptables_command_state *cs_b)
 {
-	const struct arpt_entry *a = data_a;
-	const struct arpt_entry *b = data_b;
+	const struct arpt_entry *a = &cs_a->arp;
+	const struct arpt_entry *b = &cs_b->arp;
 
 	if (a->arp.src.s_addr != b->arp.src.s_addr
 	    || a->arp.tgt.s_addr != b->arp.tgt.s_addr
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index d342858e1d9d8..d4b66a25c740e 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -97,9 +97,9 @@ static int _add_action(struct nftnl_rule *r, struct iptables_command_state *cs)
 }
 
 static int nft_bridge_add(struct nft_handle *h,
-			  struct nftnl_rule *r, void *data)
+			  struct nftnl_rule *r,
+			  struct iptables_command_state *cs)
 {
-	struct iptables_command_state *cs = data;
 	struct ebt_match *iter;
 	struct ebt_entry *fw = &cs->eb;
 	uint32_t op;
@@ -164,9 +164,9 @@ static int nft_bridge_add(struct nft_handle *h,
 }
 
 static void nft_bridge_parse_meta(struct nft_xt_ctx *ctx,
-				  struct nftnl_expr *e, void *data)
+				  struct nftnl_expr *e,
+				  struct iptables_command_state *cs)
 {
-	struct iptables_command_state *cs = data;
 	struct ebt_entry *fw = &cs->eb;
 	uint8_t invflags = 0;
 	char iifname[IFNAMSIZ] = {}, oifname[IFNAMSIZ] = {};
@@ -200,9 +200,9 @@ static void nft_bridge_parse_meta(struct nft_xt_ctx *ctx,
 }
 
 static void nft_bridge_parse_payload(struct nft_xt_ctx *ctx,
-				     struct nftnl_expr *e, void *data)
+				     struct nftnl_expr *e,
+				     struct iptables_command_state *cs)
 {
-	struct iptables_command_state *cs = data;
 	struct ebt_entry *fw = &cs->eb;
 	unsigned char addr[ETH_ALEN];
 	unsigned short int ethproto;
@@ -397,7 +397,7 @@ static struct nftnl_set *set_from_lookup_expr(struct nft_xt_ctx *ctx,
 }
 
 static void nft_bridge_parse_lookup(struct nft_xt_ctx *ctx,
-				    struct nftnl_expr *e, void *data)
+				    struct nftnl_expr *e)
 {
 	struct xtables_match *match = NULL;
 	struct nft_among_data *among_data;
@@ -483,17 +483,15 @@ static void parse_watcher(void *object, struct ebt_match **match_list,
 		(*match_list)->next = m;
 }
 
-static void nft_bridge_parse_match(struct xtables_match *m, void *data)
+static void nft_bridge_parse_match(struct xtables_match *m,
+				   struct iptables_command_state *cs)
 {
-	struct iptables_command_state *cs = data;
-
 	parse_watcher(m, &cs->match_list, true);
 }
 
-static void nft_bridge_parse_target(struct xtables_target *t, void *data)
+static void nft_bridge_parse_target(struct xtables_target *t,
+				    struct iptables_command_state *cs)
 {
-	struct iptables_command_state *cs = data;
-
 	/* harcoded names :-( */
 	if (strcmp(t->name, "log") == 0 ||
 	    strcmp(t->name, "nflog") == 0) {
@@ -594,10 +592,9 @@ static void print_protocol(uint16_t ethproto, bool invert, unsigned int bitmask)
 		printf("%s ", ent->e_name);
 }
 
-static void __nft_bridge_save_rule(const void *data, unsigned int format)
+static void __nft_bridge_save_rule(const struct iptables_command_state *cs,
+				   unsigned int format)
 {
-	const struct iptables_command_state *cs = data;
-
 	if (cs->eb.ethproto)
 		print_protocol(cs->eb.ethproto, cs->eb.invflags & EBT_IPROTO,
 			       cs->eb.bitmask);
@@ -645,10 +642,11 @@ static void __nft_bridge_save_rule(const void *data, unsigned int format)
 		fputc('\n', stdout);
 }
 
-static void nft_bridge_save_rule(const void *data, unsigned int format)
+static void nft_bridge_save_rule(const struct iptables_command_state *cs,
+				 unsigned int format)
 {
 	printf(" ");
-	__nft_bridge_save_rule(data, format);
+	__nft_bridge_save_rule(cs, format);
 }
 
 static void nft_bridge_print_rule(struct nft_handle *h, struct nftnl_rule *r,
@@ -672,10 +670,11 @@ static void nft_bridge_save_chain(const struct nftnl_chain *c,
 	printf(":%s %s\n", chain, policy ?: "ACCEPT");
 }
 
-static bool nft_bridge_is_same(const void *data_a, const void *data_b)
+static bool nft_bridge_is_same(const struct iptables_command_state *cs_a,
+			       const struct iptables_command_state *cs_b)
 {
-	const struct ebt_entry *a = data_a;
-	const struct ebt_entry *b = data_b;
+	const struct ebt_entry *a = &cs_a->eb;
+	const struct ebt_entry *b = &cs_b->eb;
 	int i;
 
 	if (a->ethproto != b->ethproto ||
@@ -821,9 +820,9 @@ static void nft_bridge_xlate_mac(struct xt_xlate *xl, const char *type, bool inv
 	xt_xlate_add(xl, " ");
 }
 
-static int nft_bridge_xlate(const void *data, struct xt_xlate *xl)
+static int nft_bridge_xlate(const struct iptables_command_state *cs,
+			    struct xt_xlate *xl)
 {
-	const struct iptables_command_state *cs = data;
 	int ret;
 
 	xlate_ifname(xl, "iifname", cs->eb.in,
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index bdb105f8eb683..af3d0c98b7989 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -26,9 +26,9 @@
 #include "nft.h"
 #include "nft-shared.h"
 
-static int nft_ipv4_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
+static int nft_ipv4_add(struct nft_handle *h, struct nftnl_rule *r,
+			struct iptables_command_state *cs)
 {
-	struct iptables_command_state *cs = data;
 	struct xtables_rule_match *matchp;
 	uint32_t op;
 	int ret;
@@ -93,12 +93,9 @@ static int nft_ipv4_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
 	return add_action(r, cs, !!(cs->fw.ip.flags & IPT_F_GOTO));
 }
 
-static bool nft_ipv4_is_same(const void *data_a,
-			     const void *data_b)
+static bool nft_ipv4_is_same(const struct iptables_command_state *a,
+			     const struct iptables_command_state *b)
 {
-	const struct iptables_command_state *a = data_a;
-	const struct iptables_command_state *b = data_b;
-
 	if (a->fw.ip.src.s_addr != b->fw.ip.src.s_addr
 	    || a->fw.ip.dst.s_addr != b->fw.ip.dst.s_addr
 	    || a->fw.ip.smsk.s_addr != b->fw.ip.smsk.s_addr
@@ -135,10 +132,8 @@ static void get_frag(struct nft_xt_ctx *ctx, struct nftnl_expr *e, bool *inv)
 }
 
 static void nft_ipv4_parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
-				void *data)
+				struct iptables_command_state *cs)
 {
-	struct iptables_command_state *cs = data;
-
 	switch (ctx->meta.key) {
 	case NFT_META_L4PROTO:
 		cs->fw.ip.proto = nftnl_expr_get_u8(e, NFTNL_EXPR_CMP_DATA);
@@ -160,9 +155,9 @@ static void parse_mask_ipv4(struct nft_xt_ctx *ctx, struct in_addr *mask)
 }
 
 static void nft_ipv4_parse_payload(struct nft_xt_ctx *ctx,
-				   struct nftnl_expr *e, void *data)
+				   struct nftnl_expr *e,
+				   struct iptables_command_state *cs)
 {
-	struct iptables_command_state *cs = data;
 	struct in_addr addr;
 	uint8_t proto;
 	bool inv;
@@ -250,10 +245,9 @@ static void nft_ipv4_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 	nft_clear_iptables_command_state(&cs);
 }
 
-static void nft_ipv4_save_rule(const void *data, unsigned int format)
+static void nft_ipv4_save_rule(const struct iptables_command_state *cs,
+			       unsigned int format)
 {
-	const struct iptables_command_state *cs = data;
-
 	save_ipv4_addr('s', &cs->fw.ip.src, &cs->fw.ip.smsk,
 		       cs->fw.ip.invflags & IPT_INV_SRCIP);
 	save_ipv4_addr('d', &cs->fw.ip.dst, &cs->fw.ip.dmsk,
@@ -296,9 +290,9 @@ static void xlate_ipv4_addr(const char *selector, const struct in_addr *addr,
 	}
 }
 
-static int nft_ipv4_xlate(const void *data, struct xt_xlate *xl)
+static int nft_ipv4_xlate(const struct iptables_command_state *cs,
+			  struct xt_xlate *xl)
 {
-	const struct iptables_command_state *cs = data;
 	const char *comment;
 	int ret;
 
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index a5323171bb4bb..892a485415933 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -25,9 +25,9 @@
 #include "nft.h"
 #include "nft-shared.h"
 
-static int nft_ipv6_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
+static int nft_ipv6_add(struct nft_handle *h, struct nftnl_rule *r,
+			struct iptables_command_state *cs)
 {
-	struct iptables_command_state *cs = data;
 	struct xtables_rule_match *matchp;
 	uint32_t op;
 	int ret;
@@ -82,12 +82,9 @@ static int nft_ipv6_add(struct nft_handle *h, struct nftnl_rule *r, void *data)
 	return add_action(r, cs, !!(cs->fw6.ipv6.flags & IP6T_F_GOTO));
 }
 
-static bool nft_ipv6_is_same(const void *data_a,
-			     const void *data_b)
+static bool nft_ipv6_is_same(const struct iptables_command_state *a,
+			     const struct iptables_command_state *b)
 {
-	const struct iptables_command_state *a = data_a;
-	const struct iptables_command_state *b = data_b;
-
 	if (memcmp(a->fw6.ipv6.src.s6_addr, b->fw6.ipv6.src.s6_addr,
 		   sizeof(struct in6_addr)) != 0
 	    || memcmp(a->fw6.ipv6.dst.s6_addr, b->fw6.ipv6.dst.s6_addr,
@@ -108,10 +105,8 @@ static bool nft_ipv6_is_same(const void *data_a,
 }
 
 static void nft_ipv6_parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
-				void *data)
+				struct iptables_command_state *cs)
 {
-	struct iptables_command_state *cs = data;
-
 	switch (ctx->meta.key) {
 	case NFT_META_L4PROTO:
 		cs->fw6.ipv6.proto = nftnl_expr_get_u8(e, NFTNL_EXPR_CMP_DATA);
@@ -133,9 +128,9 @@ static void parse_mask_ipv6(struct nft_xt_ctx *ctx, struct in6_addr *mask)
 }
 
 static void nft_ipv6_parse_payload(struct nft_xt_ctx *ctx,
-				   struct nftnl_expr *e, void *data)
+				   struct nftnl_expr *e,
+				   struct iptables_command_state *cs)
 {
-	struct iptables_command_state *cs = data;
 	struct in6_addr addr;
 	uint8_t proto;
 	bool inv;
@@ -213,10 +208,9 @@ static void nft_ipv6_print_rule(struct nft_handle *h, struct nftnl_rule *r,
 	nft_clear_iptables_command_state(&cs);
 }
 
-static void nft_ipv6_save_rule(const void *data, unsigned int format)
+static void nft_ipv6_save_rule(const struct iptables_command_state *cs,
+			       unsigned int format)
 {
-	const struct iptables_command_state *cs = data;
-
 	save_ipv6_addr('s', &cs->fw6.ipv6.src, &cs->fw6.ipv6.smsk,
 		       cs->fw6.ipv6.invflags & IP6T_INV_SRCIP);
 	save_ipv6_addr('d', &cs->fw6.ipv6.dst, &cs->fw6.ipv6.dmsk,
@@ -257,9 +251,9 @@ static void xlate_ipv6_addr(const char *selector, const struct in6_addr *addr,
 	}
 }
 
-static int nft_ipv6_xlate(const void *data, struct xt_xlate *xl)
+static int nft_ipv6_xlate(const struct iptables_command_state *cs,
+			  struct xt_xlate *xl)
 {
-	const struct iptables_command_state *cs = data;
 	const char *comment;
 	int ret;
 
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 861aa0642061e..c57218542c964 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -319,7 +319,6 @@ static void nft_parse_target(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	struct xtables_target *target;
 	struct xt_entry_target *t;
 	size_t size;
-	void *data = ctx->cs;
 
 	target = xtables_find_target(targname, XTF_TRY_LOAD);
 	if (target == NULL)
@@ -335,7 +334,7 @@ static void nft_parse_target(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 
 	target->t = t;
 
-	ctx->h->ops->parse_target(target, data);
+	ctx->h->ops->parse_target(target, ctx->cs);
 }
 
 static void nft_parse_match(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
@@ -767,9 +766,9 @@ static void nft_parse_tcp_flags(struct nft_xt_ctx *ctx,
 }
 
 static void nft_parse_transport(struct nft_xt_ctx *ctx,
-				struct nftnl_expr *e, void *data)
+				struct nftnl_expr *e,
+				struct iptables_command_state *cs)
 {
-	struct iptables_command_state *cs = data;
 	uint32_t sdport;
 	uint16_t port;
 	uint8_t proto, op;
@@ -869,7 +868,6 @@ static void nft_parse_transport_range(struct nft_xt_ctx *ctx,
 
 static void nft_parse_cmp(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 {
-	void *data = ctx->cs;
 	uint32_t reg;
 
 	reg = nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_SREG);
@@ -877,7 +875,7 @@ static void nft_parse_cmp(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		return;
 
 	if (ctx->flags & NFT_XT_CTX_META) {
-		ctx->h->ops->parse_meta(ctx, e, data);
+		ctx->h->ops->parse_meta(ctx, e, ctx->cs);
 		ctx->flags &= ~NFT_XT_CTX_META;
 	}
 	/* bitwise context is interpreted from payload */
@@ -885,13 +883,13 @@ static void nft_parse_cmp(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 		switch (ctx->payload.base) {
 		case NFT_PAYLOAD_LL_HEADER:
 			if (ctx->h->family == NFPROTO_BRIDGE)
-				ctx->h->ops->parse_payload(ctx, e, data);
+				ctx->h->ops->parse_payload(ctx, e, ctx->cs);
 			break;
 		case NFT_PAYLOAD_NETWORK_HEADER:
-			ctx->h->ops->parse_payload(ctx, e, data);
+			ctx->h->ops->parse_payload(ctx, e, ctx->cs);
 			break;
 		case NFT_PAYLOAD_TRANSPORT_HEADER:
-			nft_parse_transport(ctx, e, data);
+			nft_parse_transport(ctx, e, ctx->cs);
 			break;
 		}
 	}
@@ -1055,7 +1053,7 @@ static void nft_parse_lookup(struct nft_xt_ctx *ctx, struct nft_handle *h,
 			     struct nftnl_expr *e)
 {
 	if (ctx->h->ops->parse_lookup)
-		ctx->h->ops->parse_lookup(ctx, e, NULL);
+		ctx->h->ops->parse_lookup(ctx, e);
 }
 
 static void nft_parse_range(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
@@ -1319,10 +1317,9 @@ bool compare_targets(struct xtables_target *tg1, struct xtables_target *tg2)
 	return true;
 }
 
-void nft_ipv46_parse_target(struct xtables_target *t, void *data)
+void nft_ipv46_parse_target(struct xtables_target *t,
+			    struct iptables_command_state *cs)
 {
-	struct iptables_command_state *cs = data;
-
 	cs->target = t;
 	cs->jumpto = t->name;
 }
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 04b1d97f950d5..7b337943836a4 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -78,21 +78,17 @@ struct nft_xt_ctx {
 };
 
 struct nft_family_ops {
-	int (*add)(struct nft_handle *h, struct nftnl_rule *r, void *data);
-	bool (*is_same)(const void *data_a,
-			const void *data_b);
+	int (*add)(struct nft_handle *h, struct nftnl_rule *r,
+		   struct iptables_command_state *cs);
+	bool (*is_same)(const struct iptables_command_state *cs_a,
+			const struct iptables_command_state *cs_b);
 	void (*print_payload)(struct nftnl_expr *e,
 			      struct nftnl_expr_iter *iter);
 	void (*parse_meta)(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
-			   void *data);
+			   struct iptables_command_state *cs);
 	void (*parse_payload)(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
-			      void *data);
-	void (*parse_bitwise)(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
-			      void *data);
-	void (*parse_cmp)(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
-			  void *data);
-	void (*parse_lookup)(struct nft_xt_ctx *ctx, struct nftnl_expr *e,
-			     void *data);
+			      struct iptables_command_state *cs);
+	void (*parse_lookup)(struct nft_xt_ctx *ctx, struct nftnl_expr *e);
 	void (*set_goto_flag)(struct iptables_command_state *cs);
 
 	void (*print_table_header)(const char *tablename);
@@ -102,16 +98,20 @@ struct nft_family_ops {
 			     int refs, uint32_t entries);
 	void (*print_rule)(struct nft_handle *h, struct nftnl_rule *r,
 			   unsigned int num, unsigned int format);
-	void (*save_rule)(const void *data, unsigned int format);
+	void (*save_rule)(const struct iptables_command_state *cs,
+			  unsigned int format);
 	void (*save_chain)(const struct nftnl_chain *c, const char *policy);
 	struct xt_cmd_parse_ops cmd_parse;
-	void (*parse_match)(struct xtables_match *m, void *data);
-	void (*parse_target)(struct xtables_target *t, void *data);
+	void (*parse_match)(struct xtables_match *m,
+			    struct iptables_command_state *cs);
+	void (*parse_target)(struct xtables_target *t,
+			     struct iptables_command_state *cs);
 	void (*init_cs)(struct iptables_command_state *cs);
 	void (*rule_to_cs)(struct nft_handle *h, const struct nftnl_rule *r,
 			   struct iptables_command_state *cs);
 	void (*clear_cs)(struct iptables_command_state *cs);
-	int (*xlate)(const void *data, struct xt_xlate *xl);
+	int (*xlate)(const struct iptables_command_state *cs,
+		     struct xt_xlate *xl);
 	int (*add_entry)(struct nft_handle *h,
 			 const char *chain, const char *table,
 			 struct iptables_command_state *cs,
@@ -173,7 +173,8 @@ void save_matches_and_target(const struct iptables_command_state *cs,
 
 struct nft_family_ops *nft_family_ops_lookup(int family);
 
-void nft_ipv46_parse_target(struct xtables_target *t, void *data);
+void nft_ipv46_parse_target(struct xtables_target *t,
+			    struct iptables_command_state *cs);
 
 bool compare_matches(struct xtables_rule_match *mt1, struct xtables_rule_match *mt2);
 bool compare_targets(struct xtables_target *tg1, struct xtables_target *tg2);
diff --git a/iptables/nft.c b/iptables/nft.c
index d011d7c88da12..6883662fa28d2 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1648,7 +1648,7 @@ void add_compat(struct nftnl_rule *r, uint32_t proto, bool inv)
 
 struct nftnl_rule *
 nft_rule_new(struct nft_handle *h, const char *chain, const char *table,
-	     void *data)
+	     struct iptables_command_state *cs)
 {
 	struct nftnl_rule *r;
 
@@ -1660,7 +1660,7 @@ nft_rule_new(struct nft_handle *h, const char *chain, const char *table,
 	nftnl_rule_set_str(r, NFTNL_RULE_TABLE, table);
 	nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, chain);
 
-	if (h->ops->add(h, r, data) < 0)
+	if (h->ops->add(h, r, cs) < 0)
 		goto err;
 
 	return r;
diff --git a/iptables/nft.h b/iptables/nft.h
index fd116c2e3e198..68b0910c8e182 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -173,7 +173,7 @@ struct nftnl_set *nft_set_batch_lookup_byid(struct nft_handle *h,
  */
 struct nftnl_rule;
 
-struct nftnl_rule *nft_rule_new(struct nft_handle *h, const char *chain, const char *table, void *data);
+struct nftnl_rule *nft_rule_new(struct nft_handle *h, const char *chain, const char *table, struct iptables_command_state *cs);
 int nft_rule_append(struct nft_handle *h, const char *chain, const char *table, struct nftnl_rule *r, struct nftnl_rule *ref, bool verbose);
 int nft_rule_insert(struct nft_handle *h, const char *chain, const char *table, struct nftnl_rule *r, int rulenum, bool verbose);
 int nft_rule_check(struct nft_handle *h, const char *chain, const char *table, struct nftnl_rule *r, bool verbose);
-- 
2.34.1

