Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B754C432BE
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Aug 2021 21:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E9CC60F58
	for <netfilter-devel@archiver.kernel.org>; Fri, 27 Aug 2021 21:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231688AbhH0VKz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 27 Aug 2021 17:10:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231570AbhH0VKz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 27 Aug 2021 17:10:55 -0400
Received: from kadath.azazel.net (kadath.azazel.net [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B633EC0613D9
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Aug 2021 14:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Type:MIME-Version:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=n3LqUd53dSqa5LZ1T5K5aOOO2jQW0M7UGbdIJXvdyqc=; b=KOSOdgglk44Hn/vA09yWOv1sni
        9tjA7yrP3m6x+6on0AGggEZyrG4sSGh0dP0TOutOvdcxObNo4lZ4wdWt3soihiJ0KMfhw0GNLryEP
        /lPViBBgVEZr5rtXPQG9kHyGcKJk/Xg0jCMB6ECnpC3JOhV1SzaDVWulIUjeXVn7TiHsh7PUgZ4X3
        HlHEsDbDk7jKvMPKlEd1BIVYg+F7m8nf8GM+dZv40RtZhI4jWyaDw8cBXrw4nB/CsDmT+laCd323Q
        GwngvvHrDpAvrTbNwGWqtPn613biFfmYO2Zk3PEp72MdY1pTqWbaSYSCKkZx23tDCzOHuyxrrftkJ
        QN9SMtDA==;
Received: from [2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3] (helo=azazel.net)
        by kadath.azazel.net with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mJj6u-00EXlC-3u; Fri, 27 Aug 2021 22:10:00 +0100
Date:   Fri, 27 Aug 2021 22:09:58 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Duncan Roe <duncan_roe@optusnet.com.au>
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: libnetfilter_queue: automake portability warning
Message-ID: <YSlUpg5zfcwNiS50@azazel.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="g6NtRdAyxNFnOa/f"
Content-Disposition: inline
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:feb3:bcff:fe5e:42c3
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--g6NtRdAyxNFnOa/f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Running autogen.sh gives the following output when it gets to
doxygen/Makefile.am:

  doxygen/Makefile.am:3: warning: shell find $(top_srcdir: non-POSIX variable name
  doxygen/Makefile.am:3: (probably a GNU make extension)

Automake doesn't understand the GNU make $(shell ...) function and tries
to interpret it as an Automake variable.  The Automake people would
probably say we shouldn't do that 'cause it's not portable:

  https://www.gnu.org/software/automake/manual/automake.html#Wildcards

However, if we accept that we are targetting GNU make, but we want to
get rid of the warning, I believe there are two ways to do so.  We can
tell Automake not to warn about non-portable constructions:

  diff --git a/configure.ac b/configure.ac
  index 4721eebbab1f..7cd34d079e67 100644
  --- a/configure.ac
  +++ b/configure.ac
  @@ -6,7 +6,7 @@ AC_CANONICAL_HOST
   AC_CONFIG_MACRO_DIR([m4])
   AC_CONFIG_HEADERS([config.h])

  -AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
  +AM_INIT_AUTOMAKE([-Wall -Wno-portability foreign subdir-objects
          tar-pax no-dist-gzip dist-bzip2 1.6])
   m4_ifdef([AM_PROG_AR], [AM_PROG_AR])

On the other hand, if we want to suppress the warning for just this one
GNU-ism, we can hide it from automake:

  diff --git a/configure.ac b/configure.ac
  index 4721eebbab1f..b2b54d3168ad 100644
  --- a/configure.ac
  +++ b/configure.ac
  @@ -56,6 +56,19 @@ AS_IF([test "x$DOXYGEN" = x], [
                  with_doxygen=no
          ])
   ])
  +#
  +# Putting $(shell ... ) directly into the doyxgen Makefile.am confuses automake,
  +# which tries to interpret it as an automake variable:
  +#
  +#   doxygen/Makefile.am:3: warning: shell find $(top_srcdir: non-POSIX variable name
  +#   doxygen/Makefile.am:3: (probably a GNU make extension)
  +#
  +# Instead, we use autoconf to substitute it into place after automake has run.
  +#
  +AS_IF([test "x$with_doxygen" != no], [
  +  AC_SUBST([DOC_SRCS], ['$(shell find $(top_srcdir)/src -name '"'"'*.c'"'"')'])
  +])
  +
   AC_OUTPUT

   echo "
  diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
  index f38009b24114..6ed30e21ff75 100644
  --- a/doxygen/Makefile.am
  +++ b/doxygen/Makefile.am
  @@ -1,6 +1,6 @@
   if HAVE_DOXYGEN

  -doc_srcs = $(shell find $(top_srcdir)/src -name '*.c')
  +doc_srcs = @DOC_SRCS@

   doxyfile.stamp: $(doc_srcs) Makefile.am
          rm -rf html man

J.

--g6NtRdAyxNFnOa/f
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEbB20U2PvQDe9VtUXKYasCr3xBA0FAmEpVKYACgkQKYasCr3x
BA18ShAAvEsmRpfg3pphZBw4OjqAuhpDf1zPihfho9uvdTZHZejUmoDmBOM+cbZc
AqZLXVE7pQti+jUKG6TdIzpGXhBVPorbWFwvhyqqFEpRRZNcoVNjuIHnYWroRbqV
+lSS14wqrbP3QJzJN5USJGd1EP7mXIX5djuj2BuVt0nRoxFmv1y7SYo3Rr9VCKvI
nSijuR/9wOUvWAZ+ollZh2C5ugMSyU+y6O5JVgJb0QRzhlGKqMg/GZLgZeCLbd1X
6ZHIgIy+k8rdYXB3zReSw9SqSY7UjkGufWLaHeNj0TDnVEGLa3N74w6vSHDZXnJT
Vuu6VqKOSLTOi4nOEdRMfw0KWRlMRYLzwq4ZOFsFo3YSRgZIU9pN/0+lO0Yzo25P
/VLs0vpkMBUcGv4TyyIAOJHLMO+GxBTiqNHkgC1gNGrkJonMq0AMC6hPgEwrNiy6
bER413x0sJ4DGcD34aEFui5uYh430OqLrM5lj120wU/mO53okl0+/b03yC+jvmw8
2azxRSG+/VX2h9ZyRXk6RCzp4yUvYP4BG8gqJEWXaN0abOkH/klapzdb3KFj4OMD
r41PRWJnWBIQFEWKhXTnIn8CbHNY//O3WCaj2SAt1kPaDPhuUOmEbgfri+vaCUy9
FaNM+FN2cRu6qCxoqkG4rh1JbiOeG8uDhlZMgJgvCKSFxCyZElM=
=1R8m
-----END PGP SIGNATURE-----

--g6NtRdAyxNFnOa/f--
