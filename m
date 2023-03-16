Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B34C6FD1F
	for <netfilter-devel@archiver.kernel.org>; Thu, 16 Mar 2023 18:56:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjCPS40 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 16 Mar 2023 14:56:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230045AbjCPS4X (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Mar 2023 14:56:23 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E90DCA44
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Mar 2023 11:56:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=cnfO244BfONDo+D3ryZGIPFuwU8254jP8kwgk11Ozyc=; b=lz2RuBmXgH4A2kdt2rOAiTqJux
        9vtLtczaBr3Ihoxp9/bwcMndpgCZdOTa6XFEUduOeRmniUDQ0gWEib2B68IjwsczQ58fUZflINR1d
        90B2+yziY0xzb5OWXyqHvPkMCjYL8osidQZ2DoQrAvzvxJr7jr3PCHn6cNm4rGUGVR4j9UK1ljHKi
        l0Jv0BQSDmcV7a7kS+b7EFsY0qGdw3dzos4aio1JMzeFyMvdhUlphF/4eaGVIIZne84wag9ZGCtuh
        o+H2x6g0Fn5cxr2UkwmE2fxjULF6VXeOyIm3lR8d4meP8IhNf3KB4UnDJerEIYdSsRPvvKsM7i43c
        LRKnYRfg==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pcslo-00B9Bb-St; Thu, 16 Mar 2023 18:56:13 +0000
Date:   Thu, 16 Mar 2023 18:56:11 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Florian Westphal <fw@strlen.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next] netfilter: nft_exthdr: add boolean DCCP option
 matching
Message-ID: <20230316185611.GD4331@celephais.dreamlands>
References: <20230312143714.158943-1-jeremy@azazel.net>
 <20230316092334.GE4072@breakpoint.cc>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fPjLnzwIo69qAueD"
Content-Disposition: inline
In-Reply-To: <20230316092334.GE4072@breakpoint.cc>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--fPjLnzwIo69qAueD
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

I was trying to avoid an on-stack buffer, 'cause it would be quite big,
while improving concurrency over xt_dccp.c, which has a single file-
scope buffer protected by a spin-lock.  I'll take a look at pipapo.
Thanks for the tips.

> > +	for (i =3D 0; i < optlen; ) {
> > +		/* Options 0 - 31 are 1B in the length.  Options 32 et seq. are
> > +		 * at least 2B long.  In all cases, the first byte contains the
> > +		 * option type.  In multi-byte options, the second byte contains
> > +		 * the option length, which must be at least two; if it is
> > +		 * greater than two, there are `len - 2` following bytes of
> > +		 * option data.
> > +		 */
> > +		unsigned int len;
> > +
> > +		if (options[i] > 31 && (optlen - i < 2 || options[i + 1] < 2))
> > +			goto err;
> > +
> > +		len =3D options[i] > 31 ? options[i + 1] : 1;
> > +
> > +		if (optlen - i < len)
> > +			goto err;
> > +
> > +		if (options[i] !=3D priv->type) {
> > +			i +=3D len;
>=20
> I think this needs to guard against len =3D=3D 0?

`len` should be at least 1:

> > +		if (options[i] > 31 && (optlen - i < 2 || options[i + 1] < 2))
> > +			goto err;
> > +

If options[i] > 31, we verify that we can get the length from
options[i + 1] and that it is at least 2.

> > +		len =3D options[i] > 31 ? options[i + 1] : 1;

If options[i] > 31, we assign options[i + 1], which we know is at
least two, to len; otheriwse, we assign 1.

J.

--fPjLnzwIo69qAueD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQTZkQACgkQKYasCr3x
BA2B1BAAjkahaLsYqNZhNA3hbXbroM5ku7PttOmC8AMnSQzH0QY26PihraaMKQPt
lYhtMczBaHAs4cQJFVA6dYjvUAxXt5TaS5ntgemkgNO5jwcgV6B3cF5XZY1maQeU
UKfVtLr+2POVQUeHsXGBpxQJ+AAg+cBluA/sj2HOI6Kq5EbBJPZOkV9XB1ODfq+0
BASMMg58cCPYnD53olju3NUAhDXa/i7lJ/DuZB/BEjRhn22XuFDcxTOeFBfi0zVI
hysP+x11fPcqGKeUAC3qJFGpk3bTR3PsAEgSnYxW/Ny4HOP6SlSIFFz6thz/m+A3
5vsRNjXEeE5sYeLG2378jzp6OZVJeHQ1qYzOG4j2m5aEPhpipt3yEWgO+NUYabMq
HTA5c09ztMvNPYf8J9S/ufV1GKY7fwXwmAadrtM7gVj6REVhLjzVwgkh7869WV2u
VsdVlAe3r0k+LEuAT2Xm5ZJuY9lWue3TZF1W8CIVvCIlPVz99DmBFfIjckqgvySZ
gkqHClnkcWUlKawv6hCyUJpEtYJF7naGOGjSyYKDQIfvnV8WeZls27WIgFSvWkvA
+1I+kOaBD2yTRLc+Pjb9fYg36qYR+XRTLnbu1jvd8ybx7I6GO6HmZxlg114XB3Iv
WvIHQNy+rOAbD/SUqbhFovPU+XBzZ7H/vTkREkz6WM5hWylTuZA=
=lzka
-----END PGP SIGNATURE-----

--fPjLnzwIo69qAueD--
