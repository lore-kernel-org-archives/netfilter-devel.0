From: Thomas Jacob <jacob@internet24.de>
Subject: [PATCH] Spelling
Date: Wed,  2 Jul 2008 13:18:02 +0200
Message-ID: <1214997482-19063-2-git-send-email-jacob@internet24.de>
References: <>
 <1214997482-19063-1-git-send-email-jacob@internet24.de>
Cc: Thomas Jacob <jacob@internet24.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:60809 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754119AbYGBLRo (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 07:17:44 -0400
Received: from mailin02.ims-firmen.de ([192.168.1.111])
	by mailout02.ims-firmen.de with esmtp (Exim 4.67)
	(envelope-from <jacob@internet24.de>)
	id 1KE0LH-000727-De
	for netfilter-devel@vger.kernel.org; Wed, 02 Jul 2008 13:17:43 +0200
In-Reply-To: <1214997482-19063-1-git-send-email-jacob@internet24.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Thomas Jacob <jacob@internet24.de>
---
 libiptc/libiptc.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index e0c44c3..c77455a 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -160,8 +160,8 @@ STRUCT_TC_HANDLE
 	struct chain_head **chain_index;   /* array for fast chain list access*/
 	unsigned int        chain_index_sz;/* size of chain index array */
 
-	struct list_head            offsets_create_list; /* array chunks created during data acquisition */
-	struct offsets_lookup_table offsets_search;      /* final offsets search array */
+	struct list_head            offsets_create_list; /* Array chunks created during data acquisition */
+	struct offsets_lookup_table offsets_search;      /* Final offsets search array */
 
 	STRUCT_GETINFO info;
 	STRUCT_GET_ENTRIES *entries;
@@ -705,11 +705,11 @@ iptcc_find_chain_by_offset(TC_HANDLE_T handle, unsigned int offset)
 
 
 /*
- * Fast membership check on order arrays of inclusive intervals
+ * Fast membership check on ordered arrays of inclusive intervals
  *  ( based on http://en.wikipedia.org/wiki/Binary_search )
  *
  * value: value to search for
- * array: array of struct points
+ * array: array of struct pointers
  * left: struct attribute denoting left inclusive range limiter in array items
  * right: struct attribute denoting left inclusive range limiter in array items
  * size: number of items in array
@@ -744,14 +744,14 @@ iptcc_find_chain_by_offset_fast(TC_HANDLE_T handle, unsigned int offset)
 	if (handle->offsets_search.num_entries==0)
 		return NULL;
 
-	/* find the chunk */
+	/* Find the chunk that could contain an appropriate interval */
 	binary_array_range_search(offset, handle->offsets_search.entries, head_offset, foot_offset,
 			handle->offsets_search.num_entries, low, high, mid, result);
 
 	if (result<0)
 		return NULL;
 
-	/* find chain in chunk */
+	/* Find chain in chunk */
 	struct chain_head ** chunk_chains =  handle->offsets_search.entries[result]->entries;
 	unsigned int num_entries = handle->offsets_search.entries[result]->num_entries;
 
-- 
1.5.4.3

