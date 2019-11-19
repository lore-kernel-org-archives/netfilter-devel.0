Return-Path: <SRS0=iRt+=ZL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53694C432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 01:07:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 27DF620730
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 01:07:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OHsCqKqG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727202AbfKSBHe (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 20:07:34 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57371 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726962AbfKSBHd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 20:07:33 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574125651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=PkRmp9dsWaTioL48z8B7QPkmRAmVp9sNMZPSrQCpMuQ=;
        b=OHsCqKqGCaR/T0M7OONbvk7T7EebwQnBEeKpJaAX/9Xbx9VCTk7sDPI59cpnBpZWemFM3i
        v86V4EB2x/ZeTIrOxlrtHaldNK41y0f7bjsL94tzCgXh1OjHXmDLWO3CF0/YREexwdwjNU
        eQtX7ZUfwsCQ8Oz8aM5JUu/I89xZFkQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-205-xp0VN0DqM86_aNZWzIklZw-1; Mon, 18 Nov 2019 20:07:28 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 03EBA8024CC;
        Tue, 19 Nov 2019 01:07:27 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E54F62AF7A;
        Tue, 19 Nov 2019 01:07:24 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH libnftnl] set: Add support for NFTA_SET_SUBKEY attributes
Date:   Tue, 19 Nov 2019 02:07:23 +0100
Message-Id: <20191119010723.39368-1-sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: xp0VN0DqM86_aNZWzIklZw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the NFTNL_SET_SUBKEY flag is passed, send one NFTA_SET_SUBKEY
attributes per set subkey_len attribute in the set description.

Note that our internal representation, and nftables storage, for
these attributes, is 8-bit wide, but the kernel uses 32 bits. As
field length is expressed in bits, this is probably a good
compromise to keep the UAPI future-proof and memory footprint to
a minimum, for the moment being.

This is the libnftnl counterpart for nftables patch:
  src: Add support for and export NFT_SET_SUBKEY attributes

and depends on the UAPI changes from patch:
  [PATCH nf-next 1/8] netfilter: nf_tables: Support for subkeys, set with m=
ultiple ranged fields

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
I'm not updating the UAPI header copy in this series, please
let me know if I'd better do that.

 include/libnftnl/set.h |  1 +
 include/set.h          |  2 ++
 src/set.c              | 28 ++++++++++++++++++++++++++++
 3 files changed, 31 insertions(+)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index db3fa68..0a5e02a 100644
--- a/include/libnftnl/set.h
+++ b/include/libnftnl/set.h
@@ -29,6 +29,7 @@ enum nftnl_set_attr {
 =09NFTNL_SET_USERDATA,
 =09NFTNL_SET_OBJ_TYPE,
 =09NFTNL_SET_HANDLE,
+=09NFTNL_SET_SUBKEY,
 =09__NFTNL_SET_MAX
 };
 #define NFTNL_SET_MAX (__NFTNL_SET_MAX - 1)
diff --git a/include/set.h b/include/set.h
index 446acd2..41d5dba 100644
--- a/include/set.h
+++ b/include/set.h
@@ -31,6 +31,8 @@ struct nftnl_set {
 =09uint32_t=09=09flags;
 =09uint32_t=09=09gc_interval;
 =09uint64_t=09=09timeout;
+
+=09uint8_t=09=09=09subkey_len[NFT_REG32_COUNT];
 };
=20
 struct nftnl_set_list;
diff --git a/src/set.c b/src/set.c
index 78447c6..60a46d8 100644
--- a/src/set.c
+++ b/src/set.c
@@ -91,6 +91,7 @@ void nftnl_set_unset(struct nftnl_set *s, uint16_t attr)
 =09case NFTNL_SET_DESC_SIZE:
 =09case NFTNL_SET_TIMEOUT:
 =09case NFTNL_SET_GC_INTERVAL:
+=09case NFTNL_SET_SUBKEY:
 =09=09break;
 =09case NFTNL_SET_USERDATA:
 =09=09xfree(s->user.data);
@@ -115,6 +116,7 @@ static uint32_t nftnl_set_validate[NFTNL_SET_MAX + 1] =
=3D {
 =09[NFTNL_SET_DESC_SIZE]=09=3D sizeof(uint32_t),
 =09[NFTNL_SET_TIMEOUT]=09=09=3D sizeof(uint64_t),
 =09[NFTNL_SET_GC_INTERVAL]=09=3D sizeof(uint32_t),
+=09[NFTNL_SET_SUBKEY]=09=09=3D sizeof(uint8_t) * NFT_REG32_COUNT,
 };
=20
 EXPORT_SYMBOL(nftnl_set_set_data);
@@ -190,6 +192,9 @@ int nftnl_set_set_data(struct nftnl_set *s, uint16_t at=
tr, const void *data,
 =09=09memcpy(s->user.data, data, data_len);
 =09=09s->user.len =3D data_len;
 =09=09break;
+=09case NFTNL_SET_SUBKEY:
+=09=09memcpy(s->subkey_len, data, data_len);
+=09=09break;
 =09}
 =09s->flags |=3D (1 << attr);
 =09return 0;
@@ -361,6 +366,23 @@ nftnl_set_nlmsg_build_desc_payload(struct nlmsghdr *nl=
h, struct nftnl_set *s)
 =09mnl_attr_nest_end(nlh, nest);
 }
=20
+static void
+nftnl_set_nlmsg_build_subkey_payload(struct nlmsghdr *nlh, struct nftnl_se=
t *s)
+{
+=09struct nlattr *nest;
+=09uint32_t v;
+=09uint8_t *l;
+
+=09nest =3D mnl_attr_nest_start(nlh, NFTA_SET_SUBKEY);
+=09for (l =3D s->subkey_len; l - s->subkey_len < NFT_REG32_COUNT; l++) {
+=09=09if (!*l)
+=09=09=09break;
+=09=09v =3D *l;
+=09=09mnl_attr_put_u32(nlh, NFTA_SET_SUBKEY_LEN, htonl(v));
+=09}
+=09mnl_attr_nest_end(nlh, nest);
+}
+
 EXPORT_SYMBOL(nftnl_set_nlmsg_build_payload);
 void nftnl_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_set =
*s)
 {
@@ -395,6 +417,8 @@ void nftnl_set_nlmsg_build_payload(struct nlmsghdr *nlh=
, struct nftnl_set *s)
 =09=09mnl_attr_put_u32(nlh, NFTA_SET_GC_INTERVAL, htonl(s->gc_interval));
 =09if (s->flags & (1 << NFTNL_SET_USERDATA))
 =09=09mnl_attr_put(nlh, NFTA_SET_USERDATA, s->user.len, s->user.data);
+=09if (s->flags & (1 << NFTNL_SET_SUBKEY))
+=09=09nftnl_set_nlmsg_build_subkey_payload(nlh, s);
 }
=20
=20
@@ -439,6 +463,10 @@ static int nftnl_set_parse_attr_cb(const struct nlattr=
 *attr, void *data)
 =09=09if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
 =09=09=09abi_breakage();
 =09=09break;
+=09case NFTA_SET_SUBKEY:
+=09=09if (mnl_attr_validate(attr, MNL_TYPE_NESTED) < 0)
+=09=09=09abi_breakage();
+=09=09break;
 =09}
=20
 =09tb[type] =3D attr;
--=20
2.23.0

