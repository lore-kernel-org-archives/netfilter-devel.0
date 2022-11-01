Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F59CC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Nov 2022 18:48:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230159AbiKASr7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Nov 2022 14:47:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbiKASr6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2022 14:47:58 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E85D11C435
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2022 11:47:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=z2b92HPEbTvDF8FaBugjEBdX4U34QGcuf4XJkH5Hays=; b=qEkVJ2GFXYM0az2h2QgzP3QdpV
        ThyZP/o8qs0gXSE3zD2wW7xJi/BrP1rg8gtwm/lUXbgs9sbgZfqav0aMko3n4mC+aXow7aaHJnMHK
        bQVi0M41VR/a2wsqXqjb9Wva+IDTqB05HlPlskoEe97iP3Ygwmdpe3hc76EGX/SSumTM03nq1c+0t
        iKpMc63PRsbFOg+vDUSOjRa7EEmuGa7pIvFRvUJWJZjw0LXaP9v5YWsEEtyaZrbQCPnZZagK+r03r
        JiFzBFUnzbTrBAyhUjO3Zygdcz1S9uL/86/ZyXxzeqyNOAu+it6hy8F04dETEjoGlJyY5U4moFbmH
        fOuj5NMA==;
Received: from [2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1opwIm-005p5W-3W; Tue, 01 Nov 2022 18:47:56 +0000
Date:   Tue, 1 Nov 2022 18:47:55 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v4 13/32] evaluate: support shifts larger than the
 width of the left operand
Message-ID: <Y2Fp2wDdck9RRyUu@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
 <20220404121410.188509-14-jeremy@azazel.net>
 <YovHkOThO0KYRGda@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uCfWwz2CLgq+WqO7"
Content-Disposition: inline
In-Reply-To: <YovHkOThO0KYRGda@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--uCfWwz2CLgq+WqO7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-05-23, at 19:42:40 +0200, Pablo Neira Ayuso wrote:
> I just tested patches 9 and 14 alone, and meta mark set ip dscp ...
> now works fine.
>
> So most of the work from 7 to 14 is to allow to use shifts.
>
> So 8, 10, 11, 12 and 13 enable the use of shifts is meta and ct
> statements?

Yes.

> The new _NBIT field is there to store the original length for the
> payload field (6 bits, for the ip dscp case)?

It's for this ip6 dscp case:

  ct mark set ip6 dscp << 2 | 16

This is linearized as:

  [ payload load 2b @ network header + 0 => reg 1 ]
  [ bitwise reg 1 = ( reg 1 & 0x0000c00f ) ^ 0x00000000 ]
  [ bitwise reg 1 = ( reg 1 >> 0x00000006 ) ]
  [ byteorder reg 1 = ntoh(reg 1, 2, 1) ]
  [ bitwise reg 1 = ( reg 1 << 0x00000002 ) ]
  [ bitwise reg 1 = ( reg 1 & 0x00000fef ) ^ 0x00000010 ]
  [ ct set mark with reg 1 ]

The problem is the last bitwise expression:

  [ bitwise reg 1 = ( reg 1 & 0x00000fef ) ^ 0x00000010 ]

`ip6 dscp` spans two octets:

  @nh(0,16) & 0xfc0 >> 6

The original length is 12 bits.  The LSHIFT expression changes the
byte-order to host-endian.

When the OR expression is evaluated, it is converted from:

  ${lhs} | 16

to:

  ${lhs} & 0xfef ^ 0x10

and when it is linearized, the bit-length is rounded up to 16 bits and
the byte-order is converted to big-endian.

During delinearization we try to turn the mask-and-xor back into its
original form before the original endianness and length are known, so
starting from:

  ${lhs} & 0xef0f ^ 0x1000

we fail to strip the mask and end up with:

  ct mark set ip6 dscp << 2 & 4095 | 16

Having gone back and reviewed this bug in the writing of this e-mail
I've realized that the introduction of native kernel bitwise op's in
patches 27-28 could obviate it.  In the current iteration of the
patch-set, the new bitwise op's are only used to support previously
unsupported bitwise expressions with variable right hand operands;
currently supported operations with constant right hand operands are
still converted to mask-and-xor operations.  If the linearization code
were changed to use the native op's for expressions with constant RHS's
too, the problematic conversion from mask-and-xor would go away.

When I tried this out, I had to make a couple of other changes to get it
working.  The big one was to register allocation.  Although netfilter
registers are 32-bits wide these days, they are currently allocated in
blocks of four for backwards-compatibility with older kernels.  Some of
the new test-cases added in this series failed because of a lack of
available registers, so I changed the allocation as follows:

  --- a/src/netlink_linearize.c
  +++ b/src/netlink_linearize.c
  @@ -97,7 +97,7 @@ static void __release_register(struct netlink_linearize_ctx *ctx,
   static enum nft_registers get_register(struct netlink_linearize_ctx *ctx,
                                         const struct expr *expr)
   {
  -       if (expr && expr->etype == EXPR_CONCAT)
  +       if (expr && expr->len)
                  return __get_register(ctx, expr->len);
          else
                  return __get_register(ctx, NFT_REG_SIZE * BITS_PER_BYTE);
  @@ -106,7 +106,7 @@ static enum nft_registers get_register(struct netlink_linearize_ctx *ctx,
   static void release_register(struct netlink_linearize_ctx *ctx,
                               const struct expr *expr)
   {
  -       if (expr && expr->etype == EXPR_CONCAT)
  +       if (expr && expr->len)
                  __release_register(ctx, expr->len);
          else
                  __release_register(ctx, NFT_REG_SIZE * BITS_PER_BYTE);

It's been seven years since the switch from 128- to 32-bit registers.
Would something like this change be acceptable?

J.

> On Mon, Apr 04, 2022 at 01:13:51PM +0100, Jeremy Sowden wrote:
> > If we want to left-shift a value of narrower type and assign the result
> > to a variable of a wider type, we are constrained to only shifting up to
> > the width of the narrower type.  Thus:
> >
> >   add rule t c meta mark set ip dscp << 2
> >
> > works, but:
> >
> >   add rule t c meta mark set ip dscp << 8
> >
> > does not, even though the lvalue is large enough to accommodate the
> > result.
> >
> > Evaluation of the left-hand operand of a shift overwrites the `len`
> > field of the evaluation context when `expr_evaluate_primary` is called.
> > Instead, preserve the `len` value of the evaluation context for shifts,
> > and support shifts up to that size, even if they are larger than the
> > length of the left operand.
> >
> > Update netlink_delinearize.c to handle the case where the length of a
> > shift expression does not match that of its left-hand operand.
> >
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > ---
> >  src/evaluate.c            | 23 ++++++++++++++---------
> >  src/netlink_delinearize.c |  4 ++--
> >  2 files changed, 16 insertions(+), 11 deletions(-)
> >
> > diff --git a/src/evaluate.c b/src/evaluate.c
> > index be493f85010c..ee4da5a2b889 100644
> > --- a/src/evaluate.c
> > +++ b/src/evaluate.c
> > @@ -1116,14 +1116,18 @@ static int constant_binop_simplify(struct eval_ctx *ctx, struct expr **expr)
> >  static int expr_evaluate_shift(struct eval_ctx *ctx, struct expr **expr)
> >  {
> >  	struct expr *op = *expr, *left = op->left, *right = op->right;
> > +	unsigned int shift = mpz_get_uint32(right->value);
> > +	unsigned int op_len = left->len;
> >
> > -	if (mpz_get_uint32(right->value) >= left->len)
> > -		return expr_binary_error(ctx->msgs, right, left,
> > -					 "%s shift of %u bits is undefined "
> > -					 "for type of %u bits width",
> > -					 op->op == OP_LSHIFT ? "Left" : "Right",
> > -					 mpz_get_uint32(right->value),
> > -					 left->len);
> > +	if (shift >= op_len) {
> > +		if (shift >= ctx->ectx.len)
> > +			return expr_binary_error(ctx->msgs, right, left,
> > +						 "%s shift of %u bits is undefined for type of %u bits width",
> > +						 op->op == OP_LSHIFT ? "Left" : "Right",
> > +						 shift,
> > +						 op_len);
> > +		op_len = ctx->ectx.len;
> > +	}
> >
> >  	/* Both sides need to be in host byte order */
> >  	if (byteorder_conversion(ctx, &op->left, BYTEORDER_HOST_ENDIAN) < 0)
> > @@ -1134,7 +1138,7 @@ static int expr_evaluate_shift(struct eval_ctx *ctx, struct expr **expr)
> >
> >  	op->dtype     = &integer_type;
> >  	op->byteorder = BYTEORDER_HOST_ENDIAN;
> > -	op->len       = left->len;
> > +	op->len	      = op_len;
> >
> >  	if (expr_is_constant(left))
> >  		return constant_binop_simplify(ctx, expr);
> > @@ -1167,6 +1171,7 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
> >  {
> >  	struct expr *op = *expr, *left, *right;
> >  	const char *sym = expr_op_symbols[op->op];
> > +	unsigned int ectx_len = ctx->ectx.len;
> >
> >  	if (expr_evaluate(ctx, &op->left) < 0)
> >  		return -1;
> > @@ -1174,7 +1179,7 @@ static int expr_evaluate_binop(struct eval_ctx *ctx, struct expr **expr)
> >
> >  	if (op->op == OP_LSHIFT || op->op == OP_RSHIFT)
> >  		__expr_set_context(&ctx->ectx, &integer_type,
> > -				   left->byteorder, ctx->ectx.len, 0);
> > +				   left->byteorder, ectx_len, 0);
> >  	if (expr_evaluate(ctx, &op->right) < 0)
> >  		return -1;
> >  	right = op->right;
> > diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> > index cf5359bf269e..9f6fdee3e92d 100644
> > --- a/src/netlink_delinearize.c
> > +++ b/src/netlink_delinearize.c
> > @@ -486,7 +486,7 @@ static struct expr *netlink_parse_bitwise_bool(struct netlink_parse_ctx *ctx,
> >  		mpz_ior(m, m, o);
> >  	}
> >
> > -	if (left->len > 0 && mpz_scan0(m, 0) == left->len) {
> > +	if (left->len > 0 && mpz_scan0(m, 0) >= left->len) {
> >  		/* mask encompasses the entire value */
> >  		expr_free(mask);
> >  	} else {
> > @@ -536,7 +536,7 @@ static struct expr *netlink_parse_bitwise_shift(struct netlink_parse_ctx *ctx,
> >  	right->byteorder = BYTEORDER_HOST_ENDIAN;
> >
> >  	expr = binop_expr_alloc(loc, op, left, right);
> > -	expr->len = left->len;
> > +	expr->len = nftnl_expr_get_u32(nle, NFTNL_EXPR_BITWISE_LEN) * BITS_PER_BYTE;
> >
> >  	return expr;
> >  }
> > --
> > 2.35.1
> >
>

--uCfWwz2CLgq+WqO7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmNhadoACgkQKYasCr3x
BA1OSBAAvt65a17/i+yUIQO9PE8uB7Aml/nCJ37euZWirdGTOm4Tth3Djk7e/thM
r+VP56Z+jhEhpyhmefotTudw3g5+3fQuHNU0GB6Bsgy+84//zeGhK/DxZYEhHJPe
1Sp/tNlIHMPD2P4xmCe5qd/TSz+jEEoV5o4sxY0aw4Po+RiYiR4W1zxxC9LHISYx
/3yBsXLwVE93tZtp2pjyJM4x72akwyfB6trlrzqk1YdJcfxTrxA3Uf3bUyJ/0Ukr
CJHia5yHfvfSfnx4023Zbz6GYHGEKvxe4Vwpl6Fyklyo7Viulh8Y9R5SryCsgSQM
NHcKe1hzdRCgTpepxK3LKXLdllMTJ2WxBRtnKCQQl7uQcjbUE9gYPLV8YQkWF9kl
T0qf1zUWWBs7V5O5tj4UtVivg61QcQN2vX4mkheg1d9Ealo6OHVzZhJ0I5qo7SWp
KQXjQ9wmcLurVmiIRPWjbuvg/i0bI8Kcgzy17DuwjVQc4JjKCoR5XDVFwGC1op5F
DZEO5oel9rn56keRPMUkq4vynD48BaV82ez9UIBX9zrxBg/sQqLNDwNrAzM/6Bxi
XLR28JDDR2c38ZrGrkfAniNtdU51wpcgaR5BppwvjYPqplehAP9tXzF0sgXotz2R
2ROpX/wl7bGAXx5hsTCmDuMuPJJUbtuf+Pc3HxMfoxy4TCEsWuE=
=yZ7b
-----END PGP SIGNATURE-----

--uCfWwz2CLgq+WqO7--
