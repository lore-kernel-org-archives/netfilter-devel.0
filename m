Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA546C433EF
	for <netfilter-devel@archiver.kernel.org>; Mon, 31 Jan 2022 18:31:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355813AbiAaSbM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 31 Jan 2022 13:31:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350610AbiAaSbK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 31 Jan 2022 13:31:10 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849CEC061714
        for <netfilter-devel@vger.kernel.org>; Mon, 31 Jan 2022 10:31:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=DW8lJBGhghYYrehV2+bPUWuajPP4AfLpaJHSMjYdqWo=; b=cFM6c3yHTvmJOzWk6IM17CKIiz
        pnHUVJIDF4i1FNjATF+PohHgXO9Dtyx3K1Y31l8owkg97pLmpw/wk5xEqbpYMnBk1c7OkYTsGol8E
        /Zv83yZKtKXRG9R5ZmgHlY8oQlpNvK0cuO15jLkJCwAA4ERe2EQzM8EmRkju7pEbrSfngsH1crHGE
        rt5CmhWsFR2nEMJwSGlkSTIgMIx7I4aANyQQr9GeXueK11YQq6ki21Tx6PUR1CpFrVodhXuaVV1VB
        4BKqApytIMMb2PCq2BwgeZ4PN4uq1sTdP83T8AyKS2ch+iRARCuZETU7hrJVRu7E+as5YbFSJukVj
        vgUecQ5g==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1nEbSF-007KtI-9s; Mon, 31 Jan 2022 18:31:07 +0000
Date:   Mon, 31 Jan 2022 18:31:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Philip Prindeville <philipp_subx@redfish-solutions.com>
Cc:     Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2 1/1] xt_ECHO, xt_TARPIT: make properly conditional on
 IPv6
Message-ID: <Yfgq6qWKgTV9NEkg@azazel.net>
References: <20210926195734.702772-1-philipp@redfish-solutions.com>
 <5s32r847-4op5-70s2-7o9n-4968n7rso321@vanv.qr>
 <05A51779-4B94-49BA-B1B8-6CA5BE695D80@redfish-solutions.com>
 <Yfe48T7Nxpzp20wL@azazel.net>
 <E7F7FB17-246B-4EFF-9449-FE1764F9816E@redfish-solutions.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4cupPT7jGUOV9uwx"
Content-Disposition: inline
In-Reply-To: <E7F7FB17-246B-4EFF-9449-FE1764F9816E@redfish-solutions.com>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--4cupPT7jGUOV9uwx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-01-31, at 11:27:25 -0700, Philip Prindeville wrote:
> On Jan 31, 2022, at 3:24 AM, Jeremy Sowden <jeremy@azazel.net> wrote:
> > On 2022-01-30, at 21:53:26 -0700, Philip Prindeville wrote:
> > > On Sep 28, 2021, at 3:43 AM, Jan Engelhardt <jengelh@inai.de> wrote:
> > > > On Sunday 2021-09-26 21:57, Philip Prindeville wrote:
> > > > > From: Philip Prindeville <philipp@redfish-solutions.com>
> > > > >
> > > > > Not all modules compile equally well when CONFIG_IPv6 is disabled.
> > > > >
> > > > > 	{
> > > > > 		.name       = "ECHO",
> > > > > 		.revision   = 0,
> > > > > -		.family     = NFPROTO_IPV6,
> > > > > +		.family     = NFPROTO_IPV4,
> > > > > 		.proto      = IPPROTO_UDP,
> > > > > 		.table      = "filter",
> > > > > -		.target     = echo_tg6,
> > > > > +		.target     = echo_tg4,
> > > > > 		.me         = THIS_MODULE,
> > > > > 	},
> > > > > +#ifdef WITH_IPV6
> > > >
> > > > I put the original order back, makes the diff smaller.
> > > > So added.
> > >
> > > Did this get merged?
> >
> > It did.  It's currently at the tip of master.
>
> Did we change repo sites?  I'm not seeing it here:
>
> https://sourceforge.net/p/xtables-addons/xtables-addons/ci/e3ae438e2e23f0849c756604a4518315e097ad62/log/?path=/extensions/xt_ECHO.c

Yes:

  https://inai.de/projects/xtables-addons/

J.

--4cupPT7jGUOV9uwx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmH4KuIACgkQKYasCr3x
BA11khAAs46gw6Zuc0+F1/2+j8LT8ru2mvBm/00sITxO5fI8J6YKo6P3Ykx6oS/P
4gpcs5OklaeGTVQqso27fVNdatcjxZXrYlVAPVWVhmVjnL+XBFxELSNmFHFcabXg
sS+8RcbQvkXG4ct+ngYNYU2TFHpOTZTnn/hBOMFYC0dAkcQOZGNyMeHli6GsjIg4
DY5xfnlsFOO+Fin+nSiktNWfhq5/olJL9N6S3584EE2P3SO1reM2bTgf0lV1y+M6
eOnCYXumO2SNVsxBY+xrYfG68Yh6whGBYWghTnUDRLH0l+rQV8jPx3siS1eJKliG
YaXZ7pLWzwjZFZuG/bx9CLv5kTifHKiTmcLac7miZ3rNAZuYJTqs87Wuy+noeX2s
qP+V+onLVdln75pqXvAADG46fnbEN4pueGP3lL3nbbPgoMu18ucnNqAI+Iq8c8Ba
vHi1NNc62ufSMEudwPWgz1Sjq0vd63TXcFyb2djT4hbRL62J1neWjN8bc7+l3EPu
SK5v4xHLwmFRcuCPGRU4gk1OUKgPD4U/V46a0S6YVwz8zTt5uG1LdtnnGDi+YqC9
SYf9lGwvkmKfX2psxPvddWckeKTSrddaCW83uoA91IUz1JssGYwaE1RI/w50zji3
5l0yxW5lq/JdJuBUd1G1n5gn8Z/X6gzPHFlPIIfgH9CS3c1PopQ=
=d5sQ
-----END PGP SIGNATURE-----

--4cupPT7jGUOV9uwx--
