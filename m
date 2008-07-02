From: Jesper Dangaard Brouer <jdb@comx.dk>
Subject: [PATCH 2/2] Fix scalability performance issue during initial
	ruleset parsing.
Date: Wed, 02 Jul 2008 21:57:27 +0200
Message-ID: <1215028647.9467.6.camel@localhost.localdomain>
Reply-To: jdb@comx.dk
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
To: Netfilter Developers <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:33559 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754231AbYGBT53 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jul 2008 15:57:29 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


 Finding jump chains is slow O(Chain*Rules).

The problem:
 is that the chain list is searched lineary for each rule with a jump
 target. The problem lies in the "second pass" (of function
 parse_table) where the userchain jump targets are found. For each
 rule "R" with a IPTCC_R_JUMP target, function
 iptcc_find_chain_by_offset() searches through the chains "C" in the
 chain list (worst-case hitting the last one).

The solution:
 in this patch is to speed up iptcc_find_chain_by_offset() by using
 binary search. Reducing complexity from O(C) to O(log C).

Implementation:
 Its possible to use the same bsearch algorithm and data structure
 (chain_index), as used for chain name searching.

How is that possible:
 One has to realize that the chains are both sorted by name and
 offsets, this is because the chains are already sorted in the ruleset
 from the kernel.

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
---
 libiptc/libiptc.c |  123 +++++++++++++++++++++++++++++++++++++++++----
 1 files changed, 112 insertions(+), 11 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index ec5317b..b68e48c 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -140,10 +140,20 @@ STRUCT_TC_HANDLE
 	struct chain_head **chain_index;   /* array for fast chain list access*/
 	unsigned int        chain_index_sz;/* size of chain index array */
 
+	int sorted_offsets; /* if chains are received sorted from kernel,
+			     * then the offsets are also sorted. Says if its
+			     * possible to bsearch offsets using chain_index.
+			     */
+
 	STRUCT_GETINFO info;
 	STRUCT_GET_ENTRIES *entries;
 };
 
+enum bsearch_type {
+	BSEARCH_NAME,	/* Binary search after chain name */
+	BSEARCH_OFFSET,	/* Binary search based on offset */
+};
+
 /* allocate a new chain head for the cache */
 static struct chain_head *iptcc_alloc_chain_head(const char *name, int hooknum)
 {
@@ -306,15 +316,21 @@ iptcb_ent_is_hook_entry(STRUCT_ENTRY *e, TC_HANDLE_T h)
 
 static inline unsigned int iptcc_is_builtin(struct chain_head *c);
 
-
 /* Use binary search in the chain index array, to find a chain_head
  * pointer closest to the place of the searched name element.
  *
  * Notes that, binary search (obviously) requires that the chain list
  * is sorted by name.
+ *
+ * The not so obvious: The chain index array, is actually both sorted
+ * by name and offset, at the same time!.  This is only true because,
+ * chain are stored sorted in the kernel (as we pushed it in sorted).
+ *
  */
 static struct list_head *
-iptcc_bsearch_chain_index(const char *name, unsigned int *idx, TC_HANDLE_T handle)
+__iptcc_bsearch_chain_index(const char *name, unsigned int offset,
+			    unsigned int *idx, TC_HANDLE_T handle,
+			    enum bsearch_type type)
 {
 	unsigned int pos, end;
 	int res;
@@ -332,7 +348,8 @@ iptcc_bsearch_chain_index(const char *name, unsigned int *idx, TC_HANDLE_T handl
 	end = handle->chain_index_sz;
 	pos = end / 2;
 
-	debug("bsearch Find chain:%s (pos:%d end:%d)\n", name, pos, end);
+	debug("bsearch Find chain:%s (pos:%d end:%d) (offset:%d)\n",
+	      name, pos, end, offset);
 
 	/* Loop */
  loop:
@@ -341,13 +358,32 @@ iptcc_bsearch_chain_index(const char *name, unsigned int *idx, TC_HANDLE_T handl
 		return &handle->chains; /* Be safe, return orig start pos */
 	}
 
-	res = strcmp(name, handle->chain_index[pos]->name);
+	debug("bsearch Index[%d] name:%s ",
+	      pos, handle->chain_index[pos]->name);
+
+	/* Support for different compare functions */
+	switch (type) {
+	case BSEARCH_NAME:
+		res = strcmp(name, handle->chain_index[pos]->name);
+		break;
+	case BSEARCH_OFFSET:
+		debug("head_offset:[%d] foot_offset:[%d] ",
+		      handle->chain_index[pos]->head_offset,
+		      handle->chain_index[pos]->foot_offset);
+		res = offset - handle->chain_index[pos]->head_offset;
+		break;
+	default:
+		fprintf(stderr, "ERROR: %d not a valid bsearch type\n",
+			type);
+		abort();
+		break;
+	}
+	debug("res:%d ", res);
+
+
 	list_pos = &handle->chain_index[pos]->list;
 	*idx = pos;
 
-	debug("bsearch Index[%d] name:%s res:%d ",
-	      pos, handle->chain_index[pos]->name, res);
-
 	if (res == 0) { /* Found element, by direct hit */
 		debug("[found] Direct hit pos:%d end:%d\n", pos, end);
 		return list_pos;
@@ -371,7 +407,15 @@ iptcc_bsearch_chain_index(const char *name, unsigned int *idx, TC_HANDLE_T handl
 		}
 
 		/* Exit case: Next index less, thus elem in this list section */
-		res = strcmp(name, handle->chain_index[pos+1]->name);
+		switch (type) {
+		case BSEARCH_NAME:
+			res = strcmp(name, handle->chain_index[pos+1]->name);
+			break;
+		case BSEARCH_OFFSET:
+			res = offset - handle->chain_index[pos+1]->head_offset;
+			break;
+		}
+
 		if (res < 0) {
 			debug("[found] closest list (end:%d)\n", end);
 			return list_pos;
@@ -385,6 +429,34 @@ iptcc_bsearch_chain_index(const char *name, unsigned int *idx, TC_HANDLE_T handl
 	return list_pos;
 }
 
+/* Wrapper for string chain name based bsearch */
+static struct list_head *
+iptcc_bsearch_chain_index(const char *name, unsigned int *idx,
+			  TC_HANDLE_T handle)
+{
+	return __iptcc_bsearch_chain_index(name, 0, idx, handle, BSEARCH_NAME);
+}
+
+
+/* Wrapper for offset chain based bsearch */
+static struct list_head *
+iptcc_bsearch_chain_offset(unsigned int offset, unsigned int *idx,
+			  TC_HANDLE_T handle)
+{
+	struct list_head *pos;
+
+	/* If chains were not received sorted from kernel, then the
+	 * offset bsearch is not possible.
+	 */
+	if (!handle->sorted_offsets)
+		pos = handle->chains.next;
+	else
+		pos = __iptcc_bsearch_chain_index(NULL, offset, idx, handle,
+						  BSEARCH_OFFSET);
+	return pos;
+}
+
+
 #ifdef DEBUG
 /* Trivial linear search of chain index. Function used for verifying
    the output of bsearch function */
@@ -612,14 +684,28 @@ static struct chain_head *
 iptcc_find_chain_by_offset(TC_HANDLE_T handle, unsigned int offset)
 {
 	struct list_head *pos;
+	struct list_head *list_start_pos;
+	unsigned int i;
 
 	if (list_empty(&handle->chains))
 		return NULL;
 
-	list_for_each(pos, &handle->chains) {
+	/* Find a smart place to start the search */
+  	list_start_pos = iptcc_bsearch_chain_offset(offset, &i, handle);
+
+	/* Note that iptcc_bsearch_chain_offset() skips builtin
+	 * chains, but this function is only used for finding jump
+	 * targets, and a buildin chain is not a valid jump target */
+
+	debug("Offset:[%u] starting search at index:[%u]\n", offset, i);
+//	list_for_each(pos, &handle->chains) {
+	list_for_each(pos, list_start_pos->prev) {
 		struct chain_head *c = list_entry(pos, struct chain_head, list);
-		if (offset >= c->head_offset && offset <= c->foot_offset)
+		debug(".");
+		if (offset >= c->head_offset && offset <= c->foot_offset) {
+			debug("Offset search found chain:[%s]\n", c->name);
 			return c;
+		}
 	}
 
 	return NULL;
@@ -819,11 +905,22 @@ static void __iptcc_p_add_chain(TC_HANDLE_T h, struct chain_head *c,
 		list_add_tail(&c->list, &h->chains);
 	else {
 		ctail = list_entry(tail, struct chain_head, list);
+
 		if (strcmp(c->name, ctail->name) > 0 ||
 		    iptcc_is_builtin(ctail))
 			list_add_tail(&c->list, &h->chains);/* Already sorted*/
-		else
+		else {
 			iptc_insert_chain(h, c);/* Was not sorted */
+
+			/* Notice, if chains were not received sorted
+			 * from kernel, then an offset bsearch is no
+			 * longer valid.
+			 */
+			h->sorted_offsets = 0;
+
+			debug("NOTICE: chain:[%s] was NOT sorted(ctail:%s)\n",
+			      c->name, ctail->name);
+		}
 	}
 
 	h->chain_iterator_cur = c;
@@ -947,6 +1044,10 @@ static int parse_table(TC_HANDLE_T h)
 	unsigned int num = 0;
 	struct chain_head *c;
 
+	/* Assume that chains offsets are sorted, this verified during
+	   parsing of ruleset (in __iptcc_p_add_chain())*/
+	h->sorted_offsets = 1;
+
 	/* First pass: over ruleset blob */
 	ENTRY_ITERATE(h->entries->entrytable, h->entries->size,
 			cache_add_entry, h, &prev, &num);
-- 
1.5.3


