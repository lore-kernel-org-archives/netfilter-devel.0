From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/2] netfilter: nfnetlink_log: validate dependencies to avoid breaking atomicity
Date: Tue, 13 Oct 2015 12:47:48 +0200
Message-ID: <1444733268-8564-2-git-send-email-pablo@netfilter.org>
References: <1444733268-8564-1-git-send-email-pablo@netfilter.org>
Cc: chamaken@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56986 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbbJMKkx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 Oct 2015 06:40:53 -0400
In-Reply-To: <1444733268-8564-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Check that dependencies are fulfilled before updating the logger
instance, otherwise we can leave things in intermediate state on errors
in nfulnl_recv_config().

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink_log.c | 43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 2002d57..a5b9680 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -825,6 +825,7 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 	struct net *net = sock_net(ctnl);
 	struct nfnl_log_net *log = nfnl_log_pernet(net);
 	int ret = 0;
+	u16 flags;
 
 	if (nfula[NFULA_CFG_CMD]) {
 		u_int8_t pf = nfmsg->nfgen_family;
@@ -846,6 +847,28 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		goto out_put;
 	}
 
+	/* Check if we support these flags in first place, dependencies should
+	 * be there too not to break atomicity.
+	 */
+	if (nfula[NFULA_CFG_FLAGS]) {
+		flags = ntohs(nla_get_be16(nfula[NFULA_CFG_FLAGS]));
+
+		if ((flags & NFULNL_CFG_F_CONNTRACK) &&
+		    !rcu_access_pointer(nfnl_ct_hook)) {
+#ifdef CONFIG_MODULES
+			nfnl_unlock(NFNL_SUBSYS_ULOG);
+			request_module("ip_conntrack_netlink");
+			nfnl_lock(NFNL_SUBSYS_ULOG);
+			if (rcu_access_pointer(nfnl_ct_hook)) {
+				ret = -EAGAIN;
+				goto out_put;
+			}
+#endif
+			ret = -EOPNOTSUPP;
+			goto out_put;
+		}
+	}
+
 	if (cmd != NULL) {
 		switch (cmd->command) {
 		case NFULNL_CFG_CMD_BIND:
@@ -905,26 +928,8 @@ nfulnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 		nfulnl_set_qthresh(inst, ntohl(qthresh));
 	}
 
-	if (nfula[NFULA_CFG_FLAGS]) {
-		u16 flags = ntohs(nla_get_be16(nfula[NFULA_CFG_FLAGS]));
-
-		if (flags & NFULNL_CFG_F_CONNTRACK &&
-		    !rcu_access_pointer(nfnl_ct_hook)) {
-#ifdef CONFIG_MODULES
-			nfnl_unlock(NFNL_SUBSYS_ULOG);
-			request_module("ip_conntrack_netlink");
-			nfnl_lock(NFNL_SUBSYS_ULOG);
-			if (rcu_access_pointer(nfnl_ct_hook)) {
-				ret = -EAGAIN;
-				goto out;
-			}
-#endif
-			ret = -EOPNOTSUPP;
-			goto out;
-		}
-
+	if (nfula[NFULA_CFG_FLAGS])
 		nfulnl_set_flags(inst, flags);
-	}
 
 out_put:
 	instance_put(inst);
-- 
2.1.4

