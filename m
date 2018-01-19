From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft] configure: Remove AC_HEADER_STDBOOL, AC_C_ and AC_TYPE_ macros
Date: Fri, 19 Jan 2018 08:30:17 +0530
Message-ID: <20180119030017.12432-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:39273 "EHLO
        mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752855AbeASDBs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jan 2018 22:01:48 -0500
Received: by mail-pf0-f194.google.com with SMTP id e11so323504pff.6
        for <netfilter-devel@vger.kernel.org>; Thu, 18 Jan 2018 19:01:48 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following macros check if particular C types in specific header file
exists, these header files defines them and are already included in the
source code. So, remove them.

AC_HEADER_STDBOOL - stdbool.h
AC_TYPE_INT and AC_TYPE_UINT - stdint.h or inttypes.h
AC_TYPE_OFF_T and AC_TYPE_UID_T - sys/types.h
AC_TYPE_SIZE_T - stddef.h, string.h, stdlib.h or stdio.h

Remove AC_C_CONST and AC_C_INLINE as gcc supports inline and const
keywords.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 configure.ac | 16 ----------------
 1 file changed, 16 deletions(-)

diff --git a/configure.ac b/configure.ac
index 6ed3edc..13b5574 100644
--- a/configure.ac
+++ b/configure.ac
@@ -120,22 +120,6 @@ AC_CHECK_HEADERS([arpa/inet.h fcntl.h inttypes.h limits.h malloc.h \
 		  stddef.h stdint.h stdlib.h string.h unistd.h], ,
 		 AC_MSG_ERROR([Header file not found]))
 
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
 # Checks for library functions.
 AC_CHECK_FUNCS([memmove memset strchr strdup strerror strtoull])
 
-- 
2.14.3

