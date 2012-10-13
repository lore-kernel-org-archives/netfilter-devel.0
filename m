From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 2/2] build: resolve compile abort on RHEL5 #2
Date: Sat, 13 Oct 2012 14:09:22 +0200
Message-ID: <1350130162-13193-3-git-send-email-jengelh@inai.de>
References: <1350130162-13193-1-git-send-email-jengelh@inai.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:60249 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100Ab2JMMJ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Oct 2012 08:09:26 -0400
In-Reply-To: <1350130162-13193-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libnetfilter_acct.c: In function 'nfacct_nlmsg_build_payload':
libnetfilter_acct.c:422: warning: implicit declaration of function
'htobe64'
libnetfilter_acct.c: In function 'nfacct_nlmsg_parse_payload':
libnetfilter_acct.c:477: warning: implicit declaration of function
'be64toh'

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 src/internal.h |   12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/src/internal.h b/src/internal.h
index 3a88d1a..2106401 100644
--- a/src/internal.h
+++ b/src/internal.h
@@ -9,4 +9,16 @@
 #	define EXPORT_SYMBOL
 #endif
 
+#include <endian.h>
+#if !defined(htobe64)
+#	include <byteswap.h>
+#	if __BYTE_ORDER == __LITTLE_ENDIAN
+#		define htobe64(x) __bswap_64(x)
+#		define betoh64(x) __bswap_64(x)
+#	else
+#		define htobe64(x) (x)
+#		define betoh64(x) (x)
+#	endif
+#endif
+
 #endif
-- 
1.7.10.4

