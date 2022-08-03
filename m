Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34C85C19F2B
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Aug 2022 21:02:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238595AbiHCVCX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Aug 2022 17:02:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231605AbiHCVCX (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Aug 2022 17:02:23 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BB15A175
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Aug 2022 14:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=JMS74JQjBY2+Br0KaLtVPsT+iAbcbaF5i7ZvU2UpNmo=; b=PEX1taTmdqg3dZPLi/oyPNVNGT
        ez/PulBsVAGPclB9+YdFE3yNc9YB0ncZ+T2v8RV5GYb1KSkRQMEEy6alpIU624mDcc5pF2OdqfgNd
        yzuO/GZqeCm3HQJsB6x7toTDy+eDS7yZZyW73pXcRhV/4Y+29fNc7FHo7Q+m9cBtYc0YyUuk6pnui
        Wjfvox0YqCCiIgYX3aSUIYuyZCTGh+qmtwmJj7gcafkiT6BcJDXy+bJ2SC0OZElz3Hz/Sgan2DG+I
        K5iYSlXoOQPIGmS44JpsXJBVWa7tYUFcQmUS1oUxSOGfwaapoom/Xu4bsRfu/3XLZ573MNRw9ug6A
        E6uSLaaQ==;
Received: from [2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oJLVR-001H5w-FZ; Wed, 03 Aug 2022 22:02:17 +0100
Date:   Wed, 3 Aug 2022 22:02:16 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Mark Mentovai <mark@mentovai.com>,
        Duncan Roe <duncan_roe@optusnet.com.au>
Subject: Re: [PATCH libmnl 5/6] doc: move man-page sym-link shell-script into
 a separate file
Message-ID: <YuriWD5FTtrOsGix@azazel.net>
References: <20220803201247.3057365-1-jeremy@azazel.net>
 <20220803201247.3057365-6-jeremy@azazel.net>
 <2spnnr6s-1q7s-12s1-n688-463n9q162np0@vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ZS37eozskSMV/gQs"
Content-Disposition: inline
In-Reply-To: <2spnnr6s-1q7s-12s1-n688-463n9q162np0@vanv.qr>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:f47b:9ff:fe41:7a71
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--ZS37eozskSMV/gQs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2022-08-03, at 22:56:32 +0200, Jan Engelhardt wrote:
> On Wednesday 2022-08-03 22:12, Jeremy Sowden wrote:
> > We use `$(SHELL)` to run the script and exec bash if `$(SHELL)` is
> > something else.  We don't hard-code the path to bash.
>=20
> Does it matter in practice? I don't recall seeing libmnl targeting
> a BSD platform where bash prominently isn't /bin/bash.

Apparently, there are cross-building use-cases.

J.

--ZS37eozskSMV/gQs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmLq4k8ACgkQKYasCr3x
BA3O7g/9GHiIB6pr1ud/LJUPm1DNlz4aLiR7m82jJIGNSBLGjNa2HX+w/wkJoDFk
K+TopObrY1XuhJ5ID1VqYvunVnvHYU6Id3+n3R1KVfviAqnzp6P0HOS4MMoUTZrJ
9bldJFsh/r8PJCGLGCBc36ov443nfaUZ1bsMynDN03XBLeQgEr0+xa3a9LLPR5xS
AphZtgeOOq8KpbfkbSk/KB3+JHZ4jfHEIsMy4ST/TSynHj8qo30I/YNYdg5I3B8d
ckqSxH91Yg6GkGqfQhRX6P5ylEtOqCtUWgmWkV3nW8KRbBgXrEeijZMVU5Xu/cmp
TYiFRcBN44a2CFk0XuX7EnNlQ6EN+xpL/BDaLvPFYWM1UjTHtNUECEGoaN965tac
cSdw3U68ALE9VDPC9kxF7rupF8h/qDSedRgy3tdX/pt3Hdxes+OfEToI92a3UrS7
/K8nOVC5BzspvqIhtiQ5VhjPVg5jdpQFZoOY4SnSD4baCYR7/v8mBVop3cuB8ys/
psDxmKUBTEAkzzygXFF3Y9yJQpz3exeWZXJ2hL08gDb6TYLLranmP9r78+WB8Vxy
praej5ua5SXILmTyuLLBdYCVRN7bCcdfmTakQ6TeU+/0Wf8yJVgcI3q4QkxP/jIi
EepJx7Pux5cmWztJHROEr1xF3GIRdVOs38aZ+IpBa4WLzjmv1lU=
=DOQ6
-----END PGP SIGNATURE-----

--ZS37eozskSMV/gQs--
