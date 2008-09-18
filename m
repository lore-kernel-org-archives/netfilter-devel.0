From: Sven Wegener <sven.wegener@stealer.net>
Subject: [PATCH] ipset: Fix order of libs in Makefile
Date: Thu, 18 Sep 2008 15:17:53 +0200 (CEST)
Message-ID: <alpine.LNX.2.00.0809181516530.22510@titan.stealer.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.stealer.net ([88.198.224.204]:55936 "EHLO
	smtp1.stealer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753265AbYIRNSA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Sep 2008 09:18:00 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Libraries need to come after the objects, for --as-needed to work.

Signed-off-by: Sven Wegener <sven.wegener@stealer.net>
---
 Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- ipset.orig/Makefile
+++ ipset/Makefile
@@ -74,7 +74,7 @@
 	$(CC) $(CFLAGS) -DIPSET_VERSION=\"$(IPSET_VERSION)\" -DIPSET_LIB_DIR=\"$(IPSET_LIB_DIR)\" -c -o $@ $<
 
 ipset: ipset.o
-	$(CC) $(CFLAGS) -ldl -rdynamic -o $@ $^
+	$(CC) $(CFLAGS) -rdynamic -o $@ $^ -ldl
 
 #Pooltypes
 ipset_%.o: ipset_%.c
