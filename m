Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A478CC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Nov 2022 18:46:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiKASqr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Nov 2022 14:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiKASqq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2022 14:46:46 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C33E1C435
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2022 11:46:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4AE+oYbIs1CBeey+OBOZnNvBArdKpYWiNhaF1MPforc=; b=sTnPWYFgGAWDiDUIrKtNvNNs7+
        c9NbZXkb6AJ1v4wXr3PirIvIS6OBgUOoy3I+7WKgJNFhVXMl/tBPMAauB33xJVZ9OyubnRWAimaou
        2xoSa5Cis2GpXBPUZEIsze/YCj/oJ6qPuf+kyCdt4lvo0M8kftTYjcWXrohpVbBVpK/thrgu1L9nG
        lvl5aONPqoVHqIp12NH47CipIT/E4O3ttOZIlDqtK2srx91W7Yv8AKX7pyhPkOgZRDVU/KF8XnGYm
        BW9nDwfNXxksyvGxzmqG+gnmfXtcEjzPNPpTwLHn6jsKoafnBJWZwaOZPQHAO5yHyAmW+WwhkVbug
        PqJ/r75w==;
Received: from [2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1opwHb-005p4E-8n; Tue, 01 Nov 2022 18:46:43 +0000
Date:   Tue, 1 Nov 2022 18:46:42 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v4 08/32] netlink: send bit-length of bitwise binops
 to kernel
Message-ID: <Y2FpkkeMF5zzHX7o@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
 <20220404121410.188509-9-jeremy@azazel.net>
 <You+bsAw2mbUuE6S@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jNfLDqRyVyzM6Cd2"
Content-Disposition: inline
In-Reply-To: <You+bsAw2mbUuE6S@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--jNfLDqRyVyzM6Cd2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022-05-23, at 19:03:42 +0200, Pablo Neira Ayuso wrote:
> On Mon, Apr 04, 2022 at 01:13:46PM +0100, Jeremy Sowden wrote:
> > Some bitwise operations are generated when munging paylod
> > expressions.  During delinearization, we attempt to eliminate these
> > operations.  However, this is done before deducing the byte-order or
> > the correct length in bits of the operands, which means that we
> > don't always handle multi-byte host-endian operations correctly.
> > Therefore, pass the bit-length of these expressions to the kernel in
> > order to have it available during delinearization.
> >
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > ---
> >  src/netlink_delinearize.c | 14 ++++++++++++--
> >  src/netlink_linearize.c   |  2 ++
> >  2 files changed, 14 insertions(+), 2 deletions(-)
> >
> > diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> > index a1b00dee209a..733977bc526d 100644
> > --- a/src/netlink_delinearize.c
> > +++ b/src/netlink_delinearize.c
> > @@ -451,20 +451,28 @@ static struct expr *netlink_parse_bitwise_bool(st=
ruct netlink_parse_ctx *ctx,
> >  					       const struct nftnl_expr *nle,
> >  					       enum nft_registers sreg,
> >  					       struct expr *left)
> > -
> >  {
> >  	struct nft_data_delinearize nld;
> >  	struct expr *expr, *mask, *xor, *or;
> > +	unsigned int nbits;
> >  	mpz_t m, x, o;
> >
> >  	expr =3D left;
> >
> > +	nbits =3D nftnl_expr_get_u32(nle, NFTNL_EXPR_BITWISE_NBITS);
> > +	if (nbits > 0)
> > +		expr->len =3D nbits;
>
> So NFTNL_EXPR_BITWISE_NBITS is signalling that this is an implicit
> bitwise that has been generated to operate with a payload header
> bitfield?
>
> Could you provide an example expression tree to show how this
> simplifies delinearization?

This rule:

  add rule ip6 t c ct mark set ip6 dscp lshift 2 or 0x10

has the following representation:

  ip6 t c
  [ payload load 2b @ network header + 0 =3D> reg 1 ]
  [ bitwise reg 1 =3D ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
  [ bitwise reg 1 =3D ( reg 1 >> 0x00000006 ) ]
  [ byteorder reg 1 =3D ntoh(reg 1, 2, 1) ]
  [ bitwise reg 1 =3D ( reg 1 << 0x00000002 ) ]
  [ bitwise reg 1 =3D ( reg 1 & 0x00000fef ) ^ 0x00000010 ]
  [ ct set mark with reg 1 ]

This patch is intended to fix a problem with the OR expression:

  [ bitwise reg 1 =3D ( reg 1 & 0x00000fef ) ^ 0x00000010 ]
 =20
The expression has length 12 bits.  During linearization the length is
rounded up to 2 bytes.  During delinearization, the length of the
expression is compared to the size of the mask in order to determine
whether the mask can be removed:

  if (left->len > 0 && mpz_scan0(m, 0) =3D=3D left->len) {
    /* mask encompasses the entire value */
    expr_free(mask);
  } else {
    mpz_set(mask->value, m);
    expr =3D binop_expr_alloc(loc, OP_AND, expr, mask);
    expr->len =3D left->len;
  }

Because the length of the expression is now 16 bits, it does not match
the width of the mask and so the mask is retained:

  table ip6 t {
    chain c {
      type filter hook output priority filter; policy accept;
      ct mark set ip6 dscp << 2 & 4095 | 16
    }
  }

> > +
> >  	nld.value =3D nftnl_expr_get(nle, NFTNL_EXPR_BITWISE_MASK, &nld.len);
> >  	mask =3D netlink_alloc_value(loc, &nld);
> > +	if (nbits > 0)
> > +		mpz_switch_byteorder(mask->value, div_round_up(nbits, BITS_PER_BYTE)=
);
>
> What is the byteorder expected for the mask before this switch
> operation?

NBO.

> >  	mpz_init_set(m, mask->value);
> >
> >  	nld.value =3D nftnl_expr_get(nle, NFTNL_EXPR_BITWISE_XOR, &nld.len);
> > -	xor  =3D netlink_alloc_value(loc, &nld);
> > +	xor =3D netlink_alloc_value(loc, &nld);
> > +	if (nbits > 0)
> > +		mpz_switch_byteorder(xor->value, div_round_up(nbits, BITS_PER_BYTE));
> >  	mpz_init_set(x, xor->value);
> >
> >  	mpz_init_set_ui(o, 0);
> > @@ -500,6 +508,8 @@ static struct expr *netlink_parse_bitwise_bool(stru=
ct netlink_parse_ctx *ctx,
> >
> >  		or =3D netlink_alloc_value(loc, &nld);
> >  		mpz_set(or->value, o);
> > +		if (nbits > 0)
> > +			mpz_switch_byteorder(or->value, div_round_up(nbits, BITS_PER_BYTE));
> >  		expr =3D binop_expr_alloc(loc, OP_OR, expr, or);
> >  		expr->len =3D left->len;
> >  	}
> > diff --git a/src/netlink_linearize.c b/src/netlink_linearize.c
> > index c8bbcb7452b0..4793f3853bee 100644
> > --- a/src/netlink_linearize.c
> > +++ b/src/netlink_linearize.c
> > @@ -677,6 +677,8 @@ static void netlink_gen_bitwise(struct netlink_line=
arize_ctx *ctx,
> >  	netlink_put_register(nle, NFTNL_EXPR_BITWISE_DREG, dreg);
> >  	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_OP, NFT_BITWISE_BOOL);
> >  	nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_LEN, len);
> > +	if (expr->byteorder =3D=3D BYTEORDER_HOST_ENDIAN)
> > +		nftnl_expr_set_u32(nle, NFTNL_EXPR_BITWISE_NBITS, expr->len);
>
> Why is this only required for host endian expressions?

I wasn't sure whether keeping track of the bit length by storing it in
the kernel would be an acceptable solution.  Doing it for both byte-
orders caused failures in unrelated test-cases.  Since NBO expressions
don't come up in my use-case I decided to restrict it to HBO to start
with, and, if copying the bit-length to and from the kernel *was*
acceptable, to fix those test-failures in the next version of the
patch-set (I assumed one would be required :)).

However, in the process of replying to the questions in your response to
patch 13, I have realized that this patch may not be necessary after
all.  The problem here lies in the code which attempts to turn a mask-
and-xor expression back into the corresponding original bitwise opera-
tion.  A different solution would be to make use of the native bitwise
operations introduced by this series to avoid having to convert to and
=66rom mask-and-xor expressions altogether.  Further explanation in the
later reply.

J.

> >  	netlink_gen_raw_data(mask, expr->byteorder, len, &nld);
> >  	nftnl_expr_set(nle, NFTNL_EXPR_BITWISE_MASK, nld.value, nld.len);
> > --
> > 2.35.1
> >
>

--jNfLDqRyVyzM6Cd2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmNhaYYACgkQKYasCr3x
BA2Pig/+PMbRypTXpOtkmRTfHdFsqdbTKJ8kGAlCkQ0D+zvMp6AkmuqK1uPEJwp2
nYz4MN9UauRMmj3g9K2GqFyRCnl286VuFirIt0bQTFj8T5X9aqlS4sTqQ6lhcfzM
M3wfYs1l+IH00Nbz0WK4eDrsA3uGOlzsh6OGoigAXClU8w8ozDjpCT6Hr7ynnV7h
dgihzhgsrcwvbh4J1dgh/6MErMsABpGQ/3LIJH8Lg0EYKXyBoK+4RsPgQuDTHZAs
O9L0OxNDsMfUGalmp4jE87OnbFapFSvUFg12+ahd6cYfrN43ESajBo3zwjT8XQoG
A9MmPCcqr+V2vwwnGfg/tJRLcpYj0+SQAB9kZUaEgg8vqE5aQ8Ngu1V1iryTA7kh
T0u22bzEIc8fBiTcJqxfcDh7qcge1O6Bi+7B+IUSzKY3HkH3BvW17rxhFZq99zj2
FtC9BYjsOrcGCD+7Or7ZHSQZE0VVyyHh9vzAOlpv9wvM82MCrgt65YViEAxWIvp9
x6yQRm1mLMZlhogtWIRpts2WSSxdTqI1SoEvJGklHVAamasXM9R+ooYYIBAZvQ8t
v/3KV/ix6aaUuTl1JHkItQXU0d3AVB0CKlTtiU3ou9eqAa/xhPyDNJraoxosLayL
weh7Kaj5tm+mdRjXN6vRUFv9GoyuiZfJKQe4LkKammOUunaUaAc=
=CkcA
-----END PGP SIGNATURE-----

--jNfLDqRyVyzM6Cd2--
