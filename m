Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2130C43334
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jun 2022 16:28:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245139AbiFHQ2E (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 12:28:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245150AbiFHQ2C (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 12:28:02 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4DB1FDE82
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2022 09:28:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8C9fjlWAopjmEMLFre8kJec0KUqwknpOO1t7Ga6xIC0=; b=FYPtjYwQ9posZ42aeltHXBbFPS
        pQegIumHEFwt9g7+I50xhD2wn41fRnVriQyW513N5BnhrehPj67lQUd1jRWGHHZIRAlQyixPzsRqd
        PGLf+zB0ZXeu+H4C1xSPrcfRPs/dYgnJeqNboD1Xradf3TLmoEdZkis32ceebsAdlmgEmJQJTjI7s
        Z5leEZ414KViBJSikn7d3CDYJMkRbI/erjBMQlNF9eQ63UbtTIj+IU9wR5wlV+HozNRWpSN0/9mbk
        zAYC9LxIOYwzOSIoA3GcURqGMU9pKvKlhxgeh6fBXqOWSHRRLbLnNpI/Vagjae7ao1LDJsN6PJ2Wc
        WdKvSMRg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1nyyXG-00085P-Ts
        for netfilter-devel@vger.kernel.org; Wed, 08 Jun 2022 18:27:58 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/9] Makefile: Add --enable-profiling configure option
Date:   Wed,  8 Jun 2022 18:27:04 +0200
Message-Id: <20220608162712.31202-2-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220608162712.31202-1-phil@nwl.cc>
References: <20220608162712.31202-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

A little convenience to prepare a build for analysis with gcov/gprof.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 .gitignore                |  4 ++++
 configure.ac              | 10 ++++++++++
 extensions/GNUmakefile.in |  2 +-
 iptables/Makefile.am      |  1 +
 libipq/Makefile.am        |  1 +
 libiptc/Makefile.am       |  1 +
 libxtables/Makefile.am    |  1 +
 utils/Makefile.am         |  1 +
 8 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/.gitignore b/.gitignore
index e55952642ed0d..a206fb4870bc8 100644
--- a/.gitignore
+++ b/.gitignore
@@ -1,4 +1,8 @@
 *.a
+*.gcda
+*.gcno
+*.gcno.gcov.json.gz
+*.gcov
 *.la
 *.lo
 *.so
diff --git a/configure.ac b/configure.ac
index 071afaf1515de..ea5d2d49112a3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -71,6 +71,9 @@ AC_ARG_WITH([xt-lock-name], AS_HELP_STRING([--with-xt-lock-name=PATH],
 	[Path to the xtables lock [[/run/xtables.lock]]]),
 	[xt_lock_name="$withval"],
 	[xt_lock_name="/run/xtables.lock"])
+AC_ARG_ENABLE([profiling],
+	AS_HELP_STRING([--enable-profiling], [build for use of gcov/gprof]),
+	[enable_profiling="$enableval"], [enable_profiling="no"])
 
 AC_MSG_CHECKING([whether $LD knows -Wl,--no-undefined])
 saved_LDFLAGS="$LDFLAGS";
@@ -188,6 +191,11 @@ if [[ -n "$ksourcedir" ]]; then
 fi;
 pkgdatadir='${datadir}/xtables';
 
+if test "x$enable_profiling" = "xyes"; then
+	regular_CFLAGS+=" -fprofile-arcs -ftest-coverage"
+	regular_LDFLAGS+=" -lgcov --coverage"
+fi
+
 define([EXPAND_VARIABLE],
 [$2=[$]$1
 if test $prefix = 'NONE'; then
@@ -205,6 +213,7 @@ eval "$2=[$]$2"
 AC_SUBST([regular_CFLAGS])
 AC_SUBST([regular_CPPFLAGS])
 AC_SUBST([noundef_LDFLAGS])
+AC_SUBST([regular_LDFLAGS])
 AC_SUBST([kinclude_CPPFLAGS])
 AC_SUBST([kbuilddir])
 AC_SUBST([ksourcedir])
@@ -250,6 +259,7 @@ Iptables Configuration:
   nfsynproxy util support:		${enable_nfsynproxy}
   nftables support:			${enable_nftables}
   connlabel support:			${enable_connlabel}
+  profiling support:			${enable_profiling}
 
 Build parameters:
   Put plugins into executable (static):	${enable_static}
diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
index 6dad4e02481bd..3c68f8decd13f 100644
--- a/extensions/GNUmakefile.in
+++ b/extensions/GNUmakefile.in
@@ -24,7 +24,7 @@ kinclude_CPPFLAGS  = @kinclude_CPPFLAGS@
 AM_CFLAGS       = ${regular_CFLAGS}
 AM_CPPFLAGS     = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_builddir} -I${top_srcdir}/include -I${top_srcdir} ${kinclude_CPPFLAGS} ${CPPFLAGS} @libnetfilter_conntrack_CFLAGS@ @libnftnl_CFLAGS@
 AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
-AM_LDFLAGS      = @noundef_LDFLAGS@
+AM_LDFLAGS      = @noundef_LDFLAGS@ @regular_LDFLAGS@
 
 ifeq (${V},)
 AM_LIBTOOL_SILENT = --silent
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index 0258264c4c705..23f8352d30610 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -2,6 +2,7 @@
 
 AM_CFLAGS        = ${regular_CFLAGS}
 AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include -I${top_srcdir} ${kinclude_CPPFLAGS} ${libmnl_CFLAGS} ${libnftnl_CFLAGS} ${libnetfilter_conntrack_CFLAGS}
+AM_LDFLAGS       = ${regular_LDFLAGS}
 
 BUILT_SOURCES =
 
diff --git a/libipq/Makefile.am b/libipq/Makefile.am
index 9e3a2ca6c42e2..2cdaf32e03292 100644
--- a/libipq/Makefile.am
+++ b/libipq/Makefile.am
@@ -2,6 +2,7 @@
 
 AM_CFLAGS = ${regular_CFLAGS}
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include
+AM_LDFLAGS = ${regular_LDFLAGS}
 
 libipq_la_SOURCES = libipq.c
 lib_LTLIBRARIES   = libipq.la
diff --git a/libiptc/Makefile.am b/libiptc/Makefile.am
index 464a069628f0c..097842f212bb5 100644
--- a/libiptc/Makefile.am
+++ b/libiptc/Makefile.am
@@ -2,6 +2,7 @@
 
 AM_CFLAGS        = ${regular_CFLAGS}
 AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CPPFLAGS}
+AM_LDFLAGS       = ${regular_LDFLAGS}
 
 pkgconfig_DATA      = libiptc.pc libip4tc.pc libip6tc.pc
 
diff --git a/libxtables/Makefile.am b/libxtables/Makefile.am
index 3bfded8570e08..2f4a12e571b9b 100644
--- a/libxtables/Makefile.am
+++ b/libxtables/Makefile.am
@@ -2,6 +2,7 @@
 
 AM_CFLAGS   = ${regular_CFLAGS}
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include -I${top_srcdir}/iptables -I${top_srcdir} ${kinclude_CPPFLAGS}
+AM_LDFLAGS  = ${regular_LDFLAGS}
 
 lib_LTLIBRARIES       = libxtables.la
 libxtables_la_SOURCES = xtables.c xtoptions.c getethertype.c
diff --git a/utils/Makefile.am b/utils/Makefile.am
index 42bd973730194..327a29e028c4d 100644
--- a/utils/Makefile.am
+++ b/utils/Makefile.am
@@ -3,6 +3,7 @@
 AM_CFLAGS = ${regular_CFLAGS}
 AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_builddir}/include \
               -I${top_srcdir}/include ${libnfnetlink_CFLAGS}
+AM_LDFLAGS = ${regular_LDFLAGS}
 
 sbin_PROGRAMS =
 pkgdata_DATA =
-- 
2.34.1

