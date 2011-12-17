From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/4] m4: resolve autoconf-2.68 warnings
Date: Sat, 17 Dec 2011 16:37:09 +0100
Message-ID: <1324136231-25643-4-git-send-email-jengelh@medozas.de>
References: <1324136231-25643-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:59770 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752352Ab1LQPhQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 17 Dec 2011 10:37:16 -0500
In-Reply-To: <1324136231-25643-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Newer autoconf desires proper full quoting and use of AC_LANG_SOURCE.
Import new m4 file from git://dev.medozas.de/m4_jengelh.

m4/gcc4_visibility.m4:4: CHECK_GCC_FVISIBILITY is expanded from...
configure.ac:15: the top level
configure.ac:15: warning: AC_LANG_CONFTEST: no AC_LANG_SOURCE call
detected in body
---
 m4/gcc4_visibility.m4 |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/m4/gcc4_visibility.m4 b/m4/gcc4_visibility.m4
index 84959f3..214d3f3 100644
--- a/m4/gcc4_visibility.m4
+++ b/m4/gcc4_visibility.m4
@@ -7,13 +7,13 @@ AC_DEFUN([CHECK_GCC_FVISIBILITY], [
 	CFLAGS="$saved_CFLAGS -fvisibility=hidden"
 	AC_CACHE_CHECK([whether compiler accepts -fvisibility=hidden],
 	  [ac_cv_fvisibility_hidden], AC_COMPILE_IFELSE(
-		AC_LANG_PROGRAM([], []),
+		[AC_LANG_SOURCE()],
 		[ac_cv_fvisibility_hidden=yes],
 		[ac_cv_fvisibility_hidden=no]
 	))
 	if test "$ac_cv_fvisibility_hidden" = "yes"; then
 		AC_DEFINE([HAVE_VISIBILITY_HIDDEN], [1],
-		  [True if compiler supports -fvisibility=hidden])
+			[True if compiler supports -fvisibility=hidden])
 		AC_SUBST([GCC_FVISIBILITY_HIDDEN], [-fvisibility=hidden])
 	fi
 	CFLAGS="$saved_CFLAGS"
-- 
1.7.3.4

