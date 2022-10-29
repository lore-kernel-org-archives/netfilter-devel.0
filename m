Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8448C38A02
	for <netfilter-devel@archiver.kernel.org>; Sat, 29 Oct 2022 09:00:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJ2JAU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 29 Oct 2022 05:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229756AbiJ2JAT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Oct 2022 05:00:19 -0400
Received: from mx0.riseup.net (mx0.riseup.net [198.252.153.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 636CB1F9E8
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Oct 2022 02:00:18 -0700 (PDT)
Received: from fews1.riseup.net (fews1-pn.riseup.net [10.0.1.83])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx0.riseup.net (Postfix) with ESMTPS id 4MztfV0np6z9s70
        for <netfilter-devel@vger.kernel.org>; Sat, 29 Oct 2022 09:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1667034018; bh=WzI9qdXaz5ap9txwS+2tLA5YtN0pPrGn3gos/PXOPDY=;
        h=From:To:Cc:Subject:Date:From;
        b=rYvG6gl2KLYGpbjic3jvmas4IgR3O0BIB7gP43MGIFjBUvr09At0WLFHv8aTtkDsD
         JoAEsjUIp2wqL1qMn6eJukZKgH0FxEGYT1daFmMskTavYRP1R1mHaGGpg2klnNw07a
         51WOkXDqD4o0oLYhWVuKZH2OGXHOGZy7gtlyrlhY=
X-Riseup-User-ID: 6A14B08A553EAFA0126D319B7C5ABDAB51AD320A01963006FC0A6D2C01D7374E
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews1.riseup.net (Postfix) with ESMTPSA id 4MztfS5nDwz5vXJ;
        Sat, 29 Oct 2022 09:00:16 +0000 (UTC)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nf-next v3] netfilter: nf_tables: add support to destroy operation
Date:   Sat, 29 Oct 2022 10:59:40 +0200
Message-Id: <20221029085940.10307-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce NFT_MSG_DESTROY* message type. The destroy operation performs a
delete operation but ignoring the ENOENT errors.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
v1: initial patch
v2: fix bug on rule destroy without handle
v3: adjust some lines length
---
 include/uapi/linux/netfilter/nf_tables.h | 14 +++++
 net/netfilter/nf_tables_api.c            | 73 ++++++++++++++++++++++++
 2 files changed, 87 insertions(+)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 466fd3f4447c..0442335693fe 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -97,6 +97,13 @@ enum nft_verdicts {
  * @NFT_MSG_NEWFLOWTABLE: add new flow table (enum nft_flowtable_attributes)
  * @NFT_MSG_GETFLOWTABLE: get flow table (enum nft_flowtable_attributes)
  * @NFT_MSG_DELFLOWTABLE: delete flow table (enum nft_flowtable_attributes)
+ * @NFT_MSG_DESTROYTABLE: destroy a table (enum nft_table_attributes)
+ * @NFT_MSG_DESTROYCHAIN: destroy a chain (enum nft_chain_attributes)
+ * @NFT_MSG_DESTROYRULE: destroy a rule (enum nft_rule_attributes)
+ * @NFT_MSG_DESTROYSET: destroy a set (enum nft_set_attributes)
+ * @NFT_MSG_DESTROYSETELEM: destroy a set element (enum nft_set_elem_attributes)
+ * @NFT_MSG_DESTROYOBJ: destroy a stateful object (enum nft_object_attributes)
+ * @NFT_MSG_DESTROYFLOWTABLE: destroy flow table (enum nft_flowtable_attributes)
  */
 enum nf_tables_msg_types {
 	NFT_MSG_NEWTABLE,
@@ -124,6 +131,13 @@ enum nf_tables_msg_types {
 	NFT_MSG_NEWFLOWTABLE,
 	NFT_MSG_GETFLOWTABLE,
 	NFT_MSG_DELFLOWTABLE,
+	NFT_MSG_DESTROYTABLE,
+	NFT_MSG_DESTROYCHAIN,
+	NFT_MSG_DESTROYRULE,
+	NFT_MSG_DESTROYSET,
+	NFT_MSG_DESTROYSETELEM,
+	NFT_MSG_DESTROYOBJ,
+	NFT_MSG_DESTROYFLOWTABLE,
 	NFT_MSG_MAX,
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 12fc9cda4a2c..2186eb29d854 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1373,6 +1373,10 @@ static int nf_tables_deltable(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	if (IS_ERR(table)) {
+		if (PTR_ERR(table) == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) ==
+		    NFT_MSG_DESTROYTABLE)
+			return 0;
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(table);
 	}
@@ -2603,6 +2607,10 @@ static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
 		chain = nft_chain_lookup(net, table, attr, genmask);
 	}
 	if (IS_ERR(chain)) {
+		if (PTR_ERR(chain) == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) ==
+		    NFT_MSG_DESTROYCHAIN)
+			return 0;
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(chain);
 	}
@@ -3636,6 +3644,10 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 		if (nla[NFTA_RULE_HANDLE]) {
 			rule = nft_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
 			if (IS_ERR(rule)) {
+				if (PTR_ERR(rule) == -ENOENT &&
+				    NFNL_MSG_TYPE(info->nlh->nlmsg_type) ==
+				    NFT_MSG_DESTROYRULE)
+					return 0;
 				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_HANDLE]);
 				return PTR_ERR(rule);
 			}
@@ -3644,6 +3656,10 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 		} else if (nla[NFTA_RULE_ID]) {
 			rule = nft_rule_lookup_byid(net, nla[NFTA_RULE_ID]);
 			if (IS_ERR(rule)) {
+				if (PTR_ERR(rule) == -ENOENT &&
+				    NFNL_MSG_TYPE(info->nlh->nlmsg_type) ==
+				    NFT_MSG_DESTROYRULE)
+					return 0;
 				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_ID]);
 				return PTR_ERR(rule);
 			}
@@ -4632,6 +4648,10 @@ static int nf_tables_delset(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	if (IS_ERR(set)) {
+		if (PTR_ERR(set) == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) ==
+		    NFT_MSG_DESTROYSET)
+			return 0;
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(set);
 	}
@@ -6396,6 +6416,10 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_del_setelem(&ctx, set, attr);
+		if (err == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) ==
+		    NFT_MSG_DESTROYSETELEM)
+			err = 0;
 		if (err < 0)
 			break;
 	}
@@ -7038,6 +7062,9 @@ static int nf_tables_delobj(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	if (IS_ERR(obj)) {
+		if (PTR_ERR(obj) == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYOBJ)
+			return 0;
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(obj);
 	}
@@ -7656,6 +7683,10 @@ static int nf_tables_delflowtable(struct sk_buff *skb,
 	}
 
 	if (IS_ERR(flowtable)) {
+		if (PTR_ERR(flowtable) == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) ==
+		    NFT_MSG_DESTROYFLOWTABLE)
+			return 0;
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(flowtable);
 	}
@@ -8065,6 +8096,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_TABLE_MAX,
 		.policy		= nft_table_policy,
 	},
+	[NFT_MSG_DESTROYTABLE] = {
+		.call		= nf_tables_deltable,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_TABLE_MAX,
+		.policy		= nft_table_policy,
+	},
 	[NFT_MSG_NEWCHAIN] = {
 		.call		= nf_tables_newchain,
 		.type		= NFNL_CB_BATCH,
@@ -8083,6 +8120,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_CHAIN_MAX,
 		.policy		= nft_chain_policy,
 	},
+	[NFT_MSG_DESTROYCHAIN] = {
+		.call		= nf_tables_delchain,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_CHAIN_MAX,
+		.policy		= nft_chain_policy,
+	},
 	[NFT_MSG_NEWRULE] = {
 		.call		= nf_tables_newrule,
 		.type		= NFNL_CB_BATCH,
@@ -8101,6 +8144,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_RULE_MAX,
 		.policy		= nft_rule_policy,
 	},
+	[NFT_MSG_DESTROYRULE] = {
+		.call		= nf_tables_delrule,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_RULE_MAX,
+		.policy		= nft_rule_policy,
+	},
 	[NFT_MSG_NEWSET] = {
 		.call		= nf_tables_newset,
 		.type		= NFNL_CB_BATCH,
@@ -8119,6 +8168,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_SET_MAX,
 		.policy		= nft_set_policy,
 	},
+	[NFT_MSG_DESTROYSET] = {
+		.call		= nf_tables_delset,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_SET_MAX,
+		.policy		= nft_set_policy,
+	},
 	[NFT_MSG_NEWSETELEM] = {
 		.call		= nf_tables_newsetelem,
 		.type		= NFNL_CB_BATCH,
@@ -8137,6 +8192,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
 		.policy		= nft_set_elem_list_policy,
 	},
+	[NFT_MSG_DESTROYSETELEM] = {
+		.call		= nf_tables_delsetelem,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_SET_ELEM_LIST_MAX,
+		.policy		= nft_set_elem_list_policy,
+	},
 	[NFT_MSG_GETGEN] = {
 		.call		= nf_tables_getgen,
 		.type		= NFNL_CB_RCU,
@@ -8159,6 +8220,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_OBJ_MAX,
 		.policy		= nft_obj_policy,
 	},
+	[NFT_MSG_DESTROYOBJ] = {
+		.call		= nf_tables_delobj,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_OBJ_MAX,
+		.policy		= nft_obj_policy,
+	},
 	[NFT_MSG_GETOBJ_RESET] = {
 		.call		= nf_tables_getobj,
 		.type		= NFNL_CB_RCU,
@@ -8183,6 +8250,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 		.attr_count	= NFTA_FLOWTABLE_MAX,
 		.policy		= nft_flowtable_policy,
 	},
+	[NFT_MSG_DESTROYFLOWTABLE] = {
+		.call		= nf_tables_delflowtable,
+		.type		= NFNL_CB_BATCH,
+		.attr_count	= NFTA_FLOWTABLE_MAX,
+		.policy		= nft_flowtable_policy,
+	},
 };
 
 static int nf_tables_validate(struct net *net)
-- 
2.30.2

