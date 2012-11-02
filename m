From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 10/11] netfilter: xtables2: chain dump support
Date: Fri,  2 Nov 2012 04:38:42 +0100
Message-ID: <1351827523-10629-11-git-send-email-jengelh@inai.de>
References: <1351827523-10629-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:42673 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762710Ab2KBDkI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 23:40:08 -0400
In-Reply-To: <1351827523-10629-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds recognition for the NFXTM_CHAIN_DUMP request. A chain
snapshot is taken and then used to spool the contents (of which there
are not any yet, but still) to userspace in small Netlink bites.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/net/netfilter/xt_core.h                  |    1 +
 include/uapi/linux/netfilter/nfnetlink_xtables.h |    2 +
 net/netfilter/xt_core.c                          |    8 ++
 net/netfilter/xt_nfnetlink.c                     |  152 ++++++++++++++++++++++
 4 files changed, 163 insertions(+)

diff --git a/include/net/netfilter/xt_core.h b/include/net/netfilter/xt_core.h
index b0b496f..c706240 100644
--- a/include/net/netfilter/xt_core.h
+++ b/include/net/netfilter/xt_core.h
@@ -43,6 +43,7 @@ extern struct xt2_chain *xt2_chain_lookup(struct xt2_table *, const char *);
 extern void xt2_chain_free(struct xt2_chain *);
 extern struct xt2_chain *xt2_chain_move(struct xt2_table *, const char *,
 					const char *);
+extern struct xt2_chain *xt2_chain_dup(const struct xt2_chain *);
 
 extern struct xt2_table *xt2_table_new(void);
 extern void xt2_table_free(struct xt2_table *);
diff --git a/include/uapi/linux/netfilter/nfnetlink_xtables.h b/include/uapi/linux/netfilter/nfnetlink_xtables.h
index 44d6595..8bf422a 100644
--- a/include/uapi/linux/netfilter/nfnetlink_xtables.h
+++ b/include/uapi/linux/netfilter/nfnetlink_xtables.h
@@ -12,6 +12,7 @@
  * %NFXTM_COMMIT:	finalize and commit a transaction
  * %NFXTM_TABLE_REPLACE:start a table replace transaction
  * %NFXTM_ABORT:	abort an active transaction
+ * %NFXTM_CHAIN_DUMP:	retrieve chain properties and rules in the chain
  */
 enum nfxt_msg_type {
 	NFXTM_IDENTIFY = 1,
@@ -22,6 +23,7 @@ enum nfxt_msg_type {
 	NFXTM_COMMIT,
 	NFXTM_TABLE_REPLACE,
 	NFXTM_ABORT,
+	NFXTM_CHAIN_DUMP,
 };
 
 /**
diff --git a/net/netfilter/xt_core.c b/net/netfilter/xt_core.c
index 7c00e2d..584a172 100644
--- a/net/netfilter/xt_core.c
+++ b/net/netfilter/xt_core.c
@@ -129,6 +129,14 @@ struct xt2_chain *xt2_chain_move(struct xt2_table *table, const char *old_name,
 	return new_chain;
 }
 
+struct xt2_chain *xt2_chain_dup(const struct xt2_chain *old)
+{
+	WARN_ON(old == NULL);
+	if (old == NULL)
+		return ERR_PTR(-EINVAL);
+	return xt2_chain_new(NULL, old->name);
+}
+
 /**
  * Create a new table with no chains and no rules.
  */
diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index 4d4a076..c8163c6 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -68,6 +68,14 @@ struct xtnetlink_transact {
 };
 
 /**
+ * struct netlink_callback->args[x] holds, for different x:
+ * %NLCBA_CHAIN_PTR:	a pointer to the currently traversed chain
+ */
+enum {
+	NLCBA_CHAIN_PTR = 1,
+};
+
+/**
  * Write-locked: the one user may add/delete entries to/from transact_list
  * Read-locked: users only touch transaction entries' content
  */
@@ -342,6 +350,21 @@ xtnetlink_table_wput(struct xtnetlink_transact *xa, struct net *net,
 }
 
 /**
+ * Return a pointer to the live table, and only for a reading consumer.
+ * Symmetric call to xtnetlink_table_rput is required.
+ */
+static struct xt2_table *xtnetlink_table_rget(struct net *net)
+{
+	rcu_read_lock();
+	return rcu_dereference(xtables2_pernet(net)->master);
+}
+
+static void xtnetlink_table_rput(void)
+{
+	rcu_read_unlock();
+}
+
+/**
  * Ran too often into NULL derefs. Now there is a dummy function for unused
  * message type 0.
  */
@@ -590,6 +613,134 @@ xtnetlink_abort(struct sock *xtnl, struct sk_buff *iskb,
 	return xtnetlink_error(&ref, NFXTE_SUCCESS);
 }
 
+/*
+ * Table dumping is iterating over all chains it contains and simply calling
+ * their dump functions. Since only a single message can be emitted at a time,
+ * we have to remember where we left off. nl_cb->args[NLCBA_*] take care of
+ * that, but more importantly, so does nl_cb->dump, which essentially holds
+ * the state (in a Turing sense).
+ *
+ * digraph {
+ *   emit_table -> emit_final; -- no chains at all
+ *   emit_table -> emit_chain; -- chains exist
+ *   emit_chain -> emit_final; -- no further chains
+ *   emit_chain -> emit_chain; -- when this chain is empty and next one exists
+ *   emit_chain -> emit_rule;  -- when chain has rules
+ *   emit_rule  -> emit_final; -- no further rules, no further chains
+ *   emit_rule  -> emit_chain; -- no further rules, more chains
+ *   emit_rule  -> emit_rule;  -- more rules
+ * };
+ */
+
+static int
+xtnetlink_emit_final(struct sk_buff *skb, struct netlink_callback *nl_cb)
+{
+	/* Cause emission of NLMSG_DONE. */
+	return 0;
+}
+
+static int
+xtnetlink_emit_chain(struct sk_buff *skb, struct netlink_callback *nl_cb)
+{
+	struct xtnetlink_pktref oldref =
+		{.c_skb = nl_cb->skb, .c_msg = nl_cb->nlh};
+	struct xt2_chain *chain = (void *)nl_cb->args[NLCBA_CHAIN_PTR];
+	struct nlmsghdr *msg = NULL;
+
+	msg = xtnetlink_fill(skb, &oldref, NLM_F_MULTI);
+	msg->nlmsg_type = MAKE_TAGGED_TYPE(NFXTM_CHAIN_DUMP);
+	if (nla_put_string(skb, NFXTA_NAME, chain->name) != 0)
+		goto nla_put_failure;
+	nlmsg_end(skb, msg);
+
+	nl_cb->dump = xtnetlink_emit_final;
+	return skb->len;
+ nla_put_failure:
+	return 0; /* -ENOBUFS; but caller only checks for != 0 */
+}
+
+static int
+xtnetlink_dump_done(struct netlink_callback *nl_cb)
+{
+	struct xt2_chain *chain = (void *)nl_cb->args[NLCBA_CHAIN_PTR];
+
+	if (chain != NULL)
+		xt2_chain_free(chain);
+	return 0; /* caller does not care */
+}
+
+/**
+ * To get an atomic snapshot of the chain, it needs to be duplicated at the
+ * start of the CHAIN_DUMP operation. This is done here.
+ */
+static int xtnetlink_chain_dump_init(struct sock *xtnl, struct sk_buff *iskb,
+				     const struct nlmsghdr *imsg,
+				     struct xt2_chain **chain)
+{
+	struct xtnetlink_pktref ref =
+		{.c_skb = iskb, .c_msg = imsg, .sock = xtnl};
+	struct xt2_table *table;
+	struct xt2_chain *old_chain;
+	const struct nlattr *name_attr;
+	const char *name;
+
+	name_attr = nlmsg_find_attr(imsg, sizeof(struct nfgenmsg), NFXTA_NAME);
+	if (name_attr == NULL)
+		return xtnetlink_error(&ref, NFXTE_ATTRSET_INCOMPLETE);
+	name = nla_data(name_attr);
+	if (*name == '\0')
+		return xtnetlink_error(&ref, NFXTE_CHAIN_INVALID_NAME);
+
+	table = xtnetlink_table_rget(sock_net(xtnl));
+	old_chain = xt2_chain_lookup(table, name);
+	if (old_chain == NULL) {
+		xtnetlink_table_rput();
+		return xtnetlink_error(&ref, NFXTE_CHAIN_NOENT);
+	}
+
+	*chain = xt2_chain_dup(old_chain);
+	xtnetlink_table_rput();
+	if (IS_ERR(*chain))
+		return xtnetlink_error(&ref, PTR_ERR(*chain));
+	/*
+	 * Because xtnetlink_error returns 0 when it emitted an error packet,
+	 * >0 shall be used here to denote success.
+	 */
+	return 1;
+}
+
+static int
+xtnetlink_chain_dump_begin(struct sk_buff *skb, struct netlink_callback *nl_cb)
+{
+	nl_cb->args[NLCBA_CHAIN_PTR] = (uintptr_t)nl_cb->data;
+	nl_cb->dump = xtnetlink_emit_chain;
+	return nl_cb->dump(skb, nl_cb);
+}
+
+/**
+ * Handle a CHAIN_DUMP request. This will, in response, emit a CHAIN_DUMP
+ * (with chain properties like NFXTA_NAME etc.), [and later: zero or more
+ * RULE_ENTRY].
+ */
+static int xtnetlink_chain_dump(struct sock *xtnl, struct sk_buff *iskb,
+				const struct nlmsghdr *imsg,
+				const struct nlattr *const *ad)
+{
+	struct netlink_dump_control ctl = {
+		.dump   = xtnetlink_chain_dump_begin,
+		.done   = xtnetlink_dump_done,
+		.module = THIS_MODULE,
+	};
+	struct xt2_chain *chain = NULL;
+	int ret;
+
+	ret = xtnetlink_chain_dump_init(xtnl, iskb, imsg, &chain);
+	if (ret <= 0)
+		return ret;
+	ctl.data = chain;
+	return netlink_dump_start(xtnl, iskb, imsg, &ctl);
+}
+
 static const struct nla_policy xtnetlink_policy[] = {
 	[NFXTA_NAME] = {.type = NLA_NUL_STRING},
 	[NFXTA_ERRNO] = {.type = NLA_U32},
@@ -616,6 +767,7 @@ static const struct nfnl_callback xtnetlink_callback[] = {
 	[NFXTM_COMMIT] = {.call = xtnetlink_commit, pol},
 	[NFXTM_TABLE_REPLACE] = {.call = xtnetlink_table_replace, pol},
 	[NFXTM_ABORT] = {.call = xtnetlink_abort, pol},
+	[NFXTM_CHAIN_DUMP] = {.call = xtnetlink_chain_dump, pol},
 };
 #undef pol
 
-- 
1.7.10.4

