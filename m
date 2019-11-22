Return-Path: <SRS0=uBXc=ZO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5E9FC432C0
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Nov 2019 13:40:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8B56920707
	for <netfilter-devel@archiver.kernel.org>; Fri, 22 Nov 2019 13:40:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GqUnytXI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728128AbfKVNkT (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 22 Nov 2019 08:40:19 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:51615 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726633AbfKVNkT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 22 Nov 2019 08:40:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574430017;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=5qq32iPQjRhCpl5qkg5VcYNPITcMxp7kGVXxfNPtm5s=;
        b=GqUnytXIhv5YMZoVkLQjH3EAqiAwZ4ASoE1FcL6bBoBoCNNK1cxDf+/DOfrDwX+t3HOEZD
        5Nh+qkCFYagNql69ucx4SzWZXPzD2w8aM6GUKNErlNhC0BCnFgU4oF+TXcB5x7/Oys1mKW
        ptW3R5/sKQLAdqkxLLSXjMEOzaE9f3I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-W3TgmsokMk-9w30JXIP9iw-1; Fri, 22 Nov 2019 08:40:14 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68C36DB23;
        Fri, 22 Nov 2019 13:40:13 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 42B701036C8E;
        Fri, 22 Nov 2019 13:40:10 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next v2 1/8] netfilter: nf_tables: Support for subkeys, set with multiple ranged fields
Date:   Fri, 22 Nov 2019 14:40:00 +0100
Message-Id: <90493a6feae0ae64db378fbfc8e9f351d4b7b05d.1574428269.git.sbrivio@redhat.com>
In-Reply-To: <cover.1574428269.git.sbrivio@redhat.com>
References: <cover.1574428269.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: W3TgmsokMk-9w30JXIP9iw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Introduce a new nested netlink attribute, NFTA_SET_SUBKEY, used to
specify the length of each field in a set concatenation.

This allows set implementations to support concatenation of multiple
ranged items, as they can divide the input key into matching data for
every single field. Such set implementations would indicate this
capability with the NFT_SET_SUBKEY flag.

In order to specify the interval for a set entry, userspace would
simply keep using two elements per entry, as it happens now, with the
end element indicating the upper interval bound. As a single element
can now be a concatenation of several fields, with or without the
NFT_SET_ELEM_INTERVAL_END flag, we obtain a convenient way to support
multiple ranged fields in a set.

While at it, export the number of 32-bit registers available for
packet matching, as nftables will need this to know the maximum
number of field lengths that can be specified.

For example, "packets with an IPv4 address between 192.0.2.0 and
192.0.2.42, with destination port between 22 and 25", can be
expressed as two concatenated elements:

  192.0.2.0 . 22
  192.0.2.42 . 25 with NFT_SET_ELEM_INTERVAL_END

and the NFTA_SET_SUBKEY attributes would be 32, 16, in that order.

Note that this does *not* represent the concatenated range:

  0xc0 0x00 0x02 0x00 0x00 0x16 - 0xc0 0x00 0x02 0x2a 0x00 0x25

on the six packet bytes of interest. That is, the range specified
does *not* include e.g. 0xc0 0x00 0x02 0x29 0x00 0x42, which is:
  192.0.0.41 . 66

Suggested-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v2: No changes

 include/uapi/linux/netfilter/nf_tables.h | 16 ++++++++++++++++
 net/netfilter/nf_tables_api.c            |  4 ++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/=
netfilter/nf_tables.h
index bb9b049310df..f8dbeac14898 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -48,6 +48,7 @@ enum nft_registers {
=20
 #define NFT_REG_SIZE=0916
 #define NFT_REG32_SIZE=094
+#define NFT_REG32_COUNT=09(NFT_REG32_15 - NFT_REG32_00 + 1)
=20
 /**
  * enum nft_verdicts - nf_tables internal verdicts
@@ -275,6 +276,7 @@ enum nft_rule_compat_attributes {
  * @NFT_SET_TIMEOUT: set uses timeouts
  * @NFT_SET_EVAL: set can be updated from the evaluation path
  * @NFT_SET_OBJECT: set contains stateful objects
+ * @NFT_SET_SUBKEY: set uses subkeys to map intervals for multiple fields
  */
 enum nft_set_flags {
 =09NFT_SET_ANONYMOUS=09=09=3D 0x1,
@@ -284,6 +286,7 @@ enum nft_set_flags {
 =09NFT_SET_TIMEOUT=09=09=09=3D 0x10,
 =09NFT_SET_EVAL=09=09=09=3D 0x20,
 =09NFT_SET_OBJECT=09=09=09=3D 0x40,
+=09NFT_SET_SUBKEY=09=09=09=3D 0x80,
 };
=20
 /**
@@ -309,6 +312,17 @@ enum nft_set_desc_attributes {
 };
 #define NFTA_SET_DESC_MAX=09(__NFTA_SET_DESC_MAX - 1)
=20
+/**
+ * enum nft_set_subkey_attributes - subkeys for multiple ranged fields
+ *
+ * @NFTA_SET_SUBKEY_LEN: length of single field, in bits (NLA_U32)
+ */
+enum nft_set_subkey_attributes {
+=09NFTA_SET_SUBKEY_LEN,
+=09__NFTA_SET_SUBKEY_MAX
+};
+#define NFTA_SET_SUBKEY_MAX=09(__NFTA_SET_SUBKEY_MAX - 1)
+
 /**
  * enum nft_set_attributes - nf_tables set netlink attributes
  *
@@ -327,6 +341,7 @@ enum nft_set_desc_attributes {
  * @NFTA_SET_USERDATA: user data (NLA_BINARY)
  * @NFTA_SET_OBJ_TYPE: stateful object type (NLA_U32: NFT_OBJECT_*)
  * @NFTA_SET_HANDLE: set handle (NLA_U64)
+ * @NFTA_SET_SUBKEY: subkeys for multiple ranged fields (NLA_NESTED)
  */
 enum nft_set_attributes {
 =09NFTA_SET_UNSPEC,
@@ -346,6 +361,7 @@ enum nft_set_attributes {
 =09NFTA_SET_PAD,
 =09NFTA_SET_OBJ_TYPE,
 =09NFTA_SET_HANDLE,
+=09NFTA_SET_SUBKEY,
 =09__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX=09=09(__NFTA_SET_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index ff04cdc87f76..a877d60f86a9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3248,7 +3248,7 @@ EXPORT_SYMBOL_GPL(nft_unregister_set);
=20
 #define NFT_SET_FEATURES=09(NFT_SET_INTERVAL | NFT_SET_MAP | \
 =09=09=09=09 NFT_SET_TIMEOUT | NFT_SET_OBJECT | \
-=09=09=09=09 NFT_SET_EVAL)
+=09=09=09=09 NFT_SET_EVAL | NFT_SET_SUBKEY)
=20
 static bool nft_set_ops_candidate(const struct nft_set_type *type, u32 fla=
gs)
 {
@@ -3826,7 +3826,7 @@ static int nf_tables_newset(struct net *net, struct s=
ock *nlsk,
 =09=09if (flags & ~(NFT_SET_ANONYMOUS | NFT_SET_CONSTANT |
 =09=09=09      NFT_SET_INTERVAL | NFT_SET_TIMEOUT |
 =09=09=09      NFT_SET_MAP | NFT_SET_EVAL |
-=09=09=09      NFT_SET_OBJECT))
+=09=09=09      NFT_SET_OBJECT | NFT_SET_SUBKEY))
 =09=09=09return -EINVAL;
 =09=09/* Only one of these operations is supported */
 =09=09if ((flags & (NFT_SET_MAP | NFT_SET_OBJECT)) =3D=3D
--=20
2.20.1

