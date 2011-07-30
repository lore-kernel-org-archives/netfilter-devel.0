From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/3] utils: resolve compiler warning
Date: Sat, 30 Jul 2011 21:11:03 +0200
Message-ID: <1312053064-2153-4-git-send-email-jengelh@medozas.de>
References: <1312053064-2153-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:36867 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752638Ab1G3TLJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Jul 2011 15:11:09 -0400
In-Reply-To: <1312053064-2153-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

iftest.c:36:1: warning: control reaches end of non-void function

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 utils/iftest.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/utils/iftest.c b/utils/iftest.c
index 2bbe3a3..523a17a 100644
--- a/utils/iftest.c
+++ b/utils/iftest.c
@@ -7,7 +7,7 @@
 
 #include <libnfnetlink/libnfnetlink.h>
 
-int main()
+int main(void)
 {
 	int i;
 	struct nlif_handle *h;
@@ -33,4 +33,5 @@ int main()
 	}
 
 	nlif_close(h);
+	return EXIT_SUCCESS;
 }
-- 
1.7.3.4

