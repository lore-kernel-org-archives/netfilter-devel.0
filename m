Return-Path: <SRS0=4EdP=WW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2B4CC3A59F
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 11:41:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B4CB620874
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Aug 2019 11:41:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="aZAtQD3r"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729569AbfHZLlC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Aug 2019 07:41:02 -0400
Received: from mx1.riseup.net ([198.252.153.129]:52942 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726497AbfHZLlC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Aug 2019 07:41:02 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 185CB1A1201
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Aug 2019 04:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1566819661; bh=y8+HDR33p5OvtQRyLiCwGZM+FTegEwjvjEd7Rl+MNk0=;
        h=From:To:Cc:Subject:Date:From;
        b=aZAtQD3rklWWTvaaJ2AO3mHIZUGZi3fF+xlpl45VrszZw/1/nhcQKhSl9qxC+U6G6
         DY6GjJ7/1fvjMilBvShSAw09P9jstGJYJ6X9PPoAV37SGBBiFuXVyWbB83d9GSBLOz
         HJRIHSSEvSh4Sd5tRrKzG7dGTlyFshJ/QdVqeBEg=
X-Riseup-User-ID: DC9EC260A4E29ED74E3175A0951D6AA6B7BB42CE637BE1FE4EE62B355C9EB142
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 52C0922224B;
        Mon, 26 Aug 2019 04:41:00 -0700 (PDT)
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
To:     netfilter-devel@vger.kernel.org
Cc:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Subject: [PATCH 1/2 nf-next v3] netfilter: nf_tables: Introduce stateful object update operation
Date:   Mon, 26 Aug 2019 13:40:52 +0200
Message-Id: <20190826114054.877-1-ffmancera@riseup.net>
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
 include/net/netfilter/nf_tables.h |  8 ++++
 net/netfilter/nf_tables_api.c     | 79 ++++++++++++++++++++++++++++---
 2 files changed, 80 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index dc301e3d6739..c23f950d67e2 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1123,6 +1123,8 @@ struct nft_object_ops {
 	int				(*dump)(struct sk_buff *skb,
 						struct nft_object *obj,
 						bool reset);
+	int				(*update)(struct nft_object *obj,
+						  struct nft_object *newobj);
 	const struct nft_object_type	*type;
 };
 
@@ -1405,10 +1407,16 @@ struct nft_trans_elem {
 
 struct nft_trans_obj {
 	struct nft_object		*obj;
+	struct nft_object		*newobj;
+	bool				update;
 };
 
 #define nft_trans_obj(trans)	\
 	(((struct nft_trans_obj *)trans->data)->obj)
+#define nft_trans_obj_newobj(trans) \
+	(((struct nft_trans_obj *)trans->data)->newobj)
+#define nft_trans_obj_update(trans)	\
+	(((struct nft_trans_obj *)trans->data)->update)
 
 struct nft_trans_flowtable {
 	struct nft_flowtable		*flowtable;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index fe3b7b0c6c66..38084fccb507 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5122,6 +5122,39 @@ nft_obj_type_get(struct net *net, u32 objtype)
 	return ERR_PTR(-ENOENT);
 }
 
+static int nf_tables_updobj(const struct nft_ctx *ctx,
+			    const struct nft_object_type *type,
+			    const struct nlattr *attr,
+			    struct nft_object *obj)
+{
+	struct nft_object *newobj;
+	struct nft_trans *trans;
+	int err = -ENOMEM;
+
+	trans = nft_trans_alloc(ctx, NFT_MSG_NEWOBJ,
+				sizeof(struct nft_trans_obj));
+	if (!trans)
+		return -ENOMEM;
+
+	newobj = nft_obj_init(ctx, type, attr);
+	if (IS_ERR(newobj)) {
+		err = PTR_ERR(newobj);
+		goto err;
+	}
+
+	nft_trans_obj(trans) = obj;
+	nft_trans_obj_update(trans) = true;
+	nft_trans_obj_newobj(trans) = newobj;
+	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
+
+	return 0;
+
+err:
+	nft_trans_destroy(trans);
+	kfree(newobj);
+	return err;
+}
+
 static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 			    struct sk_buff *skb, const struct nlmsghdr *nlh,
 			    const struct nlattr * const nla[],
@@ -5161,7 +5194,13 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
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
@@ -6422,6 +6461,19 @@ static void nft_chain_commit_update(struct nft_trans *trans)
 	}
 }
 
+static void nft_obj_commit_update(struct nft_trans *trans)
+{
+	struct nft_object *newobj;
+	struct nft_object *obj;
+
+	obj = nft_trans_obj(trans);
+	newobj = nft_trans_obj_newobj(trans);
+
+	obj->ops->update(obj, newobj);
+
+	kfree(newobj);
+}
+
 static void nft_commit_release(struct nft_trans *trans)
 {
 	switch (trans->msg_type) {
@@ -6786,10 +6838,18 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
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
@@ -6936,8 +6996,13 @@ static int __nf_tables_abort(struct net *net)
 			nft_trans_destroy(trans);
 			break;
 		case NFT_MSG_NEWOBJ:
-			trans->ctx.table->use--;
-			nft_obj_del(nft_trans_obj(trans));
+			if (nft_trans_obj_update(trans)) {
+				kfree(nft_trans_obj_newobj(trans));
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

