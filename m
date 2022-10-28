Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BE89C38A02
	for <netfilter-devel@archiver.kernel.org>; Fri, 28 Oct 2022 10:06:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbiJ1KGD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 28 Oct 2022 06:06:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJ1KGC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 28 Oct 2022 06:06:02 -0400
Received: from mx1.riseup.net (mx1.riseup.net [198.252.153.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6182C97CE
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2022 03:06:00 -0700 (PDT)
Received: from fews2.riseup.net (fews2-pn.riseup.net [10.0.1.84])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4MzJ8m4DpNzDrgB
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Oct 2022 10:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1666951560; bh=B+IW5b8dVSPJAs7atCpEkVkg1fYFRylvPbGYXYIY25I=;
        h=From:To:Cc:Subject:Date:From;
        b=SZDOX4SeBhV9w3HLUHqFzmbTzE/J4+0J/VYGXeJ+CyQpJcGp7+Yc9NJij67gLzZzT
         iq/trjbI6YHQqthV3BkAGgdXvCno5skEZrzS0tzBCkdbYEpQHom3X0YGTusruh66vp
         Hj6LGVcRrxsJrlZpoDOROUk4T/KSrneMW9aTqiII=
X-Riseup-User-ID: 63A26A88F8F70A70BA8D326F8285509BAA9CAF604C7AC240105D34E86778AACF
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews2.riseup.net (Postfix) with ESMTPSA id 4MzJ8l5Nzhz214Q;
        Fri, 28 Oct 2022 10:05:59 +0000 (UTC)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH nf-next v2] netfilter: nf_tables: add support to destroy operation
Date:   Fri, 28 Oct 2022 12:05:31 +0200
Message-Id: <20221028100531.58666-1-ffmancera@riseup.net>
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
---
 include/uapi/linux/netfilter/nf_tables.h | 14 ++++++
 net/netfilter/nf_tables_api.c            | 63 ++++++++++++++++++++++++
 2 files changed, 77 insertions(+)

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
index 12fc9cda4a2c..9e731b895f0c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1373,6 +1373,9 @@ static int nf_tables_deltable(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	if (IS_ERR(table)) {
+		if (PTR_ERR(table) == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYTABLE)
+			return 0;
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(table);
 	}
@@ -2603,6 +2606,9 @@ static int nf_tables_delchain(struct sk_buff *skb, const struct nfnl_info *info,
 		chain = nft_chain_lookup(net, table, attr, genmask);
 	}
 	if (IS_ERR(chain)) {
+		if (PTR_ERR(chain) == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYCHAIN)
+			return 0;
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(chain);
 	}
@@ -3636,6 +3642,9 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 		if (nla[NFTA_RULE_HANDLE]) {
 			rule = nft_rule_lookup(chain, nla[NFTA_RULE_HANDLE]);
 			if (IS_ERR(rule)) {
+				if (PTR_ERR(rule) == -ENOENT &&
+				    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYRULE)
+					return 0;
 				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_HANDLE]);
 				return PTR_ERR(rule);
 			}
@@ -3644,6 +3653,9 @@ static int nf_tables_delrule(struct sk_buff *skb, const struct nfnl_info *info,
 		} else if (nla[NFTA_RULE_ID]) {
 			rule = nft_rule_lookup_byid(net, nla[NFTA_RULE_ID]);
 			if (IS_ERR(rule)) {
+				if (PTR_ERR(rule) == -ENOENT &&
+				    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYRULE)
+					return 0;
 				NL_SET_BAD_ATTR(extack, nla[NFTA_RULE_ID]);
 				return PTR_ERR(rule);
 			}
@@ -6396,6 +6408,9 @@ static int nf_tables_delsetelem(struct sk_buff *skb,
 
 	nla_for_each_nested(attr, nla[NFTA_SET_ELEM_LIST_ELEMENTS], rem) {
 		err = nft_del_setelem(&ctx, set, attr);
+		if (err == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYSETELEM)
+			err = 0;
 		if (err < 0)
 			break;
 	}
@@ -7038,6 +7053,9 @@ static int nf_tables_delobj(struct sk_buff *skb, const struct nfnl_info *info,
 	}
 
 	if (IS_ERR(obj)) {
+		if (PTR_ERR(obj) == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYOBJ)
+			return 0;
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(obj);
 	}
@@ -7656,6 +7674,9 @@ static int nf_tables_delflowtable(struct sk_buff *skb,
 	}
 
 	if (IS_ERR(flowtable)) {
+		if (PTR_ERR(flowtable) == -ENOENT &&
+		    NFNL_MSG_TYPE(info->nlh->nlmsg_type) == NFT_MSG_DESTROYFLOWTABLE)
+			return 0;
 		NL_SET_BAD_ATTR(extack, attr);
 		return PTR_ERR(flowtable);
 	}
@@ -8065,6 +8086,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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
@@ -8083,6 +8110,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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
@@ -8101,6 +8134,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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
@@ -8119,6 +8158,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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
@@ -8137,6 +8182,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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
@@ -8159,6 +8210,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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
@@ -8183,6 +8240,12 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
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

