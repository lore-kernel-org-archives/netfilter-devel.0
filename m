From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 7/8] netfilter: xtables2: support for entering/dumping target actions
Date: Tue,  4 Dec 2012 02:00:48 +0100
Message-ID: <1354582849-26888-8-git-send-email-jengelh@inai.de>
References: <1354582849-26888-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:49570 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751722Ab2LDBBA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 20:01:00 -0500
In-Reply-To: <1354582849-26888-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/net/netfilter/xt_core.h                  |    8 +-
 include/uapi/linux/netfilter/nfnetlink_xtables.h |    2 +
 net/netfilter/xt_core.c                          |   86 +++++++++++++++++++++-
 net/netfilter/xt_nfnetlink.c                     |   10 ++-
 4 files changed, 101 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/xt_core.h b/include/net/netfilter/xt_core.h
index 29918c9..812eb26 100644
--- a/include/net/netfilter/xt_core.h
+++ b/include/net/netfilter/xt_core.h
@@ -74,6 +74,7 @@ struct nf_hook_ops;
 struct xt2_proto_rule;
 struct xt2_rule_buffer;
 struct xt_match;
+struct xt_target;
 
 /**
  * A rule is composed of zero or more actions, which are specified here
@@ -83,6 +84,7 @@ enum xt2_action_type {
 	NFXT_ACTION_FILLER = 0,
 	NFXT_ACTION_VERDICT,
 	NFXT_ACTION_MATCH,
+	NFXT_ACTION_TARGET,
 };
 
 /**
@@ -192,6 +194,7 @@ struct xt2_packed_action {
 	union {
 		unsigned int verdict;
 		const struct xt_match *match_ext;
+		const struct xt_target *target_ext;
 	};
 	char data[] __xt_int_aligned;
 };
@@ -212,7 +215,10 @@ struct xt2_proto_action {
 			uint8_t revision;
 			unsigned int dsize;
 			void *data;
-			const struct xt_match *match_ext;
+			union {
+				const struct xt_match *match_ext;
+				const struct xt_target *target_ext;
+			};
 		} mt;
 	};
 };
diff --git a/include/uapi/linux/netfilter/nfnetlink_xtables.h b/include/uapi/linux/netfilter/nfnetlink_xtables.h
index 988acb4..1863597 100644
--- a/include/uapi/linux/netfilter/nfnetlink_xtables.h
+++ b/include/uapi/linux/netfilter/nfnetlink_xtables.h
@@ -55,6 +55,7 @@ enum nfxt_msg_type {
  * %NFXTA_REVISION:		revision for match/target action
  * %NFXTA_ACTION_NAME:		name of action extension
  * %NFXTA_ACTION_DATA:		opaque parameter block for match/target
+ * %NFXTA_TARGET:		container for target action
  */
 enum nfxt_attr_type {
 	NFXTA_UNSPEC = 0,
@@ -75,6 +76,7 @@ enum nfxt_attr_type {
 	NFXTA_REVISION,
 	NFXTA_ACTION_NAME,
 	NFXTA_ACTION_DATA,
+	NFXTA_TARGET,
 };
 
 /**
diff --git a/net/netfilter/xt_core.c b/net/netfilter/xt_core.c
index 756d186..8615fe4 100644
--- a/net/netfilter/xt_core.c
+++ b/net/netfilter/xt_core.c
@@ -206,6 +206,10 @@ void xt2_rule_free(struct xt2_proto_rule *rule)
 			if (action->mt.match_ext != NULL)
 				module_put(action->mt.match_ext->me);
 			kfree(action->mt.data);
+		} else if (action->type == NFXT_ACTION_TARGET) {
+			if (action->mt.target_ext != NULL)
+				module_put(action->mt.target_ext->me);
+			kfree(action->mt.data);
 		}
 		kfree(action);
 	}
@@ -298,6 +302,58 @@ static void xt2_match_refput(struct xt2_packed_action *pa, struct net *net)
 	module_put(m->me);
 }
 
+static int xt2_target_refget(struct xt2_packed_action *pa, struct net *net)
+{
+	const struct xt_target *t = pa->target_ext;
+	struct xt_tgchk_param ckpar;
+	int ret;
+
+	if (t == NULL)
+		return 0;
+	if (!try_module_get(t->me))
+		return -ENOENT;
+	if (t->targetsize != -1 && t->targetsize != pa->dsize) {
+		pr_info("Invalid data size for target: "
+			"%u (kernel) != %u (user)\n",
+			t->targetsize, pa->dsize);
+		module_put(t->me);
+		return -EINVAL;
+	}
+	ckpar.net       = net;
+	ckpar.table     = NFXT_MASTER_TABLE;
+	ckpar.entryinfo = NULL;
+	ckpar.target    = t;
+	ckpar.targinfo  = pa->data;
+	ckpar.hook_mask = ~0U;
+	ckpar.family    = NFPROTO_UNSPEC;
+	if (t->checkentry == NULL)
+		return 0;
+	ret = t->checkentry(&ckpar);
+	if (ret == 0)
+		return 0;
+	module_put(t->me);
+	pa->match_ext = NULL;
+	return ret;
+}
+
+static void xt2_target_refput(struct xt2_packed_action *pa, struct net *net)
+{
+	const struct xt_target *t = pa->target_ext;
+	struct xt_tgdtor_param dtpar;
+
+	if (t == NULL)
+		return;
+	if (t->destroy != NULL) {
+		dtpar.net      = net;
+		dtpar.target   = t;
+		dtpar.targinfo = pa->data;
+		dtpar.family   = NFPROTO_UNSPEC;
+		t->destroy(&dtpar);
+	}
+	module_put(t->me);
+}
+
+
 static void xt2_rule_refput(struct xt2_packed_rule *rule, struct net *net)
 {
 	struct xt2_packed_action *action;
@@ -305,6 +361,8 @@ static void xt2_rule_refput(struct xt2_packed_rule *rule, struct net *net)
 	xt2_foreach_action(action, rule) {
 		if (action->type == NFXT_ACTION_MATCH)
 			xt2_match_refput(action, net);
+		else if (action->type == NFXT_ACTION_TARGET)
+			xt2_target_refput(action, net);
 	}
 }
 
@@ -318,6 +376,8 @@ static int xt2_rule_refget(struct xt2_packed_rule *rule, struct net *net)
 			/* nothing */
 		} else if (action->type == NFXT_ACTION_MATCH) {
 			ret = xt2_match_refget(action, net);
+		} else if (action->type == NFXT_ACTION_TARGET) {
+			ret = xt2_target_refget(action, net);
 		} else {
 			WARN_ON(true);
 			ret = -EIO;
@@ -640,7 +700,8 @@ static void xt2_splice_prepare_rules(struct xt2_rule_buffer *buffer)
 			z += sizeof(struct xt2_packed_action);
 			if (action->type == NFXT_ACTION_VERDICT)
 				/* nothing */;
-			else if (action->type == NFXT_ACTION_MATCH)
+			else if (action->type == NFXT_ACTION_MATCH ||
+				 action->type == NFXT_ACTION_TARGET)
 				z += XT_ALIGN(action->mt.dsize);
 			else
 				WARN_ON(true);
@@ -728,6 +789,24 @@ static int xt2_splice_match(struct xt2_packed_action *pa,
 	return 0;
 }
 
+static int xt2_splice_target(struct xt2_packed_action *pa,
+			     struct xt2_proto_action *action)
+{
+	const struct xt_target *t;
+
+	t = xt_request_find_target(NFPROTO_UNSPEC, action->mt.name,
+				   action->mt.revision);
+	if (IS_ERR(t))
+		return PTR_ERR(t);
+	action->mt.target_ext = t;
+	pa->target_ext = t;
+	pa->dsize = action->mt.dsize;
+	memcpy(pa->data, action->mt.data, pa->dsize);
+	kfree(action->mt.data);
+	action->mt.data = NULL;
+	return 0;
+}
+
 /**
  * @packed_rule:	target buffer for packed rule
  * @proto_rule:		prototype rule
@@ -756,6 +835,11 @@ xt2_splice_rule(struct net *net, struct xt2_packed_rule *packed_rule,
 			if (ret != 0)
 				return ret;
 			write_ptr = pa->data + XT_ALIGN(pa->dsize);
+		} else if (action->type == NFXT_ACTION_TARGET) {
+			ret = xt2_splice_target(pa, action);
+			if (ret != 0)
+				return ret;
+			write_ptr = pa->data + XT_ALIGN(pa->dsize);
 		}
 	}
 	return 0;
diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index c85548d..c87d7f6 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -126,6 +126,7 @@ static const struct nla_policy xtnetlink_policy[] = {
 	[NFXTA_REVISION]       = {.type = NLA_U32},
 	[NFXTA_ACTION_NAME]    = {.type = NLA_NUL_STRING},
 	[NFXTA_ACTION_DATA]    = {.type = NLA_BINARY},
+	[NFXTA_TARGET]         = {.type = NLA_NESTED},
 };
 
 static int
@@ -1012,7 +1013,7 @@ xtnetlink_emit_verdict(struct sk_buff *skb, const struct xt2_packed_action *pa)
  * @skb:	netlink packet for userspace to be filled
  * @pa:		packed action from the active ruleset
  *
- * Append the attributes for a match action into the skb. Note that the
+ * Append the attributes for a match/target action into the skb. Note that the
  * emission of %NFXTA_ACTION_DATA is suppressed if the data size is 0. This
  * goes in line with %NFXTA_ACTION_DATA not being mandatory during rule input
  * either.
@@ -1061,6 +1062,8 @@ xtnetlink_emit_rule(struct sk_buff *skb, struct netlink_callback *nl_cb)
 			ret = xtnetlink_emit_verdict(skb, action);
 		else if (action->type == NFXT_ACTION_MATCH)
 			ret = xtnetlink_emit_mt(NFXTA_MATCH, skb, action);
+		else if (action->type == NFXT_ACTION_TARGET)
+			ret = xtnetlink_emit_mt(NFXTA_TARGET, skb, action);
 		else
 			ret = -EIO;
 		if (ret != 0)
@@ -1309,7 +1312,8 @@ xtnetlink_rule_mt(struct xt2_proto_action *action, const struct nlattr *cont)
 		ret = NFXTE_ATTRSET_INCOMPLETE;
 		goto out;
 	}
-	action->type = NFXT_ACTION_MATCH;
+	action->type = (nla_type(cont) == NFXTA_MATCH) ?
+		       NFXT_ACTION_MATCH : NFXT_ACTION_TARGET;
 	strlcpy(action->mt.name, nla_data(tb[NFXTA_ACTION_NAME]),
 		sizeof(action->mt.name));
 	action->mt.revision = nla_get_u32(tb[NFXTA_REVISION]);
@@ -1343,7 +1347,7 @@ static int xtnetlink_rule_fill(struct xt2_proto_rule *rule,
 	if (attr_type == NFXTA_VERDICT) {
 		action->type = NFXT_ACTION_VERDICT;
 		action->verdict = nla_get_u32(attr);
-	} else if (attr_type == NFXTA_MATCH) {
+	} else if (attr_type == NFXTA_MATCH || attr_type == NFXTA_TARGET) {
 		ret = xtnetlink_rule_mt(action, attr);
 		if (ret != 0)
 			goto out;
-- 
1.7.10.4

