From: Felix Janda <felix.janda@posteo.de>
Subject: [ebtables PATCH 2/2] ethernetdb.h: Remove C++ specific compiler hint
 macro _THROW
Date: Sat, 16 May 2015 12:31:58 +0200
Message-ID: <20150516102328.GJ14201@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:43799 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750810AbbEPKco (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 May 2015 06:32:44 -0400
Received: from dovecot03.posteo.de (unknown [185.67.36.28])
	by mx02.posteo.de (Postfix) with ESMTPS id C4D4925A3DFD
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 12:32:43 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot03.posteo.de (Postfix) with ESMTPSA id 3lpjbv3QJPz5vN4
	for <netfilter-devel@vger.kernel.org>; Sat, 16 May 2015 12:32:43 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fixes compilation with musl libc

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/ethernetdb.h | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/ethernetdb.h b/include/ethernetdb.h
index 46d8bfd..1683abe 100644
--- a/include/ethernetdb.h
+++ b/include/ethernetdb.h
@@ -38,21 +38,20 @@ struct ethertypeent {
 
 /* Open ethertype data base files and mark them as staying open even
    after a later search if STAY_OPEN is non-zero.  */
-extern void setethertypeent(int __stay_open) __THROW;
+extern void setethertypeent(int __stay_open);
 
 /* Close ethertype data base files and clear `stay open' flag.  */
-extern void endethertypeent(void) __THROW;
+extern void endethertypeent(void);
 
 /* Get next entry from ethertype data base file.  Open data base if
    necessary.  */
-extern struct ethertypeent *getethertypeent(void) __THROW;
+extern struct ethertypeent *getethertypeent(void);
 
 /* Return entry from ethertype data base for network with NAME.  */
-extern struct ethertypeent *getethertypebyname(__const char *__name)
-    __THROW;
+extern struct ethertypeent *getethertypebyname(__const char *__name);
 
 /* Return entry from ethertype data base which number is PROTO.  */
-extern struct ethertypeent *getethertypebynumber(int __ethertype) __THROW;
+extern struct ethertypeent *getethertypebynumber(int __ethertype);
 
 
 #endif				/* ethernetdb.h */
-- 
2.3.6
