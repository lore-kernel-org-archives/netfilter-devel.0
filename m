From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: [PATCH] arptables: disable dlfcn.h include
Date: Sat,  8 Nov 2014 10:19:39 -0300
Message-ID: <1415452779-11721-1-git-send-email-gustavo@zacarias.com.ar>
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from www.zacarias.com.ar ([62.210.192.172]:37434 "EHLO
	www.zacarias.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753622AbaKHNbU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Nov 2014 08:31:20 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The relevant code is disabled in libarptc_incl.c so it's not required
and breaks the ability to build it in a pure-static toolchain.

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
---
 arptables.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arptables.c b/arptables.c
index 64ac3aa..fe270bc 100644
--- a/arptables.c
+++ b/arptables.c
@@ -35,7 +35,9 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <inttypes.h>
+#if 0
 #include <dlfcn.h>
+#endif
 #include <ctype.h>
 #include <stdarg.h>
 #include <limits.h>
-- 
2.0.4

