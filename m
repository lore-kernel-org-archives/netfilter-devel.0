From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [PATCHv2 nf-next 3/5] netfilter: nfnetlink_queue_ct: export
 functions
Date: Mon, 7 Sep 2015 16:44:28 +0900
Message-ID: <20150907074428.GA32741@gmail.com>
References: <20150824231038.GA20038@gmail.com>
 <20150824231520.GC20038@gmail.com>
 <20150826190553.GA18429@salvia>
 <20150901003436.GA2642@gmail.com>
 <20150901004146.GD2642@gmail.com>
 <20150903101034.GA19011@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="uAKRQypu60I7Lcqm"
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:35639 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240AbbIGHoe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Sep 2015 03:44:34 -0400
Received: by pacfv12 with SMTP id fv12so91444043pac.2
        for <netfilter-devel@vger.kernel.org>; Mon, 07 Sep 2015 00:44:33 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20150903101034.GA19011@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--uAKRQypu60I7Lcqm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

 Hi,

On Thu, Sep 03, 2015 at 12:10:34PM +0200, Pablo Neira Ayuso wrote:
> The idea is that nfnetlink_queue and nfnetlink_log request this module
> to be loaded when the CONNTRACK flag is passed.

I tried to modularize nfnetlink_queue_ct first, please see a patch
attached. It can be compiled with NETFILTER_NETLINK_QUEUE=m and any
of NETFILTER_NETLINK_QUEUE_CT, but in a case of QUEUE=y, QUEUE_CT
can not be a module.

Can we enforce QUEUE_CT not to be 'm', in case of QUEUE=y by
updating Kconfig? Would you please give me some advice?

Thanks,

--uAKRQypu60I7Lcqm
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-netfilter-nfnetlink_queue-modularize-nfnetlink_queue.patch"

>From e2bc33e98b8626c475482c11106e56d15bcf2268 Mon Sep 17 00:00:00 2001
From: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Date: Mon, 7 Sep 2015 09:44:30 +0900
Subject: [PATCH 1/5] netfilter: nfnetlink_queue: modularize nfnetlink_queue_ct

The aim of this patch is eventually to include the conntrack
information together with not only nfqueue but also nflog. The first
thing to do so is modularize nfnetlink_queue_ct.

Signed-off-by: Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
---
 include/linux/netfilter.h               |   11 -----------
 include/net/netfilter/nf_conntrack.h    |   10 ++++++++++
 include/net/netfilter/nfnetlink_queue.h |    4 ++--
 net/netfilter/Kconfig                   |    7 ++++---
 net/netfilter/Makefile                  |    2 +-
 net/netfilter/core.c                    |    4 ----
 net/netfilter/nf_conntrack_netlink.c    |   12 +++---------
 net/netfilter/nfnetlink_queue_core.c    |    6 ++++++
 net/netfilter/nfnetlink_queue_ct.c      |   29 +++++++++++++++++++++++++++++
 9 files changed, 55 insertions(+), 30 deletions(-)

diff --git a/include/linux/netfilter.h b/include/linux/netfilter.h
index d788ce6..5582d9b 100644
--- a/include/linux/netfilter.h
+++ b/include/linux/netfilter.h
@@ -375,17 +375,6 @@ extern void (*nf_ct_destroy)(struct nf_conntrack *) __rcu;
 struct nf_conn;
 enum ip_conntrack_info;
 struct nlattr;
-
-struct nfq_ct_hook {
-	size_t (*build_size)(const struct nf_conn *ct);
-	int (*build)(struct sk_buff *skb, struct nf_conn *ct);
-	int (*parse)(const struct nlattr *attr, struct nf_conn *ct);
-	int (*attach_expect)(const struct nlattr *attr, struct nf_conn *ct,
-			     u32 portid, u32 report);
-	void (*seq_adjust)(struct sk_buff *skb, struct nf_conn *ct,
-			   enum ip_conntrack_info ctinfo, s32 off);
-};
-extern struct nfq_ct_hook __rcu *nfq_ct_hook;
 #else
 static inline void nf_ct_attach(struct sk_buff *new, struct sk_buff *skb) {}
 #endif
diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
index f5e23c6..23d0528 100644
--- a/include/net/netfilter/nf_conntrack.h
+++ b/include/net/netfilter/nf_conntrack.h
@@ -305,4 +305,14 @@ struct nf_conn *nf_ct_tmpl_alloc(struct net *net,
 #define MODULE_ALIAS_NFCT_HELPER(helper) \
         MODULE_ALIAS("nfct-helper-" helper)
 
+struct nfq_ct_hook {
+	size_t (*build_size)(const struct nf_conn *ct);
+	int (*build)(struct sk_buff *skb, struct nf_conn *ct);
+	int (*parse)(const struct nlattr *attr, struct nf_conn *ct);
+	int (*attach_expect)(const struct nlattr *attr, struct nf_conn *ct,
+			     u32 portid, u32 report);
+	void (*seq_adjust)(struct sk_buff *skb, struct nf_conn *ct,
+			   enum ip_conntrack_info ctinfo, s32 off);
+};
+
 #endif /* _NF_CONNTRACK_H */
diff --git a/include/net/netfilter/nfnetlink_queue.h b/include/net/netfilter/nfnetlink_queue.h
index aff88ba..def25ad 100644
--- a/include/net/netfilter/nfnetlink_queue.h
+++ b/include/net/netfilter/nfnetlink_queue.h
@@ -5,7 +5,7 @@
 
 struct nf_conn;
 
-#ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
+#if IS_ENABLED(CONFIG_NETFILTER_NETLINK_QUEUE_CT)
 struct nf_conn *nfqnl_ct_get(struct sk_buff *entskb, size_t *size,
 			     enum ip_conntrack_info *ctinfo);
 struct nf_conn *nfqnl_ct_parse(const struct sk_buff *skb,
@@ -47,5 +47,5 @@ inline int nfqnl_attach_expect(struct nf_conn *ct, const struct nlattr *attr,
 {
 	return 0;
 }
-#endif /* NF_CONNTRACK */
+#endif /* CONFIG_NETFILTER_NETLINK_QUEUE_CT */
 #endif
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 3e1b4ab..b11e198 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -363,9 +363,10 @@ config NF_CT_NETLINK_HELPER
 	  If unsure, say `N'.
 
 config NETFILTER_NETLINK_QUEUE_CT
-        bool "NFQUEUE integration with Connection Tracking"
-        default n
-        depends on NETFILTER_NETLINK_QUEUE
+	tristate "NFQUEUE integration with Connection Tracking"
+	default n
+	depends on NF_CT_NETLINK
+	depends on NETFILTER_NETLINK_QUEUE
 	help
 	  If this option is enabled, NFQUEUE can include Connection Tracking
 	  information together with the packet is the enqueued via NFNETLINK.
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 70d026d..701d548 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -11,9 +11,9 @@ obj-$(CONFIG_NETFILTER) = netfilter.o
 obj-$(CONFIG_NETFILTER_NETLINK) += nfnetlink.o
 obj-$(CONFIG_NETFILTER_NETLINK_ACCT) += nfnetlink_acct.o
 nfnetlink_queue-y := nfnetlink_queue_core.o
-nfnetlink_queue-$(CONFIG_NETFILTER_NETLINK_QUEUE_CT) += nfnetlink_queue_ct.o
 obj-$(CONFIG_NETFILTER_NETLINK_QUEUE) += nfnetlink_queue.o
 obj-$(CONFIG_NETFILTER_NETLINK_LOG) += nfnetlink_log.o
+obj-$(CONFIG_NETFILTER_NETLINK_QUEUE_CT) += nfnetlink_queue_ct.o
 
 # connection tracking
 obj-$(CONFIG_NF_CONNTRACK) += nf_conntrack.o
diff --git a/net/netfilter/core.c b/net/netfilter/core.c
index 0b939b7..31be279 100644
--- a/net/netfilter/core.c
+++ b/net/netfilter/core.c
@@ -384,10 +384,6 @@ void nf_conntrack_destroy(struct nf_conntrack *nfct)
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL(nf_conntrack_destroy);
-
-struct nfq_ct_hook __rcu *nfq_ct_hook __read_mostly;
-EXPORT_SYMBOL_GPL(nfq_ct_hook);
-
 #endif /* CONFIG_NF_CONNTRACK */
 
 #ifdef CONFIG_NF_NAT_NEEDED
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 94a6654..bd355a5 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -2133,7 +2133,7 @@ ctnetlink_alloc_expect(const struct nlattr *const cda[], struct nf_conn *ct,
 		       struct nf_conntrack_tuple *tuple,
 		       struct nf_conntrack_tuple *mask);
 
-#ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
+#if IS_ENABLED(CONFIG_NETFILTER_NETLINK_QUEUE_CT)
 static size_t
 ctnetlink_nfqueue_build_size(const struct nf_conn *ct)
 {
@@ -2350,13 +2350,14 @@ ctnetlink_nfqueue_attach_expect(const struct nlattr *attr, struct nf_conn *ct,
 	return 0;
 }
 
-static struct nfq_ct_hook ctnetlink_nfqueue_hook = {
+struct nfq_ct_hook ctnetlink_nfqueue_hook = {
 	.build_size	= ctnetlink_nfqueue_build_size,
 	.build		= ctnetlink_nfqueue_build,
 	.parse		= ctnetlink_nfqueue_parse,
 	.attach_expect	= ctnetlink_nfqueue_attach_expect,
 	.seq_adjust	= nf_ct_tcp_seqadj_set,
 };
+EXPORT_SYMBOL_GPL(ctnetlink_nfqueue_hook);
 #endif /* CONFIG_NETFILTER_NETLINK_QUEUE_CT */
 
 /***********************************************************************
@@ -3341,10 +3342,6 @@ static int __init ctnetlink_init(void)
 		pr_err("ctnetlink_init: cannot register pernet operations\n");
 		goto err_unreg_exp_subsys;
 	}
-#ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
-	/* setup interaction between nf_queue and nf_conntrack_netlink. */
-	RCU_INIT_POINTER(nfq_ct_hook, &ctnetlink_nfqueue_hook);
-#endif
 	return 0;
 
 err_unreg_exp_subsys:
@@ -3362,9 +3359,6 @@ static void __exit ctnetlink_exit(void)
 	unregister_pernet_subsys(&ctnetlink_net_ops);
 	nfnetlink_subsys_unregister(&ctnl_exp_subsys);
 	nfnetlink_subsys_unregister(&ctnl_subsys);
-#ifdef CONFIG_NETFILTER_NETLINK_QUEUE_CT
-	RCU_INIT_POINTER(nfq_ct_hook, NULL);
-#endif
 }
 
 module_init(ctnetlink_init);
diff --git a/net/netfilter/nfnetlink_queue_core.c b/net/netfilter/nfnetlink_queue_core.c
index 685cc6a..e2bca3a 100644
--- a/net/netfilter/nfnetlink_queue_core.c
+++ b/net/netfilter/nfnetlink_queue_core.c
@@ -1196,6 +1196,12 @@ nfqnl_recv_config(struct sock *ctnl, struct sk_buff *skb,
 			goto err_out_unlock;
 		}
 #endif
+#if !IS_ENABLED(CONFIG_NETFILTER_NETLINK_QUEUE_CT)
+		if (flags & mask & NFQA_CFG_F_CONNTRACK) {
+			ret = -EOPNOTSUPP;
+			goto err_out_unlock;
+		}
+#endif
 		spin_lock_bh(&queue->lock);
 		queue->flags &= ~mask;
 		queue->flags |= flags & mask;
diff --git a/net/netfilter/nfnetlink_queue_ct.c b/net/netfilter/nfnetlink_queue_ct.c
index 96cac50..4e8587e 100644
--- a/net/netfilter/nfnetlink_queue_ct.c
+++ b/net/netfilter/nfnetlink_queue_ct.c
@@ -7,6 +7,9 @@
  *
  */
 
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
@@ -14,6 +17,9 @@
 #include <net/netfilter/nf_conntrack.h>
 #include <net/netfilter/nfnetlink_queue.h>
 
+extern struct nfq_ct_hook ctnetlink_nfqueue_hook;
+static struct nfq_ct_hook __rcu *nfq_ct_hook __read_mostly;
+
 struct nf_conn *nfqnl_ct_get(struct sk_buff *entskb, size_t *size,
 			     enum ip_conntrack_info *ctinfo)
 {
@@ -34,6 +40,7 @@ struct nf_conn *nfqnl_ct_get(struct sk_buff *entskb, size_t *size,
 	}
 	return ct;
 }
+EXPORT_SYMBOL_GPL(nfqnl_ct_get);
 
 struct nf_conn *
 nfqnl_ct_parse(const struct sk_buff *skb, const struct nlattr *attr,
@@ -53,6 +60,7 @@ nfqnl_ct_parse(const struct sk_buff *skb, const struct nlattr *attr,
 
 	return ct;
 }
+EXPORT_SYMBOL_GPL(nfqnl_ct_parse);
 
 int nfqnl_ct_put(struct sk_buff *skb, struct nf_conn *ct,
 		 enum ip_conntrack_info ctinfo)
@@ -83,6 +91,7 @@ int nfqnl_ct_put(struct sk_buff *skb, struct nf_conn *ct,
 nla_put_failure:
 	return -1;
 }
+EXPORT_SYMBOL_GPL(nfqnl_ct_put);
 
 void nfqnl_ct_seq_adjust(struct sk_buff *skb, struct nf_conn *ct,
 			 enum ip_conntrack_info ctinfo, int diff)
@@ -96,6 +105,7 @@ void nfqnl_ct_seq_adjust(struct sk_buff *skb, struct nf_conn *ct,
 	if ((ct->status & IPS_NAT_MASK) && diff)
 		nfq_ct->seq_adjust(skb, ct, ctinfo, diff);
 }
+EXPORT_SYMBOL_GPL(nfqnl_ct_seq_adjust);
 
 int nfqnl_attach_expect(struct nf_conn *ct, const struct nlattr *attr,
 			u32 portid, u32 report)
@@ -111,3 +121,22 @@ int nfqnl_attach_expect(struct nf_conn *ct, const struct nlattr *attr,
 
 	return nfq_ct->attach_expect(attr, ct, portid, report);
 }
+EXPORT_SYMBOL_GPL(nfqnl_attach_expect);
+
+static int __init nfnl_glue_ct_init(void)
+{
+	rcu_assign_pointer(nfq_ct_hook, &ctnetlink_nfqueue_hook);
+	return 0;
+}
+
+static void __exit nfnl_glue_ct_exit(void)
+{
+	RCU_INIT_POINTER(nfq_ct_hook, NULL);
+        synchronize_rcu();
+}
+
+module_init(nfnl_glue_ct_init);
+module_exit(nfnl_glue_ct_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
-- 
1.7.10.4


--uAKRQypu60I7Lcqm--
