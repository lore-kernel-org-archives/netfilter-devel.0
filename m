From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next RFC 1/8] netfilter: nf_tables: remove nhooks field from struct nft_af_info
Date: Sun, 31 Dec 2017 00:13:41 +0100
Message-ID: <20171230231348.5497-2-pablo@netfilter.org>
References: <20171230231348.5497-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39206 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750982AbdL3XN4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Dec 2017 18:13:56 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B770CC51AE
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A696271D6
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:54 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9738671D6
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:52 +0100 (CET)
Received: from salvia.here (40.red-212-170-55.staticip.rima-tde.net [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 746594265A32
        for <netfilter-devel@vger.kernel.org>; Sun, 31 Dec 2017 00:13:52 +0100 (CET)
In-Reply-To: <20171230231348.5497-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We already validate the hook through bitmask, so this check is
superfluous.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h       | 2 --
 net/bridge/netfilter/nf_tables_bridge.c | 1 -
 net/ipv4/netfilter/nf_tables_arp.c      | 1 -
 net/ipv4/netfilter/nf_tables_ipv4.c     | 1 -
 net/ipv6/netfilter/nf_tables_ipv6.c     | 1 -
 net/netfilter/nf_tables_api.c           | 4 ----
 net/netfilter/nf_tables_inet.c          | 1 -
 net/netfilter/nf_tables_netdev.c        | 1 -
 8 files changed, 12 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 430d27c0035a..9725f8586c61 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -970,7 +970,6 @@ enum nft_af_flags {
  *
  *	@list: used internally
  *	@family: address family
- *	@nhooks: number of hooks in this family
  *	@owner: module owner
  *	@tables: used internally
  *	@flags: family flags
@@ -978,7 +977,6 @@ enum nft_af_flags {
 struct nft_af_info {
 	struct list_head		list;
 	int				family;
-	unsigned int			nhooks;
 	struct module			*owner;
 	struct list_head		tables;
 	u32				flags;
diff --git a/net/bridge/netfilter/nf_tables_bridge.c b/net/bridge/netfilter/nf_tables_bridge.c
index 86774b5c3b73..66c97b1e3303 100644
--- a/net/bridge/netfilter/nf_tables_bridge.c
+++ b/net/bridge/netfilter/nf_tables_bridge.c
@@ -44,7 +44,6 @@ nft_do_chain_bridge(void *priv,
 
 static struct nft_af_info nft_af_bridge __read_mostly = {
 	.family		= NFPROTO_BRIDGE,
-	.nhooks		= NF_BR_NUMHOOKS,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/net/ipv4/netfilter/nf_tables_arp.c b/net/ipv4/netfilter/nf_tables_arp.c
index f84c17763f6f..f9089b2ad905 100644
--- a/net/ipv4/netfilter/nf_tables_arp.c
+++ b/net/ipv4/netfilter/nf_tables_arp.c
@@ -29,7 +29,6 @@ nft_do_chain_arp(void *priv,
 
 static struct nft_af_info nft_af_arp __read_mostly = {
 	.family		= NFPROTO_ARP,
-	.nhooks		= NF_ARP_NUMHOOKS,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/net/ipv4/netfilter/nf_tables_ipv4.c b/net/ipv4/netfilter/nf_tables_ipv4.c
index f4675253f1e6..a98f2de63771 100644
--- a/net/ipv4/netfilter/nf_tables_ipv4.c
+++ b/net/ipv4/netfilter/nf_tables_ipv4.c
@@ -32,7 +32,6 @@ static unsigned int nft_do_chain_ipv4(void *priv,
 
 static struct nft_af_info nft_af_ipv4 __read_mostly = {
 	.family		= NFPROTO_IPV4,
-	.nhooks		= NF_INET_NUMHOOKS,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/net/ipv6/netfilter/nf_tables_ipv6.c b/net/ipv6/netfilter/nf_tables_ipv6.c
index 9cd45b964123..bddd39dc1cf3 100644
--- a/net/ipv6/netfilter/nf_tables_ipv6.c
+++ b/net/ipv6/netfilter/nf_tables_ipv6.c
@@ -30,7 +30,6 @@ static unsigned int nft_do_chain_ipv6(void *priv,
 
 static struct nft_af_info nft_af_ipv6 __read_mostly = {
 	.family		= NFPROTO_IPV6,
-	.nhooks		= NF_INET_NUMHOOKS,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c12a4b63cb2a..0b318f28475f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1283,10 +1283,6 @@ static int nft_chain_parse_hook(struct net *net,
 	    ha[NFTA_HOOK_PRIORITY] == NULL)
 		return -EINVAL;
 
-	hook->num = ntohl(nla_get_be32(ha[NFTA_HOOK_HOOKNUM]));
-	if (hook->num >= afi->nhooks)
-		return -EINVAL;
-
 	hook->priority = ntohl(nla_get_be32(ha[NFTA_HOOK_PRIORITY]));
 
 	type = chain_type[afi->family][NFT_CHAIN_T_DEFAULT];
diff --git a/net/netfilter/nf_tables_inet.c b/net/netfilter/nf_tables_inet.c
index 8d0344f2d677..5128ffd053df 100644
--- a/net/netfilter/nf_tables_inet.c
+++ b/net/netfilter/nf_tables_inet.c
@@ -61,7 +61,6 @@ static unsigned int nft_inet_output(void *priv, struct sk_buff *skb,
 
 static struct nft_af_info nft_af_inet __read_mostly = {
 	.family		= NFPROTO_INET,
-	.nhooks		= NF_INET_NUMHOOKS,
 	.owner		= THIS_MODULE,
 };
 
diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
index 42f6f6d42a6d..3da3dc7de945 100644
--- a/net/netfilter/nf_tables_netdev.c
+++ b/net/netfilter/nf_tables_netdev.c
@@ -40,7 +40,6 @@ nft_do_chain_netdev(void *priv, struct sk_buff *skb,
 
 static struct nft_af_info nft_af_netdev __read_mostly = {
 	.family		= NFPROTO_NETDEV,
-	.nhooks		= NF_NETDEV_NUMHOOKS,
 	.owner		= THIS_MODULE,
 	.flags		= NFT_AF_NEEDS_DEV,
 };
-- 
2.11.0

