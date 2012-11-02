From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 04/11] netfilter: xtables2: chain renaming support
Date: Fri,  2 Nov 2012 04:38:36 +0100
Message-ID: <1351827523-10629-5-git-send-email-jengelh@inai.de>
References: <1351827523-10629-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:42664 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762657Ab2KBDkG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 23:40:06 -0400
In-Reply-To: <1351827523-10629-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To keep in mind for later patches: for a ruleset to do chain jumps by
following a C pointer, and have that work with the create-delete cycle
of the chain rename operation, the pointer will need to point to
something that is static across the create-delete. What I thought up:

struct xt2_chain { char name[48]; struct xt2_p_chain *persistent; };
struct xt2_p_chain { struct xt2_chain *back; void *packed_data; };

and having the ruleset point to a struct xt2_p_chain.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/net/netfilter/xt_core.h                  |    2 +
 include/uapi/linux/netfilter/nfnetlink_xtables.h |    4 ++
 net/netfilter/xt_core.c                          |   30 +++++++++++++++
 net/netfilter/xt_nfnetlink.c                     |   45 ++++++++++++++++++++++
 4 files changed, 81 insertions(+)

diff --git a/include/net/netfilter/xt_core.h b/include/net/netfilter/xt_core.h
index 5fec51f..cfd09fa 100644
--- a/include/net/netfilter/xt_core.h
+++ b/include/net/netfilter/xt_core.h
@@ -41,5 +41,7 @@ extern struct xt2_pernet_data *xtables2_pernet(struct net *);
 extern struct xt2_chain *xt2_chain_new(struct xt2_table *, const char *);
 extern struct xt2_chain *xt2_chain_lookup(struct xt2_table *, const char *);
 extern void xt2_chain_free(struct xt2_chain *);
+extern struct xt2_chain *xt2_chain_move(struct xt2_table *, const char *,
+					const char *);
 
 #endif /* _NETFILTER_XTCORE_H */
diff --git a/include/uapi/linux/netfilter/nfnetlink_xtables.h b/include/uapi/linux/netfilter/nfnetlink_xtables.h
index 57dec3c..1f66720 100644
--- a/include/uapi/linux/netfilter/nfnetlink_xtables.h
+++ b/include/uapi/linux/netfilter/nfnetlink_xtables.h
@@ -8,24 +8,28 @@
  * 			(message equipped with NFXTA_ERRNO/NFXTA_XTERRNO)
  * %NFXTM_CHAIN_NEW:	request creation of a chain by name
  * %NFXTM_CHAIN_DEL:	request deletion of a chain by name
+ * %NFXTM_CHAIN_MOVE:	rename a chain
  */
 enum nfxt_msg_type {
 	NFXTM_IDENTIFY = 1,
 	NFXTM_ERROR,
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
diff --git a/net/netfilter/xt_core.c b/net/netfilter/xt_core.c
index a0d6748..289ab5063 100644
--- a/net/netfilter/xt_core.c
+++ b/net/netfilter/xt_core.c
@@ -100,6 +100,36 @@ void xt2_chain_free(struct xt2_chain *chain)
 }
 
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
+
+/**
  * Create a new table with no chains and no rules.
  */
 static struct xt2_table *xt2_table_new(void)
diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index 88df8350a..9fc18c4 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -257,10 +257,54 @@ xtnetlink_chain_del(struct sock *xtnl, struct sk_buff *iskb,
 	return xtnetlink_error(&ref, ret);
 }
 
+static int
+xtnetlink_chain_move(struct sock *xtnl, struct sk_buff *iskb,
+		     const struct nlmsghdr *imsg,
+		     const struct nlattr *const *attr)
+{
+	struct xt2_pernet_data *pnet = xtables2_pernet(sock_net(xtnl));
+	struct xtnetlink_pktref ref =
+		{.c_skb = iskb, .c_msg = imsg, .sock = xtnl};
+	const char *old_name, *new_name;
+	const struct xt2_chain *chain;
+	struct xt2_table *table;
+	int ret;
+
+	if (attr[NFXTA_NAME] == NULL)
+		return xtnetlink_error(&ref, NFXTE_ATTRSET_INCOMPLETE);
+	old_name = nla_data(attr[NFXTA_NAME]);
+	if (*old_name == '\0')
+		return xtnetlink_error(&ref, NFXTE_CHAIN_NOENT);
+	if (attr[NFXTA_NEW_NAME] == NULL)
+		return xtnetlink_error(&ref, NFXTE_ATTRSET_INCOMPLETE);
+	new_name = nla_data(attr[NFXTA_NEW_NAME]);
+	if (*new_name == '\0')
+		return xtnetlink_error(&ref, NFXTE_CHAIN_INVALID_NAME);
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
+		return xtnetlink_error(&ref, NFXTE_CHAIN_NAMETOOLONG);
+	case -EEXIST:
+		return xtnetlink_error(&ref, NFXTE_CHAIN_EXISTS);
+	case -ENOENT:
+		return xtnetlink_error(&ref, NFXTE_CHAIN_NOENT);
+	default:
+		return xtnetlink_error(&ref, ret);
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
@@ -276,6 +320,7 @@ static const struct nfnl_callback xtnetlink_callback[] = {
 	[NFXTM_IDENTIFY] = {.call = xtnetlink_identify, pol},
 	[NFXTM_CHAIN_NEW] = {.call = xtnetlink_chain_new, pol},
 	[NFXTM_CHAIN_DEL] = {.call = xtnetlink_chain_del, pol},
+	[NFXTM_CHAIN_MOVE] = {.call = xtnetlink_chain_move, pol},
 };
 #undef pol
 
-- 
1.7.10.4

