From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 31/56] netfilter: xtables2: packet tracing
Date: Tue, 29 Jun 2010 10:43:11 +0200
Message-ID: <1277801017-30600-32-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44300 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754368Ab0F2IoO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:44:14 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/x_tables.c |   76 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 76 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 5303ae3..f4fce99 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -31,6 +31,7 @@
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
 #include <linux/netfilter_arp/arp_tables.h>
+#include <net/netfilter/nf_log.h>
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
@@ -1730,6 +1731,73 @@ void xt2_table_destroy(struct net *net, struct xt2_table *table)
 }
 EXPORT_SYMBOL_GPL(xt2_table_destroy);
 
+#if defined(CONFIG_NETFILTER_XT_TARGET_TRACE) || \
+    defined(CONFIG_NETFILTER_XT_TARGET_TRACE_MODULE)
+static struct nf_loginfo xt2_trace_loginfo __read_mostly = {
+	.type  = NF_LOG_TYPE_LOG,
+	.u.log = {
+		.level    = 4,
+		.logflags = NF_LOG_MASK,
+	},
+};
+
+static const char *xt2_verdict_string(unsigned int verdict)
+{
+	switch (verdict) {
+	case XT_RETURN:      return "RETURN";    break;
+	case XT_START_CHAIN: return "GOTO/JUMP"; break;
+	case XT_CONTINUE:    return "CONTINUE";  break;
+	}
+	switch (verdict & NF_VERDICT_MASK) {
+	case NF_ACCEPT: return "ACCEPT"; break;
+	case NF_DROP:   return "DROP";   break;
+	case NF_STOLEN: return "STOLEN"; break;
+	case NF_QUEUE:  return "QUEUE";  break;
+	case NF_STOP:   return "STOP";   break;
+	default:        return "?";      break;
+	}
+}
+
+static void
+xt2_trace_packet(const struct sk_buff *skb, unsigned int hook,
+		 const struct net_device *in, const struct net_device *out,
+		 const struct xt2_chain *chain, const struct xt2_rule *rule,
+		 unsigned int verdict)
+{
+	static const char *const builtin_chain_names[] = {
+		[NF_INET_PRE_ROUTING]  = "PREROUTING",
+		[NF_INET_LOCAL_IN]     = "INPUT",
+		[NF_INET_FORWARD]      = "FORWARD",
+		[NF_INET_LOCAL_OUT]    = "OUTPUT",
+		[NF_INET_POST_ROUTING] = "POSTROUTING",
+	};
+	const struct xt2_table *table = chain->table;
+	const struct xt2_rule *zrule;
+	unsigned int rule_index = 0;
+	const char *chain_name, *comment;
+
+	chain_name = xt2_builtin_chain(chain) ?
+		     builtin_chain_names[hook] : chain->name;
+	if (rule != NULL)
+		list_for_each_entry(zrule, &chain->rule_list, anchor) {
+			++rule_index;
+			if (zrule == rule)
+				break;
+		}
+
+	if (rule == NULL)
+		comment = "return"; /* end-of-chain */
+	else if (rule == chain->table->underflow[hook])
+		comment = "policy";
+	else
+		comment = "rule";
+
+	nf_log_packet(table->nfproto, hook, skb, in, out, &xt2_trace_loginfo,
+		      "TRACE: %s:%s:%s:%u:%s ", table->name, chain_name,
+		      comment, rule_index, xt2_verdict_string(verdict));
+}
+#endif
+
 static unsigned int
 xt2_do_actions(struct sk_buff *skb, struct xt_action_param *acpar,
 	       const struct xt2_rule *rule, const struct xt2_chain **chain_ptr,
@@ -1805,6 +1873,14 @@ xt2_do_table(struct sk_buff *skb, unsigned int hook,
 		verdict = xt2_do_actions(skb, &acpar, rule, &chain, stackptr,
 					 table->stacksize, jumpstack);
 
+#if defined(CONFIG_NETFILTER_XT_TARGET_TRACE) || \
+    defined(CONFIG_NETFILTER_XT_TARGET_TRACE_MODULE)
+	if (unlikely(skb->nf_trace))
+		xt2_trace_packet(skb, hook, in, out, rule->chain,
+			(&rule->anchor == &chain->rule_list) ? NULL : rule,
+			verdict);
+#endif
+
 	switch (verdict) {
 	case XT_START_CHAIN:
 		goto do_chain;
-- 
1.7.1

