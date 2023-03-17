Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5CEEC74A5B
	for <netfilter-devel@archiver.kernel.org>; Fri, 17 Mar 2023 22:31:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230321AbjCQWbv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 17 Mar 2023 18:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230103AbjCQWbu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 17 Mar 2023 18:31:50 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87DE769CC6
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Mar 2023 15:31:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZLTYEu2gdNZ2CHwLNGuT9ant0FlQiQ7b6ERJEDXXZFc=; b=fgMbptTQY/j3ZI3MbIV4clZtUu
        epm0LlZSGxPPiC4rSB7JTnqlgnQEtnf85j1S6YyR2K7eIiK8P+BjYk/h2IkUqq32eJoemgwlwVizu
        d1XPxAYcRGTKNvN3QeJnY8ho0iE3Z6Q5Bk1BvTjUPPC2Y6owGJ0ISFJkObQt9K6hRkEDP5nK18i4l
        VPhHyveN2Yzrw0gSYBOQfsd43sXNDaBTmXEv5AKNpi/pGgv+djuVetVkSVHk1zpyswTmDjooGKRzQ
        ru+Qi2viinPlDXnmJWwQjQCJObJg8ufyzQ8s2Po7vpYQAUvGYA+703PUfAX+9dBQJjviE9vJaJIj+
        9UMnMNhQ==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pdIbw-00Cfic-QK; Fri, 17 Mar 2023 22:31:44 +0000
Date:   Fri, 17 Mar 2023 22:31:43 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next] netfilter: nft_exthdr: add boolean DCCP option
 matching
Message-ID: <20230317223143.GA80565@celephais.dreamlands>
References: <20230312143714.158943-1-jeremy@azazel.net>
 <20230316092334.GE4072@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="+LnzutK+d9l82Nra"
Content-Disposition: inline
In-Reply-To: <20230316092334.GE4072@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--+LnzutK+d9l82Nra
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-03-16, at 10:23:34 +0100, Florian Westphal wrote:
> Jeremy Sowden <jeremy@azazel.net> wrote:
> > The xt_dccp iptables module supports the matching of DCCP packets based
> > on the presence or absence of DCCP options.  Extend nft_exthdr to add
> > this functionality to nftables.
> >=20
> > Link: https://bugzilla.netfilter.org/show_bug.cgi?id=3D930
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > ---
> >  include/uapi/linux/netfilter/nf_tables.h |   2 +
> >  net/netfilter/nft_exthdr.c               | 105 +++++++++++++++++++++++
> > +struct nft_exthdr_dccp {
> > +	struct nft_exthdr exthdr;
> > +	/* A buffer into which to copy the DCCP packet options for parsing.  =
The
> > +	 * options are located between the packet header and its data.  The
> > +	 * offset of the data from the start of the header is stored in an 8-=
bit
> > +	 * field as the number of 32-bit words, so the options will definitely
> > +	 * be shorter than `4 * U8_MAX` bytes.
> > +	 */
> > +	u8 optbuf[4 * U8_MAX];
> > +};
> > +
> >  static unsigned int optlen(const u8 *opt, unsigned int offset)
> >  {
> >  	/* Beware zero-length options: make finite progress */
> > @@ -406,6 +418,70 @@ static void nft_exthdr_sctp_eval(const struct nft_=
expr *expr,
> >  		regs->verdict.code =3D NFT_BREAK;
> >  }
> > =20
> > +static void nft_exthdr_dccp_eval(const struct nft_expr *expr,
> > +				 struct nft_regs *regs,
> > +				 const struct nft_pktinfo *pkt)
> > +{
> > +	struct nft_exthdr_dccp *priv_dccp =3D nft_expr_priv(expr);
> > +	struct nft_exthdr *priv =3D &priv_dccp->exthdr;
> > +	u32 *dest =3D &regs->data[priv->dreg];
> > +	unsigned int optoff, optlen, i;
> > +	const struct dccp_hdr *dh;
> > +	struct dccp_hdr _dh;
> > +	const u8 *options;
> > +
> > +	if (pkt->tprot !=3D IPPROTO_DCCP || pkt->fragoff)
> > +		goto err;
> > +
> > +	dh =3D skb_header_pointer(pkt->skb, nft_thoff(pkt), sizeof(_dh), &_dh=
);
> > +	if (!dh)
> > +		goto err;
> > +
> > +	if (dh->dccph_doff * 4 < __dccp_hdr_len(dh))
> > +		goto err;
> > +
> > +	optoff =3D __dccp_hdr_len(dh);
> > +	optlen =3D dh->dccph_doff * 4 - optoff;
>=20
> Perhaps reorder this slightly:
>=20
>      optoff =3D __dccp_hdr_len(dh);
>      if (dh->dccph_doff * 4 <=3D optoff)
> 	     goto err;
>=20
>      optlen =3D dh->dccph_doff * 4 - optoff;
>=20
>      options =3D skb_header_pointer(pkt->skb, nft_thoff(pkt) + optoff, op=
tlen,
> 				     priv_dccp->optbuf);
>=20
> This isn't safe.  priv_dccp->optbuf is neither percpu nor is there
> something that prevents a softinterrupt from firing.
>=20
> I suggest you have a look at 'pipapo' set type which uses percpu scratch
> maps.
>=20
> Yet another alternative is to provide a small onstack scratch buffer,
> say 256 byte, and fall back to kmalloc for larger spaces.
>=20
> Or, always use a on-stack buffer that gets re-used for each of the
> parsed options.

On giving it some more thought, it occurred to me that there would be no
need to read the option data, only the type and length, so one could do
something like this:

	optoff =3D __dccp_hdr_len(dh);
	if (dh->dccph_doff * 4 <=3D optoff)
		goto err;

	optlen =3D dh->dccph_doff * 4 - optoff;

	for (i =3D 0; i < optlen; ) {
		u8 buf[2], *ptr, type, len;

		ptr =3D skb_header_pointer(pkt->skb, thoff + optoff + i,
					 optlen - i > 1 ? 2 : 1, &buf);
		if (!ptr)
			goto err;

		type =3D ptr[0];

		if (type <=3D 31)
			len =3D 1;
		else {
			if (optlen - i < 2)
				goto err;

			len =3D ptr[1];

			if (len < 2)
				goto err;
		}

		if (type =3D=3D priv->type) {
			*dest =3D 1;
			return;
		}

		i +=3D len;
	}

J.

--+LnzutK+d9l82Nra
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQU6kEACgkQKYasCr3x
BA2KoQ//U5n0tNJOZSKIcyW7OOVbVv9hpatj8WXARHQsR1/SdDrZvZd/P39ONj+d
d/s4dxOZ18ml4kG54xHi8CGD/sT9APXSYp0+zmXBwGduqIRwZDA59+4XgHheqt4q
bLJvoQEMT0YZ4xcvGK/su8Bo2KA/SW37oeZl/L/UxqVy6AwGPyaOqGL+KaSAij48
PR5XfqvvyW3ROs1lGDw7Gt1ZWQuxlJH64TLFjUO9hFw8lv4veFWwh7HqC4W19lOC
aEqL0zBm3A2XfmFssL6uIT24sx4+X/KujloflGGdE4F1tlxMRVlnlQPQf6cG8WU5
QD06uToEqJwQlCAqwC0UEdc8UwIVCIR53BGjrn89pDnV1KR7jiSE01ISwKDAtork
59cb4F5Mu2CiYauF45/K2NzVbRZL1z8cV/8FuLETf+xygobJ24Sb6Glo/ymM2C91
wnC4+J3L64x6JfX/858O3YXWmnWgG+UE+Y0zLQrh/2sAVWWCcpwHLdrRFaOHKKlG
7bNWCise0aOZNfdjK7nvxsB6eWzB7aC/6S22ZP3YsaKeaNs069bfh3GalNI0yHZi
ruyzGOqYxL06jpnC2d+IfEKlbCx4SlmMN+wjEnGqg+0609lwtQy/bVPKtMkzqIwt
tugIzSPeoZj44+SzTdwfXsjeglJak5jMMNFRYYkXDkSLhaqPnPU=
=8cHA
-----END PGP SIGNATURE-----

--+LnzutK+d9l82Nra--
