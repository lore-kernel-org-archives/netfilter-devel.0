From: Dan Eble <dane@aiinet.com>
Subject: [PATCH] Negative rule numbers (library portion)
Date: Mon, 23 Sep 2002 11:17:39 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0209231055350.32713-100000@dane-linux.aiinet.com>
Reply-To: <dane@aiinet.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Well, Bart De Schuymer was apparently the only one who liked this idea, 
but that must count for _something_.

Since nobody responded to my questions about counters on rules at c->end, 
and there is a distinct lack of comments in the code about what such a 
thing means, I have left the behavior alone.  If it is truly a bug, 
someone else will have to fix it; if not, someone ought to comment the 
code to explain why not.

To make this change a little easier to swallow, I have split it into two
parts.  This first part changes only libiptc.  The next patch changes only
the command line interface.  I hope the core team will accept at least the
library patch, so that if I have to write my own command-line interface to
allow negative indexes, at least I will not have to spend so much time
maintaining differences from the official libiptc.

In addition to the extensive index tests I did last week, I have tested a
few cases with only this patch applied, to make sure it works with an
unaltered iptables program.

This patch requires the "unused prepend augument" patch I posted on
2002-9-16.

--- iptables-GPL-old/include/libiptc/libip6tc.h	Mon Feb 25 04:00:36 2002
+++ iptables-GPL/include/libiptc/libip6tc.h	Thu Sep 12 08:15:10 2002
@@ -57,13 +57,13 @@
 /* Insert the entry `fw' in chain `chain' into position `rulenum'. */
 int ip6tc_insert_entry(const ip6t_chainlabel chain,
 		       const struct ip6t_entry *e,
-		       unsigned int rulenum,
+		       int rulenum,
 		       ip6tc_handle_t *handle);
 
 /* Atomically replace rule `rulenum' in `chain' with `fw'. */
 int ip6tc_replace_entry(const ip6t_chainlabel chain,
 			const struct ip6t_entry *e,
-			unsigned int rulenum,
+			int rulenum,
 			ip6tc_handle_t *handle);
 
 /* Append entry `fw' to chain `chain'. Equivalent to insert with
@@ -80,7 +80,7 @@
 
 /* Delete the rule in position `rulenum' in `chain'. */
 int ip6tc_delete_num_entry(const ip6t_chainlabel chain,
-			   unsigned int rulenum,
+			   int rulenum,
 			   ip6tc_handle_t *handle);
 
 /* Check the packet `fw' on chain `chain'. Returns the verdict, or
@@ -122,17 +122,17 @@
 
 /* read packet and byte counters for a specific rule */
 struct ip6t_counters *ip6tc_read_counter(const ip6t_chainlabel chain,
-					unsigned int rulenum,
+					int rulenum,
 					ip6tc_handle_t *handle);
 
 /* zero packet and byte counters for a specific rule */
 int ip6tc_zero_counter(const ip6t_chainlabel chain,
-		       unsigned int rulenum,
+		       int rulenum,
 		       ip6tc_handle_t *handle);
 
 /* set packet and byte counters for a specific rule */
 int ip6tc_set_counter(const ip6t_chainlabel chain,
-		      unsigned int rulenum,
+		      int rulenum,
 		      struct ip6t_counters *counters,
 		      ip6tc_handle_t *handle);
 
--- iptables-GPL-old/include/libiptc/libiptc.h	Thu Apr 19 12:35:39 2001
+++ iptables-GPL/include/libiptc/libiptc.h	Thu Sep 12 08:08:18 2002
@@ -65,13 +65,13 @@
 /* Insert the entry `e' in chain `chain' into position `rulenum'. */
 int iptc_insert_entry(const ipt_chainlabel chain,
 		      const struct ipt_entry *e,
-		      unsigned int rulenum,
+		      int rulenum,
 		      iptc_handle_t *handle);
 
 /* Atomically replace rule `rulenum' in `chain' with `e'. */
 int iptc_replace_entry(const ipt_chainlabel chain,
 		       const struct ipt_entry *e,
-		       unsigned int rulenum,
+		       int rulenum,
 		       iptc_handle_t *handle);
 
 /* Append entry `e' to chain `chain'.  Equivalent to insert with
@@ -89,7 +89,7 @@
 
 /* Delete the rule in position `rulenum' in `chain'. */
 int iptc_delete_num_entry(const ipt_chainlabel chain,
-			  unsigned int rulenum,
+			  int rulenum,
 			  iptc_handle_t *handle);
 
 /* Check the packet `e' on chain `chain'.  Returns the verdict, or
@@ -132,17 +132,17 @@
 
 /* read packet and byte counters for a specific rule */
 struct ipt_counters *iptc_read_counter(const ipt_chainlabel chain,
-				       unsigned int rulenum,
+				       int rulenum,
 				       iptc_handle_t *handle);
 
 /* zero packet and byte counters for a specific rule */
 int iptc_zero_counter(const ipt_chainlabel chain,
-		      unsigned int rulenum,
+		      int rulenum,
 		      iptc_handle_t *handle);
 
 /* set packet and byte counters for a specific rule */
 int iptc_set_counter(const ipt_chainlabel chain,
-		     unsigned int rulenum,
+		     int rulenum,
 		     struct ipt_counters *counters,
 		     iptc_handle_t *handle);
 
--- iptables-GPL-old/libiptc/libiptc.c	Thu Sep 19 09:11:49 2002
+++ iptables-GPL/libiptc/libiptc.c	Thu Sep 19 09:42:45 2002
@@ -180,6 +180,82 @@
 	return entry2offset(h, index2entry(h, index));
 }
 
+/* rulenum=0 finds first rule (c->start),
+ * rulenum=1 finds second rule, etc.
+ * index_out receives the index of the found entry.
+ */
+static STRUCT_ENTRY *
+rulenum2entry_forward(const TC_HANDLE_T handle, struct chain_cache *c,
+		      unsigned int rulenum, unsigned int *index_out)
+{
+	unsigned int index;
+	STRUCT_ENTRY *entry;
+
+	/* Find the base entry/index. */
+	entry = c->start;
+	index = entry2index(handle, entry);
+
+	/* Find the true entry/index relative to the base entry/index. */
+	if (rulenum) {
+		if (rulenum > UINT_MAX - index) /* catch overflow */
+			return 0;
+		index += rulenum;
+		entry = index2entry(handle, index);
+		if (!entry || entry > c->end)
+			return 0;
+	}
+
+	if (index_out)
+		*index_out = index;
+
+	return entry;
+}
+
+/* rulenum=0 finds end-of-list (c->end),
+ * rulenum=1 finds last rule, etc.
+ * index_out receives the index of the found entry.
+ */
+static STRUCT_ENTRY *
+rulenum2entry_reverse(const TC_HANDLE_T handle, struct chain_cache *c,
+		      unsigned int rulenum, unsigned int *index_out)
+{
+	unsigned int index;
+	STRUCT_ENTRY *entry;
+
+	/* Find the base entry/index. */
+	entry = c->end;
+	index = entry2index(handle, entry);
+
+	/* Find the true entry/index relative to the base entry/index. */
+	if (rulenum) {
+		if (rulenum > index) /* catch underflow */
+			return 0;
+		index -= rulenum;
+		entry = index2entry(handle, index);
+		if (!entry || entry < c->start)
+			return 0;
+	}
+
+	if (index_out)
+		*index_out = index;
+
+	return entry;
+}
+
+/* General access of an entry from the beginning or end of a chain, depending
+ * on the sign of rulenum.  The ambiguous case of rulenum=0 is resolved in
+ * favor of the forward direction for backward compatibility.
+ */
+static STRUCT_ENTRY *
+rulenum2entry(const TC_HANDLE_T handle, struct chain_cache *c,
+	      int rulenum, unsigned int *index_out)
+{
+	if (rulenum >= 0)
+		return rulenum2entry_forward(handle, c, rulenum, index_out);
+	else
+		return rulenum2entry_reverse(handle, c, -rulenum, index_out);
+}
+
 static const char *
 get_errorlabel(TC_HANDLE_T h, unsigned int offset)
 {
@@ -907,10 +983,10 @@
 int
 TC_INSERT_ENTRY(const IPT_CHAINLABEL chain,
 		const STRUCT_ENTRY *e,
-		unsigned int rulenum,
+		int rulenum,
 		TC_HANDLE_T *handle)
 {
-	unsigned int chainindex, offset;
+	unsigned int index, offset;
 	STRUCT_ENTRY_TARGET old;
 	struct chain_cache *c;
 	STRUCT_ENTRY *tmp;
@@ -922,22 +998,26 @@
 		return 0;
 	}
 
-	chainindex = entry2index(*handle, c->start);
+	if (rulenum >= 0)
+		tmp = rulenum2entry_forward(*handle, c, rulenum, &index);
+	else {
+		/* Add -1 to insert *after* the requested entry. */
+		tmp = rulenum2entry_reverse(*handle, c, -rulenum - 1, &index);
+	}
 
-	tmp = index2entry(*handle, chainindex + rulenum);
-	if (!tmp || tmp > c->end) {
+	if (!tmp) {
 		errno = E2BIG;
 		return 0;
 	}
-	offset = index2offset(*handle, chainindex + rulenum);
+
+	offset = entry2offset(*handle, tmp);
 
 	/* Mapping target actually alters entry, but that's
            transparent to the caller. */
 	if (!map_target(*handle, (STRUCT_ENTRY *)e, offset, &old))
 		return 0;
 
-	ret = insert_rules(1, e->next_offset, e, offset,
-			   chainindex + rulenum, handle);
+	ret = insert_rules(1, e->next_offset, e, offset, index, handle);
 	unmap_target((STRUCT_ENTRY *)e, &old);
 	return ret;
 }
@@ -946,10 +1026,10 @@
 int
 TC_REPLACE_ENTRY(const IPT_CHAINLABEL chain,
 		 const STRUCT_ENTRY *e,
-		 unsigned int rulenum,
+		 int rulenum,
 		 TC_HANDLE_T *handle)
 {
-	unsigned int chainindex, offset;
+	unsigned int index, offset;
 	STRUCT_ENTRY_TARGET old;
 	struct chain_cache *c;
 	STRUCT_ENTRY *tmp;
@@ -962,25 +1042,23 @@
 		return 0;
 	}
 
-	chainindex = entry2index(*handle, c->start);
-
-	tmp = index2entry(*handle, chainindex + rulenum);
-	if (!tmp || tmp >= c->end) {
+	tmp = rulenum2entry(*handle, c, rulenum, &index);
+	if (!tmp || tmp == c->end) {
 		errno = E2BIG;
 		return 0;
 	}
 
-	offset = index2offset(*handle, chainindex + rulenum);
+	offset = entry2offset(*handle, tmp);
+
 	/* Replace = delete and insert. */
 	if (!delete_rules(1, get_entry(*handle, offset)->next_offset,
-			  offset, chainindex + rulenum, handle))
+			  offset, index, handle))
 		return 0;
 
 	if (!map_target(*handle, (STRUCT_ENTRY *)e, offset, &old))
 		return 0;
 
-	ret = insert_rules(1, e->next_offset, e, offset,
-			   chainindex + rulenum, handle);
+	ret = insert_rules(1, e->next_offset, e, offset, index, handle);
 	unmap_target((STRUCT_ENTRY *)e, &old);
 	return ret;
 }
@@ -992,26 +1070,7 @@
 		const STRUCT_ENTRY *e,
 		TC_HANDLE_T *handle)
 {
-	struct chain_cache *c;
-	STRUCT_ENTRY_TARGET old;
-	int ret;
-
-	iptc_fn = TC_APPEND_ENTRY;
-	if (!(c = find_label(chain, *handle))) {
-		errno = ENOENT;
-		return 0;
-	}
-
-	if (!map_target(*handle, (STRUCT_ENTRY *)e,
-			entry2offset(*handle, c->end), &old))
-		return 0;
-
-	ret = insert_rules(1, e->next_offset, e,
-			   entry2offset(*handle, c->end),
-			   entry2index(*handle, c->end),
-			   handle);
-	unmap_target((STRUCT_ENTRY *)e, &old);
-	return ret;
+	return TC_INSERT_ENTRY(chain, e, -1, handle);
 }
 
 static inline int
@@ -1119,7 +1178,7 @@
 /* Delete the rule in position `rulenum' in `chain'. */
 int
 TC_DELETE_NUM_ENTRY(const IPT_CHAINLABEL chain,
-		    unsigned int rulenum,
+		    int rulenum,
 		    TC_HANDLE_T *handle)
 {
 	unsigned int index;
@@ -1133,19 +1192,12 @@
 		return 0;
 	}
 
-	index = entry2index(*handle, c->start) + rulenum;
-
-	if (index >= entry2index(*handle, c->end)) {
+	e = rulenum2entry(*handle, c, rulenum, &index);
+	if (!e || e == c->end) {
 		errno = E2BIG;
 		return 0;
 	}
 
-	e = index2entry(*handle, index);
-	if (e == NULL) {
-		errno = EINVAL;
-		return 0;
-	}
-
 	ret = delete_rules(1, e->next_offset, entry2offset(*handle, e),
 			   index, handle);
 	return ret;
@@ -1211,12 +1263,11 @@
 
 STRUCT_COUNTERS *
 TC_READ_COUNTER(const IPT_CHAINLABEL chain,
-		unsigned int rulenum,
+		int rulenum,
 		TC_HANDLE_T *handle)
 {
 	STRUCT_ENTRY *e;
 	struct chain_cache *c;
-	unsigned int chainindex, end;
 
 	iptc_fn = TC_READ_COUNTER;
 	CHECK(*handle);
@@ -1226,27 +1277,23 @@
 		return NULL;
 	}
 
-	chainindex = entry2index(*handle, c->start);
-	end = entry2index(*handle, c->end);
-
-	if (chainindex + rulenum > end) {
+	e = rulenum2entry(*handle, c, rulenum, NULL);
+	if (!e) {
 		errno = E2BIG;
 		return NULL;
 	}
 
-	e = index2entry(*handle, chainindex + rulenum);
-
 	return &e->counters;
 }
 
 int
 TC_ZERO_COUNTER(const IPT_CHAINLABEL chain,
-		unsigned int rulenum,
+		int rulenum,
 		TC_HANDLE_T *handle)
 {
 	STRUCT_ENTRY *e;
 	struct chain_cache *c;
-	unsigned int chainindex, end;
+	unsigned int index;
 	
 	iptc_fn = TC_ZERO_COUNTER;
 	CHECK(*handle);
@@ -1256,21 +1303,14 @@
 		return 0;
 	}
 
-	chainindex = entry2index(*handle, c->start);
-	end = entry2index(*handle, c->end);
-
-	if (chainindex + rulenum > end) {
+	e = rulenum2entry(*handle, c, rulenum, &index);
+	if (!e) {
 		errno = E2BIG;
 		return 0;
 	}
 
-	e = index2entry(*handle, chainindex + rulenum);
-
-	if ((*handle)->counter_map[chainindex + rulenum].maptype
-			== COUNTER_MAP_NORMAL_MAP) {
-		(*handle)->counter_map[chainindex + rulenum].maptype
-			 = COUNTER_MAP_ZEROED;
-	}
+	if ((*handle)->counter_map[index].maptype == COUNTER_MAP_NORMAL_MAP)
+		(*handle)->counter_map[index].maptype = COUNTER_MAP_ZEROED;
 
 	set_changed(*handle);
 
@@ -1279,13 +1319,13 @@
 
 int 
 TC_SET_COUNTER(const IPT_CHAINLABEL chain,
-	       unsigned int rulenum,
+	       int rulenum,
 	       STRUCT_COUNTERS *counters,
 	       TC_HANDLE_T *handle)
 {
 	STRUCT_ENTRY *e;
 	struct chain_cache *c;
-	unsigned int chainindex, end;
+	unsigned int index;
 
 	iptc_fn = TC_SET_COUNTER;
 	CHECK(*handle);
@@ -1295,18 +1335,13 @@
 		return 0;
 	}
 
-	chainindex = entry2index(*handle, c->start);
-	end = entry2index(*handle, c->end);
-
-	if (chainindex + rulenum > end) {
+	e = rulenum2entry(*handle, c, rulenum, &index);
+	if (!e) {
 		errno = E2BIG;
 		return 0;
 	}
 
-	e = index2entry(*handle, chainindex + rulenum);
-
-	(*handle)->counter_map[chainindex + rulenum].maptype
-		= COUNTER_MAP_SET;
+	(*handle)->counter_map[index].maptype = COUNTER_MAP_SET;
 
 	memcpy(&e->counters, counters, sizeof(STRUCT_COUNTERS));
 
