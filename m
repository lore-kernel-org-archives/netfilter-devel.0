From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 05/11] netfilter: xtables2: netlink part for splice operation
Date: Fri, 16 Nov 2012 02:23:39 +0100
Message-ID: <1353029025-31635-6-git-send-email-jengelh@inai.de>
References: <1353029025-31635-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:45176 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab2KPBX5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:23:57 -0500
In-Reply-To: <1353029025-31635-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This makes the splice functionality available over Netlink.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/uapi/linux/netfilter/nfnetlink_xtables.h |    8 +-
 net/netfilter/xt_nfnetlink.c                     |  119 +++++++++++++++++++++-
 2 files changed, 125 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_xtables.h b/include/uapi/linux/netfilter/nfnetlink_xtables.h
index e9471f1..9f34b44 100644
--- a/include/uapi/linux/netfilter/nfnetlink_xtables.h
+++ b/include/uapi/linux/netfilter/nfnetlink_xtables.h
@@ -11,9 +11,10 @@
  * %NFXTM_CHAIN_MOVE:	rename a chain
  * %NFXTM_COMMIT:	finalize and commit a transaction
  * %NFXTM_TABLE_REPLACE:start a table replace transaction
- * %NFXTM_ABORT:	abort an active transaction
+ * %NFXTM_ABORT:	abort the topmost active transaction
  * %NFXTM_CHAIN_DUMP:	retrieve chain properties and rules in the chain
  * %NFXTM_TABLE_DUMP:	retrieve table (multiple chains) and their rules
+ * %NFXTM_CHAIN_SPLICE:	start a splice transaction; modify rules of a chain
  */
 enum nfxt_msg_type {
 	NFXTM_IDENTIFY = 1,
@@ -26,6 +27,7 @@ enum nfxt_msg_type {
 	NFXTM_ABORT,
 	NFXTM_CHAIN_DUMP,
 	NFXTM_TABLE_DUMP,
+	NFXTM_CHAIN_SPLICE,
 };
 
 /**
@@ -35,6 +37,8 @@ enum nfxt_msg_type {
  * %NFXTA_NEW_NAME:		new name of object
  * %NFXTA_REVISION_MIN:		minimum API revision supported by xtnetlink
  * %NFXTA_REVISION_MAX:		maximum API revision supported by xtnetlink
+ * %NFXTA_SPLICE_OFFSET:	rule number to start deletion from
+ * %NFXTA_SPLICE_DLENGTH:	delete this many rules
  */
 enum nfxt_attr_type {
 	NFXTA_UNSPEC = 0,
@@ -44,6 +48,8 @@ enum nfxt_attr_type {
 	NFXTA_NEW_NAME,
 	NFXTA_REVISION_MIN,
 	NFXTA_REVISION_MAX,
+	NFXTA_SPLICE_OFFSET,
+	NFXTA_SPLICE_DLENGTH,
 };
 
 /**
diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index da9e2e3..1941ce6 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -65,6 +65,7 @@ enum xtnetlink_transact_type {
 struct xtnetlink_splice_param {
 	char name[sizeof((struct xt2_chain *)NULL)->name];
 	unsigned int offset, dlength;
+	struct xt2_rule_buffer *rulebuf;
 };
 
 /**
@@ -249,8 +250,11 @@ static void xtnetlink_transact_free(struct xtnetlink_transact *xa)
 		if (xa->table != NULL)
 			xt2_table_free(xa->table);
 	} else if (xa->type == XA_SPLICE_BUFFER) {
-		if (xa->splice_param != NULL)
+		if (xa->splice_param != NULL) {
+			if (xa->splice_param->rulebuf != NULL)
+				xt2_rulebuf_free(xa->splice_param->rulebuf);
 			kfree(xa->splice_param);
+		}
 	}
 	kfree(xa);
 }
@@ -616,6 +620,105 @@ xtnetlink_table_replace(struct sock *xtnl, struct sk_buff *iskb,
 	return xtnetlink_error(&ref, NFXTE_SUCCESS);
 }
 
+/**
+ * In Xtables, rules are packed for demonstrable cache efficiency and thus
+ * processing speed (over e.g. linked lists that some other firewall
+ * implementations use; cf. Love_for_blobs.pdf, NFWS 2008).
+ *
+ * The rule packing done in Xtables(1 and 2) requires a offset recomputation.
+ * Therefore, it is most efficient to batch multiple changes for a pack, and
+ * this is what CHAIN_SPLICE does. Like the Perl function from which it borrows
+ * the name, CHAIN_SPLICE collects both delete and insert requests, which
+ * together allow for "replace".
+ *
+ * A CHAIN_SPLICE operation is to be followed by zero or more RULE_ENTRYs, with
+ * a final COMMIT that initiates the rule packing and atomic replace of the
+ * rules at the chain level.
+ */
+static int xtnetlink_chain_splice(struct sock *xtnl, struct sk_buff *iskb,
+				  const struct nlmsghdr *imsg,
+				  const struct nlattr *const *attr)
+{
+	struct xtnetlink_pktref ref =
+		{.c_skb = iskb, .c_msg = imsg, .sock = xtnl};
+	struct xtnetlink_splice_param *sp;
+	struct xtnetlink_transact *xa;
+	struct xt2_table *table;
+	int ret;
+
+	if (attr[NFXTA_NAME] == NULL || attr[NFXTA_SPLICE_OFFSET] == NULL ||
+	    attr[NFXTA_SPLICE_DLENGTH] == NULL)
+		return xtnetlink_error(&ref, NFXTE_ATTRSET_INCOMPLETE);
+	/*
+	 * Check that chain is present and courteously fail early if not so.
+	 * If the chain goes away later, we will catch its absence
+	 * during NFXTM_COMMIT.
+	 */
+	table = xtnetlink_table_rget(&xa, sock_net(xtnl),
+				     NETLINK_CB(iskb).portid);
+	if (xa != NULL &&
+	    xt2_chain_lookup(table, nla_data(attr[NFXTA_NAME])) == NULL) {
+		xtnetlink_table_rput(xa, sock_net(xtnl));
+		return xtnetlink_error(&ref, NFXTE_CHAIN_NOENT);
+	}
+	xtnetlink_table_rput(xa, sock_net(xtnl));
+
+	/*
+	 * Establish rule buffer and save away splice parameters for
+	 * commit time.
+	 */
+	xa = xtnetlink_transact_new(sock_net(xtnl), NETLINK_CB(iskb).portid,
+				    XA_SPLICE_BUFFER);
+	if (xa == NULL)
+		return -ENOMEM;
+	sp = xa->splice_param = kmalloc(sizeof(*xa->splice_param), GFP_KERNEL);
+	if (sp == NULL)
+		goto out_nomem;
+	sp->rulebuf = xt2_rulebuf_new();
+	if (sp->rulebuf == NULL)
+		goto out_nomem;
+	strncpy(sp->name, nla_data(attr[NFXTA_NAME]), sizeof(sp->name));
+	sp->name[sizeof(sp->name)-1] = '\0';
+	sp->offset  = nla_get_u32(attr[NFXTA_SPLICE_OFFSET]);
+	sp->dlength = nla_get_u32(attr[NFXTA_SPLICE_DLENGTH]);
+
+	ret = xtnetlink_transact_push(xa);
+	if (ret == -EEXIST) {
+		xtnetlink_transact_free(xa);
+		return xtnetlink_error(&ref, NFXTE_TRANSACT_ACTIVE);
+	}
+
+	xtnetlink_transact_put(xa);
+	return xtnetlink_error(&ref, NFXTE_SUCCESS);
+ out_nomem:
+	xtnetlink_transact_free(xa);
+	return -ENOMEM;
+}
+
+static int xtnetlink_commit_rules(const struct xtnetlink_pktref *ref,
+				  struct xtnetlink_transact *xa_rule)
+{
+	const struct xtnetlink_splice_param *sp = xa_rule->splice_param;
+	struct xtnetlink_transact *xa_table;
+	struct xt2_table *table;
+	struct xt2_chain *chain;
+	int ret;
+
+	xtnetlink_transact_pop(xa_rule);
+	table = xtnetlink_table_wget(&xa_table, sock_net(ref->sock),
+				     NETLINK_CB(ref->c_skb).portid);
+	/* table is now locked, chain won't go away */
+	chain = xt2_chain_lookup(table, sp->name);
+	if (chain == NULL) {
+		xtnetlink_table_wput(xa_table, sock_net(ref->sock), table);
+		return xtnetlink_error(ref, NFXTE_CHAIN_NOENT);
+	}
+
+	ret = xt2_chain_splice(chain, sp->rulebuf, sp->offset, sp->dlength);
+	xtnetlink_table_wput(xa_table, sock_net(ref->sock), table);
+	return xtnetlink_error(ref, ret);
+}
+
 static int
 xtnetlink_commit(struct sock *xtnl, struct sk_buff *iskb,
 		 const struct nlmsghdr *imsg, const struct nlattr *const *ad)
@@ -625,7 +728,18 @@ xtnetlink_commit(struct sock *xtnl, struct sk_buff *iskb,
 		{.c_skb = iskb, .c_msg = imsg, .sock = xtnl};
 	struct xtnetlink_transact *xa;
 	struct xt2_table *old_table;
+	int ret;
+
+	xa = xtnetlink_transact_get(sock_net(xtnl), NETLINK_CB(iskb).portid,
+				    XA_SPLICE_BUFFER);
+	if (xa != NULL) {
+		/* Finish up NFXTM_CHAIN_SPLICE */
+		ret = xtnetlink_commit_rules(&ref, xa);
+		xtnetlink_transact_free(xa);
+		return ret;
+	}
 
+	/* Finish up a NFXTM_TABLE_REPLACE */
 	xa = xtnetlink_transact_get(sock_net(xtnl), NETLINK_CB(iskb).portid,
 				    XA_TABLE_BUFFER);
 	if (xa == NULL)
@@ -895,6 +1009,8 @@ static const struct nla_policy xtnetlink_policy[] = {
 	[NFXTA_NEW_NAME] = {.type = NLA_NUL_STRING},
 	[NFXTA_REVISION_MIN] = {.type = NLA_U32},
 	[NFXTA_REVISION_MAX] = {.type = NLA_U32},
+	[NFXTA_SPLICE_OFFSET] = {.type = NLA_U32},
+	[NFXTA_SPLICE_DLENGTH] = {.type = NLA_U32},
 };
 
 /*
@@ -916,6 +1032,7 @@ static const struct nfnl_callback xtnetlink_callback[] = {
 	[NFXTM_ABORT] = {.call = xtnetlink_abort, pol},
 	[NFXTM_CHAIN_DUMP] = {.call = xtnetlink_chain_dump, pol},
 	[NFXTM_TABLE_DUMP] = {.call = xtnetlink_table_dump, pol},
+	[NFXTM_CHAIN_SPLICE] = {.call = xtnetlink_chain_splice, pol},
 };
 #undef pol
 
-- 
1.7.10.4

