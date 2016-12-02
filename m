From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH v2,nf-next 06/11] netfilter: nf_tables: notify internal updates of stateful objects
Date: Fri,  2 Dec 2016 19:08:36 +0100
Message-ID: <1480702121-1782-7-git-send-email-pablo@netfilter.org>
References: <1480702121-1782-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47716 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752154AbcLBSJ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Dec 2016 13:09:26 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A9A9FD163C
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 19:08:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9A5EEDA388
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 19:08:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 7F2E8DA388
        for <netfilter-devel@vger.kernel.org>; Fri,  2 Dec 2016 19:08:55 +0100 (CET)
In-Reply-To: <1480702121-1782-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Introduce nf_tables_obj_notify() to notify internal state changes in
stateful objects. This is used by the quota object to report depletion
in a follow up patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: No changes.

 include/net/netfilter/nf_tables.h |  4 ++++
 net/netfilter/nf_tables_api.c     | 31 +++++++++++++++++++------------
 2 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 20fb731a69f6..ab2328b94731 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -967,6 +967,10 @@ struct nft_object *nf_tables_obj_lookup(const struct nft_table *table,
 					const struct nlattr *nla, u32 objtype,
 					u8 genmask);
 
+int nft_obj_notify(struct net *net, struct nft_table *table,
+		   struct nft_object *obj, u32 portid, u32 seq,
+		   int event, int family, int report, gfp_t gfp);
+
 /**
  *	struct nft_object_type - stateful object type
  *
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6258a659d422..cf6ece95599b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4274,38 +4274,45 @@ static int nf_tables_delobj(struct net *net, struct sock *nlsk,
 	return nft_delobj(&ctx, obj);
 }
 
-static int nf_tables_obj_notify(const struct nft_ctx *ctx,
-				struct nft_object *obj, int event)
+int nft_obj_notify(struct net *net, struct nft_table *table,
+		   struct nft_object *obj, u32 portid, u32 seq, int event,
+		   int family, int report, gfp_t gfp)
 {
 	struct sk_buff *skb;
 	int err;
 
-	if (!ctx->report &&
-	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
+	if (!report &&
+	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
 		return 0;
 
 	err = -ENOBUFS;
-	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
+	skb = nlmsg_new(NLMSG_GOODSIZE, gfp);
 	if (skb == NULL)
 		goto err;
 
-	err = nf_tables_fill_obj_info(skb, ctx->net, ctx->portid, ctx->seq,
-				      event, 0, ctx->afi->family, ctx->table,
-				      obj, false);
+	err = nf_tables_fill_obj_info(skb, net, portid, seq, event, 0, family,
+				      table, obj, false);
 	if (err < 0) {
 		kfree_skb(skb);
 		goto err;
 	}
 
-	err = nfnetlink_send(skb, ctx->net, ctx->portid, NFNLGRP_NFTABLES,
-			     ctx->report, GFP_KERNEL);
+	err = nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, report, gfp);
 err:
 	if (err < 0) {
-		nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES,
-				  err);
+		nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, err);
 	}
 	return err;
 }
+EXPORT_SYMBOL_GPL(nft_obj_notify);
+
+static int nf_tables_obj_notify(const struct nft_ctx *ctx,
+				struct nft_object *obj, int event)
+{
+	return nft_obj_notify(ctx->net, ctx->table, obj, ctx->portid,
+			      ctx->seq, event, ctx->afi->family, ctx->report,
+			      GFP_KERNEL);
+}
 
 static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
 				   u32 portid, u32 seq)
-- 
2.1.4

