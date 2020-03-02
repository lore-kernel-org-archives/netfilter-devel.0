Return-Path: <SRS0=hj4T=4T=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CFF2C3F2D2
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 14:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C68CB2187F
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Mar 2020 14:16:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="NUaE6SnQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbgCBOQk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Mar 2020 09:16:40 -0500
Received: from kadath.azazel.net ([81.187.231.250]:50000 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgCBOQk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Mar 2020 09:16:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=pC5BdRYAsofIcRFj8/SCW3PpmArlza4W47V96xnMytI=; b=NUaE6SnQIkGiyJODdJfMYJKM/A
        0a2xwYDgvEjBV6SICkj4Q0sC2sQdM+kSPGaTYkigX+47nIaDgnxjtjUlkqbb4mT8Fpb6h6bhUbSSt
        4X68bFhg5JOVqxYp3KnGBuAeJcng5jBNGhnAdx4+iidir4735IcOZA0lCCaGeokak0DN9faUSb3Cg
        nCkXpKwMvban5sjF3RQ9+J8zUX+TSdxeHCv3RbnaS0x6zNW/TIpMZK0at9QKyU8EPaqb6GdZLKz7W
        5dmAdbhOBVACSDwXy/uvVD/Up3mZdHmj8GUgNhQABvS0a0zfm2gq/36E5MRmUs+tq6pgTXMBoXsSO
        PjzJXxHQ==;
Received: from [2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1j8ls5-0005UN-Qq; Mon, 02 Mar 2020 14:16:37 +0000
Date:   Mon, 2 Mar 2020 14:16:36 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft 05/18] evaluate: no need to swap byte-order for
 values of fewer than 16 bits.
Message-ID: <20200302141636.GA996468@azazel.net>
References: <20200229112731.796417-1-jeremy@azazel.net>
 <20200229112731.796417-6-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="IJpNTDwzlM2Ie8A6"
Content-Disposition: inline
In-Reply-To: <20200229112731.796417-6-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--IJpNTDwzlM2Ie8A6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2020-02-29, at 11:27:18 +0000, Jeremy Sowden wrote:
> Endianness is not meaningful for objects smaller than 2 bytes and the
> byte-order conversions are no-ops in the kernel, so don't bother
> inserting them.
>
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  src/evaluate.c              | 2 +-
>  tests/py/any/meta.t.payload | 4 ----
>  2 files changed, 1 insertion(+), 5 deletions(-)
>
> diff --git a/src/evaluate.c b/src/evaluate.c
> index 9b1a04f26f44..d5cc386d9792 100644
> --- a/src/evaluate.c
> +++ b/src/evaluate.c
> @@ -149,7 +149,7 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
>
>  	if (expr_is_constant(*expr))
>  		(*expr)->byteorder = byteorder;
> -	else {
> +	else if ((*expr)->len / BITS_PER_BYTE > 1) {
>  		op = byteorder_conversion_op(*expr, byteorder);
>  		*expr = unary_expr_alloc(&(*expr)->location, op, *expr);
>  		if (expr_evaluate(ctx, expr) < 0)

This isn't quite right.  It should be:

@@ -147,7 +147,7 @@ static int byteorder_conversion(struct eval_ctx *ctx, struct expr **expr,
                                  byteorder_names[byteorder],
                                  byteorder_names[(*expr)->byteorder]);

-       if (expr_is_constant(*expr))
+       if (expr_is_constant(*expr) || (*expr)->len / BITS_PER_BYTE < 2)
                (*expr)->byteorder = byteorder;
        else {
                op = byteorder_conversion_op(*expr, byteorder);

I'll send out a new version this evening.

--IJpNTDwzlM2Ie8A6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQGzBAABCgAdFiEEd/6/sDFjb+OCRmRMonv1GCHZ79cFAl5dFT0ACgkQonv1GCHZ
79fopgv/Zh41I8rUpiGDvqJC/SdPw5tyRJ4AbYpQV10xOsu2T1zmgo295AS8yQue
OLOf0X+h+j/pbvWgLjDnF748vV/smTYPnlF64ZOC1HDqbT6lgPDKVnNBc/lbRmfR
43sh8cRvXmPrPdFYzDYcH531JBkr3Cwdc4n6ZTngsR/AVKxzi5Tm19Fi4NciS14q
CXB/vkow1SOchy8Nps55GnEx8jOlSYEYXIUuR7QbdCKloU+6McUeKj4CKl+Ke4OB
GQf0+RcMyWvUo8jC/iob7IN4zfqbsHQOEaPTyXQKZ8gisYryQWCzg54ARabS+8wD
Y7jcOgOfFIowBKThZqhP5aY6qs/ljPYp2rr4ztpmM3uXWydtz3dvAkCkLIPNiAC0
udYwVtMiZkoXAQYolTiTNrW8ZJB03EkPOOy/nmocekcmBdD+B5zl6JwDbS+NW7p1
1SqeTgen5ZPWEDIqlzC9DLWI/YFAWj6zZjHLIwQnnPHVwik6ReR5CPqcJS073YtO
IfGIxKvr
=jhqQ
-----END PGP SIGNATURE-----

--IJpNTDwzlM2Ie8A6--
