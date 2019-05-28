Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A944EC04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 21:03:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78D45208CB
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 21:03:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727273AbfE1VDh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 17:03:37 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:38454 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726683AbfE1VDh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 17:03:37 -0400
Received: from localhost ([::1]:51542 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hVjFv-0002JZ-LT; Tue, 28 May 2019 23:03:35 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Eric Garver <e@erig.me>
Subject: [nft PATCH v4 7/7] src: Support intra-transaction rule references
Date:   Tue, 28 May 2019 23:03:23 +0200
Message-Id: <20190528210323.14605-8-phil@nwl.cc>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190528210323.14605-1-phil@nwl.cc>
References: <20190528210323.14605-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A rule may be added before or after another one using index keyword. To
support for the other rule being added within the same batch, one has to
make use of NFTNL_RULE_ID and NFTNL_RULE_POSITION_ID attributes. This
patch does just that among a few more crucial things:

* Fetch full kernel ruleset upon encountering a rule which references
  another one. Any earlier rule add/insert commands are then restored by
  cache_add_commands().

* Avoid cache updates for rules not referencing another one, but make
  sure cache is not treated as complete afterwards so a later rule with
  reference will cause cache update and repopulation from command list.

* Reduce rule_translate_index() to its core code which is the actual
  linking of rules and consequently rename the function. The removed
  bits are pulled into the calling rule_evaluate() to reduce code
  duplication in between cache inserts with and without rule reference.

* Pass the current command op to rule_evaluate() as indicator whether to
  insert before or after a referenced rule or at beginning or end of
  chain in cache. Exploit this from chain_evaluate() to avoid adding
  the chain's rules a second time.

Light casts shadow though: It has been possible to reference another
rule of the same transaction via its *guessed* handle - this patch
removes that possibility.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- Move rule list manipulation into a dedicated function
  rule_cache_update().
- Restore old performance for simple commands by fetching a full rule
  cache only if the currently evaluated rule references another one.
- Extend 0024rule_0 test a bit to make sure things work with interactive
  nft also.
---
 include/rule.h                                |   6 +
 src/evaluate.c                                | 103 +++++++++++-------
 src/mnl.c                                     |   4 +
 src/rule.c                                    |  53 +++++++++
 .../shell/testcases/cache/0003_cache_update_0 |   7 ++
 .../shell/testcases/nft-f/0006action_object_0 |   2 +-
 tests/shell/testcases/transactions/0024rule_0 |  17 +++
 .../transactions/dumps/0024rule_0.nft         |   8 ++
 8 files changed, 162 insertions(+), 38 deletions(-)
 create mode 100755 tests/shell/testcases/transactions/0024rule_0
 create mode 100644 tests/shell/testcases/transactions/dumps/0024rule_0.nft

diff --git a/include/rule.h b/include/rule.h
index aa8881d375b96..e2bbdf3696bfe 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -73,6 +73,8 @@ struct handle {
 	struct position_spec	position;
 	struct position_spec	index;
 	uint32_t		set_id;
+	uint32_t		rule_id;
+	uint32_t		position_id;
 };
 
 extern void handle_merge(struct handle *dst, const struct handle *src);
@@ -263,6 +265,10 @@ extern struct rule *rule_lookup(const struct chain *chain, uint64_t handle);
 extern struct rule *rule_lookup_by_index(const struct chain *chain,
 					 uint64_t index);
 
+enum cmd_ops;
+extern void rule_cache_update(enum cmd_ops op, struct chain *chain,
+			      struct rule *rule, struct rule *ref);
+
 /**
  * struct set - nftables set
  *
diff --git a/src/evaluate.c b/src/evaluate.c
index 09bb1fd37a301..ef781ad2c8712 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -3184,46 +3184,32 @@ static int flowtable_evaluate(struct eval_ctx *ctx, struct flowtable *ft)
 	return 0;
 }
 
-/* Convert rule's handle.index into handle.position. */
-static int rule_translate_index(struct eval_ctx *ctx, struct rule *rule)
+/* make src point at dst, either via handle.position or handle.position_id */
+static void link_rules(struct rule *src, struct rule *dst)
 {
-	struct table *table;
-	struct chain *chain;
-	uint64_t index = 0;
-	struct rule *r;
-	int ret;
+	static uint32_t ref_id = 0;
 
-	/* update cache with CMD_LIST so that rules are fetched, too */
-	ret = cache_update(ctx->nft, CMD_LIST, ctx->msgs);
-	if (ret < 0)
-		return ret;
-
-	table = table_lookup(&rule->handle, &ctx->nft->cache);
-	if (!table)
-		return table_not_found(ctx);
-
-	chain = chain_lookup(table, &rule->handle);
-	if (!chain)
-		return chain_not_found(ctx);
-
-	list_for_each_entry(r, &chain->rules, list) {
-		if (++index < rule->handle.index.id)
-			continue;
-		rule->handle.position.id = r->handle.handle.id;
-		rule->handle.position.location = rule->handle.index.location;
-		break;
+	if (dst->handle.handle.id) {
+		/* dst is in kernel, make src reference it by handle */
+		src->handle.position.id = dst->handle.handle.id;
+		src->handle.position.location = src->handle.index.location;
+		return;
 	}
-	if (!rule->handle.position.id)
-		return cmd_error(ctx, &rule->handle.index.location,
-				"Could not process rule: %s",
-				strerror(ENOENT));
-	return 0;
+
+	/* dst is not in kernel, make src reference it by per-transaction ID */
+	if (!dst->handle.rule_id)
+		dst->handle.rule_id = ++ref_id;
+	src->handle.position_id = dst->handle.rule_id;
 }
 
-static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule)
+static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule, enum cmd_ops op)
 {
 	struct stmt *stmt, *tstmt = NULL;
 	struct error_record *erec;
+	struct rule *ref = NULL;
+	struct table *table;
+	struct chain *chain;
+	int ret;
 
 	proto_ctx_init(&ctx->pctx, rule->handle.family, ctx->nft->debug_mask);
 	memset(&ctx->ectx, 0, sizeof(ctx->ectx));
@@ -3248,10 +3234,53 @@ static int rule_evaluate(struct eval_ctx *ctx, struct rule *rule)
 		return -1;
 	}
 
-	if (rule->handle.index.id &&
-	    rule_translate_index(ctx, rule))
-		return -1;
+	if (!rule->handle.index.id &&
+	    !rule->handle.handle.id &&
+	    !rule->handle.position.id) {
+		/* No reference to another rule in this one, no need to update
+		 * cache for it. Just mark the cache as incomplete so it is not
+		 * left out by accident. */
+		if (cache_is_complete(&ctx->nft->cache, CMD_LIST))
+			ctx->nft->cache.cmd = CMD_RESET;
+		return 0;
+	}
+
+	/* update cache with CMD_LIST so that rules are fetched, too */
+	ret = cache_update(ctx->nft, CMD_LIST, ctx->msgs);
+	if (ret < 0)
+		return ret;
+
+	table = table_lookup(&rule->handle, &ctx->nft->cache);
+	if (!table)
+		return table_not_found(ctx);
+
+	chain = chain_lookup(table, &rule->handle);
+	if (!chain)
+		return chain_not_found(ctx);
+
+	if (rule->handle.index.id) {
+		ref = rule_lookup_by_index(chain, rule->handle.index.id);
+		if (!ref)
+			return cmd_error(ctx, &rule->handle.index.location,
+					 "Could not process rule: %s",
+					 strerror(ENOENT));
+
+		link_rules(rule, ref);
+	} else if (rule->handle.handle.id) {
+		ref = rule_lookup(chain, rule->handle.handle.id);
+		if (!ref)
+			return cmd_error(ctx, &rule->handle.handle.location,
+					 "Could not process rule: %s",
+					 strerror(ENOENT));
+	} else if (rule->handle.position.id) {
+		ref = rule_lookup(chain, rule->handle.position.id);
+		if (!ref)
+			return cmd_error(ctx, &rule->handle.position.location,
+					 "Could not process rule: %s",
+					 strerror(ENOENT));
+	}
 
+	rule_cache_update(op, chain, rule, ref);
 	return 0;
 }
 
@@ -3333,7 +3362,7 @@ static int chain_evaluate(struct eval_ctx *ctx, struct chain *chain)
 
 	list_for_each_entry(rule, &chain->rules, list) {
 		handle_merge(&rule->handle, &chain->handle);
-		if (rule_evaluate(ctx, rule) < 0)
+		if (rule_evaluate(ctx, rule, CMD_INVALID) < 0)
 			return -1;
 	}
 	return 0;
@@ -3430,7 +3459,7 @@ static int cmd_evaluate_add(struct eval_ctx *ctx, struct cmd *cmd)
 		return set_evaluate(ctx, cmd->set);
 	case CMD_OBJ_RULE:
 		handle_merge(&cmd->rule->handle, &cmd->handle);
-		return rule_evaluate(ctx, cmd->rule);
+		return rule_evaluate(ctx, cmd->rule, cmd->op);
 	case CMD_OBJ_CHAIN:
 		ret = cache_update(ctx->nft, cmd->op, ctx->msgs);
 		if (ret < 0)
diff --git a/src/mnl.c b/src/mnl.c
index f6363560721c1..9bb712adfa3b5 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -327,6 +327,10 @@ int mnl_nft_rule_add(struct netlink_ctx *ctx, const struct cmd *cmd,
 	nftnl_rule_set_str(nlr, NFTNL_RULE_CHAIN, h->chain.name);
 	if (h->position.id)
 		nftnl_rule_set_u64(nlr, NFTNL_RULE_POSITION, h->position.id);
+	if (h->rule_id)
+		nftnl_rule_set_u32(nlr, NFTNL_RULE_ID, h->rule_id);
+	if (h->position_id)
+		nftnl_rule_set_u32(nlr, NFTNL_RULE_POSITION_ID, h->position_id);
 
 	netlink_linearize_rule(ctx, nlr, rule);
 	nlh = nftnl_nlmsg_build_hdr(nftnl_batch_buffer(ctx->batch),
diff --git a/src/rule.c b/src/rule.c
index b00161e0e4350..0048a8e064523 100644
--- a/src/rule.c
+++ b/src/rule.c
@@ -293,6 +293,23 @@ static int cache_add_set_cmd(struct eval_ctx *ectx)
 	return 0;
 }
 
+static int cache_add_rule_cmd(struct eval_ctx *ectx)
+{
+	struct table *table;
+	struct chain *chain;
+
+	table = table_lookup(&ectx->cmd->rule->handle, &ectx->nft->cache);
+	if (!table)
+		return table_not_found(ectx);
+
+	chain = chain_lookup(table, &ectx->cmd->rule->handle);
+	if (!chain)
+		return chain_not_found(ectx);
+
+	rule_cache_update(ectx->cmd->op, chain, ectx->cmd->rule, NULL);
+	return 0;
+}
+
 static int cache_add_commands(struct nft_ctx *nft, struct list_head *msgs)
 {
 	struct eval_ctx ectx = {
@@ -314,6 +331,11 @@ static int cache_add_commands(struct nft_ctx *nft, struct list_head *msgs)
 				continue;
 			ret = cache_add_set_cmd(&ectx);
 			break;
+		case CMD_OBJ_RULE:
+			if (!cache_is_complete(&nft->cache, CMD_LIST))
+				continue;
+			ret = cache_add_rule_cmd(&ectx);
+			break;
 		default:
 			break;
 		}
@@ -727,6 +749,37 @@ struct rule *rule_lookup_by_index(const struct chain *chain, uint64_t index)
 	return NULL;
 }
 
+void rule_cache_update(enum cmd_ops op, struct chain *chain,
+		       struct rule *rule, struct rule *ref)
+{
+	switch (op) {
+	case CMD_INSERT:
+		rule_get(rule);
+		if (ref)
+			list_add_tail(&rule->list, &ref->list);
+		else
+			list_add(&rule->list, &chain->rules);
+		break;
+	case CMD_ADD:
+		rule_get(rule);
+		if (ref)
+			list_add(&rule->list, &ref->list);
+		else
+			list_add_tail(&rule->list, &chain->rules);
+		break;
+	case CMD_REPLACE:
+		rule_get(rule);
+		list_add(&rule->list, &ref->list);
+		/* fall through */
+	case CMD_DELETE:
+		list_del(&ref->list);
+		rule_free(ref);
+		break;
+	default:
+		break;
+	}
+}
+
 struct scope *scope_init(struct scope *scope, const struct scope *parent)
 {
 	scope->parent = parent;
diff --git a/tests/shell/testcases/cache/0003_cache_update_0 b/tests/shell/testcases/cache/0003_cache_update_0
index fa9b5df380a41..05edc9c7c33eb 100755
--- a/tests/shell/testcases/cache/0003_cache_update_0
+++ b/tests/shell/testcases/cache/0003_cache_update_0
@@ -34,6 +34,9 @@ EOF
 # add rule ip t4 c meta l4proto icmp accept -> rule to reference in next step
 # add rule ip t4 c index 0 drop -> index 0 is not found due to rule cache not
 #                                  being updated
+# add rule ip t4 c index 2 drop -> index 2 is not found due to igmp rule being
+#                                  in same transaction and therefore not having
+#                                  an allocated handle
 $NFT -i >/dev/null <<EOF
 add table ip t4; add chain ip t4 c
 add rule ip t4 c meta l4proto icmp accept
@@ -41,3 +44,7 @@ EOF
 $NFT -f - >/dev/null <<EOF
 add rule ip t4 c index 0 drop
 EOF
+$NFT -f - >/dev/null <<EOF
+add rule ip t4 c meta l4proto igmp accept
+add rule ip t4 c index 2 drop
+EOF
diff --git a/tests/shell/testcases/nft-f/0006action_object_0 b/tests/shell/testcases/nft-f/0006action_object_0
index b9766f2dbb721..742e0bdec69f7 100755
--- a/tests/shell/testcases/nft-f/0006action_object_0
+++ b/tests/shell/testcases/nft-f/0006action_object_0
@@ -16,7 +16,6 @@ generate1()
 	add set $family t s {type inet_service;}
 	add element $family t s {8080}
 	insert rule $family t c meta l4proto tcp tcp dport @s accept
-	replace rule $family t c handle 2 meta l4proto tcp tcp dport {9090}
 	add map $family t m {type inet_service:verdict;}
 	add element $family t m {10080:drop}
 	insert rule $family t c meta l4proto tcp tcp dport vmap @m
@@ -28,6 +27,7 @@ generate2()
 {
 	local family=$1
 	echo "
+	replace rule $family t c handle 2 meta l4proto tcp tcp dport {9090}
 	flush chain $family t c
 	delete element $family t m {10080:drop}
 	delete element $family t s {8080}
diff --git a/tests/shell/testcases/transactions/0024rule_0 b/tests/shell/testcases/transactions/0024rule_0
new file mode 100755
index 0000000000000..4c1ac41db3b47
--- /dev/null
+++ b/tests/shell/testcases/transactions/0024rule_0
@@ -0,0 +1,17 @@
+#!/bin/bash
+
+RULESET="flush ruleset
+add table x
+add chain x y
+add rule x y accept comment rule1
+add rule x y accept comment rule4
+add rule x y index 0 accept comment rule2
+insert rule x y index 2 accept comment rule3"
+
+$NFT -f - <<< "$RULESET" && \
+	$NFT -f - <<< "$RULESET" && \
+	echo "$RULESET" | tr '\n' ';' | $NFT -i >/dev/null && \
+	exit 0
+echo "E: intra-transaction rule reference failed"
+exit 1
+
diff --git a/tests/shell/testcases/transactions/dumps/0024rule_0.nft b/tests/shell/testcases/transactions/dumps/0024rule_0.nft
new file mode 100644
index 0000000000000..7860ff654c5e2
--- /dev/null
+++ b/tests/shell/testcases/transactions/dumps/0024rule_0.nft
@@ -0,0 +1,8 @@
+table ip x {
+	chain y {
+		accept comment "rule1"
+		accept comment "rule2"
+		accept comment "rule3"
+		accept comment "rule4"
+	}
+}
-- 
2.21.0

