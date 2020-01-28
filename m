Return-Path: <SRS0=fFh5=3R=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D48BC33CB3
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jan 2020 10:00:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5952D24686
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 Jan 2020 10:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725901AbgA1KAk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 Jan 2020 05:00:40 -0500
Received: from correo.us.es ([193.147.175.20]:55450 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725853AbgA1KAj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 Jan 2020 05:00:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D24D56EADF
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2020 11:00:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C39EFDA715
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jan 2020 11:00:38 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B947BDA714; Tue, 28 Jan 2020 11:00:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AF0CBDA705;
        Tue, 28 Jan 2020 11:00:36 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 28 Jan 2020 11:00:36 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 92BDE4301DE0;
        Tue, 28 Jan 2020 11:00:36 +0100 (CET)
Date:   Tue, 28 Jan 2020 11:00:35 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf-next v4 00/10] netfilter: nft_bitwise: shift support
Message-ID: <20200128100035.m4s54v5mfrlqvo4e@salvia>
References: <20200115213216.77493-1-jeremy@azazel.net>
 <20200116144833.jeshvfqvjpbl6fez@salvia>
 <20200116145954.GC18463@azazel.net>
 <20200126111251.e4kncc54umrq7mea@salvia>
 <20200127111314.GA377617@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="iilk6oqjbqvyxqtq"
Content-Disposition: inline
In-Reply-To: <20200127111314.GA377617@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--iilk6oqjbqvyxqtq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 27, 2020 at 11:13:14AM +0000, Jeremy Sowden wrote:
> On 2020-01-26, at 12:12:51 +0100, Pablo Neira Ayuso wrote:
> > I've been looking into (ab)using bitwise to implement add/sub. I would
> > like to not add nft_arith for only this, and it seems to me much of
> > your code can be reused.
> >
> > Do you think something like this would work?
>=20
> Absolutely.
>=20
> A couple of questions.  What's the use-case?

inc/dec ip ttl field.

> I find the combination of applying the delta to every u32 and having
> a carry curious.  Do you want to support bigendian arithmetic (i.e.,
> carrying to the left) as well?

Userspace should convert to host endianess before doing arithmetics.

> I've suggested a couple of changes below.
[...]
> > diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
> > index 0ed2281f03be..fd0cd2b4722a 100644
> > --- a/net/netfilter/nft_bitwise.c
> > +++ b/net/netfilter/nft_bitwise.c
> > @@ -60,6 +60,38 @@ static void nft_bitwise_eval_rshift(u32 *dst, const
> > u32 *src,
> >  	}
> >  }
> >
> > +static void nft_bitwise_eval_add(u32 *dst, const u32 *src,
> > +				 const struct nft_bitwise *priv)
> > +{
> > +	u32 delta =3D priv->data.data[0];
> > +	unsigned int i, words;
> > +	u32 tmp =3D 0;
> > +
> > +	words =3D DIV_ROUND_UP(priv->len, sizeof(u32));
> > +	for (i =3D 0; i < words; i++) {
> > +		tmp =3D src[i];
> > +		dst[i] =3D src[i] + delta;
> > +		if (dst[i] < tmp && i + 1 < words)
> > +			dst[i + 1]++;
> > +	}
> > +}
>=20
> for (i =3D 0; i < words; i++) {
> 	dst[i] =3D src[i] + delta + tmp;
> 	tmp =3D dst[i] < src[i] ? 1 : 0;
> }

Much simpler indeed, thanks.

--iilk6oqjbqvyxqtq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEFEKqOX9jqZmzwkCc1GSBvS7ZkBkFAl4wBj0ACgkQ1GSBvS7Z
kBmgKBAAphYYSEZDBDU138aUGxWD+ii1KmlfNr58l2tbCRuCttNabzJfW/FOxBSX
lpdtJPTxY5/ivkfvxdh94Z2kN5hlejapigCdSQ3z2tUTDszpVWT2UkNHnmG/oALp
iZiQdkCo8AQrwjbQnz5yKoDWJWdTM+GPbNfOvjJQsoh4ocmpRxOahmeJ0koXwsdi
qqv08qRtGfJer+FQSU37YzYbjfn5JDWJ4wGc9qGMRoqF9vcYiQ5s14zB+fxa4wtH
FNdeARtOwI3yvlWZeD6vodeJSMOL6yWqEqFG9Ui1BWClRxTaqNmr33o8+MTQR0Mo
hP8GpHeMHhkHdtMA+nBGEiVA9goXBhv1/JHYpeZ8Yt87WYVdsc4Z4+NiPlaw2ese
1FmwthPBYplGA1NlZ5ljhzXv+t9LRXX73SJIY6bgQlxcNFIRtXZo9jca7q5wvi0m
WnofppZvgRXZwiIUHXZfLVZ6elAiGtHVJCwHU6esYrveP/a2P97lUlfWzHKDnppU
sbF7iY4rvvclngk8EUyWG5FHXUFuYO+9ZE3bM2KShvQvCD1LkaUcK4eqgNE0US/1
LJH/2czF8RIq/edKxVqBGEX1mTjg01eZQiNPsj4HyhTGuWxxRNruThDa4WdXbox+
HSZaT0Xmlx2Ga2snOT6awAsW6DFBVED1ZpSirXGp+AfFra0GF7Q=
=QiHo
-----END PGP SIGNATURE-----

--iilk6oqjbqvyxqtq--
