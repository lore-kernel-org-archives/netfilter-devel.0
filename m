From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 7/8] build: run autoupdate
Date: Tue, 19 Oct 2010 18:12:20 +0200
Message-ID: <1287504742-12922-8-git-send-email-jengelh@medozas.de>
References: <1287504742-12922-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53576 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754720Ab0JSQMe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:12:34 -0400
In-Reply-To: <1287504742-12922-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

AC_CANONICAL_SYSTEM is deprecated in favor of calling one or more of
AC_CANONICAL_{BUILD,HOST,TARGET}. Since configure.ac only uses $target,
only AC_CANONICAL_TARGET is needed.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index b86ec14..0bff332 100644
--- a/configure.ac
+++ b/configure.ac
@@ -1,6 +1,6 @@
 dnl Boilerplate
 AC_INIT([ipset], [5.0], [kadlec@blackhole.kfki.hu])
-AC_CANONICAL_SYSTEM
+AC_CANONICAL_TARGET
 AC_CONFIG_MACRO_DIR([m4])
 AC_CONFIG_HEADER([config.h])
 AM_INIT_AUTOMAKE([-Wall -Werror foreign subdir-objects])
@@ -105,7 +105,7 @@ AM_CONDITIONAL([DISABLE_EXTRA_FLAGS], [test "x$extra_flags" = xno])
 dnl Checks for programs
 AC_PROG_CC
 AM_PROG_CC_C_O
-AC_PROG_LIBTOOL
+LT_INIT
 AC_PROG_INSTALL
 AC_PROG_LN_S
 
-- 
1.7.1

