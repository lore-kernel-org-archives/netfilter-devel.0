From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/8] netfilter: xtables2: support for entering/dumping rule verdicts
Date: Tue,  4 Dec 2012 02:00:42 +0100
Message-ID: <1354582849-26888-2-git-send-email-jengelh@inai.de>
References: <1354582849-26888-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:49567 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab2LDBA6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 20:00:58 -0500
In-Reply-To: <1354582849-26888-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This commit makes the NFXTM_RULE_ENTRY handler recognize NFXTA_VERDICT
attributes which are used to specify the final verdict (ACCEPT, DROP,
etc.) for a rule if matches prior to it yielded true. Similarly,
NFXTA_VERDICTs are now emitted on NFXTM_*_DUMP.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/net/netfilter/xt_core.h                  |   63 ++++++++++++++++++++++
 include/uapi/linux/netfilter/nfnetlink_xtables.h |    5 ++
 net/netfilter/xt_core.c                          |   38 ++++++++++---
 net/netfilter/xt_nfnetlink.c                     |   47 ++++++++++++++++
 4 files changed, 145 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/xt_core.h b/include/net/netfilter/xt_core.h
index d3150e0..a5b3ab6 100644
--- a/include/net/netfilter/xt_core.h
+++ b/include/net/netfilter/xt_core.h
@@ -18,6 +18,8 @@
 	BUILD_BUG_ON_ZERO( \
 		!__builtin_types_compatible_p(__typeof__(p), const type) && \
 		!__builtin_types_compatible_p(__typeof__(p), type))
+#define xt2_assert_is_packed_action(a) \
+	xt2_assert_is_type(struct xt2_packed_action *, (a))
 #define xt2_assert_is_packed_rule(r) \
 	xt2_assert_is_type(struct xt2_packed_rule *, (r))
 #define xt2_assert_is_rule_block(p) \
@@ -38,6 +40,20 @@
 	     (rule) != NULL && (rule) < xt2_chain_stop_rule(rule_block); \
 	     (rule) = xt2_chain_next_rule(rule))
 
+#define xt2_rule_first_action(packed_rule) \
+	((struct xt2_packed_action *)((packed_rule)->data + \
+	 xt2_assert_is_packed_rule(packed_rule)))
+#define xt2_rule_stop_action(packed_rule) \
+	((struct xt2_packed_action *)((packed_rule)->data + \
+	 (packed_rule)->dsize + xt2_assert_is_packed_rule(packed_rule)))
+#define xt2_rule_next_action(packed_action) \
+	((struct xt2_packed_action *)((packed_action)->data + \
+	 (packed_action)->dsize + xt2_assert_is_packed_action(packed_action)))
+#define xt2_foreach_action(action, packed_rule) \
+	for ((action) = xt2_rule_first_action(packed_rule); \
+	     (action) < xt2_rule_stop_action(packed_rule); \
+	     (action) = xt2_rule_next_action(action))
+
 /**
  * Misc constants.
  *
@@ -59,6 +75,15 @@ struct xt2_proto_rule;
 struct xt2_rule_buffer;
 
 /**
+ * A rule is composed of zero or more actions, which are specified here
+ * and used in struct xt2_proto_action.type and the packed ruleset.
+ */
+enum xt2_action_type {
+	NFXT_ACTION_FILLER = 0,
+	NFXT_ACTION_VERDICT,
+};
+
+/**
  * @master:	the master table
  * @master_lock:	protecting changes to @master
  */
@@ -118,9 +143,15 @@ struct xt2_chain {
  * A "prototype" rule is a data structure that collects a rule's match and
  * target parameters in a simple linked list - in principle anything that can
  * be easily appended to - until the rule is packed later.
+ *
+ * @anchor:		for parent xt2_rule_buffer
+ * @action_list:	list of collected actions
+ * @packed_size:	projected size for packed rule
+ * 			(without xt2_packed_rule header)
  */
 struct xt2_proto_rule {
 	struct list_head anchor;
+	struct list_head action_list;
 	unsigned int packed_size;
 };
 
@@ -134,6 +165,38 @@ struct xt2_packed_rule {
 	char data[] __xt_int_aligned;
 };
 
+/**
+ * @dsize:	size of the @data block
+ * @type:	%NFXT_ACTION_{VERDICT,...}
+ * @verdict:	%NF_{ACCEPT,DROP,...}
+ * @data:	custom data for this action, if any
+ *
+ * NB: Due to padding, @type-specific action structs would take up the same
+ * space, so we can just cumulate them in an union as well.
+ * NB: This is half the size of xt1's :)
+ */
+struct xt2_packed_action {
+	unsigned int dsize;
+	uint8_t type;
+	union {
+		unsigned int verdict;
+	};
+	char data[] __xt_int_aligned;
+};
+
+/**
+ * @anchor:	list anchor for parent (struct xt2_rule.action_list);
+ * @type:	type of this action (cf. enum xt2_action_type)
+ * @verdict:	%NF_{ACCEPT,DROP,...} if type is %NFXT_ACTION_VERDICT
+ */
+struct xt2_proto_action {
+	struct list_head anchor;
+	uint8_t type;
+	union {
+		unsigned int verdict;
+	};
+};
+
 extern struct xt2_pernet_data *xtables2_pernet(struct net *);
 
 extern struct xt2_proto_rule *xt2_rule_new(void);
diff --git a/include/uapi/linux/netfilter/nfnetlink_xtables.h b/include/uapi/linux/netfilter/nfnetlink_xtables.h
index 31c82c1..80312da 100644
--- a/include/uapi/linux/netfilter/nfnetlink_xtables.h
+++ b/include/uapi/linux/netfilter/nfnetlink_xtables.h
@@ -50,6 +50,7 @@ enum nfxt_msg_type {
  * 				(%NF_INET_*, %NF_ARP_*, %NF_BRIDGE_*, ...)
  * %NFXTA_HOOK_PRIORITY:	(base chains:) priority for the hook
  * %NFXTA_HOOK_NFPROTO:		(base chains:) nfproto to add the hook for
+ * %NFXTA_VERDICT:		verdict action in a rule
  */
 enum nfxt_attr_type {
 	NFXTA_UNSPEC = 0,
@@ -65,6 +66,7 @@ enum nfxt_attr_type {
 	NFXTA_HOOK_INDEX,
 	NFXTA_HOOK_PRIORITY,
 	NFXTA_HOOK_NFPROTO,
+	NFXTA_VERDICT,
 };
 
 /**
@@ -80,6 +82,8 @@ enum nfxt_attr_type {
  * %NFXTE_TRANSACT_INACTIVE:	Commit issued when no transaction active
  * %NFXTE_CHAIN_IS_PROMOTED:	Chain is already in promoted state
  * %NFXTE_CHAIN_IS_DEMOTED:	Chain is already in demoted state
+ * %NFXTE_UNKNOWN_ATTRIBUTE:	The nlmsg contained an attribute that was not
+ * 				understood and not ignored.
  */
 enum nfxt_errno {
 	NFXTE_SUCCESS = 0,
@@ -92,6 +96,7 @@ enum nfxt_errno {
 	NFXTE_TRANSACT_INACTIVE,
 	NFXTE_CHAIN_IS_PROMOTED,
 	NFXTE_CHAIN_IS_DEMOTED,
+	NFXTE_UNKNOWN_ATTRIBUTE,
 };
 
 #endif /* _LINUX_NFNETLINK_XTABLES_H */
diff --git a/net/netfilter/xt_core.c b/net/netfilter/xt_core.c
index 158bbfe..179ab1b 100644
--- a/net/netfilter/xt_core.c
+++ b/net/netfilter/xt_core.c
@@ -144,11 +144,16 @@ struct xt2_proto_rule *xt2_rule_new(void)
 	rule = kmalloc(sizeof(*rule), GFP_KERNEL);
 	if (rule == NULL)
 		return NULL;
+	INIT_LIST_HEAD(&rule->action_list);
 	return rule;
 }
 
 void xt2_rule_free(struct xt2_proto_rule *rule)
 {
+	struct xt2_proto_action *action, *next;
+
+	list_for_each_entry_safe(action, next, &rule->action_list, anchor)
+		kfree(action);
 	kfree(rule);
 }
 
@@ -418,16 +423,21 @@ xt2_chain_dup(struct xt2_table *new_table, const struct xt2_chain *old)
 	return chain;
 }
 
-/**
- * Compute the packed size from all the actions (matches and targets) attached
- * to a prototype rule.
- */
 static void xt2_splice_prepare_rules(struct xt2_rule_buffer *buffer)
 {
 	struct xt2_proto_rule *rule;
-
-	list_for_each_entry(rule, &buffer->rule_list, anchor)
-		rule->packed_size = 0;
+	struct xt2_proto_action *action;
+	size_t z;
+
+	list_for_each_entry(rule, &buffer->rule_list, anchor) {
+		z = 0;
+		list_for_each_entry(action, &rule->action_list, anchor) {
+			z += sizeof(struct xt2_packed_action);
+			if (action->type != NFXT_ACTION_VERDICT)
+				WARN_ON(true);
+		}
+		rule->packed_size = z;
+	}
 }
 
 /**
@@ -492,9 +502,21 @@ static int xt2_splice_find_offsets(struct xt2_splice_state *spl)
  * Serializes @proto_rule into @packed_rule.
  */
 static void xt2_splice_rule(struct xt2_packed_rule *packed_rule,
-			    struct xt2_proto_rule *proto_rule)
+			    const struct xt2_proto_rule *proto_rule)
 {
+	void *write_ptr = packed_rule->data;
+	const struct xt2_proto_action *action;
+	struct xt2_packed_action *pa;
+
 	packed_rule->dsize = proto_rule->packed_size;
+	list_for_each_entry(action, &proto_rule->action_list, anchor) {
+		pa = write_ptr;
+		pa->type = action->type;
+		write_ptr = pa->data;
+
+		if (action->type == NFXT_ACTION_VERDICT)
+			pa->verdict = action->verdict;
+	}
 }
 
 /**
diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index 3d40543..4d3fff4 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -120,6 +120,7 @@ static const struct nla_policy xtnetlink_policy[] = {
 	[NFXTA_HOOK_INDEX]     = {.type = NLA_U32},
 	[NFXTA_HOOK_PRIORITY]  = {.type = NLA_U32},
 	[NFXTA_HOOK_NFPROTO]   = {.type = NLA_U32},
+	[NFXTA_VERDICT]        = {.type = NLA_U32},
 };
 
 static int
@@ -984,6 +985,14 @@ xtnetlink_abort(struct sock *xtnl, struct sk_buff *iskb,
  * Any emit_ function is to be called with a properly set-up nl_cb->args[].
  */
 
+static int
+xtnetlink_emit_verdict(struct sk_buff *skb, const struct xt2_packed_action *pa)
+{
+	if (nla_put_u32(skb, NFXTA_VERDICT, pa->verdict) != 0)
+		return -EMSGSIZE;
+	return 0;
+}
+
 static int xtnetlink_emit_chain(struct sk_buff *, struct netlink_callback *);
 
 static int
@@ -995,10 +1004,20 @@ xtnetlink_emit_rule(struct sk_buff *skb, struct netlink_callback *nl_cb)
 		(const void *)nl_cb->args[NLCBA_CHAIN_PTR];
 	const struct xt2_packed_rule *rule =
 		(const void *)nl_cb->args[NLCBA_RULE_PTR];
+	const struct xt2_packed_action *action;
 	struct nlmsghdr *msg;
+	int ret;
 
 	msg = xtnetlink_fill_mhdr(skb, nl_cb);
 	msg->nlmsg_type = MAKE_TAGGED_TYPE(NFXTM_RULE_ENTRY);
+	xt2_foreach_action(action, rule) {
+		if (action->type == NFXT_ACTION_VERDICT)
+			ret = xtnetlink_emit_verdict(skb, action);
+		else
+			ret = -EIO;
+		if (ret != 0)
+			return 0; /* DULL DUMP INTERFACE */
+	}
 	nlmsg_end(skb, msg);
 
 	/* Note chain->rules is always valid if we got here to emit rules. */
@@ -1217,6 +1236,25 @@ static int xtnetlink_table_dump(struct sock *xtnl, struct sk_buff *iskb,
 	return netlink_dump_start(xtnl, iskb, imsg, &ctl);
 }
 
+static int xtnetlink_rule_fill(struct xt2_proto_rule *rule,
+			       const struct nlattr *attr)
+{
+	struct xt2_proto_action *action;
+
+	action = kmalloc(sizeof(*action), GFP_KERNEL);
+	if (action == NULL)
+		return -ENOMEM;
+	INIT_LIST_HEAD(&action->anchor);
+	if (attr->nla_type == NFXTA_VERDICT) {
+		action->verdict = nla_get_u32(attr);
+	} else {
+		kfree(action);
+		return NFXTE_UNKNOWN_ATTRIBUTE;
+	}
+	list_add_tail(&action->anchor, &rule->action_list);
+	return 0;
+}
+
 static int xtnetlink_rule_entry(struct sock *xtnl, struct sk_buff *iskb,
 				const struct nlmsghdr *imsg,
 				const struct nlattr *const *ad)
@@ -1225,6 +1263,8 @@ static int xtnetlink_rule_entry(struct sock *xtnl, struct sk_buff *iskb,
 		{.c_skb = iskb, .c_msg = imsg, .sock = xtnl};
 	struct xt2_proto_rule *rule;
 	struct xtnetlink_transact *xa;
+	const struct nlattr *attr;
+	unsigned int rem;
 	int ret;
 
 	xa = xtnetlink_transact_get(sock_net(xtnl), NETLINK_CB(iskb).portid,
@@ -1237,6 +1277,13 @@ static int xtnetlink_rule_entry(struct sock *xtnl, struct sk_buff *iskb,
 		ret = -ENOMEM;
 		goto out;
 	}
+
+	nlmsg_for_each_attr(attr, imsg, sizeof(struct nfgenmsg), rem) {
+		ret = xtnetlink_rule_fill(rule, attr);
+		if (ret != 0)
+			goto out2;
+	}
+
 	ret = xt2_rulebuf_push(xa->splice_param->rulebuf, rule);
 	if (ret < 0)
 		goto out2;
-- 
1.7.10.4

