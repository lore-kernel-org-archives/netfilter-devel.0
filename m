Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C23A9C433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 11:07:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9C4FE611C4
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 11:07:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbhKFLKQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 07:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbhKFLKQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 07:10:16 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FE43C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 04:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=0clpHKRrUdgYpuOekFPGo+PJgyWhn5Qr7MdZOo4FP1I=; b=r5VI+aNV/ywg3YXqFmd340Y8Mn
        wHlVLO4DH1gHz6hlzRYXNp1h9WKwrDKCIxdRwM0GQP+6Rp9UN8bCCaQvgfcE9zMmhfEVrL3YLInMR
        sNYO1Qg8LMYL/BPW6mx/tu1um8wbuDaLHykQT73/7kbwzey6/XVjo02UzyREvPOWWowhl0JCGtz7/
        TmatfPAoOrHPkkkNG64puO9cxbHdcQrV+Mgtb0SEpafnJuVs7nnyrHF0jvBCSFmfNHcIrww/jxeWl
        PcKCm/dvgXbpD642SX0Lv/140LV8amKiyeRVZ1L5wiE6T89DDd96egSr0IT9ITN5XRf9W6NYXC/yK
        j4VVZ/UA==;
Received: from ec2-18-200-185-153.eu-west-1.compute.amazonaws.com ([18.200.185.153] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjJXp-004g8e-Hl; Sat, 06 Nov 2021 11:07:33 +0000
Date:   Sat, 6 Nov 2021 11:07:29 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH 13/13] build: bump autoconf version to 2.71
Message-ID: <YYZh8So8mUy6xI3K@azazel.net>
References: <20211030160141.1132819-1-jeremy@azazel.net>
 <20211030160141.1132819-14-jeremy@azazel.net>
 <q87qqs7q-4n50-3ppq-9867-q0n51n60p89n@vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="L75XXhx10osWr8TY"
Content-Disposition: inline
In-Reply-To: <q87qqs7q-4n50-3ppq-9867-q0n51n60p89n@vanv.qr>
X-SA-Exim-Connect-IP: 18.200.185.153
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--L75XXhx10osWr8TY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-10-30, at 19:21:07 +0200, Jan Engelhardt wrote:
> On Saturday 2021-10-30 18:01, Jeremy Sowden wrote:
>
> >diff --git a/configure.ac b/configure.ac
> >index ea245dae3796..8d18cc6eb7fb 100644
> >--- a/configure.ac
> >+++ b/configure.ac
> >@@ -1,6 +1,6 @@
> > dnl Process this file with autoconf to produce a configure script.
> > AC_INIT([ulogd], [2.0.7])
> >-AC_PREREQ([2.50])
> >+AC_PREREQ([2.71])
> > AC_CONFIG_AUX_DIR([build-aux])
> > AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2
> 1.10b subdir-objects])
> > AC_CONFIG_HEADERS([config.h])
>
> That's not a good move; it puts unnecessary stones on the road to
> building from git (i.e. with full autoreconf) on e.g. SUSE 15.X (and
> some other distros I am sure) that only have autoconf 2.69 or .65 or
> whatever.

Did wonder if bumping to 2.71 might be a bit aggressive. :)

> Unless there is a _specific new shiny m4 macro_ that is invoked
> somewhere, I cannot see a reason to gratuitiously bump PREREQ.

Fair enough.  Don't seem to be any signficant differences in the
generated files.  Will drop this in v2.

J.

--L75XXhx10osWr8TY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmGGYfAACgkQKYasCr3x
BA1SuRAAmAebSRHcwB3c3HPqAnvJ5ET5UpoL8gBfN+YKLna+R9gRhJ+4mboXCgtu
hiU0JGlU6t2NEJJmqoI/f5jtXwgWaf9dEg7QgIPPqmpthOBgE+/UjLAjOm7Dh9J1
ZzE/HLsqOLkt6DvAqbluC9AbuFUVHJfOS0wtu/jE0xQKR6AhdthPqAEstcz/TWrH
ckwnbkWcEr+lG1erRrGe6bfWDddhMHT7+v/l28MJL86DCzO6/XpIeslaYxycVLRT
h4QgRzQRrJbGThwQHFwtSKOcqWmbrIPUWOgtf/nn1uexiGB6yDo3HoFB6mxl6rHX
YDJ94JXNDqMuu8V2CgsheV+DeSBLGDIGOmkwCDLLO00kOzrS1tBm1BAcNo/DqaxY
J1YxZFpSqcMZ0i+b1HJovobl2gJUaz8YgyR/Bcp/jBl32W6k4OE/2QZfS9a06UoT
5jaSGaqom6hF+HJNRtwApzI0hDroAryqZoRQek4WBgPAfMmxOxpTHJOHZTMBfkTV
6nkIMI/ZaEhQLPc7DLizqII4/MHEbwadyP4H1jNR5/Lz5vBjMm3rLbzmnTP/vUQi
/j01j0On0y8dJ72bUgDHL6LTkDqJOCj1mShUPAHTJUDad457ouRXwrc76tIgQ3Wh
6GzzicYFRyi++I/WbEfYgrZqU495j6aUF9rYP5BKxhRoHtk4Ccc=
=E+Qo
-----END PGP SIGNATURE-----

--L75XXhx10osWr8TY--
