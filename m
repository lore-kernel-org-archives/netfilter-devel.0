Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3589BC433FE
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AF3B610E7
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Oct 2021 20:25:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242845AbhJHU1S (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:27:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242700AbhJHU1M (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 16:27:12 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47A2C061570
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Oct 2021 13:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=PtiIACC3ohlsm/JjfW/vOP0YdxTiZu3qq2tsrCoJC/A=; b=WYPWpgIcJIN3sXcfclhu3ovzG0
        WJ4mqsC6VUrjlTVPcX8t2wEcP8REcjF72EjpbYGAOAfX+niNGahPuy4MmrQeAVLrwTnFnEE87NELN
        8LR3dnc7g3ptPHvKO5reQUqLkOodWu4I0G89VrDkZx3k+J6ZgKl5/WcsB0HPDyH8j0UMIny6xpYVW
        VDP0KNq/4lfK98IwdWm6YTCteMsKJexV464GOzc6SixyfPvJXe3iByNaNoLh/Y8jIoVfagWjBrw2D
        SGkDYvfsS7znvnjbHmqKvw2LKQMKa5iJVgMtVowLRb6L3SfrVgxL9O6zGI73orobzJHYv5c1/PEfP
        G3JkWoMw==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mYwQa-00AjDz-A6; Fri, 08 Oct 2021 21:25:12 +0100
Date:   Fri, 8 Oct 2021 21:25:11 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_log v3] build: doc: `make` generates
 requested documentation
Message-ID: <YWCpJ79+7sB6XhBn@azazel.net>
References: <20211006042627.22161-1-duncan_roe@optusnet.com.au>
 <YWCnMp8v8oQuA9N6@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="3+lRNPUozA9zLKX+"
Content-Disposition: inline
In-Reply-To: <YWCnMp8v8oQuA9N6@azazel.net>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--3+lRNPUozA9zLKX+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-10-08, at 21:16:50 +0100, Jeremy Sowden wrote:
> On 2021-10-06, at 15:26:27 +1100, Duncan Roe wrote:
> > Generate man pages, HTML, neither or both according to ./configure.
> > Based on the work done for libnetfilter_queue
> >
> > Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
>
> A couple of minor comments below, but otherwise:

One more suggestion. :)

> Tested-by: Jeremy Sowden <jeremy@azazel.net>
>
> > ---
> > v2: remove --without-doxygen since -disable-man-pages does that
> > v3: - update .gitignore for clean `git status` after in-tree build
> >     - adjust configure.ac indentation for better readability
> >     - adjust configure.ac for all lines to fit in 80cc
> >  .gitignore                               |  7 ++--
> >  Makefile.am                              |  2 +-
> >  autogen.sh                               |  8 +++++
> >  configure.ac                             | 45 +++++++++++++++++++++++-
> >  doxygen/Makefile.am                      | 39 ++++++++++++++++++++
> >  doxygen.cfg.in => doxygen/doxygen.cfg.in |  9 ++---
> >  6 files changed, 102 insertions(+), 8 deletions(-)
> >  create mode 100644 doxygen/Makefile.am
> >  rename doxygen.cfg.in => doxygen/doxygen.cfg.in (76%)
> >
> > diff --git a/.gitignore b/.gitignore
> > index 5eaabe3..bb5e9d8 100644
> > --- a/.gitignore
> > +++ b/.gitignore
> > @@ -13,6 +13,9 @@ Makefile.in
> >  /configure
> >  /libtool
> >
> > -/doxygen/
> > -/doxygen.cfg
>
> I'd leave the initial /'s here:
>
> > +doxygen/doxygen.cfg
> > +doxygen/build_man.sh
> > +doxygen/doxyfile.stamp
> > +doxygen/man/
> > +doxygen/html/
> >  /*.pc
> > diff --git a/Makefile.am b/Makefile.am
> > index 2a9cdd8..6662d7b 100644
> > --- a/Makefile.am
> > +++ b/Makefile.am
> > @@ -1,4 +1,4 @@
> > -SUBDIRS	= include src utils
> > +SUBDIRS	= include src utils doxygen
> >
> >  ACLOCAL_AMFLAGS = -I m4
> >
> > diff --git a/autogen.sh b/autogen.sh
> > index 5e1344a..b47c529 100755
> > --- a/autogen.sh
> > +++ b/autogen.sh
> > @@ -1,4 +1,12 @@
> >  #!/bin/sh -e
> >
> > +# Allow to override build_man.sh url for local testing
> > +# E.g. export NFQ_URL=file:///usr/src/libnetfilter_queue
> > +NFQ_URL=${NFQ_URL:-https://git.netfilter.org/libnetfilter_queue/plain}
>
> You may as well download build_man.sh straight to doxygen/:
>
>   BUILD_MAN=doxygen/build_man.sh
>
>   curl $NFQ_URL/$BUILD_MAN -o$BUILD_MAN
>   chmod a+x $BUILD_MAN

Either:

  # Allow to override build_man.sh url for local testing
  # E.g. export NFQ_URL=file:///usr/src/libnetfilter_queue
  : ${NFQ_URL:=https://git.netfilter.org/libnetfilter_queue/plain}

  BUILD_MAN=doxygen/build_man.sh

  curl $NFQ_URL/$BUILD_MAN -o$BUILD_MAN
  chmod a+x $BUILD_MAN

or:

  BUILD_MAN=doxygen/build_man.sh

  # Allow to override build_man.sh url for local testing
  # E.g. export NFQ_URL=file:///usr/src/libnetfilter_queue
  curl ${NFQ_URL:-https://git.netfilter.org/libnetfilter_queue/plain}/$BUILD_MAN -o$BUILD_MAN
  chmod a+x $BUILD_MAN

> > +curl $NFQ_URL/doxygen/build_man.sh -O
> > +chmod a+x build_man.sh
> > +mv build_man.sh doxygen/
> > +
> >  autoreconf -fi
> >  rm -Rf autom4te.cache
> > diff --git a/configure.ac b/configure.ac
> > index c914e00..134178d 100644
> > --- a/configure.ac
> > +++ b/configure.ac
> > @@ -12,6 +12,23 @@ m4_ifdef([AM_PROG_AR], [AM_PROG_AR])
> >  dnl kernel style compile messages
> >  m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
> >
> > +AC_ARG_ENABLE([html-doc],
> > +	      AS_HELP_STRING([--enable-html-doc], [Enable html documentation]),
> > +	      [], [enable_html_doc=no])
> > +AM_CONDITIONAL([BUILD_HTML], [test "$enable_html_doc" = yes])
> > +AS_IF([test "$enable_html_doc" = yes],
> > +      [AC_SUBST(GEN_HTML, YES)],
> > +      [AC_SUBST(GEN_HTML, NO)])
> > +
> > +AC_ARG_ENABLE([man-pages],
> > +	      AS_HELP_STRING([--disable-man-pages],
> > +			     [Disable man page documentation]),
> > +	      [], [enable_man_pages=yes])
> > +AM_CONDITIONAL([BUILD_MAN], [test "$enable_man_pages" = yes])
> > +AS_IF([test "$enable_man_pages" = yes],
> > +      [AC_SUBST(GEN_MAN, YES)],
> > +      [AC_SUBST(GEN_MAN, NO)])
> > +
> >  AC_PROG_CC
> >  AM_PROG_CC_C_O
> >  AC_DISABLE_STATIC
> > @@ -35,8 +52,34 @@ PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 1.0.2],
> >  		  [HAVE_LNFCT=1], [HAVE_LNFCT=0])
> >  AM_CONDITIONAL([BUILD_NFCT], [test "$HAVE_LNFCT" -eq 1])
> >
> > +AS_IF([test "$enable_man_pages" = no -a "$enable_html_doc" = no],
> > +      [with_doxygen=no], [with_doxygen=yes])
> > +
> > +AS_IF([test "x$with_doxygen" != xno], [
> > +	AC_CHECK_PROGS([DOXYGEN], [doxygen], [""])
> > +	AC_CHECK_PROGS([DOT], [dot], [""])
> > +	AS_IF([test "x$DOT" != "x"],
> > +	      [AC_SUBST(HAVE_DOT, YES)],
> > +	      [AC_SUBST(HAVE_DOT, NO)])
> > +])
> > +
> > +AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
> > +AS_IF([test "x$DOXYGEN" = x], [
> > +	AS_IF([test "x$with_doxygen" != xno], [
> > +		dnl Only run doxygen Makefile if doxygen installed
> > +		AC_MSG_WARN([Doxygen not found - not building documentation])
> > +		enable_html_doc=no
> > +		enable_man_pages=no
> > +	])
> > +])
> > +
> >  dnl Output the makefile
> >  AC_CONFIG_FILES([Makefile src/Makefile include/Makefile
> >  	include/libnetfilter_log/Makefile utils/Makefile libnetfilter_log.pc
> > -	doxygen.cfg])
> > +	doxygen/Makefile doxygen/doxygen.cfg])
> >  AC_OUTPUT
> > +
> > +echo "
> > +libnetfilter_log configuration:
> > +man pages:                    ${enable_man_pages}
> > +html docs:                    ${enable_html_doc}"
> > diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
> > new file mode 100644
> > index 0000000..582db4e
> > --- /dev/null
> > +++ b/doxygen/Makefile.am
> > @@ -0,0 +1,39 @@
> > +if HAVE_DOXYGEN
> > +
> > +doc_srcs = $(top_srcdir)/src/libnetfilter_log.c\
> > +	   $(top_srcdir)/src/nlmsg.c\
> > +	   $(top_srcdir)/src/libipulog_compat.c
> > +
> > +doxyfile.stamp: $(doc_srcs) Makefile
> > +	rm -rf html man
> > +	doxygen doxygen.cfg >/dev/null
> > +
> > +if BUILD_MAN
> > +	$(abs_top_srcdir)/doxygen/build_man.sh
> > +endif
> > +
> > +	touch doxyfile.stamp
> > +
> > +CLEANFILES = doxyfile.stamp
> > +
> > +all-local: doxyfile.stamp
> > +clean-local:
> > +	rm -rf man html
> > +install-data-local:
> > +if BUILD_MAN
> > +	mkdir -p $(DESTDIR)$(mandir)/man3
> > +	cp --no-dereference --preserve=links,mode,timestamps man/man3/*.3\
> > +	  $(DESTDIR)$(mandir)/man3/
> > +endif
> > +if BUILD_HTML
> > +	mkdir  -p $(DESTDIR)$(htmldir)
> > +	cp  --no-dereference --preserve=links,mode,timestamps html/*\
> > +		$(DESTDIR)$(htmldir)
> > +endif
> > +
> > +# make distcheck needs uninstall-local
> > +uninstall-local:
> > +	rm -rf $(DESTDIR)$(mandir) man html doxyfile.stamp $(DESTDIR)$(htmldir)
> > +endif
> > +
> > +EXTRA_DIST = build_man.sh
> > diff --git a/doxygen.cfg.in b/doxygen/doxygen.cfg.in
> > similarity index 76%
> > rename from doxygen.cfg.in
> > rename to doxygen/doxygen.cfg.in
> > index dc2fddb..b6c27dc 100644
> > --- a/doxygen.cfg.in
> > +++ b/doxygen/doxygen.cfg.in
> > @@ -1,12 +1,11 @@
> >  # Difference with default Doxyfile 1.8.20
> >  PROJECT_NAME           = @PACKAGE@
> >  PROJECT_NUMBER         = @VERSION@
> > -OUTPUT_DIRECTORY       = doxygen
> >  ABBREVIATE_BRIEF       =
> >  FULL_PATH_NAMES        = NO
> >  TAB_SIZE               = 8
> >  OPTIMIZE_OUTPUT_FOR_C  = YES
> > -INPUT                  = .
> > +INPUT                  = @abs_top_srcdir@/src
> >  FILE_PATTERNS          = *.c
> >  RECURSIVE              = YES
> >  EXCLUDE_SYMBOLS        = nflog_g_handle \
> > @@ -18,7 +17,9 @@ SOURCE_BROWSER         = YES
> >  ALPHABETICAL_INDEX     = NO
> >  GENERATE_LATEX         = NO
> >  LATEX_CMD_NAME         = latex
> > -GENERATE_MAN           = YES
> > -HAVE_DOT               = YES
> > +GENERATE_MAN           = @GEN_MAN@
> > +GENERATE_HTML          = @GEN_HTML@
> > +MAN_LINKS              = YES
> > +HAVE_DOT               = @HAVE_DOT@
> >  DOT_TRANSPARENT        = YES
> >  SEARCHENGINE           = NO
> > --
> > 2.17.5
> >
> >

--3+lRNPUozA9zLKX+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmFgqSYACgkQKYasCr3x
BA1W9A//b8mjKXezrkKeTmV9bNBOBO18SQGqHGxos5lOBysQax22s71LZn42ld2K
EoKWKsVRwVbIzqV6C4T6sVgKMjV2/JMBdn7/BVXdeoClLFmBFIOOh7SjhXeU3FNd
AYHRJJEncoit5ot3QaSRsT0ClZgF8bnOEozSeLWfUGhgPiCQ43YtUOPcf/cp2B3z
ILExHIYYEkQ+Uln5DMWYyrFRtZsh8h0z+TTUk4TVAvXTtc9wWje8KqHFJRrAXiYF
n1HBLNOx/BZrY1ldNvtIvcdTt1JGXv92lOnXF2MjiNwZU4s9Zt9cecOY8g4QYoE8
dy083bjB15GahHPL03WvMaJFnobohpANpLuE5jJWkFBJ4jb3p8zA/Szv7mNx1nbV
v5KXy4C2X6cnEYPWqz/J2FCLUueS9Cvt8O8VU1Jvi2QK+ehPAIeKcqeiAM3Bgxan
1sV9pBFVBWOWSckpgNujlBoFP0JfRQOSFvPKZk+T1QHIKIuBVoQ2R1qsLvd0vjPL
qv4k44tlZ3wIqK1AT99Yxdtw89nXMdeZvPIKnqFSfQa+rPwqzWIcIu3nyHrZoxir
rvApXh3CjpoZEubg1eVsdKOgx4IuwbU4xoCZT+BAe79SzFc1bpm6kXXe2Pk768Z2
xgWn5VXr0lqW0mn1ucSAikzmUOvvwO8QYI5+xDGDu5d4ScwrFMc=
=+LPO
-----END PGP SIGNATURE-----

--3+lRNPUozA9zLKX+--
