Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4F60C43215
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 13:19:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 96C0822519
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 13:19:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730128AbfKTNTD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 08:19:03 -0500
Received: from correo.us.es ([193.147.175.20]:49278 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbfKTNTD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 08:19:03 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E8284130E36
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D8036DA3A9
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:58 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CC453DA7B6; Wed, 20 Nov 2019 14:18:58 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9584A7BEA
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:56 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 Nov 2019 14:18:56 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id BEF5F42EE38F
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:56 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/7] netfilter: nft_objref: rename NFTA_OBJREF_IMM_TYPE to NFTA_OBJREF_TYPE
Date:   Wed, 20 Nov 2019 14:18:48 +0100
Message-Id: <20191120131854.308740-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191120131854.308740-1-pablo@netfilter.org>
References: <20191120131854.308740-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Prepare this netlink attribute to be used from maps too.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/uapi/linux/netfilter/nf_tables.h |  5 +++--
 net/netfilter/nft_objref.c               | 10 +++++-----
 2 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index bb9b049310df..100261902b1b 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1376,7 +1376,7 @@ enum nft_fwd_attributes {
 /**
  * enum nft_objref_attributes - nf_tables stateful object expression netlink attributes
  *
- * @NFTA_OBJREF_IMM_TYPE: object type for immediate reference (NLA_U32: nft_register)
+ * @NFTA_OBJREF_TYPE: object type for set reference (NLA_U32: nft_register)
  * @NFTA_OBJREF_IMM_NAME: object name for immediate reference (NLA_STRING)
  * @NFTA_OBJREF_SET_SREG: source register of the data to look for (NLA_U32: nft_registers)
  * @NFTA_OBJREF_SET_NAME: name of the set where to look for (NLA_STRING)
@@ -1384,7 +1384,8 @@ enum nft_fwd_attributes {
  */
 enum nft_objref_attributes {
 	NFTA_OBJREF_UNSPEC,
-	NFTA_OBJREF_IMM_TYPE,
+	NFTA_OBJREF_TYPE,
+#define NFTA_OBJREF_IMM_TYPE	NFTA_OBJREF_TYPE
 	NFTA_OBJREF_IMM_NAME,
 	NFTA_OBJREF_SET_SREG,
 	NFTA_OBJREF_SET_NAME,
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index bfd18d2b65a2..984f5b1810be 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -31,10 +31,10 @@ static int nft_objref_init(const struct nft_ctx *ctx,
 	u32 objtype;
 
 	if (!tb[NFTA_OBJREF_IMM_NAME] ||
-	    !tb[NFTA_OBJREF_IMM_TYPE])
+	    !tb[NFTA_OBJREF_TYPE])
 		return -EINVAL;
 
-	objtype = ntohl(nla_get_be32(tb[NFTA_OBJREF_IMM_TYPE]));
+	objtype = ntohl(nla_get_be32(tb[NFTA_OBJREF_TYPE]));
 	obj = nft_obj_lookup(ctx->net, ctx->table,
 			     tb[NFTA_OBJREF_IMM_NAME], objtype,
 			     genmask);
@@ -52,7 +52,7 @@ static int nft_objref_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	const struct nft_object *obj = nft_objref_priv(expr);
 
 	if (nla_put_string(skb, NFTA_OBJREF_IMM_NAME, obj->key.name) ||
-	    nla_put_be32(skb, NFTA_OBJREF_IMM_TYPE,
+	    nla_put_be32(skb, NFTA_OBJREF_TYPE,
 			 htonl(obj->ops->type->type)))
 		goto nla_put_failure;
 
@@ -212,7 +212,7 @@ nft_objref_select_ops(const struct nft_ctx *ctx,
 	     tb[NFTA_OBJREF_SET_ID]))
 		return &nft_objref_map_ops;
 	else if (tb[NFTA_OBJREF_IMM_NAME] &&
-		 tb[NFTA_OBJREF_IMM_TYPE])
+		 tb[NFTA_OBJREF_TYPE])
 		return &nft_objref_ops;
 
 	return ERR_PTR(-EOPNOTSUPP);
@@ -221,7 +221,7 @@ nft_objref_select_ops(const struct nft_ctx *ctx,
 static const struct nla_policy nft_objref_policy[NFTA_OBJREF_MAX + 1] = {
 	[NFTA_OBJREF_IMM_NAME]	= { .type = NLA_STRING,
 				    .len = NFT_OBJ_MAXNAMELEN - 1 },
-	[NFTA_OBJREF_IMM_TYPE]	= { .type = NLA_U32 },
+	[NFTA_OBJREF_TYPE]	= { .type = NLA_U32 },
 	[NFTA_OBJREF_SET_SREG]	= { .type = NLA_U32 },
 	[NFTA_OBJREF_SET_NAME]	= { .type = NLA_STRING,
 				    .len = NFT_SET_MAXNAMELEN - 1 },
-- 
2.11.0

