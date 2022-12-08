Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 942A0C4167B
	for <netfilter-devel@archiver.kernel.org>; Thu,  8 Dec 2022 21:21:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbiLHVVp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 8 Dec 2022 16:21:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiLHVVo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Dec 2022 16:21:44 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A93DC25E1
        for <netfilter-devel@vger.kernel.org>; Thu,  8 Dec 2022 13:21:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QesKa7fp9X1jQXheP9SKSWGNXM1W4aHNwPsI43Wg6kM=; b=nZUuuBaeJzdpI98KkLlWVR8hJ/
        xxl7Tq64YCkkAbq2wS0M4LEiPJlT8v3Nxr74XW5wJBCYHcW4Wll+ql/hd1bLWYt9nmgLDnKuHNoXx
        FeVqNltPmRVoxoA++5CdzllVGnbqaBGhl9QNULCO0RPX+AYoR0NsU9CMA3xcCFZbL2U3IhInAhA5q
        5xnggWbzczF1GIVM1Ppb9qM3Mf2OGxoKMQFPjYHGvclt6SM//6DnlonDPLlzuLhJxNeYadGc7ofxa
        Mwb98TC7SeyQN9kb7vCmHoXk195/FsBBM48CM8AUzbywoskWL9rUfp8WOUaUQMkninuMGol26dy98
        Iq+tNuVQ==;
Received: from [2001:8b0:fb7d:d6d6:d237:45ff:fe20:4c6f] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1p3OKq-005fKw-7N; Thu, 08 Dec 2022 21:21:40 +0000
Date:   Thu, 8 Dec 2022 21:21:38 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH ulogd2 2/4] filter: fix buffer sizes in filter plug-ins
Message-ID: <Y5JVYhDHRnxeSEvB@azazel.net>
References: <20221203190212.346490-1-jeremy@azazel.net>
 <20221203190212.346490-3-jeremy@azazel.net>
 <Y5JSFbQVlHUbMMM/@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="HtKEbg+gzwR3MBfZ"
Content-Disposition: inline
In-Reply-To: <Y5JSFbQVlHUbMMM/@salvia>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d6:d237:45ff:fe20:4c6f
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--HtKEbg+gzwR3MBfZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-12-08, at 22:07:33 +0100, Pablo Neira Ayuso wrote:
> On Sat, Dec 03, 2022 at 07:02:10PM +0000, Jeremy Sowden wrote:
> [...]
> > The arrays are indexed by subtracting `START_KEY` from the enum
> > value of the key currently being processed: `hwmac_str[okey -
> > START_KEY]`.  However, this means that the last key (`KEY_MAC_ADDR`
> > in this example) will run off the end of the array.  Increase the
> > size of the arrays.
>
> BTW, did you detect this via valgrind or such? If so, posting an
> extract of the splat in the commit message is good to have.

One of the GCC sanitizers, IIRC.  I'll make sure to include a trace in
future.

J.

--HtKEbg+gzwR3MBfZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmOSVVoACgkQKYasCr3x
BA0OeQ/8CRfD4VAZYc31W0uX44NiYqNVYxVAX835Mu543oFyBi2/GlVTLMB9ofCF
/uchjLAKeouGQBffQUP73nOjQgiShqgk4r0MCKXyRBlyVxgscLTHVFSGcNXREXNR
HQmPW9S9P03Q0YOORKk4et9z2MqjiuKjJ6dQ9+rjjjeCfYapWrov/kskx2jva2A3
ju9OxRhdRd7JQmhJ0lxv0FSD1axhGme9S8Dl9rZZbY2ROm1d8P9cNJP2/ziA5HsM
BQyXzmvICC1944jk05mNxGuca6ttgxMY8Iung53CPfH1q8aU8gRMGKFQbvqYt+DY
iGZ5tzNvlNRB5LIXX8qtA/5FOqujmnmzhwTwfG7wUh+vlSRwsK195Jatp9pngkpV
LHMoULhxp5V/2dK0+L6kDb0cPUchJgOPWZyRffS6wsp3r075XzC954awk0NJP6eC
ifyzbrcQbjSmQWRlRaqrfIufpcwSuy95HSLcElIymJTeDFEwEyZ+2MYam4bIP1pz
VnGX5oeAF4Xae7JwZC8oeaDox/EuIORVvans5fltiyDIeRxDH63kPqQUTlVri2Z9
UBSb1IL+/yF+RCGrF/LuRQuxsYDs/y0JaIenR+snn3nnX55IsJemux6tgl7Hfin8
gIwk9LmahwNtIbGUBJG4B3UWUPPYLa+B1NDNuAjf/Pwmk6RBFwY=
=1wlP
-----END PGP SIGNATURE-----

--HtKEbg+gzwR3MBfZ--
