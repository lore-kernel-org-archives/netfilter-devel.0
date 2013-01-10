From: pablo@netfilter.org
Subject: [PATCH 2/7] netfilter: nf_tables: move filter chain definition to layer 3 modules
Date: Thu, 10 Jan 2013 16:28:36 +0100
Message-ID: <1357831721-10182-2-git-send-email-pablo@netfilter.org>
References: <1357831721-10182-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37132 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753907Ab3AJP24 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:28:56 -0500
In-Reply-To: <1357831721-10182-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch moves the definition of the filter_ipv4 and filter_ipv6
default filter chains to where they belong.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/netfilter/nf_tables_ipv4.c |   23 +++++++++++++++++++-
 net/ipv6/netfilter/nf_tables_ipv6.c |   23 +++++++++++++++++++-
 net/netfilter/nf_tables_api.c       |   41 -----------------------------------
 3 files changed, 44 insertions(+), 43 deletions(-)

diff --git a/net/ipv4/netfilter/nf_tables_ipv4.c b/net/ipv4/netfilter/nf_tables_ipv4.c
index 8827539..a0ee4c2 100644
--- a/net/ipv4/netfilter/nf_tables_ipv4.c
+++ b/net/ipv4/netfilter/nf_tables_ipv4.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
+ * Copyright (c) 2012-2013 Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -70,14 +71,34 @@ static struct pernet_operations nf_tables_ipv4_net_ops = {
 	.exit	= nf_tables_ipv4_exit_net,
 };
 
+static struct nf_chain_type filter_ipv4 = {
+	.family		= NFPROTO_IPV4,
+	.name		= "filter",
+	.type		= NFT_CHAIN_T_DEFAULT,
+	.hook_mask	= (1 << NF_INET_LOCAL_IN) |
+			  (1 << NF_INET_LOCAL_OUT) |
+			  (1 << NF_INET_FORWARD) |
+			  (1 << NF_INET_PRE_ROUTING) |
+			  (1 << NF_INET_POST_ROUTING),
+	.fn		= {
+		[NF_INET_LOCAL_IN]	= nft_do_chain,
+		[NF_INET_LOCAL_OUT]	= nft_do_chain,
+		[NF_INET_FORWARD]	= nft_do_chain,
+		[NF_INET_PRE_ROUTING]	= nft_do_chain,
+		[NF_INET_POST_ROUTING]	= nft_do_chain,
+	},
+};
+
 static int __init nf_tables_ipv4_init(void)
 {
+	nft_register_chain_type(&filter_ipv4);
 	return register_pernet_subsys(&nf_tables_ipv4_net_ops);
 }
 
 static void __exit nf_tables_ipv4_exit(void)
 {
-	return unregister_pernet_subsys(&nf_tables_ipv4_net_ops);
+	unregister_pernet_subsys(&nf_tables_ipv4_net_ops);
+	nft_unregister_chain_type(&filter_ipv4);
 }
 
 module_init(nf_tables_ipv4_init);
diff --git a/net/ipv6/netfilter/nf_tables_ipv6.c b/net/ipv6/netfilter/nf_tables_ipv6.c
index ff68524..e1eee09 100644
--- a/net/ipv6/netfilter/nf_tables_ipv6.c
+++ b/net/ipv6/netfilter/nf_tables_ipv6.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
+ * Copyright (c) 2012-2013 Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -67,14 +68,34 @@ static struct pernet_operations nf_tables_ipv6_net_ops = {
 	.exit	= nf_tables_ipv6_exit_net,
 };
 
+static struct nf_chain_type filter_ipv6 = {
+	.family		= NFPROTO_IPV6,
+	.name		= "filter",
+	.type		= NFT_CHAIN_T_DEFAULT,
+	.hook_mask	= (1 << NF_INET_LOCAL_IN) |
+			  (1 << NF_INET_LOCAL_OUT) |
+			  (1 << NF_INET_FORWARD) |
+			  (1 << NF_INET_PRE_ROUTING) |
+			  (1 << NF_INET_POST_ROUTING),
+	.fn		= {
+		[NF_INET_LOCAL_IN]	= nft_do_chain,
+		[NF_INET_LOCAL_OUT]	= nft_do_chain,
+		[NF_INET_FORWARD]	= nft_do_chain,
+		[NF_INET_PRE_ROUTING]	= nft_do_chain,
+		[NF_INET_POST_ROUTING]	= nft_do_chain,
+	},
+};
+
 static int __init nf_tables_ipv6_init(void)
 {
+	nft_register_chain_type(&filter_ipv6);
 	return register_pernet_subsys(&nf_tables_ipv6_net_ops);
 }
 
 static void __exit nf_tables_ipv6_exit(void)
 {
-	return unregister_pernet_subsys(&nf_tables_ipv6_net_ops);
+	unregister_pernet_subsys(&nf_tables_ipv6_net_ops);
+	nft_unregister_chain_type(&filter_ipv6);
 }
 
 module_init(nf_tables_ipv6_init);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d0dab16..a8ae0b4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2842,42 +2842,6 @@ int nft_data_dump(struct sk_buff *skb, int attr, const struct nft_data *data,
 }
 EXPORT_SYMBOL_GPL(nft_data_dump);
 
-static struct nf_chain_type filter_ipv4 = {
-	.family		= NFPROTO_IPV4,
-	.name		= "filter",
-	.type		= NFT_CHAIN_T_DEFAULT,
-	.hook_mask	= (1 << NF_INET_LOCAL_IN) |
-			  (1 << NF_INET_LOCAL_OUT) |
-			  (1 << NF_INET_FORWARD) |
-			  (1 << NF_INET_PRE_ROUTING) |
-			  (1 << NF_INET_POST_ROUTING),
-	.fn		= {
-		[NF_INET_LOCAL_IN] 	= nft_do_chain,
-		[NF_INET_LOCAL_OUT]	= nft_do_chain,
-		[NF_INET_FORWARD]	= nft_do_chain,
-		[NF_INET_PRE_ROUTING]	= nft_do_chain,
-		[NF_INET_POST_ROUTING]	= nft_do_chain,
-	},
-};
-
-static struct nf_chain_type filter_ipv6 = {
-	.family		= NFPROTO_IPV6,
-	.name		= "filter",
-	.type		= NFT_CHAIN_T_DEFAULT,
-	.hook_mask	= (1 << NF_INET_LOCAL_IN) |
-			  (1 << NF_INET_LOCAL_OUT) |
-			  (1 << NF_INET_FORWARD) |
-			  (1 << NF_INET_PRE_ROUTING) |
-			  (1 << NF_INET_POST_ROUTING),
-	.fn		= {
-		[NF_INET_LOCAL_IN] 	= nft_do_chain,
-		[NF_INET_LOCAL_OUT]	= nft_do_chain,
-		[NF_INET_FORWARD]	= nft_do_chain,
-		[NF_INET_PRE_ROUTING]	= nft_do_chain,
-		[NF_INET_POST_ROUTING]	= nft_do_chain,
-	},
-};
-
 static int nf_tables_init_net(struct net *net)
 {
 	INIT_LIST_HEAD(&net->nft.af_info);
@@ -2907,9 +2871,6 @@ static int __init nf_tables_module_init(void)
 	if (err < 0)
 		goto err3;
 
-	nft_register_chain_type(&filter_ipv4);
-	nft_register_chain_type(&filter_ipv6);
-
 	pr_info("nf_tables: (c) 2007-2009 Patrick McHardy <kaber@trash.net>\n");
 	return register_pernet_subsys(&nf_tables_net_ops);
 err3:
@@ -2923,8 +2884,6 @@ err1:
 static void __exit nf_tables_module_exit(void)
 {
 	unregister_pernet_subsys(&nf_tables_net_ops);
-	nft_unregister_chain_type(&filter_ipv4);
-	nft_unregister_chain_type(&filter_ipv6);
 	nfnetlink_subsys_unregister(&nf_tables_subsys);
 	nf_tables_core_module_exit();
 	kfree(info);
-- 
1.7.10.4

