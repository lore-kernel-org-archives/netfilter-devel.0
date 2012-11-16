From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 02/11] netfilter: xtables2: implement the splice buffer
Date: Fri, 16 Nov 2012 02:23:36 +0100
Message-ID: <1353029025-31635-3-git-send-email-jengelh@inai.de>
References: <1353029025-31635-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:45172 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474Ab2KPBXx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:23:53 -0500
In-Reply-To: <1353029025-31635-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 net/netfilter/xt_nfnetlink.c |   37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index 1690cf6..da9e2e3 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -50,9 +50,21 @@ struct xtnetlink_pktref {
  * Multiple types of transaction buffers do exist -
  * %XA_TABLE_BUFFER:	holds chains accumulating during any operation during
  * 			%NFXTM_TABLE_REPLACE .. %NFXTM_COMMIT period
+ * %XA_SPLICE_BUFFER:	holds rules accumulating during %NFXTM_CHAIN_SPLICE ..
+ * 			%NFXTM_COMMIT period
  */
 enum xtnetlink_transact_type {
 	XA_TABLE_BUFFER,
+	XA_SPLICE_BUFFER,
+};
+
+/**
+ * This struct is used to record splice parameters and the ruleset until
+ * %NFXTM_COMMIT is commanded and xt2_chain_splice is called.
+ */
+struct xtnetlink_splice_param {
+	char name[sizeof((struct xt2_chain *)NULL)->name];
+	unsigned int offset, dlength;
 };
 
 /**
@@ -78,6 +90,7 @@ struct xtnetlink_transact {
 	enum xtnetlink_transact_type type;
 	union {
 		struct xt2_table *table;
+		struct xtnetlink_splice_param *splice_param;
 	};
 };
 
@@ -235,6 +248,9 @@ static void xtnetlink_transact_free(struct xtnetlink_transact *xa)
 	if (xa->type == XA_TABLE_BUFFER) {
 		if (xa->table != NULL)
 			xt2_table_free(xa->table);
+	} else if (xa->type == XA_SPLICE_BUFFER) {
+		if (xa->splice_param != NULL)
+			kfree(xa->splice_param);
 	}
 	kfree(xa);
 }
@@ -579,6 +595,8 @@ xtnetlink_table_replace(struct sock *xtnl, struct sk_buff *iskb,
 	struct xtnetlink_transact *xa;
 	int ret;
 
+	/* check that no XA_SPLICE_BUFFER is active */
+
 	xa = xtnetlink_transact_new(sock_net(xtnl), NETLINK_CB(iskb).portid,
 				    XA_TABLE_BUFFER);
 	if (xa == NULL)
@@ -636,6 +654,19 @@ xtnetlink_abort(struct sock *xtnl, struct sk_buff *iskb,
 	struct xtnetlink_transact *xa;
 
 	xa = xtnetlink_transact_get(sock_net(xtnl), NETLINK_CB(iskb).portid,
+				    XA_SPLICE_BUFFER);
+	if (xa != NULL) {
+		/*
+		 * CHAIN_SPLICE context is always topmost (one cannot call
+		 * TABLE_REPLACE from CHAIN_SPLICE ctx), so if a rule buffer
+		 * is present, abort that.
+		 */
+		xtnetlink_transact_pop(xa);
+		xtnetlink_transact_free(xa);
+		return xtnetlink_error(&ref, NFXTE_SUCCESS);
+	}
+
+	xa = xtnetlink_transact_get(sock_net(xtnl), NETLINK_CB(iskb).portid,
 				    XA_TABLE_BUFFER);
 	if (xa == NULL)
 		return xtnetlink_error(&ref, NFXTE_TRANSACT_INACTIVE);
@@ -906,6 +937,12 @@ xtnetlink_nlevent(struct notifier_block *blk, unsigned long event, void *ptr)
 
 	if (event != NETLINK_URELEASE || note->protocol != NETLINK_NETFILTER)
 		return NOTIFY_DONE;
+
+	xa = xtnetlink_transact_get(note->net, note->portid, XA_SPLICE_BUFFER);
+	if (xa != NULL) {
+		xtnetlink_transact_pop(xa);
+		xtnetlink_transact_free(xa);
+	}
 	/*
 	 * Freeing is non-sleeping thanks to kfree_rcu in xt2_table_free.
 	 * Is this needed, or do we have a user context in this NL notifier?
-- 
1.7.10.4

