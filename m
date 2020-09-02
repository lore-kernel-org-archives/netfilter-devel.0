Return-Path: <SRS0=PMCV=CL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FF67C433E2
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Sep 2020 09:13:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64C812071B
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Sep 2020 09:13:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="TgRow6Et"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726510AbgIBJNM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Sep 2020 05:13:12 -0400
Received: from mx1.riseup.net ([198.252.153.129]:48316 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726400AbgIBJNK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Sep 2020 05:13:10 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "Sectigo RSA Domain Validation Secure Server CA" (not verified))
        by mx1.riseup.net (Postfix) with ESMTPS id 4BhJBZ2r0XzFdxH;
        Wed,  2 Sep 2020 02:13:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1599037990; bh=PqEd/4bauYabr3xiKec3VrpsiCSC3ZXArG2XRPSelJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TgRow6EttlihPDQX9Xahf4tMcYvbrycsenoNYmKmhBzw/S02z8Ur8C/UAPw+JD6UQ
         CHCmCjdZYGeyH/n4jufFY5TUSuSVULPpa5KpPjsyk6PSgA/wda0KCmWz+PiXGKVHEd
         TmRTKbVPYhyj5XdvVbLbFhSyvF8q6q5ZXVzvDQ2U=
X-Riseup-User-ID: 65650930BA84037A1C483ABD088577AA5B52838A61194AC4570A96547FB2C80F
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 4BhJBY40s3z8tRn;
        Wed,  2 Sep 2020 02:13:09 -0700 (PDT)
From:   "Jose M. Guisado Gomez" <guigom@riseup.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/3] netfilter: nf_tables: add userdata support for nft_object
Date:   Wed,  2 Sep 2020 11:12:39 +0200
Message-Id: <20200902091241.1379-2-guigom@riseup.net>
In-Reply-To: <20200902091241.1379-1-guigom@riseup.net>
References: <20200902091241.1379-1-guigom@riseup.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Enables storing userdata for nft_object. Initially this will store an
optional comment but can be extended in the future as needed.

Adds new attribute NFTA_OBJ_USERDATA to nft_object.

Renames error labels in nf_tables_newobj to make it more clear.

Signed-off-by: Jose M. Guisado Gomez <guigom@riseup.net>
---
 include/net/netfilter/nf_tables.h        |  2 ++
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nf_tables_api.c            | 39 +++++++++++++++++++-----
 3 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 97a7e147a59a..99c1b3188b1e 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1123,6 +1123,8 @@ struct nft_object {
 	u32				genmask:2,
 					use:30;
 	u64				handle;
+	u16				udlen;
+	u8				*udata;
 	/* runtime data below here */
 	const struct nft_object_ops	*ops ____cacheline_aligned;
 	unsigned char			data[]
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 543dc697b796..2a6e09dea1a0 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -1559,6 +1559,7 @@ enum nft_ct_expectation_attributes {
  * @NFTA_OBJ_DATA: stateful object data (NLA_NESTED)
  * @NFTA_OBJ_USE: number of references to this expression (NLA_U32)
  * @NFTA_OBJ_HANDLE: object handle (NLA_U64)
+ * @NFTA_OBJ_USERDATA: user data (NLA_BINARY)
  */
 enum nft_object_attributes {
 	NFTA_OBJ_UNSPEC,
@@ -1569,6 +1570,7 @@ enum nft_object_attributes {
 	NFTA_OBJ_USE,
 	NFTA_OBJ_HANDLE,
 	NFTA_OBJ_PAD,
+	NFTA_OBJ_USERDATA,
 	__NFTA_OBJ_MAX
 };
 #define NFTA_OBJ_MAX		(__NFTA_OBJ_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 6ccce2a2e715..55111aefd3db 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5755,6 +5755,8 @@ static const struct nla_policy nft_obj_policy[NFTA_OBJ_MAX + 1] = {
 	[NFTA_OBJ_TYPE]		= { .type = NLA_U32 },
 	[NFTA_OBJ_DATA]		= { .type = NLA_NESTED },
 	[NFTA_OBJ_HANDLE]	= { .type = NLA_U64},
+	[NFTA_OBJ_USERDATA]	= { .type = NLA_BINARY,
+				    .len = NFT_USERDATA_MAXLEN },
 };
 
 static struct nft_object *nft_obj_init(const struct nft_ctx *ctx,
@@ -5901,6 +5903,7 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 	struct nft_table *table;
 	struct nft_object *obj;
 	struct nft_ctx ctx;
+	u16 udlen = 0;
 	u32 objtype;
 	int err;
 
@@ -5946,7 +5949,7 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 	obj = nft_obj_init(&ctx, type, nla[NFTA_OBJ_DATA]);
 	if (IS_ERR(obj)) {
 		err = PTR_ERR(obj);
-		goto err1;
+		goto err_init;
 	}
 	obj->key.table = table;
 	obj->handle = nf_tables_alloc_handle(table);
@@ -5954,32 +5957,48 @@ static int nf_tables_newobj(struct net *net, struct sock *nlsk,
 	obj->key.name = nla_strdup(nla[NFTA_OBJ_NAME], GFP_KERNEL);
 	if (!obj->key.name) {
 		err = -ENOMEM;
-		goto err2;
+		goto err_strdup;
+	}
+
+	if(nla[NFTA_OBJ_USERDATA]) {
+		udlen = nla_len(nla[NFTA_OBJ_USERDATA]);
+		obj->udata = kzalloc(udlen, GFP_KERNEL);
+		if (obj->udata == NULL)
+			goto err_userdata;
+	} else {
+		obj->udata = NULL;
+	}
+
+	if (udlen) {
+		nla_memcpy(obj->udata, nla[NFTA_OBJ_USERDATA], udlen);
+		obj->udlen = udlen;
 	}
 
 	err = nft_trans_obj_add(&ctx, NFT_MSG_NEWOBJ, obj);
 	if (err < 0)
-		goto err3;
+		goto err_trans;
 
 	err = rhltable_insert(&nft_objname_ht, &obj->rhlhead,
 			      nft_objname_ht_params);
 	if (err < 0)
-		goto err4;
+		goto err_obj_ht;
 
 	list_add_tail_rcu(&obj->list, &table->objects);
 	table->use++;
 	return 0;
-err4:
+err_obj_ht:
 	/* queued in transaction log */
 	INIT_LIST_HEAD(&obj->list);
 	return err;
-err3:
+err_trans:
 	kfree(obj->key.name);
-err2:
+err_userdata:
+	kfree(obj->udata);
+err_strdup:
 	if (obj->ops->destroy)
 		obj->ops->destroy(&ctx, obj);
 	kfree(obj);
-err1:
+err_init:
 	module_put(type->owner);
 	return err;
 }
@@ -6011,6 +6030,10 @@ static int nf_tables_fill_obj_info(struct sk_buff *skb, struct net *net,
 			 NFTA_OBJ_PAD))
 		goto nla_put_failure;
 
+	if (obj->udata &&
+	    nla_put(skb, NFTA_OBJ_USERDATA, obj->udlen, obj->udata))
+		goto nla_put_failure;
+
 	nlmsg_end(skb, nlh);
 	return 0;
 
-- 
2.27.0

