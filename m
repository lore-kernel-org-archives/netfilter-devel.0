From: heitzenberger@astaro.com
Subject: [ULOGD 13/15] llist: turn poisoning off by default
Date: Sat, 02 Feb 2008 21:48:39 +0100
Message-ID: <20080202205109.028902335@astaro.com>
References: <20080202204826.267107164@astaro.com>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-1.dex002.intermedia.net ([64.78.21.6]:39951 "EHLO
	dhost002-1.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933664AbYBBUvZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:51:25 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
Content-Disposition: inline; filename=ulogd-llist-poison-debug-only.diff

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
