Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6270C678D4
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 18:55:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233385AbjCGSzr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 13:55:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233398AbjCGSz2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 13:55:28 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0243016AC2
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 10:42:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=7Rqg/KElHCXUkdob4q8KrPhekjUP+A9kTvb6jPBYPlg=; b=OoRULQ7++tM41mSw5LQDQFTJhR
        hFFCkUENAO26eNHc4BLhmK7FNduMzQ8AtsrXWCvRAIsGysRhOhDiyvf0ia28p3hZ2lX4A2oLR60k4
        dSWYfajWQbhRqaGRCAolZ/hJPW1QZSWSrvS/HWYLhw5ZcY8e/hua4XP4vFd4yIEfrptinVdlSZLpY
        ue6Y7NdPPbeV93FNAoemXryW4b6AXq0U3U1NnmUPPlmJUQ9KviFaqwEZT6KwaS/b4FaPjBZvog2jj
        dW+yB1+aAfVNMAwA3Y4D8DxgMGK7u2j/JSWOUAukmwWSxNCur8rL8aZ3SThzb/r9PKBIxFcP7b6ST
        14l8Rvig==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pZcGz-00GqxL-Q1; Tue, 07 Mar 2023 18:42:53 +0000
Date:   Tue, 7 Mar 2023 18:42:52 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 12/13] netfilter: nft_redir: deduplicate eval
 call-backs
Message-ID: <20230307184252.GE226246@celephais.dreamlands>
References: <20230305121817.2234734-1-jeremy@azazel.net>
 <20230305121817.2234734-13-jeremy@azazel.net>
 <20230307123740.GD13059@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="iNxISMKqNLsGvozl"
Content-Disposition: inline
In-Reply-To: <20230307123740.GD13059@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--iNxISMKqNLsGvozl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-07, at 13:37:40 +0100, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > nft_redir has separate ipv4 and ipv6 call-backs which share much of
> > their code, and an inet one switch containing a switch that calls one of
> > the others based on the family of the packet.  Merge the ipv4 and ipv6
> > ones into the inet one in order to get rid of the duplicate code.
> >=20
> > Const-qualify the `priv` pointer since we don't need to write through
> > it.
> >=20
> > Set the `NF_NAT_RANGE_PROTO_SPECIFIED` flag once during init, rather
> > than on every eval.
>=20
> Reviewed-by: Florian Westphal <fw@strlen.de>
>=20
> > -	struct nft_redir *priv =3D nft_expr_priv(expr);
> > +	const struct nft_redir *priv =3D nft_expr_priv(expr);
> >  	struct nf_nat_range2 range;
> > =20
> >  	memset(&range, 0, sizeof(range));
> >  	if (priv->sreg_proto_min) {
> > -		range.min_proto.all =3D (__force __be16)nft_reg_load16(
> > -			&regs->data[priv->sreg_proto_min]);
> > -		range.max_proto.all =3D (__force __be16)nft_reg_load16(
> > -			&regs->data[priv->sreg_proto_max]);
> > -		range.flags |=3D NF_NAT_RANGE_PROTO_SPECIFIED;
> > +		range.min_proto.all =3D (__force __be16)
> > +			nft_reg_load16(&regs->data[priv->sreg_proto_min]);
> > +		range.max_proto.all =3D (__force __be16)
> > +			nft_reg_load16(&regs->data[priv->sreg_proto_max]);
> >  	}
> > =20
> >  	range.flags |=3D priv->flags;
>=20
> Nit: This could be updated to 'range.flags =3D priv->flags'

Will fix.

J.

--iNxISMKqNLsGvozl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQHhawACgkQKYasCr3x
BA2X8A/+Ojt1I3IRHp+lzSQQBZtmX1In3d17lN+xOnVq2zh9R1764zyFmsNObeZF
Lq6KqTNUu2Q7f1iaaI4f8QczP0YbaKIf7QucTvXy3CApTtHFFbqvWUitnJLI+NZy
Uh2Piw9p7gFCyhIVoflV96a6Dv5p6N/Xg7u1nf0CoN7hKLb59hEkjLIutO9PNOV6
/vbAXQ3jz+qsv+gZblqiE6r9SgeClBvR5fQXJD/5lwU1L/lRkawlbUvj8DhvMdGY
DLhM/Dyd/p9LmJgUS7r1gfoofCcEMeGgSWHkRasOad9rkBcRDsbAeUaSYxY4nCrX
Rylv990KurSmzKGtEa0UHf4phNAdd66sc858Kqk1C1eUBkwCaFXuEdf9cHLGmjLp
ndd5gsgGPOyq5BCjWgoRBHaj/YcCyxy3Ad3S2tLHoqEiHeLzOnm1pOzQnQDeXZHV
VJQC5PEaDgVaAkV3CeIy4aA0yZpGCYJUKTx9FiXXbb6o4w344xSLn0/W/GdKlhnJ
MxvHTF+QXY/gAopPbXt7ThEwrjZxyBrW2i7XzSV+nCsLmXdN12ZhqapnU6lLnQ6n
fx4SVoeVv4+TjMSlTnlDk/gzQvcbyCmqyEpNuqtDnBhsJgRIYeu/G9hLRzRmjLF2
l/TJDuAscVs85tdvJrhQ1xUbwoiEoU4m4LZtlKZboUa8xPCYKk0=
=PI7I
-----END PGP SIGNATURE-----

--iNxISMKqNLsGvozl--
