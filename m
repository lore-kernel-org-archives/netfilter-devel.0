Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F0C5C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Nov 2022 18:46:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiKASqz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Nov 2022 14:46:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiKASqy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2022 14:46:54 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C590E1C435
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2022 11:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=e+5Ul9wgPl3N9NyhlfY804wrVVZp8OgLyUx0h55iISA=; b=MzyUOCx0U6VpkXQcEI9/XlV9Xw
        ypSnG3DV5aEv2kTGRpjjqnBV2FQ/SGr2dTmHAQ+MdM4hHFt3D+Yx9mvIcVqBNAGg8FxUGMvdfLxHD
        fr4JppExCOmMRpILe03rFrPBSglz1Zlh2oLwVVHJEtlDvxmteUZVMvUwH6bOXEvkf7kfsu6Iw4az8
        jwz53Ys94bL2qg3Sf4mJaKCe+SahUU4UWA5YVS3XCCS35C/xt9kwty5/+41cHc2Iqf4qUkqmo061f
        do0YAnXGjbjAAr40zmH18z+YNivjfcN7NNC5qbtwwmkYCZfurvz90hyww2tz1RcfEBV6WX8JhWtLJ
        zkuma8MA==;
Received: from [2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1opwHj-005p4N-VH; Tue, 01 Nov 2022 18:46:52 +0000
Date:   Tue, 1 Nov 2022 18:46:50 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v4 09/32] netlink_delinearize: add postprocessing for
 payload binops
Message-ID: <Y2FpmnPVGzUNFeIc@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
 <20220404121410.188509-10-jeremy@azazel.net>
 <YovCDObeM32n8uvT@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+si3KJpkRbmH9jix"
Content-Disposition: inline
In-Reply-To: <YovCDObeM32n8uvT@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--+si3KJpkRbmH9jix
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-05-23, at 19:19:08 +0200, Pablo Neira Ayuso wrote:
> On Mon, Apr 04, 2022 at 01:13:47PM +0100, Jeremy Sowden wrote:
> > If a user uses a payload expression as a statement argument:
> >
> >   nft add rule t c meta mark set ip dscp lshift 2 or 0x10
> >
> > we may need to undo munging during delinearization.
> >
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > ---
> >  src/netlink_delinearize.c | 39 +++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 39 insertions(+)
> >
> > diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> > index 733977bc526d..12624db4c3a5 100644
> > --- a/src/netlink_delinearize.c
> > +++ b/src/netlink_delinearize.c
> > @@ -2454,6 +2454,42 @@ static void relational_binop_postprocess(struct rule_pp_ctx *ctx,
> >  	}
> >  }
> >
> > +static bool payload_binop_postprocess(struct rule_pp_ctx *ctx,
> > +				      struct expr **exprp)
> > +{
> > +	struct expr *expr = *exprp;
> > +
> > +	if (expr->op != OP_RSHIFT)
> > +		return false;
> > +
> > +	if (expr->left->etype == EXPR_UNARY) {
> > +		/*
> > +		 * If the payload value was originally in a different byte-order
> > +		 * from the payload expression, there will be a byte-order
> > +		 * conversion to remove.
> > +		 */
>
> The comment assumes this is a payload expression, the unary is
> stripped off here...
>
> > +		struct expr *left = expr_get(expr->left->arg);
> > +		expr_free(expr->left);
> > +		expr->left = left;
> > +	}
> > +
> > +	if (expr->left->etype != EXPR_BINOP || expr->left->op != OP_AND)
> > +		return false;
> > +
> > +	if (expr->left->left->etype != EXPR_PAYLOAD)
>
> ... but the check for payload is coming here.

Will fix.

> I assume this postprocessing is to undo the switch from network
> byteorder to host byteorder for the ip dscp of the example above?
>
> Could you describe an example expression tree to depict this
> delinearize scenario?

Currently, demunging is only done for payload statement expressions, in
`stmt_payload_postprocess`.  However, this patch-set will lead to the
appearance of munged payload expressions in other contexts, such as the
example given above in the commit message:

  nft add rule t c meta mark set ip dscp lshift 2 or 0x10

The expression tree for the value assigned to `meta mark` is:

                              OR
		             /  \
                       LSHIFT    0x10
                      /      \
                RSHIFT        2
               /      \
            AND        2
           /   \
   @nh(8,8)     0xfc

and the `@nh(8,8) & 0xfc >> 2` expression needs to be demunged to `ip dscp`.

> > +		return false;
> > +
> > +	expr_set_type(expr->right, &integer_type,
> > +		      BYTEORDER_HOST_ENDIAN);
> > +	expr_postprocess(ctx, &expr->right);
> > +
> > +	binop_postprocess(ctx, expr, &expr->left);
> > +	*exprp = expr_get(expr->left);
> > +	expr_free(expr);
> > +
> > +	return true;
> > +}
> > +
> >  static struct expr *string_wildcard_expr_alloc(struct location *loc,
> >  					       const struct expr *mask,
> >  					       const struct expr *expr)
> > @@ -2566,6 +2602,9 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
> >  		expr_set_type(expr, expr->arg->dtype, !expr->arg->byteorder);
> >  		break;
> >  	case EXPR_BINOP:
> > +		if (payload_binop_postprocess(ctx, exprp))
> > +			break;
> > +
> >  		expr_postprocess(ctx, &expr->left);
> >  		switch (expr->op) {
> >  		case OP_LSHIFT:
> > --
> > 2.35.1
> >
>

--+si3KJpkRbmH9jix
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmNhaZoACgkQKYasCr3x
BA05xA//XOVgifo3RZqmJ1lQmG49znCMDDVjxhk7wALQGmQNF9sxVaKN+avLA55r
hy9lW1CCadH7iRwNGrZPrAmx9h/Of9eFjimW3+h0ifQSe7QmMXipVx4D6efLLB5R
wXW7cSzcyEF9y++CaZY9RVKswWgbptyaUeeLpdJmRPzt0YDv6aZ6Y7aobEp8ewlA
9Rkk3PzxCBQQ728J2DJvd6MBwrejJkf+uDTx3cEfsp4Bgnstbwn1rCP3ZQh7oAtI
ha6OJamhpaPcH24u5ACHFa1URJlboP7pXN8VHCKwDT+PmIaze6EUbIltrNUUsqBw
W52r2MLxRV7EtWENt7iL4DIYCkqYWuUMfKeEjhe+DvTpzQ1cvn6gFgn+nnmGJfQM
2TqxFunw9jedlSlhcdDJUXx+duNNDwmG6CwoaUFpmATLy7jg0NnICSMk5WiEqn45
HoJwIIZ+GNidq3k2wlsA13UuMYfK2JqzdrFkN+TAXK8/9YMmLkMBzJyhq2Rz8ZK+
zJpDdGlJQfjs3a3bTDMKIB3PysWENkswZ+MbG7yJm+hR90myjIHCty4IC5IuPWPW
s9loREu3wUIZ8ZjzpwZQ90xOifT8U5uILOnuODqFyD6Qj5sRUAjBxZUO/3AFPurQ
FtOf49qpPZYZ2Zsfg6cYmCacaUCaUH8NZO3uFzTRzXtCpqirm5k=
=OfPl
-----END PGP SIGNATURE-----

--+si3KJpkRbmH9jix--
