Return-Path: <SRS0=20nZ=ZY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F126C432C0
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 13:14:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 376B120674
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Dec 2019 13:14:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727508AbfLBNOV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Dec 2019 08:14:21 -0500
Received: from correo.us.es ([193.147.175.20]:49362 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727433AbfLBNOU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Dec 2019 08:14:20 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 7840DA1A343
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 14:14:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 694FBDA70D
        for <netfilter-devel@vger.kernel.org>; Mon,  2 Dec 2019 14:14:14 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 5ED14DA709; Mon,  2 Dec 2019 14:14:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 10D7ADA70D;
        Mon,  2 Dec 2019 14:14:12 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Dec 2019 14:14:12 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DBC014265A5A;
        Mon,  2 Dec 2019 14:14:11 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     sbrivio@redhat.com
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH,nf-next RFC 2/2] netfilter: nf_tables: add NFTA_SET_ELEM_KEY_END attribute
Date:   Mon,  2 Dec 2019 14:14:07 +0100
Message-Id: <20191202131407.500999-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20191202131407.500999-1-pablo@netfilter.org>
References: <20191202131407.500999-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Add NFTA_SET_ELEM_KEY_END attribute to convey the closing element of the
interval between kernel and userspace.

This patch also adds the NFT_SET_EXT_KEY_END extension to store the
closing element value in this interval.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        | 14 +++++-
 include/uapi/linux/netfilter/nf_tables.h |  2 +
 net/netfilter/nf_tables_api.c            | 82 +++++++++++++++++++++++---------
 net/netfilter/nft_dynset.c               |  2 +-
 4 files changed, 76 insertions(+), 24 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index fe7c50acc681..2252a3892124 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -231,6 +231,7 @@ struct nft_userdata {
  *	struct nft_set_elem - generic representation of set elements
  *
  *	@key: element key
+ *	@key_end: closing element key
  *	@priv: element private data and extensions
  */
 struct nft_set_elem {
@@ -238,6 +239,10 @@ struct nft_set_elem {
 		u32		buf[NFT_DATA_VALUE_MAXLEN / sizeof(u32)];
 		struct nft_data	val;
 	} key;
+	union {
+		u32		buf[NFT_DATA_VALUE_MAXLEN / sizeof(u32)];
+		struct nft_data	val;
+	} key_end;
 	void			*priv;
 };
 
@@ -502,6 +507,7 @@ void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set);
  *	enum nft_set_extensions - set extension type IDs
  *
  *	@NFT_SET_EXT_KEY: element key
+ *	@NFT_SET_EXT_KEY_END: closing element key
  *	@NFT_SET_EXT_DATA: mapping data
  *	@NFT_SET_EXT_FLAGS: element flags
  *	@NFT_SET_EXT_TIMEOUT: element timeout
@@ -513,6 +519,7 @@ void nf_tables_destroy_set(const struct nft_ctx *ctx, struct nft_set *set);
  */
 enum nft_set_extensions {
 	NFT_SET_EXT_KEY,
+	NFT_SET_EXT_KEY_END,
 	NFT_SET_EXT_DATA,
 	NFT_SET_EXT_FLAGS,
 	NFT_SET_EXT_TIMEOUT,
@@ -606,6 +613,11 @@ static inline struct nft_data *nft_set_ext_key(const struct nft_set_ext *ext)
 	return nft_set_ext(ext, NFT_SET_EXT_KEY);
 }
 
+static inline struct nft_data *nft_set_ext_key_end(const struct nft_set_ext *ext)
+{
+	return nft_set_ext(ext, NFT_SET_EXT_KEY_END);
+}
+
 static inline struct nft_data *nft_set_ext_data(const struct nft_set_ext *ext)
 {
 	return nft_set_ext(ext, NFT_SET_EXT_DATA);
@@ -655,7 +667,7 @@ static inline struct nft_object **nft_set_ext_obj(const struct nft_set_ext *ext)
 
 void *nft_set_elem_init(const struct nft_set *set,
 			const struct nft_set_ext_tmpl *tmpl,
-			const u32 *key, const u32 *data,
+			const u32 *key, const u32 *key_end, const u32 *data,
 			u64 timeout, u64 expiration, gfp_t gfp);
 void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 			  bool destroy_expr);
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index bb9b049310df..1d62552a12a7 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -370,6 +370,7 @@ enum nft_set_elem_flags {
  * @NFTA_SET_ELEM_USERDATA: user data (NLA_BINARY)
  * @NFTA_SET_ELEM_EXPR: expression (NLA_NESTED: nft_expr_attributes)
  * @NFTA_SET_ELEM_OBJREF: stateful object reference (NLA_STRING)
+ * @NFTA_SET_ELEM_KEY_END: closing key value (NLA_STRING)
  */
 enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_UNSPEC,
@@ -382,6 +383,7 @@ enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_EXPR,
 	NFTA_SET_ELEM_PAD,
 	NFTA_SET_ELEM_OBJREF,
+	NFTA_SET_ELEM_KEY_END,
 	__NFTA_SET_ELEM_MAX
 };
 #define NFTA_SET_ELEM_MAX	(__NFTA_SET_ELEM_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 13e291fac26f..927f6de5f65c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4199,6 +4199,7 @@ static const struct nla_policy nft_set_elem_policy[NFTA_SET_ELEM_MAX + 1] = {
 					    .len = NFT_USERDATA_MAXLEN },
 	[NFTA_SET_ELEM_EXPR]		= { .type = NLA_NESTED },
 	[NFTA_SET_ELEM_OBJREF]		= { .type = NLA_STRING },
+	[NFTA_SET_ELEM_KEY_END]		= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX + 1] = {
@@ -4248,6 +4249,11 @@ static int nf_tables_fill_setelem(struct sk_buff *skb,
 			  NFT_DATA_VALUE, set->klen) < 0)
 		goto nla_put_failure;
 
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END) &&
+	    nft_data_dump(skb, NFTA_SET_ELEM_KEY_END, nft_set_ext_key_end(ext),
+			  NFT_DATA_VALUE, set->klen) < 0)
+		goto nla_put_failure;
+
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) &&
 	    nft_data_dump(skb, NFTA_SET_ELEM_DATA, nft_set_ext_data(ext),
 			  set->dtype == NFT_DATA_VERDICT ? NFT_DATA_VERDICT : NFT_DATA_VALUE,
@@ -4538,6 +4544,13 @@ static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (err < 0)
 		return err;
 
+	if (nla[NFTA_SET_ELEM_KEY_END]) {
+		err = nft_setelem_parse_key(ctx, set, &elem.key_end.val,
+					    nla[NFTA_SET_ELEM_KEY_END]);
+		if (err < 0)
+			return err;
+	}
+
 	priv = set->ops->get(ctx->net, set, &elem, flags);
 	if (IS_ERR(priv))
 		return PTR_ERR(priv);
@@ -4663,8 +4676,8 @@ static struct nft_trans *nft_trans_elem_alloc(struct nft_ctx *ctx,
 
 void *nft_set_elem_init(const struct nft_set *set,
 			const struct nft_set_ext_tmpl *tmpl,
-			const u32 *key, const u32 *data,
-			u64 timeout, u64 expiration, gfp_t gfp)
+			const u32 *key, const u32 *key_end,
+			const u32 *data, u64 timeout, u64 expiration, gfp_t gfp)
 {
 	struct nft_set_ext *ext;
 	void *elem;
@@ -4677,6 +4690,8 @@ void *nft_set_elem_init(const struct nft_set *set,
 	nft_set_ext_init(ext, tmpl);
 
 	memcpy(nft_set_ext_key(ext), key, set->klen);
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
+		memcpy(nft_set_ext_key_end(ext), key_end, set->klen);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		memcpy(nft_set_ext_data(ext), data, set->dlen);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
@@ -4811,9 +4826,19 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	err = nft_setelem_parse_key(ctx, set, &elem.key.val,
 				    nla[NFTA_SET_ELEM_KEY]);
 	if (err < 0)
-		goto err1;
+		return err;
 
 	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+
+	if (nla[NFTA_SET_ELEM_KEY_END]) {
+		err = nft_setelem_parse_key(ctx, set, &elem.key_end.val,
+					    nla[NFTA_SET_ELEM_KEY_END]);
+		if (err < 0)
+			goto err_parse_key;
+
+		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
+	}
+
 	if (timeout > 0) {
 		nft_set_ext_add(&tmpl, NFT_SET_EXT_EXPIRATION);
 		if (timeout != set->timeout)
@@ -4823,14 +4848,14 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	if (nla[NFTA_SET_ELEM_OBJREF] != NULL) {
 		if (!(set->flags & NFT_SET_OBJECT)) {
 			err = -EINVAL;
-			goto err2;
+			goto err_parse_key_end;
 		}
 		obj = nft_obj_lookup(ctx->net, ctx->table,
 				     nla[NFTA_SET_ELEM_OBJREF],
 				     set->objtype, genmask);
 		if (IS_ERR(obj)) {
 			err = PTR_ERR(obj);
-			goto err2;
+			goto err_parse_key_end;
 		}
 		nft_set_ext_add(&tmpl, NFT_SET_EXT_OBJREF);
 	}
@@ -4839,11 +4864,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		err = nft_data_init(ctx, &data, sizeof(data), &d2,
 				    nla[NFTA_SET_ELEM_DATA]);
 		if (err < 0)
-			goto err2;
+			goto err_parse_key_end;
 
 		err = -EINVAL;
 		if (set->dtype != NFT_DATA_VERDICT && d2.len != set->dlen)
-			goto err3;
+			goto err_parse_data;
 
 		dreg = nft_type_to_reg(set->dtype);
 		list_for_each_entry(binding, &set->bindings, list) {
@@ -4861,7 +4886,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 							  &data,
 							  d2.type, d2.len);
 			if (err < 0)
-				goto err3;
+				goto err_parse_data;
 
 			if (d2.type == NFT_DATA_VERDICT &&
 			    (data.verdict.code == NFT_GOTO ||
@@ -4886,10 +4911,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	}
 
 	err = -ENOMEM;
-	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data, data.data,
+	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data,
+				      elem.key_end.val.data, data.data,
 				      timeout, expiration, GFP_KERNEL);
 	if (elem.priv == NULL)
-		goto err3;
+		goto err_parse_data;
 
 	ext = nft_set_elem_ext(set, elem.priv);
 	if (flags)
@@ -4906,7 +4932,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans == NULL)
-		goto err4;
+		goto err_trans;
 
 	ext->genmask = nft_genmask_cur(ctx->net) | NFT_SET_ELEM_BUSY_MASK;
 	err = set->ops->insert(ctx->net, set, &elem, &ext2);
@@ -4917,7 +4943,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) ^
 			    nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF)) {
 				err = -EBUSY;
-				goto err5;
+				goto err_element_clash;
 			}
 			if ((nft_set_ext_exists(ext, NFT_SET_EXT_DATA) &&
 			     nft_set_ext_exists(ext2, NFT_SET_EXT_DATA) &&
@@ -4930,33 +4956,35 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			else if (!(nlmsg_flags & NLM_F_EXCL))
 				err = 0;
 		}
-		goto err5;
+		goto err_element_clash;
 	}
 
 	if (set->size &&
 	    !atomic_add_unless(&set->nelems, 1, set->size + set->ndeact)) {
 		err = -ENFILE;
-		goto err6;
+		goto err_set_full;
 	}
 
 	nft_trans_elem(trans) = elem;
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 	return 0;
 
-err6:
+err_set_full:
 	set->ops->remove(ctx->net, set, &elem);
-err5:
+err_element_clash:
 	kfree(trans);
-err4:
+err_trans:
 	if (obj)
 		obj->use--;
 	kfree(elem.priv);
-err3:
+err_parse_data:
 	if (nla[NFTA_SET_ELEM_DATA] != NULL)
 		nft_data_release(&data, d2.type);
-err2:
+err_parse_key_end:
+	nft_data_release(&elem.key_end.val, NFT_DATA_VALUE);
+err_parse_key:
 	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
-err1:
+
 	return err;
 }
 
@@ -5082,9 +5110,19 @@ static int nft_del_setelem(struct nft_ctx *ctx, struct nft_set *set,
 
 	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
 
+	if (nla[NFTA_SET_ELEM_KEY_END]) {
+		err = nft_setelem_parse_key(ctx, set, &elem.key_end.val,
+					    nla[NFTA_SET_ELEM_KEY_END]);
+		if (err < 0)
+			return err;
+
+		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
+	}
+
 	err = -ENOMEM;
-	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data, NULL, 0,
-				      0, GFP_KERNEL);
+	elem.priv = nft_set_elem_init(set, &tmpl, elem.key.val.data,
+				      elem.key_end.val.data, NULL, 0, 0,
+				      GFP_KERNEL);
 	if (elem.priv == NULL)
 		goto err2;
 
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 8887295414dc..683785225a3e 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -54,7 +54,7 @@ static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
 
 	timeout = priv->timeout ? : set->timeout;
 	elem = nft_set_elem_init(set, &priv->tmpl,
-				 &regs->data[priv->sreg_key],
+				 &regs->data[priv->sreg_key], NULL,
 				 &regs->data[priv->sreg_data],
 				 timeout, 0, GFP_ATOMIC);
 	if (elem == NULL)
-- 
2.11.0

