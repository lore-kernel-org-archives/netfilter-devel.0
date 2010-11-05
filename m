From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/5] build: run autoupdate to replace obsolete constructs
Date: Fri,  5 Nov 2010 18:56:51 +0100
Message-ID: <1288979814-18512-4-git-send-email-jengelh@medozas.de>
References: <1288979814-18512-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:55379 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753332Ab0KER47 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Nov 2010 13:56:59 -0400
In-Reply-To: <1288979814-18512-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index 1d5ac2b..7f9110a 100644
--- a/configure.ac
+++ b/configure.ac
@@ -65,8 +65,7 @@ AC_CHECK_FUNCS(inet_pton)
 dnl Some systems have it, but not IPv6
 if test "$ac_cv_func_inet_pton" = "yes" ; then
 AC_MSG_CHECKING(if inet_pton supports IPv6)
-AC_TRY_RUN(
-   [
+AC_RUN_IFELSE([AC_LANG_SOURCE([[
 #ifdef HAVE_SYS_TYPES_H
 #include <sys/types.h>
 #endif
@@ -87,9 +86,9 @@ int main()
      else
         exit(0);
   }
-  ], [ AC_MSG_RESULT(yes)
+  ]])],[ AC_MSG_RESULT(yes)
        AC_DEFINE_UNQUOTED(HAVE_INET_PTON_IPV6, 1, [Define to 1 if inet_pton supports IPv6.])
-  ], AC_MSG_RESULT(no), AC_MSG_RESULT(no))
+  ],[AC_MSG_RESULT(no)],[AC_MSG_RESULT(no)])
 fi
 
 # Checks for header files.
-- 
1.7.1

