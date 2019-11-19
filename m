Return-Path: <SRS0=iRt+=ZL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74544C432C0
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 01:07:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C86820730
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 01:07:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XNpBY9DX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfKSBHY (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 20:07:24 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:25738 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726962AbfKSBHX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 20:07:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574125642;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DYV/X/nXe/IjcC12BLBhsxesMbdyPh7PPC9gM5FCbJY=;
        b=XNpBY9DXeelhCDCsNXUtz0Rfe5MVBmd0pQw0lhbJPDBuhBqM3eDHnEkcXAb9GcZiQlAepy
        vs+kC2JytlfzL12Tne8AAdmj9oOnEC6EvUocWUUDZy9dq7faG+vXr2m6OTrTbAbOUuY7EM
        EHReSqrvAZ4kfrTvc0GCPyfWdPkH3Tk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-187-R69sX_d_OTKJjoKckPkerA-1; Mon, 18 Nov 2019 20:07:19 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DAA061005500;
        Tue, 19 Nov 2019 01:07:17 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CD748BA45;
        Tue, 19 Nov 2019 01:07:15 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nft 1/3] src: Add support for and export NFT_SET_SUBKEY attributes
Date:   Tue, 19 Nov 2019 02:07:10 +0100
Message-Id: <20191119010712.39316-2-sbrivio@redhat.com>
In-Reply-To: <20191119010712.39316-1-sbrivio@redhat.com>
References: <20191119010712.39316-1-sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: R69sX_d_OTKJjoKckPkerA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

To support arbitrary range concatenations, the kernel needs to know
how long each field in the concatenation is.

While evaluating concatenated expressions, export the datatype size,
in bits, into the new subkey_len array, and hand the data over via
libnftnl.

Note that, while the subkey length is expressed in bits, and the
kernel attribute is 32-bit long to make UAPI more future-proof, we
just reserve 8 bits for it, at the moment, and still store this data
in bits.

As we don't have subkeys exceeding 128 bits in length, this should be
fine, at least for a while, but it can be easily changed later on to
use the full 32 bits allowed by the netlink attribute.

This change depends on the UAPI kernel patch with title:
  netfilter: nf_tables: Support for subkeys, set with multiple ranged field=
s

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 include/expression.h |  1 +
 include/rule.h       |  1 +
 src/evaluate.c       | 12 ++++++++----
 src/mnl.c            |  4 ++++
 4 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/include/expression.h b/include/expression.h
index 717b6755..b6d5adb2 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -256,6 +256,7 @@ struct expr {
 =09=09=09struct list_head=09expressions;
 =09=09=09unsigned int=09=09size;
 =09=09=09uint32_t=09=09set_flags;
+=09=09=09uint8_t=09=09=09subkey_len[NFT_REG32_COUNT];
 =09=09};
 =09=09struct {
 =09=09=09/* EXPR_SET_REF */
diff --git a/include/rule.h b/include/rule.h
index 0b2eba37..a263947d 100644
--- a/include/rule.h
+++ b/include/rule.h
@@ -308,6 +308,7 @@ struct set {
 =09struct expr=09=09*rg_cache;
 =09uint32_t=09=09policy;
 =09bool=09=09=09automerge;
+=09uint8_t=09=09=09subkey_len[NFT_REG32_COUNT];
 =09struct {
 =09=09uint32_t=09size;
 =09} desc;
diff --git a/src/evaluate.c b/src/evaluate.c
index e54eaf1a..e1ecf4de 100644
--- a/src/evaluate.c
+++ b/src/evaluate.c
@@ -1211,7 +1211,7 @@ static int expr_evaluate_concat(struct eval_ctx *ctx,=
 struct expr **expr,
 {
 =09const struct datatype *dtype =3D ctx->ectx.dtype, *tmp;
 =09uint32_t type =3D dtype ? dtype->type : 0, ntype =3D 0;
-=09int off =3D dtype ? dtype->subtypes : 0;
+=09int off =3D dtype ? dtype->subtypes : 0, subkey_idx =3D 0;
 =09unsigned int flags =3D EXPR_F_CONSTANT | EXPR_F_SINGLETON;
 =09struct expr *i, *next;
=20
@@ -1240,6 +1240,8 @@ static int expr_evaluate_concat(struct eval_ctx *ctx,=
 struct expr **expr,
 =09=09=09=09=09=09 i->dtype->name);
=20
 =09=09ntype =3D concat_subtype_add(ntype, i->dtype->type);
+
+=09=09(*expr)->subkey_len[subkey_idx++] =3D i->dtype->size;
 =09}
=20
 =09(*expr)->flags |=3D flags;
@@ -3301,9 +3303,11 @@ static int set_evaluate(struct eval_ctx *ctx, struct=
 set *set)
 =09=09=09=09=09 "specified in %s definition",
 =09=09=09=09=09 set->key->dtype->name, type);
 =09}
-=09if (set->flags & NFT_SET_INTERVAL &&
-=09    set->key->etype =3D=3D EXPR_CONCAT)
-=09=09return set_error(ctx, set, "concatenated types not supported in inte=
rval sets");
+=09if (set->flags & NFT_SET_INTERVAL && set->key->etype =3D=3D EXPR_CONCAT=
) {
+=09=09memcpy(&set->subkey_len, &set->key->subkey_len,
+=09=09       sizeof(set->subkey_len));
+=09=09set->flags |=3D NFT_SET_SUBKEY;
+=09}
=20
 =09if (set_is_datamap(set->flags)) {
 =09=09if (set->datatype =3D=3D NULL)
diff --git a/src/mnl.c b/src/mnl.c
index fdba0af8..292a26fd 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -880,6 +880,10 @@ int mnl_nft_set_add(struct netlink_ctx *ctx, const str=
uct cmd *cmd,
 =09=09=09=09 set->automerge))
 =09=09memory_allocation_error();
=20
+=09if (set->flags & NFT_SET_SUBKEY)
+=09=09nftnl_set_set_data(nls, NFTNL_SET_SUBKEY, &set->subkey_len,
+=09=09=09=09   sizeof(set->subkey_len));
+
 =09nftnl_set_set_data(nls, NFTNL_SET_USERDATA, nftnl_udata_buf_data(udbuf)=
,
 =09=09=09   nftnl_udata_buf_len(udbuf));
 =09nftnl_udata_buf_free(udbuf);
--=20
2.23.0

