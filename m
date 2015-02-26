From: Markus Teich <markus.teich@stusta.mhn.de>
Subject: [PATCH] header: use sysconf() instead of getpagesize()
Date: Thu, 26 Feb 2015 14:38:03 +0100
Message-ID: <1424957883-12444-1-git-send-email-markus.teich@stusta.mhn.de>
References: <20150226130837.GA3655@salvia>
Cc: "Pablo Neira Ayuso" <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from hermod.fs.tum.de ([129.187.202.12]:40179 "EHLO hermod.fs.tum.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076AbbBZNhF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 Feb 2015 08:37:05 -0500
In-Reply-To: <20150226130837.GA3655@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The sysconf(_SC_PAGESIZE) call is more portable since it does not need
_BSD_SOURCE defined.
---
 include/libmnl/libmnl.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/libmnl/libmnl.h b/include/libmnl/libmnl.h
index 0de6678..3a589bc 100644
--- a/include/libmnl/libmnl.h
+++ b/include/libmnl/libmnl.h
@@ -17,7 +17,7 @@ extern "C" {
  */
 
 #define MNL_SOCKET_AUTOPID	0
-#define MNL_SOCKET_BUFFER_SIZE (getpagesize() < 8192L ? getpagesize() : 8192L)
+#define MNL_SOCKET_BUFFER_SIZE (sysconf(_SC_PAGESIZE) < 8192L ? sysconf(_SC_PAGESIZE) : 8192L)
 
 struct mnl_socket;
 
-- 
2.0.5

