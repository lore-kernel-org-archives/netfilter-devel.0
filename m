From: Jesper Dangaard Brouer <jdb@comx.dk>
Subject: [PATCH 2/2] iptables/libiptc perf issue: Finding jump chains is
	suboptimal
Date: Mon, 26 Nov 2007 14:56:46 +0100
Message-ID: <1196085406.3866.59.camel@localhost.localdomain>
Reply-To: jdb@comx.dk
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: "Paul C. Diem" <PCDiem@FoxValley.net>,
	Martin Josefsson <gandalf@netfilter.org>
To: Netfilter Developers <netfilter-devel@vger.kernel.org>,
	Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:34001 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752577AbXKZN6r (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Nov 2007 08:58:47 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Performance optimize scalability issue:
   Finding jump chains is suboptimal O(Chain*Rules).

The problem is that the chain list is searched lineary for each rule
with a jump target.

The problem lies in the "second pass" (of function parse_table) where
the userchain jump targets are found. For each rule "R" with a
IPTCC_R_JUMP target, function iptcc_find_chain_by_offset searches
through the chains "C" in the chain list (worst-case hitting the last one).

The "second pass" loop has a bad worst-case run time of O(C*R).

The solution idea is based upon Paul C. Diem's patch.

The patch solves this by using the blob data structure as a kind of
hash table.  The "comefrom" field of the "entry" struct, is used to
store a pointer to chain it belongs to.  Modifying the "entry" struct
in the blob, should not pose a problem, because its modified after a
copy of it have been stored in rule->entry.

In cache_add_entry(): is the "comefrom" field of the "entry" struct
modified.

In iptcc_find_chain_by_offset(): is the lineary search replaced by a
direct lookup that returns the chain pointer O(1).

Cc: Paul C. Diem <PCDiem@FoxValley.net>
Signed-off-by: Jesper Dangaard Brouer <hawk@comx.dk>
---
 libiptc/libiptc.c |   23 +++++++++++++++++++----
 1 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/libiptc/libiptc.c b/libiptc/libiptc.c
index e7ffb01..e611178 100644
--- a/libiptc/libiptc.c
+++ b/libiptc/libiptc.c
@@ -307,13 +307,20 @@ static struct rule_head *iptcc_get_rule_num_reverse(struct chain_head *c,
 static struct chain_head *
 iptcc_find_chain_by_offset(TC_HANDLE_T handle, unsigned int offset)
 {
-	struct list_head *pos;
-
 	if (list_empty(&handle->chains))
 		return NULL;
 
-	list_for_each(pos, &handle->chains) {
-		struct chain_head *c = list_entry(pos, struct chain_head, list);
+	/* Find the entry pointed to by offset */
+	STRUCT_ENTRY * e = iptcb_offset2entry(handle, offset);
+
+	/* When parsing the blob (in cache_add_entry), the entry
+	   field comefrom has been modified to contain a pointer
+	   to the chain it belongs to.
+	*/
+	struct chain_head *c = (struct chain_head *)e->comefrom;
+
+	if (c) {
+		/* Extra verifying step*/
 		if (offset >= c->head_offset && offset <= c->foot_offset)
 			return c;
 	}
@@ -494,6 +501,14 @@ new_rule:
 		r->index = *num;
 		r->offset = offset;
 		memcpy(r->entry, e, e->next_offset);
+
+		/*
+		  Modify the blob entry to contain a pointer to the
+		  chain it belongs to.  Needed later to resolve jump
+		  targets faster (used in iptcc_find_chain_by_offset)
+		*/
+		e->comefrom = (unsigned int)h->chain_iterator_cur;
+
 		r->counter_map.maptype = COUNTER_MAP_NORMAL_MAP;
 		r->counter_map.mappos = r->index;
 

