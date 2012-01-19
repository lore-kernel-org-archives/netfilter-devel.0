From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 6/7] netfilter: xtables2: transaction abort support
Date: Thu, 19 Jan 2012 17:26:20 +0100
Message-ID: <1326990381-14534-7-git-send-email-jengelh@medozas.de>
References: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:57977 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932533Ab2ASQ0Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:26:25 -0500
In-Reply-To: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is rather straightforward.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/nfnetlink_xtables.h |    1 +
 net/netfilter/xt2_nfnetlink.c               |   27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+), 0 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_xtables.h b/include/linux/netfilter/nfnetlink_xtables.h
index 2399678..497200b 100644
--- a/include/linux/netfilter/nfnetlink_xtables.h
+++ b/include/linux/netfilter/nfnetlink_xtables.h
@@ -8,6 +8,7 @@ enum nfxt_msg_type {
 	NFXTM_CHAIN_MOVE,
 	NFXTM_TABLE_REPLACE,
 	NFXTM_COMMIT,
+	NFXTM_ABORT,
 };
 
 /**
diff --git a/net/netfilter/xt2_nfnetlink.c b/net/netfilter/xt2_nfnetlink.c
index 0ef6442..08bcc5e 100644
--- a/net/netfilter/xt2_nfnetlink.c
+++ b/net/netfilter/xt2_nfnetlink.c
@@ -438,6 +438,32 @@ xtnetlink_commit(struct sock *xtnl, struct sk_buff *iskb,
 	return xtnetlink_error(xtnl, &ref, NFXTE_SUCCESS);
 }
 
+/**
+ * NFXTM_ABORT: The client wants to explicitly abandon a transaction it itself
+ * had started earlier. Usually issued by the client when part of a
+ * transaction, for example a NFXTM_CHAIN_SPLICE within a
+ * NFXTM_TABLE_REPLACE..NFXTM_COMMIT window yielded ENOMEM.
+ */
+static int
+xtnetlink_abort(struct sock *xtnl, struct sk_buff *iskb,
+		const struct nlmsghdr *imsg, const struct nlattr *const *ad)
+{
+	struct xtnetlink_pktref ref = {.c_skb = iskb, .c_msg = imsg};
+	struct xtnetlink_transact *xa;
+	int ret;
+
+	mutex_lock(&xtnetlink_transact_lock);
+	xa = xtnetlink_transact_lookup(sock_net(xtnl), NETLINK_CB(iskb).pid);
+	if (xa == NULL) {
+		ret = NFXTE_TRANSACT_INACTIVE;
+	} else {
+		xtnetlink_transact_free(xa);
+		ret = NFXTE_SUCCESS;
+	}
+	mutex_unlock(&xtnetlink_transact_lock);
+	return xtnetlink_error(xtnl, &ref, ret);
+}
+
 static const struct nla_policy xtnetlink_policy[] = {
 	[NFXTA_NAME] = {.type = NLA_NUL_STRING},
 	[NFXTA_ERRNO] = {.type = NLA_U32},
@@ -461,6 +487,7 @@ static const struct nfnl_callback xtnetlink_callback[] = {
 	[NFXTM_CHAIN_MOVE] = {.call = xtnetlink_chain_move, pol},
 	[NFXTM_TABLE_REPLACE] = {.call = xtnetlink_table_replace, pol},
 	[NFXTM_COMMIT] = {.call = xtnetlink_commit, pol},
+	[NFXTM_ABORT] = {.call = xtnetlink_abort, pol},
 };
 #undef pol
 
-- 
1.7.7

