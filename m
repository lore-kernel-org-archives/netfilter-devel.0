From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH 1/4] Add configure flag to disable NFACCT build
Date: Sat, 03 Nov 2012 17:01:01 +0100
Message-ID: <1351958461.11805.1.camel@tourtet>
References: <1351942382-24791-1-git-send-email-eric@regit.org>
	 <1351942382-24791-2-git-send-email-eric@regit.org>
	 <alpine.LNX.2.01.1211031537300.14935@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:50505 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756224Ab2KCQBS convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Nov 2012 12:01:18 -0400
In-Reply-To: <alpine.LNX.2.01.1211031537300.14935@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Le samedi 03 novembre 2012 =C3=A0 15:40 +0100, Jan Engelhardt a =C3=A9c=
rit :
>=20
> On Saturday 2012-11-03 12:32, Eric Leblond wrote:
>=20
> >diff --git a/configure.ac b/configure.ac
> >index 0f21cf1..159cb0b 100644
> >--- a/configure.ac
> >+++ b/configure.ac
> >@@ -44,9 +44,15 @@ AC_SUBST([regular_CFLAGS])
> > dnl Check for the right nfnetlink version
> > PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >=3D 1.0.1])
> > PKG_CHECK_MODULES([LIBMNL], [libmnl >=3D 1.0.3])
> >-PKG_CHECK_MODULES([LIBNETFILTER_ACCT], [libnetfilter_acct >=3D 1.0.=
1])
> > PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack=
 >=3D 1.0.2])
> > PKG_CHECK_MODULES([LIBNETFILTER_LOG], [libnetfilter_log >=3D 1.0.0]=
)
> >+AC_ARG_ENABLE(nfacct,
> >+       AS_HELP_STRING([--enable-nfacct], [Enable nfacct module [def=
ault=3Dyes]]),,[enable_nfacct=3Dyes])
> >+AS_IF([test "x$enable_nfacct" =3D "xyes"], [
> >+    PKG_CHECK_MODULES([LIBNETFILTER_ACCT], [libnetfilter_acct >=3D =
1.0.1])
> >+    AC_DEFINE([BUILD_NFACCT], [1], [Building nfacct module])
> >+])
> >+AM_CONDITIONAL([BUILD_NFACCT], [test "x$enable_nfacct" =3D "xyes"])
> >=20
> > CT_CHECK_POSTGRES_DB()
> > AM_CONDITIONAL(HAVE_PGSQL, test "x$PQLIBPATH" !=3D "x")
> >diff --git a/input/sum/Makefile.am b/input/sum/Makefile.am
> >index 33fa849..b6ddb4d 100644
> >--- a/input/sum/Makefile.am
> >+++ b/input/sum/Makefile.am
> >@@ -1,8 +1,8 @@
> > AM_CPPFLAGS =3D -I$(top_srcdir)/include $(LIBNETFILTER_ACCT_CFLAGS)=
 $(LIBMNL_CFLAGS)
> > AM_CFLAGS =3D ${regular_CFLAGS}
> >-
> >+if BUILD_NFACCT
> > pkglib_LTLIBRARIES =3D ulogd_inpflow_NFACCT.la
> >-
> > ulogd_inpflow_NFACCT_la_SOURCES =3D ulogd_inpflow_NFACCT.c
> > ulogd_inpflow_NFACCT_la_LDFLAGS =3D -avoid-version -module
> > ulogd_inpflow_NFACCT_la_LIBADD  =3D $(LIBMNL_LIBS) $(LIBNETFILTER_A=
CCT_LIBS)
> >+endif
>=20
> As far as I remember, AM conditionals do not automatically
> become C macros. Can you check config.h?

Yeah, that's why I've added AC_DEFINE when the module is built.

BR,

> So you will likely have to add the following line into the if..endif
> block:
>=20
>  AM_CPPFLAGS +=3D -DBUILD_NFACCT


--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
