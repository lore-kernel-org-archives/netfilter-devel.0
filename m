From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 07/11] netfilter: xtables2: rule dumping
Date: Fri, 16 Nov 2012 02:23:41 +0100
Message-ID: <1353029025-31635-8-git-send-email-jengelh@inai.de>
References: <1353029025-31635-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:45178 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751219Ab2KPBX5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:23:57 -0500
In-Reply-To: <1353029025-31635-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Now that the chain blob is populated (by previous commit), it can be
traversed and dumped to userspace.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 net/netfilter/xt_nfnetlink.c |   43 +++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 42 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index 60e883f..26a8c51 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -99,10 +99,12 @@ struct xtnetlink_transact {
  * struct netlink_callback->args[x] holds, for different x:
  * %NLCBA_TABLE_PTR:	a pointer to the currently traversed table
  * %NLCBA_CHAIN_PTR:	a pointer to the currently traversed chain
+ * %NLCBA_RULE_PTR:	a pointer to the currently traversed rule
  */
 enum {
 	NLCBA_TABLE_PTR = 0,
 	NLCBA_CHAIN_PTR,
+	NLCBA_RULE_PTR,
 };
 
 /**
@@ -818,6 +820,40 @@ xtnetlink_emit_final(struct sk_buff *skb, struct netlink_callback *nl_cb)
 	return 0;
 }
 
+static int xtnetlink_emit_chain(struct sk_buff *, struct netlink_callback *);
+
+static int
+xtnetlink_emit_rule(struct sk_buff *skb, struct netlink_callback *nl_cb)
+{
+	struct xtnetlink_pktref oldref =
+		{.c_skb = nl_cb->skb, .c_msg = nl_cb->nlh};
+	struct xt2_table *table = (void *)nl_cb->args[NLCBA_TABLE_PTR];
+	struct xt2_chain *chain = (void *)nl_cb->args[NLCBA_CHAIN_PTR];
+	struct xt2_packed_rule *rule = (void *)nl_cb->args[NLCBA_RULE_PTR];
+	struct nlmsghdr *msg = NULL;
+
+	msg = xtnetlink_fill(skb, &oldref, NLM_F_MULTI);
+	msg->nlmsg_type = MAKE_TAGGED_TYPE(NFXTM_RULE_ENTRY);
+	nlmsg_end(skb, msg);
+
+	/* Note chain->rules is always valid if we got here to emit rules. */
+	rule = xt2_chain_next_rule(rule);
+	if (rule < xt2_chain_stop_rule(chain->rules)) {
+		nl_cb->args[NLCBA_RULE_PTR] = (uintptr_t)rule;
+	} else if (table != NULL && chain->anchor.next != &table->chain_list) {
+		/* Advance to next chain */
+		chain = list_entry(chain->anchor.next,
+				   __typeof__(*chain), anchor);
+		nl_cb->args[NLCBA_CHAIN_PTR] = (uintptr_t)chain;
+		nl_cb->dump = xtnetlink_emit_chain;
+	} else {
+		/* No more chains either */
+		nl_cb->dump = xtnetlink_emit_final;
+	}
+
+	return skb->len;
+}
+
 static int
 xtnetlink_emit_chain(struct sk_buff *skb, struct netlink_callback *nl_cb)
 {
@@ -833,12 +869,17 @@ xtnetlink_emit_chain(struct sk_buff *skb, struct netlink_callback *nl_cb)
 		goto nla_put_failure;
 	nlmsg_end(skb, msg);
 
-	if (table != NULL && chain->anchor.next != &table->chain_list) {
+	if (chain->rules != NULL) {
+		/* If there are rules, they need to be dumped next. */
+		nl_cb->args[NLCBA_RULE_PTR] = (uintptr_t)chain->rules->data;
+		nl_cb->dump = xtnetlink_emit_rule;
+	} else if (table != NULL && chain->anchor.next != &table->chain_list) {
 		/* Advance to next chain and keep nl_cb->dump. */
 		chain = list_entry(chain->anchor.next,
 				   __typeof__(*chain), anchor);
 		nl_cb->args[NLCBA_CHAIN_PTR] = (uintptr_t)chain;
 	} else {
+		/* No more chains present */
 		nl_cb->dump = xtnetlink_emit_final;
 	}
 	return skb->len;
-- 
1.7.10.4

