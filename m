Return-Path: <SRS0=LKNA=RU=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64B27C43381
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Mar 2019 18:24:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 32A1C20872
	for <netfilter-devel@archiver.kernel.org>; Sun, 17 Mar 2019 18:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726229AbfCQSYm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 17 Mar 2019 14:24:42 -0400
Received: from wp260.webpack.hosteurope.de ([80.237.133.29]:50220 "EHLO
        wp260.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725946AbfCQSYm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 17 Mar 2019 14:24:42 -0400
Received: from p200300cb2706710199469a6c02ec47e3.dip0.t-ipconnect.de ([2003:cb:2706:7101:9946:9a6c:2ec:47e3] helo=deneb.skynet.aixah.de); authenticated
        by wp260.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1h5aSf-0000M7-2t; Sun, 17 Mar 2019 19:24:41 +0100
Received: by deneb.skynet.aixah.de (Postfix, from userid 1000)
        id ECA80C2D07; Sun, 17 Mar 2019 19:24:39 +0100 (CET)
From:   Luis Ressel <aranea@aixah.de>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nft 2/2 v2] configure.ac: Clean up AC_ARG_{WITH,ENABLE} invocations, s/==/=/
Date:   Sun, 17 Mar 2019 19:24:22 +0100
Message-Id: <20190317182422.17738-1-aranea@aixah.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;aranea@aixah.de;1552847082;f5d0e440;
X-HE-SMSGID: 1h5aSf-0000M7-2t
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

* AC_ARG_ENABLE implicitly defines enable_debug; there's no point in
  performing extra work just to define with_debug with an identical
  value.

* The same applies to with_xtables and with_libxtables.

* The AS_IF block in the `AC_ARG_ENABLE([man-doc], ...` invocation is
  essentially a noop. All it does is to set enable_man_doc to `yes` if
  has a value that matches neither `yes` nor `no`. (This could happen if
  a user calls `configure --enable-man-doc=foo`, but that'd be a user
  error which we don't need to handle.)

* The correct operator for equality tests in `test` is `=`. Some
  implementations also support `==`, but this is not portable.
---
 configure.ac | 34 +++++++++++++++-------------------
 1 file changed, 15 insertions(+), 19 deletions(-)

diff --git a/configure.ac b/configure.ac
index ccf8db0..e3c0be2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -13,16 +13,13 @@ AC_CONFIG_HEADER([config.h])
 
 AC_ARG_ENABLE([debug],
 	      AS_HELP_STRING([--disable-debug], [Disable debugging symbols]),
-	      AS_IF([test "x$enable_debug" = "xno"], [with_debug=no], [with_debug=yes]),
-	      [with_debug=yes])
-AC_SUBST(with_debug)
-AM_CONDITIONAL([BUILD_DEBUG], [test "x$with_debug" != xno])
+	      [], [enable_debug=yes])
+AM_CONDITIONAL([BUILD_DEBUG], [test "x$enable_debug" != xno])
 
 AC_ARG_ENABLE([man-doc],
 	      AS_HELP_STRING([--disable-man-doc], [Disable man page documentation]),
-	      AS_IF([test "x$enable_man_doc" = "xno"], [enable_man_doc=no],
-	      [enable_man_doc=yes]), [enable_man_doc=yes])
-AM_CONDITIONAL([BUILD_MAN], [test "x$enable_man_doc" == "xyes" ])
+	      [], [enable_man_doc=yes])
+AM_CONDITIONAL([BUILD_MAN], [test "x$enable_man_doc" = "xyes" ])
 
 # Checks for programs.
 AC_PROG_CC
@@ -58,12 +55,12 @@ PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
 PKG_CHECK_MODULES([LIBNFTNL], [libnftnl >= 1.1.1])
 
 AC_ARG_WITH([mini-gmp], [AS_HELP_STRING([--with-mini-gmp],
-            [Use builtin mini-gmp (for embedded builds)])], [],
-            [with_mini_gmp=no])
+            [Use builtin mini-gmp (for embedded builds)])],
+	    [], [with_mini_gmp=no])
 AS_IF([test "x$with_mini_gmp" != xyes], [
 AC_CHECK_LIB([gmp],[__gmpz_init], , AC_MSG_ERROR([No suitable version of libgmp found]))
 ])
-AM_CONDITIONAL([BUILD_MINIGMP], [test "x$with_mini_gmp" == xyes])
+AM_CONDITIONAL([BUILD_MINIGMP], [test "x$with_mini_gmp" = xyes])
 
 AC_ARG_WITH([cli], [AS_HELP_STRING([--without-cli],
             [disable interactive CLI (libreadline support)])],
@@ -78,13 +75,12 @@ AM_CONDITIONAL([BUILD_CLI], [test "x$with_cli" != xno])
 
 AC_ARG_WITH([xtables], [AS_HELP_STRING([--with-xtables],
             [Use libxtables for iptables interaction])],
-	    [with_libxtables=$withval], [with_libxtables=no])
-AS_IF([test "x$with_libxtables" != xno], [
+	    [], [with_xtables=no])
+AS_IF([test "x$with_xtables" != xno], [
 PKG_CHECK_MODULES([XTABLES], [xtables >= 1.6.1])
 AC_DEFINE([HAVE_LIBXTABLES], [1], [0])
 ])
-AC_SUBST(with_libxtables)
-AM_CONDITIONAL([BUILD_XTABLES], [test "x$with_libxtables" == xyes])
+AM_CONDITIONAL([BUILD_XTABLES], [test "x$with_xtables" = xyes])
 
 AC_ARG_WITH([json], [AS_HELP_STRING([--with-json],
             [Enable JSON output support])],
@@ -106,9 +102,9 @@ AC_ARG_WITH([python_bin],
 	    [PYTHON_BIN="$withval"], [AC_PATH_PROGS(PYTHON_BIN, python python2 python2.7)]
 	   )
 
-AS_IF([test "x$PYTHON_BIN" == "x"], [
-	AS_IF([test "x$enable_python" == "xyes"], [AC_MSG_ERROR([Python asked but not found])])
-	AS_IF([test "x$enable_python" == "xcheck"], [AC_MSG_WARN([Python not found, continuing anyway])])
+AS_IF([test "x$PYTHON_BIN" = "x"], [
+	AS_IF([test "x$enable_python" = "xyes"], [AC_MSG_ERROR([Python asked but not found])])
+	AS_IF([test "x$enable_python" = "xcheck"], [AC_MSG_WARN([Python not found, continuing anyway])])
 	])
 
 AM_CONDITIONAL([HAVE_PYTHON], [test "x$PYTHON_BIN" != "x"])
@@ -136,10 +132,10 @@ AC_OUTPUT
 echo "
 nft configuration:
   cli support:			${with_cli}
-  enable debugging symbols:	${with_debug}
+  enable debugging symbols:	${enable_debug}
   use mini-gmp:			${with_mini_gmp}
   enable man page:              ${enable_man_doc}
-  libxtables support:		${with_libxtables}
+  libxtables support:		${with_xtables}
   json output support:          ${with_json}"
 
 AS_IF([test "x$PYTHON_BIN" != "x"], [
-- 
2.21.0

