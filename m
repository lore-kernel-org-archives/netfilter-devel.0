Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C9278E732F3
	for <netfilter-devel@archiver.kernel.org>; Thu, 28 Sep 2023 16:52:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbjI1Qwx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 28 Sep 2023 12:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbjI1Qww (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 28 Sep 2023 12:52:52 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 411ED99
        for <netfilter-devel@vger.kernel.org>; Thu, 28 Sep 2023 09:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7p65C5HEHDh8/5Ysc4OS8xzqNUEiobXCkyB0iXI1wJ8=; b=TlaSl/p/rUih3phrzjGKUwsfRn
        WCrTlNOaKJ8mkMtARuImtODZpS+X21R40roA7x9dYyxkBcTJ3Rdsv7tjIJxd/PS9llLaSi95RHhfg
        E1nTa8uz81+haA2T2BtO+22uzf6mSZOzFij6XB0HXbsfYOjObd3PGk32l4jSXS1qNeIrz4c0B5yN2
        7mE5lCYwlqdKdKz1F8nXp+l25gP41oJ+lR/+7b/uUDawMXhJtFyjvEB6lJhc8EHCazHboSXBcnPaQ
        ghvgjoiRd923n3uWF2F7sK2JGc9jvLoUPktOpgiXCmqmpgw1kqoqfdBzoFJLPEX27s6oR3WjgeTbT
        LpYkhyng==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qluFs-0004wN-L6; Thu, 28 Sep 2023 18:52:48 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [nf PATCH v2 5/8] netfilter: nf_tables: Introduce nf_tables_getobj_single
Date:   Thu, 28 Sep 2023 18:52:41 +0200
Message-ID: <20230928165244.7168-6-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230928165244.7168-1-phil@nwl.cc>
References: <20230928165244.7168-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Outsource the reply skb preparation for non-dump getrule requests into a
distinct function. Prep work for object reset locking.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
Changes since v1:
- New patch
---
 net/netfilter/nf_tables_api.c | 66 +++++++++++++++++++++++++++--------
 1 file changed, 51 insertions(+), 15 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 67ee0d09cb844..eee149ea98b41 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7775,19 +7775,65 @@ static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 }
 
 /* called with rcu_read_lock held */
+static struct sk_buff *
+nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
+			const struct nlattr * const nla[], bool reset)
+{
+	struct netlink_ext_ack *extack = info->extack;
+	u8 genmask = nft_genmask_cur(info->net);
+	u8 family = info->nfmsg->nfgen_family;
+	const struct nft_table *table;
+	struct net *net = info->net;
+	struct nft_object *obj;
+	struct sk_buff *skb2;
+	u32 objtype;
+	int err;
+
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
 static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 			    const struct nlattr * const nla[])
 {
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
+	u32 portid = NETLINK_CB(skb).portid;
 	const struct nft_table *table;
 	struct net *net = info->net;
 	struct nft_object *obj;
 	struct sk_buff *skb2;
 	bool reset = false;
 	u32 objtype;
-	int err;
 
 	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
 		struct netlink_dump_control c = {
@@ -7818,10 +7864,6 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 		return PTR_ERR(obj);
 	}
 
-	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
-	if (!skb2)
-		return -ENOMEM;
-
 	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
 		reset = true;
 
@@ -7840,17 +7882,11 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 		kfree(buf);
 	}
 
-	err = nf_tables_fill_obj_info(skb2, net, NETLINK_CB(skb).portid,
-				      info->nlh->nlmsg_seq, NFT_MSG_NEWOBJ, 0,
-				      family, table, obj, reset);
-	if (err < 0)
-		goto err_fill_obj_info;
-
-	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
+	skb2 = nf_tables_getobj_single(portid, info, nla, reset);
+	if (IS_ERR(skb2))
+		return PTR_ERR(skb2);
 
-err_fill_obj_info:
-	kfree_skb(skb2);
-	return err;
+	return nfnetlink_unicast(skb2, net, portid);
 }
 
 static void nft_obj_destroy(const struct nft_ctx *ctx, struct nft_object *obj)
-- 
2.41.0

