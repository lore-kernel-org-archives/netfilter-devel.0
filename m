From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH 4/4] libiptc: Use DEBUGP macro from trace.h
Date: Thu, 25 Jul 2013 13:23:49 +0400
Message-ID: <1374744229-5427-5-git-send-email-a.perevalov@samsung.com>
References: <1374744229-5427-1-git-send-email-a.perevalov@samsung.com>
Cc: pablo@netfilter.org, netfilter@vger.kernel.org,
	Alexey Perevalov <a.perevalov@samsung.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
In-reply-to: <1374744229-5427-1-git-send-email-a.perevalov@samsung.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Signed-off-by: Alexey Perevalov <a.perevalov@samsung.com>
---
 libiptc/libiptc.c |   90 ++++++++++++++++++++++-------------------------------
 1 file changed, 37 insertions(+), 53 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index f0f7815..bff89c3 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -38,23 +38,7 @@
 #include <libiptc/xtcshared.h>
 
 #include "linux_list.h"
-
-//#define IPTC_DEBUG2 1
-
-#ifdef IPTC_DEBUG2
-#include <fcntl.h>
-#define DEBUGP(x, args...)	fprintf(stderr, "%s: " x, __FUNCTION__, ## args)
-#define DEBUGP_C(x, args...)	fprintf(stderr, x, ## args)
-#else
-#define DEBUGP(x, args...)
-#define DEBUGP_C(x, args...)
-#endif
-
-#ifdef DEBUG
-#define debug(x, args...)	fprintf(stderr, x, ## args)
-#else
-#define debug(x, args...)
-#endif
+#include "trace.h"
 
 static void *iptc_fn = NULL;
 
@@ -338,7 +322,7 @@ __iptcc_bsearch_chain_index(const char *name, unsigned int offset,
 
 	/* Check for empty array, e.g. no user defined chains */
 	if (handle->chain_index_sz == 0) {
-		debug("WARNING: handle->chain_index_sz == 0\n");
+		DEBUGP("WARNING: handle->chain_index_sz == 0\n");
 		return list_pos;
 	}
 
@@ -346,7 +330,7 @@ __iptcc_bsearch_chain_index(const char *name, unsigned int offset,
 	end = handle->chain_index_sz;
 	pos = end / 2;
 
-	debug("bsearch Find chain:%s (pos:%d end:%d) (offset:%d)\n",
+	DEBUGP("bsearch Find chain:%s (pos:%d end:%d) (offset:%d)\n",
 	      name, pos, end, offset);
 
 	/* Loop */
@@ -356,7 +340,7 @@ __iptcc_bsearch_chain_index(const char *name, unsigned int offset,
 		return &handle->chains; /* Be safe, return orig start pos */
 	}
 
-	debug("bsearch Index[%d] name:%s ",
+	DEBUGP("bsearch Index[%d] name:%s ",
 	      pos, handle->chain_index[pos]->name);
 
 	/* Support for different compare functions */
@@ -365,7 +349,7 @@ __iptcc_bsearch_chain_index(const char *name, unsigned int offset,
 		res = strcmp(name, handle->chain_index[pos]->name);
 		break;
 	case BSEARCH_OFFSET:
-		debug("head_offset:[%d] foot_offset:[%d] ",
+		DEBUGP("head_offset:[%d] foot_offset:[%d] ",
 		      handle->chain_index[pos]->head_offset,
 		      handle->chain_index[pos]->foot_offset);
 		res = offset - handle->chain_index[pos]->head_offset;
@@ -376,14 +360,14 @@ __iptcc_bsearch_chain_index(const char *name, unsigned int offset,
 		abort();
 		break;
 	}
-	debug("res:%d ", res);
+	DEBUGP("res:%d ", res);
 
 
 	list_pos = &handle->chain_index[pos]->list;
 	*idx = pos;
 
 	if (res == 0) { /* Found element, by direct hit */
-		debug("[found] Direct hit pos:%d end:%d\n", pos, end);
+		DEBUGP("[found] Direct hit pos:%d end:%d\n", pos, end);
 		return list_pos;
 	} else if (res < 0) { /* Too far, jump back */
 		end = pos;
@@ -391,16 +375,16 @@ __iptcc_bsearch_chain_index(const char *name, unsigned int offset,
 
 		/* Exit case: First element of array */
 		if (end == 0) {
-			debug("[found] Reached first array elem (end%d)\n",end);
+			DEBUGP("[found] Reached first array elem (end%d)\n",end);
 			return list_pos;
 		}
-		debug("jump back to pos:%d (end:%d)\n", pos, end);
+		DEBUGP("jump back to pos:%d (end:%d)\n", pos, end);
 		goto loop;
 	} else { /* res > 0; Not far enough, jump forward */
 
 		/* Exit case: Last element of array */
 		if (pos == handle->chain_index_sz-1) {
-			debug("[found] Last array elem (end:%d)\n", end);
+			DEBUGP("[found] Last array elem (end:%d)\n", end);
 			return list_pos;
 		}
 
@@ -415,12 +399,12 @@ __iptcc_bsearch_chain_index(const char *name, unsigned int offset,
 		}
 
 		if (res < 0) {
-			debug("[found] closest list (end:%d)\n", end);
+			DEBUGP("[found] closest list (end:%d)\n", end);
 			return list_pos;
 		}
 
 		pos = (pos+end)/2;
-		debug("jump forward to pos:%d (end:%d)\n", pos, end);
+		DEBUGP("jump forward to pos:%d (end:%d)\n", pos, end);
 		goto loop;
 	}
 }
@@ -496,7 +480,7 @@ static int iptcc_chain_index_alloc(struct xtc_handle *h)
                       (h->num_chains % list_length ? 1 : 0);
 	array_mem   = sizeof(h->chain_index) * array_elems;
 
-	debug("Alloc Chain index, elems:%d mem:%d bytes\n",
+	DEBUGP("Alloc Chain index, elems:%d mem:%d bytes\n",
 	      array_elems, array_mem);
 
 	h->chain_index = malloc(array_mem);
@@ -541,9 +525,9 @@ static int iptcc_chain_index_build(struct xtc_handle *h)
 	struct chain_head *c;
 
 	/* Build up the chain index array here */
-	debug("Building chain index\n");
+	DEBUGP("Building chain index\n");
 
-	debug("Number of user defined chains:%d bucket_sz:%d array_sz:%d\n",
+	DEBUGP("Number of user defined chains:%d bucket_sz:%d array_sz:%d\n",
 		h->num_chains, list_length, h->chain_index_sz);
 
 	if (h->chain_index_sz == 0)
@@ -563,21 +547,21 @@ static int iptcc_chain_index_build(struct xtc_handle *h)
 				break;
 
 			if ((chains % list_length)== 0) {
-				debug("\nIndex[%d] Chains:", cindex);
+				DEBUGP("\nIndex[%d] Chains:", cindex);
 				h->chain_index[cindex] = c;
 			}
 			chains++;
 		}
-		debug("%s, ", c->name);
+		DEBUGP("%s, ", c->name);
 	}
-	debug("\n");
+	DEBUGP("\n");
 
 	return 1;
 }
 
 static int iptcc_chain_index_rebuild(struct xtc_handle *h)
 {
-	debug("REBUILD chain index array\n");
+	DEBUGP("REBUILD chain index array\n");
 	iptcc_chain_index_free(h);
 	if ((iptcc_chain_index_alloc(h)) < 0)
 		return -ENOMEM;
@@ -605,7 +589,7 @@ static int iptcc_chain_index_delete_chain(struct chain_head *c, struct xtc_handl
 
 	index_ptr = iptcc_bsearch_chain_index(c->name, &idx, h);
 
-	debug("Del chain[%s] c->list:%p index_ptr:%p\n",
+	DEBUGP("Del chain[%s] c->list:%p index_ptr:%p\n",
 	      c->name, &c->list, index_ptr);
 
 	/* Save the next pointer */
@@ -625,7 +609,7 @@ static int iptcc_chain_index_delete_chain(struct chain_head *c, struct xtc_handl
 			return iptcc_chain_index_rebuild(h);
 		} else {
 			/* Avoiding rebuild */
-			debug("Update cindex[%d] with next ptr name:[%s]\n",
+			DEBUGP("Update cindex[%d] with next ptr name:[%s]\n",
 			      idx, c2->name);
 			h->chain_index[idx]=c2;
 			return 0;
@@ -693,13 +677,13 @@ iptcc_find_chain_by_offset(struct xtc_handle *handle, unsigned int offset)
 	 * chains, but this function is only used for finding jump
 	 * targets, and a buildin chain is not a valid jump target */
 
-	debug("Offset:[%u] starting search at index:[%u]\n", offset, i);
+	DEBUGP("Offset:[%u] starting search at index:[%u]\n", offset, i);
 //	list_for_each(pos, &handle->chains) {
 	list_for_each(pos, list_start_pos->prev) {
 		struct chain_head *c = list_entry(pos, struct chain_head, list);
-		debug(".");
+		DEBUGP(".");
 		if (offset >= c->head_offset && offset <= c->foot_offset) {
-			debug("Offset search found chain:[%s]\n", c->name);
+			DEBUGP("Offset search found chain:[%s]\n", c->name);
 			return c;
 		}
 	}
@@ -743,13 +727,13 @@ iptcc_find_label(const char *name, struct xtc_handle *handle)
 		struct chain_head *test_c, *tmp_c;
 		test_pos = iptcc_linearly_search_chain_index(name, handle);
 		if (list_start_pos != test_pos) {
-			debug("BUG in chain_index search\n");
+			DEBUGP("BUG in chain_index search\n");
 			test_c=list_entry(test_pos,      struct chain_head,list);
 			tmp_c =list_entry(list_start_pos,struct chain_head,list);
-			debug("Verify search found:\n");
-			debug(" Chain:%s\n", test_c->name);
-			debug("BSearch found:\n");
-			debug(" Chain:%s\n", tmp_c->name);
+			DEBUGP("Verify search found:\n");
+			DEBUGP(" Chain:%s\n", test_c->name);
+			DEBUGP("BSearch found:\n");
+			DEBUGP(" Chain:%s\n", tmp_c->name);
 			exit(42);
 		}
 	}
@@ -763,24 +747,24 @@ iptcc_find_label(const char *name, struct xtc_handle *handle)
 	list_for_each(pos, list_start_pos->prev) {
 		struct chain_head *c = list_entry(pos, struct chain_head, list);
 		res = strcmp(c->name, name);
-		debug("List search name:%s == %s res:%d\n", name, c->name, res);
+		DEBUGP("List search name:%s == %s res:%d\n", name, c->name, res);
 		if (res==0)
 			return c;
 
 		/* We can stop earlier as we know list is sorted */
 		if (res>0 && !iptcc_is_builtin(c)) { /* Walked too far*/
-			debug(" Not in list, walked too far, sorted list\n");
+			DEBUGP(" Not in list, walked too far, sorted list\n");
 			return NULL;
 		}
 
 		/* Stop on wrap around, if list head is reached */
 		if (pos == &handle->chains) {
-			debug("Stop, list head reached\n");
+			DEBUGP("Stop, list head reached\n");
 			return NULL;
 		}
 	}
 
-	debug("List search NOT found name:%s\n", name);
+	DEBUGP("List search NOT found name:%s\n", name);
 	return NULL;
 }
 
@@ -853,7 +837,7 @@ static void iptc_insert_chain(struct xtc_handle *h, struct chain_head *c)
 	if (i==0 && strcmp(c->name, h->chain_index[0]->name) <= 0) {
 		h->chain_index[0] = c; /* Update chain index head */
 		list_start_pos = h->chains.next;
-		debug("Update chain_index[0] with %s\n", c->name);
+		DEBUGP("Update chain_index[0] with %s\n", c->name);
 	}
 
 	/* Handel if bsearch bails out early */
@@ -871,7 +855,7 @@ static void iptc_insert_chain(struct xtc_handle *h, struct chain_head *c)
 
 			/* Stop if list head is reached */
 			if (&tmp->list == &h->chains) {
-				debug("Insert, list head reached add to tail\n");
+				DEBUGP("Insert, list head reached add to tail\n");
 				break;
 			}
 		}
@@ -916,7 +900,7 @@ static void __iptcc_p_add_chain(struct xtc_handle *h, struct chain_head *c,
 			 */
 			h->sorted_offsets = 0;
 
-			debug("NOTICE: chain:[%s] was NOT sorted(ctail:%s)\n",
+			DEBUGP("NOTICE: chain:[%s] was NOT sorted(ctail:%s)\n",
 			      c->name, ctail->name);
 		}
 	}
@@ -2275,7 +2259,7 @@ TC_CREATE_CHAIN(const IPT_CHAINLABEL chain, struct xtc_handle *handle)
 	capacity = handle->chain_index_sz * CHAIN_INDEX_BUCKET_LEN;
 	exceeded = handle->num_chains - capacity;
 	if (exceeded > CHAIN_INDEX_INSERT_MAX) {
-		debug("Capacity(%d) exceeded(%d) rebuild (chains:%d)\n",
+		DEBUGP("Capacity(%d) exceeded(%d) rebuild (chains:%d)\n",
 		      capacity, exceeded, handle->num_chains);
 		iptcc_chain_index_rebuild(handle);
 	}
-- 
1.7.9.5

