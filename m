Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75E48C433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Nov 2021 16:08:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C4A861B49
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Nov 2021 16:07:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236170AbhKQQK4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Nov 2021 11:10:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233995AbhKQQKy (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Nov 2021 11:10:54 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E8A9C061570
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Nov 2021 08:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ReaNtMOOcNQyD8ZU9/W0KlOvdTgcTttU85ZSAjVbugg=; b=J0H5EzEJO7E97xaqxaYPZSoLXm
        KnvMv55Tjh9Jveg+3UpkpKRatFJcSWw+wLXXt5TxASS+KW0QpxjdvSpsGnpvqhdP+7VO/6ADzHrjl
        0KDyUwiGmtAtLJ8Q1/ujR7U/GWt4eVCwCz5ZOgUBoOQxVoQM9VGnq4CeJKZmH0x8xiyTh6gvDawdb
        9/WlazlinM5D9ZRRLEm1de7rIl8bBazOfVmX9Jnv8fB6PBkSfwSamy/N/WTNRhc1FDVhgbFDTVXtI
        ziQSGnT5WYBxIbV1TL3jm6Z2UznfSwjaCIFdL4xvj2HV3XGpKhV5BAHBiUB07mIQvOBwXuGITeP2i
        GMcfLAww==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mnNTU-00FdVx-W4; Wed, 17 Nov 2021 16:07:53 +0000
Date:   Wed, 17 Nov 2021 16:07:43 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH v4 00/15] Build Improvements
Message-ID: <YZUozx/W3CRKYYBE@ulthar.dreamlands>
References: <20211114155231.793594-1-jeremy@azazel.net>
 <YZOewaJ0kmJ0Zvpw@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="nCEeJ3GIprPPGRBN"
Content-Disposition: inline
In-Reply-To: <YZOewaJ0kmJ0Zvpw@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--nCEeJ3GIprPPGRBN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-11-16, at 13:06:25 +0100, Pablo Neira Ayuso wrote:
> On Sun, Nov 14, 2021 at 03:52:16PM +0000, Jeremy Sowden wrote:
> > Some tidying and autotools updates and fixes.
>
> Series applied, thanks.

Thanks, Pablo.

> BTW, enabling a few output plugins here, such as pcap and dbi, I don't
> think this is related to your patches. Probably acinclude.m4 can be
> replaced by direct AC_CHECK_LIB() from configure.ac these days?

I did start to look at acinclude.m4 because many of the third-party
libraries ship pkg-config files these days, so it may be possible to do
some pruning.  I'll get the compiler-warning fixes ready first.

J.

--nCEeJ3GIprPPGRBN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmGVKMAACgkQKYasCr3x
BA2v1g//W1qshncG8oPMrGsMNAY/gT9B5+zRoKF71ttWh4V4c+JlSDZgHcnCWpeS
kw3UtNWdepuKiTvY0oa6+NZhQIcMOidGawIGx5t3Cb11zSDDlyHXCgMCwTHMKBnt
PNdVfbZyuuO/ZiQh2K83YM6OY7HpKmwAgvYTFn3ChW1n1ML3JWgLLsQRIybYHyTo
m5bUZyx1wwvoDuBqi0Okq5CpQ1Q0YtWr+droeAZV29905/lmIoXMBuavGdD2X+Ax
QC2LeG3t2Dpm/iADKm6Wci4zQpFBFF0g3avCwnItlFlf+6suWgh1WZJPYz3fmL3Y
6TOHhGeTz22zNwcsIlRZs5mDOWbvPqnyZdnbV3DE6Ir2AynPySIJg2PwrRBhAGlm
8/swOrlJmGaQPDeN30YhKxcJBCtndZlp4SwNCMKK7Hf9ZZMb0cdFypJ8NjDnB4Z2
7fuOF3S1DSSQgJX3SfZ7heJAfjHOFoP11p9OgIr3IQsrvfUqv2vK2ozCdb2EbTSD
khUDUb6jlwgAKpdP6EWByq4yt69ojPLcrxBXK5YGPKyjGrcpD0Qkx4H1bLBzCLyE
lcasCpN22i8r/BLBaMKpaTPkrj8RoFrqT8TRncBBvUtN5iSDOPnaLn8c2u2wY/ui
1Ah4AtLEQ2Z5iI8fdUrUK1QbQPll+cMTQDjni5PeQxwLUa9sa2s=
=1q11
-----END PGP SIGNATURE-----

--nCEeJ3GIprPPGRBN--
