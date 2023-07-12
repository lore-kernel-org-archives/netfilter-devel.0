Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9B76EB64D9
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Jul 2023 09:59:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230352AbjGLJ7U (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Jul 2023 05:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbjGLJ7U (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Jul 2023 05:59:20 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 970511720
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Jul 2023 02:59:18 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, igor@gooddata.com, phil@nwl.cc
Subject: [PATCH iptables] nft-bridge: pass context structure to ops->add() to improve anonymous set support
Date:   Wed, 12 Jul 2023 11:59:12 +0200
Message-Id: <20230712095912.140792-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add context structure to improve bridge among support which creates an
anonymous set. This context structure specifies the command and it
allows to optionally store a anonymous set.

Use this context to generate native bytecode only if this is an
add/insert/replace command.

This fixes a dangling anonymous set that is created on rule removal.

Fixes: 26753888720d ("nft: bridge: Rudimental among extension support")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
This test passes tests/py and tests/shell.

 iptables/nft-arp.c    |  4 ++--
 iptables/nft-bridge.c |  9 ++++----
 iptables/nft-cmd.c    |  6 ++++-
 iptables/nft-ipv4.c   |  6 ++---
 iptables/nft-ipv6.c   |  6 ++---
 iptables/nft-shared.h |  5 ++--
 iptables/nft.c        | 54 ++++++++++++++++++++++++++++---------------
 iptables/nft.h        |  9 +++++---
 8 files changed, 62 insertions(+), 37 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index 265de5f88cea..9868966a0368 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -40,8 +40,8 @@ static bool need_devaddr(struct arpt_devaddr_info *info)
 	return false;
 }
 
-static int nft_arp_add(struct nft_handle *h, struct nftnl_rule *r,
-		       struct iptables_command_state *cs)
+static int nft_arp_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
+		       struct nftnl_rule *r, struct iptables_command_state *cs)
 {
 	struct arpt_entry *fw = &cs->arp;
 	uint32_t op;
diff --git a/iptables/nft-bridge.c b/iptables/nft-bridge.c
index 6e50950774e6..391a8ab723c1 100644
--- a/iptables/nft-bridge.c
+++ b/iptables/nft-bridge.c
@@ -138,7 +138,8 @@ static int _add_action(struct nftnl_rule *r, struct iptables_command_state *cs)
 
 static int
 nft_bridge_add_match(struct nft_handle *h, const struct ebt_entry *fw,
-		     struct nftnl_rule *r, struct xt_entry_match *m)
+		     struct nft_rule_ctx *ctx, struct nftnl_rule *r,
+		     struct xt_entry_match *m)
 {
 	if (!strcmp(m->u.user.name, "802_3") && !(fw->bitmask & EBT_802_3))
 		xtables_error(PARAMETER_PROBLEM,
@@ -152,10 +153,10 @@ nft_bridge_add_match(struct nft_handle *h, const struct ebt_entry *fw,
 		xtables_error(PARAMETER_PROBLEM,
 			      "For IPv6 filtering the protocol must be specified as IPv6.");
 
-	return add_match(h, r, m);
+	return add_match(h, ctx, r, m);
 }
 
-static int nft_bridge_add(struct nft_handle *h,
+static int nft_bridge_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
 			  struct nftnl_rule *r,
 			  struct iptables_command_state *cs)
 {
@@ -217,7 +218,7 @@ static int nft_bridge_add(struct nft_handle *h,
 
 	for (iter = cs->match_list; iter; iter = iter->next) {
 		if (iter->ismatch) {
-			if (nft_bridge_add_match(h, fw, r, iter->u.match->m))
+			if (nft_bridge_add_match(h, fw, ctx, r, iter->u.match->m))
 				break;
 		} else {
 			if (add_target(r, iter->u.watcher->t))
diff --git a/iptables/nft-cmd.c b/iptables/nft-cmd.c
index 7b2fc3a59578..8a824586ad8c 100644
--- a/iptables/nft-cmd.c
+++ b/iptables/nft-cmd.c
@@ -14,12 +14,16 @@
 #include <xtables.h>
 #include "nft.h"
 #include "nft-cmd.h"
+#include <libnftnl/set.h>
 
 struct nft_cmd *nft_cmd_new(struct nft_handle *h, int command,
 			    const char *table, const char *chain,
 			    struct iptables_command_state *state,
 			    int rulenum, bool verbose)
 {
+	struct nft_rule_ctx ctx = {
+		.command = command,
+	};
 	struct nftnl_rule *rule;
 	struct nft_cmd *cmd;
 
@@ -33,7 +37,7 @@ struct nft_cmd *nft_cmd_new(struct nft_handle *h, int command,
 	cmd->verbose = verbose;
 
 	if (state) {
-		rule = nft_rule_new(h, chain, table, state);
+		rule = nft_rule_new(h, &ctx, chain, table, state);
 		if (!rule) {
 			nft_cmd_free(cmd);
 			return NULL;
diff --git a/iptables/nft-ipv4.c b/iptables/nft-ipv4.c
index 2a5d25d8694e..2f10220edd50 100644
--- a/iptables/nft-ipv4.c
+++ b/iptables/nft-ipv4.c
@@ -26,8 +26,8 @@
 #include "nft.h"
 #include "nft-shared.h"
 
-static int nft_ipv4_add(struct nft_handle *h, struct nftnl_rule *r,
-			struct iptables_command_state *cs)
+static int nft_ipv4_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
+			struct nftnl_rule *r, struct iptables_command_state *cs)
 {
 	struct xtables_rule_match *matchp;
 	uint32_t op;
@@ -84,7 +84,7 @@ static int nft_ipv4_add(struct nft_handle *h, struct nftnl_rule *r,
 	add_compat(r, cs->fw.ip.proto, cs->fw.ip.invflags & XT_INV_PROTO);
 
 	for (matchp = cs->matches; matchp; matchp = matchp->next) {
-		ret = add_match(h, r, matchp->match->m);
+		ret = add_match(h, ctx, r, matchp->match->m);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/iptables/nft-ipv6.c b/iptables/nft-ipv6.c
index 658a4f201895..d53f87c1d26e 100644
--- a/iptables/nft-ipv6.c
+++ b/iptables/nft-ipv6.c
@@ -25,8 +25,8 @@
 #include "nft.h"
 #include "nft-shared.h"
 
-static int nft_ipv6_add(struct nft_handle *h, struct nftnl_rule *r,
-			struct iptables_command_state *cs)
+static int nft_ipv6_add(struct nft_handle *h, struct nft_rule_ctx *ctx,
+			struct nftnl_rule *r, struct iptables_command_state *cs)
 {
 	struct xtables_rule_match *matchp;
 	uint32_t op;
@@ -70,7 +70,7 @@ static int nft_ipv6_add(struct nft_handle *h, struct nftnl_rule *r,
 	add_compat(r, cs->fw6.ipv6.proto, cs->fw6.ipv6.invflags & XT_INV_PROTO);
 
 	for (matchp = cs->matches; matchp; matchp = matchp->next) {
-		ret = add_match(h, r, matchp->match->m);
+		ret = add_match(h, ctx, r, matchp->match->m);
 		if (ret < 0)
 			return ret;
 	}
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index a06b263d77c1..4f47058d2ec5 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -35,13 +35,14 @@
 			| FMT_NUMERIC | FMT_NOTABLE)
 #define FMT(tab,notab) ((format) & FMT_NOTABLE ? (notab) : (tab))
 
+struct nft_rule_ctx;
 struct xtables_args;
 struct nft_handle;
 struct xt_xlate;
 
 struct nft_family_ops {
-	int (*add)(struct nft_handle *h, struct nftnl_rule *r,
-		   struct iptables_command_state *cs);
+	int (*add)(struct nft_handle *h, struct nft_rule_ctx *ctx,
+		   struct nftnl_rule *r, struct iptables_command_state *cs);
 	bool (*is_same)(const struct iptables_command_state *cs_a,
 			const struct iptables_command_state *cs_b);
 	void (*print_payload)(struct nftnl_expr *e,
diff --git a/iptables/nft.c b/iptables/nft.c
index 1cb104e75ccc..59e3fa7079c4 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1154,7 +1154,8 @@ gen_lookup(uint32_t sreg, const char *set_name, uint32_t set_id, uint32_t flags)
 #define NFT_DATATYPE_ETHERADDR	9
 
 static int __add_nft_among(struct nft_handle *h, const char *table,
-			   struct nftnl_rule *r, struct nft_among_pair *pairs,
+			   struct nft_rule_ctx *ctx, struct nftnl_rule *r,
+			   struct nft_among_pair *pairs,
 			   int cnt, bool dst, bool inv, bool ip)
 {
 	uint32_t set_id, type = NFT_DATATYPE_ETHERADDR, len = ETH_ALEN;
@@ -1235,7 +1236,7 @@ static int __add_nft_among(struct nft_handle *h, const char *table,
 	return 0;
 }
 
-static int add_nft_among(struct nft_handle *h,
+static int add_nft_among(struct nft_handle *h, struct nft_rule_ctx *ctx,
 			 struct nftnl_rule *r, struct xt_entry_match *m)
 {
 	struct nft_among_data *data = (struct nft_among_data *)m->data;
@@ -1251,10 +1252,10 @@ static int add_nft_among(struct nft_handle *h,
 	}
 
 	if (data->src.cnt)
-		__add_nft_among(h, table, r, data->pairs, data->src.cnt,
+		__add_nft_among(h, table, ctx, r, data->pairs, data->src.cnt,
 				false, data->src.inv, data->src.ip);
 	if (data->dst.cnt)
-		__add_nft_among(h, table, r, data->pairs + data->src.cnt,
+		__add_nft_among(h, table, ctx, r, data->pairs + data->src.cnt,
 				data->dst.cnt, true, data->dst.inv,
 				data->dst.ip);
 	return 0;
@@ -1462,22 +1463,30 @@ static int add_nft_mark(struct nft_handle *h, struct nftnl_rule *r,
 	return 0;
 }
 
-int add_match(struct nft_handle *h,
+int add_match(struct nft_handle *h, struct nft_rule_ctx *ctx,
 	      struct nftnl_rule *r, struct xt_entry_match *m)
 {
 	struct nftnl_expr *expr;
 	int ret;
 
-	if (!strcmp(m->u.user.name, "limit"))
-		return add_nft_limit(r, m);
-	else if (!strcmp(m->u.user.name, "among"))
-		return add_nft_among(h, r, m);
-	else if (!strcmp(m->u.user.name, "udp"))
-		return add_nft_udp(h, r, m);
-	else if (!strcmp(m->u.user.name, "tcp"))
-		return add_nft_tcp(h, r, m);
-	else if (!strcmp(m->u.user.name, "mark"))
-		return add_nft_mark(h, r, m);
+	switch (ctx->command) {
+	case NFT_COMPAT_RULE_APPEND:
+	case NFT_COMPAT_RULE_INSERT:
+	case NFT_COMPAT_RULE_REPLACE:
+		if (!strcmp(m->u.user.name, "limit"))
+			return add_nft_limit(r, m);
+		else if (!strcmp(m->u.user.name, "among"))
+			return add_nft_among(h, ctx, r, m);
+		else if (!strcmp(m->u.user.name, "udp"))
+			return add_nft_udp(h, r, m);
+		else if (!strcmp(m->u.user.name, "tcp"))
+			return add_nft_tcp(h, r, m);
+		else if (!strcmp(m->u.user.name, "mark"))
+			return add_nft_mark(h, r, m);
+		break;
+	default:
+		break;
+	}
 
 	expr = nftnl_expr_alloc("match");
 	if (expr == NULL)
@@ -1705,7 +1714,8 @@ void add_compat(struct nftnl_rule *r, uint32_t proto, bool inv)
 }
 
 struct nftnl_rule *
-nft_rule_new(struct nft_handle *h, const char *chain, const char *table,
+nft_rule_new(struct nft_handle *h, struct nft_rule_ctx *ctx,
+	     const char *chain, const char *table,
 	     struct iptables_command_state *cs)
 {
 	struct nftnl_rule *r;
@@ -1718,7 +1728,7 @@ nft_rule_new(struct nft_handle *h, const char *chain, const char *table,
 	nftnl_rule_set_str(r, NFTNL_RULE_TABLE, table);
 	nftnl_rule_set_str(r, NFTNL_RULE_CHAIN, chain);
 
-	if (h->ops->add(h, r, cs) < 0)
+	if (h->ops->add(h, ctx, r, cs) < 0)
 		goto err;
 
 	return r;
@@ -2878,6 +2888,9 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
 {
 	struct iptables_command_state cs = {};
 	struct nftnl_rule *r, *new_rule;
+	struct nft_rule_ctx ctx = {
+		.command = NFT_COMPAT_RULE_ZERO,
+	};
 	struct nft_chain *c;
 	int ret = 0;
 
@@ -2896,7 +2909,7 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain,
 
 	h->ops->rule_to_cs(h, r, &cs);
 	cs.counters.pcnt = cs.counters.bcnt = 0;
-	new_rule = nft_rule_new(h, chain, table, &cs);
+	new_rule = nft_rule_new(h, &ctx, chain, table, &cs);
 	h->ops->clear_cs(&cs);
 
 	if (!new_rule)
@@ -3274,6 +3287,9 @@ static int ebt_add_policy_rule(struct nftnl_chain *c, void *data)
 		.eb.bitmask = EBT_NOPROTO,
 	};
 	struct nftnl_udata_buf *udata;
+	struct nft_rule_ctx ctx = {
+		.command	= NFT_COMPAT_RULE_APPEND,
+	};
 	struct nft_handle *h = data;
 	struct nftnl_rule *r;
 	const char *pname;
@@ -3301,7 +3317,7 @@ static int ebt_add_policy_rule(struct nftnl_chain *c, void *data)
 
 	command_jump(&cs, pname);
 
-	r = nft_rule_new(h, nftnl_chain_get_str(c, NFTNL_CHAIN_NAME),
+	r = nft_rule_new(h, &ctx, nftnl_chain_get_str(c, NFTNL_CHAIN_NAME),
 			 nftnl_chain_get_str(c, NFTNL_CHAIN_TABLE), &cs);
 	ebt_cs_clean(&cs);
 
diff --git a/iptables/nft.h b/iptables/nft.h
index 1d18982dc8cf..5acbbf82e2c2 100644
--- a/iptables/nft.h
+++ b/iptables/nft.h
@@ -168,9 +168,11 @@ struct nftnl_set *nft_set_batch_lookup_byid(struct nft_handle *h,
 /*
  * Operations with rule-set.
  */
-struct nftnl_rule;
+struct nft_rule_ctx {
+	int			command;
+};
 
-struct nftnl_rule *nft_rule_new(struct nft_handle *h, const char *chain, const char *table, struct iptables_command_state *cs);
+struct nftnl_rule *nft_rule_new(struct nft_handle *h, struct nft_rule_ctx *rule, const char *chain, const char *table, struct iptables_command_state *cs);
 int nft_rule_append(struct nft_handle *h, const char *chain, const char *table, struct nftnl_rule *r, struct nftnl_rule *ref, bool verbose);
 int nft_rule_insert(struct nft_handle *h, const char *chain, const char *table, struct nftnl_rule *r, int rulenum, bool verbose);
 int nft_rule_check(struct nft_handle *h, const char *chain, const char *table, struct nftnl_rule *r, bool verbose);
@@ -188,7 +190,8 @@ int nft_rule_zero_counters(struct nft_handle *h, const char *chain, const char *
  */
 int add_counters(struct nftnl_rule *r, uint64_t packets, uint64_t bytes);
 int add_verdict(struct nftnl_rule *r, int verdict);
-int add_match(struct nft_handle *h, struct nftnl_rule *r, struct xt_entry_match *m);
+int add_match(struct nft_handle *h, struct nft_rule_ctx *ctx,
+	      struct nftnl_rule *r, struct xt_entry_match *m);
 int add_target(struct nftnl_rule *r, struct xt_entry_target *t);
 int add_jumpto(struct nftnl_rule *r, const char *name, int verdict);
 int add_action(struct nftnl_rule *r, struct iptables_command_state *cs, bool goto_set);
-- 
2.30.2

