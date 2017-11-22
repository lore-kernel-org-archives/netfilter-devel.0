From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 4/5] netfilter: nf_tables_inet: don't use multihook infrastructure anymore
Date: Wed, 22 Nov 2017 15:02:49 +0100
Message-ID: <20171122140250.14798-5-pablo@netfilter.org>
References: <20171122140250.14798-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45784 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751319AbdKVODe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Nov 2017 09:03:34 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 678B01D94BE
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:03:32 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DD918DA90B
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:03:31 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E5A32BAC2A
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:02:56 +0100 (CET)
Received: from salvia.here (129.166.216.87.static.jazztel.es [87.216.166.129])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 9FCF8403DFA0
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Nov 2017 15:02:56 +0100 (CET)
In-Reply-To: <20171122140250.14798-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use new native NFPROTO_INET support in netfilter core, this gets rid of
ad-hoc code in the nf_tables API codebase.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_ipv4.h |  2 --
 include/net/netfilter/nf_tables_ipv6.h |  2 --
 net/ipv4/netfilter/nf_tables_ipv4.c    |  3 +-
 net/ipv6/netfilter/nf_tables_ipv6.c    |  3 +-
 net/netfilter/nf_tables_inet.c         | 66 +++++++++++++++++++++++++++-------
 5 files changed, 56 insertions(+), 20 deletions(-)

diff --git a/include/net/netfilter/nf_tables_ipv4.h b/include/net/netfilter/nf_tables_ipv4.h
index f0896ba456c4..56b82bb3b78a 100644
--- a/include/net/netfilter/nf_tables_ipv4.h
+++ b/include/net/netfilter/nf_tables_ipv4.h
@@ -62,6 +62,4 @@ nft_set_pktinfo_ipv4_validate(struct nft_pktinfo *pkt,
 		nft_set_pktinfo_proto_unspec(pkt, skb);
 }
 
-extern struct nft_af_info nft_af_ipv4;
-
 #endif
diff --git a/include/net/netfilter/nf_tables_ipv6.h b/include/net/netfilter/nf_tables_ipv6.h
index b8065b72f56e..c1158d83fb5f 100644
--- a/include/net/netfilter/nf_tables_ipv6.h
+++ b/include/net/netfilter/nf_tables_ipv6.h
@@ -78,6 +78,4 @@ nft_set_pktinfo_ipv6_validate(struct nft_pktinfo *pkt,
 		nft_set_pktinfo_proto_unspec(pkt, skb);
 }
 
-extern struct nft_af_info nft_af_ipv6;
-
 #endif
diff --git a/net/ipv4/netfilter/nf_tables_ipv4.c b/net/ipv4/netfilter/nf_tables_ipv4.c
index 2840a29b2e04..d731a1c2e00a 100644
--- a/net/ipv4/netfilter/nf_tables_ipv4.c
+++ b/net/ipv4/netfilter/nf_tables_ipv4.c
@@ -44,7 +44,7 @@ static unsigned int nft_ipv4_output(void *priv,
 	return nft_do_chain_ipv4(priv, skb, state);
 }
 
-struct nft_af_info nft_af_ipv4 __read_mostly = {
+static struct nft_af_info nft_af_ipv4 __read_mostly = {
 	.family		= NFPROTO_IPV4,
 	.nhooks		= NF_INET_NUMHOOKS,
 	.owner		= THIS_MODULE,
@@ -57,7 +57,6 @@ struct nft_af_info nft_af_ipv4 __read_mostly = {
 		[NF_INET_POST_ROUTING]	= nft_do_chain_ipv4,
 	},
 };
-EXPORT_SYMBOL_GPL(nft_af_ipv4);
 
 static int nf_tables_ipv4_init_net(struct net *net)
 {
diff --git a/net/ipv6/netfilter/nf_tables_ipv6.c b/net/ipv6/netfilter/nf_tables_ipv6.c
index d6e4ba5de916..b6699ffbd430 100644
--- a/net/ipv6/netfilter/nf_tables_ipv6.c
+++ b/net/ipv6/netfilter/nf_tables_ipv6.c
@@ -41,7 +41,7 @@ static unsigned int nft_ipv6_output(void *priv,
 	return nft_do_chain_ipv6(priv, skb, state);
 }
 
-struct nft_af_info nft_af_ipv6 __read_mostly = {
+static struct nft_af_info nft_af_ipv6 __read_mostly = {
 	.family		= NFPROTO_IPV6,
 	.nhooks		= NF_INET_NUMHOOKS,
 	.owner		= THIS_MODULE,
@@ -54,7 +54,6 @@ struct nft_af_info nft_af_ipv6 __read_mostly = {
 		[NF_INET_POST_ROUTING]	= nft_do_chain_ipv6,
 	},
 };
-EXPORT_SYMBOL_GPL(nft_af_ipv6);
 
 static int nf_tables_ipv6_init_net(struct net *net)
 {
diff --git a/net/netfilter/nf_tables_inet.c b/net/netfilter/nf_tables_inet.c
index f713cc205669..4ddd055f3aed 100644
--- a/net/netfilter/nf_tables_inet.c
+++ b/net/netfilter/nf_tables_inet.c
@@ -9,6 +9,7 @@
 #include <linux/init.h>
 #include <linux/module.h>
 #include <linux/ip.h>
+#include <linux/ipv6.h>
 #include <linux/netfilter_ipv4.h>
 #include <linux/netfilter_ipv6.h>
 #include <net/netfilter/nf_tables.h>
@@ -16,26 +17,67 @@
 #include <net/netfilter/nf_tables_ipv6.h>
 #include <net/ip.h>
 
-static void nft_inet_hook_ops_init(struct nf_hook_ops *ops, unsigned int n)
+static unsigned int nft_do_chain_inet(void *priv, struct sk_buff *skb,
+				      const struct nf_hook_state *state)
 {
-	struct nft_af_info *afi;
-
-	if (n == 1)
-		afi = &nft_af_ipv4;
-	else
-		afi = &nft_af_ipv6;
+	struct nft_pktinfo pkt;
+
+	switch (state->pf) {
+	case NFPROTO_IPV4:
+		nft_set_pktinfo_ipv4(&pkt, skb, state);
+		break;
+	case NFPROTO_IPV6:
+		nft_set_pktinfo_ipv6(&pkt, skb, state);
+		break;
+	default:
+		break;
+	}
+
+	return nft_do_chain(&pkt, priv);
+}
 
-	ops->pf = afi->family;
-	if (afi->hooks[ops->hooknum])
-		ops->hook = afi->hooks[ops->hooknum];
+static unsigned int nft_inet_output(void *priv, struct sk_buff *skb,
+				    const struct nf_hook_state *state)
+{
+	struct nft_pktinfo pkt;
+
+	switch (state->pf) {
+	case NFPROTO_IPV4:
+		if (unlikely(skb->len < sizeof(struct iphdr) ||
+			     ip_hdr(skb)->ihl < sizeof(struct iphdr) / 4)) {
+			if (net_ratelimit())
+				pr_info("ignoring short SOCK_RAW packet\n");
+			return NF_ACCEPT;
+		}
+		nft_set_pktinfo_ipv4(&pkt, skb, state);
+		break;
+	case NFPROTO_IPV6:
+	        if (unlikely(skb->len < sizeof(struct ipv6hdr))) {
+			if (net_ratelimit())
+				pr_info("ignoring short SOCK_RAW packet\n");
+			return NF_ACCEPT;
+		}
+		nft_set_pktinfo_ipv6(&pkt, skb, state);
+		break;
+	default:
+		break;
+	}
+
+	return nft_do_chain(&pkt, priv);
 }
 
 static struct nft_af_info nft_af_inet __read_mostly = {
 	.family		= NFPROTO_INET,
 	.nhooks		= NF_INET_NUMHOOKS,
 	.owner		= THIS_MODULE,
-	.nops		= 2,
-	.hook_ops_init	= nft_inet_hook_ops_init,
+	.nops		= 1,
+	.hooks		= {
+		[NF_INET_LOCAL_IN]	= nft_do_chain_inet,
+		[NF_INET_LOCAL_OUT]	= nft_inet_output,
+		[NF_INET_FORWARD]	= nft_do_chain_inet,
+		[NF_INET_PRE_ROUTING]	= nft_do_chain_inet,
+		[NF_INET_POST_ROUTING]	= nft_do_chain_inet,
+        },
 };
 
 static int __net_init nf_tables_inet_init_net(struct net *net)
-- 
2.11.0

