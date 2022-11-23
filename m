Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 429DEC433FE
	for <netfilter-devel@archiver.kernel.org>; Wed, 23 Nov 2022 13:55:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237603AbiKWNzj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 23 Nov 2022 08:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236065AbiKWNzT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 23 Nov 2022 08:55:19 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA2672105
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Nov 2022 05:49:36 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1oxq87-0001Rw-Ae; Wed, 23 Nov 2022 14:49:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH iptables-nft] iptables-nft: exit nonzero when iptables-save cannot decode all expressions
Date:   Wed, 23 Nov 2022 14:49:29 +0100
Message-Id: <20221123134929.4700-1-fw@strlen.de>
X-Mailer: git-send-email 2.37.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

We always return 0, even if we printed some error message half-way.
Increment an error counter whenever an error message was printed so that
the chain-loop can exit with an error if this counter is nonzero.

Another effect is that iptables-restore won't have a chance to print the
COMMIT line.

Reported-by: Phil Sutter <phil@nwl.cc>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 iptables/nft-bridge.c |  4 ++--
 iptables/nft-shared.c | 10 +++++++---
 iptables/nft-shared.h |  4 ++--
 iptables/nft.c        | 26 ++++++++++++++++++++------
 iptables/nft.h        |  2 +-
 5 files changed, 32 insertions(+), 14 deletions(-)

diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index e8ac7a364169..4367d072906d 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -563,12 +563,12 @@ static void nft_bridge_parse_target(struct xtables_target *t,
 	cs->jumpto = t->name;
 }
 
-static void nft_rule_to_ebtables_command_state(struct nft_handle *h,
+static bool nft_rule_to_ebtables_command_state(struct nft_handle *h,
 					       const struct nftnl_rule *r,
 					       struct iptables_command_state *cs)
 {
 	cs->eb.bitmask = EBT_NOPROTO;
-	nft_rule_to_iptables_command_state(h, r, cs);
+	return nft_rule_to_iptables_command_state(h, r, cs);
 }
 
 static void print_iface(const char *option, const char *name, bool invert)
diff --git a/iptables/nft-shared.c b/iptables/nft-shared.c
index 97512e3f43ff..63d251986f65 100644
--- a/iptables/nft-shared.c
+++ b/iptables/nft-shared.c
@@ -1199,7 +1199,7 @@ static void nft_parse_range(struct nft_xt_ctx *ctx, struct nftnl_expr *e)
 	}
 }
 
-void nft_rule_to_iptables_command_state(struct nft_handle *h,
+bool nft_rule_to_iptables_command_state(struct nft_handle *h,
 					const struct nftnl_rule *r,
 					struct iptables_command_state *cs)
 {
@@ -1210,10 +1210,11 @@ void nft_rule_to_iptables_command_state(struct nft_handle *h,
 		.h = h,
 		.table = nftnl_rule_get_str(r, NFTNL_RULE_TABLE),
 	};
+	bool ret = true;
 
 	iter = nftnl_expr_iter_create(r);
 	if (iter == NULL)
-		return;
+		return false;
 
 	ctx.iter = iter;
 	expr = nftnl_expr_iter_next(iter);
@@ -1249,6 +1250,7 @@ void nft_rule_to_iptables_command_state(struct nft_handle *h,
 		if (ctx.errmsg) {
 			fprintf(stderr, "%s", ctx.errmsg);
 			ctx.errmsg = NULL;
+			ret = false;
 		}
 
 		expr = nftnl_expr_iter_next(iter);
@@ -1270,7 +1272,7 @@ void nft_rule_to_iptables_command_state(struct nft_handle *h,
 			match = xtables_find_match("comment", XTF_TRY_LOAD,
 						   &cs->matches);
 			if (match == NULL)
-				return;
+				return false;
 
 			size = XT_ALIGN(sizeof(struct xt_entry_match))
 				+ match->size;
@@ -1287,6 +1289,8 @@ void nft_rule_to_iptables_command_state(struct nft_handle *h,
 
 	if (!cs->jumpto)
 		cs->jumpto = "";
+
+	return ret;
 }
 
 void nft_clear_iptables_command_state(struct iptables_command_state *cs)
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 3d935d5324b0..e2c3ac7b0cc5 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -159,7 +159,7 @@ struct nft_family_ops {
 	void (*parse_target)(struct xtables_target *t,
 			     struct iptables_command_state *cs);
 	void (*init_cs)(struct iptables_command_state *cs);
-	void (*rule_to_cs)(struct nft_handle *h, const struct nftnl_rule *r,
+	bool (*rule_to_cs)(struct nft_handle *h, const struct nftnl_rule *r,
 			   struct iptables_command_state *cs);
 	void (*clear_cs)(struct iptables_command_state *cs);
 	int (*xlate)(const struct iptables_command_state *cs,
@@ -213,7 +213,7 @@ int parse_meta(struct nft_xt_ctx *ctx, struct nftnl_expr *e, uint8_t key,
 	       unsigned char *outiface_mask, uint8_t *invflags);
 void __get_cmp_data(struct nftnl_expr *e, void *data, size_t dlen, uint8_t *op);
 void get_cmp_data(struct nftnl_expr *e, void *data, size_t dlen, bool *inv);
-void nft_rule_to_iptables_command_state(struct nft_handle *h,
+bool nft_rule_to_iptables_command_state(struct nft_handle *h,
 					const struct nftnl_rule *r,
 					struct iptables_command_state *cs);
 void nft_clear_iptables_command_state(struct iptables_command_state *cs);
diff --git a/iptables/nft.c b/iptables/nft.c
index 4c0110bb8040..67c5877ce9cc 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1748,15 +1748,16 @@ nft_rule_append(struct nft_handle *h, const char *chain, const char *table,
 	return 1;
 }
 
-void
+bool
 nft_rule_print_save(struct nft_handle *h, const struct nftnl_rule *r,
 		    enum nft_rule_print type, unsigned int format)
 {
 	const char *chain = nftnl_rule_get_str(r, NFTNL_RULE_CHAIN);
 	struct iptables_command_state cs = {};
 	struct nft_family_ops *ops = h->ops;
+	bool ret;
 
-	ops->rule_to_cs(h, r, &cs);
+	ret = ops->rule_to_cs(h, r, &cs);
 
 	if (!(format & (FMT_NOCOUNTS | FMT_C_COUNTS)))
 		printf("[%llu:%llu] ", (unsigned long long)cs.counters.pcnt,
@@ -1777,6 +1778,8 @@ nft_rule_print_save(struct nft_handle *h, const struct nftnl_rule *r,
 
 	if (ops->clear_cs)
 		ops->clear_cs(&cs);
+
+	return ret;
 }
 
 static bool nft_rule_is_policy_rule(struct nftnl_rule *r)
@@ -1887,6 +1890,7 @@ int nft_chain_save(struct nft_chain *nc, void *data)
 struct nft_rule_save_data {
 	struct nft_handle *h;
 	unsigned int format;
+	unsigned int errors;
 };
 
 static int nft_rule_save_cb(struct nft_chain *c, void *data)
@@ -1901,7 +1905,11 @@ static int nft_rule_save_cb(struct nft_chain *c, void *data)
 
 	r = nftnl_rule_iter_next(iter);
 	while (r != NULL) {
-		nft_rule_print_save(d->h, r, NFT_RULE_APPEND, d->format);
+		bool ret = nft_rule_print_save(d->h, r, NFT_RULE_APPEND, d->format);
+
+		if (!ret)
+			d->errors++;
+
 		r = nftnl_rule_iter_next(iter);
 	}
 
@@ -1919,6 +1927,9 @@ int nft_rule_save(struct nft_handle *h, const char *table, unsigned int format)
 
 	ret = nft_chain_foreach(h, table, nft_rule_save_cb, &d);
 
+	if (ret == 0 && d.errors)
+		xtables_error(VERSION_PROBLEM, "Cannot decode all rules provided by kernel");
+
 	/* the core expects 1 for success and 0 for error */
 	return ret == 0 ? 1 : 0;
 }
@@ -2341,15 +2352,18 @@ static bool nft_rule_cmp(struct nft_handle *h, struct nftnl_rule *r,
 			 struct nftnl_rule *rule)
 {
 	struct iptables_command_state _cs = {}, this = {}, *cs = &_cs;
-	bool ret = false;
+	bool ret = false, ret_this, ret_that;
 
-	h->ops->rule_to_cs(h, r, &this);
-	h->ops->rule_to_cs(h, rule, cs);
+	ret_this = h->ops->rule_to_cs(h, r, &this);
+	ret_that = h->ops->rule_to_cs(h, rule, cs);
 
 	DEBUGP("comparing with... ");
 #ifdef DEBUG_DEL
 	nft_rule_print_save(h, r, NFT_RULE_APPEND, 0);
 #endif
+	if (!ret_this || !ret_that)
+		DEBUGP("Cannot convert rules: %d %d\n", ret_this, ret_that);
+
 	if (!h->ops->is_same(cs, &this))
 		goto out;
 
diff --git a/iptables/nft.h b/iptables/nft.h
index 68b0910c8e18..caff1fdeff92 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -203,7 +203,7 @@ enum nft_rule_print {
 	NFT_RULE_DEL,
 };
 
-void nft_rule_print_save(struct nft_handle *h, const struct nftnl_rule *r,
+bool nft_rule_print_save(struct nft_handle *h, const struct nftnl_rule *r,
 			 enum nft_rule_print type, unsigned int format);
 
 uint32_t nft_invflags2cmp(uint32_t invflags, uint32_t flag);
-- 
2.37.4

