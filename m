Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80983C43334
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Jul 2022 10:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237914AbiGHKGk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Jul 2022 06:06:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237768AbiGHKGj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Jul 2022 06:06:39 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5B1CD83F32
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Jul 2022 03:06:38 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf,v2 2/2] netfilter: nf_tables: replace BUG_ON by element length check
Date:   Fri,  8 Jul 2022 12:06:33 +0200
Message-Id: <20220708100633.18896-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220708100633.18896-1-pablo@netfilter.org>
References: <20220708100633.18896-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

BUG_ON can be triggered from userspace with an element with a large
userdata area. Replace it by length check and return EINVAL instead.
Over time extensions have been growing in size.

Pick a sufficiently old Fixes: tag to propagate this fix.

Fixes: 3ac4c07a2400 ("netfilter: nf_tables: add set extensions")
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: add a few missing check for nft_set_ext_add() returned value.

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
index 9b6711e2f193..0f8f0d59d2c1 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5838,8 +5838,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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
@@ -5948,7 +5951,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			goto err_set_elem_expr;
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		if (err < 0)
+			goto err_parse_key;
 	}
 
 	if (nla[NFTA_SET_ELEM_KEY_END]) {
@@ -5957,22 +5962,31 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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
@@ -5987,7 +6001,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			err = PTR_ERR(obj);
 			goto err_parse_key_end;
 		}
-		nft_set_ext_add(&tmpl, NFT_SET_EXT_OBJREF);
+		err = nft_set_ext_add(&tmpl, NFT_SET_EXT_OBJREF);
+		if (err < 0)
+			goto err_parse_key_end;
 	}
 
 	if (nla[NFTA_SET_ELEM_DATA] != NULL) {
@@ -6021,7 +6037,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 							  NFT_VALIDATE_NEED);
 		}
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_DATA, desc.len);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_DATA, desc.len);
+		if (err < 0)
+			goto err_parse_data;
 	}
 
 	/* The full maximum length of userdata can exceed the maximum
@@ -6031,9 +6049,12 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
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
@@ -6261,8 +6282,11 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 
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
@@ -6270,7 +6294,9 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			return err;
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+		if (err < 0)
+			goto fail_elem;
 	}
 
 	if (nla[NFTA_SET_ELEM_KEY_END]) {
@@ -6279,7 +6305,9 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 		if (err < 0)
 			goto fail_elem;
 
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
+		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
+		if (err < 0)
+			goto fail_elem_key_end;
 	}
 
 	err = -ENOMEM;
-- 
2.30.2

