Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B05ABEB64D9
	for <netfilter-devel@archiver.kernel.org>; Mon, 19 Jun 2023 14:03:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbjFSODv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 19 Jun 2023 10:03:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbjFSODu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 19 Jun 2023 10:03:50 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14D4310D
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Jun 2023 07:03:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FVjgOnYBrtDbthoWsZRdjF3zRQdFcwgU6gyxbw+3fcM=; b=SNtj1ADf9vetMvz7q37/vQ75qD
        3P1nCtNnpvozOdZvhqHuNxdG0POPG+ayAodmWir/t029UjkRHDbu2MVF/8Q+Vc9sWJ6NHhON5xZeF
        Jv7TEdwgJDYg+aGESFSDTQRrqR0UQVc1d9k4XpA+QQlstAky5htMoBVgeYEl84R9VChvlNSF70InR
        j7AyRHSxB4TzGoIj8NIBsrcJAkmd0hCKspqeg6p+3g9vvLtvFC7sraMP1TwpD5SBQMgAWBLWFrl3s
        TDFG5g3Wlm8uPYGrXxSlPXQ3nJoXuDKKV5cNaYPcoIGgi0+zqGYGF4yuN9CvclnJMH40rtUYaFS3o
        aoQkDP+Q==;
Received: from [2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608] (helo=azazel.net)
        by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qBFTu-0087sx-2G;
        Mon, 19 Jun 2023 15:03:46 +0100
Date:   Mon, 19 Jun 2023 15:02:34 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nf] lib/ts_bm: reset initial match offset for every block
 of text
Message-ID: <20230619140234.GC82872@azazel.net>
References: <20230611081719.612675-1-jeremy@azazel.net>
 <ZJBc2qInxGK7yY34@calendula>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RVt4/YBZenQug9fk"
Content-Disposition: inline
In-Reply-To: <ZJBc2qInxGK7yY34@calendula>
X-SA-Exim-Connect-IP: 2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--RVt4/YBZenQug9fk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-06-19, at 15:49:14 +0200, Pablo Neira Ayuso wrote:
> On Sun, Jun 11, 2023 at 09:17:19AM +0100, Jeremy Sowden wrote:
> > The `shift` variable which indicates the offset in the string at which
> > to start matching the pattern is initialized to `bm->patlen - 1`, but it
> > is not reset when a new block is retrieved.  This means the implemen-
> > tation may start looking at later and later positions in each successive
> > block and miss occurrences of the pattern at the beginning.  E.g.,
> > consider a HTTP packet held in a non-linear skb, where the HTTP request
> > line occurs in the second block:
> >=20
> >   [... 52 bytes of packet headers ...]
> >   GET /bmtest HTTP/1.1\r\nHost: www.example.com\r\n\r\n
> >=20
> > and the pattern is "GET /bmtest".
> >=20
> > Once the first block comprising the packet headers has been examined,
> > `shift` will be pointing to somewhere near the end of the block, and so
> > when the second block is examined the request line at the beginning will
> > be missed.
> >=20
> > Reinitialize the variable for each new block.
> >=20
> > Adjust some indentation and remove some trailing white-space at the same
> > time.
> >=20
> > Fixes: 8082e4ed0a61 ("[LIB]: Boyer-Moore extension for textsearch infra=
structure strike #2")
> > Link: https://bugzilla.netfilter.org/show_bug.cgi?id=3D1390
> > Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> > ---
> >  lib/ts_bm.c | 16 +++++++++-------
> >  1 file changed, 9 insertions(+), 7 deletions(-)
> >=20
> > diff --git a/lib/ts_bm.c b/lib/ts_bm.c
> > index 1f2234221dd1..ef448490a2cc 100644
> > --- a/lib/ts_bm.c
> > +++ b/lib/ts_bm.c
> > @@ -60,23 +60,25 @@ static unsigned int bm_find(struct ts_config *conf,=
 struct ts_state *state)
> >  	struct ts_bm *bm =3D ts_config_priv(conf);
> >  	unsigned int i, text_len, consumed =3D state->offset;
> >  	const u8 *text;
> > -	int shift =3D bm->patlen - 1, bs;
> > +	int bs;
> >  	const u8 icase =3D conf->flags & TS_IGNORECASE;
> > =20
> >  	for (;;) {
> > +		int shift =3D bm->patlen - 1;
>=20
> This line is the fix, right?

Yup.

> >  		text_len =3D conf->get_next_block(consumed, &text, conf, state);
> > =20
> >  		if (unlikely(text_len =3D=3D 0))
> >  			break;
> >
>=20
> These updates below are a clean up, right? If so, maybe split this in
> two patches I'd suggest?

Sure.

> >  		while (shift < text_len) {
> > -			DEBUGP("Searching in position %d (%c)\n",=20
> > -				shift, text[shift]);
> > -			for (i =3D 0; i < bm->patlen; i++)=20
> > +			DEBUGP("Searching in position %d (%c)\n",
> > +			       shift, text[shift]);
> > +			for (i =3D 0; i < bm->patlen; i++)
> >  				if ((icase ? toupper(text[shift-i])
> > -				    : text[shift-i])
> > -					!=3D bm->pattern[bm->patlen-1-i])
> > -				     goto next;
> > +				     : text[shift-i])
> > +				    !=3D bm->pattern[bm->patlen-1-i])
>=20
> Maybe disentagle this with a few helper functions?
>=20
> static char bm_get_char(const char *text, unsigned int pos, bool icase)
> {
>         return icase ? toupper(text[pos]) : text[pos];
> }

Sure.

> Thanks
>=20
> >  				if ((icase ? toupper(text[shift-i])
> > -				    : text[shift-i])
> > +					goto next;
> > =20
> >  			/* London calling... */
> >  			DEBUGP("found!\n");
> > --=20
> > 2.39.2
> >=20

J.

--RVt4/YBZenQug9fk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmSQX+8ACgkQKYasCr3x
BA1svxAAkyjf9KAdvR+19n3tQxtcQaljKBXVUSjUsxhbTW+vkfSwkbDLz14cR/1J
6nmW9Yh8M7IBxrLsARN9PxQcDLYiJy81tX7xMOKgxpPhBQq0h5dq74ABgEImrSS0
wRxGjRR9kmL173GloOAMElh7fNdeYGTtJo8jm2gsPqmk5LSr5uakt0dBhRLub/4N
vUqh1dFImncQYQhrahOa+znmMmKMLDtUZgXgG1SdK13LRHkXaiE2xpbVebxODh/4
v8hKK47L35FLgBhnbMEMf1CgvkvLPZlntRkMQxavbI7l+jXy4wUOVtYpRXo4CnZ4
4sqjYTTJidqEDS3gjLwzT/YwakYC9J2YVJLHlZgVnuguf0bSfQ3ubbOYznocYE6P
CNlwtW9YLj08KZ0FLWIQFGEHwWbLHjKpuWxtqCvN69WS87Q0VFpAHzImuwarcS9L
HKyeptlYr7jcxQcT8TnVha2sm0D52rUdvUc39d4PnZUCDSlLOvlSs1NqwqAOwcCl
k2GYOh+LTMsjep/wD9Hj+KD1Gh793wYUGTbGdPbOHm7G5ddkAhireBuPscAuGZaG
Zi5bubALLt3qv6KBgsPc640a7MFwFfJ72tRguZGN4BlUbJVGnLxwl/g6ePxMdl4j
dwuivrLtdUxVQsks39bLmwGsY1XBrIHtK2WZwgrMj0azCxOPwdY=
=m4cF
-----END PGP SIGNATURE-----

--RVt4/YBZenQug9fk--
