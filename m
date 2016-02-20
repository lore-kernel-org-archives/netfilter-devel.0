From: Stephane Bryant <stephane.ml.bryant@gmail.com>
Subject: [PATCH nf-next v3 1/3] netfilter: bridge: add nf_afinfo to enable queuing to userspace
Date: Sat, 20 Feb 2016 10:07:08 +0100
Message-ID: <1455959230-3680-1-git-send-email-stephane.ml.bryant@gmail.com>
Cc: netfilter-devel@vger.kernel.org,
	stephane <stephane.ml.bryant@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:37936 "EHLO
	mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992561AbcBTJHe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Feb 2016 04:07:34 -0500
Received: by mail-wm0-f49.google.com with SMTP id a4so100461744wme.1
        for <netfilter-devel@vger.kernel.org>; Sat, 20 Feb 2016 01:07:33 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: stephane <stephane.ml.bryant@gmail.com>

This just adds and registers a nf_afinfo for the ethernet
bridge, which enables queuing to userspace for the AF_BRIDGE
family. No checksum computation is done.

Signed-off-by: Stephane Bryant <stephane.ml.bryant@gmail.com>
---
 net/bridge/netfilter/nf_tables_bridge.c | 47 +++++++++++++++++++++++++++++++--
 1 file changed, 45 insertions(+), 2 deletions(-)

diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index 7fcdd72..a78c4e2 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -162,15 +162,57 @@ static const struct nf_chain_type filter_bridge = {
 			  (1 << NF_BR_POST_ROUTING),
 };
 
+static void nf_br_saveroute(const struct sk_buff *skb,
+			    struct nf_queue_entry *entry)
+{
+}
+
+static int nf_br_reroute(struct net *net, struct sk_buff *skb,
+			 const struct nf_queue_entry *entry)
+{
+	return 0;
+}
+
+static __sum16 nf_br_checksum(struct sk_buff *skb, unsigned int hook,
+			      unsigned int dataoff, u_int8_t protocol)
+{
+	return 0;
+}
+
+static __sum16 nf_br_checksum_partial(struct sk_buff *skb, unsigned int hook,
+				      unsigned int dataoff, unsigned int len,
+				      u_int8_t protocol)
+{
+	return 0;
+}
+
+static int nf_br_route(struct net *net, struct dst_entry **dst,
+		       struct flowi *fl, bool strict __always_unused)
+{
+	return 0;
+}
+
+static const struct nf_afinfo nf_br_afinfo = {
+	.family                 = AF_BRIDGE,
+	.checksum               = nf_br_checksum,
+	.checksum_partial       = nf_br_checksum_partial,
+	.route                  = nf_br_route,
+	.saveroute              = nf_br_saveroute,
+	.reroute                = nf_br_reroute,
+	.route_key_size         = 0,
+};
+
 static int __init nf_tables_bridge_init(void)
 {
 	int ret;
 
+	nf_register_afinfo(&nf_br_afinfo);
 	nft_register_chain_type(&filter_bridge);
 	ret = register_pernet_subsys(&nf_tables_bridge_net_ops);
-	if (ret < 0)
+	if (ret < 0) {
 		nft_unregister_chain_type(&filter_bridge);
-
+		nf_unregister_afinfo(&nf_br_afinfo);
+	}
 	return ret;
 }
 
@@ -178,6 +220,7 @@ static void __exit nf_tables_bridge_exit(void)
 {
 	unregister_pernet_subsys(&nf_tables_bridge_net_ops);
 	nft_unregister_chain_type(&filter_bridge);
+	nf_unregister_afinfo(&nf_br_afinfo);
 }
 
 module_init(nf_tables_bridge_init);
-- 
2.1.4

