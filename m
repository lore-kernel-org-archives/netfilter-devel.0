From: Natanael Copa <ncopa@alpinelinux.org>
Subject: [PATCH libnetfilter_log] Add include needed for integer type definition.
Date: Wed, 29 Apr 2015 10:50:58 +0200
Message-ID: <1430297458-20973-1-git-send-email-ncopa@alpinelinux.org>
Cc: Natanael Copa <ncopa@alpinelinux.org>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.alpinelinux.org ([74.117.189.114]:55804 "EHLO
	mail.alpinelinux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422789AbbD2I60 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 29 Apr 2015 04:58:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The sys/types.h is needed for u_int*_t types.

Signed-off-by: Natanael Copa <ncopa@alpinelinux.org>
---
 include/libnetfilter_log/libipulog.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/libnetfilter_log/libipulog.h b/include/libnetfilter_log/libipulog.h
index 8a4ae2a..1093bdd 100644
--- a/include/libnetfilter_log/libipulog.h
+++ b/include/libnetfilter_log/libipulog.h
@@ -4,6 +4,7 @@
 #include <errno.h>
 #include <unistd.h>
 #include <fcntl.h>
+#include <sys/types.h>
 
 /* FIXME: glibc sucks */
 #ifndef MSG_TRUNC 
-- 
2.3.6

