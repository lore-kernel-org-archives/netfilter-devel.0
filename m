From: Sven Wegener <sven.wegener@stealer.net>
Subject: [PATCH] ipset/iptreemap: Fix memory leak
Date: Thu, 18 Sep 2008 15:14:42 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.0809181513580.22510@titan.stealer.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.stealer.net ([88.198.224.204]:55905 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752773AbYIRNPE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Sep 2008 09:15:04 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We leak the strdup()ed memory for each element we parse.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 ipset_iptreemap.c |    3 +++
 1 file changed, 3 insertions(+)

--- ipset.orig/ipset_iptreemap.c
+++ ipset/ipset_iptreemap.c
@@ -17,6 +17,7 @@
 
 #include <limits.h>
 #include <stdio.h>
+#include <stdlib.h>
 #include <string.h>
 #include <sys/socket.h>
 #include <netinet/in.h>
@@ -88,6 +89,8 @@
 		}
 	}
 
+	free(saved);
+
 	return 1;
 }
 
