From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: [PATCH] arptables: remove dead dynamic hooks code
Date: Tue, 11 Nov 2014 10:20:22 -0300
Message-ID: <1415712022-31842-1-git-send-email-gustavo@zacarias.com.ar>
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.zacarias.com.ar ([62.210.192.172]:45933 "EHLO
	www.zacarias.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193AbaKKNUd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Nov 2014 08:20:33 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The code is unused and #if'ed away, it also breaks pure-static
builds because of the dlfcn.h include.

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
---
 arptables.c              |  1 -
 libarptc/libarptc_incl.c | 15 ---------------
 2 files changed, 16 deletions(-)

diff --git a/arptables.c b/arptables.c
index 64ac3aa..845e226 100644
--- a/arptables.c
+++ b/arptables.c
@@ -35,7 +35,6 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <inttypes.h>
-#include <dlfcn.h>
 #include <ctype.h>
 #include <stdarg.h>
 #include <limits.h>
diff --git a/libarptc/libarptc_incl.c b/libarptc/libarptc_incl.c
index 9c1aeac..1d2e8b7 100644
--- a/libarptc/libarptc_incl.c
+++ b/libarptc/libarptc_incl.c
@@ -257,22 +257,7 @@ TC_INIT(const char *tablename)
 	    == NULL)
 		return NULL;
 
-/* Too hard --RR */
-#if 0
-	sprintf(pathname, "%s/%s", ARPT_LIB_DIR, info.name);
-	dynlib = dlopen(pathname, RTLD_NOW);
-	if (!dynlib) {
-		errno = ENOENT;
-		return NULL;
-	}
-	h->hooknames = dlsym(dynlib, "hooknames");
-	if (!h->hooknames) {
-		errno = ENOENT;
-		return NULL;
-	}
-#else
 	h->hooknames = hooknames;
-#endif
 
 	/* Initialize current state */
 	h->info = info;
-- 
2.0.4

