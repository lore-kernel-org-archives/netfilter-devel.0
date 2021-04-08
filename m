Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37261C433ED
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Apr 2021 06:12:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DB0D861155
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Apr 2021 06:12:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbhDHGMQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Apr 2021 02:12:16 -0400
Received: from mx2.suse.de ([195.135.220.15]:60158 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229506AbhDHGMQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Apr 2021 02:12:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1617862324; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type;
        bh=LDtE1X5UFHz5lNt+5PPbL+I2cxsgMQS/8cRbhOdlwnA=;
        b=sBnGVOcGgXavD+EVIzU2/d7TQ6C5wgCIah2rNUD8YFZRmohkeE25XkVZcOlU//TZ0KiRup
        LqcXi7+sazbtF6TnAavCUSWuF+RevW/gR9s5xoZcqdiE2jBg07uAxvEXw+/jnaGtK+tW7s
        gQ0WWyZMWY5MfTD/Nn2OopQBDcSykFc=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 63F64AFF5
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Apr 2021 06:12:04 +0000 (UTC)
Date:   Thu, 8 Apr 2021 08:12:03 +0200
From:   Ali Abdallah <ali.abdallah@suse.com>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH] conntrack_tcp: Reset the max ACK flag on SYN in ignore state
Message-ID: <20210408061203.35kbl44elgz4resh@Fryzen495>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="sorrycwfi4i7idgz"
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--sorrycwfi4i7idgz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dear,

I would like to propose a small patch in order to fix an issue of some
RSTs being marked as invalid.

For an established connection, at some point the server sends a [RST,
ACK], the client reuse the same port and sends a SYN, the SYN packet is
ignored in CLOSE state

nf_ct_tcp: invalid packet ignored in state CLOSE ... SEQ=3Dxxxxxx ACK=3D0 S=
YN

The server then answers that SYN packet with an [RST, ACK] SEQ=3D0,
ACK=3Dxxxxxx+1

This new RST, because of the IP_CT_TCP_FLAG_MAXACK_SET being already set, is
erroneously marked as invalid with 'nf_ct_tcp: "invalid rst"'.

Kind regards,

--=20
Ali Abdallah | SUSE Linux L3 Engineer
GPG fingerprint: 51A0 F4A0 C8CF C98F 842E  A9A8 B945 56F8 1C85 D0D5

---

Here is the PATCH

=46rom e9d4d3a70a19d8a3868d16c93281119797fb54df Mon Sep 17 00:00:00 2001
=46rom: Ali Abdallah <aabdallah@suse.de>
Date: Thu, 8 Apr 2021 07:44:27 +0200
Subject: [PATCH] Reset the max ACK flag on SYN in ignore state

In ignore state, we let SYN goes in original, the server might respond
with RST/ACK, and that RST packet is erroneously dropped because of the
flag IP_CT_TCP_FLAG_MAXACK_SET being already set.
---
 net/netfilter/nf_conntrack_proto_tcp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conn=
track_proto_tcp.c
index ec23330687a5..891a66e35afd 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -963,6 +963,9 @@ int nf_conntrack_tcp_packet(struct nf_conn *ct,
=20
 			ct->proto.tcp.last_flags =3D
 			ct->proto.tcp.last_wscale =3D 0;
+			/* Reset the max ack flag so in case the server replies
+			 * with RST/ACK it will be marked as an invalid rst */
+			ct->proto.tcp.seen[dir].flags &=3D ~IP_CT_TCP_FLAG_MAXACK_SET;
 			tcp_options(skb, dataoff, th, &seen);
 			if (seen.flags & IP_CT_TCP_FLAG_WINDOW_SCALE) {
 				ct->proto.tcp.last_flags |=3D
--=20
2.26.2



--sorrycwfi4i7idgz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEUaD0oMjPyY+ELqmouUVW+ByF0NUFAmBunrAACgkQuUVW+ByF
0NVTXA//b9D6AYh5sG6uTDG3wQ6++yLhkUnItvYz4pTF+9c9Ei4Ioai5dIYH8WEb
xHBNCWrK/bacG8d/EiqCORc0hr2zAA+J8zFyPukXe+EP3PbURBdajWw5+aopbLMy
N4gRkF65+X53IehznZC9QymZ3ogh4/5MiB82dm0RiCKs7cNSULq76KNRjeyaHbNp
QAGq/e3j+cCYfCiUNPOhkz5oYVUeJU2K7aZ4zBK+Nycd3UFZ6CDs4PayplWnJWL7
JMf0Gi34gfv/h+CUuzBuV7Vn2nM4XTIjUAjoI/r+t/lA/CU/JluX678YcMSWDKAQ
NnrKSmmubtHPXUnv1mJ+/PPcomSW2dSKDsBRxOqV7pXHiUtq6tL0zHLJIcIK9MMJ
yqVhaSj7cuc5yEMsHK2KewQD/jKqmTSmVEuUdH50j7EBXU2lAeaTyQk+Ebkltckv
XIzRccr/rnHVSZz/Xm31LFZTWdWOCr5HCzmL+mfDtwrkPGoHOFx5P5l5VwTXSi2b
GdQnpRpyy03AD2aR37XA3XCP5h30xwBVLJI+eGuSaX0tLF6pzvxRxJwpU0TC84Vu
aMtJGydzgFrloG0BM0ScK19vpR0vjbPpop0ohrgwJ7gUvSr3CSjrZasU5GM2y4k6
2+qxoWhaORBmi6jg9q5xrYpCoU1fRYOxUVyCCPBwuSTcZyAS0vI=
=bUVE
-----END PGP SIGNATURE-----

--sorrycwfi4i7idgz--
