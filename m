From: Jesper Dangaard Brouer <hawk@comx.dk>
Subject: [PATCH 1/3] iptables: Fix chain rename bug in libiptc.
Date: Mon, 23 Mar 2009 13:55:14 +0100
Message-ID: <20090323125514.959.87191.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:59525 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750711AbZCWNXU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:23:20 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Chain renaming (TC_RENAME_CHAIN) can result in an unsorted
chain list.  That breaks the requirement of the binary search
done in iptcc_bsearch_chain_index().

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
---

 libiptc/libiptc.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 544a5b2..86cfab4 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -2404,8 +2404,15 @@ int TC_RENAME_CHAIN(const IPT_CHAINLABEL oldname,
 		return 0;
 	}
 
+	/* This only unlinks "c" from the list, thus no free(c) */
+	iptcc_chain_index_delete_chain(c, handle);
+
+	/* Change the name of the chain */
 	strncpy(c->name, newname, sizeof(IPT_CHAINLABEL));
-	
+
+	/* Insert sorted into to list again */
+	iptc_insert_chain(handle, c);
+
 	set_changed(handle);
 
 	return 1;

