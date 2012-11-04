From: Eric Leblond <eric@regit.org>
Subject: [libnfacct PATCH] Add include needed for integer types definition.
Date: Sun,  4 Nov 2012 10:54:12 +0100
Message-ID: <1352022852-29382-2-git-send-email-eric@regit.org>
References: <1352022711.11805.8.camel@tourtet>
 <1352022852-29382-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:56950 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab2KDJyh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 4 Nov 2012 04:54:37 -0500
In-Reply-To: <1352022852-29382-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

---
 include/libnetfilter_acct/libnetfilter_acct.h |    1 +
 1 file changed, 1 insertion(+)

diff --git a/include/libnetfilter_acct/libnetfilter_acct.h b/include/libnetfilter_acct/libnetfilter_acct.h
index a326c3c..48fe8f4 100644
--- a/include/libnetfilter_acct/libnetfilter_acct.h
+++ b/include/libnetfilter_acct/libnetfilter_acct.h
@@ -2,6 +2,7 @@
 #define _LIBNETFILTER_ACCT_H_
 
 #include <sys/types.h>
+#include <inttypes.h>
 #include <linux/netfilter/nfnetlink_acct.h>
 
 struct nfacct;
-- 
1.7.10.4

