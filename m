Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6277EC433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 30 Nov 2021 10:46:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236057AbhK3KuD (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 30 Nov 2021 05:50:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236584AbhK3KuC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 30 Nov 2021 05:50:02 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2CC3C061574
        for <netfilter-devel@vger.kernel.org>; Tue, 30 Nov 2021 02:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KONKad38dq4qsBKevCPJT7GRpMP07KgS+EZF9MCdm1E=; b=VUh3wJ4rkhpS7n3XwlyEyerDEn
        vyNgq0aitqRHj2Hzx/UByqcG+/FL3kEoFrMR0nMuuJ2J6SyEJnT/D9UDt2tgKj8Dj+eJ59nCcHMZM
        NMtdgKlpbP2erdurC1eMmN9Go/7MwlOKt3BoNjprzWqp96DXOsQVgSYciFOFEBlEsxXBekDU4TP+R
        FwDqVO1SwCTaRXS6JsSgBJU6wrYyfj7TEW7xkFAoJQkR8IjOCtQzxS1RR9T/zJf2mSXGfNw7jLwvX
        J97RI3TebnBSMvBYAedQ5daAWLZU/bsapvVrBiYAv/5wl2mzjTWJtxb0AL943A36rpx2D/POUPbCR
        5rmdSD6A==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ms0en-00Awtr-A2
        for netfilter-devel@vger.kernel.org; Tue, 30 Nov 2021 10:46:41 +0000
Date:   Tue, 30 Nov 2021 10:46:40 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH v3 00/32] Fixes for compiler warnings
Message-ID: <YaYBEPXKyyWgogtX@azazel.net>
References: <20211124222444.2597311-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="8QJ16v2KjVmin42S"
Content-Disposition: inline
In-Reply-To: <20211124222444.2597311-1-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--8QJ16v2KjVmin42S
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-11-24, at 22:23:55 +0000, Jeremy Sowden wrote:
> This patch-set fixes all the warnings reported by gcc 11.
>
> Most of the warnings concern fall-throughs in switches, possibly
> problematic uses of functions like `strncpy` and `strncat` and possible
> truncation of output by `sprintf` and its siblings.
>
> Some of the patches fix bugs revealed by warnings, some tweak code to
> avoid warnings, others fix or improve things I noticed while looking at
> the warnings.

Just noticed I've mucked up the publication of this version of the
patch-set and included patches from a previous rebase.  Will send out v4
shortly with the duplicates removed.

J.

--8QJ16v2KjVmin42S
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmGmAQUACgkQKYasCr3x
BA07HRAAudsQdXvaMXcfqbRUt3ucHlVq0UfrWQGtB2LIYuAhfVAPxLm2isdJJjXr
VfOas58cQnATN9Yw24AL3h2ZegD/Fo9k1e5i8cuCTVrlSe1z116Cd33GN+8C8Lef
XL5y5OJC2sEdVeNHxkdZfQHcY3wV/6Tfs8+6WNIqUhn9ciH5G7Y/Jec1kwc38tRd
kKA2QL7HxYaQ9rm6R0sjJ946/2LkVJKCiqS6dD99vl/MDMTFo2SJp7umSX9tHjdR
77wCtYZUkLKa9Uav04J0BgNdoym1/tmqOOpeQZXSBTchw9g9bK3iYMelNfVWfz0w
nDWSjjY9u1W4pyBPlnNQ80lPQ5isum0voni2VBG3Ljw9nu5cqhb/FS74cVntBjMh
xLd4Mnxbla7TCPSIp9TapfLnWO1QXfQjDryUVNTiqX7b0VzQmsc7ShHAfjyREE0J
tmrtwoaRvUpZU0NleFV0oeohjXZcdXGG4YRlJuCmwhEcUiTDvBkl2cxFbWE/sFWG
iqlWvY3s6xxV48J4px1esBKu9yPv9SIF8nLxsyP3MvFy1sDCeWO3ZxXHWplIL/eJ
lc3lDt9vafaaoeevvwF2Zk8XCNRri5u8KINGkGcm7Xigzst3R2k2a5P7x76cko52
g3L4F+cvHUA91YYBL2Fy8G6/mZgtHEhOwSWx47iLx9tYiblpsWE=
=RvTM
-----END PGP SIGNATURE-----

--8QJ16v2KjVmin42S--
