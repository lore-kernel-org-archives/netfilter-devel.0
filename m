From: Jesper Dangaard Brouer <hawk@comx.dk>
Subject: [PATCH 2/3] iptables: Fix whitespaces and typos.
Date: Mon, 23 Mar 2009 13:55:19 +0100
Message-ID: <20090323125519.959.9342.stgit@localhost.localdomain>
References: <20090323125514.959.87191.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:59523 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752108AbZCWNXU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Mar 2009 09:23:20 -0400
In-Reply-To: <20090323125514.959.87191.stgit@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Cleanup whitespaces while going through the code.

Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
---

 libiptc/libiptc.c |   82 +++++++++++++++++++++++++++--------------------------
 1 files changed, 41 insertions(+), 41 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index 86cfab4..59cbf55 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -9,7 +9,7 @@
  */
 
 /* (C) 1999 Paul ``Rusty'' Russell - Placed under the GNU GPL (See
- * COPYING for details). 
+ * COPYING for details).
  * (C) 2000-2004 by the Netfilter Core Team <coreteam@netfilter.org>
  *
  * 2003-Jun-20: Harald Welte <laforge@netfilter.org>:
@@ -17,9 +17,9 @@
  * 2003-Jun-23: Harald Welte <laforge@netfilter.org>:
  * 	- performance optimization, sponsored by Astaro AG (http://www.astaro.com/)
  * 	  don't rebuild the chain cache after every operation, instead fix it
- * 	  up after a ruleset change.  
+ * 	  up after a ruleset change.
  * 2004-Aug-18: Harald Welte <laforge@netfilter.org>:
- * 	- futher performance work: total reimplementation of libiptc.
+ * 	- further performance work: total reimplementation of libiptc.
  * 	- libiptc now has a real internal (linked-list) represntation of the
  * 	  ruleset and a parser/compiler from/to this internal representation
  * 	- again sponsored by Astaro AG (http://www.astaro.com/)
@@ -130,7 +130,7 @@ STRUCT_TC_HANDLE
 	int changed;			 /* Have changes been made? */
 
 	struct list_head chains;
-	
+
 	struct chain_head *chain_iterator_cur;
 	struct rule_head *rule_iterator_cur;
 
@@ -817,14 +817,14 @@ static int __iptcc_p_del_policy(struct xtc_handle *h, unsigned int num)
 			h->chain_iterator_cur->rules.prev;
 
 		/* save verdict */
-		h->chain_iterator_cur->verdict = 
+		h->chain_iterator_cur->verdict =
 			*(int *)GET_TARGET(pr->entry)->data;
 
 		/* save counter and counter_map information */
-		h->chain_iterator_cur->counter_map.maptype = 
+		h->chain_iterator_cur->counter_map.maptype =
 						COUNTER_MAP_NORMAL_MAP;
 		h->chain_iterator_cur->counter_map.mappos = num-1;
-		memcpy(&h->chain_iterator_cur->counters, &pr->entry->counters, 
+		memcpy(&h->chain_iterator_cur->counters, &pr->entry->counters,
 			sizeof(h->chain_iterator_cur->counters));
 
 		/* foot_offset points to verdict rule */
@@ -926,8 +926,8 @@ static void __iptcc_p_add_chain(struct xtc_handle *h, struct chain_head *c,
 }
 
 /* main parser function: add an entry from the blob to the cache */
-static int cache_add_entry(STRUCT_ENTRY *e, 
-			   struct xtc_handle *h, 
+static int cache_add_entry(STRUCT_ENTRY *e,
+			   struct xtc_handle *h,
 			   STRUCT_ENTRY **prev,
 			   unsigned int *num)
 {
@@ -951,9 +951,9 @@ static int cache_add_entry(STRUCT_ENTRY *e,
 	 * target, or a hook entry point */
 
 	if (strcmp(GET_TARGET(e)->u.user.name, ERROR_TARGET) == 0) {
-		struct chain_head *c = 
+		struct chain_head *c =
 			iptcc_alloc_chain_head((const char *)GET_TARGET(e)->data, 0);
-		DEBUGP_C("%u:%u:new userdefined chain %s: %p\n", *num, offset, 
+		DEBUGP_C("%u:%u:new userdefined chain %s: %p\n", *num, offset,
 			(char *)c->name, c);
 		if (!c) {
 			errno = -ENOMEM;
@@ -965,9 +965,9 @@ static int cache_add_entry(STRUCT_ENTRY *e,
 
 	} else if ((builtin = iptcb_ent_is_hook_entry(e, h)) != 0) {
 		struct chain_head *c =
-			iptcc_alloc_chain_head((char *)hooknames[builtin-1], 
+			iptcc_alloc_chain_head((char *)hooknames[builtin-1],
 						builtin);
-		DEBUGP_C("%u:%u new builtin chain: %p (rules=%p)\n", 
+		DEBUGP_C("%u:%u new builtin chain: %p (rules=%p)\n",
 			*num, offset, c, &c->rules);
 		if (!c) {
 			errno = -ENOMEM;
@@ -985,7 +985,7 @@ static int cache_add_entry(STRUCT_ENTRY *e,
 		struct rule_head *r;
 new_rule:
 
-		if (!(r = iptcc_alloc_rule(h->chain_iterator_cur, 
+		if (!(r = iptcc_alloc_rule(h->chain_iterator_cur,
 					   e->next_offset))) {
 			errno = ENOMEM;
 			return -1;
@@ -1125,7 +1125,7 @@ static inline int iptcc_compile_rule (struct xtc_handle *h, STRUCT_REPLACE *repl
 		t = (STRUCT_STANDARD_TARGET *)GET_TARGET(r->entry);
 		t->verdict = r->offset + r->size;
 	}
-	
+
 	/* copy entry from cache to blob */
 	memcpy((char *)repl->entries+r->offset, r->entry, r->size);
 
@@ -1147,11 +1147,11 @@ static int iptcc_compile_chain(struct xtc_handle *h, STRUCT_REPLACE *repl, struc
 		head->e.target_offset = sizeof(STRUCT_ENTRY);
 		head->e.next_offset = IPTCB_CHAIN_START_SIZE;
 		strcpy(head->name.t.u.user.name, ERROR_TARGET);
-		head->name.t.u.target_size = 
+		head->name.t.u.target_size =
 				ALIGN(sizeof(struct ipt_error_target));
 		strcpy(head->name.error, c->name);
 	} else {
-		repl->hook_entry[c->hooknum-1] = c->head_offset;	
+		repl->hook_entry[c->hooknum-1] = c->head_offset;
 		repl->underflow[c->hooknum-1] = c->foot_offset;
 	}
 
@@ -1191,7 +1191,7 @@ static int iptcc_compile_chain_offsets(struct xtc_handle *h, struct chain_head *
 
 	if (!iptcc_is_builtin(c))  {
 		/* Chain has header */
-		*offset += sizeof(STRUCT_ENTRY) 
+		*offset += sizeof(STRUCT_ENTRY)
 			     + ALIGN(sizeof(struct ipt_error_target));
 		(*num)++;
 	}
@@ -1204,7 +1204,7 @@ static int iptcc_compile_chain_offsets(struct xtc_handle *h, struct chain_head *
 		(*num)++;
 	}
 
-	DEBUGP("%s; chain_foot %u, offset=%u, index=%u\n", c->name, *num, 
+	DEBUGP("%s; chain_foot %u, offset=%u, index=%u\n", c->name, *num,
 		*offset, *num);
 	c->foot_offset = *offset;
 	c->foot_index = *num;
@@ -1255,7 +1255,7 @@ static int iptcc_compile_table(struct xtc_handle *h, STRUCT_REPLACE *repl)
 	error = (void *)repl->entries + repl->size - IPTCB_CHAIN_ERROR_SIZE;
 	error->entry.target_offset = sizeof(STRUCT_ENTRY);
 	error->entry.next_offset = IPTCB_CHAIN_ERROR_SIZE;
-	error->target.t.u.user.target_size = 
+	error->target.t.u.user.target_size =
 		ALIGN(sizeof(struct ipt_error_target));
 	strcpy((char *)&error->target.t.u.user.name, ERROR_TARGET);
 	strcpy((char *)&error->target.error, "ERROR");
@@ -1353,7 +1353,7 @@ retry:
 
 #ifdef IPTC_DEBUG2
 	{
-		int fd = open("/tmp/libiptc-so_get_entries.blob", 
+		int fd = open("/tmp/libiptc-so_get_entries.blob",
 				O_CREAT|O_WRONLY);
 		if (fd >= 0) {
 			write(fd, h->entries, tmp);
@@ -1407,7 +1407,7 @@ print_match(const STRUCT_ENTRY_MATCH *m)
 }
 
 static int dump_entry(STRUCT_ENTRY *e, struct xtc_handle *const handle);
- 
+
 void
 TC_DUMP_ENTRIES(struct xtc_handle *const handle)
 {
@@ -1448,7 +1448,7 @@ static void iptcc_chain_iterator_advance(struct xtc_handle *handle)
 	if (c->list.next == &handle->chains)
 		handle->chain_iterator_cur = NULL;
 	else
-		handle->chain_iterator_cur = 
+		handle->chain_iterator_cur =
 			list_entry(c->list.next, struct chain_head, list);
 }
 
@@ -1488,7 +1488,7 @@ TC_NEXT_CHAIN(struct xtc_handle *handle)
 	}
 
 	iptcc_chain_iterator_advance(handle);
-	
+
 	DEBUGP(": returning `%s'\n", c->name);
 	return c->name;
 }
@@ -1536,13 +1536,13 @@ TC_NEXT_RULE(const STRUCT_ENTRY *prev, struct xtc_handle *handle)
 		DEBUGP_C("returning NULL\n");
 		return NULL;
 	}
-	
-	r = list_entry(handle->rule_iterator_cur->list.next, 
+
+	r = list_entry(handle->rule_iterator_cur->list.next,
 			struct rule_head, list);
 
 	iptc_fn = TC_NEXT_RULE;
 
-	DEBUGP_C("next=%p, head=%p...", &r->list, 
+	DEBUGP_C("next=%p, head=%p...", &r->list,
 		&handle->rule_iterator_cur->chain->rules);
 
 	if (&r->list == &handle->rule_iterator_cur->chain->rules) {
@@ -1571,7 +1571,7 @@ TC_NUM_RULES(const char *chain, struct xtc_handle *handle)
 		errno = ENOENT;
 		return (unsigned int)-1;
 	}
-	
+
 	return c->num_rules;
 }
 
@@ -1580,7 +1580,7 @@ TC_GET_RULE(const char *chain, unsigned int n, struct xtc_handle *handle)
 {
 	struct chain_head *c;
 	struct rule_head *r;
-	
+
 	iptc_fn = TC_GET_RULE;
 
 	CHECK(handle);
@@ -1657,7 +1657,7 @@ int
 TC_BUILTIN(const char *chain, struct xtc_handle *const handle)
 {
 	struct chain_head *c;
-	
+
 	iptc_fn = TC_BUILTIN;
 
 	c = iptcc_find_label(chain, handle);
@@ -2018,7 +2018,7 @@ TC_DELETE_ENTRY(const IPT_CHAINLABEL chain,
 	} else {
 		/* iptcc_map_target increment target chain references
 		 * since this is a fake rule only used for matching
-		 * the chain references count is decremented again. 
+		 * the chain references count is decremented again.
 		 */
 		if (r->type == IPTCC_R_JUMP
 		    && r->jump)
@@ -2039,7 +2039,7 @@ TC_DELETE_ENTRY(const IPT_CHAINLABEL chain,
 		 * current iterator, move rule iterator back.  next
 		 * pointer will then point to real next node */
 		if (i == handle->rule_iterator_cur) {
-			handle->rule_iterator_cur = 
+			handle->rule_iterator_cur =
 				list_entry(handle->rule_iterator_cur->list.prev,
 					   struct rule_head, list);
 		}
@@ -2090,7 +2090,7 @@ TC_DELETE_NUM_ENTRY(const IPT_CHAINLABEL chain,
 	 * iterator, move rule iterator back.  next pointer will then
 	 * point to real next node */
 	if (r == handle->rule_iterator_cur) {
-		handle->rule_iterator_cur = 
+		handle->rule_iterator_cur =
 			list_entry(handle->rule_iterator_cur->list.prev,
 				   struct rule_head, list);
 	}
@@ -2184,7 +2184,7 @@ TC_ZERO_COUNTER(const IPT_CHAINLABEL chain,
 {
 	struct chain_head *c;
 	struct rule_head *r;
-	
+
 	iptc_fn = TC_ZERO_COUNTER;
 	CHECK(handle);
 
@@ -2206,7 +2206,7 @@ TC_ZERO_COUNTER(const IPT_CHAINLABEL chain,
 	return 1;
 }
 
-int 
+int
 TC_SET_COUNTER(const IPT_CHAINLABEL chain,
 	       unsigned int rulenum,
 	       STRUCT_COUNTERS *counters,
@@ -2602,7 +2602,7 @@ TC_COMMIT(struct xtc_handle *handle)
 
 #ifdef IPTC_DEBUG2
 	{
-		int fd = open("/tmp/libiptc-so_set_replace.blob", 
+		int fd = open("/tmp/libiptc-so_set_replace.blob",
 				O_CREAT|O_WRONLY);
 		if (fd >= 0) {
 			write(fd, repl, sizeof(*repl) + repl->size);
@@ -2632,12 +2632,12 @@ TC_COMMIT(struct xtc_handle *handle)
 				break;
 			case COUNTER_MAP_NORMAL_MAP:
 				counters_normal_map(newcounters, repl,
-						    c->foot_index, 
+						    c->foot_index,
 						    c->counter_map.mappos);
 				break;
 			case COUNTER_MAP_ZEROED:
 				counters_map_zeroed(newcounters, repl,
-						    c->foot_index, 
+						    c->foot_index,
 						    c->counter_map.mappos,
 						    &c->counters);
 				break;
@@ -2657,7 +2657,7 @@ TC_COMMIT(struct xtc_handle *handle)
 
 			case COUNTER_MAP_NORMAL_MAP:
 				counters_normal_map(newcounters, repl,
-						    r->index, 
+						    r->index,
 						    r->counter_map.mappos);
 				break;
 
@@ -2678,7 +2678,7 @@ TC_COMMIT(struct xtc_handle *handle)
 
 #ifdef IPTC_DEBUG2
 	{
-		int fd = open("/tmp/libiptc-so_set_add_counters.blob", 
+		int fd = open("/tmp/libiptc-so_set_add_counters.blob",
 				O_CREAT|O_WRONLY);
 		if (fd >= 0) {
 			write(fd, newcounters, counterlen);
@@ -2721,7 +2721,7 @@ TC_STRERROR(int err)
 	} table [] =
 	  { { TC_INIT, EPERM, "Permission denied (you must be root)" },
 	    { TC_INIT, EINVAL, "Module is wrong version" },
-	    { TC_INIT, ENOENT, 
+	    { TC_INIT, ENOENT,
 		    "Table does not exist (do you need to insmod?)" },
 	    { TC_DELETE_CHAIN, ENOTEMPTY, "Chain is not empty" },
 	    { TC_DELETE_CHAIN, EINVAL, "Can't delete built-in chain" },

