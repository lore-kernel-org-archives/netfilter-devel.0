Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82463C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 15:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 59B36610F9
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 15:31:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbhKNPeQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 10:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbhKNPeO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 10:34:14 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546CCC061746
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 07:31:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xk1my/fkVRq8TNbGm9pQ/xn4+SDk5JRNlE4LIFaNtA4=; b=asri+ozl2stNh2Sxtb2JTMk5Fr
        YvIikYbeRPy43rQnj2BbMA/XAFtVjh3ZEv28v/DuWCT4gckTaYbFJwRihWy3kDJj9Qi/AdRz+nTP4
        R8GA+XVwkYnTxVjm3ElhLQymY2TYGSWzDwLHP+uIZGEy1goDbTWYdCrG2f5w1DlyzjurtVvpjgcSD
        IG/7iy+Pin0196ZJLy4eztXqb3no4ZjWcXw8fX9kN7sgzAME2QE32sES8rwRjNEJN/6ZdCS/nDhSK
        zmtkQ/z9ZDCei8SI1t7aS7zGtvT/nzODhgOfVFVM1MgJSV3f+xyz97Hd7Ioxfui/jiXzQobnfITFB
        uCknEmwg==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmHTP-00CfC9-66; Sun, 14 Nov 2021 15:31:15 +0000
Date:   Sun, 14 Nov 2021 15:31:14 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH v3 14/16] build: remove unnecessary `AC_SUBST`
 calls
Message-ID: <YZErwsUUKHV5omgP@azazel.net>
References: <20211114140058.752394-1-jeremy@azazel.net>
 <20211114140058.752394-15-jeremy@azazel.net>
 <72852nsr-op91-6618-2r4-73995n6rs64@vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="TV/bs0VgjblGKlgk"
Content-Disposition: inline
In-Reply-To: <72852nsr-op91-6618-2r4-73995n6rs64@vanv.qr>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--TV/bs0VgjblGKlgk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-11-14, at 15:58:48 +0100, Jan Engelhardt wrote:
> On Sunday 2021-11-14 15:00, Jeremy Sowden wrote:
> >We don't use the variables being passed to `AC_SUBST` in these calls
> as
> >output variables, so remove them.
>
> >-AC_SUBST(PQINCPATH)
> >-AC_SUBST(PQLIBPATH)
> >-AC_SUBST(PQLIBS)
>
> Eh, but why? These are all still used.

You're quite right.  Fit of idiocy on my part.

J.

--TV/bs0VgjblGKlgk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmGRK7sACgkQKYasCr3x
BA2flw/7BIaGlNEAX0n0cczb5QMPAP9hwlXrSLVL4D3W4t808Gyc33KIPGdt5abA
wWw8RN9jvkIY/vO/vm3uMuOjblVC4dIm2V+vGKi6iOk7G074C/J8S0i0gwb+lIFh
oXj3znl9f9PNRv2NXzMPwNpUVs3s3yFzp5TZgM1cvCcCWeM32XzE31srbmB2hcOl
OcDK7HSKun/kq1szGzoLNadEJAnB538EPkNl20G0F5iMHU0tENqmbPHp3eKhAp9Z
RxiaXSr339/Pmui6MNF8cr3A0MC+9wE8xAMx1irYwCx97No86k4M99mWF6KQnFDH
woxAlKtZOsB2aArp5ZzGq0dWbkfzVawc33QhTN1msaEVBIRoM5t+3rAzupkgIR5+
uJ0Y8t5DSdW4PTychi0jEX7VUncK9NBTwN3Vm5qy9DMg0GY8+8Y9OtDz2BT77oL/
6RMffgpVIqe+rOf82W/mP/jhJmK66aTG5WUC1dKqc9nlfYi4kG+PRbPU/+VRUnaf
aJ1qao58Hgc14bYQFGoZAPUCrKOSXvGfvn2CCg7F4kmg+HacCitw7Dr2qbGGHLxm
zolJbd5rb//goY7R/lzgc7Oq6UxuHmLBRwbg/YboY7muq8kpURjlcZwvb/0D6NkM
kdJl6L0vaZL58CjHaK5EWqGbAEec4GRTDK4c5PKlFh5TO6xjaqQ=
=4GBi
-----END PGP SIGNATURE-----

--TV/bs0VgjblGKlgk--
