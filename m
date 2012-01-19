From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 4/7] netfilter: xtables2: chain renaming support
Date: Thu, 19 Jan 2012 17:26:18 +0100
Message-ID: <1326990381-14534-5-git-send-email-jengelh@medozas.de>
References: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:57974 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500Ab2ASQ0Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:26:24 -0500
In-Reply-To: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To keep in mind for later patches: for a ruleset to use
pointer-following chain jumps that work with the create-delete cycle
of renames of the target chain, it needs to point to something that
remains during that. What I thought up:

struct xt2_chain { char name[48]; struct xt2_p_chain *persistent; };
struct xt2_p_chain { struct xt2_chain *back; void *packed_data; };

and the ruleset pointing to a struct xt2_p_chain.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/nfnetlink_xtables.h |    3 ++
 include/net/netfilter/x_tables2.h           |    2 +
 net/netfilter/xt2_core.c                    |   31 +++++++++++++++++
 net/netfilter/xt2_nfnetlink.c               |   47 +++++++++++++++++++++++++++
 4 files changed, 83 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_xtables.h b/include/linux/netfilter/nfnetlink_xtables.h
index fe1b6ce..296012a 100644
--- a/include/linux/netfilter/nfnetlink_xtables.h
+++ b/include/linux/netfilter/nfnetlink_xtables.h
@@ -5,18 +5,21 @@ enum nfxt_msg_type {
 	NFXTM_IDENTIFY = 1,
 	NFXTM_CHAIN_NEW,
 	NFXTM_CHAIN_DEL,
+	NFXTM_CHAIN_MOVE,
 };
 
 /**
  * %NFXTA_NAME:			name of the object being operated on
  * %NFXTA_ERRNO:		system error code (%Exxx)
  * %NFXTA_XTERRNO:		NFXT-specific error code (cf. enum nfxt_errno)
+ * %NFXTA_NEW_NAME:		new name of object
  */
 enum nfxt_attr_type {
 	NFXTA_UNSPEC = 0,
 	NFXTA_NAME,
 	NFXTA_ERRNO,
 	NFXTA_XTERRNO,
+	NFXTA_NEW_NAME,
 };
 
 /**
diff --git a/include/net/netfilter/x_tables2.h b/include/net/netfilter/x_tables2.h
index b13eab7..198ec31 100644
--- a/include/net/netfilter/x_tables2.h
+++ b/include/net/netfilter/x_tables2.h
@@ -42,5 +42,7 @@ extern struct xt2_pernet_data *xtables2_pernet(struct net *);
 extern struct xt2_chain *xt2_chain_new(struct xt2_table *, const char *);
 extern struct xt2_chain *xt2_chain_lookup(struct xt2_table *, const char *);
 extern void xt2_chain_free(struct xt2_chain *);
+extern struct xt2_chain *xt2_chain_move(struct xt2_table *, const char *,
+					const char *);
 
 #endif /* _NET_NETFILTER_XTABLES2_H */
diff --git a/net/netfilter/xt2_core.c b/net/netfilter/xt2_core.c
index 5e7426d..5d8f155 100644
--- a/net/netfilter/xt2_core.c
+++ b/net/netfilter/xt2_core.c
@@ -100,6 +100,37 @@ void xt2_chain_free(struct xt2_chain *chain)
 EXPORT_SYMBOL_GPL(xt2_chain_free);
 
 /**
+ * @table:	table to add the new chain to
+ * @name:	current name for the chain; not %NULL
+ * @new_name:	new name for the chain; not %NULL
+ *
+ * Rename chain by means of a create-delete cycle. This is to avoid
+ * temporary invisiblity of the chain and/or duplicate chain names for readers.
+ *
+ * Caller should hold table lock.
+ */
+struct xt2_chain *xt2_chain_move(struct xt2_table *table, const char *old_name,
+				 const char *new_name)
+{
+	struct xt2_chain *old_chain, *new_chain;
+
+	if (strlen(new_name) >= ARRAY_SIZE(new_chain->name))
+		return ERR_PTR(-ENAMETOOLONG);
+	if (xt2_chain_lookup(table, new_name) != NULL)
+		return ERR_PTR(-EEXIST);
+	old_chain = xt2_chain_lookup(table, old_name);
+	if (old_chain == NULL)
+		return ERR_PTR(-ENOENT);
+	new_chain = xt2_chain_new(table, new_name);
+	if (IS_ERR(new_chain))
+		return new_chain;
+	/* - rule move magic here once that code appears */
+	xt2_chain_free(old_chain);
+	return new_chain;
+}
+EXPORT_SYMBOL_GPL(xt2_chain_move);
+
+/**
  * Create a new table with no chains and no rules.
  */
 static struct xt2_table *xt2_table_new(void)
diff --git a/net/netfilter/xt2_nfnetlink.c b/net/netfilter/xt2_nfnetlink.c
index b50e468d..9f29b34 100644
--- a/net/netfilter/xt2_nfnetlink.c
+++ b/net/netfilter/xt2_nfnetlink.c
@@ -253,10 +253,56 @@ xtnetlink_chain_del(struct sock *xtnl, struct sk_buff *iskb,
 	return ret;
 }
 
+static int
+xtnetlink_chain_move(struct sock *xtnl, struct sk_buff *iskb,
+		     const struct nlmsghdr *imsg,
+		     const struct nlattr *const *ad)
+{
+	struct xt2_pernet_data *pnet = xtables2_pernet(sock_net(xtnl));
+	struct xtnetlink_pktref ref = {.c_skb = iskb, .c_msg = imsg};
+	const char *old_name, *new_name;
+	const struct xt2_chain *chain;
+	const struct nlattr *attr;
+	struct xt2_table *table;
+	int ret;
+
+	attr = nlmsg_find_attr(imsg, sizeof(struct nfgenmsg), NFXTA_NAME);
+	if (attr == NULL)
+		return xtnetlink_error(xtnl, &ref, NFXTE_ATTRSET_INCOMPLETE);
+	old_name = nla_data(attr);
+	if (*old_name == '\0')
+		return xtnetlink_error(xtnl, &ref, NFXTE_CHAIN_NOENT);
+	attr = nlmsg_find_attr(imsg, sizeof(struct nfgenmsg), NFXTA_NEW_NAME);
+	if (attr == NULL)
+		return xtnetlink_error(xtnl, &ref, NFXTE_ATTRSET_INCOMPLETE);
+	new_name = nla_data(attr);
+	if (*new_name == '\0')
+		return xtnetlink_error(xtnl, &ref, NFXTE_CHAIN_INVALID_NAME);
+
+	mutex_lock(&pnet->master_lock);
+	table = pnet->master;
+	mutex_lock(&table->lock);
+	chain = xt2_chain_move(table, old_name, new_name);
+	ret   = IS_ERR(chain) ? PTR_ERR(chain) : 0;
+	mutex_unlock(&table->lock);
+	mutex_unlock(&pnet->master_lock);
+	switch (ret) {
+	case -ENAMETOOLONG:
+		return xtnetlink_error(xtnl, &ref, NFXTE_CHAIN_NAMETOOLONG);
+	case -EEXIST:
+		return xtnetlink_error(xtnl, &ref, NFXTE_CHAIN_EXISTS);
+	case -ENOENT:
+		return xtnetlink_error(xtnl, &ref, NFXTE_CHAIN_NOENT);
+	default:
+		return xtnetlink_error(xtnl, &ref, ret);
+	}
+}
+
 static const struct nla_policy xtnetlink_policy[] = {
 	[NFXTA_NAME] = {.type = NLA_NUL_STRING},
 	[NFXTA_ERRNO] = {.type = NLA_U32},
 	[NFXTA_XTERRNO] = {.type = NLA_U32},
+	[NFXTA_NEW_NAME] = {.type = NLA_NUL_STRING},
 };
 
 /*
@@ -272,6 +318,7 @@ static const struct nfnl_callback xtnetlink_callback[] = {
 	[NFXTM_IDENTIFY] = {.call = xtnetlink_identify, pol},
 	[NFXTM_CHAIN_NEW] = {.call = xtnetlink_chain_new, pol},
 	[NFXTM_CHAIN_DEL] = {.call = xtnetlink_chain_del, pol},
+	[NFXTM_CHAIN_MOVE] = {.call = xtnetlink_chain_move, pol},
 };
 #undef pol
 
-- 
1.7.7

