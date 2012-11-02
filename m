From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 11/11] netfilter: xtables2: table dump support
Date: Fri,  2 Nov 2012 04:38:43 +0100
Message-ID: <1351827523-10629-12-git-send-email-jengelh@inai.de>
References: <1351827523-10629-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:42674 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762645Ab2KBDkI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 23:40:08 -0400
In-Reply-To: <1351827523-10629-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add support for the NFXTM_TABLE_DUMP request. Since a table is merely
a collection of chains, it will iterate over those and reuse the chain
dump code, by shifting the .dump function pointer during the dump
itself. (Seems to be an interesting, and previously unused, approach.)

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/net/netfilter/xt_core.h                  |    4 +-
 include/uapi/linux/netfilter/nfnetlink_xtables.h |    2 +
 net/netfilter/xt_core.c                          |   22 +++++-
 net/netfilter/xt_nfnetlink.c                     |   92 +++++++++++++++++++++-
 4 files changed, 113 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/xt_core.h b/include/net/netfilter/xt_core.h
index c706240..965e579 100644
--- a/include/net/netfilter/xt_core.h
+++ b/include/net/netfilter/xt_core.h
@@ -43,9 +43,11 @@ extern struct xt2_chain *xt2_chain_lookup(struct xt2_table *, const char *);
 extern void xt2_chain_free(struct xt2_chain *);
 extern struct xt2_chain *xt2_chain_move(struct xt2_table *, const char *,
 					const char *);
-extern struct xt2_chain *xt2_chain_dup(const struct xt2_chain *);
+extern struct xt2_chain *xt2_chain_dup(struct xt2_table *,
+				       const struct xt2_chain *);
 
 extern struct xt2_table *xt2_table_new(void);
 extern void xt2_table_free(struct xt2_table *);
+extern struct xt2_table *xt2_table_dup(const struct xt2_table *);
 
 #endif /* _NETFILTER_XTCORE_H */
diff --git a/include/uapi/linux/netfilter/nfnetlink_xtables.h b/include/uapi/linux/netfilter/nfnetlink_xtables.h
index 8bf422a..e9471f1 100644
--- a/include/uapi/linux/netfilter/nfnetlink_xtables.h
+++ b/include/uapi/linux/netfilter/nfnetlink_xtables.h
@@ -13,6 +13,7 @@
  * %NFXTM_TABLE_REPLACE:start a table replace transaction
  * %NFXTM_ABORT:	abort an active transaction
  * %NFXTM_CHAIN_DUMP:	retrieve chain properties and rules in the chain
+ * %NFXTM_TABLE_DUMP:	retrieve table (multiple chains) and their rules
  */
 enum nfxt_msg_type {
 	NFXTM_IDENTIFY = 1,
@@ -24,6 +25,7 @@ enum nfxt_msg_type {
 	NFXTM_TABLE_REPLACE,
 	NFXTM_ABORT,
 	NFXTM_CHAIN_DUMP,
+	NFXTM_TABLE_DUMP,
 };
 
 /**
diff --git a/net/netfilter/xt_core.c b/net/netfilter/xt_core.c
index 584a172..835af4a 100644
--- a/net/netfilter/xt_core.c
+++ b/net/netfilter/xt_core.c
@@ -129,12 +129,13 @@ struct xt2_chain *xt2_chain_move(struct xt2_table *table, const char *old_name,
 	return new_chain;
 }
 
-struct xt2_chain *xt2_chain_dup(const struct xt2_chain *old)
+struct xt2_chain *
+xt2_chain_dup(struct xt2_table *new_table, const struct xt2_chain *old)
 {
 	WARN_ON(old == NULL);
 	if (old == NULL)
 		return ERR_PTR(-EINVAL);
-	return xt2_chain_new(NULL, old->name);
+	return xt2_chain_new(new_table, old->name);
 }
 
 /**
@@ -164,6 +165,23 @@ void xt2_table_free(struct xt2_table *table)
 	kfree(table);
 }
 
+struct xt2_table *xt2_table_dup(const struct xt2_table *old_table)
+{
+	const struct xt2_chain *old_chain;
+	struct xt2_table *new_table;
+
+	new_table = xt2_table_new();
+	if (new_table == NULL)
+		return NULL;
+	list_for_each_entry_rcu(old_chain, &old_table->chain_list, anchor)
+		if (xt2_chain_dup(new_table, old_chain) == NULL)
+			goto out;
+	return new_table;
+ out:
+	xt2_table_free(new_table);
+	return NULL;
+}
+
 static int __net_init xtables2_net_init(struct net *net)
 {
 	struct xt2_pernet_data *pnet = xtables2_pernet(net);
diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index c8163c6..cffeb30 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -69,10 +69,12 @@ struct xtnetlink_transact {
 
 /**
  * struct netlink_callback->args[x] holds, for different x:
+ * %NLCBA_TABLE_PTR:	a pointer to the currently traversed table
  * %NLCBA_CHAIN_PTR:	a pointer to the currently traversed chain
  */
 enum {
-	NLCBA_CHAIN_PTR = 1,
+	NLCBA_TABLE_PTR = 0,
+	NLCBA_CHAIN_PTR,
 };
 
 /**
@@ -630,6 +632,8 @@ xtnetlink_abort(struct sock *xtnl, struct sk_buff *iskb,
  *   emit_rule  -> emit_chain; -- no further rules, more chains
  *   emit_rule  -> emit_rule;  -- more rules
  * };
+ *
+ * Any emit_ function is to be called with a properly set-up nl_cb->args[].
  */
 
 static int
@@ -644,6 +648,7 @@ xtnetlink_emit_chain(struct sk_buff *skb, struct netlink_callback *nl_cb)
 {
 	struct xtnetlink_pktref oldref =
 		{.c_skb = nl_cb->skb, .c_msg = nl_cb->nlh};
+	struct xt2_table *table = (void *)nl_cb->args[NLCBA_TABLE_PTR];
 	struct xt2_chain *chain = (void *)nl_cb->args[NLCBA_CHAIN_PTR];
 	struct nlmsghdr *msg = NULL;
 
@@ -653,18 +658,53 @@ xtnetlink_emit_chain(struct sk_buff *skb, struct netlink_callback *nl_cb)
 		goto nla_put_failure;
 	nlmsg_end(skb, msg);
 
-	nl_cb->dump = xtnetlink_emit_final;
+	if (table != NULL && chain->anchor.next != &table->chain_list) {
+		/* Advance to next chain and keep nl_cb->dump. */
+		chain = list_entry(chain->anchor.next,
+				   __typeof__(*chain), anchor);
+		nl_cb->args[NLCBA_CHAIN_PTR] = (uintptr_t)chain;
+	} else {
+		nl_cb->dump = xtnetlink_emit_final;
+	}
+
 	return skb->len;
  nla_put_failure:
 	return 0; /* -ENOBUFS; but caller only checks for != 0 */
 }
 
 static int
+xtnetlink_emit_table(struct sk_buff *skb, struct netlink_callback *nl_cb)
+{
+	struct xtnetlink_pktref oldref =
+		{.c_skb = nl_cb->skb, .c_msg = nl_cb->nlh};
+	struct xt2_table *table = (void *)nl_cb->args[NLCBA_TABLE_PTR];
+	const struct xt2_chain *chain;
+	struct nlmsghdr *msg = NULL;
+
+	msg = xtnetlink_fill(skb, &oldref, NLM_F_MULTI);
+	msg->nlmsg_type = MAKE_TAGGED_TYPE(NFXTM_TABLE_DUMP);
+	nlmsg_end(skb, msg);
+
+	if (list_empty(&table->chain_list)) {
+		nl_cb->dump = xtnetlink_emit_final;
+		return skb->len;
+	}
+
+	chain = list_entry(table->chain_list.next, __typeof__(*chain), anchor);
+	nl_cb->args[NLCBA_CHAIN_PTR] = (uintptr_t)chain;
+	nl_cb->dump = xtnetlink_emit_chain;
+	return skb->len;
+}
+
+static int
 xtnetlink_dump_done(struct netlink_callback *nl_cb)
 {
+	struct xt2_table *table = (void *)nl_cb->args[NLCBA_TABLE_PTR];
 	struct xt2_chain *chain = (void *)nl_cb->args[NLCBA_CHAIN_PTR];
 
-	if (chain != NULL)
+	if (table != NULL)
+		xt2_table_free(table);
+	else if (chain != NULL)
 		xt2_chain_free(chain);
 	return 0; /* caller does not care */
 }
@@ -698,7 +738,7 @@ static int xtnetlink_chain_dump_init(struct sock *xtnl, struct sk_buff *iskb,
 		return xtnetlink_error(&ref, NFXTE_CHAIN_NOENT);
 	}
 
-	*chain = xt2_chain_dup(old_chain);
+	*chain = xt2_chain_dup(NULL, old_chain);
 	xtnetlink_table_rput();
 	if (IS_ERR(*chain))
 		return xtnetlink_error(&ref, PTR_ERR(*chain));
@@ -741,6 +781,49 @@ static int xtnetlink_chain_dump(struct sock *xtnl, struct sk_buff *iskb,
 	return netlink_dump_start(xtnl, iskb, imsg, &ctl);
 }
 
+static int xtnetlink_table_dump_init(struct sock *xtnl, struct sk_buff *iskb,
+				     const struct nlmsghdr *imsg,
+				     struct xt2_table **table)
+{
+	struct xtnetlink_pktref ref =
+		{.c_skb = iskb, .c_msg = imsg, .sock = xtnl};
+	const struct xt2_table *old_table;
+
+	old_table = xtnetlink_table_rget(sock_net(xtnl));
+	*table = xt2_table_dup(old_table);
+	xtnetlink_table_rput();
+	if (*table == NULL)
+		return xtnetlink_error(&ref, -ENOMEM);
+	return 1;
+}
+
+static int
+xtnetlink_table_dump_begin(struct sk_buff *skb, struct netlink_callback *nl_cb)
+{
+	nl_cb->args[NLCBA_TABLE_PTR] = (uintptr_t)nl_cb->data;
+	nl_cb->dump = xtnetlink_emit_table;
+	return nl_cb->dump(skb, nl_cb);
+}
+
+static int xtnetlink_table_dump(struct sock *xtnl, struct sk_buff *iskb,
+				const struct nlmsghdr *imsg,
+				const struct nlattr *const *ad)
+{
+	struct netlink_dump_control ctl = {
+		.dump   = xtnetlink_table_dump_begin,
+		.done   = xtnetlink_dump_done,
+		.module = THIS_MODULE,
+	};
+	struct xt2_table *table = NULL;
+	int ret;
+
+	ret = xtnetlink_table_dump_init(xtnl, iskb, imsg, &table);
+	if (ret <= 0)
+		return ret;
+	ctl.data = table;
+	return netlink_dump_start(xtnl, iskb, imsg, &ctl);
+}
+
 static const struct nla_policy xtnetlink_policy[] = {
 	[NFXTA_NAME] = {.type = NLA_NUL_STRING},
 	[NFXTA_ERRNO] = {.type = NLA_U32},
@@ -768,6 +851,7 @@ static const struct nfnl_callback xtnetlink_callback[] = {
 	[NFXTM_TABLE_REPLACE] = {.call = xtnetlink_table_replace, pol},
 	[NFXTM_ABORT] = {.call = xtnetlink_abort, pol},
 	[NFXTM_CHAIN_DUMP] = {.call = xtnetlink_chain_dump, pol},
+	[NFXTM_TABLE_DUMP] = {.call = xtnetlink_table_dump, pol},
 };
 #undef pol
 
-- 
1.7.10.4

