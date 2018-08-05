From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 13/21] netfilter: cttimeout: Make NF_CT_NETLINK_TIMEOUT depend on NF_CONNTRACK_TIMEOUT
Date: Sun,  5 Aug 2018 23:21:33 +0200
Message-ID: <20180805212141.3033-14-pablo@netfilter.org>
References: <20180805212141.3033-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180805212141.3033-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Harsha Sharma <harshasharmaiitr@gmail.com>

With this, remove ifdef for CONFIG_NF_CONNTRACK_TIMEOUT in
nfnetlink_cttimeout. This is also required for moving ctnl_untimeout
from nfnetlink_cttimeout to nf_conntrack_timeout.

Signed-off-by: Harsha Sharma <harshasharmaiitr@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/Kconfig               | 1 +
 net/netfilter/nfnetlink_cttimeout.c | 6 ------
 2 files changed, 1 insertion(+), 6 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 0febf3e21f91..55e399d5af10 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -365,6 +365,7 @@ config NF_CT_NETLINK_TIMEOUT
 	tristate  'Connection tracking timeout tuning via Netlink'
 	select NETFILTER_NETLINK
 	depends on NETFILTER_ADVANCED
+	depends on NF_CONNTRACK_TIMEOUT
 	help
 	  This option enables support for connection tracking timeout
 	  fine-grain tuning. This allows you to attach specific timeout
diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
index d9d952fad3e0..4199e5300575 100644
--- a/net/netfilter/nfnetlink_cttimeout.c
+++ b/net/netfilter/nfnetlink_cttimeout.c
@@ -503,7 +503,6 @@ static int cttimeout_default_get(struct net *net, struct sock *ctnl,
 	return err;
 }
 
-#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 static struct ctnl_timeout *
 ctnl_timeout_find_get(struct net *net, const char *name)
 {
@@ -534,7 +533,6 @@ static void ctnl_timeout_put(struct ctnl_timeout *timeout)
 
 	module_put(THIS_MODULE);
 }
-#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 
 static const struct nfnl_callback cttimeout_cb[IPCTNL_MSG_TIMEOUT_MAX] = {
 	[IPCTNL_MSG_TIMEOUT_NEW]	= { .call = cttimeout_new_timeout,
@@ -605,10 +603,8 @@ static int __init cttimeout_init(void)
 			"nfnetlink.\n");
 		goto err_out;
 	}
-#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	RCU_INIT_POINTER(nf_ct_timeout_find_get_hook, ctnl_timeout_find_get);
 	RCU_INIT_POINTER(nf_ct_timeout_put_hook, ctnl_timeout_put);
-#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 	return 0;
 
 err_out:
@@ -621,11 +617,9 @@ static void __exit cttimeout_exit(void)
 	nfnetlink_subsys_unregister(&cttimeout_subsys);
 
 	unregister_pernet_subsys(&cttimeout_ops);
-#ifdef CONFIG_NF_CONNTRACK_TIMEOUT
 	RCU_INIT_POINTER(nf_ct_timeout_find_get_hook, NULL);
 	RCU_INIT_POINTER(nf_ct_timeout_put_hook, NULL);
 	synchronize_rcu();
-#endif /* CONFIG_NF_CONNTRACK_TIMEOUT */
 }
 
 module_init(cttimeout_init);
-- 
2.11.0
