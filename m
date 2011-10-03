From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 2/3] build: resolve compiler warnings
Date: Mon,  3 Oct 2011 22:10:08 +0200
Message-ID: <1317672610-29855-3-git-send-email-jengelh@medozas.de>
References: <1317672610-29855-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: sam@synack.fr
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:48175 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231Ab1JCUKo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:10:44 -0400
In-Reply-To: <1317672610-29855-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

utils.c: In function 'get_taskname':
utils.c:62:2: warning: implicit declaration of function
	'read' [-Wimplicit-function-declaration]
utils.c:63:2: warning: implicit declaration of function
	'close' [-Wimplicit-function-declaration]
snet.c: In function 'snet_get':
snet.c:607:1: warning: control reaches end of non-void
	function [-Wreturn-type]
snet_lib.c: In function 'snet_destroy':
snet_lib.c:63:1: warning: control reaches end of non-void
	function [-Wreturn-type]
---
 snet.c     |    1 +
 snet_lib.c |    1 +
 utils.c    |    1 +
 3 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/snet.c b/snet.c
index 3d94846..ff5267a 100644
--- a/snet.c
+++ b/snet.c
@@ -604,6 +604,7 @@ int snet_get(struct nl_handle *nl_handle)
 		return -1;
 	}
 	snet_dbg(fout, 1, "exiting\n");
+	return 0;
 }
 
 int snet_verdict_delay(struct nl_handle *nl_handle, int family,
diff --git a/snet_lib.c b/snet_lib.c
index 0a2390e..97fd44c 100644
--- a/snet_lib.c
+++ b/snet_lib.c
@@ -60,4 +60,5 @@ int snet_destroy(struct snet_lib *sl)
 
 	nl_close(sl->snet_sock);
 	nl_handle_destroy(sl->snet_sock);
+	return 0;
 }
diff --git a/utils.c b/utils.c
index 51b029a..87572f6 100644
--- a/utils.c
+++ b/utils.c
@@ -2,6 +2,7 @@
 #include <utils.h>
 #include <snet.h>
 #include <fcntl.h>
+#include <unistd.h>
 
 const char *snet_syscall_name(const __u8 syscall)
 {
-- 
1.7.3.4

