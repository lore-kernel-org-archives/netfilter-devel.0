From: Tobias Klauser <tklauser@distanz.ch>
Subject: [PATCH nft] build: add missing backslash to list of CFLAGS
Date: Fri, 13 Jan 2017 15:24:09 +0100
Message-ID: <20170113142409.15705-1-tklauser@distanz.ch>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.zhinst.com ([212.126.164.98]:54446 "EHLO mail.zhinst.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751640AbdAMOYL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 13 Jan 2017 09:24:11 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Due to a missing backslash in the AM_CFLAGS list some warning flags do
not get added to the generated default CLFAGS. Add the missing backslash
to include them as well.

Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
---
 src/Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/Makefile.am b/src/Makefile.am
index 65cb4b403754..c6586f5f03c2 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -16,7 +16,7 @@ AM_CFLAGS = -Wall								\
 	    -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations	\
 	    -Wdeclaration-after-statement -Wsign-compare -Winit-self		\
 	    -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute	\
-	    -Wcast-align -Wundef -Wbad-function-cast
+	    -Wcast-align -Wundef -Wbad-function-cast				\
 	    -Waggregate-return -Wunused -Wwrite-strings
 
 
-- 
2.11.0


