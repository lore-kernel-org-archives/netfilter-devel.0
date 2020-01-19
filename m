Return-Path: <SRS0=vOmJ=3I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 462BDC47409
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 13:33:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1CCAB20663
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 13:33:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PbolnCPm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbgASNdj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Jan 2020 08:33:39 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:56725 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727011AbgASNdj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Jan 2020 08:33:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579440817;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L8a1Eoglt4rW+Ki/jVuQ5vG6sG2m51A+MvccfKnV+Po=;
        b=PbolnCPm0QWEtEKhLPW6ga3FI/StxEpeJDuaIzzALz6wM3cH6Fs0fzHmYrokGq3v6ABYB3
        b/GC9152acipmfzD47/l/MhU7Hd3uWFpfm4f7v9uZ8948VjRsMTrAScood0xWf3sDsdXtF
        FjzHIvFAUjGKj38nkSBK0yt1WjWTDhM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-37-AW0mF2ZrMpexjHbmTew2CA-1; Sun, 19 Jan 2020 08:33:36 -0500
X-MC-Unique: AW0mF2ZrMpexjHbmTew2CA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B4E55100550E;
        Sun, 19 Jan 2020 13:33:34 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C31525D9CA;
        Sun, 19 Jan 2020 13:33:32 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next v3 3/9] netfilter: nf_tables: Support for sets with multiple ranged fields
Date:   Sun, 19 Jan 2020 14:33:15 +0100
Message-Id: <c02a408d46aa24c42cf594125f101eb935595904.1579434906.git.sbrivio@redhat.com>
In-Reply-To: <cover.1579434906.git.sbrivio@redhat.com>
References: <cover.1579434906.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce a new nested netlink attribute, NFTA_SET_DESC_CONCAT, used
to specify the length of each field in a set concatenation.

This allows set implementations to support concatenation of multiple
ranged items, as they can divide the input key into matching data for
every single field. Such set implementations would be selected as
they specify support for NFT_SET_INTERVAL and allow desc->field_count
to be greater than one. Explicitly disallow this for nft_set_rbtree.

In order to specify the interval for a set entry, userspace would
include in NFTA_SET_DESC_CONCAT attributes field lengths, and pass
range endpoints as two separate keys, represented by attributes
NFTA_SET_ELEM_KEY and NFTA_SET_ELEM_KEY_END.

While at it, export the number of 32-bit registers available for
packet matching, as nftables will need this to know the maximum
number of field lengths that can be specified.

For example, "packets with an IPv4 address between 192.0.2.0 and
192.0.2.42, with destination port between 22 and 25", can be
expressed as two concatenated elements:

  NFTA_SET_ELEM_KEY:            192.0.2.0 . 22
  NFTA_SET_ELEM_KEY_END:        192.0.2.42 . 25

and NFTA_SET_DESC_CONCAT attribute would contain:

  NFTA_LIST_ELEM
    NFTA_SET_FIELD_LEN:		4
  NFTA_LIST_ELEM
    NFTA_SET_FIELD_LEN:		2

v3: Complete rework, NFTA_SET_DESC_CONCAT instead of NFTA_SET_SUBKEY
v2: No changes

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 include/net/netfilter/nf_tables.h        |  8 +++
 include/uapi/linux/netfilter/nf_tables.h | 15 ++++
 net/netfilter/nf_tables_api.c            | 90 +++++++++++++++++++++++-
 net/netfilter/nft_set_rbtree.c           |  3 +
 4 files changed, 115 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf=
_tables.h
index 504c0aa93805..4170c033d461 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -264,11 +264,15 @@ struct nft_set_iter {
  *	@klen: key length
  *	@dlen: data length
  *	@size: number of set elements
+ *	@field_len: length of each field in concatenation, bytes
+ *	@field_count: number of concatenated fields in element
  */
 struct nft_set_desc {
 	unsigned int		klen;
 	unsigned int		dlen;
 	unsigned int		size;
+	u8			field_len[NFT_REG32_COUNT];
+	u8			field_count;
 };
=20
 /**
@@ -409,6 +413,8 @@ void nft_unregister_set(struct nft_set_type *type);
  * 	@dtype: data type (verdict or numeric type defined by userspace)
  * 	@objtype: object type (see NFT_OBJECT_* definitions)
  * 	@size: maximum set size
+ *	@field_len: length of each field in concatenation, bytes
+ *	@field_count: number of concatenated fields in element
  *	@use: number of rules references to this set
  * 	@nelems: number of elements
  * 	@ndeact: number of deactivated elements queued for removal
@@ -435,6 +441,8 @@ struct nft_set {
 	u32				dtype;
 	u32				objtype;
 	u32				size;
+	u8				field_len[NFT_REG32_COUNT];
+	u8				field_count;
 	u32				use;
 	atomic_t			nelems;
 	u32				ndeact;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linu=
x/netfilter/nf_tables.h
index c13106496bd2..065218a20bb7 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -48,6 +48,7 @@ enum nft_registers {
=20
 #define NFT_REG_SIZE	16
 #define NFT_REG32_SIZE	4
+#define NFT_REG32_COUNT	(NFT_REG32_15 - NFT_REG32_00 + 1)
=20
 /**
  * enum nft_verdicts - nf_tables internal verdicts
@@ -301,14 +302,28 @@ enum nft_set_policies {
  * enum nft_set_desc_attributes - set element description
  *
  * @NFTA_SET_DESC_SIZE: number of elements in set (NLA_U32)
+ * @NFTA_SET_DESC_CONCAT: description of field concatenation (NLA_NESTED=
)
  */
 enum nft_set_desc_attributes {
 	NFTA_SET_DESC_UNSPEC,
 	NFTA_SET_DESC_SIZE,
+	NFTA_SET_DESC_CONCAT,
 	__NFTA_SET_DESC_MAX
 };
 #define NFTA_SET_DESC_MAX	(__NFTA_SET_DESC_MAX - 1)
=20
+/**
+ * enum nft_set_field_attributes - attributes of concatenated fields
+ *
+ * @NFTA_SET_FIELD_LEN: length of single field, in bits (NLA_U32)
+ */
+enum nft_set_field_attributes {
+	NFTA_SET_FIELD_UNSPEC,
+	NFTA_SET_FIELD_LEN,
+	__NFTA_SET_FIELD_MAX
+};
+#define NFTA_SET_FIELD_MAX	(__NFTA_SET_FIELD_MAX - 1)
+
 /**
  * enum nft_set_attributes - nf_tables set netlink attributes
  *
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.=
c
index 6cfd65348958..767688e5673c 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3358,6 +3358,7 @@ static const struct nla_policy nft_set_policy[NFTA_=
SET_MAX + 1] =3D {
=20
 static const struct nla_policy nft_set_desc_policy[NFTA_SET_DESC_MAX + 1=
] =3D {
 	[NFTA_SET_DESC_SIZE]		=3D { .type =3D NLA_U32 },
+	[NFTA_SET_DESC_CONCAT]		=3D { .type =3D NLA_NESTED },
 };
=20
 static int nft_ctx_init_from_setattr(struct nft_ctx *ctx, struct net *ne=
t,
@@ -3524,6 +3525,33 @@ static __be64 nf_jiffies64_to_msecs(u64 input)
 	return cpu_to_be64(jiffies64_to_msecs(input));
 }
=20
+static int nf_tables_fill_set_concat(struct sk_buff *skb,
+				     const struct nft_set *set)
+{
+	struct nlattr *concat, *field;
+	int i;
+
+	concat =3D nla_nest_start_noflag(skb, NFTA_SET_DESC_CONCAT);
+	if (!concat)
+		return -ENOMEM;
+
+	for (i =3D 0; i < set->field_count; i++) {
+		field =3D nla_nest_start_noflag(skb, NFTA_LIST_ELEM);
+		if (!field)
+			return -ENOMEM;
+
+		if (nla_put_be32(skb, NFTA_SET_FIELD_LEN,
+				 htonl(set->field_len[i])))
+			return -ENOMEM;
+
+		nla_nest_end(skb, field);
+	}
+
+	nla_nest_end(skb, concat);
+
+	return 0;
+}
+
 static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx =
*ctx,
 			      const struct nft_set *set, u16 event, u16 flags)
 {
@@ -3587,11 +3615,17 @@ static int nf_tables_fill_set(struct sk_buff *skb=
, const struct nft_ctx *ctx,
 		goto nla_put_failure;
=20
 	desc =3D nla_nest_start_noflag(skb, NFTA_SET_DESC);
+
 	if (desc =3D=3D NULL)
 		goto nla_put_failure;
 	if (set->size &&
 	    nla_put_be32(skb, NFTA_SET_DESC_SIZE, htonl(set->size)))
 		goto nla_put_failure;
+
+	if (set->field_count > 1 &&
+	    nf_tables_fill_set_concat(skb, set))
+		goto nla_put_failure;
+
 	nla_nest_end(skb, desc);
=20
 	nlmsg_end(skb, nlh);
@@ -3764,6 +3798,53 @@ static int nf_tables_getset(struct net *net, struc=
t sock *nlsk,
 	return err;
 }
=20
+static const struct nla_policy nft_concat_policy[NFTA_SET_FIELD_MAX + 1]=
 =3D {
+	[NFTA_SET_FIELD_LEN]	=3D { .type =3D NLA_U32 },
+};
+
+static int nft_set_desc_concat_parse(const struct nlattr *attr,
+				     struct nft_set_desc *desc)
+{
+	struct nlattr *tb[NFTA_SET_FIELD_MAX + 1];
+	u32 len;
+	int err;
+
+	err =3D nla_parse_nested_deprecated(tb, NFTA_SET_FIELD_MAX, attr,
+					  nft_concat_policy, NULL);
+	if (err < 0)
+		return err;
+
+	if (!tb[NFTA_SET_FIELD_LEN])
+		return -EINVAL;
+
+	len =3D ntohl(nla_get_be32(tb[NFTA_SET_FIELD_LEN]));
+
+	if (len * BITS_PER_BYTE / 32 > NFT_REG32_COUNT)
+		return -E2BIG;
+
+	desc->field_len[desc->field_count++] =3D len;
+
+	return 0;
+}
+
+static int nft_set_desc_concat(struct nft_set_desc *desc,
+			       const struct nlattr *nla)
+{
+	struct nlattr *attr;
+	int rem, err;
+
+	nla_for_each_nested(attr, nla, rem) {
+		if (nla_type(attr) !=3D NFTA_LIST_ELEM)
+			return -EINVAL;
+
+		err =3D nft_set_desc_concat_parse(attr, desc);
+		if (err < 0)
+			return err;
+	}
+
+	return 0;
+}
+
 static int nf_tables_set_desc_parse(struct nft_set_desc *desc,
 				    const struct nlattr *nla)
 {
@@ -3777,8 +3858,10 @@ static int nf_tables_set_desc_parse(struct nft_set=
_desc *desc,
=20
 	if (da[NFTA_SET_DESC_SIZE] !=3D NULL)
 		desc->size =3D ntohl(nla_get_be32(da[NFTA_SET_DESC_SIZE]));
+	if (da[NFTA_SET_DESC_CONCAT])
+		err =3D nft_set_desc_concat(desc, da[NFTA_SET_DESC_CONCAT]);
=20
-	return 0;
+	return err;
 }
=20
 static int nf_tables_newset(struct net *net, struct sock *nlsk,
@@ -3801,6 +3884,7 @@ static int nf_tables_newset(struct net *net, struct=
 sock *nlsk,
 	unsigned char *udata;
 	u16 udlen;
 	int err;
+	int i;
=20
 	if (nla[NFTA_SET_TABLE] =3D=3D NULL ||
 	    nla[NFTA_SET_NAME] =3D=3D NULL ||
@@ -3979,6 +4063,10 @@ static int nf_tables_newset(struct net *net, struc=
t sock *nlsk,
 	set->gc_int =3D gc_int;
 	set->handle =3D nf_tables_alloc_handle(table);
=20
+	set->field_count =3D desc.field_count;
+	for (i =3D 0; i < desc.field_count; i++)
+		set->field_len[i] =3D desc.field_len[i];
+
 	err =3D ops->init(set, &desc, nla);
 	if (err < 0)
 		goto err3;
diff --git a/net/netfilter/nft_set_rbtree.c b/net/netfilter/nft_set_rbtre=
e.c
index a9f804f7a04a..5000b938ab1e 100644
--- a/net/netfilter/nft_set_rbtree.c
+++ b/net/netfilter/nft_set_rbtree.c
@@ -466,6 +466,9 @@ static void nft_rbtree_destroy(const struct nft_set *=
set)
 static bool nft_rbtree_estimate(const struct nft_set_desc *desc, u32 fea=
tures,
 				struct nft_set_estimate *est)
 {
+	if (desc->field_count > 1)
+		return false;
+
 	if (desc->size)
 		est->size =3D sizeof(struct nft_rbtree) +
 			    desc->size * sizeof(struct nft_rbtree_elem);
--=20
2.24.1

