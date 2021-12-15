Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40F0CC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Dec 2021 18:47:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343960AbhLOSrw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Dec 2021 13:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343961AbhLOSrq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Dec 2021 13:47:46 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E814EC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Dec 2021 10:47:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:To:From:Date:Sender:Reply-To:Cc:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=nG4tyKtcsc+7t3sPg9+P9wtcJWznbR7D62Kc0sKvi9s=; b=AQ/uRf4dvksBGBKQ3XkybXREfg
        G5VmclIdB1AWBf4wU3aQdsCNV0VHBXLLORT3M/nQy6HzLrPvLXFtiJOF0OsdeokSuonr6faF8EH4g
        eDP15r6PCJWtWMBASEMjbEKaJ/hyVPE2841leedZVk7tN3IFLzA09l5IM886kzaV2CNX5JljH6vhh
        UxEs22Bdf1ICyfGjH+njAEsksZd6617oqt0QBS8ywop0XeDnKDw213/xXkOCXapa3npIf1ghssCJg
        i3NAPR2SI7mJub0mLNb/j9xscgkRD48JY3wAoHgRDrRFTM1s06ioQakW8Da4IcJ4RF+TVTMnl9Q4o
        WWTkNdfg==;
Received: from celephais.dreamlands ([192.168.96.3] helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mxZJX-008Ycb-W6
        for netfilter-devel@vger.kernel.org; Wed, 15 Dec 2021 18:47:44 +0000
Date:   Wed, 15 Dec 2021 18:47:39 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: Re: [PATCH] build: fix autoconf warnings
Message-ID: <Ybo4S2Zme8SkKmyp@azazel.net>
References: <20211215184440.39507-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="NZzxK1l9otlMzctb"
Content-Disposition: inline
In-Reply-To: <20211215184440.39507-1-jeremy@azazel.net>
X-SA-Exim-Connect-IP: 192.168.96.3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--NZzxK1l9otlMzctb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-12-15, at 18:44:40 +0000, Jeremy Sowden wrote:
> autoconf complains about three obsolete macros.
>
> `AC_CONFIG_HEADER` has been superseded by `AC_CONFIG_HEADERS`, so
> replace it.
>
> `AM_PROG_LEX` calls `AC_PROG_LEX` with no arguments, but this usage is
> deprecated.  The only difference between `AM_PROG_LEX` and `AC_PROG_LEX`
> is that the former defines `$LEX` as "./build-aux/missing lex" if no lex
> is found to ensure a useful error is reported when make is run.  How-
> ever, the configure script checks that we have a working lex and exits
> with an error if none is available, so `$LEX` will never be called and
> we can replace `AM_PROG_LEX` with `AC_PROG_LEX`.
>
> `AM_PROG_LIBTOOL` has been superseded by `LT_INIT`, which is already in
> configure.ac, so remove it.
>
> We can also replace `AC_DISABLE_STATIC` with an argument to `LT_INIT`.
>
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
> ---
>  configure.ac | 8 +++-----
>  1 file changed, 3 insertions(+), 5 deletions(-)
>
> diff --git a/configure.ac b/configure.ac
> index bb65f749691c..503883f28c66 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -9,7 +9,7 @@ AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
>  dnl kernel style compile messages
>  m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
>
> -AC_CONFIG_HEADER([config.h])
> +AC_CONFIG_HEADERS([config.h])
>
>  AC_ARG_ENABLE([debug],
>  	      AS_HELP_STRING([--disable-debug], [Disable debugging symbols]),
> @@ -26,7 +26,7 @@ AC_PROG_CC
>  AC_PROG_MKDIR_P
>  AC_PROG_INSTALL
>  AC_PROG_SED
> -AM_PROG_LEX
> +AC_PROG_LEX([noyywrap])
>  AC_PROG_YACC
>
>  if test -z "$ac_cv_prog_YACC" -a ! -f "${srcdir}/src/parser_bison.c"
> @@ -43,11 +43,9 @@ then
>  fi
>
>  AM_PROG_AR
> -AM_PROG_LIBTOOL
> -LT_INIT
> +LT_INIT([disable-static])
>  AM_PROG_CC_C_O
>  AC_EXEEXT
> -AC_DISABLE_STATIC
>  CHECK_GCC_FVISIBILITY
>
>  AS_IF([test "x$enable_man_doc" = "xyes"], [
> --
> 2.34.1
>
>

Forgot to set the subject-prefix to "nft".

Apologies,

J.

--NZzxK1l9otlMzctb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmG6OEsACgkQKYasCr3x
BA22dhAAyLIUOUAh36VPtDBJa/TnoLLEPSe2936hFIPd31nF44kZ5nzIJjf2tq3G
nL0yM+g6kzTm/9GHBCoFXnr4pfArNYlst1LBVMlW4M2pgjhT975txqmpb6O3ydDX
NbFsgYZvP89jWkgAx4Su7KF9uDb0WZq2dgTQn0jcx3Le84+2MrvVXgQOexwToLZn
Q5+gvjPxhLM7Xs/ZX4CjCCn0P4xrEOCnjCAfz5Ya9A4rQgRAk4SkeDsNgYQOk1zX
dZLrZ3UWAE/umZPHqay3+GvRCT3hbZNINlEdfExFFiZ5RpdKl4RKB2oQaQ+GdQuO
6lIvgHqqGzKoguZwauzVPn+2f738jn6YsIkyy5RfQMOUebVG+kl+RV51pxqnBdr1
dOXQ40+cHAKLcQtsRC+G1f4/wwWaSW1KulwJ/cdzPeZjuDUrKMtCCWB+nS29wViL
KT5QZA9FmoU9mdsIR28/dSR0YBGQ/yXrA0VvQZ/7wA8rFWZje7UMpFvzXC0Ys3EB
j7ZuACNUYzKOUVGNPjUMwqIrCrJyhD4y96WjluUutEiP+s+6xCSqLaS+TlKRen2N
WvUYCBlhpDpmemep39K+36R8cORkQs9xjicOiFT9azGE9HjG95hugkoMgMjGRSm1
/PvXdsBVHdnq+I5cbwpNwWjF8T6UgvWgrHcUELUuACjSaP030Yg=
=dSJW
-----END PGP SIGNATURE-----

--NZzxK1l9otlMzctb--
