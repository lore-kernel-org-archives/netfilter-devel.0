From: Thomas Jacob <jacob@internet24.de>
Subject: [PATCH 3/3] Coding style
Date: Wed,  2 Jul 2008 20:00:35 +0200
Message-ID: <1215021635-28691-4-git-send-email-jacob@internet24.de>
References: <>
 <1215021635-28691-1-git-send-email-jacob@internet24.de>
 <1215021635-28691-2-git-send-email-jacob@internet24.de>
 <1215021635-28691-3-git-send-email-jacob@internet24.de>
Cc: Thomas Jacob <jacob@internet24.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout02.ims-firmen.de ([213.174.32.97]:55462 "EHLO
	mailout02.ims-firmen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185AbYGBSAP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 14:00:15 -0400
Received: from mailin03.ims-firmen.de ([192.168.1.112])
	by mailout02.ims-firmen.de with esmtp (Exim 4.67)
	(envelope-from <jacob@internet24.de>)
	id 1KE6cn-0002KC-Ve
	for netfilter-devel@vger.kernel.org; Wed, 02 Jul 2008 20:00:13 +0200
In-Reply-To: <1215021635-28691-3-git-send-email-jacob@internet24.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Thomas Jacob <jacob@internet24.de>
---
 libiptc/libiptc.c |  118 ++++++++++++++++++++++++++++++-----------------------
 1 files changed, 67 insertions(+), 51 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index c77455a..b89522b 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -129,21 +129,22 @@ struct chain_head
 /* Max. number of chain_head per offsets chunk */
 #define OFFSETS_CHUNK_SIZE (1024)
 
-struct offsets_create_chunk
+struct offsets_chunk
 {
 	struct list_head list;
 
-	unsigned int head_offset; /* of first entry */
-	unsigned int foot_offset; /* of last entry */
+	unsigned int first_offset; /* head_offset of first entry */
+	unsigned int last_offset; /* foot_offset of last entry */
 
-	unsigned int num_entries; /* #entries */
-	struct chain_head * entries[OFFSETS_CHUNK_SIZE]; /* order by offset */
+	unsigned int num_entries;
+	/* ordered by offset */
+	struct chain_head *entries[OFFSETS_CHUNK_SIZE];
 };
 
 struct offsets_lookup_table
 {
-	unsigned int num_entries; /* #entries */
-	struct offsets_create_chunk ** entries; /* order by offset */
+	unsigned int num_entries;
+	struct offsets_chunk **entries; /* ordered by offset */
 };
 
 STRUCT_TC_HANDLE
@@ -160,8 +161,10 @@ STRUCT_TC_HANDLE
 	struct chain_head **chain_index;   /* array for fast chain list access*/
 	unsigned int        chain_index_sz;/* size of chain index array */
 
-	struct list_head            offsets_create_list; /* Array chunks created during data acquisition */
-	struct offsets_lookup_table offsets_search;      /* Final offsets search array */
+	/* Array chunks created during data acquisition */
+	struct list_head offsets_search_list;
+	/* Final offsets search array */
+	struct offsets_lookup_table offsets_search;
 
 	STRUCT_GETINFO info;
 	STRUCT_GET_ENTRIES *entries;
@@ -597,31 +600,35 @@ static int iptcc_chain_index_delete_chain(struct chain_head *c, TC_HANDLE_T h)
 /* Create offsets lookup table from the chunk list */
 static int iptcc_offsets_index_create(TC_HANDLE_T h)
 {
-	struct offsets_create_chunk * chunk;
-	unsigned int total_number=0;
+	struct offsets_chunk *ch;
+	unsigned int total_number = 0;
+	unsigned int i = 0;
 
 	/* First pass: count non-empty chunks and set their ranges */
-	list_for_each_entry(chunk, &h->offsets_create_list, list) {
-		if (chunk->num_entries>0) {
+	list_for_each_entry(ch, &h->offsets_search_list, list) {
+		if (ch->num_entries > 0) {
 			total_number++;
-			chunk->head_offset = chunk->entries[0]->head_offset;
-			chunk->foot_offset = chunk->entries[chunk->num_entries-1]->foot_offset;
+			ch->first_offset =
+				ch->entries[0]->head_offset;
+			ch->last_offset =
+				ch->entries[ch->num_entries - 1]->foot_offset;
 		}
 	}
 
 	/* No chains->nothing to assign */
-	if (total_number==0)
+	if (total_number == 0)
 		return 1;
 
-	h->offsets_search.entries = malloc(sizeof(struct offsets_create_chunk *)*total_number);
+	h->offsets_search.entries =
+		malloc(sizeof(struct offsets_chunk *)*total_number);
+
 	if (!h->offsets_search.entries)
 		return -ENOMEM;
 
 	/* Second pass: fill chunk table */
-	unsigned int i=0;
-	list_for_each_entry(chunk, &h->offsets_create_list, list)
-		if (chunk->num_entries>0)
-			h->offsets_search.entries[i++] = chunk;
+	list_for_each_entry(ch, &h->offsets_search_list, list)
+		if (ch->num_entries > 0)
+			h->offsets_search.entries[i++] = ch;
 
 	h->offsets_search.num_entries = total_number;
 
@@ -631,17 +638,17 @@ static int iptcc_offsets_index_create(TC_HANDLE_T h)
 /* Free offsets lookup table AND the individual chunks */
 static void iptcc_offsets_index_free(TC_HANDLE_T h)
 {
-	struct offsets_create_chunk * chunk, *tmp;
+	struct offsets_chunk *ch, *tmp;
 
-	if (h->offsets_search.num_entries>0) {
+	if (h->offsets_search.num_entries > 0) {
 		free(h->offsets_search.entries);
-		h->offsets_search.num_entries=0;
+		h->offsets_search.num_entries = 0;
 	}
 
-	list_for_each_entry_safe(chunk, tmp, &h->offsets_create_list, list)
-		free(chunk);
+	list_for_each_entry_safe(ch, tmp, &h->offsets_search_list, list)
+		free(ch);
 
-	INIT_LIST_HEAD(&h->offsets_create_list);
+	INIT_LIST_HEAD(&h->offsets_search_list);
 }
 
 
@@ -721,7 +728,7 @@ iptcc_find_chain_by_offset(TC_HANDLE_T handle, unsigned int offset)
 	low = 0; \
 	high = size; \
 	result = -1; \
-	while(low<=high) \
+	while(low <= high) \
 	{ \
 		mid = (low + high) / 2; \
 		if ((array)[mid]->left > value) \
@@ -740,25 +747,31 @@ static struct chain_head *
 iptcc_find_chain_by_offset_fast(TC_HANDLE_T handle, unsigned int offset)
 {
 	int low,high,mid,result;
+	struct chain_head **chunk_chains;
+	unsigned int num_entries;
 
-	if (handle->offsets_search.num_entries==0)
+	if (handle->offsets_search.num_entries == 0)
 		return NULL;
 
 	/* Find the chunk that could contain an appropriate interval */
-	binary_array_range_search(offset, handle->offsets_search.entries, head_offset, foot_offset,
-			handle->offsets_search.num_entries, low, high, mid, result);
+	binary_array_range_search(offset, handle->offsets_search.entries,
+			first_offset, last_offset,
+			handle->offsets_search.num_entries,
+			low, high, mid, result);
 
-	if (result<0)
+	if (result < 0)
 		return NULL;
 
 	/* Find chain in chunk */
-	struct chain_head ** chunk_chains =  handle->offsets_search.entries[result]->entries;
-	unsigned int num_entries = handle->offsets_search.entries[result]->num_entries;
+	chunk_chains = handle->offsets_search.entries[result]->entries;
+	num_entries = handle->offsets_search.entries[result]->num_entries;
 
-	binary_array_range_search(offset, chunk_chains, head_offset, foot_offset,
-			num_entries, low, high, mid, result);
+	binary_array_range_search(offset, chunk_chains,
+			head_offset, foot_offset,
+			num_entries,
+			low, high, mid, result);
 
-	if (result<0)
+	if (result < 0)
 		return NULL;
 
 	return chunk_chains[result];
@@ -862,11 +875,11 @@ static void iptcc_delete_rule(struct rule_head *r)
 /* Allocate another offsets chunk and append it to list */
 static int __iptcc_p_new_offsets_chunk(TC_HANDLE_T h)
 {
-	struct offsets_create_chunk * new_chunk = malloc(sizeof(struct offsets_create_chunk));
+	struct offsets_chunk *new_chunk = malloc(sizeof(struct offsets_chunk));
 
 	if (new_chunk) {
-		new_chunk->num_entries=0;
-		list_add_tail(&new_chunk->list, &h->offsets_create_list);
+		new_chunk->num_entries = 0;
+		list_add_tail(&new_chunk->list, &h->offsets_search_list);
 		return 1;
 	}
 	return -1;
@@ -878,6 +891,8 @@ static int __iptcc_p_new_offsets_chunk(TC_HANDLE_T h)
  * to be called from specific places within the parser */
 static int __iptcc_p_del_policy(TC_HANDLE_T h, unsigned int num)
 {
+	struct offsets_chunk *occ;
+
 	if (h->chain_iterator_cur) {
 		/* policy rule is last rule */
 		struct rule_head *pr = (struct rule_head *)
@@ -899,17 +914,18 @@ static int __iptcc_p_del_policy(TC_HANDLE_T h, unsigned int num)
 		h->chain_iterator_cur->foot_offset = pr->offset;
 
 		/* do we need a new offsets chunk? */
-		if (list_empty(&h->offsets_create_list) ||
-			list_entry(h->offsets_create_list.prev, struct offsets_create_chunk, list)->num_entries
-			>=OFFSETS_CHUNK_SIZE)
-			if (__iptcc_p_new_offsets_chunk(h)<0)
+		if (list_empty(&h->offsets_search_list) ||
+			list_entry(h->offsets_search_list.prev,
+				struct offsets_chunk, list)->num_entries
+			>= OFFSETS_CHUNK_SIZE)
+			if (__iptcc_p_new_offsets_chunk(h) < 0)
 				return -1;
 
 		/* add next chain to the current offsets chunk */
-		struct offsets_create_chunk * occ =
-			list_entry(h->offsets_create_list.prev, struct offsets_create_chunk, list);
+		occ = list_entry(h->offsets_search_list.prev,
+				struct offsets_chunk, list);
 
-		occ->entries[occ->num_entries++]=h->chain_iterator_cur;
+		occ->entries[occ->num_entries++] = h->chain_iterator_cur;
 
 		/* delete rule from cache */
 		iptcc_delete_rule(pr);
@@ -1012,7 +1028,7 @@ static int cache_add_entry(STRUCT_ENTRY *e,
 		/* This is the ERROR node at the end of the chain */
 		DEBUGP_C("%u:%u: end of table:\n", *num, offset);
 
-		if ((__iptcc_p_del_policy(h, *num))<0) {
+		if ((__iptcc_p_del_policy(h, *num)) < 0) {
 			errno = -ENOMEM;
 			return -1;
 		}
@@ -1035,7 +1051,7 @@ static int cache_add_entry(STRUCT_ENTRY *e,
 		}
 		h->num_chains++; /* New user defined chain */
 
-		if ((__iptcc_p_add_chain(h, c, offset, num))<0) {
+		if ((__iptcc_p_add_chain(h, c, offset, num)) < 0) {
 			errno = -ENOMEM;
 			return -1;
 		}
@@ -1052,7 +1068,7 @@ static int cache_add_entry(STRUCT_ENTRY *e,
 
 		c->hooknum = builtin;
 
-		if ((__iptcc_p_add_chain(h, c, offset, num))<0) {
+		if ((__iptcc_p_add_chain(h, c, offset, num)) < 0) {
 			errno = -ENOMEM;
 			return -1;
 		}
@@ -1376,7 +1392,7 @@ alloc_handle(const char *tablename, unsigned int size, unsigned int num_rules)
 	strcpy(h->entries->name, tablename);
 	h->entries->size = size;
 
-	INIT_LIST_HEAD(&h->offsets_create_list);
+	INIT_LIST_HEAD(&h->offsets_search_list);
 
 	return h;
 
-- 
1.5.4.3

