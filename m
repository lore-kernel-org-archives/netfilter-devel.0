Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F00BEC4332F
	for <netfilter-devel@archiver.kernel.org>; Thu, 22 Dec 2022 11:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235148AbiLVLC3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 22 Dec 2022 06:02:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbiLVLC1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 22 Dec 2022 06:02:27 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B513927DE7
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Dec 2022 03:02:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xC26nqjGrp93c4sKC9A7DBlNu97MQ3t3p1aYEZjqGOk=; b=d2y8R/QjUCTGBW5bG5md7IfE/8
        sLsFMO4Fv/0dkw+F1TRJvHOm/RAEWSBjxkvGIm1S0PwZp8rBEGTgW5bEZ/J9t+2iN4fmyi6rBA2sz
        B4jd6b3ZDfPPj+0e6UswWXhS9YKAmai3l4q1GOE2X6Sm67TCs3ZqIBBcdHhffTLLo85X038Jw4C8i
        vcKcI+XUQMp7lfyOZcVBb87S6SPl/l6Dg5zQeHte2wMiZT8LLPUiJWHwRjW14Cp6q2yEY7ZtH363V
        Zyehl6KO4rZ0TziEWUC9W9NHja6FDCVNJ/x7lfCkiDs2ZgR0eUToL1RXaWHA5OXMX/uwJyHWu9whk
        g7+JcgUw==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p8JLB-004FVU-Iv; Thu, 22 Dec 2022 11:02:21 +0000
Date:   Thu, 22 Dec 2022 11:02:20 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH nft] scanner: treat invalid octal strings as strings
Message-ID: <Y6Q5PIB5ZIXFpJ40@celephais.dreamlands>
References: <20221216202714.1413699-1-jeremy@azazel.net>
 <Y6Qzq48e+ihIf4La@salvia>
 <Y6Q3AUkBrNbB2JBO@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="UFxYs9BBP+7RSHyG"
Content-Disposition: inline
In-Reply-To: <Y6Q3AUkBrNbB2JBO@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--UFxYs9BBP+7RSHyG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022-12-22, at 11:52:49 +0100, Pablo Neira Ayuso wrote:
> On Thu, Dec 22, 2022 at 11:38:39AM +0100, Pablo Neira Ayuso wrote:
> > On Fri, Dec 16, 2022 at 08:27:14PM +0000, Jeremy Sowden wrote:
> [...]
> > > We get:
> > >=20
> > >   $ sudo ./src/nft -f - <<<'
> > >   > table x {
> > >   >   chain y {
> > >   >     ip saddr 0308 continue comment "error"
> > >   >   }
> > >   > }
> > >   > '
> > >   /dev/stdin:4:14-17: Error: Could not resolve hostname: Name or serv=
ice not known
> > >       ip saddr 0308 continue comment "error"
> > >                ^^^^
> > >=20
> > > Add a test-case.
> >=20
> > Applied, thanks.
> >=20
> > I am sorry I missed this patch before the release.
>=20
> Hm. I thought this patch just fixes the parsing of octals.
>
> iptables and iproute seem to support for octals?

So does nft.  However, 0308 is not valid octal, and nft was silently
truncating it to 030.

For hex and decimal, we know that the entire number string is valid in
the base and only have to worry whether it is too long and may result in
a out-of-range error.  For octal, there is also the possibility that the
string may contain 8 or 9.  This patch adds a check for this and if the
check fails the failure is handled as an error in the same way it would
be if strtoull had reported `ERANGE`.

I did consider adding an `{octalstring}` match to handle octal
separately from decimal, but in the end the solution in this patch
seemed simpler.

J.

--UFxYs9BBP+7RSHyG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmOkOTYACgkQKYasCr3x
BA0lxRAApJuh1i5nCbKX4cd7fiH8Bjkjk3nNOziLRufHq0rsYw2v46AcdiHPM47F
suBEOdq7sanPJxrcd9xVVi7yilV751Qw9qsvPM+k3oYK10YLlCszBN5ZbJ9hNEiz
meK5VWLzp+lCSKCb/dARqVFKFDzzb91abZXvTEtGliEO++hEL30HKlbGWp6WvigR
7Q36i++DAPoJc/PH3Mw+k0MnGAmD8OgpT7fBsgL/tNRXjyXSUpZ75WBrCwVKVn0W
8KL80jjXZ/qr20UVZzWxFFHbdMGA5nFxK3kqWeBpq6tGt6ej056R7N5fEUtGWnIP
bWKUTMadbBhM3f37S/ODjT/uNiLWu248V6OWz03r3DZbogjpZBG9JnSOOIgNv1tf
5uvPV2n/XGW/jktIUlCjFaMu8sQCOp/7fyEgSIVphaXdPrcluC1MypsGLXTo4PGV
/KQ0nOa/nifBhNZvbIqsMQqJN2/n1exWBGfM2PaaZnppFbRuRvLvqN+0GoW0YfI0
dPfY2da1gTPWTXBGRr+DyoWJGAK4JDC6xE6xMjtqAZ6vOqRuda5xZrGWQ5jfJvxf
rVu2qhtoyDuJo7f5NCU39IMfpS6vCAVvm8rfIXDgqdYzTTjDE95NJbMjDJtSfwHJ
xkyN3hDeXAUXnpmnCLYducBoPJaINiNzGyW4TAL5lN3b8Q/ewlE=
=w3bX
-----END PGP SIGNATURE-----

--UFxYs9BBP+7RSHyG--
