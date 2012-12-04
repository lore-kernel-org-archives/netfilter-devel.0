From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 4/8] netfilter: xtables2: iterator for obtain/drop references to actions
Date: Tue,  4 Dec 2012 02:00:45 +0100
Message-ID: <1354582849-26888-5-git-send-email-jengelh@inai.de>
References: <1354582849-26888-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:49566 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691Ab2LDBA6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 20:00:58 -0500
In-Reply-To: <1354582849-26888-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Actions like matches and targets can optionally have "checkentry" and
"destroy" functions that are to be called whenever an action is
instantiated or released, respectively. This commit provides the
chain/rule-level functions that iterate over the ruleset to call
future checkentry/destroy calls.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 net/netfilter/xt_core.c |   88 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/net/netfilter/xt_core.c b/net/netfilter/xt_core.c
index 865da3b..ef31215 100644
--- a/net/netfilter/xt_core.c
+++ b/net/netfilter/xt_core.c
@@ -209,11 +209,86 @@ void xt2_rulebuf_free(struct xt2_rule_buffer *rb)
 	kfree(rb);
 }
 
+static void xt2_rule_refput(struct xt2_packed_rule *rule, struct net *net)
+{
+	struct xt2_packed_action *action;
+
+	xt2_foreach_action(action, rule) {
+		/* To be filled in. */
+	}
+}
+
+static int xt2_rule_refget(struct xt2_packed_rule *rule, struct net *net)
+{
+	struct xt2_packed_action *action;
+	int ret = 0;
+
+	xt2_foreach_action(action, rule) {
+		/* <- To be filled in, for matches and targets. */
+		if (action->type != NFXT_ACTION_VERDICT)
+			WARN_ON(true);
+		if (ret != 0) {
+			/* Trim rule and only unroll prior entities. */
+			rule->dsize = (const char *)action - rule->data;
+			xt2_rule_refput(rule, net);
+			return ret;
+		}
+	}
+	return 0;
+}
+
+static void xt2_blob_refput(struct xt2_rule_block *blob)
+{
+	struct xt2_packed_rule *rule;
+
+	/*
+	 * It is acceptable to not do the unrolling backwards.
+	 * (xtables1 also did that, and extensions must not rely on any
+	 * calling order.)
+	 */
+	xt2_foreach_rule(rule, blob)
+		xt2_rule_refput(rule, blob->netns);
+}
+
+/**
+ * After a chain's ruleset has been duplicated or spliced as part of
+ * xt2_chain_dup or xt2_chain_splice, respectively, references need to be
+ * obtained for the extensions. This is to make sure that (a) the
+ * previously-loaded extensions/modules do not go away, (b) per-extension
+ * private data does not go away either when the original ruleset is freed,
+ * especially when we are busy with dumping the duplicated ruleset to
+ * userspace.
+ *
+ * The caller of this function should be in RCU to avoid the original blob
+ * going away and therefore also (b).
+ */
+static int xt2_blob_refget(struct xt2_rule_block *blob)
+{
+	struct xt2_packed_rule *rule;
+	int ret = 0;
+
+	xt2_foreach_rule(rule, blob) {
+		ret = xt2_rule_refget(rule, blob->netns);
+		if (ret != 0) {
+			/*
+			 * Trim blob and only unroll prior rules. Note that
+			 * changing blob->size trashes the ruleset (but that is
+			 * ok since there is no attempt to reuse the blob).
+			 */
+			blob->size = (const char *)rule - blob->data;
+			xt2_blob_refput(blob);
+			return ret;
+		}
+	}
+	return 0;
+}
+
 static void xt2_blob_vfree(struct work_struct *work)
 {
 	struct xt2_rule_block *blob;
 
 	blob = container_of(work, struct xt2_rule_block, work);
+	xt2_blob_refput(blob);
 	vfree(blob);
 }
 
@@ -240,6 +315,7 @@ static void xt2_blob_free(struct rcu_head *rcu)
  *
  * Shrinks/enlarges the input blob by allocating a new memory block and
  * copying it over. (Freeing is done in the caller.)
+ * The caller should consider calling xt2_blob_refget() afterwards.
  */
 static void *
 xt2_blob_renew(struct xt2_rule_block *oldp, size_t offset, ssize_t change)
@@ -447,6 +523,13 @@ xt2_chain_dup(struct xt2_table *new_table, const struct xt2_chain *old)
 	}
 	if (old->rules != NULL && chain->rules != NULL)
 		xt2_net_set(chain->rules->netns, old->rules->netns);
+	if (chain->rules != NULL) {
+		ret = xt2_blob_refget(chain->rules);
+		if (ret != 0) {
+			xt2_chain_free(chain);
+			return ERR_PTR(ret);
+		}
+	}
 	return chain;
 }
 
@@ -597,6 +680,11 @@ int xt2_chain_splice(struct xt2_chain *chain, struct xt2_rule_buffer *rulebuf,
 		packed_rule = xt2_chain_next_rule(packed_rule);
 	}
 
+	ret = xt2_blob_refget(blob);
+	if (ret != 0) {
+		xt2_blob_vfree(&blob->work);
+		return ret;
+	}
 	old_blob = chain->rules;
 	rcu_assign_pointer(chain->rules, blob);
 	if (old_blob != NULL)
-- 
1.7.10.4

