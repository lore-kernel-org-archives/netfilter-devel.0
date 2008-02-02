From: heitzenberger@astaro.com
Subject: [ULOGD 09/15] llist: add llist_for_each_prev_safe()
Date: Sat, 02 Feb 2008 21:48:35 +0100
Message-ID: <20080202205108.452364267@astaro.com>
References: <20080202204826.267107164@astaro.com>
Cc: holger@eitzenberger.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dhost002-47.dex002.intermedia.net ([64.78.21.143]:21876 "EHLO
	dhost002-47.dex002.intermedia.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933685AbYBBUv3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 15:51:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
Content-Disposition: inline; filename=ulogd-common-add-llist_for_each_prev_safe.diff

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
