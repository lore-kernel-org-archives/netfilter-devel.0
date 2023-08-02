Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3A7CC00528
	for <netfilter-devel@archiver.kernel.org>; Wed,  2 Aug 2023 10:43:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbjHBKnl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 2 Aug 2023 06:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234364AbjHBKnP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 2 Aug 2023 06:43:15 -0400
Received: from taras.nevrast.org (unknown [IPv6:2a05:d01c:431:aa03:b7e1:333d:ea2a:b14e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BE3C4487
        for <netfilter-devel@vger.kernel.org>; Wed,  2 Aug 2023 03:40:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Kiks5kvDRlLxjGJf6jvPWm/xOGltmGhOoofUy7nnEK8=; b=auHJvXK6bTrQS/LMwoanpGNaic
        4V9COFwvXbUNEMiXpjPNFWo94Z33PZm0ZMG0Pic/6Dqt9q4oYgLp8xxgRGWw5gfPVAVgeIFIGayL/
        K9t++3FXWTg7XcG+PZIo4O7fM0IQ/MhlU0B3iTVWUtKikBtYhe5lPscoVYy/P89KPjW4expIYF1fk
        9znXAy2IGDL+YPGNvwFCgZpdbnEVcbuMV56+SM1+w39gXbntgs8UywvEKYkqivnwXnUfefsVRUCaw
        hJLC3kOVKHyqiGhNnhXgxbkTU3i4oJ9kmZkp8+0IJDdDetkstsAGL+rNQ+yQPrFeD5q6BlJKEeZoF
        Nm8Wfeqg==;
Received: from celephais.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f] helo=celephais.dreamlands)
        by taras.nevrast.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.96)
        (envelope-from <jeremy@azazel.net>)
        id 1qR9HV-001lng-0j;
        Wed, 02 Aug 2023 11:40:41 +0100
Date:   Wed, 2 Aug 2023 11:40:40 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: ulogd2 patch ping
Message-ID: <20230802104040.GK84273@celephais.dreamlands>
References: <20230725191128.GE84273@celephais.dreamlands>
 <ZMDLC8QFOUH9z7xQ@calendula>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="hS4KVxz99fuDIvbP"
Content-Disposition: inline
In-Reply-To: <ZMDLC8QFOUH9z7xQ@calendula>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:3c21:9cff:fe2f:35f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on taras.nevrast.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--hS4KVxz99fuDIvbP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2023-07-26, at 09:28:11 +0200, Pablo Neira Ayuso wrote:
> On Tue, Jul 25, 2023 at 08:11:28PM +0100, Jeremy Sowden wrote:
> > There is a ulogd2 patch of mine from the end of last that is still
> > under review in Patchwork:
> >=20
> >   https://patchwork.ozlabs.org/project/netfilter-devel/patch/2022120822=
2208.681865-1-jeremy@azazel.net/
> >=20
> > It would be great to get a yea or nay.
>=20
> What plugins are still IPv4-only in ulogd2?

ipfix, gprint, oprint and the SQL plug-ins all assume that input keys of
type ULOGD_RET_IPADDR are ipv4.  There is a separate ipv6 adddress type
(ULOGD_RET_IP6ADDR), but it is not used anywhere.

The question is what to do with ipv6 addresses on output, in particular
for the DB plug-ins where trying to write 128 bit values into possibly
32 bit columns might cause errors.  In the current version of the patch,
the gprint and oprint plug-ins are updated to output ipv6 addresses
correctly, the DB plug-ins replace the value with null, and I didn't fix
the ipfix plug-in.

As it happens, the mysql and pgsql schemas in doc/ should be fine, but
the sqlite3 one won't be.  My current thinking is to add a boolean
config setting to the SQL plug-ins to indicate whether the DB schema
can accommodate ipv6 addresses.

> Maybe add _IPV4 | _IPV6 flags to plugins hence it is possible to
> validate if user's stack is valid, otherwise bail out and provide a
> reason via logging?

The problem is that it isn't always possible to tell.  Consider a stack
with an NFLOG source.  The address family will depend on the family of
the table containing the rule outputting to the log, which is not
visible to ulogd.

> Regarding translation from network to host byte, I think it makes more
> sense to keep IPv4 addres in network byte, so filter and output
> plugings always expect them such way as you did in your patch?

Having revisited this work, I think my blithe assumption that I could
fix the handling of ipv6 addresses and the original endianness problem
in one patch may have been overly optimistic. :) In the next version, I
will separate the changes to keep ipv4 addresses in NBO from the ipv6
fixes.

Florian's observation about the ambiguity between real mapped ipv4
addresses and the synthetic ones created by this patch has prompted me
to revisit my approach to the ipv6 fixes.  My current thinking is to use
the `len` field of `struct ulogd_key` to keep track of the size of the
address: 4 =3D ipv4, 16 =3D ipv6.

J.

--hS4KVxz99fuDIvbP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmTKMqAACgkQKYasCr3x
BA3EXhAAz8RGcxdPfYnDz+nE+7uxqPviL91PxtoXYHiKGe9W5HflsuuzcQQ2omUm
YvGhXXq5JAZ3MLFl3TuExGf7xTvHlXXpryUyX8bboy4CKAcK4APJLeBaZqiTeKaf
fe8XSy/a9KX4dt7NnYF9Ww2IHf6Kfo87GXtJf14hQiL1RRp/djfQd3PBl6Cfu8JU
pbwht0aYEsE27hBdLp0NbXwf3kmAyZsteQjx0E6DN6pkeaYgVMqwW4YQN/4zqvrK
cm0RMKoYmNAyK75Upli5Sg5PWi1hUBw6jhEY/Iwdhh/9yH64SB+6t1gDMtciifep
JVwjlOTcf9CdFiBf6a/edL9Hhr/eaBFfcE92eKnPqXPWeHJHedTrtgzK1Ij1+jOc
WUefo+o5yssoVt6l/qTlow0BKz8aApkVZ/oLG+f4yGiwITZ7MdayfNondsbVoBIs
Ykp4F7EqjM3K+hD0SYEa7xXtlp79cmmRANRt+d+RkmzZ4fgxW5VqizEvfFrCc7Sx
1EaHuh8/YbcFfpGDR55TmCkSGASSDpWgdSKceZ7jfp9jenaGY6D9hXjLss+MSLxs
JICyn6Ywar+tysuhPYxs3S4jXmeWx6+q89pN3jaI/C467NRYq4vUSYLaIexrAe9M
6eFDlfeDE7XI00tycshdAyVU1xUHy020RecrAq6GhybiLNWuhHA=
=CEH7
-----END PGP SIGNATURE-----

--hS4KVxz99fuDIvbP--
