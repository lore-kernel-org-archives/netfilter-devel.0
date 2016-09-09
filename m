From: fgao@ikuai8.com
Subject: [PATCH v3 2/2 nf-next] netfilter: Add the missed return value check of nft_register_chain_type
Date: Fri,  9 Sep 2016 23:25:36 +0800
Message-ID: <1473434736-4479-1-git-send-email-fgao@ikuai8.com>
Cc: gfree.wind@gmail.com, Gao Feng <fgao@ikuai8.com>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbg327.qq.com ([14.17.43.158]:41782 "EHLO smtpbg327.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754401AbcIIPZ5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Sep 2016 11:25:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Gao Feng <fgao@ikuai8.com>

There are some codes of netfilter module which did not check the return
value of nft_register_chain_type. Add the checks now.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 v3: Split return value check of nft_register_chain_type as second patch
 v2: Add all return value checks in netfilter module
 v1: Initial patch

 net/netfilter/nf_tables_inet.c   | 13 ++++++++++---
 net/netfilter/nf_tables_netdev.c | 14 +++++++++-----
 2 files changed, 19 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nf_tables_inet.c b/net/netfilter/nf_tables_inet.c
index 6b5f762..8ed7953 100644
--- a/net/netfilter/nf_tables_inet.c
+++ b/net/netfilter/nf_tables_inet.c
@@ -82,11 +82,18 @@ static int __init nf_tables_inet_init(void)
 {
 	int ret;
 
-	nft_register_chain_type(&filter_inet);
+	ret = nft_register_chain_type(&filter_inet);
+	if (ret)
+		goto err1;
+
 	ret = register_pernet_subsys(&nf_tables_inet_net_ops);
-	if (ret < 0)
-		nft_unregister_chain_type(&filter_inet);
+	if (ret)
+		goto err2;
 
+	return 0;
+err2:
+	nft_unregister_chain_type(&filter_inet);
+err1:
 	return ret;
 }
 
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


