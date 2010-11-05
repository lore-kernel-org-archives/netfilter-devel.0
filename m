From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 8/9] build: no need for error message in PKG_CHECK_MODULES
Date: Fri,  5 Nov 2010 19:36:22 +0100
Message-ID: <1288982184-23584-9-git-send-email-jengelh@medozas.de>
References: <1288982184-23584-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44414 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754691Ab0KESgf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:36:35 -0400
In-Reply-To: <1288982184-23584-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

PKG_CHECK_MODULES already produces its own (and more verbose) messsage
when a module cannot be found.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |   13 +++----------
 1 files changed, 3 insertions(+), 10 deletions(-)

diff --git a/configure.ac b/configure.ac
index fec034e..75372fc 100644
--- a/configure.ac
+++ b/configure.ac
@@ -36,16 +36,9 @@ regular_CFLAGS="-Wall -Wextra -Wno-unused-parameter"
 AC_SUBST([regular_CFLAGS])
 
 dnl Check for the right nfnetlink version
-LIBNFNETLINK_REQUIRED=0.0.39
-LIBNETFILTER_CONNTRACK_REQUIRED=0.0.95
-LIBNETFILTER_LOG_REQUIRED=1.0.0
-
-PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,, AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
-
-PKG_CHECK_MODULES(LIBNETFILTER_CONNTRACK, libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED,, AC_MSG_ERROR(Cannot find libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED))
-
-PKG_CHECK_MODULES(LIBNETFILTER_LOG, libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED,, AC_MSG_ERROR(Cannot find libnetfilter_log >= $LIBNETFILTER_LOG_REQUIRED))
-
+PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 0.0.39])
+PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 0.0.95])
+PKG_CHECK_MODULES([LIBNETFILTER_LOG], [libnetfilter_log >= 1.0.0])
 
 CT_CHECK_POSTGRES_DB()
 AM_CONDITIONAL(HAVE_PGSQL, test "x$PQLIBPATH" != "x")
-- 
1.7.1

