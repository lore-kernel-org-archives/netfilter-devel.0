From: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
Subject: Re: [PATCH] Bitwise Out Of Bound Read in Netfilter Conntrack
Date: Tue, 17 Oct 2017 15:48:13 +0200
Message-ID: <f3b8d5d7-cdb9-e357-899d-adbcb0401bc0@x41-dsec.de>
References: <804512f5-786b-d4d0-bc8e-299c5c2683bf@x41-dsec.de>
 <20171012000346.GE26835@breakpoint.cc>
 <732a5fa7-1ccc-24f4-862c-18ff61b0fabb@x41-dsec.de>
 <20171017130917.GA21110@salvia>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="B3K6ttmAbvjOceNgS6mvHsNsL3k81rwWn"
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from aibo.runbox.com ([91.220.196.211]:47498 "EHLO aibo.runbox.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762312AbdJQNs0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Oct 2017 09:48:26 -0400
In-Reply-To: <20171017130917.GA21110@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--B3K6ttmAbvjOceNgS6mvHsNsL3k81rwWn
Content-Type: multipart/mixed; boundary="aSsR7hJsm8bq46wXp79pIcCruRnx1B05F";
 protected-headers="v1"
From: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Message-ID: <f3b8d5d7-cdb9-e357-899d-adbcb0401bc0@x41-dsec.de>
Subject: Re: [PATCH] Bitwise Out Of Bound Read in Netfilter Conntrack
References: <804512f5-786b-d4d0-bc8e-299c5c2683bf@x41-dsec.de>
 <20171012000346.GE26835@breakpoint.cc>
 <732a5fa7-1ccc-24f4-862c-18ff61b0fabb@x41-dsec.de>
 <20171017130917.GA21110@salvia>
In-Reply-To: <20171017130917.GA21110@salvia>

--aSsR7hJsm8bq46wXp79pIcCruRnx1B05F
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hello Pablo,

they fix different issues, therefore both should
be applied.

Regards,
Eric

On 17/10/17 15:09, Pablo Neira Ayuso wrote:
> Hi Eric,
>=20
> Is there any change with regards to previous patch?
>=20
> I have two in patchwork:
>=20
> http://patchwork.ozlabs.org/patch/823074/
> http://patchwork.ozlabs.org/patch/825682/
>=20
> Which one should I consider for submission?
>=20
> Thanks!
>=20
> On Fri, Oct 13, 2017 at 08:29:08PM +0200, Eric Sesterhenn wrote:
>>
>> From 66a5a55b6e7e45c51691583cf5833b4fe9365dc1 Mon Sep 17 00:00:00 2001=

>> From: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
>> Date: Fri, 13 Oct 2017 20:26:32 +0200
>> Subject: [PATCH] Prevent bitwise out of bound memory reads
>>
>> The CHECK_BOUND function is not always uses, especially not
>> when reading bitwise.
>>
>> Signed-off-by: Eric Sesterhenn <eric.sesterhenn@x41-dsec.de>
>> ---
>>  net/netfilter/nf_conntrack_h323_asn1.c | 18 +++++++++++++++++-
>>  1 file changed, 17 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/netfilter/nf_conntrack_h323_asn1.c
>> b/net/netfilter/nf_conntrack_h323_asn1.c
>> index 89b2e46925c4..e298878edc86 100644
>> --- a/net/netfilter/nf_conntrack_h323_asn1.c
>> +++ b/net/netfilter/nf_conntrack_h323_asn1.c
>> @@ -104,6 +104,7 @@ typedef struct {
>>  #define INC_BITS(bs,b)
>> if(((bs)->bit+=3D(b))>7){(bs)->cur+=3D(bs)->bit>>3;(bs)->bit&=3D7;}
>>  #define BYTE_ALIGN(bs) if((bs)->bit){(bs)->cur++;(bs)->bit=3D0;}
>>  #define CHECK_BOUND(bs,n)
>> if((bs)->cur+(n)>(bs)->end)return(H323_ERROR_BOUND)
>> +#define CHECK_BIT_BOUND(bs,n) ({ size_t __tmp =3D n/8;
>> if((bs)->bit+(n%8)>7) { CHECK_BOUND(bs, __tmp + 2); } else {
>> CHECK_BOUND(bs, __tmp + 1); } })
>>  static unsigned int get_len(bitstr_t *bs);
>>  static unsigned int get_bit(bitstr_t *bs);
>>  static unsigned int get_bits(bitstr_t *bs, unsigned int b);
>> @@ -319,9 +320,11 @@ static int decode_int(bitstr_t *bs, const struct
>> field_t *f,
>>  		bs->cur +=3D 2;
>>  		break;
>>  	case CONS:		/* 64K < Range < 4G */
>> +		CHECK_BIT_BOUND(bs, 2)
>>  		len =3D get_bits(bs, 2) + 1;
>>  		BYTE_ALIGN(bs);
>>  		if (base && (f->attr & DECODE)) {	/* timeToLive */
>> +			CHECK_BOUND(bs, len);
>>  			unsigned int v =3D get_uint(bs, len) + f->lb;
>>  			PRINT(" =3D %u", v);
>>  			*((unsigned int *)(base + f->offset)) =3D v;
>> @@ -404,6 +407,7 @@ static int decode_numstr(bitstr_t *bs, const struc=
t
>> field_t *f,
>>  	PRINT("%*.s%s\n", level * TAB_SIZE, " ", f->name);
>>
>>  	/* 2 <=3D Range <=3D 255 */
>> +	CHECK_BIT_BOUND(bs, f->sz);
>>  	len =3D get_bits(bs, f->sz) + f->lb;
>>
>>  	BYTE_ALIGN(bs);
>> @@ -449,6 +453,7 @@ static int decode_octstr(bitstr_t *bs, const struc=
t
>> field_t *f,
>>  		len =3D get_len(bs) + f->lb;
>>  		break;
>>  	default:		/* 2 <=3D Range <=3D 255 */
>> +		CHECK_BIT_BOUND(bs, f->sz);
>>  		len =3D get_bits(bs, f->sz) + f->lb;
>>  		BYTE_ALIGN(bs);
>>  		break;
>> @@ -477,6 +482,7 @@ static int decode_bmpstr(bitstr_t *bs, const struc=
t
>> field_t *f,
>>  		len =3D (*bs->cur++) + f->lb;
>>  		break;
>>  	default:		/* 2 <=3D Range <=3D 255 */
>> +		CHECK_BIT_BOUND(bs, f->sz);
>>  		len =3D get_bits(bs, f->sz) + f->lb;
>>  		BYTE_ALIGN(bs);
>>  		break;
>> @@ -503,9 +509,11 @@ static int decode_seq(bitstr_t *bs, const struct
>> field_t *f,
>>  	base =3D (base && (f->attr & DECODE)) ? base + f->offset : NULL;
>>
>>  	/* Extensible? */
>> +	CHECK_BIT_BOUND(bs, 1);
>>  	ext =3D (f->attr & EXT) ? get_bit(bs) : 0;
>>
>>  	/* Get fields bitmap */
>> +	CHECK_BIT_BOUND(bs, f->sz);
>>  	bmp =3D get_bitmap(bs, f->sz);
>>  	if (base)
>>  		*(unsigned int *)base =3D bmp;
>> @@ -555,8 +563,9 @@ static int decode_seq(bitstr_t *bs, const struct
>> field_t *f,
>>  		return H323_ERROR_NONE;
>>
>>  	/* Get the extension bitmap */
>> +	CHECK_BIT_BOUND(bs, 7);
>>  	bmp2_len =3D get_bits(bs, 7) + 1;
>> -	CHECK_BOUND(bs, (bmp2_len + 7) >> 3);
>> +	CHECK_BIT_BOUND(bs, bmp2_len);
>>  	bmp2 =3D get_bitmap(bs, bmp2_len);
>>  	bmp |=3D bmp2 >> f->sz;
>>  	if (base)
>> @@ -639,6 +648,7 @@ static int decode_seqof(bitstr_t *bs, const struct=

>> field_t *f,
>>  		count =3D get_len(bs);
>>  		break;
>>  	default:
>> +		CHECK_BIT_BOUND(bs, f->sz);
>>  		count =3D get_bits(bs, f->sz);
>>  		break;
>>  	}
>> @@ -658,6 +668,7 @@ static int decode_seqof(bitstr_t *bs, const struct=

>> field_t *f,
>>  	for (i =3D 0; i < count; i++) {
>>  		if (son->attr & OPEN) {
>>  			BYTE_ALIGN(bs);
>> +			CHECK_BOUND(bs, 2);
>>  			len =3D get_len(bs);
>>  			CHECK_BOUND(bs, len);
>>  			if (!base || !(son->attr & DECODE)) {
>> @@ -710,11 +721,14 @@ static int decode_choice(bitstr_t *bs, const
>> struct field_t *f,
>>  	base =3D (base && (f->attr & DECODE)) ? base + f->offset : NULL;
>>
>>  	/* Decode the choice index number */
>> +	CHECK_BIT_BOUND(bs, 1);
>>  	if ((f->attr & EXT) && get_bit(bs)) {
>>  		ext =3D 1;
>> +		CHECK_BIT_BOUND(bs, 7);
>>  		type =3D get_bits(bs, 7) + f->lb;
>>  	} else {
>>  		ext =3D 0;
>> +		CHECK_BIT_BOUND(bs, f->sz);
>>  		type =3D get_bits(bs, f->sz);
>>  		if (type >=3D f->lb)
>>  			return H323_ERROR_RANGE;
>> @@ -727,6 +741,7 @@ static int decode_choice(bitstr_t *bs, const struc=
t
>> field_t *f,
>>  	/* Check Range */
>>  	if (type >=3D f->ub) {	/* Newer version? */
>>  		BYTE_ALIGN(bs);
>> +		CHECK_BOUND(bs, 2);
>>  		len =3D get_len(bs);
>>  		CHECK_BOUND(bs, len);
>>  		bs->cur +=3D len;
>> @@ -742,6 +757,7 @@ static int decode_choice(bitstr_t *bs, const struc=
t
>> field_t *f,
>>
>>  	if (ext || (son->attr & OPEN)) {
>>  		BYTE_ALIGN(bs);
>> +		CHECK_BOUND(bs, 2);
>>  		len =3D get_len(bs);
>>  		CHECK_BOUND(bs, len);
>>  		if (!base || !(son->attr & DECODE)) {
>>
>>
>> --=20
>> Eric Sesterhenn (Principal Security Consultant)
>> X41 D-SEC GmbH, Dennewartstr. 25-27, D-52068 Aachen
>> T: +49 241 9809418-0, Fax: -9
>> Unternehmenssitz: Aachen, Amtsgericht Aachen: HRB19989
>> Gesch=C3=A4ftsf=C3=BChrer: Markus Vervier
>>
>=20
>=20
>=20
>=20

--=20
Eric Sesterhenn (Principal Security Consultant)
X41 D-SEC GmbH, Dennewartstr. 25-27, D-52068 Aachen
T: +49 241 9809418-0, Fax: -9
Unternehmenssitz: Aachen, Amtsgericht Aachen: HRB19989
Gesch=C3=A4ftsf=C3=BChrer: Markus Vervier


--aSsR7hJsm8bq46wXp79pIcCruRnx1B05F--

--B3K6ttmAbvjOceNgS6mvHsNsL3k81rwWn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE4kR6dD1Cx4CoBY4sFLXvnJmdoEMFAlnmCh4ACgkQFLXvnJmd
oEONaw//ZqYbzIJAkEbO6qwfnO4SAgRmTiIpoAB3LrIymZ44mj7bHBNLkD5+36Dp
OvqD8y5/yXJT5F3yMsPnXUqQcrDUnQ7Ncn6fLlZhWoq5ycDkN8D/tuIMGnkkXsuw
HtLBJ+KQX7XcUdGCLq2WRU2xQoUdBjZri/rVnp4FmiO+lApVk6p2fJtSHkhj0fbD
8yRaTXi7p3QtKcBQn0i/klKt1ZIiMo+zMqjlHijtx55FMBr0hvThdjvqtBkV+Hqk
suAWnqe9SMpAyHzNaVQ9Yvo4st/htSab15egf6NMaYSvwM+biyo85ai4Kt/YyuJv
/yG4MHtnuR5ntsE9s+KqQKcWCjZrhjglZ0q0bMsNumuFNugdSOY+qn+5Rd04rhDB
0ohoLnQz4ro1LakKLco9VWdrNmAvDUB1j5UcTXCcYFSjHVEalv5ZB7xJEYIZ2US+
4uAeyY7JGy9OEUqwhV16knRpWjYpg2pON1ARalRn6jsXJhHiTTrcerfSWDlA47eX
8/AkfDUOpHsQueIV9RIL4S5SliDL+KL0+VTQ2e0lk9Y45N75gWDtwrNkwnktWJI/
cyCeJOaKjXAOjZW5MXTwff0TVMCT/FAgvQ2B/8bnOHvG10NEc3ukmsMLT3+UHqpH
m/2MqzjssjVDNr/fs0fIjVIatmYkYY+JlJrCnUI0HQOhuc5i3GU=
=wtI9
-----END PGP SIGNATURE-----

--B3K6ttmAbvjOceNgS6mvHsNsL3k81rwWn--
