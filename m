From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 2/7] netfilter: nf_tables: remove flag field from struct nft_af_info
Date: Tue,  9 Jan 2018 19:07:52 +0100
Message-ID: <20180109180757.6104-3-pablo@netfilter.org>
References: <20180109180757.6104-1-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56232 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934741AbeAISIJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jan 2018 13:08:09 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 68F6411ADC3
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jan 2018 19:08:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5A292DA841
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jan 2018 19:08:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 07C54DA841
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jan 2018 19:08:06 +0100 (CET)
Received: from salvia.here (unknown [31.4.245.124])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id CCB454265A31
        for <netfilter-devel@vger.kernel.org>; Tue,  9 Jan 2018 19:08:05 +0100 (CET)
In-Reply-To: <20180109180757.6104-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Replace it by a direct check for the netdev protocol family.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h | 6 ------
 net/netfilter/nf_tables_api.c     | 2 +-
 net/netfilter/nf_tables_netdev.c  | 1 -
 3 files changed, 1 insertion(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 536aaec96a07..9a85893a5e30 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -964,10 +964,6 @@ struct nft_table {
 	char				*name;
 };
 
-enum nft_af_flags {
-	NFT_AF_NEEDS_DEV	= (1 << 0),
-};
-
 /**
  *	struct nft_af_info - nf_tables address family info
  *
@@ -975,14 +971,12 @@ enum nft_af_flags {
  *	@family: address family
  *	@owner: module owner
  *	@tables: used internally
- *	@flags: family flags
  */
 struct nft_af_info {
 	struct list_head		list;
 	int				family;
 	struct module			*owner;
 	struct list_head		tables;
-	u32				flags;
 };
 
 int nft_register_afinfo(struct net *, struct nft_af_info *);
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index bfe3e769f1c9..71c4af0bee9b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1350,7 +1350,7 @@ static int nft_chain_parse_hook(struct net *net,
 	hook->type = type;
 
 	hook->dev = NULL;
-	if (afi->flags & NFT_AF_NEEDS_DEV) {
+	if (afi->family == NFPROTO_NETDEV) {
 		char ifname[IFNAMSIZ];
 
 		if (!ha[NFTA_HOOK_DEV]) {
diff --git a/net/netfilter/nf_tables_netdev.c b/net/netfilter/nf_tables_netdev.c
index 3da3dc7de945..c7f671daa7d0 100644
--- a/net/netfilter/nf_tables_netdev.c
+++ b/net/netfilter/nf_tables_netdev.c
@@ -41,7 +41,6 @@ nft_do_chain_netdev(void *priv, struct sk_buff *skb,
 static struct nft_af_info nft_af_netdev __read_mostly = {
 	.family		= NFPROTO_NETDEV,
 	.owner		= THIS_MODULE,
-	.flags		= NFT_AF_NEEDS_DEV,
 };
 
 static int nf_tables_netdev_init_net(struct net *net)
-- 
2.11.0


