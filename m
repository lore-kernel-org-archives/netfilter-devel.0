Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 361DDC433FE
	for <netfilter-devel@archiver.kernel.org>; Tue,  1 Nov 2022 18:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiKASrV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 1 Nov 2022 14:47:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230178AbiKASrR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 1 Nov 2022 14:47:17 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33CDA1C92B
        for <netfilter-devel@vger.kernel.org>; Tue,  1 Nov 2022 11:47:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9hsXfJg5IOOJzmOAjORmtrtRo4d0V+TcuHOHpfEg1fY=; b=phRqGo2czwqEeb6B7UQAaT6B30
        ajKRLXBVetB0y+odWTdPPCc2mklPOjrXjaRLXKr8VBJU/MQssaOefPNOGPJWR4Ck4FJDh++58sBJm
        OWdaAjJuTA4PClMMkxdyimSqAC+H3gZD6jCX3GvuLanWHpUvB5tQjTWJWzAoxnrQCiMs5wk6vHFre
        ZM01la68MKiBguQF8CSguj/n8ce6OtMgQ9NK2VFpQVIxjNWr4LR1l2G6hW19zuosiiShqgEWVkqJf
        3N2SUTrQORwlMeEPo+Uvzho4qnfo8Bp+uoqzCcI4gbsFqOm0Wvccpefh1bpFdRQO9sCLdlgixdYmW
        GXL9MfLw==;
Received: from [2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1opwI6-005p59-7X; Tue, 01 Nov 2022 18:47:14 +0000
Date:   Tue, 1 Nov 2022 18:47:13 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [nft PATCH v4 11/32] netlink_delinearize: correct length of
 right bitwise operand
Message-ID: <Y2FpsSKtU6FqPCBQ@azazel.net>
References: <20220404121410.188509-1-jeremy@azazel.net>
 <20220404121410.188509-12-jeremy@azazel.net>
 <YovCuuA/egTL+TvL@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oUZ/440jtKhMDXkW"
Content-Disposition: inline
In-Reply-To: <YovCuuA/egTL+TvL@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--oUZ/440jtKhMDXkW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-05-23, at 19:22:02 +0200, Pablo Neira Ayuso wrote:
> On Mon, Apr 04, 2022 at 01:13:49PM +0100, Jeremy Sowden wrote:
> > Set it to match the length of the left operand.
> >
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > ---
> >  src/netlink_delinearize.c | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/src/netlink_delinearize.c b/src/netlink_delinearize.c
> > index 8b010fe4d168..cf5359bf269e 100644
> > --- a/src/netlink_delinearize.c
> > +++ b/src/netlink_delinearize.c
> > @@ -2613,6 +2613,7 @@ static void expr_postprocess(struct rule_pp_ctx *ctx, struct expr **exprp)
> >  				      BYTEORDER_HOST_ENDIAN);
> >  			break;
> >  		default:
> > +			expr->right->len = expr->left->len;
>
> This seems to be required for EXPR_BINOP (exclusing left/right shift)
>
> I am assuming here expr->right is the value of the bitmask.
>
> Was expr->right->len unset?

Hmm.  I can't now remember what purpose this served.  I spent a lot of
time staring at the delinearization code for binops and payloads while
debugging this series, and it is possible that I just spotted that under
some circumstances the length of the right hand operand after delinea-
rization wasn't right or didn't match what it did after evaluation, and
made this change for correctness.  However, reverting it doesn't seem to
break anything, so I'm happy to drop it.

> >  			expr_set_type(expr->right, expr->left->dtype,
> >  				      expr->left->byteorder);
> >  		}
> > --
> > 2.35.1
> >
>

--oUZ/440jtKhMDXkW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIyBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmNhabEACgkQKYasCr3x
BA34HA/4oV0aKE9kZUl2hbpAID8WjAy741DGtJKxKKBGaBz4Yq74jIYcUuuZAR+Q
fu59o1asgKL9Z5C41qVtuJKpT/I1KlB5Lq9mkMv4R5a2o8rBzc8AlH24VZjPn63S
Ev9EIc9EW5op4MmdQnB0s2y8NoFVy0ZJJtlFHw8iAN9Kx+upTLLj35wzDVgMDdaj
xLDAWKmNSfO3q89dAXTjheARGhVSseoGJ3bqPtKvy1Vtgwmo1e5RYVv1jsnYO5cM
0g6SbjKQMspJpssmaIS1WOkeaJTCC3wtEVr1fkEVXc//PbmxiOvASbHjSsp9VonV
80k13ynZvlqdU4XM8xt4nW9R8EfZ2VH07NAvWjwktP/OQ+Zc0bARFVWCHFFejLkb
Tir9VSBjnFNsF0Sv48KSsPAHeUz5SWlMf4tr6GuV7FQSBmjFE5Zv1KGArHcbjuMg
zFCjQcogea/mFC0Gt1xqqPaAmd+rDpaoWnPY8vT1sNJKzkYFfHpBbMy8i4z6+b/+
ZdQQwdiPQGoeXrRp2qyjEopoaUTRYJ6my0PY6P9H2vuoZ4BPf5tz6ukMzwLk7N1Z
n9F1wTL7HOh9ktwEQLOvPKEXjIgIZqEg6e+A8oge0OQjIyC9f0PKD2dxQSCPeCpZ
rFaK5kBPtrBvO0m4uHNvATI6G3gewOnEZ2AprIyUbh5hvtpkDg==
=mOSb
-----END PGP SIGNATURE-----

--oUZ/440jtKhMDXkW--
