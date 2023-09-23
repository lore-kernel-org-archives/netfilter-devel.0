Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5AB88CE7A8C
	for <netfilter-devel@archiver.kernel.org>; Sat, 23 Sep 2023 01:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbjIWBiX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Sep 2023 21:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjIWBiW (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Sep 2023 21:38:22 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63DF419B
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Sep 2023 18:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Ut+80AIHGsWdkEEk3i/qTRSkDweCHfSrD0FuvMsyXo4=; b=TP/cKuldxujNtRuBIF9z5FxJXo
        RGrxJI+iO/RR4MtLtTZM11Qe5fLdTfj1WFvpZeWtXO91H52UI1U6OMOzheuKkIaMEZKk2cOqfeYer
        E2EAcja2GmEJmh9Q49v5G+JyS10LEHsBLLJC7Zj1t2e530F7hUPB1YiFahx5r+hdvx8uyVdRXBq6s
        RzQXRTZKGIuo2xgkUaKVR4lFDKTO7VEsi7upHggS3KktP7zM1VpVyod3cFSQ43eBuZWVYjPZvKuOM
        V87Snm3NgJDtkGcVptklY1vVQniMUmqJg9S/L7OJZVu/Khnb+i3hd1yhdBmpPEPFKwHr3de5Lay9l
        J0svhhow==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qjrb2-0001wI-P7; Sat, 23 Sep 2023 03:38:12 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: [nf PATCH 4/5] netfilter: nf_tables: Add locking for NFT_MSG_GETOBJ_RESET requests
Date:   Sat, 23 Sep 2023 03:38:06 +0200
Message-ID: <20230923013807.11398-5-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230923013807.11398-1-phil@nwl.cc>
References: <20230923013807.11398-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Analogous to the same change for NFT_MSG_GETRULE_RESET.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 147 +++++++++++++++++++++++++---------
 1 file changed, 109 insertions(+), 38 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index f6d8edcf0b9d5..8812d5282ca8f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7735,6 +7735,19 @@ static int nf_tables_dump_obj(struct sk_buff *skb, struct netlink_callback *cb)
 	return skb->len;
 }
 
+static int nf_tables_dumpreset_obj(struct sk_buff *skb,
+				   struct netlink_callback *cb)
+{
+	struct nftables_pernet *nft_net = nft_pernet(sock_net(skb->sk));
+	int ret;
+
+	spin_lock(&nft_net->reset_lock);
+	ret = nf_tables_dump_obj(skb, cb);
+	spin_unlock(&nft_net->reset_lock);
+
+	return ret;
+}
+
 static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 {
 	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
@@ -7751,12 +7764,18 @@ static int nf_tables_dump_obj_start(struct netlink_callback *cb)
 	if (nla[NFTA_OBJ_TYPE])
 		ctx->type = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 
-	if (NFNL_MSG_TYPE(cb->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
-		ctx->reset = true;
-
 	return 0;
 }
 
+static int nf_tables_dumpreset_obj_start(struct netlink_callback *cb)
+{
+	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
+
+	ctx->reset = true;
+
+	return nf_tables_dump_obj_start(cb);
+}
+
 static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 {
 	struct nft_obj_dump_ctx *ctx = (void *)cb->ctx;
@@ -7767,8 +7786,9 @@ static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 }
 
 /* called with rcu_read_lock held */
-static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
-			    const struct nlattr * const nla[])
+static struct sk_buff *
+nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
+			const struct nlattr * const nla[], bool reset)
 {
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
@@ -7777,10 +7797,47 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 	struct net *net = info->net;
 	struct nft_object *obj;
 	struct sk_buff *skb2;
-	bool reset = false;
 	u32 objtype;
 	int err;
 
+	if (!nla[NFTA_OBJ_NAME] ||
+	    !nla[NFTA_OBJ_TYPE])
+		return ERR_PTR(-EINVAL);
+
+	table = nft_table_lookup(net, nla[NFTA_OBJ_TABLE], family, genmask, 0);
+	if (IS_ERR(table)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_OBJ_TABLE]);
+		return ERR_CAST(table);
+	}
+
+	objtype = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
+	obj = nft_obj_lookup(net, table, nla[NFTA_OBJ_NAME], objtype, genmask);
+	if (IS_ERR(obj)) {
+		NL_SET_BAD_ATTR(extack, nla[NFTA_OBJ_NAME]);
+		return ERR_CAST(obj);
+	}
+
+	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
+	if (!skb2)
+		return ERR_PTR(-ENOMEM);
+
+	err = nf_tables_fill_obj_info(skb2, net, portid,
+				      info->nlh->nlmsg_seq, NFT_MSG_NEWOBJ, 0,
+				      family, table, obj, reset);
+	if (err < 0) {
+		kfree_skb(skb2);
+		return ERR_PTR(err);
+	}
+
+	return skb2;
+}
+
+static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
+			    const struct nlattr * const nla[])
+{
+	u32 portid = NETLINK_CB(skb).portid;
+	struct sk_buff *skb2;
+
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
 			.start = nf_tables_dump_obj_start,
@@ -7793,6 +7850,41 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
 	}
 
+	skb2 = nf_tables_getobj_single(portid, info, nla, false);
+	if (IS_ERR(skb2))
+		return PTR_ERR(skb2);
+
+	return nfnetlink_unicast(skb2, info->net, portid);
+}
+
+static int nf_tables_getobj_reset(struct sk_buff *skb,
+				  const struct nfnl_info *info,
+				  const struct nlattr * const nla[])
+{
+	const struct nftables_pernet *nft_net = nft_pernet(info->net);
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_cur(info->net);
+	u8 family = info->nfmsg->nfgen_family;
+	u32 portid = NETLINK_CB(skb).portid;
+	const struct nft_table *table;
+	struct net *net = info->net;
+	struct nft_object *obj;
+	struct sk_buff *skb2;
+	u32 objtype;
+	char *buf;
+
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.start = nf_tables_dumpreset_obj_start,
+			.dump = nf_tables_dumpreset_obj,
+			.done = nf_tables_dump_obj_done,
+			.module = THIS_MODULE,
+			.data = (void *)nla,
+		};
+
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
+
 	if (!nla[NFTA_OBJ_NAME] ||
 	    !nla[NFTA_OBJ_TYPE])
 		return -EINVAL;
@@ -7810,39 +7902,18 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 		return PTR_ERR(obj);
 	}
 
-	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
-	if (!skb2)
-		return -ENOMEM;
-
-	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
-		reset = true;
-
-	if (reset) {
-		const struct nftables_pernet *nft_net;
-		char *buf;
-
-		nft_net = nft_pernet(net);
-		buf = kasprintf(GFP_ATOMIC, "%s:%u", table->name, nft_net->base_seq);
-
-		audit_log_nfcfg(buf,
-				family,
-				obj->handle,
-				AUDIT_NFT_OP_OBJ_RESET,
-				GFP_ATOMIC);
-		kfree(buf);
-	}
-
-	err = nf_tables_fill_obj_info(skb2, net, NETLINK_CB(skb).portid,
-				      info->nlh->nlmsg_seq, NFT_MSG_NEWOBJ, 0,
-				      family, table, obj, reset);
-	if (err < 0)
-		goto err_fill_obj_info;
+	spin_lock(&nft_net->reset_lock);
+	skb2 = nf_tables_getobj_single(portid, info, nla, true);
+	spin_unlock(&nft_net->reset_lock);
+	if (IS_ERR(skb2))
+		return PTR_ERR(skb2);
 
-	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
+	buf = kasprintf(GFP_ATOMIC, "%s:%u", table->name, nft_net->base_seq);
+	audit_log_nfcfg(buf, family, obj->handle,
+			AUDIT_NFT_OP_OBJ_RESET, GFP_ATOMIC);
+	kfree(buf);
 
-err_fill_obj_info:
-	kfree_skb(skb2);
-	return err;
+	return nfnetlink_unicast(skb2, net, portid);
 }
 
 static void nft_obj_destroy(const struct nft_ctx *ctx, struct nft_object *obj)
@@ -9103,7 +9174,7 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.policy		= nft_obj_policy,
 	},
 	[NFT_MSG_GETOBJ_RESET] = {
-		.call		= nf_tables_getobj,
+		.call		= nf_tables_getobj_reset,
 		.type		= NFNL_CB_RCU,
 		.attr_count	= NFTA_OBJ_MAX,
 		.policy		= nft_obj_policy,
-- 
2.41.0

