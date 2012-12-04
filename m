From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/8] netfilter: xtables2: execute verdicts in live rule traversal
Date: Tue,  4 Dec 2012 02:00:43 +0100
Message-ID: <1354582849-26888-3-git-send-email-jengelh@inai.de>
References: <1354582849-26888-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:49564 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751236Ab2LDBA6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 20:00:58 -0500
In-Reply-To: <1354582849-26888-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Have the main packet processing function understand verdicts, and act
accordingly.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 net/netfilter/xt_core.c      |   21 +++++++++++++++++++--
 net/netfilter/xt_nfnetlink.c |    4 +++-
 2 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/xt_core.c b/net/netfilter/xt_core.c
index 179ab1b..4bde992 100644
--- a/net/netfilter/xt_core.c
+++ b/net/netfilter/xt_core.c
@@ -82,6 +82,22 @@ struct xt2_pernet_data *xtables2_pernet(struct net *net)
 }
 
 /**
+ * Evaluate one rule for the given packet. Will return %XT_CONTINUE when the
+ * next rule is to be looked at.
+ */
+static unsigned int
+xt2_do_rule(struct sk_buff *skb, const struct xt2_packed_rule *rule)
+{
+	const struct xt2_packed_action *pa;
+
+	xt2_foreach_action(pa, rule)
+		if (pa->type == NFXT_ACTION_VERDICT)
+			return pa->verdict;
+
+	return XT_CONTINUE;
+}
+
+/**
  * @skb:	packet to process
  * @chain:	chain to begin traversal at
  * @table:	table that @chain belongs to
@@ -96,11 +112,12 @@ xt2_do_table(struct sk_buff *skb, const struct xt2_chain *chain)
 {
 	const struct xt2_rule_block *rule_blob = rcu_dereference(chain->rules);
 	const struct xt2_packed_rule *rule;
+	unsigned int verdict = XT_CONTINUE;
 
 	xt2_foreach_rule(rule, rule_blob)
-		pr_debug("Hit a rule");
+		verdict = xt2_do_rule(skb, rule);
 
-	return NF_ACCEPT;
+	return (verdict != XT_CONTINUE) ? verdict : NF_ACCEPT;
 }
 
 /**
diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index 4d3fff4..e44564c 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -1240,12 +1240,14 @@ static int xtnetlink_rule_fill(struct xt2_proto_rule *rule,
 			       const struct nlattr *attr)
 {
 	struct xt2_proto_action *action;
+	unsigned int attr_type = nla_type(attr);
 
 	action = kmalloc(sizeof(*action), GFP_KERNEL);
 	if (action == NULL)
 		return -ENOMEM;
 	INIT_LIST_HEAD(&action->anchor);
-	if (attr->nla_type == NFXTA_VERDICT) {
+	if (attr_type == NFXTA_VERDICT) {
+		action->type = NFXT_ACTION_VERDICT;
 		action->verdict = nla_get_u32(attr);
 	} else {
 		kfree(action);
-- 
1.7.10.4

