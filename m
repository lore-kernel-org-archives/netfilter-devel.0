From: heitzenberger@astaro.com
Subject: [ULOGD RFC 19/30] llist: add llist_for_each_prev_safe()
Date: Wed, 30 Jan 2008 19:59:06 +0100
Message-ID: <20080130190128.883202561@kruemel.intranet.astaro.de>
References: <20080130185847.693274384@kruemel.intranet.astaro.de>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-82.dex002.intermedia.net ([64.78.20.215]:38024 "EHLO
	dhost002-82.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754676AbYA3TBm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2008 14:01:42 -0500
Content-Disposition: inline; filename=ulogd-common-add-llist_for_each_prev_safe.diff
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Holger Eitzenberger <holger@eitzenberger.org>

Index: ulogd-netfilter/include/ulogd/linuxlist.h
===================================================================
--- ulogd-netfilter.orig/include/ulogd/linuxlist.h
+++ ulogd-netfilter/include/ulogd/linuxlist.h
@@ -245,6 +245,16 @@ static inline void llist_splice_init(str
         	pos = pos->prev, prefetch(pos->prev))
         	
 /**
+ * llist_for_each_prev_safe - iterate over llist backwards safe against removal
+ * @pos:	the type * to use as a loop counter.
+ * @n:		another type * to use as temporary storage
+ * @head:	the head for your llist.
+ */
+#define llist_for_each_prev_safe(pos, n, head) \
+    for (pos = (head)->prev, n = pos->prev; pos != (head); \
+        pos = n, n = pos->prev)
+
+/**
  * llist_for_each_safe	-	iterate over a llist safe against removal of llist entry
  * @pos:	the &struct llist_head to use as a loop counter.
  * @n:		another &struct llist_head to use as temporary storage

-- 
