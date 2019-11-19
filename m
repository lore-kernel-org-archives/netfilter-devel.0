Return-Path: <SRS0=iRt+=ZL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDFB3C432C3
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 01:07:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9502B20730
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Nov 2019 01:07:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LiGqpFBD"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbfKSBHG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 20:07:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:41327 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727053AbfKSBHF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 20:07:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1574125624;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CcmwQLRpEKTJRxZz5aQv8875GiZeYtBGXF9BHnrrwvY=;
        b=LiGqpFBD99mBS7cmVg/P5ECmHkxgWxkVtK9DPJlISKZs7Gjv7M4SxM71oWr6ad3fDlij5o
        81vQyRusicFBZXUhdka3kA3oxLrr1JZZv75teQgMmNW/W7lAAbn0AtaQdscQZrB2tZRc0d
        y5k4YYfG4Zs0mE+zOb14dwcxoPhb7Ks=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-175-ngGB8BmzNBy5g2gYo2en2w-1; Mon, 18 Nov 2019 20:07:01 -0500
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8561080268C;
        Tue, 19 Nov 2019 01:06:59 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-24.ams2.redhat.com [10.36.112.24])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 662A11CD;
        Tue, 19 Nov 2019 01:06:56 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Jay Ligatti <ligatti@usf.edu>,
        Ori Rottenstreich <or@cs.technion.ac.il>,
        Kirill Kogan <kirill.kogan@gmail.com>
Subject: [PATCH nf-next 5/8] nft_set_pipapo: Provide unrolled lookup loops for common field sizes
Date:   Tue, 19 Nov 2019 02:06:32 +0100
Message-Id: <4fb71a84419b1f824b9f37660e506309aecbec88.1574119038.git.sbrivio@redhat.com>
In-Reply-To: <cover.1574119038.git.sbrivio@redhat.com>
References: <cover.1574119038.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-MC-Unique: ngGB8BmzNBy5g2gYo2en2w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For non-vectorised lookup implementations, this increases matching
rates by 20 to 30% for most set types.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
 net/netfilter/nft_set_pipapo.c | 86 +++++++++++++++++++++++++++++-----
 1 file changed, 73 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nft_set_pipapo.c b/net/netfilter/nft_set_pipapo.=
c
index 1829289a54f7..d4d8c509caf3 100644
--- a/net/netfilter/nft_set_pipapo.c
+++ b/net/netfilter/nft_set_pipapo.c
@@ -532,6 +532,51 @@ static int pipapo_refill(unsigned long *map, int len, =
int rules,
 =09return ret;
 }
=20
+#define NFT_PIPAPO_AND_BUCKET(map, bucket, bsize, idx)=09=09=09       \
+=09do {=09=09=09=09=09=09=09=09       \
+=09=09for (idx =3D 0; idx < (bsize); idx++)=09=09=09       \
+=09=09=09map[idx] &=3D *((bucket) + idx);=09=09=09       \
+=09} while (0)
+
+#define NFT_PIPAPO_MATCH_2(map, lt, bsize, pkt, offset, idx)=09=09       \
+=09do {=09=09=09=09=09=09=09=09       \
+=09=09NFT_PIPAPO_AND_BUCKET(map,=09=09=09=09       \
+=09=09=09=09      lt +=09=09=09=09       \
+=09=09=09=09      (offset +  0 +   (*pkt >> 4)) * bsize,   \
+=09=09=09=09      bsize, idx);=09=09=09       \
+=09=09NFT_PIPAPO_AND_BUCKET(map,=09=09=09=09       \
+=09=09=09=09      lt +=09=09=09=09       \
+=09=09=09=09      (offset + 16 + (*pkt & 0x0f)) * bsize,   \
+=09=09=09=09      bsize, idx);=09=09=09       \
+=09=09pkt++;=09=09=09=09=09=09=09       \
+=09} while (0)
+
+#define NFT_PIPAPO_MATCH_4(map, lt, bsize, pkt, offset, idx)=09=09       \
+=09do {=09=09=09=09=09=09=09=09       \
+=09=09NFT_PIPAPO_MATCH_2(map, lt, bsize, pkt, offset, idx);=09       \
+=09=09NFT_PIPAPO_MATCH_2(map, lt, bsize, pkt, offset + 2 * 16, idx); \
+=09} while (0)
+
+#define NFT_PIPAPO_MATCH_8(map, lt, bsize, pkt, offset, idx)=09=09       \
+=09do {=09=09=09=09=09=09=09=09       \
+=09=09NFT_PIPAPO_MATCH_4(map, lt, bsize, pkt, offset, idx);=09       \
+=09=09NFT_PIPAPO_MATCH_4(map, lt, bsize, pkt, offset + 4 * 16, idx); \
+=09} while (0)
+
+#define NFT_PIPAPO_MATCH_12(map, lt, bsize, pkt, idx)=09=09=09       \
+=09do {=09=09=09=09=09=09=09=09       \
+=09=09NFT_PIPAPO_MATCH_8(map, lt, bsize, pkt, 0, idx);=09       \
+=09=09NFT_PIPAPO_MATCH_4(map, lt, bsize, pkt, 8 * 16, idx);=09       \
+=09} while (0)
+
+#define NFT_PIPAPO_MATCH_32(map, lt, bsize, pkt, idx)=09=09=09       \
+=09do {=09=09=09=09=09=09=09=09       \
+=09=09NFT_PIPAPO_MATCH_8(map, lt, bsize, pkt,  0, idx);=09       \
+=09=09NFT_PIPAPO_MATCH_8(map, lt, bsize, pkt,  8 * 16, idx);=09       \
+=09=09NFT_PIPAPO_MATCH_8(map, lt, bsize, pkt, 16 * 16, idx);=09       \
+=09=09NFT_PIPAPO_MATCH_8(map, lt, bsize, pkt, 24 * 16, idx);=09       \
+=09} while (0)
+
 /**
  * nft_pipapo_lookup() - Lookup function
  * @net:=09Network namespace
@@ -571,24 +616,39 @@ static bool nft_pipapo_lookup(const struct net *net, =
const struct nft_set *set,
 =09nft_pipapo_for_each_field(f, i, m) {
 =09=09bool last =3D i =3D=3D m->field_count - 1;
 =09=09unsigned long *lt =3D f->lt;
-=09=09int b, group;
+=09=09int b, group, j;
=20
 =09=09/* For each 4-bit group: select lookup table bucket depending on
-=09=09 * packet bytes value, then AND bucket value
+=09=09 * packet bytes value, then AND bucket value. Unroll loops for
+=09=09 * the most common cases (protocol, port, IPv4 address, MAC
+=09=09 * address, IPv6 address).
 =09=09 */
-=09=09for (group =3D 0; group < f->groups; group++) {
-=09=09=09u8 v;
+=09=09if (f->groups =3D=3D 2) {
+=09=09=09NFT_PIPAPO_MATCH_2(res_map, lt, f->bsize, rp, 0, j);
+=09=09} else if (f->groups =3D=3D 4) {
+=09=09=09NFT_PIPAPO_MATCH_4(res_map, lt, f->bsize, rp, 0, j);
+=09=09} else if (f->groups =3D=3D 8) {
+=09=09=09NFT_PIPAPO_MATCH_8(res_map, lt, f->bsize, rp, 0, j);
+=09=09} else if (f->groups =3D=3D 12) {
+=09=09=09NFT_PIPAPO_MATCH_12(res_map, lt, f->bsize, rp, j);
+=09=09} else if (f->groups =3D=3D 32) {
+=09=09=09NFT_PIPAPO_MATCH_32(res_map, lt, f->bsize, rp, j);
+=09=09} else {
+=09=09=09for (group =3D 0; group < f->groups; group++) {
+=09=09=09=09u8 v;
+
+=09=09=09=09if (group % 2) {
+=09=09=09=09=09v =3D *rp & 0x0f;
+=09=09=09=09=09rp++;
+=09=09=09=09} else {
+=09=09=09=09=09v =3D *rp >> 4;
+=09=09=09=09}
+=09=09=09=09__bitmap_and(res_map, res_map,
+=09=09=09=09=09     lt + v * f->bsize,
+=09=09=09=09=09     f->bsize * BITS_PER_LONG);
=20
-=09=09=09if (group % 2) {
-=09=09=09=09v =3D *rp & 0x0f;
-=09=09=09=09rp++;
-=09=09=09} else {
-=09=09=09=09v =3D *rp >> 4;
+=09=09=09=09lt +=3D f->bsize * NFT_PIPAPO_BUCKETS;
 =09=09=09}
-=09=09=09__bitmap_and(res_map, res_map, lt + v * f->bsize,
-=09=09=09=09     f->bsize * BITS_PER_LONG);
-
-=09=09=09lt +=3D f->bsize * NFT_PIPAPO_BUCKETS;
 =09=09}
=20
 =09=09/* Now populate the bitmap for the next field, unless this is
--=20
2.20.1

