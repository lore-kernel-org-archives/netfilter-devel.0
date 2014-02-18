From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2/4] netfilter: nfnetlink: add rcu_dereference_protected() helpers
Date: Tue, 18 Feb 2014 18:06:48 +0000
Message-ID: <1392746810-22456-3-git-send-email-kaber@trash.net>
References: <1392746810-22456-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62024 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbaBRSHB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Feb 2014 13:07:01 -0500
In-Reply-To: <1392746810-22456-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Add a lockdep_nfnl_is_held() function and a nfnl_dereference() macro for
RCU dereferences protected by a NFNL subsystem mutex.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 include/linux/netfilter/nfnetlink.h | 21 +++++++++++++++++++++
 net/netfilter/nfnetlink.c           |  8 ++++++++
 2 files changed, 29 insertions(+)

diff --git a/include/linux/netfilter/nfnetlink.h b/include/linux/netfilter/nfnetlink.h
index 28c7436..e955d47 100644
--- a/include/linux/netfilter/nfnetlink.h
+++ b/include/linux/netfilter/nfnetlink.h
@@ -44,6 +44,27 @@ int nfnetlink_unicast(struct sk_buff *skb, struct net *net, u32 portid,
 
 void nfnl_lock(__u8 subsys_id);
 void nfnl_unlock(__u8 subsys_id);
+#ifdef CONFIG_PROVE_LOCKING
+int lockdep_nfnl_is_held(__u8 subsys_id);
+#else
+static inline int lockdep_nfnl_is_held(__u8 subsys_id)
+{
+	return 1;
+}
+#endif /* CONFIG_PROVE_LOCKING */
+
+/*
+ * nfnl_dereference - fetch RCU pointer when updates are prevented by subsys mutex
+ *
+ * @p: The pointer to read, prior to dereferencing
+ * @ss: The nfnetlink subsystem ID
+ *
+ * Return the value of the specified RCU-protected pointer, but omit
+ * both the smp_read_barrier_depends() and the ACCESS_ONCE(), because
+ * caller holds the NFNL subsystem mutex.
+ */
+#define nfnl_dereference(p, ss)					\
+	rcu_dereference_protected(p, lockdep_nfnl_is_held(ss))
 
 #define MODULE_ALIAS_NFNL_SUBSYS(subsys) \
 	MODULE_ALIAS("nfnetlink-subsys-" __stringify(subsys))
diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index 046aa13..e8138da 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -61,6 +61,14 @@ void nfnl_unlock(__u8 subsys_id)
 }
 EXPORT_SYMBOL_GPL(nfnl_unlock);
 
+#ifdef CONFIG_PROVE_LOCKING
+int lockdep_nfnl_is_held(u8 subsys_id)
+{
+	return lockdep_is_held(&table[subsys_id].mutex);
+}
+EXPORT_SYMBOL_GPL(lockdep_nfnl_is_held);
+#endif
+
 int nfnetlink_subsys_register(const struct nfnetlink_subsystem *n)
 {
 	nfnl_lock(n->subsys_id);
-- 
1.8.5.3

