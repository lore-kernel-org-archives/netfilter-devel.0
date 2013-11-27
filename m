From: Gustavo Zacarias <gustavo@zacarias.com.ar>
Subject: [PATCH iptables] iptables/ip(6)tables-save.c: remove dlfcn.h include
Date: Wed, 27 Nov 2013 10:21:12 -0300
Message-ID: <1385558472-17365-1-git-send-email-gustavo@zacarias.com.ar>
Cc: Gustavo Zacarias <gustavo@zacarias.com.ar>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from loknar.toptech.com.ar ([78.46.79.162]:43740 "EHLO
	loknar.toptech.com.ar" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab3K0NVZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Nov 2013 08:21:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

It's not required and breaks on static-only uClibc builds which don't
have the header file.

Signed-off-by: Gustavo Zacarias <gustavo@zacarias.com.ar>
---
 iptables/ip6tables-save.c | 4 ----
 iptables/iptables-save.c  | 4 ----
 2 files changed, 8 deletions(-)

diff --git a/iptables/ip6tables-save.c b/iptables/ip6tables-save.c
index d819b30..a86a64a 100644
--- a/iptables/ip6tables-save.c
+++ b/iptables/ip6tables-save.c
@@ -18,10 +18,6 @@
 #include "ip6tables.h"
 #include "ip6tables-multi.h"
 
-#ifndef NO_SHARED_LIBS
-#include <dlfcn.h>
-#endif
-
 static int show_counters = 0;
 
 static const struct option options[] = {
diff --git a/iptables/iptables-save.c b/iptables/iptables-save.c
index e599fce..2999c7f 100644
--- a/iptables/iptables-save.c
+++ b/iptables/iptables-save.c
@@ -17,10 +17,6 @@
 #include "iptables.h"
 #include "iptables-multi.h"
 
-#ifndef NO_SHARED_LIBS
-#include <dlfcn.h>
-#endif
-
 static int show_counters = 0;
 
 static const struct option options[] = {
-- 
1.8.3.2

