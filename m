From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 07/11] netfilter: xtables2: transaction abort support
Date: Fri,  2 Nov 2012 04:38:39 +0100
Message-ID: <1351827523-10629-8-git-send-email-jengelh@inai.de>
References: <1351827523-10629-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:42670 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762705Ab2KBDkH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 23:40:07 -0400
In-Reply-To: <1351827523-10629-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Support for the explicit ABORT operation over netlink.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/uapi/linux/netfilter/nfnetlink_xtables.h |    2 +
 net/netfilter/xt_nfnetlink.c                     |   45 +++++++++++++++++++---
 2 files changed, 41 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/netfilter/nfnetlink_xtables.h b/include/uapi/linux/netfilter/nfnetlink_xtables.h
index bec4d054..84133c7 100644
--- a/include/uapi/linux/netfilter/nfnetlink_xtables.h
+++ b/include/uapi/linux/netfilter/nfnetlink_xtables.h
@@ -11,6 +11,7 @@
  * %NFXTM_CHAIN_MOVE:	rename a chain
  * %NFXTM_COMMIT:	finalize and commit a transaction
  * %NFXTM_TABLE_REPLACE:start a table replace transaction
+ * %NFXTM_ABORT:	abort an active transaction
  */
 enum nfxt_msg_type {
 	NFXTM_IDENTIFY = 1,
@@ -20,6 +21,7 @@ enum nfxt_msg_type {
 	NFXTM_CHAIN_MOVE,
 	NFXTM_COMMIT,
 	NFXTM_TABLE_REPLACE,
+	NFXTM_ABORT,
 };
 
 /**
diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index 59c603f..133a4a8 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -522,6 +522,29 @@ xtnetlink_commit(struct sock *xtnl, struct sk_buff *iskb,
 	return xtnetlink_error(&ref, NFXTE_SUCCESS);
 }
 
+/**
+ * NFXTM_ABORT: The client wants to explicitly abandon a transaction it itself
+ * had started earlier. Usually issued by the client when part of a
+ * transaction, for example a NFXTM_CHAIN_ADD within a
+ * NFXTM_TABLE_REPLACE..NFXTM_COMMIT window yielded ENOMEM.
+ */
+static int
+xtnetlink_abort(struct sock *xtnl, struct sk_buff *iskb,
+		const struct nlmsghdr *imsg, const struct nlattr *const *ad)
+{
+	struct xtnetlink_pktref ref =
+		{.c_skb = iskb, .c_msg = imsg, .sock = xtnl};
+	struct xtnetlink_transact *xa;
+
+	xa = xtnetlink_transact_get(sock_net(xtnl), NETLINK_CB(iskb).portid);
+	if (xa == NULL)
+		return xtnetlink_error(&ref, NFXTE_TRANSACT_INACTIVE);
+
+	xtnetlink_transact_pop(xa);
+	xtnetlink_transact_free(xa);
+	return xtnetlink_error(&ref, NFXTE_SUCCESS);
+}
+
 static const struct nla_policy xtnetlink_policy[] = {
 	[NFXTA_NAME] = {.type = NLA_NUL_STRING},
 	[NFXTA_ERRNO] = {.type = NLA_U32},
@@ -545,6 +568,7 @@ static const struct nfnl_callback xtnetlink_callback[] = {
 	[NFXTM_CHAIN_MOVE] = {.call = xtnetlink_chain_move, pol},
 	[NFXTM_COMMIT] = {.call = xtnetlink_commit, pol},
 	[NFXTM_TABLE_REPLACE] = {.call = xtnetlink_table_replace, pol},
+	[NFXTM_ABORT] = {.call = xtnetlink_abort, pol},
 };
 #undef pol
 
@@ -555,6 +579,9 @@ static const struct nfnetlink_subsystem xtnetlink_subsys = {
 	.cb_count  = ARRAY_SIZE(xtnetlink_callback),
 };
 
+/**
+ * Abort the transaction if the socket underneath us closes.
+ */
 static int
 xtnetlink_nlevent(struct notifier_block *blk, unsigned long event, void *ptr)
 {
@@ -568,14 +595,20 @@ xtnetlink_nlevent(struct notifier_block *blk, unsigned long event, void *ptr)
 	 * Is this needed, or do we have a user context in this NL notifier?
 	 *
 	 * If notifiers are not executed right when they are issued, this
-	 * becomes as a race, as a new NL socket could be created with the
-	 * same nladdr value (.portid member).
+	 * becomes a race, as a new NL socket could be created with the
+	 * same nladdr value (.portid member):
+	 * 1. open xtnl socket
+	 * 2. issue NFXTM_REPLACE_TABLE, new TA is started
+	 * 3. close socket, notifier is queued
+	 * 4. open xtnl socket
+	 * 5. issue NFXTM_CHAIN_ADD, TA is reused (bad)
+	 * 6. notifier runs eventually and late
 	 */
 	xa = xtnetlink_transact_get(note->net, note->portid);
-	if (xa == NULL)
-		return NOTIFY_DONE;
-	xtnetlink_transact_pop(xa);
-	xtnetlink_transact_free(xa);
+	if (xa != NULL) {
+		xtnetlink_transact_pop(xa);
+		xtnetlink_transact_free(xa);
+	}
 	return NOTIFY_DONE;
 }
 
-- 
1.7.10.4

