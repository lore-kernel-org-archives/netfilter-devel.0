Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C72D7C43141
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 13:19:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A88AE22519
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 13:19:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730133AbfKTNTE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 08:19:04 -0500
Received: from correo.us.es ([193.147.175.20]:49288 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbfKTNTE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 08:19:04 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E8C0D130E39
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D9313B7FF2
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:59 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CF045B7FFE; Wed, 20 Nov 2019 14:18:59 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D2C03B7FF2
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:57 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 Nov 2019 14:18:57 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id B843342EE38F
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:57 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 3/7] netfilter: nft_objref: add nft_obj_ref structure and use it
Date:   Wed, 20 Nov 2019 14:18:50 +0100
Message-Id: <20191120131854.308740-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191120131854.308740-1-pablo@netfilter.org>
References: <20191120131854.308740-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This allows to extend this private expression area with new fields.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  4 ++++
 net/netfilter/nft_objref.c        | 22 ++++++++++++----------
 2 files changed, 16 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 87b758407868..04c3b2e7eb99 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1122,6 +1122,10 @@ struct nft_object_type {
 	const struct nla_policy		*policy;
 };
 
+struct nft_object_ref {
+	struct nft_object		*obj;
+};
+
 /**
  *	struct nft_object_ops - stateful object operations
  *
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 006c2ebd898a..c9d8543fc97c 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -11,23 +11,22 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
 
-#define nft_objref_priv(expr)	*((struct nft_object **)nft_expr_priv(expr))
-
 static void nft_objref_eval(const struct nft_expr *expr,
 			    struct nft_regs *regs,
 			    const struct nft_pktinfo *pkt)
 {
-	struct nft_object *obj = nft_objref_priv(expr);
+	struct nft_object_ref *priv = nft_expr_priv(expr);
 
-	obj->ops->eval(obj, regs, pkt);
+	priv->obj->ops->eval(priv->obj, regs, pkt);
 }
 
 static int nft_objref_init(const struct nft_ctx *ctx,
 			   const struct nft_expr *expr,
 			   const struct nlattr * const tb[])
 {
-	struct nft_object *obj = nft_objref_priv(expr);
+	struct nft_object_ref *priv = nft_expr_priv(expr);
 	u8 genmask = nft_genmask_next(ctx->net);
+	struct nft_object *obj;
 	u32 objtype;
 
 	if (!tb[NFTA_OBJREF_IMM_NAME] ||
@@ -41,15 +40,16 @@ static int nft_objref_init(const struct nft_ctx *ctx,
 	if (IS_ERR(obj))
 		return -ENOENT;
 
-	nft_objref_priv(expr) = obj;
 	obj->use++;
+	priv->obj = obj;
 
 	return 0;
 }
 
 static int nft_objref_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
-	const struct nft_object *obj = nft_objref_priv(expr);
+	const struct nft_object_ref *priv = nft_expr_priv(expr);
+	const struct nft_object *obj = priv->obj;
 
 	if (nla_put_string(skb, NFTA_OBJREF_IMM_NAME, obj->key.name) ||
 	    nla_put_be32(skb, NFTA_OBJREF_TYPE,
@@ -66,7 +66,8 @@ static void nft_objref_deactivate(const struct nft_ctx *ctx,
 				  const struct nft_expr *expr,
 				  enum nft_trans_phase phase)
 {
-	struct nft_object *obj = nft_objref_priv(expr);
+	struct nft_object_ref *priv = nft_expr_priv(expr);
+	struct nft_object *obj = priv->obj;
 
 	if (phase == NFT_TRANS_COMMIT)
 		return;
@@ -77,7 +78,8 @@ static void nft_objref_deactivate(const struct nft_ctx *ctx,
 static void nft_objref_activate(const struct nft_ctx *ctx,
 				const struct nft_expr *expr)
 {
-	struct nft_object *obj = nft_objref_priv(expr);
+	struct nft_object_ref *priv = nft_expr_priv(expr);
+	struct nft_object *obj = priv->obj;
 
 	obj->use++;
 }
@@ -85,7 +87,7 @@ static void nft_objref_activate(const struct nft_ctx *ctx,
 static struct nft_expr_type nft_objref_type;
 static const struct nft_expr_ops nft_objref_ops = {
 	.type		= &nft_objref_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_object *)),
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_object_ref)),
 	.eval		= nft_objref_eval,
 	.init		= nft_objref_init,
 	.activate	= nft_objref_activate,
-- 
2.11.0

