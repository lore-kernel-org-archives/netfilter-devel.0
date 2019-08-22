Return-Path: <SRS0=orVX=WS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0136AC41514
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 16:48:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B303623404
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Aug 2019 16:48:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="Z3k/810x"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390172AbfHVQsf (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Aug 2019 12:48:35 -0400
Received: from mx1.riseup.net ([198.252.153.129]:50636 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731428AbfHVQsf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Aug 2019 12:48:35 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id A4EBB1B9296
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Aug 2019 09:48:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1566492514; bh=3k9jTzBlgNJ/uysLrBAqw4XkzDXZTNqeAlK1eMdSxpg=;
        h=From:To:Cc:Subject:Date:From;
        b=Z3k/810xE9lJb+uX3+vWR7w71t5fJYnsRd7of8Rc3T8rGRFvPslT7UdQOgynom/pF
         anzcg8ipejs4ohKhswd7ENBOBnIlvPvbtleMbfLuATVEs+u6qNWZ5lvutNnQxcBpq/
         8ITfB3O2xg22yTF5cXtnGzQr3sHGWASvNlZ+QrRU=
X-Riseup-User-ID: 3CA01F157585D1A1042AD955FB339A57CA814894076188344A5C2F5D8B944DDA
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4E34D1209F2;
        Thu, 22 Aug 2019 09:48:33 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 1/2 nf-next v2] netfilter: nf_tables: Introduce stateful object update operation
Date:   Thu, 22 Aug 2019 18:48:26 +0200
Message-Id: <20190822164827.1064-1-ffmancera@riseup.net>
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
 include/net/netfilter/nf_tables.h | 10 ++++
 net/netfilter/nf_tables_api.c     | 90 ++++++++++++++++++++++++++++---
 2 files changed, 93 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index dc301e3d6739..3b6e300b21af 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1123,6 +1123,10 @@ struct nft_object_ops {
 	int				(*dump)(struct sk_buff *skb,
 						struct nft_object *obj,
 						bool reset);
+	int				(*update)(const struct nft_ctx *ctx,
+						  const struct nlattr *const tb[],
+						  struct nft_object *obj,
+						  bool commit);
 	const struct nft_object_type	*type;
 };
 
@@ -1405,10 +1409,16 @@ struct nft_trans_elem {
 
 struct nft_trans_obj {
 	struct nft_object		*obj;
+	struct nlattr			**tb;
+	bool				update;
 };
 
 #define nft_trans_obj(trans)	\
 	(((struct nft_trans_obj *)trans->data)->obj)
+#define nft_trans_obj_tb(trans) \
+	(((struct nft_trans_obj *)trans->data)->tb)
+#define nft_trans_obj_update(trans)	\
+	(((struct nft_trans_obj *)trans->data)->update)
 
 struct nft_trans_flowtable {
 	struct nft_flowtable		*flowtable;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fe3b7b0c6c66..810ef50275dc 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5122,6 +5122,49 @@ nft_obj_type_get(struct net *net, u32 objtype)
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
+	err = obj->ops->update(ctx, (const struct nlattr * const *)tb,
+			       obj, false);
+	if (err < 0)
+		goto err;
+
+	nft_trans_obj(trans) = obj;
+	nft_trans_obj_update(trans) = true;
+	nft_trans_obj_tb(trans) = tb;
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+
+	return 0;
+
+err:
+	nft_trans_destroy(trans);
+	kfree(tb);
+	return err;
+}
+
 static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 			    struct sk_buff *skb, const struct nlmsghdr *nlh,
 			    const struct nlattr * const nla[],
@@ -5161,7 +5204,13 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
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
@@ -6422,6 +6471,20 @@ static void nft_chain_commit_update(struct nft_trans *trans)
 	}
 }
 
+static void nft_obj_commit_update(struct nft_trans *trans)
+{
+	struct nft_object *obj;
+	struct nlattr **tb;
+
+	obj = nft_trans_obj(trans);
+	tb = nft_trans_obj_tb(trans);
+
+	obj->ops->update(&trans->ctx, (const struct nlattr * const *)tb,
+			 obj, true);
+
+	kfree(tb);
+}
+
 static void nft_commit_release(struct nft_trans *trans)
 {
 	switch (trans->msg_type) {
@@ -6786,10 +6849,18 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 			te->set->ndeact--;
 			break;
 		case NFT_MSG_NEWOBJ:
-			nft_clear(net, nft_trans_obj(trans));
-			nf_tables_obj_notify(&trans->ctx, nft_trans_obj(trans),
-					     NFT_MSG_NEWOBJ);
-			nft_trans_destroy(trans);
+			if (nft_trans_obj_update(trans)) {
+				nft_obj_commit_update(trans);
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
@@ -6936,8 +7007,13 @@ static int __nf_tables_abort(struct net *net)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWOBJ:
-			trans->ctx.table->use--;
-			nft_obj_del(nft_trans_obj(trans));
+			if (nft_trans_obj_update(trans)) {
+				kfree(nft_trans_obj_tb(trans));
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

