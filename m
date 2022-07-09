Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7C67C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  9 Jul 2022 14:18:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229637AbiGIOSU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 9 Jul 2022 10:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229697AbiGIOSS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Jul 2022 10:18:18 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D69B7E01A
        for <netfilter-devel@vger.kernel.org>; Sat,  9 Jul 2022 07:18:13 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v3] netfilter: nf_tables: replace BUG_ON by element length check
Date:   Sat,  9 Jul 2022 16:18:09 +0200
Message-Id: <20220709141809.255042-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

BUG_ON can be triggered from userspace with an element with a large
userdata area. Replace it by length check and return EINVAL instead.
Over time extensions have been growing in size.

Pick a sufficiently old Fixes: tag to propagate this fix.

Fixes: 7d7402642eaf ("netfilter: nf_tables: variable sized set element keys / data")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v3: rebase without previous patch dependency.

 include/net/netfilter/nf_tables.h | 14 ++++---
 net/netfilter/nf_tables_api.c     | 66 ++++++++++++++++++++++---------
 2 files changed, 56 insertions(+), 24 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 5c4e5a96a984..64cf655c818c 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -657,18 +657,22 @@ static inline void nft_set_ext_prepare(struct nft_set_ext_tmpl *tmpl)
 	tmpl->len = sizeof(struct nft_set_ext);
 }
 
-static inline void nft_set_ext_add_length(struct nft_set_ext_tmpl *tmpl, u8 id,
-					  unsigned int len)
+static inline int nft_set_ext_add_length(struct nft_set_ext_tmpl *tmpl, u8 id,
+					 unsigned int len)
 {
 	tmpl->len	 = ALIGN(tmpl->len, nft_set_ext_types[id].align);
-	BUG_ON(tmpl->len > U8_MAX);
+	if (tmpl->len > U8_MAX)
+		return -EINVAL;
+
 	tmpl->offset[id] = tmpl->len;
 	tmpl->len	+= nft_set_ext_types[id].len + len;
+
+	return 0;
 }
 
-static inline void nft_set_ext_add(struct nft_set_ext_tmpl *tmpl, u8 id)
+static inline int nft_set_ext_add(struct nft_set_ext_tmpl *tmpl, u8 id)
 {
-	nft_set_ext_add_length(tmpl, id, 0);
+	return nft_set_ext_add_length(tmpl, id, 0);
 }
 
 static inline void nft_set_ext_init(struct nft_set_ext *ext,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index d6b59beab3a9..dd48c91250e6 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5833,8 +5833,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (!nla[NFTA_SET_ELEM_KEY] && !(flags & NFT_SET_ELEM_CATCHALL))
 		return -EINVAL;
 
-	if (flags != 0)
-		nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
+	if (flags != 0) {
+		err = nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
+		if (err < 0)
+			return err;
+	}
 
 	if (set->flags & NFT_SET_MAP) {
 		if (nla[NFTA_SET_ELEM_DATA] == NULL &&
@@ -5943,7 +5946,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			goto err_set_elem_expr;
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		if (err < 0)
+			goto err_parse_key;
 	}
 
 	if (nla[NFTA_SET_ELEM_KEY_END]) {
@@ -5952,22 +5957,31 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			goto err_parse_key;
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
+		if (err < 0)
+			goto err_parse_key_end;
 	}
 
 	if (timeout > 0) {
-		nft_set_ext_add(&tmpl, NFT_SET_EXT_EXPIRATION);
-		if (timeout != set->timeout)
-			nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
+		err = nft_set_ext_add(&tmpl, NFT_SET_EXT_EXPIRATION);
+		if (err < 0)
+			goto err_parse_key_end;
+
+		if (timeout != set->timeout) {
+			err = nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
+			if (err < 0)
+				goto err_parse_key_end;
+		}
 	}
 
 	if (num_exprs) {
 		for (i = 0; i < num_exprs; i++)
 			size += expr_array[i]->ops->size;
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_EXPRESSIONS,
-				       sizeof(struct nft_set_elem_expr) +
-				       size);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_EXPRESSIONS,
+					     sizeof(struct nft_set_elem_expr) + size);
+		if (err < 0)
+			goto err_parse_key_end;
 	}
 
 	if (nla[NFTA_SET_ELEM_OBJREF] != NULL) {
@@ -5982,7 +5996,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			err = PTR_ERR(obj);
 			goto err_parse_key_end;
 		}
-		nft_set_ext_add(&tmpl, NFT_SET_EXT_OBJREF);
+		err = nft_set_ext_add(&tmpl, NFT_SET_EXT_OBJREF);
+		if (err < 0)
+			goto err_parse_key_end;
 	}
 
 	if (nla[NFTA_SET_ELEM_DATA] != NULL) {
@@ -6016,7 +6032,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 							  NFT_VALIDATE_NEED);
 		}
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_DATA, desc.len);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_DATA, desc.len);
+		if (err < 0)
+			goto err_parse_data;
 	}
 
 	/* The full maximum length of userdata can exceed the maximum
@@ -6026,9 +6044,12 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	ulen = 0;
 	if (nla[NFTA_SET_ELEM_USERDATA] != NULL) {
 		ulen = nla_len(nla[NFTA_SET_ELEM_USERDATA]);
-		if (ulen > 0)
-			nft_set_ext_add_length(&tmpl, NFT_SET_EXT_USERDATA,
-					       ulen);
+		if (ulen > 0) {
+			err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_USERDATA,
+						     ulen);
+			if (err < 0)
+				goto err_parse_data;
+		}
 	}
 
 	err = -ENOMEM;
@@ -6256,8 +6277,11 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 
 	nft_set_ext_prepare(&tmpl);
 
-	if (flags != 0)
-		nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
+	if (flags != 0) {
+		err = nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
+		if (err < 0)
+			return err;
+	}
 
 	if (nla[NFTA_SET_ELEM_KEY]) {
 		err = nft_setelem_parse_key(ctx, set, &elem.key.val,
@@ -6265,7 +6289,9 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			return err;
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		if (err < 0)
+			goto fail_elem;
 	}
 
 	if (nla[NFTA_SET_ELEM_KEY_END]) {
@@ -6274,7 +6300,9 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			return err;
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
+		if (err < 0)
+			goto fail_elem;
 	}
 
 	err = -ENOMEM;
-- 
2.30.2

