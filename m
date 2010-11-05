From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] build: run autoupdate to replace obsolete constructs
Date: Fri,  5 Nov 2010 18:37:31 +0100
Message-ID: <1288978652-15892-4-git-send-email-jengelh@medozas.de>
References: <1288978652-15892-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:42078 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754062Ab0KERhi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:37:38 -0400
In-Reply-To: <1288978652-15892-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index d0145bd..b194ea8 100644
--- a/configure.ac
+++ b/configure.ac
@@ -28,8 +28,7 @@ AC_CHECK_FUNCS(inet_ntop)
 dnl Again, some systems have it, but not IPv6
 if test "$ac_cv_func_inet_ntop" = "yes" ; then
 AC_MSG_CHECKING(if inet_ntop supports IPv6)
-AC_TRY_RUN(
-   [
+AC_RUN_IFELSE([AC_LANG_SOURCE([[
 #ifdef HAVE_SYS_TYPES_H
 #include <sys/types.h>
 #endif
@@ -52,9 +51,9 @@ int main()
      else
         exit(0);
   }
-  ], [ AC_MSG_RESULT(yes)
+  ]])],[ AC_MSG_RESULT(yes)
        AC_DEFINE_UNQUOTED(HAVE_INET_NTOP_IPV6, 1, [Define to 1 if inet_ntop supports IPv6.])
-     ], AC_MSG_RESULT(no),AC_MSG_RESULT(no))
+     ],[AC_MSG_RESULT(no)],[AC_MSG_RESULT(no)])
 fi
 
 if test ! -z "$libdir"; then
-- 
1.7.1

