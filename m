From: Felix Janda <felix.janda@posteo.de>
Subject: [PATCH iptables 1/4] Sync with ethernetdb.h from ebtables
Date: Tue, 16 Jun 2015 21:23:38 +0200
Message-ID: <20150616192338.GC3247@euler>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:45611 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754739AbbFPTYB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Jun 2015 15:24:01 -0400
Received: from dovecot04.posteo.de (unknown [185.67.36.27])
	by mx02.posteo.de (Postfix) with ESMTPS id 8D3FE22B47EB
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2015 21:24:00 +0200 (CEST)
Received: from mail.posteo.de (localhost [127.0.0.1])
	by dovecot04.posteo.de (Postfix) with ESMTPSA id 3m9zwc3FplzFpWG
	for <netfilter-devel@vger.kernel.org>; Tue, 16 Jun 2015 21:24:00 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Felix Janda <felix.janda@posteo.de>
---
 include/ebtables/ethernetdb.h | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/include/ebtables/ethernetdb.h b/include/ebtables/ethernetdb.h
index 46d8bfd..1683abe 100644
--- a/include/ebtables/ethernetdb.h
+++ b/include/ebtables/ethernetdb.h
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
