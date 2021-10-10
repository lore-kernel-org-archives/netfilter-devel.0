Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 071E9C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Oct 2021 20:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D1C2060F35
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Oct 2021 20:17:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230333AbhJJUTk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 10 Oct 2021 16:19:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229758AbhJJUTk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Oct 2021 16:19:40 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14122C061570
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Oct 2021 13:17:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=yKyUj4HaTyCHxnOodZVD96G/hj5EvUdAywObmCS2z2o=; b=hIKSdEE+CHEKbKUIa0Ub8sSvNJ
        iINdwC6GG1E6XZmd/b/boFueyETVP9g/J6UaIxGY6sxS3LI87txRjk0UARZX/9LUTiKypQvZFNgo8
        FrDJqkpT2MRSCmUbr9NyAIlyMiRr5SfA0sKEAuf/teSpjaTGlRLkEb/o4D/LvEyNubrUMaFPiow5x
        pwLB0OGo+mdf3iPDtToG+Y03V/9r5NAy9AW9siG5PYVzHs83auNaNE+IslYWzsKUnxO8Rw3eCaWcd
        PNf2jpuHdTzxewuemcqP3syhsTHvelreq1fgA6TeiC8KUR2QRRm4+WNI/BxJ8wCWA1b0EcfPfuLel
        +66D8ImQ==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mZfFm-00D7Hs-VI; Sun, 10 Oct 2021 21:17:03 +0100
Date:   Sun, 10 Oct 2021 21:17:01 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_log v5 1/1] build: doc: `make` generates
 requested documentation
Message-ID: <YWNKPaU2cNTRPZqn@azazel.net>
References: <20211010023734.26923-1-duncan_roe@optusnet.com.au>
 <20211010023734.26923-2-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="RkPD536mh1Dp0PDv"
Content-Disposition: inline
In-Reply-To: <20211010023734.26923-2-duncan_roe@optusnet.com.au>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--RkPD536mh1Dp0PDv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-10-10, at 13:37:34 +1100, Duncan Roe wrote:
> Generate man pages, HTML, neither or both according to ./configure.
> Based on the work done for libnetfilter_queue
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>

Tested-by: Jeremy Sowden <jeremy@azazel.net>

> ---
> v2: remove --without-doxygen since -disable-man-pages does that
> v3: - update .gitignore for clean `git status` after in-tree build
>     - adjust configure.ac indentation for better readability
>     - adjust configure.ac for all lines to fit in 80cc
> v4: implement Jeremy's suggestions
> v5: rebase on top of Jeremy's "Build fixes" patch series
>  .gitignore                               |  7 ++--
>  Makefile.am                              |  2 +-
>  autogen.sh                               |  8 +++++
>  configure.ac                             | 46 +++++++++++++++++++++++-
>  doxygen/Makefile.am                      | 39 ++++++++++++++++++++
>  doxygen.cfg.in => doxygen/doxygen.cfg.in |  9 ++---
>  6 files changed, 103 insertions(+), 8 deletions(-)
>  create mode 100644 doxygen/Makefile.am
>  rename doxygen.cfg.in => doxygen/doxygen.cfg.in (76%)
>
> diff --git a/.gitignore b/.gitignore
> index ef6bb0f..4990a51 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -16,6 +16,9 @@ Makefile.in
>  /configure
>  /libtool
>
> -/doxygen/
> -/doxygen.cfg
> +/doxygen/doxygen.cfg
> +/doxygen/build_man.sh
> +/doxygen/doxyfile.stamp
> +/doxygen/man/
> +/doxygen/html/
>  /*.pc
> diff --git a/Makefile.am b/Makefile.am
> index c7b86f7..46b14f9 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -1,4 +1,4 @@
> -SUBDIRS	= include src utils
> +SUBDIRS	= include src utils doxygen
>
>  ACLOCAL_AMFLAGS = -I m4
>
> diff --git a/autogen.sh b/autogen.sh
> index 5e1344a..93e2a23 100755
> --- a/autogen.sh
> +++ b/autogen.sh
> @@ -1,4 +1,12 @@
>  #!/bin/sh -e
>
> +BUILD_MAN=doxygen/build_man.sh
> +
> +# Allow to override build_man.sh url for local testing
> +# E.g. export NFQ_URL=file:///usr/src/libnetfilter_queue
> +curl ${NFQ_URL:-https://git.netfilter.org/libnetfilter_queue/plain}/$BUILD_MAN\
> +  -o$BUILD_MAN
> +chmod a+x $BUILD_MAN
> +
>  autoreconf -fi
>  rm -Rf autom4te.cache
> diff --git a/configure.ac b/configure.ac
> index 85e49ed..589eb59 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -12,6 +12,23 @@ m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
>  dnl kernel style compile messages
>  m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
>
> +AC_ARG_ENABLE([html-doc],
> +	      AS_HELP_STRING([--enable-html-doc], [Enable html documentation]),
> +	      [], [enable_html_doc=no])
> +AM_CONDITIONAL([BUILD_HTML], [test "$enable_html_doc" = yes])
> +AS_IF([test "$enable_html_doc" = yes],
> +      [AC_SUBST(GEN_HTML, YES)],
> +      [AC_SUBST(GEN_HTML, NO)])
> +
> +AC_ARG_ENABLE([man-pages],
> +	      AS_HELP_STRING([--disable-man-pages],
> +			     [Disable man page documentation]),
> +	      [], [enable_man_pages=yes])
> +AM_CONDITIONAL([BUILD_MAN], [test "$enable_man_pages" = yes])
> +AS_IF([test "$enable_man_pages" = yes],
> +      [AC_SUBST(GEN_MAN, YES)],
> +      [AC_SUBST(GEN_MAN, NO)])
> +
>  AC_PROG_CC
>  AM_PROG_CC_C_O
>  LT_INIT([disable_static])
> @@ -37,6 +54,27 @@ PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 1.0.2],
>  		  [HAVE_LNFCT=1], [HAVE_LNFCT=0])
>  AM_CONDITIONAL([BUILD_NFCT], [test "$HAVE_LNFCT" -eq 1])
>
> +AS_IF([test "$enable_man_pages" = no -a "$enable_html_doc" = no],
> +      [with_doxygen=no], [with_doxygen=yes])
> +
> +AS_IF([test "x$with_doxygen" != xno], [
> +	AC_CHECK_PROGS([DOXYGEN], [doxygen], [""])
> +	AC_CHECK_PROGS([DOT], [dot], [""])
> +	AS_IF([test "x$DOT" != "x"],
> +	      [AC_SUBST(HAVE_DOT, YES)],
> +	      [AC_SUBST(HAVE_DOT, NO)])
> +])
> +
> +AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
> +AS_IF([test "x$DOXYGEN" = x], [
> +	AS_IF([test "x$with_doxygen" != xno], [
> +		dnl Only run doxygen Makefile if doxygen installed
> +		AC_MSG_WARN([Doxygen not found - not building documentation])
> +		enable_html_doc=no
> +		enable_man_pages=no
> +	])
> +])
> +
>  dnl Output the makefile
>  AC_CONFIG_FILES([Makefile
>  		src/Makefile
> @@ -45,5 +83,11 @@ AC_CONFIG_FILES([Makefile
>  		utils/Makefile
>  		libnetfilter_log.pc
>  		libnetfilter_log_libipulog.pc
> -		doxygen.cfg])
> +		doxygen/Makefile
> +		doxygen/doxygen.cfg])
>  AC_OUTPUT
> +
> +echo "
> +libnetfilter_log configuration:
> +man pages:                    ${enable_man_pages}
> +html docs:                    ${enable_html_doc}"
> diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
> new file mode 100644
> index 0000000..582db4e
> --- /dev/null
> +++ b/doxygen/Makefile.am
> @@ -0,0 +1,39 @@
> +if HAVE_DOXYGEN
> +
> +doc_srcs = $(top_srcdir)/src/libnetfilter_log.c\
> +	   $(top_srcdir)/src/nlmsg.c\
> +	   $(top_srcdir)/src/libipulog_compat.c
> +
> +doxyfile.stamp: $(doc_srcs) Makefile
> +	rm -rf html man
> +	doxygen doxygen.cfg >/dev/null
> +
> +if BUILD_MAN
> +	$(abs_top_srcdir)/doxygen/build_man.sh
> +endif
> +
> +	touch doxyfile.stamp
> +
> +CLEANFILES = doxyfile.stamp
> +
> +all-local: doxyfile.stamp
> +clean-local:
> +	rm -rf man html
> +install-data-local:
> +if BUILD_MAN
> +	mkdir -p $(DESTDIR)$(mandir)/man3
> +	cp --no-dereference --preserve=links,mode,timestamps man/man3/*.3\
> +	  $(DESTDIR)$(mandir)/man3/
> +endif
> +if BUILD_HTML
> +	mkdir  -p $(DESTDIR)$(htmldir)
> +	cp  --no-dereference --preserve=links,mode,timestamps html/*\
> +		$(DESTDIR)$(htmldir)
> +endif
> +
> +# make distcheck needs uninstall-local
> +uninstall-local:
> +	rm -rf $(DESTDIR)$(mandir) man html doxyfile.stamp $(DESTDIR)$(htmldir)
> +endif
> +
> +EXTRA_DIST = build_man.sh
> diff --git a/doxygen.cfg.in b/doxygen/doxygen.cfg.in
> similarity index 76%
> rename from doxygen.cfg.in
> rename to doxygen/doxygen.cfg.in
> index dc2fddb..b6c27dc 100644
> --- a/doxygen.cfg.in
> +++ b/doxygen/doxygen.cfg.in
> @@ -1,12 +1,11 @@
>  # Difference with default Doxyfile 1.8.20
>  PROJECT_NAME           = @PACKAGE@
>  PROJECT_NUMBER         = @VERSION@
> -OUTPUT_DIRECTORY       = doxygen
>  ABBREVIATE_BRIEF       =
>  FULL_PATH_NAMES        = NO
>  TAB_SIZE               = 8
>  OPTIMIZE_OUTPUT_FOR_C  = YES
> -INPUT                  = .
> +INPUT                  = @abs_top_srcdir@/src
>  FILE_PATTERNS          = *.c
>  RECURSIVE              = YES
>  EXCLUDE_SYMBOLS        = nflog_g_handle \
> @@ -18,7 +17,9 @@ SOURCE_BROWSER         = YES
>  ALPHABETICAL_INDEX     = NO
>  GENERATE_LATEX         = NO
>  LATEX_CMD_NAME         = latex
> -GENERATE_MAN           = YES
> -HAVE_DOT               = YES
> +GENERATE_MAN           = @GEN_MAN@
> +GENERATE_HTML          = @GEN_HTML@
> +MAN_LINKS              = YES
> +HAVE_DOT               = @HAVE_DOT@
>  DOT_TRANSPARENT        = YES
>  SEARCHENGINE           = NO
> --
> 2.17.5
>
>

--RkPD536mh1Dp0PDv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmFjShgACgkQKYasCr3x
BA3uRw/5AaAqd6YvclAv/83wTvT+4VHHdk1WzD+Db2iXAP4F3viCF2IjQE7Hu7JR
5v/eJTCM3OhxebqGtMEwRuXfCymeeSL7DB88KnPVPgk95NJIlbpivAE1WxX2f3Is
6S3zdirqU0VoNc3Q/xvlqSD3HIz5m74UiRmFt+xa0Mu+vfenp4jXz08aKhMG3G0V
5vw1Ok7YwsugRXXFGSBEQjHmuglnt2stR/dUweP1CYWJ/DvCU1PAh1OyTeHUaSWm
5nOIODxoSLWRa9A+FVuU+FwgpVDuqPWikuEiAt26ACtO2ODSyK6HdEzTK1vrtq92
iUU5lWqwu1frDc4RJoqJ4ReNJGMEHy4AMQaThjkZO+j45E2OF08o78d+H1VNKvYD
eXzZ3D9KJDLPio4ZmiXd9UiCMB+1XqrPscBie8UUq4AHYUIdyGTR4gdQCY3K7lCQ
Mm6x6vaIQ6GX90N3kKG9mun3C6pIJ1HBxmuMN71r6ot/yOTtzWcjpCdKG8hjsN9g
BKfLfaSsI6iiVlvIPyACsKjDxi4TBImpsQWaYs6BHK6c7VPmVLbkUTIHSW9N2FYe
6cL+iGbTvaiVS2anIy6SeE0OIVwey4MFZw3OF4ZrWYu7iWaTbpl7c2oYDypJbHJd
/ILzt9qYKEigvv2DPaOfahaZoOdV5kVJzPFJIfLbat6cH+kaB0o=
=et56
-----END PGP SIGNATURE-----

--RkPD536mh1Dp0PDv--
