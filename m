From: Eric Leblond <eric@regit.org>
Subject: [libnflog PATCH] Add include needed for integer type definition.
Date: Sun,  4 Nov 2012 10:54:11 +0100
Message-ID: <1352022852-29382-1-git-send-email-eric@regit.org>
References: <1352022711.11805.8.camel@tourtet>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:56949 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862Ab2KDJyf (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Nov 2012 04:54:35 -0500
In-Reply-To: <1352022711.11805.8.camel@tourtet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 include/libnetfilter_log/libnetfilter_log.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/libnetfilter_log/libnetfilter_log.h b/include/libnetfilter_log/libnetfilter_log.h
index 6b0d3b0..a1331de 100644
--- a/include/libnetfilter_log/libnetfilter_log.h
+++ b/include/libnetfilter_log/libnetfilter_log.h
@@ -9,6 +9,7 @@
 #ifndef __LIBNETFILTER_LOG_H
 #define __LIBNETFILTER_LOG_H
 
+#include <sys/types.h>
 #include <libnetfilter_log/linux_nfnetlink_log.h>
 
 struct nflog_handle;
-- 
1.7.10.4

