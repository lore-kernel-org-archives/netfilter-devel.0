Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC57EC04AB6
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 09:18:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AA1A5208C3
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 09:18:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726925AbfE1JSm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 05:18:42 -0400
Received: from a3.inai.de ([88.198.85.195]:38790 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726912AbfE1JSm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 05:18:42 -0400
Received: by a3.inai.de (Postfix, from userid 65534)
        id D88E83BB8A9D; Tue, 28 May 2019 11:18:39 +0200 (CEST)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:222:6c9::f8])
        by a3.inai.de (Postfix) with ESMTP id 099BE3BB6EEF;
        Tue, 28 May 2019 11:18:32 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH] build: remove -Wl,--no-as-needed and libiptc.so
Date:   Tue, 28 May 2019 11:18:32 +0200
Message-Id: <20190528091832.32164-1-jengelh@inai.de>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190528090354.10663-1-jengelh@inai.de>
References: <20190528090354.10663-1-jengelh@inai.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Despite the presence of --no-as-needed, the libiptc.so library as
produced inside the openSUSE Build Service has no links to
libip4tc.so or libip6tc.so. I have not looked into why --no-as-needed
is ignored in this instance, but likewise, the situation must have
been like that ever since openSUSE made as-needed a distro-wide
default (gcc 4.8 timeframe or so).

Since I am not aware of any problem reports within SUSE/openSUSE
about this whole situation, it seems safe to assume no one in the
larger scope is still using a bare "-liptc" on the linker command
line and that all parties have moved on to using pkg-config.

Therefore, libiptc.la/so is hereby removed, as are all parts
related to the -Wl,--no-as-needed flag.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
It really helps if I added all changes.. ;-)

 configure.ac                |  5 ---
 libiptc/Makefile.am         |  7 +---
 m4/ax_check_linker_flags.m4 | 78 -------------------------------------
 3 files changed, 2 insertions(+), 88 deletions(-)
 delete mode 100644 m4/ax_check_linker_flags.m4

diff --git a/configure.ac b/configure.ac
index b94512d7..0a2802ff 100644
--- a/configure.ac
+++ b/configure.ac
@@ -73,11 +73,6 @@ AC_ARG_WITH([xt-lock-name], AS_HELP_STRING([--with-xt-lock-name=PATH],
 	[xt_lock_name="$withval"],
 	[xt_lock_name="/run/xtables.lock"])
 
-libiptc_LDFLAGS2="";
-AX_CHECK_LINKER_FLAGS([-Wl,--no-as-needed],
-	[libiptc_LDFLAGS2="-Wl,--no-as-needed"])
-AC_SUBST([libiptc_LDFLAGS2])
-
 AC_MSG_CHECKING([whether $LD knows -Wl,--no-undefined])
 saved_LDFLAGS="$LDFLAGS";
 LDFLAGS="-Wl,--no-undefined";
diff --git a/libiptc/Makefile.am b/libiptc/Makefile.am
index 638295db..464a0696 100644
--- a/libiptc/Makefile.am
+++ b/libiptc/Makefile.am
@@ -5,11 +5,8 @@ AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}
 
 pkgconfig_DATA      = libiptc.pc libip4tc.pc libip6tc.pc
 
-lib_LTLIBRARIES     = libip4tc.la libip6tc.la libiptc.la
-libiptc_la_SOURCES  =
-libiptc_la_LIBADD   = libip4tc.la libip6tc.la
-libiptc_la_LDFLAGS  = -version-info 0:0:0 ${libiptc_LDFLAGS2}
+lib_LTLIBRARIES     = libip4tc.la libip6tc.la
 libip4tc_la_SOURCES = libip4tc.c
 libip4tc_la_LDFLAGS = -version-info 2:0:0
 libip6tc_la_SOURCES = libip6tc.c
-libip6tc_la_LDFLAGS = -version-info 2:0:0 ${libiptc_LDFLAGS2}
+libip6tc_la_LDFLAGS = -version-info 2:0:0
diff --git a/m4/ax_check_linker_flags.m4 b/m4/ax_check_linker_flags.m4
deleted file mode 100644
index ba7bf3cf..00000000
--- a/m4/ax_check_linker_flags.m4
+++ /dev/null
@@ -1,78 +0,0 @@
-#http://git.savannah.gnu.org/gitweb/?p=autoconf-archive.git;a=blob_plain;f=m4/ax_check_linker_flags.m4
-# ===========================================================================
-#   http://www.gnu.org/software/autoconf-archive/ax_check_linker_flags.html
-# ===========================================================================
-#
-# SYNOPSIS
-#
-#   AX_CHECK_LINKER_FLAGS(FLAGS, [ACTION-SUCCESS], [ACTION-FAILURE])
-#
-# DESCRIPTION
-#
-#   Check whether the given linker FLAGS work with the current language's
-#   linker, or whether they give an error.
-#
-#   ACTION-SUCCESS/ACTION-FAILURE are shell commands to execute on
-#   success/failure.
-#
-#   NOTE: Based on AX_CHECK_COMPILER_FLAGS.
-#
-# LICENSE
-#
-#   Copyright (c) 2009 Mike Frysinger <vapier@gentoo.org>
-#   Copyright (c) 2009 Steven G. Johnson <stevenj@alum.mit.edu>
-#   Copyright (c) 2009 Matteo Frigo
-#
-#   This program is free software: you can redistribute it and/or modify it
-#   under the terms of the GNU General Public License as published by the
-#   Free Software Foundation, either version 3 of the License, or (at your
-#   option) any later version.
-#
-#   This program is distributed in the hope that it will be useful, but
-#   WITHOUT ANY WARRANTY; without even the implied warranty of
-#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
-#   Public License for more details.
-#
-#   You should have received a copy of the GNU General Public License along
-#   with this program. If not, see <http://www.gnu.org/licenses/>.
-#
-#   As a special exception, the respective Autoconf Macro's copyright owner
-#   gives unlimited permission to copy, distribute and modify the configure
-#   scripts that are the output of Autoconf when processing the Macro. You
-#   need not follow the terms of the GNU General Public License when using
-#   or distributing such scripts, even though portions of the text of the
-#   Macro appear in them. The GNU General Public License (GPL) does govern
-#   all other use of the material that constitutes the Autoconf Macro.
-#
-#   This special exception to the GPL applies to versions of the Autoconf
-#   Macro released by the Autoconf Archive. When you make and distribute a
-#   modified version of the Autoconf Macro, you may extend this special
-#   exception to the GPL to apply to your modified version as well.
-
-#serial 6
-
-AC_DEFUN([AX_CHECK_LINKER_FLAGS],
-[AC_MSG_CHECKING([whether the linker accepts $1])
-dnl Some hackery here since AC_CACHE_VAL can't handle a non-literal varname:
-AS_LITERAL_IF([$1],
-  [AC_CACHE_VAL(AS_TR_SH(ax_cv_linker_flags_[$1]), [
-      ax_save_FLAGS=$LDFLAGS
-      LDFLAGS="$1"
-      AC_LINK_IFELSE([AC_LANG_PROGRAM()],
-        AS_TR_SH(ax_cv_linker_flags_[$1])=yes,
-        AS_TR_SH(ax_cv_linker_flags_[$1])=no)
-      LDFLAGS=$ax_save_FLAGS])],
-  [ax_save_FLAGS=$LDFLAGS
-   LDFLAGS="$1"
-   AC_LINK_IFELSE([AC_LANG_PROGRAM()],
-     eval AS_TR_SH(ax_cv_linker_flags_[$1])=yes,
-     eval AS_TR_SH(ax_cv_linker_flags_[$1])=no)
-   LDFLAGS=$ax_save_FLAGS])
-eval ax_check_linker_flags=$AS_TR_SH(ax_cv_linker_flags_[$1])
-AC_MSG_RESULT($ax_check_linker_flags)
-if test "x$ax_check_linker_flags" = xyes; then
-	m4_default([$2], :)
-else
-	m4_default([$3], :)
-fi
-])dnl AX_CHECK_LINKER_FLAGS
-- 
2.21.0

