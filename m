From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 09/13] netfilter: nf_tables: perform flags validation before table allocation
Date: Thu,  9 Jan 2014 18:42:39 +0000
Message-ID: <1389292963-4089-10-git-send-email-kaber@trash.net>
References: <1389292963-4089-1-git-send-email-kaber@trash.net>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51691 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaAISnX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 13:43:23 -0500
In-Reply-To: <1389292963-4089-1-git-send-email-kaber@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Simplifies error handling. Additionally use the correct type u32 for the
host byte order flags value.

Signed-off-by: Patrick McHardy <kaber@trash.net>
---
 net/netfilter/nf_tables_api.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index c8ca3b8..88f9c94 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -366,7 +366,7 @@ static int nf_tables_updtable(struct sock *nlsk, struct sk_buff *skb,
 	int family = nfmsg->nfgen_family, ret = 0;
 
 	if (nla[NFTA_TABLE_FLAGS]) {
-		__be32 flags;
+		u32 flags;
 
 		flags = ntohl(nla_get_be32(nla[NFTA_TABLE_FLAGS]));
 		if (flags & ~NFT_TABLE_F_DORMANT)
@@ -402,6 +402,7 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 	struct nft_table *table;
 	struct net *net = sock_net(skb->sk);
 	int family = nfmsg->nfgen_family;
+	u32 flags = 0;
 
 	afi = nf_tables_afinfo_lookup(net, family, true);
 	if (IS_ERR(afi))
@@ -423,6 +424,12 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 		return nf_tables_updtable(nlsk, skb, nlh, nla, afi, table);
 	}
 
+	if (nla[NFTA_TABLE_FLAGS]) {
+		flags = ntohl(nla_get_be32(nla[NFTA_TABLE_FLAGS]));
+		if (flags & ~NFT_TABLE_F_DORMANT)
+			return -EINVAL;
+	}
+
 	table = kzalloc(sizeof(*table) + nla_len(name), GFP_KERNEL);
 	if (table == NULL)
 		return -ENOMEM;
@@ -430,18 +437,7 @@ static int nf_tables_newtable(struct sock *nlsk, struct sk_buff *skb,
 	nla_strlcpy(table->name, name, nla_len(name));
 	INIT_LIST_HEAD(&table->chains);
 	INIT_LIST_HEAD(&table->sets);
-
-	if (nla[NFTA_TABLE_FLAGS]) {
-		__be32 flags;
-
-		flags = ntohl(nla_get_be32(nla[NFTA_TABLE_FLAGS]));
-		if (flags & ~NFT_TABLE_F_DORMANT) {
-			kfree(table);
-			return -EINVAL;
-		}
-
-		table->flags |= flags;
-	}
+	table->flags = flags;
 
 	list_add_tail(&table->list, &afi->tables);
 	nf_tables_table_notify(skb, nlh, table, NFT_MSG_NEWTABLE, family);
-- 
1.8.4.2

