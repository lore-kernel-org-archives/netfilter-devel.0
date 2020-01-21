Return-Path: <SRS0=AyPt=3K=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3092EC2D0CE
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 23:18:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB23D24653
	for <netfilter-devel@archiver.kernel.org>; Tue, 21 Jan 2020 23:18:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="G3j0t9Kq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbgAUXSQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 21 Jan 2020 18:18:16 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:43262 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726407AbgAUXSQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 21 Jan 2020 18:18:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579648694;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R+IkokNXNm7QCLTetlgk1DLldDASxQdnvD+gaC/9jNw=;
        b=G3j0t9KqGzp+d+N8MAJTAh0yO9UEYhRzQzI8/GZOYfUczvkLn8es97fKm3pfPrnROpyHtT
        X6n7v/bL8mk2Y7OYzr7IXo+Yr3WYyrQ6LDgyWiMa7+UHS/5/5OP45CdBAamiSGCNGMVq36
        PsmzkqzDO978pU+u8ze/c+mHbPXVe/k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-68-pIKKTtqCPyG003aTuGyTNg-1; Tue, 21 Jan 2020 18:18:09 -0500
X-MC-Unique: pIKKTtqCPyG003aTuGyTNg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B291B1005510;
        Tue, 21 Jan 2020 23:18:08 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-49.ams2.redhat.com [10.36.112.49])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C22AD5C1BB;
        Tue, 21 Jan 2020 23:18:06 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next v4 2/9] netfilter: nf_tables: add NFTA_SET_ELEM_KEY_END attribute
Date:   Wed, 22 Jan 2020 00:17:52 +0100
Message-Id: <e758cda9c9f7ea603d476e072af87b94f79a7457.1579647351.git.sbrivio@redhat.com>
In-Reply-To: <cover.1579647351.git.sbrivio@redhat.com>
References: <cover.1579647351.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

Add NFTA_SET_ELEM_KEY_END attribute to convey the closing element of the
interval between kernel and userspace.

This patch also adds the NFT_SET_EXT_KEY_END extension to store the
closing element value in this interval.

v4: No changes
v3: New patch

[sbrivio: refactor error paths and labels; add corresponding
  nft_set_ext_type for new key; rebase]
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        | 14 +++-
 include/uapi/linux/netfilter/nf_tables.h |  2 +
 net/netfilter/nf_tables_api.c            | 85 ++++++++++++++++++------
 net/netfilter/nft_dynset.c               |  2 +-
 4 files changed, 79 insertions(+), 24 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf=
_tables.h
index fe7c50acc681..504c0aa93805 100644
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
=20
@@ -502,6 +507,7 @@ void nf_tables_destroy_set(const struct nft_ctx *ctx,=
 struct nft_set *set);
  *	enum nft_set_extensions - set extension type IDs
  *
  *	@NFT_SET_EXT_KEY: element key
+ *	@NFT_SET_EXT_KEY_END: upper bound element key, for ranges
  *	@NFT_SET_EXT_DATA: mapping data
  *	@NFT_SET_EXT_FLAGS: element flags
  *	@NFT_SET_EXT_TIMEOUT: element timeout
@@ -513,6 +519,7 @@ void nf_tables_destroy_set(const struct nft_ctx *ctx,=
 struct nft_set *set);
  */
 enum nft_set_extensions {
 	NFT_SET_EXT_KEY,
+	NFT_SET_EXT_KEY_END,
 	NFT_SET_EXT_DATA,
 	NFT_SET_EXT_FLAGS,
 	NFT_SET_EXT_TIMEOUT,
@@ -606,6 +613,11 @@ static inline struct nft_data *nft_set_ext_key(const=
 struct nft_set_ext *ext)
 	return nft_set_ext(ext, NFT_SET_EXT_KEY);
 }
=20
+static inline struct nft_data *nft_set_ext_key_end(const struct nft_set_=
ext *ext)
+{
+	return nft_set_ext(ext, NFT_SET_EXT_KEY_END);
+}
+
 static inline struct nft_data *nft_set_ext_data(const struct nft_set_ext=
 *ext)
 {
 	return nft_set_ext(ext, NFT_SET_EXT_DATA);
@@ -655,7 +667,7 @@ static inline struct nft_object **nft_set_ext_obj(con=
st struct nft_set_ext *ext)
=20
 void *nft_set_elem_init(const struct nft_set *set,
 			const struct nft_set_ext_tmpl *tmpl,
-			const u32 *key, const u32 *data,
+			const u32 *key, const u32 *key_end, const u32 *data,
 			u64 timeout, u64 expiration, gfp_t gfp);
 void nft_set_elem_destroy(const struct nft_set *set, void *elem,
 			  bool destroy_expr);
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linu=
x/netfilter/nf_tables.h
index 261864736b26..c13106496bd2 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -370,6 +370,7 @@ enum nft_set_elem_flags {
  * @NFTA_SET_ELEM_USERDATA: user data (NLA_BINARY)
  * @NFTA_SET_ELEM_EXPR: expression (NLA_NESTED: nft_expr_attributes)
  * @NFTA_SET_ELEM_OBJREF: stateful object reference (NLA_STRING)
+ * @NFTA_SET_ELEM_KEY_END: closing key value (NLA_NESTED: nft_data)
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
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.=
c
index 0628b9ad7aa4..6cfd65348958 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4182,6 +4182,9 @@ const struct nft_set_ext_type nft_set_ext_types[] =3D=
 {
 		.len	=3D sizeof(struct nft_userdata),
 		.align	=3D __alignof__(struct nft_userdata),
 	},
+	[NFT_SET_EXT_KEY_END]		=3D {
+		.align	=3D __alignof__(u32),
+	},
 };
 EXPORT_SYMBOL_GPL(nft_set_ext_types);
=20
@@ -4199,6 +4202,7 @@ static const struct nla_policy nft_set_elem_policy[=
NFTA_SET_ELEM_MAX + 1] =3D {
 					    .len =3D NFT_USERDATA_MAXLEN },
 	[NFTA_SET_ELEM_EXPR]		=3D { .type =3D NLA_NESTED },
 	[NFTA_SET_ELEM_OBJREF]		=3D { .type =3D NLA_STRING },
+	[NFTA_SET_ELEM_KEY_END]		=3D { .type =3D NLA_NESTED },
 };
=20
 static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LI=
ST_MAX + 1] =3D {
@@ -4248,6 +4252,11 @@ static int nf_tables_fill_setelem(struct sk_buff *=
skb,
 			  NFT_DATA_VALUE, set->klen) < 0)
 		goto nla_put_failure;
=20
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END) &&
+	    nft_data_dump(skb, NFTA_SET_ELEM_KEY_END, nft_set_ext_key_end(ext),
+			  NFT_DATA_VALUE, set->klen) < 0)
+		goto nla_put_failure;
+
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA) &&
 	    nft_data_dump(skb, NFTA_SET_ELEM_DATA, nft_set_ext_data(ext),
 			  set->dtype =3D=3D NFT_DATA_VERDICT ? NFT_DATA_VERDICT : NFT_DATA_VA=
LUE,
@@ -4535,6 +4544,13 @@ static int nft_get_set_elem(struct nft_ctx *ctx, s=
truct nft_set *set,
 	if (err < 0)
 		return err;
=20
+	if (nla[NFTA_SET_ELEM_KEY_END]) {
+		err =3D nft_setelem_parse_key(ctx, set, &elem.key_end.val,
+					    nla[NFTA_SET_ELEM_KEY_END]);
+		if (err < 0)
+			return err;
+	}
+
 	priv =3D set->ops->get(ctx->net, set, &elem, flags);
 	if (IS_ERR(priv))
 		return PTR_ERR(priv);
@@ -4660,8 +4676,8 @@ static struct nft_trans *nft_trans_elem_alloc(struc=
t nft_ctx *ctx,
=20
 void *nft_set_elem_init(const struct nft_set *set,
 			const struct nft_set_ext_tmpl *tmpl,
-			const u32 *key, const u32 *data,
-			u64 timeout, u64 expiration, gfp_t gfp)
+			const u32 *key, const u32 *key_end,
+			const u32 *data, u64 timeout, u64 expiration, gfp_t gfp)
 {
 	struct nft_set_ext *ext;
 	void *elem;
@@ -4674,6 +4690,8 @@ void *nft_set_elem_init(const struct nft_set *set,
 	nft_set_ext_init(ext, tmpl);
=20
 	memcpy(nft_set_ext_key(ext), key, set->klen);
+	if (nft_set_ext_exists(ext, NFT_SET_EXT_KEY_END))
+		memcpy(nft_set_ext_key_end(ext), key_end, set->klen);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_DATA))
 		memcpy(nft_set_ext_data(ext), data, set->dlen);
 	if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
@@ -4808,9 +4826,19 @@ static int nft_add_set_elem(struct nft_ctx *ctx, s=
truct nft_set *set,
 	err =3D nft_setelem_parse_key(ctx, set, &elem.key.val,
 				    nla[NFTA_SET_ELEM_KEY]);
 	if (err < 0)
-		goto err1;
+		return err;
=20
 	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
+
+	if (nla[NFTA_SET_ELEM_KEY_END]) {
+		err =3D nft_setelem_parse_key(ctx, set, &elem.key_end.val,
+					    nla[NFTA_SET_ELEM_KEY_END]);
+		if (err < 0)
+			goto err_parse_key;
+
+		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
+	}
+
 	if (timeout > 0) {
 		nft_set_ext_add(&tmpl, NFT_SET_EXT_EXPIRATION);
 		if (timeout !=3D set->timeout)
@@ -4820,14 +4848,14 @@ static int nft_add_set_elem(struct nft_ctx *ctx, =
struct nft_set *set,
 	if (nla[NFTA_SET_ELEM_OBJREF] !=3D NULL) {
 		if (!(set->flags & NFT_SET_OBJECT)) {
 			err =3D -EINVAL;
-			goto err2;
+			goto err_parse_key_end;
 		}
 		obj =3D nft_obj_lookup(ctx->net, ctx->table,
 				     nla[NFTA_SET_ELEM_OBJREF],
 				     set->objtype, genmask);
 		if (IS_ERR(obj)) {
 			err =3D PTR_ERR(obj);
-			goto err2;
+			goto err_parse_key_end;
 		}
 		nft_set_ext_add(&tmpl, NFT_SET_EXT_OBJREF);
 	}
@@ -4836,11 +4864,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, =
struct nft_set *set,
 		err =3D nft_data_init(ctx, &data, sizeof(data), &desc,
 				    nla[NFTA_SET_ELEM_DATA]);
 		if (err < 0)
-			goto err2;
+			goto err_parse_key_end;
=20
 		err =3D -EINVAL;
 		if (set->dtype !=3D NFT_DATA_VERDICT && desc.len !=3D set->dlen)
-			goto err3;
+			goto err_parse_data;
=20
 		dreg =3D nft_type_to_reg(set->dtype);
 		list_for_each_entry(binding, &set->bindings, list) {
@@ -4858,7 +4886,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, st=
ruct nft_set *set,
 							  &data,
 							  desc.type, desc.len);
 			if (err < 0)
-				goto err3;
+				goto err_parse_data;
=20
 			if (desc.type =3D=3D NFT_DATA_VERDICT &&
 			    (data.verdict.code =3D=3D NFT_GOTO ||
@@ -4883,10 +4911,11 @@ static int nft_add_set_elem(struct nft_ctx *ctx, =
struct nft_set *set,
 	}
=20
 	err =3D -ENOMEM;
-	elem.priv =3D nft_set_elem_init(set, &tmpl, elem.key.val.data, data.dat=
a,
+	elem.priv =3D nft_set_elem_init(set, &tmpl, elem.key.val.data,
+				      elem.key_end.val.data, data.data,
 				      timeout, expiration, GFP_KERNEL);
 	if (elem.priv =3D=3D NULL)
-		goto err3;
+		goto err_parse_data;
=20
 	ext =3D nft_set_elem_ext(set, elem.priv);
 	if (flags)
@@ -4903,7 +4932,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, st=
ruct nft_set *set,
=20
 	trans =3D nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
 	if (trans =3D=3D NULL)
-		goto err4;
+		goto err_trans;
=20
 	ext->genmask =3D nft_genmask_cur(ctx->net) | NFT_SET_ELEM_BUSY_MASK;
 	err =3D set->ops->insert(ctx->net, set, &elem, &ext2);
@@ -4914,7 +4943,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, st=
ruct nft_set *set,
 			    nft_set_ext_exists(ext, NFT_SET_EXT_OBJREF) ^
 			    nft_set_ext_exists(ext2, NFT_SET_EXT_OBJREF)) {
 				err =3D -EBUSY;
-				goto err5;
+				goto err_element_clash;
 			}
 			if ((nft_set_ext_exists(ext, NFT_SET_EXT_DATA) &&
 			     nft_set_ext_exists(ext2, NFT_SET_EXT_DATA) &&
@@ -4927,33 +4956,35 @@ static int nft_add_set_elem(struct nft_ctx *ctx, =
struct nft_set *set,
 			else if (!(nlmsg_flags & NLM_F_EXCL))
 				err =3D 0;
 		}
-		goto err5;
+		goto err_element_clash;
 	}
=20
 	if (set->size &&
 	    !atomic_add_unless(&set->nelems, 1, set->size + set->ndeact)) {
 		err =3D -ENFILE;
-		goto err6;
+		goto err_set_full;
 	}
=20
 	nft_trans_elem(trans) =3D elem;
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 	return 0;
=20
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
 	if (nla[NFTA_SET_ELEM_DATA] !=3D NULL)
 		nft_data_release(&data, desc.type);
-err2:
+err_parse_key_end:
+	nft_data_release(&elem.key_end.val, NFT_DATA_VALUE);
+err_parse_key:
 	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
-err1:
+
 	return err;
 }
=20
@@ -5078,9 +5109,19 @@ static int nft_del_setelem(struct nft_ctx *ctx, st=
ruct nft_set *set,
=20
 	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
=20
+	if (nla[NFTA_SET_ELEM_KEY_END]) {
+		err =3D nft_setelem_parse_key(ctx, set, &elem.key_end.val,
+					    nla[NFTA_SET_ELEM_KEY_END]);
+		if (err < 0)
+			return err;
+
+		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY_END, set->klen);
+	}
+
 	err =3D -ENOMEM;
-	elem.priv =3D nft_set_elem_init(set, &tmpl, elem.key.val.data, NULL, 0,
-				      0, GFP_KERNEL);
+	elem.priv =3D nft_set_elem_init(set, &tmpl, elem.key.val.data,
+				      elem.key_end.val.data, NULL, 0, 0,
+				      GFP_KERNEL);
 	if (elem.priv =3D=3D NULL)
 		goto fail_elem;
=20
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 8887295414dc..683785225a3e 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -54,7 +54,7 @@ static void *nft_dynset_new(struct nft_set *set, const =
struct nft_expr *expr,
=20
 	timeout =3D priv->timeout ? : set->timeout;
 	elem =3D nft_set_elem_init(set, &priv->tmpl,
-				 &regs->data[priv->sreg_key],
+				 &regs->data[priv->sreg_key], NULL,
 				 &regs->data[priv->sreg_data],
 				 timeout, 0, GFP_ATOMIC);
 	if (elem =3D=3D NULL)
--=20
2.24.1

