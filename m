Return-Path: <SRS0=vOmJ=3I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF47BC33CB1
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 13:33:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AB7DD2072B
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 13:33:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e43xjoJ/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727041AbgASNdi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Jan 2020 08:33:38 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42562 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726778AbgASNdi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Jan 2020 08:33:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579440816;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MN84y9cdfOxo6ARVIDWTdnZq2ObjDad/xMalCLfXKWA=;
        b=e43xjoJ/QCArCMmgOVPU4Ln/erQoxMJyzNh7UKAUDaCaVCRlnzNKuUNDs5z3SIfPoCpy1i
        mCyoxdedobPt6RLXPdDguP6Pi8rQB1DJ7TwKbETEnE1/PCPxhHGifS7/uQievL93OCUYl+
        q/CJP5Fz0BG80bZDsa/Fkl7IXyR/6MM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-76-7P8TzBYJMzyBgzC6lvQflw-1; Sun, 19 Jan 2020 08:33:31 -0500
X-MC-Unique: 7P8TzBYJMzyBgzC6lvQflw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B9A44100550E;
        Sun, 19 Jan 2020 13:33:29 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F293C5D9CA;
        Sun, 19 Jan 2020 13:33:26 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next v3 1/9] netfilter: nf_tables: add nft_setelem_parse_key()
Date:   Sun, 19 Jan 2020 14:33:13 +0100
Message-Id: <cd16c6687bdf9616110f769b83933988a7078f0f.1579434906.git.sbrivio@redhat.com>
In-Reply-To: <cover.1579434906.git.sbrivio@redhat.com>
References: <cover.1579434906.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

Add helper function to parse the set element key netlink attribute.

v3: New patch

[sbrivio: refactor error paths and labels; use NFT_DATA_VALUE_MAXLEN
  instead of sizeof(*key) in helper, value can be longer than that;
  rebase]
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nf_tables_api.c | 91 +++++++++++++++++------------------
 1 file changed, 45 insertions(+), 46 deletions(-)

diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.=
c
index 43f05b3acd60..0628b9ad7aa4 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4490,11 +4490,28 @@ static int nft_setelem_parse_flags(const struct n=
ft_set *set,
 	return 0;
 }
=20
+static int nft_setelem_parse_key(struct nft_ctx *ctx, struct nft_set *se=
t,
+				 struct nft_data *key, struct nlattr *attr)
+{
+	struct nft_data_desc desc;
+	int err;
+
+	err =3D nft_data_init(ctx, key, NFT_DATA_VALUE_MAXLEN, &desc, attr);
+	if (err < 0)
+		return err;
+
+	if (desc.type !=3D NFT_DATA_VALUE || desc.len !=3D set->klen) {
+		nft_data_release(key, desc.type);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 static int nft_get_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr)
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
-	struct nft_data_desc desc;
 	struct nft_set_elem elem;
 	struct sk_buff *skb;
 	uint32_t flags =3D 0;
@@ -4513,17 +4530,11 @@ static int nft_get_set_elem(struct nft_ctx *ctx, =
struct nft_set *set,
 	if (err < 0)
 		return err;
=20
-	err =3D nft_data_init(ctx, &elem.key.val, sizeof(elem.key), &desc,
-			    nla[NFTA_SET_ELEM_KEY]);
+	err =3D nft_setelem_parse_key(ctx, set, &elem.key.val,
+				    nla[NFTA_SET_ELEM_KEY]);
 	if (err < 0)
 		return err;
=20
-	err =3D -EINVAL;
-	if (desc.type !=3D NFT_DATA_VALUE || desc.len !=3D set->klen) {
-		nft_data_release(&elem.key.val, desc.type);
-		return err;
-	}
-
 	priv =3D set->ops->get(ctx->net, set, &elem, flags);
 	if (IS_ERR(priv))
 		return PTR_ERR(priv);
@@ -4722,13 +4733,13 @@ static int nft_add_set_elem(struct nft_ctx *ctx, =
struct nft_set *set,
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
 	u8 genmask =3D nft_genmask_next(ctx->net);
-	struct nft_data_desc d1, d2;
 	struct nft_set_ext_tmpl tmpl;
 	struct nft_set_ext *ext, *ext2;
 	struct nft_set_elem elem;
 	struct nft_set_binding *binding;
 	struct nft_object *obj =3D NULL;
 	struct nft_userdata *udata;
+	struct nft_data_desc desc;
 	struct nft_data data;
 	enum nft_registers dreg;
 	struct nft_trans *trans;
@@ -4794,15 +4805,12 @@ static int nft_add_set_elem(struct nft_ctx *ctx, =
struct nft_set *set,
 			return err;
 	}
=20
-	err =3D nft_data_init(ctx, &elem.key.val, sizeof(elem.key), &d1,
-			    nla[NFTA_SET_ELEM_KEY]);
+	err =3D nft_setelem_parse_key(ctx, set, &elem.key.val,
+				    nla[NFTA_SET_ELEM_KEY]);
 	if (err < 0)
 		goto err1;
-	err =3D -EINVAL;
-	if (d1.type !=3D NFT_DATA_VALUE || d1.len !=3D set->klen)
-		goto err2;
=20
-	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, d1.len);
+	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
 	if (timeout > 0) {
 		nft_set_ext_add(&tmpl, NFT_SET_EXT_EXPIRATION);
 		if (timeout !=3D set->timeout)
@@ -4825,13 +4833,13 @@ static int nft_add_set_elem(struct nft_ctx *ctx, =
struct nft_set *set,
 	}
=20
 	if (nla[NFTA_SET_ELEM_DATA] !=3D NULL) {
-		err =3D nft_data_init(ctx, &data, sizeof(data), &d2,
+		err =3D nft_data_init(ctx, &data, sizeof(data), &desc,
 				    nla[NFTA_SET_ELEM_DATA]);
 		if (err < 0)
 			goto err2;
=20
 		err =3D -EINVAL;
-		if (set->dtype !=3D NFT_DATA_VERDICT && d2.len !=3D set->dlen)
+		if (set->dtype !=3D NFT_DATA_VERDICT && desc.len !=3D set->dlen)
 			goto err3;
=20
 		dreg =3D nft_type_to_reg(set->dtype);
@@ -4848,18 +4856,18 @@ static int nft_add_set_elem(struct nft_ctx *ctx, =
struct nft_set *set,
=20
 			err =3D nft_validate_register_store(&bind_ctx, dreg,
 							  &data,
-							  d2.type, d2.len);
+							  desc.type, desc.len);
 			if (err < 0)
 				goto err3;
=20
-			if (d2.type =3D=3D NFT_DATA_VERDICT &&
+			if (desc.type =3D=3D NFT_DATA_VERDICT &&
 			    (data.verdict.code =3D=3D NFT_GOTO ||
 			     data.verdict.code =3D=3D NFT_JUMP))
 				nft_validate_state_update(ctx->net,
 							  NFT_VALIDATE_NEED);
 		}
=20
-		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_DATA, d2.len);
+		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_DATA, desc.len);
 	}
=20
 	/* The full maximum length of userdata can exceed the maximum
@@ -4942,9 +4950,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, st=
ruct nft_set *set,
 	kfree(elem.priv);
 err3:
 	if (nla[NFTA_SET_ELEM_DATA] !=3D NULL)
-		nft_data_release(&data, d2.type);
+		nft_data_release(&data, desc.type);
 err2:
-	nft_data_release(&elem.key.val, d1.type);
+	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
 err1:
 	return err;
 }
@@ -5040,7 +5048,6 @@ static int nft_del_setelem(struct nft_ctx *ctx, str=
uct nft_set *set,
 {
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
 	struct nft_set_ext_tmpl tmpl;
-	struct nft_data_desc desc;
 	struct nft_set_elem elem;
 	struct nft_set_ext *ext;
 	struct nft_trans *trans;
@@ -5051,11 +5058,10 @@ static int nft_del_setelem(struct nft_ctx *ctx, s=
truct nft_set *set,
 	err =3D nla_parse_nested_deprecated(nla, NFTA_SET_ELEM_MAX, attr,
 					  nft_set_elem_policy, NULL);
 	if (err < 0)
-		goto err1;
+		return err;
=20
-	err =3D -EINVAL;
 	if (nla[NFTA_SET_ELEM_KEY] =3D=3D NULL)
-		goto err1;
+		return -EINVAL;
=20
 	nft_set_ext_prepare(&tmpl);
=20
@@ -5065,37 +5071,31 @@ static int nft_del_setelem(struct nft_ctx *ctx, s=
truct nft_set *set,
 	if (flags !=3D 0)
 		nft_set_ext_add(&tmpl, NFT_SET_EXT_FLAGS);
=20
-	err =3D nft_data_init(ctx, &elem.key.val, sizeof(elem.key), &desc,
-			    nla[NFTA_SET_ELEM_KEY]);
+	err =3D nft_setelem_parse_key(ctx, set, &elem.key.val,
+				    nla[NFTA_SET_ELEM_KEY]);
 	if (err < 0)
-		goto err1;
-
-	err =3D -EINVAL;
-	if (desc.type !=3D NFT_DATA_VALUE || desc.len !=3D set->klen)
-		goto err2;
+		return err;
=20
-	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, desc.len);
+	nft_set_ext_add_length(&tmpl, NFT_SET_EXT_KEY, set->klen);
=20
 	err =3D -ENOMEM;
 	elem.priv =3D nft_set_elem_init(set, &tmpl, elem.key.val.data, NULL, 0,
 				      0, GFP_KERNEL);
 	if (elem.priv =3D=3D NULL)
-		goto err2;
+		goto fail_elem;
=20
 	ext =3D nft_set_elem_ext(set, elem.priv);
 	if (flags)
 		*nft_set_ext_flags(ext) =3D flags;
=20
 	trans =3D nft_trans_elem_alloc(ctx, NFT_MSG_DELSETELEM, set);
-	if (trans =3D=3D NULL) {
-		err =3D -ENOMEM;
-		goto err3;
-	}
+	if (trans =3D=3D NULL)
+		goto fail_trans;
=20
 	priv =3D set->ops->deactivate(ctx->net, set, &elem);
 	if (priv =3D=3D NULL) {
 		err =3D -ENOENT;
-		goto err4;
+		goto fail_ops;
 	}
 	kfree(elem.priv);
 	elem.priv =3D priv;
@@ -5106,13 +5106,12 @@ static int nft_del_setelem(struct nft_ctx *ctx, s=
truct nft_set *set,
 	list_add_tail(&trans->list, &ctx->net->nft.commit_list);
 	return 0;
=20
-err4:
+fail_ops:
 	kfree(trans);
-err3:
+fail_trans:
 	kfree(elem.priv);
-err2:
-	nft_data_release(&elem.key.val, desc.type);
-err1:
+fail_elem:
+	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
 	return err;
 }
=20
--=20
2.24.1

