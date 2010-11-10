From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/5] include: use C++ headers in C++ mode
Date: Thu, 11 Nov 2010 00:08:01 +0100
Message-ID: <1289430485-16467-3-git-send-email-jengelh@medozas.de>
References: <1289430485-16467-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:56307 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756496Ab0KJXII (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 10 Nov 2010 18:08:08 -0500
In-Reply-To: <1289430485-16467-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/libmnl/libmnl.h |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 7094af2..37c502a 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -1,13 +1,16 @@
 #ifndef _LIBMNL_H_
 #define _LIBMNL_H_
 
-#include <stdio.h>
-#include <stdint.h>
+#ifdef __cplusplus
+#	include <cstdio>
+#	include <cstdint>
+#else
+#	include <stdbool.h> /* not in C++ */
+#	include <stdio.h>
+#	include <stdint.h>
+#endif
 #include <sys/socket.h> /* for sa_family_t */
 #include <linux/netlink.h>
-#ifndef __cplusplus
-#	include <stdbool.h>
-#endif
 
 #ifdef __cplusplus
 extern "C" {
-- 
1.7.1

