Return-Path: <SRS0=UIY/=ZM=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32492C43215
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 13:19:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0EADC22519
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Nov 2019 13:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730135AbfKTNTF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Nov 2019 08:19:05 -0500
Received: from correo.us.es ([193.147.175.20]:49298 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbfKTNTF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Nov 2019 08:19:05 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 99B65130E41
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:19:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8AD29A7D61
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:19:00 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 80578DA3A9; Wed, 20 Nov 2019 14:19:00 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 899AFB7FFB
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:58 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 20 Nov 2019 14:18:58 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 6F53442EE38F
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Nov 2019 14:18:58 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 5/7] netfilter: nft_objref: add support for operation on objects
Date:   Wed, 20 Nov 2019 14:18:52 +0100
Message-Id: <20191120131854.308740-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191120131854.308740-1-pablo@netfilter.org>
References: <20191120131854.308740-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch allows you to specify what kind of operation you want to
perform on an object. Operations are object type specific. All objects
are assumed to have defined at least one operation (type 0).

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |  4 ++++
 include/uapi/linux/netfilter/nf_tables.h |  1 +
 net/netfilter/nf_tables_api.c            |  3 ++-
 net/netfilter/nft_objref.c               | 27 ++++++++++++++++++++++++---
 4 files changed, 31 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 413eb650bafd..7a3f408d4328 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1100,6 +1100,8 @@ void nft_obj_notify(struct net *net, const struct nft_table *table,
 		    struct nft_object *obj, u32 portid, u32 seq,
 		    int event, int family, int report, gfp_t gfp);
 
+const struct nft_object_type *__nft_obj_type_get(u32 objtype);
+
 /**
  *	struct nft_object_type - stateful object type
  *
@@ -1118,12 +1120,14 @@ struct nft_object_type {
 	struct list_head		list;
 	u32				type;
 	unsigned int                    maxattr;
+	u32				maxops;
 	struct module			*owner;
 	const struct nla_policy		*policy;
 };
 
 struct nft_object_ref {
 	struct nft_object		*obj;
+	u8				op;
 };
 
 /**
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 100261902b1b..93326a544184 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1390,6 +1390,7 @@ enum nft_objref_attributes {
 	NFTA_OBJREF_SET_SREG,
 	NFTA_OBJREF_SET_NAME,
 	NFTA_OBJREF_SET_ID,
+	NFTA_OBJREF_OP,
 	__NFTA_OBJREF_MAX
 };
 #define NFTA_OBJREF_MAX	(__NFTA_OBJREF_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ff04cdc87f76..b5051f4dbb26 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5370,7 +5370,7 @@ static int nft_object_dump(struct sk_buff *skb, unsigned int attr,
 	return -1;
 }
 
-static const struct nft_object_type *__nft_obj_type_get(u32 objtype)
+const struct nft_object_type *__nft_obj_type_get(u32 objtype)
 {
 	const struct nft_object_type *type;
 
@@ -5380,6 +5380,7 @@ static const struct nft_object_type *__nft_obj_type_get(u32 objtype)
 	}
 	return NULL;
 }
+EXPORT_SYMBOL_GPL(__nft_obj_type_get);
 
 static const struct nft_object_type *
 nft_obj_type_get(struct net *net, u32 objtype)
diff --git a/net/netfilter/nft_objref.c b/net/netfilter/nft_objref.c
index 21ef987d5ac4..f3b99af031e2 100644
--- a/net/netfilter/nft_objref.c
+++ b/net/netfilter/nft_objref.c
@@ -40,6 +40,12 @@ static int nft_objref_init(const struct nft_ctx *ctx,
 	if (IS_ERR(obj))
 		return -ENOENT;
 
+	if (tb[NFTA_OBJREF_OP]) {
+		priv->op = ntohl(nla_get_be32(tb[NFTA_OBJREF_OP]));
+		if (priv->op > obj->ops->type->maxops)
+			return -EOPNOTSUPP;
+	}
+
 	obj->use++;
 	priv->obj = obj;
 
@@ -52,8 +58,8 @@ static int nft_objref_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	const struct nft_object *obj = priv->obj;
 
 	if (nla_put_string(skb, NFTA_OBJREF_IMM_NAME, obj->key.name) ||
-	    nla_put_be32(skb, NFTA_OBJREF_TYPE,
-			 htonl(obj->ops->type->type)))
+	    nla_put_be32(skb, NFTA_OBJREF_TYPE, htonl(obj->ops->type->type)) ||
+	    nla_put_be32(skb, NFTA_OBJREF_OP, htonl(priv->op)))
 		goto nla_put_failure;
 
 	return 0;
@@ -98,6 +104,7 @@ static const struct nft_expr_ops nft_objref_ops = {
 struct nft_objref_map {
 	struct nft_set		*set;
 	enum nft_registers	sreg:8;
+	u8			op;
 	struct nft_set_binding	binding;
 };
 
@@ -120,6 +127,7 @@ static void nft_objref_map_eval(const struct nft_expr *expr,
 	}
 	obj = *nft_set_ext_obj(ext);
 	ref.obj = obj;
+	ref.op 	= priv->op;
 	obj->ops->eval(&ref, regs, pkt);
 }
 
@@ -160,6 +168,18 @@ static int nft_objref_map_init(const struct nft_ctx *ctx,
 	    set->objtype != objtype)
 		return -EOPNOTSUPP;
 
+	if (tb[NFTA_OBJREF_OP]) {
+		const struct nft_object_type *type;
+
+		if (objtype == NFT_OBJECT_UNSPEC)
+			return -EOPNOTSUPP;
+
+		priv->op = ntohl(nla_get_be32(tb[NFTA_OBJREF_OP]));
+		type = __nft_obj_type_get(objtype);
+		if (!type || priv->op > type->maxops)
+			return -EOPNOTSUPP;
+	}
+
 	priv->set = set;
 	return 0;
 }
@@ -169,7 +189,8 @@ static int nft_objref_map_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	const struct nft_objref_map *priv = nft_expr_priv(expr);
 
 	if (nft_dump_register(skb, NFTA_OBJREF_SET_SREG, priv->sreg) ||
-	    nla_put_string(skb, NFTA_OBJREF_SET_NAME, priv->set->name))
+	    nla_put_string(skb, NFTA_OBJREF_SET_NAME, priv->set->name) ||
+	    nla_put_be32(skb, NFTA_OBJREF_OP, htonl(priv->op)))
 		goto nla_put_failure;
 
 	return 0;
-- 
2.11.0

