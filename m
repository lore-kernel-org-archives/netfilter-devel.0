From: Jonh Wendell <jonh.wendell@gmail.com>
Subject: [PATCH] arptables: build an libarptc.a archive
Date: Thu, 21 Feb 2013 20:45:36 -0300
Message-ID: <1361490336-4676-1-git-send-email-jonh.wendell@gmail.com>
Cc: Jonh Wendell <jonh.wendell@oiwifi.com.br>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ye0-f169.google.com ([209.85.213.169]:64965 "EHLO
	mail-ye0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754618Ab3BUXrg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 21 Feb 2013 18:47:36 -0500
Received: by mail-ye0-f169.google.com with SMTP id l13so20355yen.14
        for <netfilter-devel@vger.kernel.org>; Thu, 21 Feb 2013 15:47:35 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jonh Wendell <jonh.wendell@oiwifi.com.br>

this allows programs to statically link against libarptc.

Signed-off-by: Jonh Wendell <jonh.wendell@oiwifi.com.br>
---
 userspace/arptables/Makefile | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/userspace/arptables/Makefile b/userspace/arptables/Makefile
index 9a7bea4..38158d9 100644
--- a/userspace/arptables/Makefile
+++ b/userspace/arptables/Makefile
@@ -19,7 +19,7 @@ endif
 
 include extensions/Makefile
 
-all: arptables
+all: arptables libarptc/libarptc.a
 
 arptables.o: arptables.c
 	$(CC) $(CFLAGS) -c -o $@ $<
@@ -30,6 +30,9 @@ arptables-standalone.o: arptables-standalone.c
 libarptc/libarptc.o: libarptc/libarptc.c libarptc/libarptc_incl.c
 	$(CC) $(CFLAGS) -c -o $@ $<
 
+libarptc/libarptc.a: libarptc/libarptc.o
+	$(AR) rcs $@ $<
+
 arptables: arptables-standalone.o arptables.o libarptc/libarptc.o $(EXT_OBJS)
 	$(CC) $(CFLAGS) $(LDFLAGS) -o $@ $^
 
@@ -62,7 +65,7 @@ clean:
 	rm -f arptables
 	rm -f *.o *~
 	rm -f extensions/*.o extensions/*~
-	rm -f libarptc/*.o libarptc/*~
+	rm -f libarptc/*.o libarptc/*~ libarptc/*.a
 	rm -f include/*~ include/libarptc/*~
 
 DIR:=arptables-v$(ARPTABLES_VERSION)
-- 
1.8.1.2

