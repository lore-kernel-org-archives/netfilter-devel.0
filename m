From: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
Subject: Re: [PATCH] Out Of Bound Read in Netfilter Conntrack
Date: Wed, 25 Oct 2017 09:05:05 +0200
Message-ID: <3567257a-3e96-a603-82c0-d1f32bcffd54@x41-dsec.de>
References: <804512f5-786b-d4d0-bc8e-299c5c2683bf@x41-dsec.de>
 <20171024162903.GA20295@salvia> <20171024163601.GA30318@salvia>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ldHBFEOIIFaG1lF3tdo9SxBWECRXppgu0"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:50482 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751421AbdJYHFS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2017 03:05:18 -0400
In-Reply-To: <20171024163601.GA30318@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ldHBFEOIIFaG1lF3tdo9SxBWECRXppgu0
Content-Type: multipart/mixed; boundary="4spBLOnCmj3ceu9mwemaPQEJ11WIJBAct";
 protected-headers="v1"
From: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Message-ID: <3567257a-3e96-a603-82c0-d1f32bcffd54@x41-dsec.de>
Subject: Re: [PATCH] Out Of Bound Read in Netfilter Conntrack
References: <804512f5-786b-d4d0-bc8e-299c5c2683bf@x41-dsec.de>
 <20171024162903.GA20295@salvia> <20171024163601.GA30318@salvia>
In-Reply-To: <20171024163601.GA30318@salvia>

--4spBLOnCmj3ceu9mwemaPQEJ11WIJBAct
Content-Type: multipart/mixed;
 boundary="------------596DB28D98233FCC88E8122E"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------596DB28D98233FCC88E8122E
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi Pablo,

On 24/10/17 18:36, Pablo Neira Ayuso wrote:
> On Tue, Oct 24, 2017 at 06:29:03PM +0200, Pablo Neira Ayuso wrote:
>> Hi,
>>
>> On Mon, Oct 09, 2017 at 07:01:14AM +0200, Eric Sesterhenn wrote:
>>> Add missing counter decrement to prevent out of bounds memory read.
>>
>> I have manually applied this. However, your patches are mangled most
>> likely by MUA and patchword doesn't get it right.
>>
>> If you could please revamp and make sure patches apply cleanly via:
>>
>>         git am patch
>>
>> I would really appreciate, thanks for your patience!
>
I tried to attach the patches in order to keep thunderbird
from mangling them. Guess its time to set up a second mua
for mailing patches.

> While at it, please prepend to your patches:
>=20
>         netfilter: nf_ct_h323: ...
>=20
> So we all know what subsystems this goes to.

As in the patches attached?

Regards,
Eric

--=20
Eric Sesterhenn (Principal Security Consultant)
X41 D-SEC GmbH, Dennewartstr. 25-27, D-52068 Aachen
T: +49 241 9809418-0, Fax: -9
Unternehmenssitz: Aachen, Amtsgericht Aachen: HRB19989
Gesch=C3=A4ftsf=C3=BChrer: Markus Vervier

--------------596DB28D98233FCC88E8122E
Content-Type: text/x-patch;
 name="0001-Out-Of-Bound-Read-in-Netfilter-Conntrack.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0001-Out-Of-Bound-Read-in-Netfilter-Conntrack.patch"

=46rom b8ed8753ca82f6f07fce2901418aab531d98ee39 Mon Sep 17 00:00:00 2001
From: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
Date: Wed, 25 Oct 2017 08:32:57 +0200
Subject: [PATCH netfilter: nf_ct_h323: 1/2] Out Of Bound Read in Netfilte=
r
 Conntrack

Add missing counter decrement to prevent out of bounds memory read.

Signed-off-by: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_co=
nntrack_h323_asn1.c
index 89b2e46925c4..2a9d1acd0cbd 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -877,6 +877,7 @@ int DecodeQ931(unsigned char *buf, size_t sz, Q931 *q=
931)
 		if (sz < 1)
 			break;
 		len =3D *p++;
+		sz--;
 		if (sz < len)
 			break;
 		p +=3D len;
--=20
2.11.0


--------------596DB28D98233FCC88E8122E
Content-Type: text/x-patch;
 name="0002-Prevent-multiple-out-of-bounds-memory-reads.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="0002-Prevent-multiple-out-of-bounds-memory-reads.patch"

=46rom c1b7044749e534207ecd3b04281ae024b01887d3 Mon Sep 17 00:00:00 2001
From: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
Date: Wed, 25 Oct 2017 08:39:38 +0200
Subject: [PATCH netfilter: nf_ct_h323: 2/2] Prevent multiple out of bound=
s
 memory reads.

Multiple accesses are not guarded by out of bound
checks. This patch introduces them.

Signed-off-by: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
---
 net/netfilter/nf_conntrack_h323_asn1.c | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_h323_asn1.c b/net/netfilter/nf_co=
nntrack_h323_asn1.c
index 2a9d1acd0cbd..78a218cdf04e 100644
--- a/net/netfilter/nf_conntrack_h323_asn1.c
+++ b/net/netfilter/nf_conntrack_h323_asn1.c
@@ -104,6 +104,7 @@ typedef struct {
 #define INC_BITS(bs,b) if(((bs)->bit+=3D(b))>7){(bs)->cur+=3D(bs)->bit>>=
3;(bs)->bit&=3D7;}
 #define BYTE_ALIGN(bs) if((bs)->bit){(bs)->cur++;(bs)->bit=3D0;}
 #define CHECK_BOUND(bs,n) if((bs)->cur+(n)>(bs)->end)return(H323_ERROR_B=
OUND)
+#define CHECK_BIT_BOUND(bs,n) ({ size_t __tmp =3D n/8; if((bs)->bit+(n%8=
)>7) { CHECK_BOUND(bs, __tmp + 2); } else { CHECK_BOUND(bs, __tmp + 1); }=
 })
 static unsigned int get_len(bitstr_t *bs);
 static unsigned int get_bit(bitstr_t *bs);
 static unsigned int get_bits(bitstr_t *bs, unsigned int b);
@@ -319,6 +320,7 @@ static int decode_int(bitstr_t *bs, const struct fiel=
d_t *f,
 		bs->cur +=3D 2;
 		break;
 	case CONS:		/* 64K < Range < 4G */
+		CHECK_BIT_BOUND(bs, 2)
 		len =3D get_bits(bs, 2) + 1;
 		BYTE_ALIGN(bs);
 		if (base && (f->attr & DECODE)) {	/* timeToLive */
@@ -404,6 +406,7 @@ static int decode_numstr(bitstr_t *bs, const struct f=
ield_t *f,
 	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
=20
 	/* 2 <=3D Range <=3D 255 */
+	CHECK_BIT_BOUND(bs, f->sz);
 	len =3D get_bits(bs, f->sz) + f->lb;
=20
 	BYTE_ALIGN(bs);
@@ -449,6 +452,7 @@ static int decode_octstr(bitstr_t *bs, const struct f=
ield_t *f,
 		len =3D get_len(bs) + f->lb;
 		break;
 	default:		/* 2 <=3D Range <=3D 255 */
+		CHECK_BIT_BOUND(bs, f->sz);
 		len =3D get_bits(bs, f->sz) + f->lb;
 		BYTE_ALIGN(bs);
 		break;
@@ -477,6 +481,7 @@ static int decode_bmpstr(bitstr_t *bs, const struct f=
ield_t *f,
 		len =3D (*bs->cur++) + f->lb;
 		break;
 	default:		/* 2 <=3D Range <=3D 255 */
+		CHECK_BIT_BOUND(bs, f->sz);
 		len =3D get_bits(bs, f->sz) + f->lb;
 		BYTE_ALIGN(bs);
 		break;
@@ -503,9 +508,11 @@ static int decode_seq(bitstr_t *bs, const struct fie=
ld_t *f,
 	base =3D (base && (f->attr & DECODE)) ? base + f->offset : NULL;
=20
 	/* Extensible? */
+	CHECK_BIT_BOUND(bs, 1);
 	ext =3D (f->attr & EXT) ? get_bit(bs) : 0;
=20
 	/* Get fields bitmap */
+	CHECK_BIT_BOUND(bs, f->sz);
 	bmp =3D get_bitmap(bs, f->sz);
 	if (base)
 		*(unsigned int *)base =3D bmp;
@@ -555,8 +562,9 @@ static int decode_seq(bitstr_t *bs, const struct fiel=
d_t *f,
 		return H323_ERROR_NONE;
=20
 	/* Get the extension bitmap */
+	CHECK_BIT_BOUND(bs, 7);
 	bmp2_len =3D get_bits(bs, 7) + 1;
-	CHECK_BOUND(bs, (bmp2_len + 7) >> 3);
+	CHECK_BIT_BOUND(bs, bmp2_len);
 	bmp2 =3D get_bitmap(bs, bmp2_len);
 	bmp |=3D bmp2 >> f->sz;
 	if (base)
@@ -639,6 +647,7 @@ static int decode_seqof(bitstr_t *bs, const struct fi=
eld_t *f,
 		count =3D get_len(bs);
 		break;
 	default:
+		CHECK_BIT_BOUND(bs, f->sz);
 		count =3D get_bits(bs, f->sz);
 		break;
 	}
@@ -658,6 +667,7 @@ static int decode_seqof(bitstr_t *bs, const struct fi=
eld_t *f,
 	for (i =3D 0; i < count; i++) {
 		if (son->attr & OPEN) {
 			BYTE_ALIGN(bs);
+			CHECK_BOUND(bs, 2);
 			len =3D get_len(bs);
 			CHECK_BOUND(bs, len);
 			if (!base || !(son->attr & DECODE)) {
@@ -710,11 +720,14 @@ static int decode_choice(bitstr_t *bs, const struct=
 field_t *f,
 	base =3D (base && (f->attr & DECODE)) ? base + f->offset : NULL;
=20
 	/* Decode the choice index number */
+	CHECK_BIT_BOUND(bs, 1);
 	if ((f->attr & EXT) && get_bit(bs)) {
 		ext =3D 1;
+		CHECK_BIT_BOUND(bs, 7);
 		type =3D get_bits(bs, 7) + f->lb;
 	} else {
 		ext =3D 0;
+		CHECK_BIT_BOUND(bs, f->sz);
 		type =3D get_bits(bs, f->sz);
 		if (type >=3D f->lb)
 			return H323_ERROR_RANGE;
@@ -727,6 +740,7 @@ static int decode_choice(bitstr_t *bs, const struct f=
ield_t *f,
 	/* Check Range */
 	if (type >=3D f->ub) {	/* Newer version? */
 		BYTE_ALIGN(bs);
+		CHECK_BOUND(bs, 2);
 		len =3D get_len(bs);
 		CHECK_BOUND(bs, len);
 		bs->cur +=3D len;
@@ -742,6 +756,7 @@ static int decode_choice(bitstr_t *bs, const struct f=
ield_t *f,
=20
 	if (ext || (son->attr & OPEN)) {
 		BYTE_ALIGN(bs);
+		CHECK_BOUND(bs, 2);
 		len =3D get_len(bs);
 		CHECK_BOUND(bs, len);
 		if (!base || !(son->attr & DECODE)) {
--=20
2.11.0


--------------596DB28D98233FCC88E8122E--

--4spBLOnCmj3ceu9mwemaPQEJ11WIJBAct--

--ldHBFEOIIFaG1lF3tdo9SxBWECRXppgu0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE4kR6dD1Cx4CoBY4sFLXvnJmdoEMFAlnwN6EACgkQFLXvnJmd
oENdDxAAhV56ymnWFouPwRJC2yFNiyGm6ToBxDQx+axm/ti+3y1Kdu1iql1AIISy
xp3uMxEy4AorV/3pquqPnPNAMYa2CGARWhqgebJQ2v0K+2P4R9NfXoPT2zDBAAZ2
9qxkClSLCw+qWfXBSLeAJ9pVGy0ZEWJaMv8Nkv3I7c8Ok4/MLiLDPimBaANpDy2y
AztX9vKCiPsVdBqPOSzRrLWWiBCdQaeERqIrgapHMayi7sjIfAeGaaAg5ODj9IZS
tvshQaFkTsB4jfTDXckzBz5c84f0Ig1EYgsQhFzhnyY/qrCNmjSJ8LmCWVbd2Q6p
Elzb3ymcGKf/ikDYR5JMzzhCcvgkxXfAJBF35+Hv8GfZYQbdVYk1Pdzu7UdUwkr7
I7/jhwHaE5xl5QcRLTj/P9nQVpN+SWdmysO41dqs5Sz3SPCzNNXqJMnRPUTIJMk4
4SWHC5e9Zhw1Qm4x3Ce3epTAsrL2OVh4rJtxuqOHG6oxPeHECXdtS25rWlNiSwo6
LYt1GG5Eg3oEBiAdHramGDnzCSLnq5oiyJJ+pEBSoYiEfsnP6lBnXyczQAMaIZxl
r1YRWnRiI9Mv/0nB7pK4EMuQUvQN3Y65qRid+kuKP00uWgwuOUo9CrMLDUe2KQXA
nsmkANGE0wnlxzoYyi9MkmGbqiGpA/1ThOS5z+6iQ/z4uHKNmy8=
=KHKh
-----END PGP SIGNATURE-----

--ldHBFEOIIFaG1lF3tdo9SxBWECRXppgu0--
