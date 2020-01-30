Return-Path: <SRS0=SOhW=3T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B26FC2D0DB
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jan 2020 00:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 257932070E
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Jan 2020 00:16:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QITssPI4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726996AbgA3AQt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 Jan 2020 19:16:49 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48649 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726939AbgA3AQs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 Jan 2020 19:16:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580343407;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MvKgv6TgarQ9N0Ncv8Gzii/NSwWTjB9V5Djf9ZIGaOk=;
        b=QITssPI4aF0takDi6Gsqj5MQW70kvv/6vq/4Rt6IS4Z0tE5GCEE0pdDaUpmijQkKpHbvw7
        ohpANBy3nJSIuvEEFIN4WgJbj+oi4A4c3eX9Ao8NTcTKQWXZjwh5TO5ZWWO4O42cmm0Xm0
        lOKvqg/2yEHJGs7GQwPMHWnAblnW5nY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-404-Z7ySXfQ3NqKBoHBvUdNAUA-1; Wed, 29 Jan 2020 19:16:45 -0500
X-MC-Unique: Z7ySXfQ3NqKBoHBvUdNAUA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 92C141005513;
        Thu, 30 Jan 2020 00:16:44 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-200-43.brq.redhat.com [10.40.200.43])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 290E819486;
        Thu, 30 Jan 2020 00:16:41 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH libnftnl v4 2/3] set: Add support for NFTA_SET_DESC_CONCAT attributes
Date:   Thu, 30 Jan 2020 01:16:33 +0100
Message-Id: <ed240166fb60f087865cc94245ae5d46dd29286d.1580342940.git.sbrivio@redhat.com>
In-Reply-To: <cover.1580342940.git.sbrivio@redhat.com>
References: <cover.1580342940.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If NFTNL_SET_DESC_CONCAT data is passed, pass that to the kernel
as NFTA_SET_DESC_CONCAT attributes: it describes the length of
single concatenated fields, in bytes.

Similarly, parse NFTA_SET_DESC_CONCAT attributes if received
from the kernel.

This is the libnftnl counterpart for nftables patch:
  src: Add support for NFTNL_SET_DESC_CONCAT

v4:
 - move NFTNL_SET_DESC_CONCAT to the end of enum nftnl_set_attr
   to avoid ABI breakage (Pablo Neira Ayuso)
v3:
 - use NFTNL_SET_DESC_CONCAT and NFTA_SET_DESC_CONCAT instead of a
   stand-alone NFTA_SET_SUBKEY attribute (Pablo Neira Ayuso)
 - pass field length in bytes instead of bits, fields would get
   unnecessarily big otherwise
v2:
 - fixed grammar in commit message
 - removed copy of array bytes in nftnl_set_nlmsg_build_subkey_payload(),
   we're simply passing values to htonl() (Phil Sutter)

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 include/libnftnl/set.h |   1 +
 include/set.h          |   2 +
 src/set.c              | 111 ++++++++++++++++++++++++++++++++++-------
 3 files changed, 95 insertions(+), 19 deletions(-)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index db3fa686d60a..bbbf58ded99a 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -29,6 +29,7 @@ enum nftnl_set_attr {
 	NFTNL_SET_USERDATA,
 	NFTNL_SET_OBJ_TYPE,
 	NFTNL_SET_HANDLE,
+	NFTNL_SET_DESC_CONCAT,
 	__NFTNL_SET_MAX
 };
 #define NFTNL_SET_MAX (__NFTNL_SET_MAX - 1)
diff --git a/include/set.h b/include/set.h
index 446acd24ca7c..895ffdb48bdb 100644
--- a/include/set.h
+++ b/include/set.h
@@ -25,6 +25,8 @@ struct nftnl_set {
 	enum nft_set_policies	policy;
 	struct {
 		uint32_t	size;
+		uint8_t		field_len[NFT_REG32_COUNT];
+		uint8_t		field_count;
 	} desc;
 	struct list_head	element_list;
=20
diff --git a/src/set.c b/src/set.c
index 78447c676f51..651dcfa56022 100644
--- a/src/set.c
+++ b/src/set.c
@@ -89,6 +89,7 @@ void nftnl_set_unset(struct nftnl_set *s, uint16_t attr=
)
 	case NFTNL_SET_ID:
 	case NFTNL_SET_POLICY:
 	case NFTNL_SET_DESC_SIZE:
+	case NFTNL_SET_DESC_CONCAT:
 	case NFTNL_SET_TIMEOUT:
 	case NFTNL_SET_GC_INTERVAL:
 		break;
@@ -174,6 +175,10 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t=
 attr, const void *data,
 	case NFTNL_SET_DESC_SIZE:
 		memcpy(&s->desc.size, data, sizeof(s->desc.size));
 		break;
+	case NFTNL_SET_DESC_CONCAT:
+		memcpy(&s->desc.field_len, data, data_len);
+		while (s->desc.field_len[++s->desc.field_count]);
+		break;
 	case NFTNL_SET_TIMEOUT:
 		memcpy(&s->timeout, data, sizeof(s->timeout));
 		break;
@@ -266,6 +271,9 @@ const void *nftnl_set_get_data(const struct nftnl_set=
 *s, uint16_t attr,
 	case NFTNL_SET_DESC_SIZE:
 		*data_len =3D sizeof(uint32_t);
 		return &s->desc.size;
+	case NFTNL_SET_DESC_CONCAT:
+		*data_len =3D s->desc.field_count;
+		return s->desc.field_len;
 	case NFTNL_SET_TIMEOUT:
 		*data_len =3D sizeof(uint64_t);
 		return &s->timeout;
@@ -351,13 +359,42 @@ err:
 	return NULL;
 }
=20
+static void nftnl_set_nlmsg_build_desc_size_payload(struct nlmsghdr *nlh=
,
+						    struct nftnl_set *s)
+{
+	mnl_attr_put_u32(nlh, NFTA_SET_DESC_SIZE, htonl(s->desc.size));
+}
+
+static void nftnl_set_nlmsg_build_desc_concat_payload(struct nlmsghdr *n=
lh,
+						      struct nftnl_set *s)
+{
+	struct nlattr *nest;
+	int i;
+
+	nest =3D mnl_attr_nest_start(nlh, NFTA_SET_DESC_CONCAT);
+	for (i =3D 0; i < NFT_REG32_COUNT && i < s->desc.field_count; i++) {
+		struct nlattr *nest_elem;
+
+		nest_elem =3D mnl_attr_nest_start(nlh, NFTA_LIST_ELEM);
+		mnl_attr_put_u32(nlh, NFTA_SET_FIELD_LEN,
+				 htonl(s->desc.field_len[i]));
+		mnl_attr_nest_end(nlh, nest_elem);
+	}
+	mnl_attr_nest_end(nlh, nest);
+}
+
 static void
 nftnl_set_nlmsg_build_desc_payload(struct nlmsghdr *nlh, struct nftnl_se=
t *s)
 {
 	struct nlattr *nest;
=20
 	nest =3D mnl_attr_nest_start(nlh, NFTA_SET_DESC);
-	mnl_attr_put_u32(nlh, NFTA_SET_DESC_SIZE, htonl(s->desc.size));
+
+	if (s->flags & (1 << NFTNL_SET_DESC_SIZE))
+		nftnl_set_nlmsg_build_desc_size_payload(nlh, s);
+	if (s->flags & (1 << NFTNL_SET_DESC_CONCAT))
+		nftnl_set_nlmsg_build_desc_concat_payload(nlh, s);
+
 	mnl_attr_nest_end(nlh, nest);
 }
=20
@@ -387,7 +424,7 @@ void nftnl_set_nlmsg_build_payload(struct nlmsghdr *n=
lh, struct nftnl_set *s)
 		mnl_attr_put_u32(nlh, NFTA_SET_ID, htonl(s->id));
 	if (s->flags & (1 << NFTNL_SET_POLICY))
 		mnl_attr_put_u32(nlh, NFTA_SET_POLICY, htonl(s->policy));
-	if (s->flags & (1 << NFTNL_SET_DESC_SIZE))
+	if (s->flags & (1 << NFTNL_SET_DESC_SIZE | 1 << NFTNL_SET_DESC_CONCAT))
 		nftnl_set_nlmsg_build_desc_payload(nlh, s);
 	if (s->flags & (1 << NFTNL_SET_TIMEOUT))
 		mnl_attr_put_u64(nlh, NFTA_SET_TIMEOUT, htobe64(s->timeout));
@@ -445,39 +482,75 @@ static int nftnl_set_parse_attr_cb(const struct nla=
ttr *attr, void *data)
 	return MNL_CB_OK;
 }
=20
-static int nftnl_set_desc_parse_attr_cb(const struct nlattr *attr, void =
*data)
+static int
+nftnl_set_desc_concat_field_parse_attr_cb(const struct nlattr *attr, voi=
d *data)
+{
+	int type =3D mnl_attr_get_type(attr);
+	struct nftnl_set *s =3D data;
+
+	if (type !=3D NFTA_SET_FIELD_LEN)
+		return MNL_CB_OK;
+
+	if (mnl_attr_validate(attr, MNL_TYPE_U32))
+		return MNL_CB_ERROR;
+
+	s->desc.field_len[s->desc.field_count] =3D ntohl(mnl_attr_get_u32(attr)=
);
+	s->desc.field_count++;
+
+	return MNL_CB_OK;
+}
+
+static int
+nftnl_set_desc_concat_parse_attr_cb(const struct nlattr *attr, void *dat=
a)
 {
-	const struct nlattr **tb =3D data;
 	int type =3D mnl_attr_get_type(attr);
+	struct nftnl_set *s =3D data;
+
+	if (type !=3D NFTA_LIST_ELEM)
+		return MNL_CB_OK;
+
+	return mnl_attr_parse_nested(attr,
+				     nftnl_set_desc_concat_field_parse_attr_cb,
+				     s);
+}
+
+static int nftnl_set_desc_parse_attr_cb(const struct nlattr *attr, void =
*data)
+{
+	int type =3D mnl_attr_get_type(attr), err;
+	struct nftnl_set *s =3D data;
=20
 	if (mnl_attr_type_valid(attr, NFTA_SET_DESC_MAX) < 0)
 		return MNL_CB_OK;
=20
 	switch (type) {
 	case NFTA_SET_DESC_SIZE:
-		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0)
+		if (mnl_attr_validate(attr, MNL_TYPE_U32) < 0) {
 			abi_breakage();
+			break;
+		}
+
+		s->desc.size =3D ntohl(mnl_attr_get_u32(attr));
+		s->flags |=3D (1 << NFTNL_SET_DESC_SIZE);
+		break;
+	case NFTA_SET_DESC_CONCAT:
+		err =3D mnl_attr_parse_nested(attr,
+					    nftnl_set_desc_concat_parse_attr_cb,
+					    s);
+		if (err !=3D MNL_CB_OK)
+			abi_breakage();
+
+		s->flags |=3D (1 << NFTNL_SET_DESC_CONCAT);
+		break;
+	default:
 		break;
 	}
=20
-	tb[type] =3D attr;
 	return MNL_CB_OK;
 }
=20
-static int nftnl_set_desc_parse(struct nftnl_set *s,
-			      const struct nlattr *attr)
+static int nftnl_set_desc_parse(struct nftnl_set *s, const struct nlattr=
 *attr)
 {
-	struct nlattr *tb[NFTA_SET_DESC_MAX + 1] =3D {};
-
-	if (mnl_attr_parse_nested(attr, nftnl_set_desc_parse_attr_cb, tb) < 0)
-		return -1;
-
-	if (tb[NFTA_SET_DESC_SIZE]) {
-		s->desc.size =3D ntohl(mnl_attr_get_u32(tb[NFTA_SET_DESC_SIZE]));
-		s->flags |=3D (1 << NFTNL_SET_DESC_SIZE);
-	}
-
-	return 0;
+	return mnl_attr_parse_nested(attr, nftnl_set_desc_parse_attr_cb, s);
 }
=20
 EXPORT_SYMBOL(nftnl_set_nlmsg_parse);
--=20
2.24.1

