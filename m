Return-Path: <SRS0=2UWv=XQ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC097C49ED7
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 11:11:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A510208C0
	for <netfilter-devel@archiver.kernel.org>; Sat, 21 Sep 2019 11:11:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=azazel.net header.i=@azazel.net header.b="TpGK1DCT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407549AbfIULLh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 21 Sep 2019 07:11:37 -0400
Received: from kadath.azazel.net ([81.187.231.250]:59812 "EHLO
        kadath.azazel.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2407543AbfIULLg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 21 Sep 2019 07:11:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
         s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/j0HJ2+LFRsYPiD+OQ0F1ZIuj+Db6JqQt4DtYk4c4Kk=; b=TpGK1DCTIKsQRgDCQjvJOoF8YR
        BYqFFpBWfyFapeDG8J/J9midiAI3nWABBBrcR/yOnoSpNar2fgQt9VEYfCSgg296l48wpS96eeFGD
        FRSrsnyF69fLx+AEhDjesTzrUSw2B9kQoSrqxCaJ41IrNduWKi3LnauN+2/FOvz6is/FRISLaYAHw
        LNR2eV0EYMf4gH34JEeZRONi11nFyxc18flWSiwjpudyIhp6ic3yuH1Y4lou/WP9jn/dWZbnTOwza
        w+K4yJxWipA93FFYgJ+LXtZRU9ryDrsJSPtJJKa/OmEk9NRbrQ1XXRF/l12CbOhXzIKijKJEQQhzl
        sSqmphFA==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <jeremy@azazel.net>)
        id 1iBdId-0007nP-KM; Sat, 21 Sep 2019 12:11:35 +0100
Date:   Sat, 21 Sep 2019 12:11:34 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Netfilter Devel <netfilter-devel@vger.kernel.org>,
        Sebastian Priebe <sebastian.priebe@de.sii.group>
Subject: Re: [PATCH RFC nftables 4/4] cli: add linenoise CLI implementation.
Message-ID: <20190921111134.GB28617@azazel.net>
References: <4df20614cd10434b9f91080d0862dd0c@de.sii.group>
 <20190916124203.31380-1-jeremy@azazel.net>
 <20190916124203.31380-5-jeremy@azazel.net>
 <20190920101901.tvnec3seyaonhmts@salvia>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="s2ZSL+KKDSLx8OML"
Content-Disposition: inline
In-Reply-To: <20190920101901.tvnec3seyaonhmts@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--s2ZSL+KKDSLx8OML
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2019-09-20, at 12:19:01 +0200, Pablo Neira Ayuso wrote:
> On Mon, Sep 16, 2019 at 01:42:03PM +0100, Jeremy Sowden wrote:
> [...]
> > diff --git a/configure.ac b/configure.ac
> > index 68f97f090535..347f3b0cc772 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -68,14 +68,23 @@ AC_CHECK_LIB([gmp],[__gmpz_init], , AC_MSG_ERROR([No suitable version of libgmp
> >  AM_CONDITIONAL([BUILD_MINIGMP], [test "x$with_mini_gmp" = xyes])
> >
> >  AC_ARG_WITH([cli], [AS_HELP_STRING([--without-cli],
> > -            [disable interactive CLI (libreadline support)])],
> > -            [], [with_cli=yes])
> > -AS_IF([test "x$with_cli" != xno], [
> > +            [disable interactive CLI (libreadline or linenoise support)])],
> > +            [], [with_cli=readline])
> > +
> > +AS_IF([test "x$with_cli" = xreadline], [
> >  AC_CHECK_LIB([readline], [readline], ,
> > -	     AC_MSG_ERROR([No suitable version of libreadline found]))
> > +        AC_MSG_ERROR([No suitable version of libreadline found]))
> >  AC_DEFINE([HAVE_LIBREADLINE], [1], [])
> > +],
> > +      [test "x$with_cli" = xlinenoise], [
> > +AH_TEMPLATE([HAVE_LINENOISE], [])
> > +AC_DEFINE([HAVE_LINENOISE], [1], [])
> > +],
> > +      [test "x$with_cli" != xno], [
> > +AC_MSG_ERROR([unexpected CLI value: $with_cli])
> >  ])
> >  AM_CONDITIONAL([BUILD_CLI], [test "x$with_cli" != xno])
> > +AM_CONDITIONAL([BUILD_CLI_LINENOISE], [test "x$with_cli" = xlinenoise])
> >
> >  AC_ARG_WITH([xtables], [AS_HELP_STRING([--with-xtables],
> >              [Use libxtables for iptables interaction])],
> > @@ -118,6 +127,7 @@ AM_CONDITIONAL([HAVE_PYTHON], [test "$enable_python" != "no"])
> >  AC_CONFIG_FILES([					\
> >  		Makefile				\
> >  		libnftables.pc				\
> > +		linenoise/Makefile			\
> >  		src/Makefile				\
> >  		include/Makefile			\
> >  		include/nftables/Makefile		\
>
> You also have to update this code after AC_OUTPUT in configure.in to
> display libnoise, right?
>
> echo "
> nft configuration:
>   cli support:                  ${with_cli}
>   enable debugging symbols:     ${enable_debug}
>   use mini-gmp:                 ${with_mini_gmp}
>   enable man page:              ${enable_man_doc}
>   libxtables support:           ${with_xtables}
>   json output support:          ${with_json}"

${with_cli} will be "readline", "linenoise" or "no":

  $ ./configure --with-cli=linenoise
  [...]

  nft configuration:
    cli support:                  linenoise
    enable debugging symbols:     yes
    use mini-gmp:                 no
    enable man page:              yes
    libxtables support:           no
    json output support:          no
    enable Python:                yes (with /usr/bin/python)

J.

--s2ZSL+KKDSLx8OML
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEZ8d+2N/NBLDbUxIF0Z7UzfnX9sMFAl2GBWUACgkQ0Z7UzfnX
9sNDKw//dg2Q5c17hc0KFUAhiZ7/Nq4NF1TfUSpkh0BBXflF259hDgbRKsFrGqSc
JPCGzzdrJgjjPH/PTfbAtgePety8/GLz/8jzPaUTU4zcbckY4I7aKD53Wx/KU3OJ
dB1MvxdHeKz/j5AaMzAnxn6GBs8cc0AH/6jN3RUDabfQpe+BZ3pwoy26xiAv6Ug3
Foy2+wgMxo9952fmPsHqh0eRLESathHpvawtttmIGSFnXhQYdpWGwpkD40DgdKkQ
WWbbtYbwmNZu2Teoej20TLc4JuM7Ltn1sHeyolQIctC+Pui5VbotVDjJcUrkPQBj
YUt3wYVNLP5NCisFKP6wqFwjkZLRvozDtXpuDpOvZEWCl37fu5Wtsh4M0/2ilwKm
qNbJ5W1HQ07EgaDu+Y8SpYc9bi9CalAUDYtXG3egrHyvvXMbovK6YjZJhlv1RSX7
5HJUwZpZ9tU7Loy8OvyWi7xGBn1q30HaUzZzqc7SYZ5aKgepVuAEg9mJWFeNIfxf
63abhkUQjd800ywPJAvN96asabKRE0riSs6eSKFy7XhInZTkVDeU1hVHSYbGS5RV
dfiizySKjzizY82KHIElPVI4GH8r07QuKLRKYjjIovKKsK0GeR1lwP901oPai3Sx
xHNzWpMcb4BSRL4iGBsPIT6SXULp4VfKaLGbutdgfh/AuaR9DMY=
=Gkuo
-----END PGP SIGNATURE-----

--s2ZSL+KKDSLx8OML--
