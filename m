Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72FB7C433FE
	for <netfilter-devel@archiver.kernel.org>; Sun, 24 Apr 2022 21:56:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239691AbiDXV71 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 24 Apr 2022 17:59:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239693AbiDXV70 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 24 Apr 2022 17:59:26 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 313903969D
        for <netfilter-devel@vger.kernel.org>; Sun, 24 Apr 2022 14:56:23 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH iptables 3/7] nft: native mark matching support
Date:   Sun, 24 Apr 2022 23:56:09 +0200
Message-Id: <20220424215613.106165-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220424215613.106165-1-pablo@netfilter.org>
References: <20220424215613.106165-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use meta mark + bitwise + cmp instead of nft_compat mark match.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-shared.c | 36 ++++++++++++++++++++++++++++++++++++
 iptables/nft.c        | 23 +++++++++++++++++++++++
 2 files changed, 59 insertions(+)

diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 5b13b29c9844..54a911801639 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -24,6 +24,7 @@
 #include <linux/netfilter/xt_comment.h>
 #include <linux/netfilter/xt_limit.h>
 #include <linux/netfilter/xt_NFLOG.h>
+#include <linux/netfilter/xt_mark.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/rule.h>
@@ -261,6 +262,38 @@ static void parse_ifname(const char *name, unsigned int len, char *dst, unsigned
 		memset(mask, 0xff, len - 2);
 }
 
+static struct xtables_match *
+nft_create_match(struct nft_xt_ctx *ctx,
+		 struct iptables_command_state *cs,
+		 const char *name);
+
+static int parse_meta_mark(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
+{
+	struct xt_mark_mtinfo1 *mark;
+	struct xtables_match *match;
+	uint32_t value;
+
+	match = nft_create_match(ctx, ctx->cs, "mark");
+	if (!match)
+		return -1;
+
+	mark = (void*)match->m->data;
+
+	if (nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_OP) == NFT_CMP_NEQ)
+		mark->invert = 1;
+
+	value = nftnl_expr_get_u32(e, NFTNL_EXPR_CMP_DATA);
+	mark->mark = value;
+	if (ctx->flags & NFT_XT_CTX_BITWISE) {
+		memcpy(&mark->mask, &ctx->bitwise.mask, sizeof(mark->mask));
+		ctx->flags &= ~NFT_XT_CTX_BITWISE;
+	} else {
+		mark->mask = 0xffffffff;
+	}
+
+	return 0;
+}
+
 int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
 	       char *iniface, unsigned char *iniface_mask,
 	       char *outiface, unsigned char *outiface_mask, uint8_t *invflags)
@@ -304,6 +337,9 @@ int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
 
 		parse_ifname(ifname, len, outiface, outiface_mask);
 		break;
+	case NFT_META_MARK:
+		parse_meta_mark(ctx, e);
+		break;
 	default:
 		return -1;
 	}
diff --git a/iptables/nft.c b/iptables/nft.c
index 6883662fa28d..a629aeff98b0 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -40,6 +40,7 @@
 
 #include <linux/netfilter/xt_limit.h>
 #include <linux/netfilter/xt_NFLOG.h>
+#include <linux/netfilter/xt_mark.h>
 
 #include <libmnl/libmnl.h>
 #include <libnftnl/gen.h>
@@ -1406,6 +1407,26 @@ static int add_nft_tcp(struct nftnl_rule *r, struct xt_entry_match *m)
 			      tcp->dpts, tcp->invflags & XT_TCP_INV_DSTPT);
 }
 
+static int add_nft_mark(struct nft_handle *h, struct nftnl_rule *r,
+			struct xt_entry_match *m)
+{
+	struct xt_mark_mtinfo1 *mark = (void *)m->data;
+	int op;
+
+	add_meta(r, NFT_META_MARK);
+	if (mark->mask != 0xffffffff)
+		add_bitwise(r, (uint8_t *)&mark->mask, sizeof(uint32_t));
+
+	if (mark->invert)
+		op = NFT_CMP_NEQ;
+	else
+		op = NFT_CMP_EQ;
+
+	add_cmp_u32(r, mark->mark, op);
+
+	return 0;
+}
+
 int add_match(struct nft_handle *h,
 	      struct nftnl_rule *r, struct xt_entry_match *m)
 {
@@ -1420,6 +1441,8 @@ int add_match(struct nft_handle *h,
 		return add_nft_udp(r, m);
 	else if (!strcmp(m->u.user.name, "tcp"))
 		return add_nft_tcp(r, m);
+	else if (!strcmp(m->u.user.name, "mark"))
+		return add_nft_mark(h, r, m);
 
 	expr = nftnl_expr_alloc("match");
 	if (expr == NULL)
-- 
2.30.2

