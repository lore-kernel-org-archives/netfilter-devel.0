Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB25BC4338F
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 09:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBA2C61165
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Aug 2021 09:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbhHVJ1H (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Aug 2021 05:27:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231147AbhHVJ1H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Aug 2021 05:27:07 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CF81C061575
        for <netfilter-devel@vger.kernel.org>; Sun, 22 Aug 2021 02:26:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hGbmc0vvNMLl1v99yurxMBgPuAM9UTpcGzyTIT8Rleo=; b=I2JwwWUGrweZPSyXE4SOwF/pfJ
        YCRJ2q1t9WI2h0nZO+6YhqaStmtKusyt8AM2hMNSBXKQ3lX1ISYYBumhWSZNJcvNScuskZl0CIAXS
        HKDcFMNZobg7E2FUbprGVglbc4J0VVK/SantLSv9cRr0jkowpRv5LvI+i2C8tmrkHkiJEKLmqUx83
        l1Nc4Hb6yPON8HhAtOwSTG3vsJ2/j7iJ1D6DYrIuYPIBH37wBhU4zomZnnf0B+JPJV4PmSuH55mFI
        Ab0bbD6hPj++5llMzFh0JDViks8NMKlAUgC0O35/AB3Cwu/NXh83DNIoZHyg9AMIlyh8IgavMG8Fg
        JD2ZcP6Q==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mHjkB-008EsJ-C2; Sun, 22 Aug 2021 10:26:19 +0100
Date:   Sun, 22 Aug 2021 10:26:18 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libnetfilter_queue v3 1/3] build: doc: Fix NAME entry in
 man pages
Message-ID: <YSIYOtDRZfz++w1q@azazel.net>
References: <20210821053805.6371-1-duncan_roe@optusnet.com.au>
 <YSDNkNFOfdyOKXh2@azazel.net>
 <YSHFbmTDw1wb4Wvq@slk1.local.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="CAJe93HXvU2n82z/"
Content-Disposition: inline
In-Reply-To: <YSHFbmTDw1wb4Wvq@slk1.local.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--CAJe93HXvU2n82z/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-08-22, at 13:33:02 +1000, Duncan Roe wrote:
> On Sat, Aug 21, 2021 at 10:55:28AM +0100, Jeremy Sowden wrote:
> > On 2021-08-21, at 15:38:03 +1000, Duncan Roe wrote:
> > > Add a post_process() function to the big shell script inside
> > > doxygen/Makefile.am
> [...]
> >
> > Would it not make life easier to move all this shell-script into a
> > build_man.sh and just call that from the make-file?  Patch attached.
>
> Of course it would, and that's how it was at library release 1.0.5,
> but `make distcheck` would not pass, as it doesn't pass with your
> patch as supplied.

Ah, yes, sorry, I did see you mention `make distcheck`, but it slipped
my mind.

> Your patch inspired me to try one last time and, thanks to hours of
> grovelling through `info autoconf`, `make distcheck` passes with the
> 1-line patch below.
>
> Remarkably, the resulting tarball includes doxygen/build_man.sh even
> though there is no EXTRA_DIST entry for it in Makefile.am.
>
> VPATH builds still work (e.g. mkdir build; cd build; ../configure;
> make) and `make distcleancheck` still passes afterward.
>
> So, I'll push out another patch rev shortly. Thanks!
>
> From a1795e7f1baff2d477d0a0a7e3058343baf3d85e Mon Sep 17 00:00:00 2001
> From: Duncan Roe <duncan_roe@optusnet.com.au>
> Date: Sun, 22 Aug 2021 11:19:22 +1000
> Subject: [PATCH libnetfilter_queue] Replace ./build_man.sh with
>  $(abs_top_srcdir)/doxygen/build_man.sh
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
>  doxygen/Makefile.am | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
> index 52dca07..aa19c5a 100644
> --- a/doxygen/Makefile.am
> +++ b/doxygen/Makefile.am
> @@ -25,7 +25,7 @@ doxyfile.stamp: $(doc_srcs) Makefile.am
>  # but not blank lines
>
>  if BUILD_MAN
> -	./build_man.sh
> +	$(abs_top_srcdir)/doxygen/build_man.sh
>  endif

Funnily enough, I fixed a number of bugs like this earlier in the year
in another context.  One might have hoped to have remembered.  Oh well.

J.

--CAJe93HXvU2n82z/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmEiGDMACgkQKYasCr3x
BA3V8Q//WZHYUuZ4MLHyukVuBoaZMPVGXY5QM4FNsYvVdYJi6GU5W6B6rNAlHCqM
jtkyqX/V1bjofegGi1tYAuV7VOMsdGJ511fXfFPKh8c64ozhy+op5Wx7EVKUXV9c
e1XDGLbLkcmgm0xP/IFgToa9BGDj88Bf9+b78U5t3TZlCOVHk4qnH46V5qyCXJ97
YLz1NuB4AASFXsZH1RL0e1QO8eFhz4fCQqHJuz3WVN3M0A5+4b+3MyP8K69Nuy9t
PJdAW7St8bp4sugZCCFG0JLBaYwoHSRB1JuxPQweDzjMGwnKFX2krdyoHbWxr94N
L79eSkAZ5vUNkxatZblR68P03/BtCbiIIMlEi3stzVhXEeKbpcCwyHHNL/Pv9qs5
d14lD/O+SD6GjMcWpkv0v01ZpKqAvOYrSnUJ0HDnQnphgPQCOID2aOHujcSZHVEJ
xTS0DYZvHNmr5w4/aYXOcroGLbsk2WDfQKImP9ML2pp+FxIPev3OsFISIyUqxKOT
Ue0lAl0uW+Nq8Rp9pvaEXr0VC7Dx6qsEjk3W9ca6Va9TbIM+bzRbFhOYm5g/Fh8a
o0XVKd9PTcPIyoibjWnnSuNyFPAILr3z6rz0HILSoCEPgaGo5okBuEvunIvEa1vR
jCjrdBpXcZ+jY82wNBiaCSqqy1FTcsozkL0bdT2INMSYTb0Jk2s=
=16pp
-----END PGP SIGNATURE-----

--CAJe93HXvU2n82z/--
