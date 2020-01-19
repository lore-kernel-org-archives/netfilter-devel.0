Return-Path: <SRS0=vOmJ=3I=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E94C7C33CB1
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 13:33:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD76420663
	for <netfilter-devel@archiver.kernel.org>; Sun, 19 Jan 2020 13:33:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Fny4tO+4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727060AbgASNdn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 19 Jan 2020 08:33:43 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26256 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727011AbgASNdn (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 19 Jan 2020 08:33:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579440822;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ua3Gx6kLY6QJ/BAxUQ2o2NPwPpJALJClUnL/+g/Yfnw=;
        b=Fny4tO+4awbhv/8o26IU2X+0LiAzeQcWE4vF4ObHBd8G3sBzmZ9gDLIS3S3GP0FJooQCLo
        Y0Lvnkn3sepHYqKKq8xKmVENH3TAG7h4J76z5UGbYvaS7v9ub4Bcu2Z0dyzixQ9IgFmxvI
        /P7lALpOOCmI1fWjutdeTPc3Nk05Dz8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-234-ADbjyioROOuz-MeZivWNDw-1; Sun, 19 Jan 2020 08:33:38 -0500
X-MC-Unique: ADbjyioROOuz-MeZivWNDw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4A190107ACC7;
        Sun, 19 Jan 2020 13:33:37 +0000 (UTC)
Received: from epycfail.redhat.com (ovpn-112-51.ams2.redhat.com [10.36.112.51])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38C685D9CA;
        Sun, 19 Jan 2020 13:33:34 +0000 (UTC)
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Cc:     Florian Westphal <fw@strlen.de>,
        =?UTF-8?q?Kadlecsik=20J=C3=B3zsef?= <kadlec@blackhole.kfki.hu>,
        Eric Garver <eric@garver.life>, Phil Sutter <phil@nwl.cc>
Subject: [PATCH nf-next v3 4/9] bitmap: Introduce bitmap_cut(): cut bits and shift remaining
Date:   Sun, 19 Jan 2020 14:33:16 +0100
Message-Id: <a4ee22fb535ef6cf978085a2aa0980cbf48f3634.1579434906.git.sbrivio@redhat.com>
In-Reply-To: <cover.1579434906.git.sbrivio@redhat.com>
References: <cover.1579434906.git.sbrivio@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The new bitmap function bitmap_cut() copies bits from source to
destination by removing the region specified by parameters first
and cut, and remapping the bits above the cut region by right
shifting them.

Signed-off-by: Stefano Brivio <sbrivio@redhat.com>
---
v3: No changes
v2: No changes

 include/linux/bitmap.h |  4 +++
 lib/bitmap.c           | 66 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/include/linux/bitmap.h b/include/linux/bitmap.h
index ff335b22f23c..f0f3a9fffa6a 100644
--- a/include/linux/bitmap.h
+++ b/include/linux/bitmap.h
@@ -53,6 +53,7 @@
  *  bitmap_find_next_zero_area_off(buf, len, pos, n, mask)  as above
  *  bitmap_shift_right(dst, src, n, nbits)      *dst =3D *src >> n
  *  bitmap_shift_left(dst, src, n, nbits)       *dst =3D *src << n
+ *  bitmap_cut(dst, src, first, n, nbits)       Cut n bits from first, c=
opy rest
  *  bitmap_replace(dst, old, new, mask, nbits)  *dst =3D (*old & ~(*mask=
)) | (*new & *mask)
  *  bitmap_remap(dst, src, old, new, nbits)     *dst =3D map(old, new)(s=
rc)
  *  bitmap_bitremap(oldbit, old, new, nbits)    newbit =3D map(old, new)=
(oldbit)
@@ -133,6 +134,9 @@ extern void __bitmap_shift_right(unsigned long *dst, =
const unsigned long *src,
 				unsigned int shift, unsigned int nbits);
 extern void __bitmap_shift_left(unsigned long *dst, const unsigned long =
*src,
 				unsigned int shift, unsigned int nbits);
+extern void bitmap_cut(unsigned long *dst, const unsigned long *src,
+		       unsigned int first, unsigned int cut,
+		       unsigned int nbits);
 extern int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1=
,
 			const unsigned long *bitmap2, unsigned int nbits);
 extern void __bitmap_or(unsigned long *dst, const unsigned long *bitmap1=
,
diff --git a/lib/bitmap.c b/lib/bitmap.c
index 4250519d7d1c..6e175fbd69a9 100644
--- a/lib/bitmap.c
+++ b/lib/bitmap.c
@@ -168,6 +168,72 @@ void __bitmap_shift_left(unsigned long *dst, const u=
nsigned long *src,
 }
 EXPORT_SYMBOL(__bitmap_shift_left);
=20
+/**
+ * bitmap_cut() - remove bit region from bitmap and right shift remainin=
g bits
+ * @dst: destination bitmap, might overlap with src
+ * @src: source bitmap
+ * @first: start bit of region to be removed
+ * @cut: number of bits to remove
+ * @nbits: bitmap size, in bits
+ *
+ * Set the n-th bit of @dst iff the n-th bit of @src is set and
+ * n is less than @first, or the m-th bit of @src is set for any
+ * m such that @first <=3D n < nbits, and m =3D n + @cut.
+ *
+ * In pictures, example for a big-endian 32-bit architecture:
+ *
+ * @src:
+ * 31                                   63
+ * |                                    |
+ * 10000000 11000001 11110010 00010101  10000000 11000001 01110010 00010=
101
+ *                 |  |              |                                  =
  |
+ *                16  14             0                                  =
 32
+ *
+ * if @cut is 3, and @first is 14, bits 14-16 in @src are cut and @dst i=
s:
+ *
+ * 31                                   63
+ * |                                    |
+ * 10110000 00011000 00110010 00010101  00010000 00011000 00101110 01000=
010
+ *                    |              |                                  =
  |
+ *                    14 (bit 17     0                                  =
 32
+ *                        from @src)
+ *
+ * Note that @dst and @src might overlap partially or entirely.
+ *
+ * This is implemented in the obvious way, with a shift and carry
+ * step for each moved bit. Optimisation is left as an exercise
+ * for the compiler.
+ */
+void bitmap_cut(unsigned long *dst, const unsigned long *src,
+		unsigned int first, unsigned int cut, unsigned int nbits)
+{
+	unsigned int len =3D BITS_TO_LONGS(nbits);
+	unsigned long keep =3D 0, carry;
+	int i;
+
+	memmove(dst, src, len * sizeof(*dst));
+
+	if (first % BITS_PER_LONG) {
+		keep =3D src[first / BITS_PER_LONG] &
+		       (~0UL >> (BITS_PER_LONG - first % BITS_PER_LONG));
+	}
+
+	while (cut--) {
+		for (i =3D first / BITS_PER_LONG; i < len; i++) {
+			if (i < len - 1)
+				carry =3D dst[i + 1] & 1UL;
+			else
+				carry =3D 0;
+
+			dst[i] =3D (dst[i] >> 1) | (carry << (BITS_PER_LONG - 1));
+		}
+	}
+
+	dst[first / BITS_PER_LONG] &=3D ~0UL << (first % BITS_PER_LONG);
+	dst[first / BITS_PER_LONG] |=3D keep;
+}
+EXPORT_SYMBOL(bitmap_cut);
+
 int __bitmap_and(unsigned long *dst, const unsigned long *bitmap1,
 				const unsigned long *bitmap2, unsigned int bits)
 {
--=20
2.24.1

