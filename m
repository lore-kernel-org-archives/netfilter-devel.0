From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 6/8] netfilter: xtables2: execute matches in live rule traversal
Date: Tue,  4 Dec 2012 02:00:47 +0100
Message-ID: <1354582849-26888-7-git-send-email-jengelh@inai.de>
References: <1354582849-26888-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:49569 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751865Ab2LDBA7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 20:00:59 -0500
In-Reply-To: <1354582849-26888-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 net/netfilter/xt_core.c |   46 ++++++++++++++++++++++++++++++++++------------
 1 file changed, 34 insertions(+), 12 deletions(-)

diff --git a/net/netfilter/xt_core.c b/net/netfilter/xt_core.c
index 548ddb8..756d186 100644
--- a/net/netfilter/xt_core.c
+++ b/net/netfilter/xt_core.c
@@ -93,16 +93,25 @@ struct xt2_pernet_data *xtables2_pernet(struct net *net)
 
 /**
  * Evaluate one rule for the given packet. Will return %XT_CONTINUE when the
- * next rule is to be looked at.
+ * next rule is to be looked at, which can happen if a match extension yields
+ * the result "false" (packet did not match) or when the end of the action list
+ * is reached.
  */
 static unsigned int
-xt2_do_rule(struct sk_buff *skb, const struct xt2_packed_rule *rule)
+xt2_do_rule(struct sk_buff *skb, const struct xt2_packed_rule *rule,
+	    struct xt_action_param *acpar)
 {
 	const struct xt2_packed_action *pa;
 
 	xt2_foreach_action(pa, rule)
-		if (pa->type == NFXT_ACTION_VERDICT)
+		if (pa->type == NFXT_ACTION_VERDICT) {
 			return pa->verdict;
+		} else if (pa->type == NFXT_ACTION_MATCH) {
+			acpar->match     = pa->match_ext;
+			acpar->matchinfo = pa->data;
+			if (!pa->match_ext->match(skb, acpar))
+				break;
+		}
 
 	return XT_CONTINUE;
 }
@@ -110,22 +119,35 @@ xt2_do_rule(struct sk_buff *skb, const struct xt2_packed_rule *rule)
 /**
  * @skb:	packet to process
  * @chain:	chain to begin traversal at
- * @table:	table that @chain belongs to
- * @in:		interface through which @skb was received, if any (or %NULL)
- * @out:	interface through which @skb will leave, if any (or %NULL)
- * @ops:	netfilter hook that got us here, if any
+ * @in_dev:	interface through which @skb was received, if any (or %NULL)
+ * @out_dev:	interface through which @skb will leave, if any (or %NULL)
+ * @hook_ops:	netfilter hook that got us here, if any
  *
  * Feed a packet through the ruleset. Caller should have entered RCU.
  */
 static unsigned int
-xt2_do_table(struct sk_buff *skb, const struct xt2_chain *chain)
+xt2_do_table(struct sk_buff *skb, const struct xt2_chain *chain,
+	     const struct net_device *in_dev, const struct net_device *out_dev,
+	     const struct nf_hook_ops *hook_ops)
 {
 	const struct xt2_rule_block *rule_blob = rcu_dereference(chain->rules);
 	const struct xt2_packed_rule *rule;
 	unsigned int verdict = XT_CONTINUE;
-
-	xt2_foreach_rule(rule, rule_blob)
-		verdict = xt2_do_rule(skb, rule);
+	struct xt_action_param acpar;
+
+	acpar.fragoff = 0;
+	acpar.thoff   = 0;
+	acpar.hotdrop = false;
+	acpar.in      = in_dev;
+	acpar.out     = out_dev;
+	acpar.family  = hook_ops->pf;
+	acpar.hooknum = hook_ops->hooknum;
+
+	xt2_foreach_rule(rule, rule_blob) {
+		verdict = xt2_do_rule(skb, rule, &acpar);
+		if (verdict != XT_CONTINUE)
+			break;
+	}
 
 	return (verdict != XT_CONTINUE) ? verdict : NF_ACCEPT;
 }
@@ -154,7 +176,7 @@ xt2_hook_entry(struct sk_buff *skb, const struct nf_hook_ops *ops,
 	 * evaluation of the old table and return %NF_ACCEPT.
 	 */
 	if (chain->table == table)
-		ret = xt2_do_table(skb, chain);
+		ret = xt2_do_table(skb, chain, in, out, ops);
 
 	rcu_read_unlock();
 	return ret;
-- 
1.7.10.4

