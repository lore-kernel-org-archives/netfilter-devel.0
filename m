Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EA6EC678D4
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 18:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbjCGSzF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 13:55:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbjCGSyb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 13:54:31 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 758299E326
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 10:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=G+qz8VVF1zJJ1PzAyGkxk5oJYFkUWx3OPCnXQL7/jMs=; b=PTK8x7VTLOayaBYsTp1E6HcO51
        8glO8KEAoPBs3aFANcz9AvrnwB5YRYDPBuXJzE08fR1E5L3/9IBNHhT4Wj+pzVxirYvMgfAYJDXv0
        ErbG6qtgCnHCyjkv1CsA8AryzIqgZ36pkb2MtrtxEqNEa7OU1D64NekYtiyNQZci6x9G+QxfWXRfN
        9R2XmMAxvyzlsdi/oeImbZDn0H4n4aXBXtMXSnl8AI0R9ijKZbgRvOICtOg4RRh4XOl392bHJIeg2
        H9yO+bze1sYu31ahq7k5tbg5K1ik4pwL49+aV8HM6OT6bgEHyCvJXKJxhopv7dvcjQxovdi9r4KLG
        rrYosihQ==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pZcGO-00Gqx9-Sf; Tue, 07 Mar 2023 18:42:16 +0000
Date:   Tue, 7 Mar 2023 18:42:15 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next 05/13] netfilter: nft_nat: add support for
 shifted port-ranges
Message-ID: <20230307184215.GD226246@celephais.dreamlands>
References: <20230305121817.2234734-1-jeremy@azazel.net>
 <20230305121817.2234734-6-jeremy@azazel.net>
 <20230307122751.GB13059@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="K/rj9BPe+CzL5Cof"
Content-Disposition: inline
In-Reply-To: <20230307122751.GB13059@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--K/rj9BPe+CzL5Cof
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-07, at 13:27:51 +0100, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > index 5c29915ab028..0517a3efb259 100644
> > --- a/net/netfilter/nft_nat.c
> > +++ b/net/netfilter/nft_nat.c
> > @@ -25,6 +25,7 @@ struct nft_nat {
> >  	u8			sreg_addr_max;
> >  	u8			sreg_proto_min;
> >  	u8			sreg_proto_max;
> > +	u8			sreg_proto_base;
> >  	enum nf_nat_manip_type  type:8;
> >  	u8			family;
> >  	u16			flags;
> > @@ -58,6 +59,8 @@ static void nft_nat_setup_proto(struct nf_nat_range2 =
*range,
> >  		nft_reg_load16(&regs->data[priv->sreg_proto_min]);
> >  	range->max_proto.all =3D (__force __be16)
> >  		nft_reg_load16(&regs->data[priv->sreg_proto_max]);
> > +	range->base_proto.all =3D (__force __be16)
> > +		nft_reg_load16(&regs->data[priv->sreg_proto_base]);
>=20
> Hmmm!  See below.
>=20
> > -	plen =3D sizeof_field(struct nf_nat_range, min_proto.all);
> > +	plen =3D sizeof_field(struct nf_nat_range2, min_proto.all);
> >  	if (tb[NFTA_NAT_REG_PROTO_MIN]) {
> >  		err =3D nft_parse_register_load(tb[NFTA_NAT_REG_PROTO_MIN],
> >  					      &priv->sreg_proto_min, plen);
> > @@ -239,6 +243,16 @@ static int nft_nat_init(const struct nft_ctx *ctx,=
 const struct nft_expr *expr,
> >  						      plen);
> >  			if (err < 0)
> >  				return err;
> > +
> > +			if (tb[NFTA_NAT_REG_PROTO_BASE]) {
> > +				err =3D nft_parse_register_load
> > +					(tb[NFTA_NAT_REG_PROTO_BASE],
> > +					 &priv->sreg_proto_base, plen);
> > +				if (err < 0)
> > +					return err;
> > +
> > +				priv->flags |=3D NF_NAT_RANGE_PROTO_OFFSET;
>=20
> So sreg_proto_base is only set if tb[NFTA_NAT_REG_PROTO_BASE] gets
> passed.
>=20
> So, I would expect that all accesses to priv->sreg_proto_base are
> guarded with a 'if (priv->sreg_proto_base)' check.
>=20
> > @@ -286,7 +300,9 @@ static int nft_nat_dump(struct sk_buff *skb,
> >  		if (nft_dump_register(skb, NFTA_NAT_REG_PROTO_MIN,
> >  				      priv->sreg_proto_min) ||
> >  		    nft_dump_register(skb, NFTA_NAT_REG_PROTO_MAX,
> > -				      priv->sreg_proto_max))
> > +				      priv->sreg_proto_max) ||
> > +		    nft_dump_register(skb, NFTA_NAT_REG_PROTO_BASE,
> > +				      priv->sreg_proto_base))
>=20
> sreg_proto_min/max are only dumped when set, so NFTA_NAT_REG_PROTO_BASE
> should not be dumped unconditionally either?
>=20

Agreed.  Will fix.

J.


--K/rj9BPe+CzL5Cof
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQHhYAACgkQKYasCr3x
BA1RWA//TC1BgDvcNXk3YBPwvoZ11BrTn6DVRWpwPoRLRDB2VW+DHY2mcb3XVWwl
aPqDSbEDCWHrCggkN2wqZ5P1JvPh0tkOZhPAmfUMG/eUtZPKVaahD0wsqyms3P9I
oEDICfQkeZ/XPdAow19KopGQFK2lKIjg/niNHuyWrdj3zhHi2bbbY/iphZ0ELbAH
ogHiezr6bImh+k896911+tKfbSTr7Pdz9PeXdMzBNdTLRuw1kvgCKffMjxxx8zG9
AycW8iIkFPtYLjemR9zTNi+bNn/9PMiTeTRWQFdJRogmu/L3u3W+sC+/EmI9Daeh
4M9KLvyIfAfYkoSZ4DEFWY8isdu/L7L24fx1iq1/VLdqeFlMBq90MphI2FaPMAgg
54GLDs1kkD+cXNbLS2+Y4LB4XPdkq98ZPEWk5w6HmdJu7coeADM6C3ty11oA5lHn
7hjC96ZDTy7ntIjYbfvZJlqvdTSHr/6kpsi5d6c5v7c1luzDfKbHVw3ehShfr3Jp
IBFlk8GnmpKzxS0/eGQQUvLtl9fdkhq+3vh0i5jfenMnfE1nVa0jKS/HqmSMdqiM
QBWORYXCF/Fwv7MnYdu8mrvaAr41Pgmq9onRv+x2b1R3h+7aSiyRT81oszEiG5Yv
qni30n+0pUzIWevL3Gsm4a2BYrGdsC5X1xQ7RPthTjKccwig4MY=
=1/df
-----END PGP SIGNATURE-----

--K/rj9BPe+CzL5Cof--
