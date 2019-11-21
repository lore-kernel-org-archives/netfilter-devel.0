Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A365C432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:10:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D6FC6206D8
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 17:10:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ca7qsYs/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727008AbfKURKa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 12:10:30 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52356 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726568AbfKURKa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 12:10:30 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574356229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=dT5TTCCVudCntCnFrqKfxhtBKT4A5lXkUNpFpzZU73A=;
        b=ca7qsYs/P3OaXSfJLk0+I2Pd4lxnft6SBtrpG40CfMahYaiLbPjtkf27UOh0X8XRfIAsTd
        nj7JuKrRkZcsZ/c+7/e6h52Phz0jYBZGWJKbRgF+0ufe21e8xDXrCcJkMA+d62pBVzjHCF
        Og7K0y1uht/KTD7DhvFtStKSVqLsY/U=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-3KJXjrlpO2qqGs1rF4gz0Q-1; Thu, 21 Nov 2019 12:10:25 -0500
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 69A9C184CAA5;
        Thu, 21 Nov 2019 17:10:24 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 5025D60141;
        Thu, 21 Nov 2019 17:10:22 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH libnftnl v2] set: Add support for NFTA_SET_SUBKEY attributes
Date:   Thu, 21 Nov 2019 18:10:21 +0100
Message-Id: <de1e8744507f6590886a5cb7eef98f23775ee2fa.1574354321.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-MC-Unique: 3KJXjrlpO2qqGs1rF4gz0Q-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If the NFTNL_SET_SUBKEY flag is passed, send one NFTA_SET_SUBKEY
attribute for each subkey_len attribute in the set description.

Note that our internal representation, and nftables storage, for
these attributes, is 8-bit wide, but the kernel uses 32 bits. As
field length is expressed in bits, this is probably a good
compromise to keep the UAPI future-proof and memory footprint to
a minimum, for the moment being.

This is the libnftnl counterpart for nftables patch:
  src: Add support for and export NFT_SET_SUBKEY attributes

and it has a UAPI dependency on kernel patch:
  [PATCH nf-next 1/8] nf_tables: Support for subkeys, set with multiple ran=
ged fields

v2:
 - fixed grammar in commit message
 - removed copy of array bytes in nftnl_set_nlmsg_build_subkey_payload(),
   we're simply passing values to htonl() (Phil Sutter)

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 include/libnftnl/set.h |  1 +
 include/set.h          |  2 ++
 src/set.c              | 27 +++++++++++++++++++++++++++
 3 files changed, 30 insertions(+)

diff --git a/include/libnftnl/set.h b/include/libnftnl/set.h
index db3fa686d60a..0a5e02aaa74c 100644
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
index 446acd24ca7c..41d5dba286bf 100644
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
index 78447c676f51..2306c10eebae 100644
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
@@ -361,6 +366,22 @@ nftnl_set_nlmsg_build_desc_payload(struct nlmsghdr *nl=
h, struct nftnl_set *s)
 =09mnl_attr_nest_end(nlh, nest);
 }
=20
+static void
+nftnl_set_nlmsg_build_subkey_payload(struct nlmsghdr *nlh, struct nftnl_se=
t *s)
+{
+=09struct nlattr *nest;
+=09int i;
+
+=09nest =3D mnl_attr_nest_start(nlh, NFTA_SET_SUBKEY);
+
+=09for (i =3D 0; i < NFT_REG32_COUNT && s->subkey_len[i]; i++) {
+=09=09mnl_attr_put_u32(nlh, NFTA_SET_SUBKEY_LEN,
+=09=09=09=09 htonl(s->subkey_len[i]));
+=09}
+
+=09mnl_attr_nest_end(nlh, nest);
+}
+
 EXPORT_SYMBOL(nftnl_set_nlmsg_build_payload);
 void nftnl_set_nlmsg_build_payload(struct nlmsghdr *nlh, struct nftnl_set =
*s)
 {
@@ -395,6 +416,8 @@ void nftnl_set_nlmsg_build_payload(struct nlmsghdr *nlh=
, struct nftnl_set *s)
 =09=09mnl_attr_put_u32(nlh, NFTA_SET_GC_INTERVAL, htonl(s->gc_interval));
 =09if (s->flags & (1 << NFTNL_SET_USERDATA))
 =09=09mnl_attr_put(nlh, NFTA_SET_USERDATA, s->user.len, s->user.data);
+=09if (s->flags & (1 << NFTNL_SET_SUBKEY))
+=09=09nftnl_set_nlmsg_build_subkey_payload(nlh, s);
 }
=20
=20
@@ -439,6 +462,10 @@ static int nftnl_set_parse_attr_cb(const struct nlattr=
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
2.20.1

