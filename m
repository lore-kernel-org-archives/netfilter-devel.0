Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71130C25B6B
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 20:08:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjJYUIn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 16:08:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229695AbjJYUIm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 16:08:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87798DC
        for <netfilter-devel@vger.kernel.org>; Wed, 25 Oct 2023 13:08:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=I4VYdAt8FOZgDvTmT5YF85a3O+ZXQd0lUthvC9avaGo=; b=eH3gqlobcJ5vyKpCbywRBQTJX/
        P/eZrLbUGtP7U3BuWeusOY5Ndb9AU1NNNO2ewnmH8mH+Bjroii4/HtvMnMGiicIVfeIqamAkO+aCY
        la9sgqTJSTNizkt40ySlLlHlBQkjJgWcakTFzmXo3ghJ9XPKvQ/2XXet9wLtkHcxz20XIdXjKQFTW
        QntoleDUiNY0eMRzpkYqCMRaRZEWqdRB7SKR9HR64dipKbNHcfpBCqf7BWuQDQZNmzjDBrwQL2u/D
        pp9XkBsiyrERNTovRyuFbmLkg4jwh/52CRJCLwW4x0riVNkPVkxtiXq+6SGjLIB7Q4IEuraPeXQ6J
        pwTueJCQ==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1qvkBB-0003cW-OQ; Wed, 25 Oct 2023 22:08:37 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nf-next PATCH v3 2/3] netfilter: nf_tables: Introduce nf_tables_getobj_single
Date:   Wed, 25 Oct 2023 22:08:27 +0200
Message-ID: <20231025200828.5482-3-phil@nwl.cc>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20231025200828.5482-1-phil@nwl.cc>
References: <20231025200828.5482-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Outsource the reply skb preparation for non-dump getrule requests into a
distinct function. Prep work for object reset locking.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 net/netfilter/nf_tables_api.c | 75 ++++++++++++++++++++---------------
 1 file changed, 44 insertions(+), 31 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d0f7274b7ffe..5f84bdd40c3f 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -7764,10 +7764,10 @@ static int nf_tables_dump_obj_done(struct netlink_callback *cb)
 }
 
 /* called with rcu_read_lock held */
-static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
-			    const struct nlattr * const nla[])
+static struct sk_buff *
+nf_tables_getobj_single(u32 portid, const struct nfnl_info *info,
+			const struct nlattr * const nla[], bool reset)
 {
-	const struct nftables_pernet *nft_net = nft_pernet(info->net);
 	struct netlink_ext_ack *extack = info->extack;
 	u8 genmask = nft_genmask_cur(info->net);
 	u8 family = info->nfmsg->nfgen_family;
@@ -7775,52 +7775,69 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 	struct net *net = info->net;
 	struct nft_object *obj;
 	struct sk_buff *skb2;
-	bool reset = false;
 	u32 objtype;
-	char *buf;
 	int err;
 
-	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
-		struct netlink_dump_control c = {
-			.start = nf_tables_dump_obj_start,
-			.dump = nf_tables_dump_obj,
-			.done = nf_tables_dump_obj_done,
-			.module = THIS_MODULE,
-			.data = (void *)nla,
-		};
-
-		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
-	}
-
 	if (!nla[NFTA_OBJ_NAME] ||
 	    !nla[NFTA_OBJ_TYPE])
-		return -EINVAL;
+		return ERR_PTR(-EINVAL);
 
 	table = nft_table_lookup(net, nla[NFTA_OBJ_TABLE], family, genmask, 0);
 	if (IS_ERR(table)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_OBJ_TABLE]);
-		return PTR_ERR(table);
+		return ERR_CAST(table);
 	}
 
 	objtype = ntohl(nla_get_be32(nla[NFTA_OBJ_TYPE]));
 	obj = nft_obj_lookup(net, table, nla[NFTA_OBJ_NAME], objtype, genmask);
 	if (IS_ERR(obj)) {
 		NL_SET_BAD_ATTR(extack, nla[NFTA_OBJ_NAME]);
-		return PTR_ERR(obj);
+		return ERR_CAST(obj);
 	}
 
 	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_ATOMIC);
 	if (!skb2)
-		return -ENOMEM;
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
+	struct nftables_pernet *nft_net = nft_pernet(info->net);
+	u32 portid = NETLINK_CB(skb).portid;
+	struct net *net = info->net;
+	struct sk_buff *skb2;
+	bool reset = false;
+	char *buf;
+
+	if (info->nlh->nlmsg_flags & NLM_F_DUMP) {
+		struct netlink_dump_control c = {
+			.start = nf_tables_dump_obj_start,
+			.dump = nf_tables_dump_obj,
+			.done = nf_tables_dump_obj_done,
+			.module = THIS_MODULE,
+			.data = (void *)nla,
+		};
+
+		return nft_netlink_dump_start_rcu(info->sk, skb, info->nlh, &c);
+	}
 
 	if (NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_GETOBJ_RESET)
 		reset = true;
 
-	err = nf_tables_fill_obj_info(skb2, net, NETLINK_CB(skb).portid,
-				      info->nlh->nlmsg_seq, NFT_MSG_NEWOBJ, 0,
-				      family, table, obj, reset);
-	if (err < 0)
-		goto err_fill_obj_info;
+	skb2 = nf_tables_getobj_single(portid, info, nla, reset);
+	if (IS_ERR(skb2))
+		return PTR_ERR(skb2);
 
 	if (!reset)
 		return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
@@ -7833,11 +7850,7 @@ static int nf_tables_getobj(struct sk_buff *skb, const struct nfnl_info *info,
 			AUDIT_NFT_OP_OBJ_RESET, GFP_ATOMIC);
 	kfree(buf);
 
-	return nfnetlink_unicast(skb2, net, NETLINK_CB(skb).portid);
-
-err_fill_obj_info:
-	kfree_skb(skb2);
-	return err;
+	return nfnetlink_unicast(skb2, net, portid);
 }
 
 static void nft_obj_destroy(const struct nft_ctx *ctx, struct nft_object *obj)
-- 
2.41.0

