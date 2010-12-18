From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/3] libipulog: rebuild required header file inclusion
Date: Sat, 18 Dec 2010 21:17:30 +0100
Message-ID: <1292703453-16324-2-git-send-email-jengelh@medozas.de>
References: <1292703453-16324-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47412 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156Ab0LRURf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 15:17:35 -0500
In-Reply-To: <1292703453-16324-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use C++ headers for C++ and throw out #includes that are not needed
for the header file.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/libnetfilter_log/libipulog.h |    9 ++++++---
 src/libipulog_compat.c               |    1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/libnetfilter_log/libipulog.h b/include/libnetfilter_log/libipulog.h
index 0278862..bb6736a 100644
--- a/include/libnetfilter_log/libipulog.h
+++ b/include/libnetfilter_log/libipulog.h
@@ -1,9 +1,12 @@
 #ifndef _LIBIPULOG_H
 #define _LIBIPULOG_H
 
-#include <errno.h>
-#include <unistd.h>
-#include <fcntl.h>
+#ifdef __cplusplus
+#	include <cstdint>
+#else
+#	include <stdint.h>
+#endif
+#include <sys/types.h>
 
 /* FIXME: glibc sucks */
 #ifndef MSG_TRUNC 
diff --git a/src/libipulog_compat.c b/src/libipulog_compat.c
index 9d93bcd..8c90cdb 100644
--- a/src/libipulog_compat.c
+++ b/src/libipulog_compat.c
@@ -1,3 +1,4 @@
+#include <errno.h>
 #include <stdlib.h>
 #include <stdio.h>
 #include <string.h>
-- 
1.7.1

