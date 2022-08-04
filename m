Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AAF7C19F2B
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 Aug 2022 10:13:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231869AbiHDKNk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 Aug 2022 06:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiHDKNi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 Aug 2022 06:13:38 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763E832DAB
        for <netfilter-devel@vger.kernel.org>; Thu,  4 Aug 2022 03:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Pjc1HRbQcYLeMDzO6rgqPt9mG9I+33+U3ln6M9+ID3U=; b=KW7zm2uQNAIc/UmrEytwnmtTQm
        M3K2q9i9gebqjlbHh1sgOR/SJxgavwApmGgZbercG0XH2dRmxC3rBZAHzkYS98Gd30OKh0hT/scGP
        6gdiueMV5qTJ3xTARbZuXFLmPCaUIlt5dcUJZoY5FaB6lOtX+qJ2bZ0RUEBE4Iknxp/nXx6ylXkjv
        02n8+L315PzZvO6kbC/MFB3azr4cNsJCUaY/YjgZmaLyQkzAhrQ+8Zfcszp9qYp8oiAOvp0b98q1x
        Z0FrqmLeL3EMHWg2/TsTvuWB2N88w7lH5Msy3IJcfmfkzLBwvOSuHvRzzMbLNUkdXNf8Xye8aFBZU
        LHBHIr+A==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.dreamlands)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1oJXr6-0025u4-6H; Thu, 04 Aug 2022 11:13:28 +0100
Date:   Thu, 4 Aug 2022 11:12:44 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH libmnl 0/6] Doxygen Build Improvements
Message-ID: <YuubnNs28whqgGSy@ulthar.dreamlands>
References: <20220803201247.3057365-1-jeremy@azazel.net>
 <YutAwJJpr8tZ4MRW@slk15.local.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="W4KNuYFMSx7avWTp"
Content-Disposition: inline
In-Reply-To: <YutAwJJpr8tZ4MRW@slk15.local.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--W4KNuYFMSx7avWTp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2022-08-04, at 13:45:04 +1000, Duncan Roe wrote:
> On Wed, Aug 03, 2022 at 09:12:41PM +0100, Jeremy Sowden wrote:
> > These changes were prompted by Mark Mentovai's request to remove a
> > hard-coded `/bin/bash` path from the rule that creates the man-page
> > sym-links.  Hitherto, the doxygen Makefile has jumped through a
> > number of hoops to make sure everything works with `make distcheck`
> > and parallel builds.  This patch-set makes some doxygen config
> > changes that obviate the need for them, fixes a bug in `make clean`,
> > updates .gitignore and moves the shell-script out of the Makefile
> > into a separate file for ease of maintenance.  In the process, the
> > hard-coded `/bin/bash` is removed.
> >
> > One thing I have left is the setting of `-p` when running the
> > shell-script.  The comment reads "`bash -p` prevents import of
> > functions from the environment".  Why is this a problem?
> >
> > Jeremy Sowden (6):
> >   build: add `make dist` tar-balls to .gitignore
> >   doc: add .gitignore for Doxygen artefacts
> >   doc: change `INPUT` doxygen setting to `@top_srcdir@`
> >   doc: move doxygen config file into doxygen directory
> >   doc: move man-page sym-link shell-script into a separate file
> >   doc: fix doxygen `clean-local` rule
> >
> >  .gitignore                               |  3 +-
> >  configure.ac                             | 15 ++++++-
> >  doxygen/.gitignore                       |  4 ++
> >  doxygen/Makefile.am                      | 53 +++---------------------
> >  doxygen.cfg.in => doxygen/doxygen.cfg.in |  4 +-
> >  doxygen/finalize_manpages.sh             | 40 ++++++++++++++++++
> >  6 files changed, 67 insertions(+), 52 deletions(-)
> >  create mode 100644 doxygen/.gitignore
> >  rename doxygen.cfg.in => doxygen/doxygen.cfg.in (91%)
> >  create mode 100644 doxygen/finalize_manpages.sh
> >
> > --
> > 2.35.1
>
> Thanks for this but ... I think it would be better to use the
> netfilter-log model.
>
> That way there is no new shell script to maintain - libmnl would pick
> up libnetfilter-queue's copy.
>
> I found the time-consuming part was checking the new SYNOPSIS lines to
> be sufficient. I have far less time nowadays (no Covid lockdowns, &c.)
> but I will try to get it done soon-ish.
>
> In the meantime I think Mark's 1-line patch to the existing mess is
> adequate.

Cool.

J.

--W4KNuYFMSx7avWTp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmLrm5YACgkQKYasCr3x
BA1eKw/8DmnuqrI2LLUorNY/1EpmeFh/Bdfy/y7kT3iDr2nlf9hPLmPW7JXDEbux
WB3gBy+7/9rvusjKt3twmsk+nIqPywq02Ckst1cMwzZkCDpzaBu6RtppxF7ITgOK
N3Zb22YBSLqvVUUnIByv+G6N0P5NApn1hh9VLaeCEyYSsRktg1pu6nF+2uOxbXN3
13GNVIWmpvM1UfsBmxDx4zXrBxIyLWth91HhjChfxBUho4FWwSfc80ABJgU7tbh2
sv+CEi55AqxQJ5QGTgKCnJi9nuHlSi4LfQjordvOQgJlhIW8Jlp/IB/RFL9T/jsw
SS2HYM4Gqqa1tXyo2HBeB54W5RYMhWidDOhB2H8/3skB3uRE4Zc6qkSsMYqoyU4P
qx4717bwbeGOL3fj4m+M5FyXO2udrKuKQFmGH/48PlBwfsbHRLPkBvsA5E57BacJ
0Wt1Ww+IWlx+njKr7bpZrB4HgmfRNTcvTgUFQgRf9m0jTv0fufDTas0a2SYofJ/6
R2OXw7slFaglr7KkNdpImtgl3YgRF4BTYygJTcZFYJQHHfG6NCDOgTEgDD7Zk82B
rPvWFxTLyYssUdZIVrEed2zii/sMe6Ynia7fOZSz9HUoiyI0gb+pb1ky42q0+izN
ZRByofB/UdF5k+OdmacaxIQZv8ZOlQE+PBeKHnm7LxwbaDZFOH8=
=cM7c
-----END PGP SIGNATURE-----

--W4KNuYFMSx7avWTp--
