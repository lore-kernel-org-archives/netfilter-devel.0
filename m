From: pablo@netfilter.org
Subject: [PATCH 3/7] netfilter: nf_tables: remove hook definitions from struct nft_af_info
Date: Thu, 10 Jan 2013 16:28:37 +0100
Message-ID: <1357831721-10182-3-git-send-email-pablo@netfilter.org>
References: <1357831721-10182-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37148 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753952Ab3AJP27 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 10:28:59 -0500
In-Reply-To: <1357831721-10182-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

They are now included in the filter chain definition.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h   |    2 --
 net/ipv4/netfilter/nf_tables_ipv4.c |    5 +----
 net/ipv6/netfilter/nf_tables_ipv6.c |    5 +----
 net/netfilter/nf_tables_api.c       |    2 --
 4 files changed, 2 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5d9d43f..0dc7d80 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -430,7 +430,6 @@ struct nft_table {
  *	@nhooks: number of hooks in this family
  *	@owner: module owner
  *	@tables: used internally
- *	@hooks: hookfn overrides for packet validation
  */
 struct nft_af_info {
 	struct list_head		list;
@@ -438,7 +437,6 @@ struct nft_af_info {
 	unsigned int			nhooks;
 	struct module			*owner;
 	struct list_head		tables;
-	nf_hookfn			*hooks[NF_MAX_HOOKS];
 };
 
 extern int nft_register_afinfo(struct net *, struct nft_af_info *);
diff --git a/net/ipv4/netfilter/nf_tables_ipv4.c b/net/ipv4/netfilter/nf_tables_ipv4.c
index a0ee4c2..29e09e9 100644
--- a/net/ipv4/netfilter/nf_tables_ipv4.c
+++ b/net/ipv4/netfilter/nf_tables_ipv4.c
@@ -38,9 +38,6 @@ static struct nft_af_info nft_af_ipv4 __read_mostly = {
 	.family		= NFPROTO_IPV4,
 	.nhooks		= NF_INET_NUMHOOKS,
 	.owner		= THIS_MODULE,
-	.hooks		= {
-		[NF_INET_LOCAL_OUT]	= nft_ipv4_output,
-	},
 };
 
 static int nf_tables_ipv4_init_net(struct net *net)
@@ -82,7 +79,7 @@ static struct nf_chain_type filter_ipv4 = {
 			  (1 << NF_INET_POST_ROUTING),
 	.fn		= {
 		[NF_INET_LOCAL_IN]	= nft_do_chain,
-		[NF_INET_LOCAL_OUT]	= nft_do_chain,
+		[NF_INET_LOCAL_OUT]	= nft_ipv4_output,
 		[NF_INET_FORWARD]	= nft_do_chain,
 		[NF_INET_PRE_ROUTING]	= nft_do_chain,
 		[NF_INET_POST_ROUTING]	= nft_do_chain,
diff --git a/net/ipv6/netfilter/nf_tables_ipv6.c b/net/ipv6/netfilter/nf_tables_ipv6.c
index e1eee09..84ccd35 100644
--- a/net/ipv6/netfilter/nf_tables_ipv6.c
+++ b/net/ipv6/netfilter/nf_tables_ipv6.c
@@ -35,9 +35,6 @@ static struct nft_af_info nft_af_ipv6 __read_mostly = {
 	.family		= NFPROTO_IPV6,
 	.nhooks		= NF_INET_NUMHOOKS,
 	.owner		= THIS_MODULE,
-	.hooks		= {
-		[NF_INET_LOCAL_OUT]	= nft_ipv6_output,
-	},
 };
 
 static int nf_tables_ipv6_init_net(struct net *net)
@@ -79,7 +76,7 @@ static struct nf_chain_type filter_ipv6 = {
 			  (1 << NF_INET_POST_ROUTING),
 	.fn		= {
 		[NF_INET_LOCAL_IN]	= nft_do_chain,
-		[NF_INET_LOCAL_OUT]	= nft_do_chain,
+		[NF_INET_LOCAL_OUT]	= nft_ipv6_output,
 		[NF_INET_FORWARD]	= nft_do_chain,
 		[NF_INET_PRE_ROUTING]	= nft_do_chain,
 		[NF_INET_POST_ROUTING]	= nft_do_chain,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a8ae0b4..697b853 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -842,8 +842,6 @@ static int nf_tables_newchain(struct sock *nlsk, struct sk_buff *skb,
 		ops->priority	= ntohl(nla_get_be32(ha[NFTA_HOOK_PRIORITY]));
 		ops->priv	= chain;
 		ops->hook       = hookfn;
-		if (afi->hooks[ops->hooknum])
-			ops->hook = afi->hooks[ops->hooknum];
 
 		chain->flags |= NFT_BASE_CHAIN;
 
-- 
1.7.10.4

