Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E094C64EC4
	for <netfilter-devel@archiver.kernel.org>; Sat,  4 Mar 2023 12:40:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbjCDMkq (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 4 Mar 2023 07:40:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229478AbjCDMkp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 4 Mar 2023 07:40:45 -0500
X-Greylist: delayed 2405 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 04 Mar 2023 04:40:43 PST
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 900F4F77C
        for <netfilter-devel@vger.kernel.org>; Sat,  4 Mar 2023 04:40:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=REavg1rntZTp/m31SQfivFAzX4d4gWKpU6IscZ6SgI8=; b=HTG/4X+/4/Kny3XMtYaEKzJ/99
        nYs4RmhgumEY6ZLiH/bKwd4z4yFd+GPEi0Eq6/L6BlUUpp5gNTkoGfF0HQ96gK0ywhQI+xDx0XLPk
        1T72SI7S2K8Skr6rE5ZSBViJcltGomEDrc3Gtn5VpE/H+waqw4sZ595jpVJDEwQtgUCK57NAToaHP
        BEprhLNaBsh7YtdD9bUarNKV1TVm+ZQCdFxefgaHw6uyo9KUDhtV6422UWc/civcF6ZSV1SB8bdJP
        bvwYn0ERZ1GzYrGoBT6wyh1iAMYY4Wsc8brQoGTZcrIMUSqwf+V4dr1S/mUbULFxe7R8wglRoYV+I
        bNKETmKA==;
Received: from [2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] (helo=celephais.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYQZ0-00Cie2-G5; Sat, 04 Mar 2023 12:00:35 +0000
Date:   Sat, 4 Mar 2023 12:00:33 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: Re: [nft PATCH v4 13/32] evaluate: support shifts larger than the
 width of the left operand
Message-ID: <ZAMy4dowt9bDaPAS@celephais.dreamlands>
References: <20220404121410.188509-1-jeremy@azazel.net>
 <20220404121410.188509-14-jeremy@azazel.net>
 <YovHkOThO0KYRGda@salvia>
 <Y+I+khlMuL+kFoq9@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="FYnJG0FwakhA4wIz"
Content-Disposition: inline
In-Reply-To: <Y+I+khlMuL+kFoq9@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--FYnJG0FwakhA4wIz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-02-07, at 13:05:38 +0100, Pablo Neira Ayuso wrote:
> Long time, no news.
>=20
> On Mon, May 23, 2022 at 07:42:43PM +0200, Pablo Neira Ayuso wrote:
> > Hi,
> >=20
> > I just tested patches 9 and 14 alone, and meta mark set ip dscp ...
> > now works fine.
>=20
> I have applied 9 and 14, including one testcase for tests/py, so
>=20
>         meta mark set ip dscp
>=20
> works, so there is at least some progress on this, sorry about this :(

A step in the right direction. :) Thanks, Pablo.

J.

--FYnJG0FwakhA4wIz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmQDMtEACgkQKYasCr3x
BA3QohAAih7bCOMgr4L1Iz79H4BKFdSCaf2Dga6MR1kZKW3UzrGm2ZUp4NJTHKr/
afdKm4lvIRz+NzUR4HOXGcHYKt7MHjT02VueSVlSLoHff2LbkXi14s6sT7fA132W
MsWYUGcZ366u2zrh32340F7V+0odhGT719j+I9Tuf2RI9wcgHwKt+C5AgvgMt/qy
lI/3pgAZ133CBb5mZPl9l7GmHv1er3A5fcyKbBQ35lvBPN8buABJ9zFp8jEylEs5
5UvEwyafxGky1gWCzqCDuf3GjEftcDfQQ1CqWgYzFSXyuEw22WACTQM+7Xf2Cd9W
0ASXvIaGrhv+T4bpp4cTU8RYJaHyxL2yy1IjU98iTesOp8NYxHcIhYNZTDdwgQEp
RAbq3rWh/QhzzJPD+/jWYqzkMZnhZz2vbez6FBKrguLtCGmVH4UkYT/2IyHcFolI
i+A8pACgcC5por+XUvWZcjw1wQneA6G/24f3UOZbEBbH7Vruq6JPokKCeauo6Geu
hkhdXRTS7Y6QEv+KsF8gUp0yV9tjGJ6O6jqj2WQ0hvV86jGcGMn+/+SG1LwKTRVk
fI0coZYSxbNEQEN767BM1JuqKUbUk1UO/T3GUsH5vYRqNbjoe0Gfjfy1O3OiPV5f
efm2uDrvpb7SC8CV4Zv+zfAh/o50MLF8TLUpPsUsJe5GPHXYF6s=
=i+Xw
-----END PGP SIGNATURE-----

--FYnJG0FwakhA4wIz--
