From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/5] utils: resolve compiler warning
Date: Fri, 31 Dec 2010 00:40:08 +0100
Message-ID: <1293752411-12923-4-git-send-email-jengelh@medozas.de>
References: <1293752411-12923-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50207 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752197Ab0L3XkR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Dec 2010 18:40:17 -0500
In-Reply-To: <1293752411-12923-1-git-send-email-jengelh@medozas.de>
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
1.7.1

