From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/3] build: remove unused checks
Date: Sun, 20 Oct 2013 16:48:09 +0200
Message-ID: <1382280491-9921-2-git-send-email-jengelh@inai.de>
References: <1382280491-9921-1-git-send-email-jengelh@inai.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:39128 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751110Ab3JTOsP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Oct 2013 10:48:15 -0400
In-Reply-To: <1382280491-9921-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The result of these checks was never evaluated, so remove them.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 configure.ac | 31 -------------------------------
 1 file changed, 31 deletions(-)

diff --git a/configure.ac b/configure.ac
index 811d7e2..b850451 100644
--- a/configure.ac
+++ b/configure.ac
@@ -21,7 +21,6 @@ AC_SUBST([CONFIG_DEBUG])
 
 # Checks for programs.
 AC_PROG_CC
-AC_PROG_MKDIR_P
 AC_PROG_INSTALL
 
 AC_CHECK_PROG(CONFIG_MAN, docbook2x-man, y, n)
@@ -61,36 +60,6 @@ AC_CHECK_LIB([gmp], [__gmpz_init], ,
 AC_CHECK_LIB([readline], [readline], ,
 	     AC_MSG_ERROR([No suitable version of libreadline found]))
 
-# Checks for header files.
-AC_HEADER_STDC
-AC_HEADER_ASSERT
-AC_CHECK_HEADERS([arpa/inet.h fcntl.h inttypes.h libintl.h limits.h malloc.h \
-		  netdb.h netinet/in.h netinet/ip.h netinet/ip6.h \
-		  netinet/tcp.h netinet/udp.h netinet/ip_icmp.h \
-		  stddef.h stdint.h stdlib.h string.h unistd.h], ,
-		 AC_MSG_ERROR([Header file not found]))
-
-# Checks for typedefs, structures, and compiler characteristics.
-AC_HEADER_STDBOOL
-AC_C_CONST
-AC_C_INLINE
-AC_TYPE_OFF_T
-AC_TYPE_SIZE_T
-AC_TYPE_UID_T
-AC_TYPE_INT8_T
-AC_TYPE_INT16_T
-AC_TYPE_INT32_T
-AC_TYPE_INT64_T
-AC_TYPE_UINT8_T
-AC_TYPE_UINT16_T
-AC_TYPE_UINT32_T
-AC_TYPE_UINT64_T
-
-# Checks for library functions.
-AC_FUNC_MALLOC
-AC_FUNC_REALLOC
-AC_CHECK_FUNCS([memmove memset strchr strdup strerror strtoull])
-
 AC_CONFIG_FILES([Makefile Makefile.defs Makefile.rules])
 AC_CONFIG_FILES([src/Makefile doc/Makefile files/Makefile])
 AC_OUTPUT
-- 
1.8.2

