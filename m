Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C59C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Nov 2022 18:47:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229866AbiKASrG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Nov 2022 14:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229462AbiKASrF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2022 14:47:05 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F2171C435
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2022 11:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=q9c+2g7eBR5Y0JLFYkG1VF3eLuPCaAmM7wV0dmflPMM=; b=Yleh2kvkznIHOAqmwbBV5Vj1tH
        f0TKLBumyl2hY6Fvyqj5gPsl+w8qQ3kdMjtvyj8VTIbzw1PrF50frBtmCrCeLjjKCB77pNco+/e2P
        g7wd/UtfIbuADqW5XwwKt9b9SpBJWJvBemxYIEGgdsz+EutnYNJXasGHTQeojyrCBKygI0zsebznd
        dCENcFW9l+8e6qNzf3kMQ/R6PS0fcqdxA8GapNkyAd0WFBbZn+zgRLENjliE4sDpIHeVuGpGOBuuK
        PAWIuONogACHqnZ756KUStQqz6cqis56TZS8zStze26FEw7iBsIAQywMU1faA9n3UunqaKXHw9ldF
        pMYE8t6Q==;
Received: from [2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1opwHu-005p4r-ML; Tue, 01 Nov 2022 18:47:02 +0000
Date:   Tue, 1 Nov 2022 18:47:01 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v4 10/32] netlink_delinearize: correct type and
 byte-order of shifts
Message-ID: <Y2Fppd4tOmk7kuYv@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
 <20220404121410.188509-11-jeremy@azazel.net>
 <YovCEsqTL9wcuv55@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="5VRRSndsreB8Y+b5"
Content-Disposition: inline
In-Reply-To: <YovCEsqTL9wcuv55@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--5VRRSndsreB8Y+b5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022-05-23, at 19:19:14 +0200, Pablo Neira Ayuso wrote:
> On Mon, Apr 04, 2022 at 01:13:48PM +0100, Jeremy Sowden wrote:
> > Shifts are of integer type and in HBO.
> >=20
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > ---
> >  src/netlink_delinearize.c | 13 +++++++++++--
> >  1 file changed, 11 insertions(+), 2 deletions(-)
> >=20
> > diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> > index 12624db4c3a5..8b010fe4d168 100644
> > --- a/src/netlink_delinearize.c
> > +++ b/src/netlink_delinearize.c
> > @@ -2618,8 +2618,17 @@ static void expr_postprocess(struct rule_pp_ctx =
*ctx, struct expr **exprp)
> >  		}
> >  		expr_postprocess(ctx, &expr->right);
> > =20
> > -		expr_set_type(expr, expr->left->dtype,
> > -			      expr->left->byteorder);
> > +		switch (expr->op) {
> > +		case OP_LSHIFT:
> > +		case OP_RSHIFT:
> > +			expr_set_type(expr, &integer_type,
> > +				      BYTEORDER_HOST_ENDIAN);
> > +			break;
> > +		default:
> > +			expr_set_type(expr, expr->left->dtype,
> > +				      expr->left->byteorder);
>=20
> This is a fix?
>=20
> If so, would it be possible to provide a standalone example that shows
> what this is fixing up?

Without this, listing a rule like:

  ct mark set ip dscp lshift 2 or 0x10

will return:

  ct mark set ip dscp << 2 | cs2

because the type of the OR's right operand will be transitively derived
=66rom `ip dscp`.  However, this is not valid syntax:

  # nft add rule t c ct mark set ip dscp '<<' 2 '|' cs2
  Error: Could not parse integer
  add rule t c ct mark set ip dscp << 2 | cs2
                                          ^^^

> > +		}
> > +
> >  		break;
> >  	case EXPR_RELATIONAL:
> >  		switch (expr->left->etype) {
> > --=20
> > 2.35.1
> >=20
>=20

--5VRRSndsreB8Y+b5
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmNhaaUACgkQKYasCr3x
BA3IiBAAijUPpBaUC6NYeJPMTvWz4QJoe7YVqA2wU9kFsyC7VwT5DgDYpvGj2XRR
RvasNGfA/7uTkdqegex1xUm1I1sqHPW0I5rDcbCY5cbeX4BIiNi8+iMCpvilsCHV
f8Nqr64XDQbuNeUGNHfzsNOth/YqQQqo3ippxObbd/Qug7dEZ27Cpq0+y49iguJb
AjrSgcxDLnU8k26lsjojdGOlG8QUTfQaBGZhA4pP4tP5N7EgCdJ1U5xvcBvKd5dj
MTe7kGJcJf6Qv87nBJxbzUFnBuIdqF7+zhNVa7H42vFTLjKmg7kvGNTsRr9p3vWh
j9BQo+xKjCDbHuyWtIzbwmVQWZE8CIzY4+Fl1i3g/YnM89I34SHM2J3EmjkmBpiU
84kS4ONkK1sb0CMwHiJtMX0VXSw8C5BR6yxbcqu/KY1ufyNiyykD8ImNUpyEq4Mw
KI4jsQzM05DX1u7AIO4rOQ9bIyeNCWJMATPay+votYQL81h0p9Y4a0/3sOk5e2O4
PS1terWXNl9OKDfhOSNhwIoge3SSy4Qqaiq2L54HPDL4I4RA602fGTqUo8BBcFUR
v8+B77Ciqpbl0+JFAgrPsPXtEGjjZfCPn/tkwxILkaYgm0BfjR1K/SCop/gGfxkS
2+r33W6h8zsVHR/GbuISR6M+geHRZ/7fg6LgHcNunqAoNvJVDHg=
=OvLm
-----END PGP SIGNATURE-----

--5VRRSndsreB8Y+b5--
