From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 1/3] build: remove unused checks
Date: Mon, 13 Jan 2014 10:07:48 +0100
Message-ID: <1389604070-12068-2-git-send-email-jengelh@inai.de>
References: <1389604070-12068-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares08.inai.de ([46.4.84.70]:56796 "EHLO ares08.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751259AbaAMJHw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:07:52 -0500
In-Reply-To: <1389604070-12068-1-git-send-email-jengelh@inai.de>
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
1.8.4

