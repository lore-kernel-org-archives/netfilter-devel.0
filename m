Return-Path: <SRS0=lxoE=WR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89D8BC3A59E
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 09:44:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5C19522DD3
	for <netfilter-devel@archiver.kernel.org>; Wed, 21 Aug 2019 09:44:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="TIUEKmnG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726389AbfHUJo0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 21 Aug 2019 05:44:26 -0400
Received: from mx1.riseup.net ([198.252.153.129]:57124 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726330AbfHUJoZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Aug 2019 05:44:25 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id DBA691A3ADA
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Aug 2019 02:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1566380664; bh=BrGWKhZxtViZJwh66qxXQw2AHd5KPy3c37cIGpu5mUQ=;
        h=From:To:Cc:Subject:Date:From;
        b=TIUEKmnGIIpV0Nfdcb3SU8k18CI41xyK9MVVo8R1vrpDhGh2iw+BRw0EFxdx8TC/O
         JMVYSiIttneuZIsBDO9Y7bGmTOjxX3FKsQFTTqu+9VgzYiuCi295tOrb51VhNUPGaJ
         e2WnucP3r4u35gWuUkoJ01TIy1InGP4tE5qxz04U=
X-Riseup-User-ID: AA1C74DEDC54CC342764E7415845A0C8F237FB133957577F7E2E436312A1836C
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 1B7E0222AE7;
        Wed, 21 Aug 2019 02:44:23 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 1/2 nf-next] netfilter: nf_tables: Introduce stateful object update operation
Date:   Wed, 21 Aug 2019 11:44:19 +0200
Message-Id: <20190821094420.866-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds the infrastructure needed for the stateful object update
support.

Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
---
 include/net/netfilter/nf_tables.h |  6 +++
 net/netfilter/nf_tables_api.c     | 71 ++++++++++++++++++++++++++++---
 2 files changed, 70 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index dc301e3d6739..dc4e32040ea9 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1123,6 +1123,9 @@ struct nft_object_ops {
 	int				(*dump)(struct sk_buff *skb,
 						struct nft_object *obj,
 						bool reset);
+	int				(*update)(const struct nft_ctx *ctx,
+						  const struct nlattr *const tb[],
+						  struct nft_object *obj);
 	const struct nft_object_type	*type;
 };
 
@@ -1405,10 +1408,13 @@ struct nft_trans_elem {
 
 struct nft_trans_obj {
 	struct nft_object		*obj;
+	bool				update;
 };
 
 #define nft_trans_obj(trans)	\
 	(((struct nft_trans_obj *)trans->data)->obj)
+#define nft_trans_obj_update(trans)	\
+	(((struct nft_trans_obj *)trans->data)->update)
 
 struct nft_trans_flowtable {
 	struct nft_flowtable		*flowtable;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fe3b7b0c6c66..5ab4b0636213 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5122,6 +5122,46 @@ nft_obj_type_get(struct net *net, u32 objtype)
 	return ERR_PTR(-ENOENT);
 }
 
+static int nf_tables_updobj(const struct nft_ctx *ctx,
+			    const struct nft_object_type *type,
+			    const struct nlattr *attr,
+			    struct nft_object *obj)
+{
+	struct nft_trans *trans;
+	struct nlattr **tb;
+	int err = -ENOMEM;
+
+	trans = nft_trans_alloc(ctx, NFT_MSG_NEWOBJ,
+				sizeof(struct nft_trans_obj));
+	if (!trans)
+		return -ENOMEM;
+
+	tb = kcalloc(type->maxattr + 1, sizeof(*tb), GFP_KERNEL);
+	if (!tb)
+		goto err;
+
+	if (attr) {
+		err = nla_parse_nested_deprecated(tb, type->maxattr, attr,
+						  type->policy, NULL);
+		if (err < 0)
+			goto err;	
+	}
+
+	err = obj->ops->update(ctx, (const struct nlattr * const *)tb, obj);
+	if (err < 0)
+		goto err;
+
+	nft_trans_obj_update(trans) = true;
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+
+	kfree(tb);
+	return 0;
+
+err:
+	nft_trans_destroy(trans);
+	return err;
+}
+
 static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 			    struct sk_buff *skb, const struct nlmsghdr *nlh,
 			    const struct nlattr * const nla[],
@@ -5161,7 +5201,13 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 			NL_SET_BAD_ATTR(extack, nla[NFTA_OBJ_NAME]);
 			return -EEXIST;
 		}
-		return 0;
+		if (nlh->nlmsg_flags & NLM_F_REPLACE)
+			return -EOPNOTSUPP;
+
+		type = nft_obj_type_get(net, objtype);
+		nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
+
+		return nf_tables_updobj(&ctx, type, nla[NFTA_OBJ_DATA], obj);
 	}
 
 	nft_ctx_init(&ctx, net, skb, nlh, family, table, NULL, nla);
@@ -6786,10 +6832,17 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			te->set->ndeact--;
 			break;
 		case NFT_MSG_NEWOBJ:
-			nft_clear(net, nft_trans_obj(trans));
-			nf_tables_obj_notify(&trans->ctx, nft_trans_obj(trans),
-					     NFT_MSG_NEWOBJ);
-			nft_trans_destroy(trans);
+			if (nft_trans_obj_update(trans)) {
+				nf_tables_obj_notify(&trans->ctx,
+						     nft_trans_obj(trans),
+						     NFT_MSG_NEWOBJ);
+			} else {
+				nft_clear(net, nft_trans_obj(trans));
+				nf_tables_obj_notify(&trans->ctx,
+						     nft_trans_obj(trans),
+						     NFT_MSG_NEWOBJ);
+				nft_trans_destroy(trans);
+			}
 			break;
 		case NFT_MSG_DELOBJ:
 			nft_obj_del(nft_trans_obj(trans));
@@ -6936,8 +6989,12 @@ static int __nf_tables_abort(struct net *net)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWOBJ:
-			trans->ctx.table->use--;
-			nft_obj_del(nft_trans_obj(trans));
+			if (nft_trans_obj_update(trans)) {
+				nft_trans_destroy(trans);
+			} else {
+				trans->ctx.table->use--;
+				nft_obj_del(nft_trans_obj(trans));
+			}
 			break;
 		case NFT_MSG_DELOBJ:
 			trans->ctx.table->use++;
-- 
2.20.1

