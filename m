From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 5/8] netfilter: xtables2: support for entering/dumping match actions
Date: Tue,  4 Dec 2012 02:00:46 +0100
Message-ID: <1354582849-26888-6-git-send-email-jengelh@inai.de>
References: <1354582849-26888-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:49568 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab2LDBBA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 20:01:00 -0500
In-Reply-To: <1354582849-26888-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Make the NFXTM_RULE_ENTRY handler understand NFXTA_MATCH* attributes,
process them during compaction, and spit them out again during dump.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/net/netfilter/xt_core.h                  |   11 ++
 include/uapi/linux/netfilter/nfnetlink_xtables.h |   14 +++
 net/netfilter/xt_core.c                          |  147 ++++++++++++++++++++--
 net/netfilter/xt_nfnetlink.c                     |  102 +++++++++++++++
 4 files changed, 262 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/xt_core.h b/include/net/netfilter/xt_core.h
index 9e79f77..29918c9 100644
--- a/include/net/netfilter/xt_core.h
+++ b/include/net/netfilter/xt_core.h
@@ -73,6 +73,7 @@ struct net;
 struct nf_hook_ops;
 struct xt2_proto_rule;
 struct xt2_rule_buffer;
+struct xt_match;
 
 /**
  * A rule is composed of zero or more actions, which are specified here
@@ -81,6 +82,7 @@ struct xt2_rule_buffer;
 enum xt2_action_type {
 	NFXT_ACTION_FILLER = 0,
 	NFXT_ACTION_VERDICT,
+	NFXT_ACTION_MATCH,
 };
 
 /**
@@ -189,6 +191,7 @@ struct xt2_packed_action {
 	uint8_t type;
 	union {
 		unsigned int verdict;
+		const struct xt_match *match_ext;
 	};
 	char data[] __xt_int_aligned;
 };
@@ -197,12 +200,20 @@ struct xt2_packed_action {
  * @anchor:	list anchor for parent (struct xt2_rule.action_list);
  * @type:	type of this action (cf. enum xt2_action_type)
  * @verdict:	%NF_{ACCEPT,DROP,...} if type is %NFXT_ACTION_VERDICT
+ * @mt:		match/target with parameter block
  */
 struct xt2_proto_action {
 	struct list_head anchor;
 	uint8_t type;
 	union {
 		unsigned int verdict;
+		struct {
+			char name[XT_EXTENSION_MAXNAMELEN];
+			uint8_t revision;
+			unsigned int dsize;
+			void *data;
+			const struct xt_match *match_ext;
+		} mt;
 	};
 };
 
diff --git a/include/uapi/linux/netfilter/nfnetlink_xtables.h b/include/uapi/linux/netfilter/nfnetlink_xtables.h
index 80312da..988acb4 100644
--- a/include/uapi/linux/netfilter/nfnetlink_xtables.h
+++ b/include/uapi/linux/netfilter/nfnetlink_xtables.h
@@ -51,6 +51,10 @@ enum nfxt_msg_type {
  * %NFXTA_HOOK_PRIORITY:	(base chains:) priority for the hook
  * %NFXTA_HOOK_NFPROTO:		(base chains:) nfproto to add the hook for
  * %NFXTA_VERDICT:		verdict action in a rule
+ * %NFXTA_MATCH:		container for match action
+ * %NFXTA_REVISION:		revision for match/target action
+ * %NFXTA_ACTION_NAME:		name of action extension
+ * %NFXTA_ACTION_DATA:		opaque parameter block for match/target
  */
 enum nfxt_attr_type {
 	NFXTA_UNSPEC = 0,
@@ -67,6 +71,10 @@ enum nfxt_attr_type {
 	NFXTA_HOOK_PRIORITY,
 	NFXTA_HOOK_NFPROTO,
 	NFXTA_VERDICT,
+	NFXTA_MATCH,
+	NFXTA_REVISION,
+	NFXTA_ACTION_NAME,
+	NFXTA_ACTION_DATA,
 };
 
 /**
@@ -84,6 +92,9 @@ enum nfxt_attr_type {
  * %NFXTE_CHAIN_IS_DEMOTED:	Chain is already in demoted state
  * %NFXTE_UNKNOWN_ATTRIBUTE:	The nlmsg contained an attribute that was not
  * 				understood and not ignored.
+ * %NFXTE_ACTION_NOENT:		A match/target by that name was not found
+ * %NFXTE_ACTION_MISMATCH:	Unexpected parameter block size from userspace
+ * %NFXTE_ACTION_REJECTED:	Checkentry of match/target rejected parameters
  */
 enum nfxt_errno {
 	NFXTE_SUCCESS = 0,
@@ -97,6 +108,9 @@ enum nfxt_errno {
 	NFXTE_CHAIN_IS_PROMOTED,
 	NFXTE_CHAIN_IS_DEMOTED,
 	NFXTE_UNKNOWN_ATTRIBUTE,
+	NFXTE_ACTION_NOENT,
+	NFXTE_ACTION_MISMATCH,
+	NFXTE_ACTION_REJECTED,
 };
 
 #endif /* _LINUX_NFNETLINK_XTABLES_H */
diff --git a/net/netfilter/xt_core.c b/net/netfilter/xt_core.c
index ef31215..548ddb8 100644
--- a/net/netfilter/xt_core.c
+++ b/net/netfilter/xt_core.c
@@ -24,6 +24,8 @@
 #include <net/netfilter/xt_core.h>
 #include "xt_nfnetlink.h"
 
+#define NFXT_MASTER_TABLE "master"
+
 #define xt2_foreach_rule_continue(rule, chain) \
 	for (; \
 	     (rule) != NULL && (rule) < xt2_chain_stop_rule(chain); \
@@ -177,8 +179,14 @@ void xt2_rule_free(struct xt2_proto_rule *rule)
 {
 	struct xt2_proto_action *action, *next;
 
-	list_for_each_entry_safe(action, next, &rule->action_list, anchor)
+	list_for_each_entry_safe(action, next, &rule->action_list, anchor) {
+		if (action->type == NFXT_ACTION_MATCH) {
+			if (action->mt.match_ext != NULL)
+				module_put(action->mt.match_ext->me);
+			kfree(action->mt.data);
+		}
 		kfree(action);
+	}
 	kfree(rule);
 }
 
@@ -209,12 +217,72 @@ void xt2_rulebuf_free(struct xt2_rule_buffer *rb)
 	kfree(rb);
 }
 
+/**
+ * After copying a match/target action, reference counts need to be grabbed
+ * for the new instance, and it needs to be revalidated by calling checkentry
+ * as well.
+ */
+static int xt2_match_refget(struct xt2_packed_action *pa, struct net *net)
+{
+	const struct xt_match *m = pa->match_ext;
+	struct xt_mtchk_param ckpar;
+	int ret;
+
+	if (m == NULL)
+		return 0;
+	if (!try_module_get(m->me))
+		return -ENOENT;
+	if (m->matchsize != -1 && m->matchsize != pa->dsize) {
+		pr_info("Invalid data size for match: "
+			"%u (kernel) != %u (user)\n",
+			m->matchsize, pa->dsize);
+		module_put(m->me);
+		return -EINVAL;
+	}
+	ckpar.net       = net;
+	ckpar.table     = NFXT_MASTER_TABLE;
+	ckpar.entryinfo = NULL;
+	ckpar.match     = m;
+	ckpar.matchinfo = pa->data;
+	ckpar.hook_mask = ~0U;
+	ckpar.family    = NFPROTO_UNSPEC;
+	if (m->checkentry == NULL)
+		return 0;
+	ret = m->checkentry(&ckpar);
+	if (ret == 0)
+		return 0;
+	module_put(m->me);
+	return ret;
+}
+
+/**
+ * Tear down a packed match, which includes calling the destroy function
+ * (if defined) and dropping the reference count on the extension.
+ */
+static void xt2_match_refput(struct xt2_packed_action *pa, struct net *net)
+{
+	const struct xt_match *m = pa->match_ext;
+	struct xt_mtdtor_param dtpar;
+
+	if (m == NULL)
+		return;
+	if (m->destroy != NULL) {
+		dtpar.net       = net;
+		dtpar.match     = m;
+		dtpar.matchinfo = pa->data;
+		dtpar.family    = NFPROTO_UNSPEC;
+		m->destroy(&dtpar);
+	}
+	module_put(m->me);
+}
+
 static void xt2_rule_refput(struct xt2_packed_rule *rule, struct net *net)
 {
 	struct xt2_packed_action *action;
 
 	xt2_foreach_action(action, rule) {
-		/* To be filled in. */
+		if (action->type == NFXT_ACTION_MATCH)
+			xt2_match_refput(action, net);
 	}
 }
 
@@ -224,9 +292,14 @@ static int xt2_rule_refget(struct xt2_packed_rule *rule, struct net *net)
 	int ret = 0;
 
 	xt2_foreach_action(action, rule) {
-		/* <- To be filled in, for matches and targets. */
-		if (action->type != NFXT_ACTION_VERDICT)
+		if (action->type == NFXT_ACTION_VERDICT) {
+			/* nothing */
+		} else if (action->type == NFXT_ACTION_MATCH) {
+			ret = xt2_match_refget(action, net);
+		} else {
 			WARN_ON(true);
+			ret = -EIO;
+		}
 		if (ret != 0) {
 			/* Trim rule and only unroll prior entities. */
 			rule->dsize = (const char *)action - rule->data;
@@ -543,7 +616,11 @@ static void xt2_splice_prepare_rules(struct xt2_rule_buffer *buffer)
 		z = 0;
 		list_for_each_entry(action, &rule->action_list, anchor) {
 			z += sizeof(struct xt2_packed_action);
-			if (action->type != NFXT_ACTION_VERDICT)
+			if (action->type == NFXT_ACTION_VERDICT)
+				/* nothing */;
+			else if (action->type == NFXT_ACTION_MATCH)
+				z += XT_ALIGN(action->mt.dsize);
+			else
 				WARN_ON(true);
 		}
 		rule->packed_size = z;
@@ -606,17 +683,43 @@ static int xt2_splice_find_offsets(struct xt2_splice_state *spl)
 }
 
 /**
+ * First, we lookup all the extensions by <name,revision>, get a reference
+ * (by way of xt_request_find_match), and this so-obtained reference belongs
+ * to the proto_action. Only if all proto_actions successfully were
+ * transformed, will the packed actions get their own reference.
+ */
+static int xt2_splice_match(struct xt2_packed_action *pa,
+			    struct xt2_proto_action *action)
+{
+	const struct xt_match *m;
+
+	m = xt_request_find_match(NFPROTO_UNSPEC, action->mt.name,
+				  action->mt.revision);
+	if (IS_ERR(m))
+		return PTR_ERR(m);
+	action->mt.match_ext = m;
+	pa->match_ext = m;
+	pa->dsize = action->mt.dsize;
+	memcpy(pa->data, action->mt.data, pa->dsize);
+	kfree(action->mt.data);
+	action->mt.data = NULL;
+	return 0;
+}
+
+/**
  * @packed_rule:	target buffer for packed rule
  * @proto_rule:		prototype rule
  *
  * Serializes @proto_rule into @packed_rule.
  */
-static void xt2_splice_rule(struct xt2_packed_rule *packed_rule,
-			    const struct xt2_proto_rule *proto_rule)
+static int
+xt2_splice_rule(struct net *net, struct xt2_packed_rule *packed_rule,
+		struct xt2_proto_rule *proto_rule)
 {
 	void *write_ptr = packed_rule->data;
-	const struct xt2_proto_action *action;
+	struct xt2_proto_action *action;
 	struct xt2_packed_action *pa;
+	int ret;
 
 	packed_rule->dsize = proto_rule->packed_size;
 	list_for_each_entry(action, &proto_rule->action_list, anchor) {
@@ -624,9 +727,16 @@ static void xt2_splice_rule(struct xt2_packed_rule *packed_rule,
 		pa->type = action->type;
 		write_ptr = pa->data;
 
-		if (action->type == NFXT_ACTION_VERDICT)
+		if (action->type == NFXT_ACTION_VERDICT) {
 			pa->verdict = action->verdict;
+		} else if (action->type == NFXT_ACTION_MATCH) {
+			ret = xt2_splice_match(pa, action);
+			if (ret != 0)
+				return ret;
+			write_ptr = pa->data + XT_ALIGN(pa->dsize);
+		}
 	}
+	return 0;
 }
 
 /**
@@ -650,6 +760,7 @@ int xt2_chain_splice(struct xt2_chain *chain, struct xt2_rule_buffer *rulebuf,
 	struct xt2_proto_rule *proto_rule;
 	struct xt2_packed_rule *packed_rule;
 	struct xt2_rule_block *blob, *old_blob;
+	struct net *net = xt2_net_get(chain->table->netns);
 	int ret;
 
 	xt2_splice_prepare_rules(rulebuf);
@@ -669,14 +780,17 @@ int xt2_chain_splice(struct xt2_chain *chain, struct xt2_rule_buffer *rulebuf,
 		if (spl.b_insert != 0 || !list_empty(spl.rule_list))
 			/* Should not happen, but safe guards are cool. */
 			return -EOVERFLOW;
+		packed_rule = NULL;
 	} else {
 		xt2_net_set(blob->netns, chain->table->netns);
+		packed_rule = (struct xt2_packed_rule *)
+			      (blob->data + spl.b_offset);
 	}
 
-	/* Read proto rules and stream them into the blob. */
-	packed_rule = (void *)(blob->data + spl.b_offset);
 	list_for_each_entry(proto_rule, spl.rule_list, anchor) {
-		xt2_splice_rule(packed_rule, proto_rule);
+		ret = xt2_splice_rule(net, packed_rule, proto_rule);
+		if (ret != 0)
+			goto out;
 		packed_rule = xt2_chain_next_rule(packed_rule);
 	}
 
@@ -690,6 +804,15 @@ int xt2_chain_splice(struct xt2_chain *chain, struct xt2_rule_buffer *rulebuf,
 	if (old_blob != NULL)
 		call_rcu(&old_blob->rcu, xt2_blob_free);
 	return 0;
+
+ out:
+	/*
+	 * By resetting the size, the cleanup function will only process as
+	 * much as we had initialized.
+	 */
+	blob->size = packed_rule - xt2_chain_first_rule(blob);
+	xt2_blob_vfree(&blob->work);
+	return ret;
 }
 
 /*
diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index e44564c..c85548d 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -19,6 +19,7 @@
 #include <linux/skbuff.h>
 #include <linux/wait.h>
 #include <linux/netfilter.h>
+#include <linux/netfilter/x_tables.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_xtables.h>
 #include <net/netlink.h>
@@ -121,6 +122,10 @@ static const struct nla_policy xtnetlink_policy[] = {
 	[NFXTA_HOOK_PRIORITY]  = {.type = NLA_U32},
 	[NFXTA_HOOK_NFPROTO]   = {.type = NLA_U32},
 	[NFXTA_VERDICT]        = {.type = NLA_U32},
+	[NFXTA_MATCH]          = {.type = NLA_NESTED},
+	[NFXTA_REVISION]       = {.type = NLA_U32},
+	[NFXTA_ACTION_NAME]    = {.type = NLA_NUL_STRING},
+	[NFXTA_ACTION_DATA]    = {.type = NLA_BINARY},
 };
 
 static int
@@ -144,6 +149,16 @@ static LIST_HEAD(xtnetlink_transact_list);
 static const unsigned int xtnetlink_revision_max; /* = 0; */
 static const unsigned int xtnetlink_revision_min; /* = 0; */
 
+static void *xtnetlink_kmemdup(const void *ptr, size_t size)
+{
+	void *result = kmalloc(size, GFP_KERNEL);
+
+	if (result == NULL)
+		return NULL;
+	memcpy(result, ptr, size);
+	return result;
+}
+
 /**
  * Create a new transaction state.
  * @net:	network namespace of socket
@@ -993,6 +1008,37 @@ xtnetlink_emit_verdict(struct sk_buff *skb, const struct xt2_packed_action *pa)
 	return 0;
 }
 
+/**
+ * @skb:	netlink packet for userspace to be filled
+ * @pa:		packed action from the active ruleset
+ *
+ * Append the attributes for a match action into the skb. Note that the
+ * emission of %NFXTA_ACTION_DATA is suppressed if the data size is 0. This
+ * goes in line with %NFXTA_ACTION_DATA not being mandatory during rule input
+ * either.
+ */
+static int xtnetlink_emit_mt(unsigned int attr_type, struct sk_buff *skb,
+			     const struct xt2_packed_action *pa)
+{
+	struct nlattr *nest;
+
+	nest = nla_nest_start(skb, attr_type);
+	if (nest == NULL)
+		return -EMSGSIZE;
+	if (nla_put_string(skb, NFXTA_ACTION_NAME, pa->match_ext->name) != 0)
+		goto out;
+	if (nla_put_u8(skb, NFXTA_REVISION, pa->match_ext->revision) != 0)
+		goto out;
+	if (pa->dsize > 0 &&
+	    nla_put(skb, NFXTA_ACTION_DATA, pa->dsize, pa->data) != 0)
+		goto out;
+	nla_nest_end(skb, nest);
+	return 0;
+ out:
+	nla_nest_cancel(skb, nest);
+	return -EMSGSIZE;
+}
+
 static int xtnetlink_emit_chain(struct sk_buff *, struct netlink_callback *);
 
 static int
@@ -1013,6 +1059,8 @@ xtnetlink_emit_rule(struct sk_buff *skb, struct netlink_callback *nl_cb)
 	xt2_foreach_action(action, rule) {
 		if (action->type == NFXT_ACTION_VERDICT)
 			ret = xtnetlink_emit_verdict(skb, action);
+		else if (action->type == NFXT_ACTION_MATCH)
+			ret = xtnetlink_emit_mt(NFXTA_MATCH, skb, action);
 		else
 			ret = -EIO;
 		if (ret != 0)
@@ -1236,11 +1284,57 @@ static int xtnetlink_table_dump(struct sock *xtnl, struct sk_buff *iskb,
 	return netlink_dump_start(xtnl, iskb, imsg, &ctl);
 }
 
+/**
+ * @action:	the proto action structure to be filled
+ * @container:	the %NFXTA_{MATCH,TARGET} attribute container
+ *
+ * Parse an %NFXTA_MATCH/%NFXTA_TARGET nested attribute and fill in a
+ * struct xt2_proto_action. The absence of a zero-side parameter block is
+ * indicated by the absence of the %NFXTA_ACTION_DATA attribute.
+ */
+static int
+xtnetlink_rule_mt(struct xt2_proto_action *action, const struct nlattr *cont)
+{
+	struct nlattr **tb;
+	int ret;
+
+	tb = kmalloc(sizeof(*tb) * ARRAY_SIZE(xtnetlink_policy), GFP_KERNEL);
+	if (tb == NULL)
+		return -ENOMEM;
+	ret = nla_parse_nested(tb, ARRAY_SIZE(xtnetlink_policy),
+			       cont, xtnetlink_policy);
+	if (ret < 0)
+		goto out;
+	if (tb[NFXTA_ACTION_NAME] == NULL || tb[NFXTA_REVISION] == NULL) {
+		ret = NFXTE_ATTRSET_INCOMPLETE;
+		goto out;
+	}
+	action->type = NFXT_ACTION_MATCH;
+	strlcpy(action->mt.name, nla_data(tb[NFXTA_ACTION_NAME]),
+		sizeof(action->mt.name));
+	action->mt.revision = nla_get_u32(tb[NFXTA_REVISION]);
+	if (tb[NFXTA_ACTION_DATA] != NULL) {
+		action->mt.dsize = nla_len(tb[NFXTA_ACTION_DATA]);
+		action->mt.data  = xtnetlink_kmemdup(nla_data(tb[NFXTA_ACTION_DATA]),
+						     action->mt.dsize);
+		if (action->mt.data == NULL) {
+			ret = -ENOMEM;
+			goto out;
+		}
+	} else {
+		action->mt.dsize = 0;
+	}
+ out:
+	kfree(tb);
+	return ret;
+}
+
 static int xtnetlink_rule_fill(struct xt2_proto_rule *rule,
 			       const struct nlattr *attr)
 {
 	struct xt2_proto_action *action;
 	unsigned int attr_type = nla_type(attr);
+	int ret;
 
 	action = kmalloc(sizeof(*action), GFP_KERNEL);
 	if (action == NULL)
@@ -1249,12 +1343,20 @@ static int xtnetlink_rule_fill(struct xt2_proto_rule *rule,
 	if (attr_type == NFXTA_VERDICT) {
 		action->type = NFXT_ACTION_VERDICT;
 		action->verdict = nla_get_u32(attr);
+	} else if (attr_type == NFXTA_MATCH) {
+		ret = xtnetlink_rule_mt(action, attr);
+		if (ret != 0)
+			goto out;
 	} else {
 		kfree(action);
 		return NFXTE_UNKNOWN_ATTRIBUTE;
 	}
 	list_add_tail(&action->anchor, &rule->action_list);
 	return 0;
+
+ out:
+	kfree(action);
+	return ret;
 }
 
 static int xtnetlink_rule_entry(struct sock *xtnl, struct sk_buff *iskb,
-- 
1.7.10.4

