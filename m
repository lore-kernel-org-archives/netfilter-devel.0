Return-Path: <SRS0=vOmJ=3I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56416C33CB1
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 13:35:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2903020663
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 13:35:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DPt6DTqN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727107AbgASNfl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Jan 2020 08:35:41 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25144 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727045AbgASNfk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Jan 2020 08:35:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579440939;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TLUsjERWNUFahymOZ67xW0IO1SHse49SM7XFB+hDjic=;
        b=DPt6DTqN6Rj0p6thPEFCEU6Z5+/0EQ3bZwCrdipzTLeS/Cqibhkr0e+mzYHLPu/wQISjHL
        f9G05b6ZK4Hm2jxMD/QWkChp3Ncq8VpniGD947NxAOfcfzi+Ne8JqbEeeWzi90SFsWvV39
        XNnX4skppCjeVzzAcWNvTWzE3scgKTU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-2BhOcBvLP5KzttF7c6CT3A-1; Sun, 19 Jan 2020 08:35:36 -0500
X-MC-Unique: 2BhOcBvLP5KzttF7c6CT3A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E59B0DB62;
        Sun, 19 Jan 2020 13:35:34 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD9F088873;
        Sun, 19 Jan 2020 13:35:32 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH libnftnl v3 2/2] set_elem: Introduce support for NFTNL_SET_ELEM_KEY_END
Date:   Sun, 19 Jan 2020 14:35:26 +0100
Message-Id: <73732b57aa4cbc6de2faf31ca571347e59560e80.1579432712.git.sbrivio@redhat.com>
In-Reply-To: <cover.1579432712.git.sbrivio@redhat.com>
References: <cover.1579432712.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The new set element attribute maps to the netlink attribute
NFTA_SET_ELEM_KEY_END in the same way as NFTNL_SET_ELEM_KEY
maps to NFTA_SET_ELEM_KEY, and represents the key data used
to express the upper bound of a range, in concatenations.

v3: New patch

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 include/libnftnl/set.h |  1 +
 include/set_elem.h     |  1 +
 src/set_elem.c         | 24 ++++++++++++++++++++++++
 3 files changed, 26 insertions(+)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index dcae354b76c4..58d1e7c52f40 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -105,6 +105,7 @@ enum {
 	NFTNL_SET_ELEM_USERDATA,
 	NFTNL_SET_ELEM_EXPR,
 	NFTNL_SET_ELEM_OBJREF,
+	NFTNL_SET_ELEM_KEY_END,
 	__NFTNL_SET_ELEM_MAX
 };
 #define NFTNL_SET_ELEM_MAX (__NFTNL_SET_ELEM_MAX - 1)
diff --git a/include/set_elem.h b/include/set_elem.h
index cc4d52943272..52f185aa11be 100644
--- a/include/set_elem.h
+++ b/include/set_elem.h
@@ -8,6 +8,7 @@ struct nftnl_set_elem {
 	uint32_t		set_elem_flags;
 	uint32_t		flags;
 	union nftnl_data_reg	key;
+	union nftnl_data_reg	key_end;
 	union nftnl_data_reg	data;
 	struct nftnl_expr	*expr;
 	uint64_t		timeout;
diff --git a/src/set_elem.c b/src/set_elem.c
index d3ce807d838c..22031938ebbc 100644
--- a/src/set_elem.c
+++ b/src/set_elem.c
@@ -75,6 +75,7 @@ void nftnl_set_elem_unset(struct nftnl_set_elem *s, uin=
t16_t attr)
 		break;
 	case NFTNL_SET_ELEM_FLAGS:
 	case NFTNL_SET_ELEM_KEY:	/* NFTA_SET_ELEM_KEY */
+	case NFTNL_SET_ELEM_KEY_END:	/* NFTA_SET_ELEM_KEY_END */
 	case NFTNL_SET_ELEM_VERDICT:	/* NFTA_SET_ELEM_DATA */
 	case NFTNL_SET_ELEM_DATA:	/* NFTA_SET_ELEM_DATA */
 	case NFTNL_SET_ELEM_TIMEOUT:	/* NFTA_SET_ELEM_TIMEOUT */
@@ -118,6 +119,10 @@ int nftnl_set_elem_set(struct nftnl_set_elem *s, uin=
t16_t attr,
 		memcpy(&s->key.val, data, data_len);
 		s->key.len =3D data_len;
 		break;
+	case NFTNL_SET_ELEM_KEY_END:	/* NFTA_SET_ELEM_KEY_END */
+		memcpy(&s->key_end.val, data, data_len);
+		s->key_end.len =3D data_len;
+		break;
 	case NFTNL_SET_ELEM_VERDICT:	/* NFTA_SET_ELEM_DATA */
 		memcpy(&s->data.verdict, data, sizeof(s->data.verdict));
 		break;
@@ -193,6 +198,9 @@ const void *nftnl_set_elem_get(struct nftnl_set_elem =
*s, uint16_t attr, uint32_t
 	case NFTNL_SET_ELEM_KEY:	/* NFTA_SET_ELEM_KEY */
 		*data_len =3D s->key.len;
 		return &s->key.val;
+	case NFTNL_SET_ELEM_KEY_END:	/* NFTA_SET_ELEM_KEY_END */
+		*data_len =3D s->key_end.len;
+		return &s->key_end.val;
 	case NFTNL_SET_ELEM_VERDICT:	/* NFTA_SET_ELEM_DATA */
 		*data_len =3D sizeof(s->data.verdict);
 		return &s->data.verdict;
@@ -287,6 +295,14 @@ void nftnl_set_elem_nlmsg_build_payload(struct nlmsg=
hdr *nlh,
 		mnl_attr_put(nlh, NFTA_DATA_VALUE, e->key.len, e->key.val);
 		mnl_attr_nest_end(nlh, nest1);
 	}
+	if (e->flags & (1 << NFTNL_SET_ELEM_KEY_END)) {
+		struct nlattr *nest1;
+
+		nest1 =3D mnl_attr_nest_start(nlh, NFTA_SET_ELEM_KEY_END);
+		mnl_attr_put(nlh, NFTA_DATA_VALUE, e->key_end.len,
+			     e->key_end.val);
+		mnl_attr_nest_end(nlh, nest1);
+	}
 	if (e->flags & (1 << NFTNL_SET_ELEM_VERDICT)) {
 		struct nlattr *nest1, *nest2;
=20
@@ -373,6 +389,7 @@ static int nftnl_set_elem_parse_attr_cb(const struct =
nlattr *attr, void *data)
 			abi_breakage();
 		break;
 	case NFTA_SET_ELEM_KEY:
+	case NFTA_SET_ELEM_KEY_END:
 	case NFTA_SET_ELEM_DATA:
 	case NFTA_SET_ELEM_EXPR:
 		if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
@@ -421,6 +438,13 @@ static int nftnl_set_elems_parse2(struct nftnl_set *=
s, const struct nlattr *nest
 			goto out_set_elem;
 		e->flags |=3D (1 << NFTNL_SET_ELEM_KEY);
         }
+	if (tb[NFTA_SET_ELEM_KEY_END]) {
+		ret =3D nftnl_parse_data(&e->key_end, tb[NFTA_SET_ELEM_KEY_END],
+				       &type);
+		if (ret < 0)
+			goto out_set_elem;
+		e->flags |=3D (1 << NFTNL_SET_ELEM_KEY_END);
+	}
         if (tb[NFTA_SET_ELEM_DATA]) {
 		ret =3D nftnl_parse_data(&e->data, tb[NFTA_SET_ELEM_DATA], &type);
 		if (ret < 0)
--=20
2.24.1

