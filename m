From: fgao@ikuai8.com
Subject: [PATCH v4 2/2 nf-next] netfilter: Add the missed return value check of nft_register_chain_type
Date: Sat, 10 Sep 2016 10:04:30 +0800
Message-ID: <1473473070-7062-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg291.qq.com ([113.108.11.223]:33412 "EHLO smtpbg291.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751219AbcIJCF3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 22:05:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

There are some codes of netfilter module which did not check the return
value of nft_register_chain_type. Add the checks now.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 v4: Cover the net/bridge, ipv4/netfilter, and ipv6/netfilter too;
 v3: Split return value check of nft_register_chain_type as second patch
 v2: Add all return value checks in netfilter module
 v1: Initial patch

 net/bridge/netfilter/nf_tables_bridge.c | 14 +++++++++++---
 net/ipv4/netfilter/nf_tables_arp.c      |  5 ++++-
 net/ipv4/netfilter/nf_tables_ipv4.c     |  5 ++++-
 net/ipv6/netfilter/nf_tables_ipv6.c     |  5 ++++-
 net/netfilter/nf_tables_inet.c          |  5 ++++-
 net/netfilter/nf_tables_netdev.c        | 14 +++++++++-----
 6 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index a78c4e2..d226e8b 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -207,13 +207,21 @@ static int __init nf_tables_bridge_init(void)
 	int ret;
 
 	nf_register_afinfo(&nf_br_afinfo);
-	nft_register_chain_type(&filter_bridge);
+	ret = nft_register_chain_type(&filter_bridge);
+	if (ret < 0)
+		goto err1;
+
 	ret = register_pernet_subsys(&nf_tables_bridge_net_ops);
 	if (ret < 0) {
-		nft_unregister_chain_type(&filter_bridge);
-		nf_unregister_afinfo(&nf_br_afinfo);
+		goto err2;
 	}
 	return ret;
+
+err2:
+	nft_unregister_chain_type(&filter_bridge);
+err1:
+	nf_unregister_afinfo(&nf_br_afinfo);
+	return ret;
 }
 
 static void __exit nf_tables_bridge_exit(void)
diff --git a/net/ipv4/netfilter/nf_tables_arp.c b/net/ipv4/netfilter/nf_tables_arp.c
index cd84d42..b91ae8f 100644
--- a/net/ipv4/netfilter/nf_tables_arp.c
+++ b/net/ipv4/netfilter/nf_tables_arp.c
@@ -80,7 +80,10 @@ static int __init nf_tables_arp_init(void)
 {
 	int ret;
 
-	nft_register_chain_type(&filter_arp);
+	ret = nft_register_chain_type(&filter_arp);
+	if (ret < 0)
+		return ret;
+
 	ret = register_pernet_subsys(&nf_tables_arp_net_ops);
 	if (ret < 0)
 		nft_unregister_chain_type(&filter_arp);
diff --git a/net/ipv4/netfilter/nf_tables_ipv4.c b/net/ipv4/netfilter/nf_tables_ipv4.c
index e44ba3b..2840a29 100644
--- a/net/ipv4/netfilter/nf_tables_ipv4.c
+++ b/net/ipv4/netfilter/nf_tables_ipv4.c
@@ -103,7 +103,10 @@ static int __init nf_tables_ipv4_init(void)
 {
 	int ret;
 
-	nft_register_chain_type(&filter_ipv4);
+	ret = nft_register_chain_type(&filter_ipv4);
+	if (ret < 0)
+		return ret;
+
 	ret = register_pernet_subsys(&nf_tables_ipv4_net_ops);
 	if (ret < 0)
 		nft_unregister_chain_type(&filter_ipv4);
diff --git a/net/ipv6/netfilter/nf_tables_ipv6.c b/net/ipv6/netfilter/nf_tables_ipv6.c
index 30b22f4..340b978 100644
--- a/net/ipv6/netfilter/nf_tables_ipv6.c
+++ b/net/ipv6/netfilter/nf_tables_ipv6.c
@@ -102,7 +102,10 @@ static int __init nf_tables_ipv6_init(void)
 {
 	int ret;
 
-	nft_register_chain_type(&filter_ipv6);
+	ret = nft_register_chain_type(&filter_ipv6);
+	if (ret < 0)
+		return ret;
+
 	ret = register_pernet_subsys(&nf_tables_ipv6_net_ops);
 	if (ret < 0)
 		nft_unregister_chain_type(&filter_ipv6);
diff --git a/net/netfilter/nf_tables_inet.c b/net/netfilter/nf_tables_inet.c
index 6b5f762..f713cc2 100644
--- a/net/netfilter/nf_tables_inet.c
+++ b/net/netfilter/nf_tables_inet.c
@@ -82,7 +82,10 @@ static int __init nf_tables_inet_init(void)
 {
 	int ret;
 
-	nft_register_chain_type(&filter_inet);
+	ret = nft_register_chain_type(&filter_inet);
+	if (ret < 0)
+		return ret;
+
 	ret = register_pernet_subsys(&nf_tables_inet_net_ops);
 	if (ret < 0)
 		nft_unregister_chain_type(&filter_inet);
diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
index 673ec5f..2c2a17e 100644
--- a/net/netfilter/nf_tables_netdev.c
+++ b/net/netfilter/nf_tables_netdev.c
@@ -222,21 +222,25 @@ static int __init nf_tables_netdev_init(void)
 {
 	int ret;
 
-	nft_register_chain_type(&nft_filter_chain_netdev);
-	ret = register_pernet_subsys(&nf_tables_netdev_net_ops);
+	ret = nft_register_chain_type(&nft_filter_chain_netdev);
 	if (ret)
 		goto err1;
 
-	ret = register_netdevice_notifier(&nf_tables_netdev_notifier);
+	ret = register_pernet_subsys(&nf_tables_netdev_net_ops);
 	if (ret)
 		goto err2;
 
+	ret = register_netdevice_notifier(&nf_tables_netdev_notifier);
+	if (ret)
+		goto err3;
+
 	return 0;
 
-err2:
+err3:
 	unregister_pernet_subsys(&nf_tables_netdev_net_ops);
-err1:
+err2:
 	nft_unregister_chain_type(&nft_filter_chain_netdev);
+err1:
 	return ret;
 }
 
-- 
1.9.1

