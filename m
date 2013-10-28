From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf_tables] netfilter: bridge: nf_tables: add filter chain type
Date: Mon, 28 Oct 2013 18:06:32 +0100
Message-ID: <1382979992-17413-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42443 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103Ab3J1RGk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:06:40 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the filter chain type which is required to
create filter chains in the bridge table from userspace.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/nf_tables_bridge.c |   41 +++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index e8cb016..cf54b22 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -1,5 +1,6 @@
 /*
  * Copyright (c) 2008 Patrick McHardy <kaber@trash.net>
+ * Copyright (c) 2013 Pablo Neira Ayuso <pablo@netfilter.org>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License version 2 as
@@ -47,14 +48,50 @@ static struct pernet_operations nf_tables_bridge_net_ops = {
 	.exit	= nf_tables_bridge_exit_net,
 };
 
+static unsigned int
+nft_do_chain_bridge(const struct nf_hook_ops *ops,
+		    struct sk_buff *skb,
+		    const struct net_device *in,
+		    const struct net_device *out,
+		    int (*okfn)(struct sk_buff *))
+{
+	struct nft_pktinfo pkt;
+
+	nft_set_pktinfo(&pkt, ops, skb, in, out);
+
+	return nft_do_chain_pktinfo(&pkt, ops);
+}
+
+static struct nf_chain_type filter_bridge = {
+	.family		= NFPROTO_BRIDGE,
+	.name		= "filter",
+	.type		= NFT_CHAIN_T_DEFAULT,
+	.hook_mask	= (1 << NF_BR_LOCAL_IN) |
+			  (1 << NF_BR_FORWARD) |
+			  (1 << NF_BR_LOCAL_OUT),
+	.fn		= {
+		[NF_BR_LOCAL_IN]	= nft_do_chain_bridge,
+		[NF_BR_FORWARD]		= nft_do_chain_bridge,
+		[NF_BR_LOCAL_OUT]	= nft_do_chain_bridge,
+	},
+};
+
 static int __init nf_tables_bridge_init(void)
 {
-	return register_pernet_subsys(&nf_tables_bridge_net_ops);
+	int ret;
+
+	nft_register_chain_type(&filter_bridge);
+	ret = register_pernet_subsys(&nf_tables_bridge_net_ops);
+	if (ret < 0)
+		nft_unregister_chain_type(&filter_bridge);
+
+	return ret;
 }
 
 static void __exit nf_tables_bridge_exit(void)
 {
-	return unregister_pernet_subsys(&nf_tables_bridge_net_ops);
+	unregister_pernet_subsys(&nf_tables_bridge_net_ops);
+	nft_unregister_chain_type(&filter_bridge);
 }
 
 module_init(nf_tables_bridge_init);
-- 
1.7.10.4

