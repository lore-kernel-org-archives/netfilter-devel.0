From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf 2/2] netfilter: nf_tables: netlink listener hits ESRCH on socket overrun
Date: Wed,  1 Mar 2017 21:53:26 +0100
Message-ID: <1488401606-11151-2-git-send-email-pablo@netfilter.org>
References: <1488401606-11151-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48912 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751055AbdCAVvE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 1 Mar 2017 16:51:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AFB2317710D
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 21:53:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E6A4DA725
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 21:53:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 66EFBDA7E0
        for <netfilter-devel@vger.kernel.org>; Wed,  1 Mar 2017 21:53:35 +0100 (CET)
In-Reply-To: <1488401606-11151-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Netlink listeners are currently hitting ESRCH on socket buffer overruns
via nf_tables, this error is misleading and inconsistent with regards to
other existing netlink subsystems. Netlink semantics mandate that
listeners hit ENOBUFS if the socket buffer overruns.

Reported-by: Alexander Alemayhu <alexander@alemayhu.com>
Tested-by: Alexander Alemayhu <alexander@alemayhu.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |   6 +-
 net/netfilter/nf_tables_api.c     | 128 +++++++++++++++++++-------------------
 2 files changed, 66 insertions(+), 68 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ac84686aaafb..2aa8a9d80fbe 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -988,9 +988,9 @@ struct nft_object *nf_tables_obj_lookup(const struct nft_table *table,
 					const struct nlattr *nla, u32 objtype,
 					u8 genmask);
 
-int nft_obj_notify(struct net *net, struct nft_table *table,
-		   struct nft_object *obj, u32 portid, u32 seq,
-		   int event, int family, int report, gfp_t gfp);
+void nft_obj_notify(struct net *net, struct nft_table *table,
+		    struct nft_object *obj, u32 portid, u32 seq,
+		    int event, int family, int report, gfp_t gfp);
 
 /**
  *	struct nft_object_type - stateful object type
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ff7304ae58ac..dcd59b8518af 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -461,16 +461,15 @@ static int nf_tables_fill_table_info(struct sk_buff *skb, struct net *net,
 	return -1;
 }
 
-static int nf_tables_table_notify(const struct nft_ctx *ctx, int event)
+static void nf_tables_table_notify(const struct nft_ctx *ctx, int event)
 {
 	struct sk_buff *skb;
 	int err;
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
-		return 0;
+		return;
 
-	err = -ENOBUFS;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (skb == NULL)
 		goto err;
@@ -484,12 +483,12 @@ static int nf_tables_table_notify(const struct nft_ctx *ctx, int event)
 
 	err = nfnetlink_send(skb, ctx->net, ctx->portid, NFNLGRP_NFTABLES,
 			     ctx->report, GFP_KERNEL);
+	if (err < 0)
+		goto err;
+
+	return;
 err:
-	if (err < 0) {
-		nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES,
-				  err);
-	}
-	return err;
+	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
 
 static int nf_tables_dump_tables(struct sk_buff *skb,
@@ -1050,16 +1049,15 @@ static int nf_tables_fill_chain_info(struct sk_buff *skb, struct net *net,
 	return -1;
 }
 
-static int nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
+static void nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
 {
 	struct sk_buff *skb;
 	int err;
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
-		return 0;
+		return;
 
-	err = -ENOBUFS;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (skb == NULL)
 		goto err;
@@ -1074,12 +1072,12 @@ static int nf_tables_chain_notify(const struct nft_ctx *ctx, int event)
 
 	err = nfnetlink_send(skb, ctx->net, ctx->portid, NFNLGRP_NFTABLES,
 			     ctx->report, GFP_KERNEL);
+	if (err < 0)
+		goto err;
+
+	return;
 err:
-	if (err < 0) {
-		nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES,
-				  err);
-	}
-	return err;
+	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
 
 static int nf_tables_dump_chains(struct sk_buff *skb,
@@ -1934,18 +1932,16 @@ static int nf_tables_fill_rule_info(struct sk_buff *skb, struct net *net,
 	return -1;
 }
 
-static int nf_tables_rule_notify(const struct nft_ctx *ctx,
-				 const struct nft_rule *rule,
-				 int event)
+static void nf_tables_rule_notify(const struct nft_ctx *ctx,
+				  const struct nft_rule *rule, int event)
 {
 	struct sk_buff *skb;
 	int err;
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
-		return 0;
+		return;
 
-	err = -ENOBUFS;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (skb == NULL)
 		goto err;
@@ -1960,12 +1956,12 @@ static int nf_tables_rule_notify(const struct nft_ctx *ctx,
 
 	err = nfnetlink_send(skb, ctx->net, ctx->portid, NFNLGRP_NFTABLES,
 			     ctx->report, GFP_KERNEL);
+	if (err < 0)
+		goto err;
+
+	return;
 err:
-	if (err < 0) {
-		nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES,
-				  err);
-	}
-	return err;
+	nfnetlink_set_err(ctx->net, ctx->portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
 
 struct nft_rule_dump_ctx {
@@ -2696,9 +2692,9 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	return -1;
 }
 
-static int nf_tables_set_notify(const struct nft_ctx *ctx,
-				const struct nft_set *set,
-				int event, gfp_t gfp_flags)
+static void nf_tables_set_notify(const struct nft_ctx *ctx,
+				 const struct nft_set *set, int event,
+			         gfp_t gfp_flags)
 {
 	struct sk_buff *skb;
 	u32 portid = ctx->portid;
@@ -2706,9 +2702,8 @@ static int nf_tables_set_notify(const struct nft_ctx *ctx,
 
 	if (!ctx->report &&
 	    !nfnetlink_has_listeners(ctx->net, NFNLGRP_NFTABLES))
-		return 0;
+		return;
 
-	err = -ENOBUFS;
 	skb = nlmsg_new(NLMSG_GOODSIZE, gfp_flags);
 	if (skb == NULL)
 		goto err;
@@ -2721,10 +2716,12 @@ static int nf_tables_set_notify(const struct nft_ctx *ctx,
 
 	err = nfnetlink_send(skb, ctx->net, portid, NFNLGRP_NFTABLES,
 			     ctx->report, gfp_flags);
-err:
 	if (err < 0)
-		nfnetlink_set_err(ctx->net, portid, NFNLGRP_NFTABLES, err);
-	return err;
+		goto err;
+
+	return;
+err:
+	nfnetlink_set_err(ctx->net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
 
 static int nf_tables_dump_sets(struct sk_buff *skb, struct netlink_callback *cb)
@@ -3504,10 +3501,10 @@ static int nf_tables_fill_setelem_info(struct sk_buff *skb,
 	return -1;
 }
 
-static int nf_tables_setelem_notify(const struct nft_ctx *ctx,
-				    const struct nft_set *set,
-				    const struct nft_set_elem *elem,
-				    int event, u16 flags)
+static void nf_tables_setelem_notify(const struct nft_ctx *ctx,
+				     const struct nft_set *set,
+				     const struct nft_set_elem *elem,
+				     int event, u16 flags)
 {
 	struct net *net = ctx->net;
 	u32 portid = ctx->portid;
@@ -3515,9 +3512,8 @@ static int nf_tables_setelem_notify(const struct nft_ctx *ctx,
 	int err;
 
 	if (!ctx->report && !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
-		return 0;
+		return;
 
-	err = -ENOBUFS;
 	skb = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (skb == NULL)
 		goto err;
@@ -3531,10 +3527,12 @@ static int nf_tables_setelem_notify(const struct nft_ctx *ctx,
 
 	err = nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, ctx->report,
 			     GFP_KERNEL);
-err:
 	if (err < 0)
-		nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, err);
-	return err;
+		goto err;
+
+	return;
+err:
+	nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
 
 static struct nft_trans *nft_trans_elem_alloc(struct nft_ctx *ctx,
@@ -4476,18 +4474,17 @@ static int nf_tables_delobj(struct net *net, struct sock *nlsk,
 	return nft_delobj(&ctx, obj);
 }
 
-int nft_obj_notify(struct net *net, struct nft_table *table,
-		   struct nft_object *obj, u32 portid, u32 seq, int event,
-		   int family, int report, gfp_t gfp)
+void nft_obj_notify(struct net *net, struct nft_table *table,
+		    struct nft_object *obj, u32 portid, u32 seq, int event,
+		    int family, int report, gfp_t gfp)
 {
 	struct sk_buff *skb;
 	int err;
 
 	if (!report &&
 	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
-		return 0;
+		return;
 
-	err = -ENOBUFS;
 	skb = nlmsg_new(NLMSG_GOODSIZE, gfp);
 	if (skb == NULL)
 		goto err;
@@ -4500,20 +4497,20 @@ int nft_obj_notify(struct net *net, struct nft_table *table,
 	}
 
 	err = nfnetlink_send(skb, net, portid, NFNLGRP_NFTABLES, report, gfp);
+	if (err < 0)
+		goto err;
+
+	return;
 err:
-	if (err < 0) {
-		nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, err);
-	}
-	return err;
+	nfnetlink_set_err(net, portid, NFNLGRP_NFTABLES, -ENOBUFS);
 }
 EXPORT_SYMBOL_GPL(nft_obj_notify);
 
-static int nf_tables_obj_notify(const struct nft_ctx *ctx,
-				struct nft_object *obj, int event)
+static void nf_tables_obj_notify(const struct nft_ctx *ctx,
+				 struct nft_object *obj, int event)
 {
-	return nft_obj_notify(ctx->net, ctx->table, obj, ctx->portid,
-			      ctx->seq, event, ctx->afi->family, ctx->report,
-			      GFP_KERNEL);
+	nft_obj_notify(ctx->net, ctx->table, obj, ctx->portid, ctx->seq, event,
+		       ctx->afi->family, ctx->report, GFP_KERNEL);
 }
 
 static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
@@ -4543,7 +4540,8 @@ static int nf_tables_fill_gen_info(struct sk_buff *skb, struct net *net,
 	return -EMSGSIZE;
 }
 
-static int nf_tables_gen_notify(struct net *net, struct sk_buff *skb, int event)
+static void nf_tables_gen_notify(struct net *net, struct sk_buff *skb,
+				 int event)
 {
 	struct nlmsghdr *nlh = nlmsg_hdr(skb);
 	struct sk_buff *skb2;
@@ -4551,9 +4549,8 @@ static int nf_tables_gen_notify(struct net *net, struct sk_buff *skb, int event)
 
 	if (nlmsg_report(nlh) &&
 	    !nfnetlink_has_listeners(net, NFNLGRP_NFTABLES))
-		return 0;
+		return;
 
-	err = -ENOBUFS;
 	skb2 = nlmsg_new(NLMSG_GOODSIZE, GFP_KERNEL);
 	if (skb2 == NULL)
 		goto err;
@@ -4567,12 +4564,13 @@ static int nf_tables_gen_notify(struct net *net, struct sk_buff *skb, int event)
 
 	err = nfnetlink_send(skb2, net, NETLINK_CB(skb).portid,
 			     NFNLGRP_NFTABLES, nlmsg_report(nlh), GFP_KERNEL);
+	if (err < 0)
+		goto err;
+
+	return;
 err:
-	if (err < 0) {
-		nfnetlink_set_err(net, NETLINK_CB(skb).portid, NFNLGRP_NFTABLES,
-				  err);
-	}
-	return err;
+	nfnetlink_set_err(net, NETLINK_CB(skb).portid, NFNLGRP_NFTABLES,
+			  -ENOBUFS);
 }
 
 static int nf_tables_getgen(struct net *net, struct sock *nlsk,
-- 
2.1.4

