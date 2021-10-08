Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39CD0C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Oct 2021 20:16:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E8A761019
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Oct 2021 20:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231589AbhJHUSw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 8 Oct 2021 16:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbhJHUSw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 8 Oct 2021 16:18:52 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD4DC061570
        for <netfilter-devel@vger.kernel.org>; Fri,  8 Oct 2021 13:16:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=34Ii7Bj+7OWpM0m9JAT2pDRCJn5wUDcp/it2pR9wj5Q=; b=R2SPQytWsDWCZdjgM37SXiqs+R
        lPJqOSL5gZnhu9xiKF/y8H1PCaWFxpdF6vjwUu0uwmuU5YnYbAdpxPde2nGSOhYd7W3IMEUUCBaIX
        4hc5hfjP67aEMKj86TudQa9mbVUJwaZM2Uf5U7XTAQTk5xvUOIxRrGqPC76hhdQ/gMxsZI+xs1l6r
        vhjcL2Xwuu3JNPn+0HXGGLZY4l4gBS6+Tj6uylmRHDV5H/aTopmB9+J9xHeosP7GXhQUnD4TjKpWE
        qx+YpNafewMz1TgPLl4AV2OzfAtGJ8V5ocZ3MSKFZg+y/7ENe2Af9nC38Y/k4yAh85QFiCJO78edL
        9AcpggHA==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mYwIV-00Aj6o-Pr; Fri, 08 Oct 2021 21:16:51 +0100
Date:   Fri, 8 Oct 2021 21:16:50 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH libnetfilter_log v3] build: doc: `make` generates
 requested documentation
Message-ID: <YWCnMp8v8oQuA9N6@azazel.net>
References: <20211006042627.22161-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="YemMeEZEpeaZDoOF"
Content-Disposition: inline
In-Reply-To: <20211006042627.22161-1-duncan_roe@optusnet.com.au>
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--YemMeEZEpeaZDoOF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On 2021-10-06, at 15:26:27 +1100, Duncan Roe wrote:
> Generate man pages, HTML, neither or both according to ./configure.
> Based on the work done for libnetfilter_queue
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>

A couple of minor comments below, but otherwise:

Tested-by: Jeremy Sowden <jeremy@azazel.net>

> ---
> v2: remove --without-doxygen since -disable-man-pages does that
> v3: - update .gitignore for clean `git status` after in-tree build
>     - adjust configure.ac indentation for better readability
>     - adjust configure.ac for all lines to fit in 80cc
>  .gitignore                               |  7 ++--
>  Makefile.am                              |  2 +-
>  autogen.sh                               |  8 +++++
>  configure.ac                             | 45 +++++++++++++++++++++++-
>  doxygen/Makefile.am                      | 39 ++++++++++++++++++++
>  doxygen.cfg.in => doxygen/doxygen.cfg.in |  9 ++---
>  6 files changed, 102 insertions(+), 8 deletions(-)
>  create mode 100644 doxygen/Makefile.am
>  rename doxygen.cfg.in => doxygen/doxygen.cfg.in (76%)
>
> diff --git a/.gitignore b/.gitignore
> index 5eaabe3..bb5e9d8 100644
> --- a/.gitignore
> +++ b/.gitignore
> @@ -13,6 +13,9 @@ Makefile.in
>  /configure
>  /libtool
>
> -/doxygen/
> -/doxygen.cfg

I'd leave the initial /'s here:

> +doxygen/doxygen.cfg
> +doxygen/build_man.sh
> +doxygen/doxyfile.stamp
> +doxygen/man/
> +doxygen/html/
>  /*.pc
> diff --git a/Makefile.am b/Makefile.am
> index 2a9cdd8..6662d7b 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -1,4 +1,4 @@
> -SUBDIRS	= include src utils
> +SUBDIRS	= include src utils doxygen
>
>  ACLOCAL_AMFLAGS = -I m4
>
> diff --git a/autogen.sh b/autogen.sh
> index 5e1344a..b47c529 100755
> --- a/autogen.sh
> +++ b/autogen.sh
> @@ -1,4 +1,12 @@
>  #!/bin/sh -e
>
> +# Allow to override build_man.sh url for local testing
> +# E.g. export NFQ_URL=file:///usr/src/libnetfilter_queue
> +NFQ_URL=${NFQ_URL:-https://git.netfilter.org/libnetfilter_queue/plain}

You may as well download build_man.sh straight to doxygen/:

  BUILD_MAN=doxygen/build_man.sh

  curl $NFQ_URL/$BUILD_MAN -o$BUILD_MAN
  chmod a+x $BUILD_MAN

> +curl $NFQ_URL/doxygen/build_man.sh -O
> +chmod a+x build_man.sh
> +mv build_man.sh doxygen/
> +
>  autoreconf -fi
>  rm -Rf autom4te.cache
> diff --git a/configure.ac b/configure.ac
> index c914e00..134178d 100644
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
>  AC_DISABLE_STATIC
> @@ -35,8 +52,34 @@ PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 1.0.2],
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
>  AC_CONFIG_FILES([Makefile src/Makefile include/Makefile
>  	include/libnetfilter_log/Makefile utils/Makefile libnetfilter_log.pc
> -	doxygen.cfg])
> +	doxygen/Makefile doxygen/doxygen.cfg])
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

--YemMeEZEpeaZDoOF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmFgpzIACgkQKYasCr3x
BA3Y9g//XotsvWCSD3Bp3h3S8PAA8uyh82d0kdngbrdzMu9a545DoQmL2n81MdSA
T7OYndlXtvp8Z0RoQsZxpLUYaeFHWip6gICVwWstQ/ymTZtrLdtwHAQK+oyjgbM8
XKfwojtUKLKH1lRiAjobr+pPkw4n1TSzm9JSkVOIIng2eqxTA6NurLHZwvkT3Kwy
hAROHySU3jaYt5+BBSKoEBjjXWre1igGVU3NZl+GT4i5j092++spfhuq4ifXK51t
+ZghDgXE6aHm6ZuXoTZjiipou7obmJKz7VnnkcypBQuDBh0iUBg3DBOw4drcJmaP
EvuBbZ5r8Te+gTL1JGplh7dmjbHVS/lu7qbnb5m2YOhphVbUoUQR30LTblQH/Xto
cobUeScFWMO+CC1WXD8ySetO7ThlGXYhnf5qvEN9LP708G1WZR1Mwb9/HN0aE7Gw
kB1wBTJx/Jz4613oY48XSUQ4kuX6HUtPwoNypkjNJO8F5w0QIVRNOXHDRn7dxIhO
yWknctwIseNbdoOh2kBv7C8KEO+k7ERHao1dc83n26oU8PWWjk/5Nb0/Yga6Fvt5
16geDbDP9cLT5cfbwVO+KrDq8pXxk7mLRPQLI77ruZgSMm7LRHUoMlP3jTUZKkl3
FFiGwWXqj7aQUuEWUs6u5sJlvTnkmsIXkEk4XKh2mYfxratYnto=
=+ACZ
-----END PGP SIGNATURE-----

--YemMeEZEpeaZDoOF--
