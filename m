Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56A87C7EE2E
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 May 2023 14:45:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbjEPOpA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 May 2023 10:45:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbjEPOor (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 May 2023 10:44:47 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5F3913A9D;
        Tue, 16 May 2023 07:44:46 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: [PATCH -stable,5.4 6/9] netfilter: nf_tables: allow up to 64 bytes in the set element data area
Date:   Tue, 16 May 2023 16:44:32 +0200
Message-Id: <20230516144435.4010-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230516144435.4010-1-pablo@netfilter.org>
References: <20230516144435.4010-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

[ fdb9c405e35bdc6e305b9b4e20ebc141ed14fc81 ]

So far, the set elements could store up to 128-bits in the data area.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  4 +++
 net/netfilter/nf_tables_api.c     | 41 +++++++++++++++++++++----------
 2 files changed, 32 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1479d7c4afe6..4f7903f8d1ad 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -239,6 +239,10 @@ struct nft_set_elem {
 		u32		buf[NFT_DATA_VALUE_MAXLEN / sizeof(u32)];
 		struct nft_data	val;
 	} key;
+	union {
+		u32		buf[NFT_DATA_VALUE_MAXLEN / sizeof(u32)];
+		struct nft_data val;
+	} data;
 	void			*priv;
 };
 
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 609ad3bf71d8..8eecc4be2d36 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4298,6 +4298,25 @@ static int nft_setelem_parse_key(struct nft_ctx *ctx, struct nft_set *set,
 	return 0;
 }
 
+static int nft_setelem_parse_data(struct nft_ctx *ctx, struct nft_set *set,
+				  struct nft_data_desc *desc,
+				  struct nft_data *data,
+				  struct nlattr *attr)
+{
+	int err;
+
+	err = nft_data_init(ctx, data, NFT_DATA_VALUE_MAXLEN, desc, attr);
+	if (err < 0)
+		return err;
+
+	if (desc->type != NFT_DATA_VERDICT && desc->len != set->dlen) {
+		nft_data_release(data, desc->type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr)
 {
@@ -4524,7 +4543,6 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_object *obj = NULL;
 	struct nft_userdata *udata;
 	struct nft_data_desc desc;
-	struct nft_data data;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
 	u32 flags = 0;
@@ -4617,15 +4635,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	if (nla[NFTA_SET_ELEM_DATA] != NULL) {
-		err = nft_data_init(ctx, &data, sizeof(data), &desc,
-				    nla[NFTA_SET_ELEM_DATA]);
+		err = nft_setelem_parse_data(ctx, set, &desc, &elem.data.val,
+					     nla[NFTA_SET_ELEM_DATA]);
 		if (err < 0)
 			goto err2;
 
-		err = -EINVAL;
-		if (set->dtype != NFT_DATA_VERDICT && desc.len != set->dlen)
-			goto err3;
-
 		dreg = nft_type_to_reg(set->dtype);
 		list_for_each_entry(binding, &set->bindings, list) {
 			struct nft_ctx bind_ctx = {
@@ -4639,14 +4653,14 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 				continue;
 
 			err = nft_validate_register_store(&bind_ctx, dreg,
-							  &data,
+							  &elem.data.val,
 							  desc.type, desc.len);
 			if (err < 0)
 				goto err3;
 
 			if (desc.type == NFT_DATA_VERDICT &&
-			    (data.verdict.code == NFT_GOTO ||
-			     data.verdict.code == NFT_JUMP))
+			    (elem.data.val.verdict.code == NFT_GOTO ||
+			     elem.data.val.verdict.code == NFT_JUMP))
 				nft_validate_state_update(ctx->net,
 							  NFT_VALIDATE_NEED);
 		}
@@ -4667,8 +4681,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	err = -ENOMEM;
-	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data, data.data,
-				      timeout, expiration, GFP_KERNEL);
+	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data,
+				      elem.data.val.data, timeout, expiration,
+				      GFP_KERNEL);
 	if (elem.priv == NULL)
 		goto err3;
 
@@ -4734,7 +4749,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	kfree(elem.priv);
 err3:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
-		nft_data_release(&data, desc.type);
+		nft_data_release(&elem.data.val, desc.type);
 err2:
 	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
 err1:
-- 
2.30.2

