From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v2,nf-next 08/11] netfilter: nft_quota: add depleted flag for objects
Date: Fri,  2 Dec 2016 19:08:38 +0100
Message-ID: <1480702121-1782-9-git-send-email-pablo@netfilter.org>
References: <1480702121-1782-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47718 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750942AbcLBSJ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Dec 2016 13:09:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3E2D7D1637
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 19:08:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2EB0ADA729
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 19:08:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1B180DA729
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 19:08:57 +0100 (CET)
In-Reply-To: <1480702121-1782-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Notify on depleted quota objects. The NFT_QUOTA_F_DEPLETED flag
indicates we have reached overquota.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2:

* Add table pointer to nft_object, so we can reach it when sending
  notifications as discussed with Florian.
* Fix broken depletion notification from nft_quota_obj_eval().

 include/net/netfilter/nf_tables.h        |  2 ++
 include/uapi/linux/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c            |  1 +
 net/netfilter/nft_quota.c                | 35 ++++++++++++++++++++++++++------
 4 files changed, 33 insertions(+), 6 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ab2328b94731..b1ada180c059 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -938,6 +938,7 @@ int nft_verdict_dump(struct sk_buff *skb, int type,
  *	struct nft_object - nf_tables stateful object
  *
  *	@list: table stateful object list node
+ *	@table: table this object belongs to
  *	@type: pointer to object type
  *	@data: pointer to object data
  *	@name: name of this stateful object
@@ -948,6 +949,7 @@ int nft_verdict_dump(struct sk_buff *skb, int type,
 struct nft_object {
 	struct list_head		list;
 	char				name[NFT_OBJ_MAXNAMELEN];
+	struct nft_table		*table;
 	u32				genmask:2,
 					use:30;
 	/* runtime data below here */
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index d4b0b652e76f..2adb67532f3d 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -977,6 +977,7 @@ enum nft_queue_attributes {
 
 enum nft_quota_flags {
 	NFT_QUOTA_F_INV		= (1 << 0),
+	NFT_QUOTA_F_DEPLETED	= (1 << 1),
 };
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index cf6ece95599b..fe508b3c0c2a 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4067,6 +4067,7 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 		err = PTR_ERR(obj);
 		goto err1;
 	}
+	obj->table = table;
 	nla_strlcpy(obj->name, nla[NFTA_OBJ_NAME], NFT_OBJ_MAXNAMELEN);
 
 	err = nft_trans_obj_add(&ctx, NFT_MSG_NEWOBJ, obj);
diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index e98c0c70f40a..829c50cb8e06 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -17,7 +17,7 @@
 
 struct nft_quota {
 	u64		quota;
-	bool		invert;
+	unsigned long	flags;
 	atomic64_t	consumed;
 };
 
@@ -27,11 +27,16 @@ static inline bool nft_overquota(struct nft_quota *priv,
 	return atomic64_add_return(skb->len, &priv->consumed) >= priv->quota;
 }
 
+static inline bool nft_quota_invert(struct nft_quota *priv)
+{
+	return priv->flags & NFT_QUOTA_F_INV;
+}
+
 static inline void nft_quota_do_eval(struct nft_quota *priv,
 				     struct nft_regs *regs,
 				     const struct nft_pktinfo *pkt)
 {
-	if (nft_overquota(priv, pkt->skb) ^ priv->invert)
+	if (nft_overquota(priv, pkt->skb) ^ nft_quota_invert(priv))
 		regs->verdict.code = NFT_BREAK;
 }
 
@@ -45,14 +50,22 @@ static void nft_quota_obj_eval(struct nft_object *obj,
 			       const struct nft_pktinfo *pkt)
 {
 	struct nft_quota *priv = nft_obj_data(obj);
+	bool overquota;
 
-	nft_quota_do_eval(priv, regs, pkt);
+	overquota = nft_overquota(priv, pkt->skb);
+	if (overquota ^ nft_quota_invert(priv))
+		regs->verdict.code = NFT_BREAK;
+
+	if (overquota &&
+	    !test_and_set_bit(NFT_QUOTA_F_DEPLETED, &priv->flags))
+		nft_obj_notify(nft_net(pkt), obj->table, obj, 0, 0,
+			       NFT_MSG_NEWOBJ, nft_pf(pkt), 0, GFP_ATOMIC);
 }
 
 static int nft_quota_do_init(const struct nlattr * const tb[],
 			     struct nft_quota *priv)
 {
-	u32 flags = 0;
+	unsigned long flags = 0;
 	u64 quota;
 
 	if (!tb[NFTA_QUOTA_BYTES])
@@ -66,10 +79,12 @@ static int nft_quota_do_init(const struct nlattr * const tb[],
 		flags = ntohl(nla_get_be32(tb[NFTA_QUOTA_FLAGS]));
 		if (flags & ~NFT_QUOTA_F_INV)
 			return -EINVAL;
+		if (flags & NFT_QUOTA_F_DEPLETED)
+			return -EOPNOTSUPP;
 	}
 
 	priv->quota = quota;
-	priv->invert = (flags & NFT_QUOTA_F_INV) ? true : false;
+	priv->flags = flags;
 	atomic64_set(&priv->consumed, 0);
 
 	return 0;
@@ -86,9 +101,17 @@ static int nft_quota_obj_init(const struct nlattr * const tb[],
 static int nft_quota_do_dump(struct sk_buff *skb, struct nft_quota *priv,
 			     bool reset)
 {
-	u32 flags = priv->invert ? NFT_QUOTA_F_INV : 0;
+	unsigned long flags = priv->flags;
 	u64 consumed;
 
+	if (reset) {
+		consumed = atomic64_xchg(&priv->consumed, 0);
+		if (test_and_clear_bit(NFT_QUOTA_F_DEPLETED, &priv->flags))
+			flags |= NFT_QUOTA_F_DEPLETED;
+	} else {
+		consumed = atomic64_read(&priv->consumed);
+	}
+
 	consumed = atomic64_read(&priv->consumed);
 	/* Since we inconditionally increment the quota for each packet that we
 	 * see, don't puzzle userspace with a number going over the quota.
-- 
2.1.4

