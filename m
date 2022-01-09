Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B496C4332F
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jan 2022 11:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233947AbiAIL6n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 Jan 2022 06:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230155AbiAIL6m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Jan 2022 06:58:42 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FB86C061756
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Jan 2022 03:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=MSUs7MQCLpP518lzZg/FUWr6NCBypLIiFDmZ8aQqjr4=; b=d0gVjzyp3mNZdTKSRMPcBbuiJX
        ZzGI6F1AGOwPcW3y2eU3wP/gWbSWK3vbuncSFgtdjor8kWeY4H5njh7irU1ArJKRCGFY/JtAyZ5XV
        e2+cTYvX7q0vzmYv5eh9pNgb/W5tvYoCn3i3FaFDK9wIj6ZVYIMB5HfbEU3HDqSIV6bZa8zT2ICQu
        rUkMYKQuFKcOOCQLMBTUEAz8YNIf3EJCfrkoN0otpCyl97ixjbmVMc7CQGYvca17NStnk1g/MXzAR
        XxtJhWBmcLVIqVY3Fo5ppuzkiyGODYwxqB4SpPc2r0g5iUdQJ2sY7uss23r3oPIP+XISDY9S08op+
        gwtsj00w==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n6WqO-002BZm-IH
        for netfilter-devel@vger.kernel.org; Sun, 09 Jan 2022 11:58:40 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 04/10] build: use pkg-config or pcap-config for libpcap
Date:   Sun,  9 Jan 2022 11:57:47 +0000
Message-Id: <20220109115753.1787915-5-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220109115753.1787915-1-jeremy@azazel.net>
References: <20220109115753.1787915-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Recent versions of libpcap support pkg-config.  Older versions provide a
pcap-config script.  Use pkg-config if available, otherwise fall back to
pcap-config.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 acinclude.m4            | 79 -----------------------------------------
 configure.ac            | 30 ++++++++++++++--
 output/pcap/Makefile.am |  2 ++
 3 files changed, 29 insertions(+), 82 deletions(-)

diff --git a/acinclude.m4 b/acinclude.m4
index a49ed316e65a..6d88c3a53cff 100644
--- a/acinclude.m4
+++ b/acinclude.m4
@@ -93,82 +93,3 @@ fi
 
 ])
 
-dnl @synopsis CT_CHECK_PCAP
-dnl
-dnl This macro tries to find the headers and libraries for libpcap.
-dnl
-dnl If includes are found, the variable PCAP_INC will be set. If
-dnl libraries are found, the variable PCAP_LIB will be set. if no check
-dnl was successful, the script exits with a error message.
-dnl
-dnl @category InstalledPackages
-dnl @author Harald Welte <laforge@gnumonks.org>
-dnl @version 2006-01-07
-dnl @license AllPermissive
-
-AC_DEFUN([CT_CHECK_PCAP], [
-
-AC_ARG_WITH(pcap,
-	[  --with-pcap=PREFIX		Prefix of your libpcap installation],
-	[pcap_prefix=$withval], [pcap_prefix=])
-AC_ARG_WITH(pcap-inc,
-	[  --with-pcap-inc=PATH		Path to the include directory of pcap],
-	[pcap_inc=$withval], [pcap_inc=/usr/include])
-AC_ARG_WITH(pcap-lib,
-	[  --with-pcap-lib=PATH		Path to the libraries of pcap],
-	[pcap_lib=$withval], [pcap_lib=/usr/lib])
-
-
-AC_SUBST(PCAP_INC)
-AC_SUBST(PCAP_LIB)
-AC_SUBST(HAVE_PCAP_LIB)
-
-if test "$pcap_prefix" != "no"; then
-
-if test "$pcap_prefix" != ""; then
-   AC_MSG_CHECKING([for libpcap includes in $pcap_prefix/include])
-   if test -f "$pcap_prefix/include/pcap.h" ; then
-      PCAP_INC="-I$pcap_prefix/include"
-      AC_MSG_RESULT([yes])
-   else
-      AC_MSG_WARN(pcap.h not found)
-   fi
-   AC_MSG_CHECKING([for libpcap in $pcap_prefix/lib])
-   if test -f "$pcap_prefix/lib/libpcap.so" ; then
-      PCAP_LIB="-L$pcap_prefix/lib -lpcap";
-      AC_MSG_RESULT([yes])
-   else
-      AC_MSG_WARN(libpcap.so not found)
-   fi
-else
-  if test "$pcap_inc" != ""; then
-    AC_MSG_CHECKING([for libpcap includes in $pcap_inc])
-    if test -f "$pcap_inc/pcap.h" ; then
-      PCAP_INC="-I$pcap_inc"
-      AC_MSG_RESULT([yes])
-    else
-      AC_MSG_WARN(pcap.h not found)
-    fi
-  fi
-  if test "$pcap_lib" != ""; then
-    AC_MSG_CHECKING([for libpcap in $pcap_lib])
-    if test -f "$pcap_lib/libpcap.so" ; then
-      PCAP_LIB="-L$pcap_lib -lpcap";
-      AC_MSG_RESULT([yes])
-    else
-      AC_MSG_WARN(libpcap.so not found)
-    fi
-  fi
-fi
-
-if test "$PCAP_INC" = "" ; then
-  AC_CHECK_HEADER([pcap.h], [], AC_MSG_WARN(pcap.h not found))
-fi
-if test "$PCAP_LIB" = "" ; then
-  AC_CHECK_LIB(pcap, pcap_close, [HAVE_PCAP_LIB="yes"], AC_MSG_WARN(libpcap.so not found))
-fi
-
-fi
-
-])
-
diff --git a/configure.ac b/configure.ac
index bcdd2f8ed99f..6909ea4858bb 100644
--- a/configure.ac
+++ b/configure.ac
@@ -153,9 +153,33 @@ AM_CONDITIONAL([HAVE_DBI], [test "x$libdbi_LIBS" != "x"])
 
 AC_ARG_ENABLE([pcap],
               [AS_HELP_STRING([--enable-pcap], [Enable PCAP output plugin [default=test]])])
-AS_IF([test "x$enable_pcap" != "xno"],
-      [AC_SEARCH_LIBS([pcap_close], [pcap], [libpcap_LIBS="-lpcap"; LIBS=""])
-       AC_SUBST([libpcap_LIBS])])
+AS_IF([test "x$enable_pcap" != "xno"], [
+
+  PKG_CHECK_EXISTS([libpcap], [PKG_CHECK_MODULES([libpcap], [libpcap])], [
+
+    AC_ARG_WITH([pcap-config],
+                [AS_HELP_STRING([--with-pcap-config=PATH], [Path to the pcap-config script])],
+                [pcap_config="$withval"], [pcap_config=pcap-config])
+
+    AC_MSG_CHECKING([for pcap-config])
+
+    AS_IF([command -v "$pcap_config" >/dev/null], [
+
+      libpcap_CFLAGS="`$pcap_config --cflags`"
+      libpcap_LIBS="`$pcap_config --libs`"
+
+      AC_SUBST([libpcap_CFLAGS])
+      AC_SUBST([libpcap_LIBS])
+
+      AC_MSG_RESULT([$pcap_config])
+
+    ], [
+      AC_MSG_RESULT([no])
+    ])
+
+  ])
+
+])
 AS_IF([test "x$libpcap_LIBS" != "x"], [enable_pcap=yes], [enable_pcap=no])
 AM_CONDITIONAL([HAVE_PCAP], [test "x$libpcap_LIBS" != "x"])
 
diff --git a/output/pcap/Makefile.am b/output/pcap/Makefile.am
index 9b4b3dde3a9c..b5064eac9fd3 100644
--- a/output/pcap/Makefile.am
+++ b/output/pcap/Makefile.am
@@ -1,5 +1,7 @@
 include $(top_srcdir)/Make_global.am
 
+AM_CPPFLAGS += $(libpcap_CFLAGS)
+
 pkglib_LTLIBRARIES = ulogd_output_PCAP.la
 
 ulogd_output_PCAP_la_SOURCES = ulogd_output_PCAP.c
-- 
2.34.1

