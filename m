From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 1/4] Add configure flag to disable NFACCT build
Date: Sat, 3 Nov 2012 15:40:28 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1211031537300.14935@nerf07.vanv.qr>
References: <1351942382-24791-1-git-send-email-eric@regit.org> <1351942382-24791-2-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:49699 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751911Ab2KCOk3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Nov 2012 10:40:29 -0400
In-Reply-To: <1351942382-24791-2-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2012-11-03 12:32, Eric Leblond wrote:

>diff --git a/configure.ac b/configure.ac
>index 0f21cf1..159cb0b 100644
>--- a/configure.ac
>+++ b/configure.ac
>@@ -44,9 +44,15 @@ AC_SUBST([regular_CFLAGS])
> dnl Check for the right nfnetlink version
> PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.1])
> PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
>-PKG_CHECK_MODULES([LIBNETFILTER_ACCT], [libnetfilter_acct >= 1.0.1])
> PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 1.0.2])
> PKG_CHECK_MODULES([LIBNETFILTER_LOG], [libnetfilter_log >= 1.0.0])
>+AC_ARG_ENABLE(nfacct,
>+       AS_HELP_STRING([--enable-nfacct], [Enable nfacct module [default=yes]]),,[enable_nfacct=yes])
>+AS_IF([test "x$enable_nfacct" = "xyes"], [
>+    PKG_CHECK_MODULES([LIBNETFILTER_ACCT], [libnetfilter_acct >= 1.0.1])
>+    AC_DEFINE([BUILD_NFACCT], [1], [Building nfacct module])
>+])
>+AM_CONDITIONAL([BUILD_NFACCT], [test "x$enable_nfacct" = "xyes"])
> 
> CT_CHECK_POSTGRES_DB()
> AM_CONDITIONAL(HAVE_PGSQL, test "x$PQLIBPATH" != "x")
>diff --git a/input/sum/Makefile.am b/input/sum/Makefile.am
>index 33fa849..b6ddb4d 100644
>--- a/input/sum/Makefile.am
>+++ b/input/sum/Makefile.am
>@@ -1,8 +1,8 @@
> AM_CPPFLAGS = -I$(top_srcdir)/include $(LIBNETFILTER_ACCT_CFLAGS) $(LIBMNL_CFLAGS)
> AM_CFLAGS = ${regular_CFLAGS}
>-
>+if BUILD_NFACCT
> pkglib_LTLIBRARIES = ulogd_inpflow_NFACCT.la
>-
> ulogd_inpflow_NFACCT_la_SOURCES = ulogd_inpflow_NFACCT.c
> ulogd_inpflow_NFACCT_la_LDFLAGS = -avoid-version -module
> ulogd_inpflow_NFACCT_la_LIBADD  = $(LIBMNL_LIBS) $(LIBNETFILTER_ACCT_LIBS)
>+endif

As far as I remember, AM conditionals do not automatically
become C macros. Can you check config.h?
So you will likely have to add the following line into the if..endif
block:

 AM_CPPFLAGS += -DBUILD_NFACCT
