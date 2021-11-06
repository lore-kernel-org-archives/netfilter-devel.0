Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 962CDC433EF
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 11:07:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75FC06108D
	for <netfilter-devel@archiver.kernel.org>; Sat,  6 Nov 2021 11:07:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233397AbhKFLJt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 6 Nov 2021 07:09:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhKFLJt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 6 Nov 2021 07:09:49 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28500C061570
        for <netfilter-devel@vger.kernel.org>; Sat,  6 Nov 2021 04:07:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=6pCLdqJ6j/Uq+jAjZNtwR4EE0s4meSQoZlQpPW8aNkk=; b=vSHc+JiGHWXJ4E29yBqoDUQVBV
        pCl5/8i4E/3zjH2Jifulmpn89DyeUmj3hkbUefdYuc/XNIs/j8QTVEKz8l6J70lpw09yjjwA6+IIM
        m1mVGogRmBTSGPf7j6+1e/qwGYxjQf4kj0vGzcDlH6vNR1mQ7dkj/1f8ptl6KW4oZFBgIUt6BquEK
        AKAemxrm7fM6KbRfvWgx3PdWMtWUvWycFA1yG5B8AOiBlP+eI1zbZK+kqVKTK/sBJtUQCz0plzsRF
        3uG8BhQfF+/X3gDfRB/6DW7bXo2dSCMTRTJkKdff28v9UzSbhFLJOyfA5O2d6/ZSB97bk2nWP6Shf
        KlanHo4w==;
Received: from ec2-18-200-185-153.eu-west-1.compute.amazonaws.com ([18.200.185.153] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mjJXO-004g8K-GP; Sat, 06 Nov 2021 11:07:06 +0000
Date:   Sat, 6 Nov 2021 11:07:04 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [ulogd2 PATCH 10/13] build: update obsolete autoconf macros
Message-ID: <YYZh2NhNdvpDYgFB@azazel.net>
References: <20211030160141.1132819-1-jeremy@azazel.net>
 <20211030160141.1132819-11-jeremy@azazel.net>
 <n5pq71os-8247-2o3-qo2-9023807oqnoq@vanv.qr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="lcGlzy65lU/66pbK"
Content-Disposition: inline
In-Reply-To: <n5pq71os-8247-2o3-qo2-9023807oqnoq@vanv.qr>
X-SA-Exim-Connect-IP: 18.200.185.153
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--lcGlzy65lU/66pbK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-10-30, at 19:16:27 +0200, Jan Engelhardt wrote:
> On Saturday 2021-10-30 18:01, Jeremy Sowden wrote:
> > +++ b/configure.ac
> > @@ -3,7 +3,7 @@ AC_INIT([ulogd], [2.0.7])
> >  AC_PREREQ([2.50])
> >  AC_CONFIG_AUX_DIR([build-aux])
> >  AM_INIT_AUTOMAKE([-Wall foreign tar-pax no-dist-gzip dist-bzip2
> 1.10b subdir-objects])
> > -AC_CONFIG_HEADER([config.h])
> > +AC_CONFIG_HEADERS([config.h])
> >  AC_CONFIG_MACRO_DIR([m4])
> >
> >  m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
> > @@ -14,8 +14,7 @@ dnl Checks for programs.
> >  AC_PROG_MAKE_SET
> >  AC_PROG_CC
> >  AC_PROG_INSTALL
> > -AC_DISABLE_STATIC
> > -AC_PROG_LIBTOOL
> > +LT_INIT([disable_static])
>
> This ought to be disable-static. Dash, not underscore.

Will fix in v2.

J.

--lcGlzy65lU/66pbK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmGGYdgACgkQKYasCr3x
BA0I/g/+Lx3L7QQwyI0ri+8UTH+YWbzkwWuBOI3MLI3pFVXngTtgoQG/Kq6e4MaE
Wr8sCVb8Z3MElmZsIKtVO/hHCbrETKpgGtbp/LRr6zblfjyHHmfhwREfWEKlFiT4
XVTh5tXoIn0RVEezqkIzbY1hYkzktKAfJsFxw3XvK7zHwGourFGB8M1zvgsi3Rol
/WDSsTZMWNkmsVAmOGzPloO5ieb9lN6341bSusFmmNWLpb92PRElXhS7XaU5ZRQ9
6HiINaVC2O1lYle0Lzri39WcvT9aVEikxidu1R9ITSdUV87V2UtwpDarYRwDfAx3
veLSwCKPI8bxKi4rXyrkMID0l1bi5kbvKviPf0hu7k/ndAxw4ozAJ4k/LCbG7kW4
6eqiwW9l4lVX+ZXJp52N7fRvqwxRiz0FiPUWnw7T9lbmDKhY2+W7v+cG4fgkPbMV
WhwCKdw3jUTfaBW5lBLTCOwNNGbkt1hd62Z4KVYvv5I3aC6ue0bYmPcSgGiguXQ4
q2ESTUDtBqKMEqCCZPW6wHh3RSnZhjXOd+3/ZLo8VGVHKvNQkkrT6w2So49AimyY
5ob1eyUXg4PsJsf6onoST9VUmZG5BOCUtW05rP0NngAhAZlPmfxrLEhgg5YrnCJh
t5IE4kWmJRTLzisUeLhKg5qIeQ7ZC6sY5p1vyFRhrs7pqe5nys0=
=9kSk
-----END PGP SIGNATURE-----

--lcGlzy65lU/66pbK--
