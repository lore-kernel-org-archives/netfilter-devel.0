From: fgao@ikuai8.com
Subject: [PATCH v3 1/2 nf-next] netfilter: Add the missed return value check of register_netdevice_notifier
Date: Fri,  9 Sep 2016 23:25:09 +0800
Message-ID: <1473434709-4432-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg291.qq.com ([113.108.11.223]:41488 "EHLO smtpbg291.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754354AbcIIPZv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 11:25:51 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

There are some codes of netfilter module which did not check the return
value of register_netdevice_notifier. Add the checks now.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 v3: Split return value check of nft_register_chain_type as second patch
 v2: Add all return value checks in netfilter module
 v1: Initial patch 

 net/netfilter/nf_tables_netdev.c | 18 +++++++++++++-----
 net/netfilter/nfnetlink_queue.c  |  9 ++++++++-
 net/netfilter/xt_TEE.c           |  8 +++++++-
 3 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
index 5eefe4a..673ec5f 100644
--- a/net/netfilter/nf_tables_netdev.c
+++ b/net/netfilter/nf_tables_netdev.c
@@ -224,12 +224,20 @@ static int __init nf_tables_netdev_init(void)
 
 	nft_register_chain_type(&nft_filter_chain_netdev);
 	ret = register_pernet_subsys(&nf_tables_netdev_net_ops);
-	if (ret < 0) {
-		nft_unregister_chain_type(&nft_filter_chain_netdev);
-		return ret;
-	}
-	register_netdevice_notifier(&nf_tables_netdev_notifier);
+	if (ret)
+		goto err1;
+
+	ret = register_netdevice_notifier(&nf_tables_netdev_notifier);
+	if (ret)
+		goto err2;
+
 	return 0;
+
+err2:
+	unregister_pernet_subsys(&nf_tables_netdev_net_ops);
+err1:
+	nft_unregister_chain_type(&nft_filter_chain_netdev);
+	return ret;
 }
 
 static void __exit nf_tables_netdev_exit(void)
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index f49f450..808da34 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -1522,9 +1522,16 @@ static int __init nfnetlink_queue_init(void)
 		goto cleanup_netlink_notifier;
 	}
 
-	register_netdevice_notifier(&nfqnl_dev_notifier);
+	status = register_netdevice_notifier(&nfqnl_dev_notifier);
+	if (status < 0) {
+		pr_err("nf_queue: failed to register netdevice notifier\n");
+		goto cleanup_netlink_subsys;
+	}
+
 	return status;
 
+cleanup_netlink_subsys:
+	nfnetlink_subsys_unregister(&nfqnl_subsys);
 cleanup_netlink_notifier:
 	netlink_unregister_notifier(&nfqnl_rtnl_notifier);
 	unregister_pernet_subsys(&nfnl_queue_net_ops);
diff --git a/net/netfilter/xt_TEE.c b/net/netfilter/xt_TEE.c
index 6e57a39..0471db4 100644
--- a/net/netfilter/xt_TEE.c
+++ b/net/netfilter/xt_TEE.c
@@ -89,6 +89,8 @@ static int tee_tg_check(const struct xt_tgchk_param *par)
 		return -EINVAL;
 
 	if (info->oif[0]) {
+		int ret;
+
 		if (info->oif[sizeof(info->oif)-1] != '\0')
 			return -EINVAL;
 
@@ -101,7 +103,11 @@ static int tee_tg_check(const struct xt_tgchk_param *par)
 		priv->notifier.notifier_call = tee_netdev_event;
 		info->priv    = priv;
 
-		register_netdevice_notifier(&priv->notifier);
+		ret = register_netdevice_notifier(&priv->notifier);
+		if (ret) {
+			kfree(priv);
+			return ret;
+		}
 	} else
 		info->priv = NULL;
 
-- 
1.9.1

