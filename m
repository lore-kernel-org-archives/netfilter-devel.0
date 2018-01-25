From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH nft] configure: Remove macro AC_CHECK_FUNCS
Date: Thu, 25 Jan 2018 20:48:53 +0530
Message-ID: <20180125151853.4740-2-rvarsha016@gmail.com>
References: <20180125151853.4740-1-rvarsha016@gmail.com>
Cc: Varsha Rao <rvarsha016@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:46063 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750980AbeAYPTl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jan 2018 10:19:41 -0500
Received: by mail-pg0-f67.google.com with SMTP id m136so5234441pga.12
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Jan 2018 07:19:41 -0800 (PST)
In-Reply-To: <20180125151853.4740-1-rvarsha016@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Functions memmove, strchr, strerror and strdup are defined in string.h
header file. Also, strtoull is defined in stdlib.h header file. These
header files are checked by AC_CHECK_HEADERS macro. AC_CHECK_FUNCS macro
is not required, so remove it.

Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 configure.ac | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/configure.ac b/configure.ac
index 71d30d8..48af28c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -128,9 +128,6 @@ AC_CHECK_HEADERS([arpa/inet.h fcntl.h inttypes.h limits.h malloc.h \
 		  stddef.h stdint.h stdlib.h string.h unistd.h], ,
 		 AC_MSG_ERROR([Header file not found]))
 
-# Checks for library functions.
-AC_CHECK_FUNCS([memmove memset strchr strdup strerror strtoull])
-
 AC_CONFIG_FILES([					\
 		Makefile				\
 		src/Makefile				\
-- 
2.14.3

