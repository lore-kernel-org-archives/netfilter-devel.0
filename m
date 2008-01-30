From: heitzenberger@astaro.com
Subject: [ULOGD RFC 26/30] llist: turn poisoning off by default
Date: Wed, 30 Jan 2008 19:59:13 +0100
Message-ID: <20080130190129.911200389@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-91.dex002.intermedia.net ([64.78.21.115]:23297 "EHLO
	dhost002-91.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755285AbYA3TBo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:44 -0500
Content-Disposition: inline; filename=ulogd-llist-poison-debug-only.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/include/ulogd/linuxlist.h
===================================================================
--- ulogd-netfilter.orig/include/ulogd/linuxlist.h
+++ ulogd-netfilter/include/ulogd/linuxlist.h
@@ -117,8 +117,10 @@ static inline void __llist_del(struct ll
 static inline void llist_del(struct llist_head *entry)
 {
 	__llist_del(entry->prev, entry->next);
+#ifdef ULOGD_LLIST_DEBUG
 	entry->next = LLIST_POISON1;
 	entry->prev = LLIST_POISON2;
+#endif /* ULOGD_LLIST_DEBUG */
 }
 
 /**

-- 
