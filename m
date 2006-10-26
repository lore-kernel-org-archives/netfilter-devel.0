From: "Paul C Diem" <PCDiem@FoxValley.net>
Subject: RE: How many rules were supported iptables?
Date: Thu, 26 Oct 2006 10:29:55 -0500
Message-ID: <001701c6f913$96d98350$52c08740@FoxValley.net>
References: <Pine.LNX.4.61.0610261314390.20975@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0610261314390.20975@ask.diku.dk>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 20 Oct 2006, Peter wrote:
(snip)
> Problem: The execution time of iptables take around 14 seconds.  This is
> caused by the way iptables/libiptc parse the ruleset blob, in libiptc.c
> function iptcc_find_chain_by_offset.  We should actually fix this... I
> have raised this issue before on the list, but the discussion died...
(snip)

I posted a patch to fix this a few months ago. Unfortunately, I'm not being
familiar with maintaining my mods with cvs, the proper way to submit patches
and the nfsim test suggested by Patrick McHardy. If someone can do that,
here's a diff of the changes I've made to libiptc.c including the
modification to load/use the chain entry offset for use by the parse and the
modification to insert new chains in the proper order and not sort chains on
init:

Paul C. Diem
PCDiem@FoxValley.net

diff -Nurp iptables-1.3.5-org/libiptc/libiptc.c
iptables-1.3.5/libiptc/libiptc.c | more
--- iptables-1.3.5-org/libiptc/libiptc.c        2006-01-30
02:43:09.000000000 -0600
+++ iptables-1.3.5/libiptc/libiptc.c    2006-07-15 15:04:24.000000000 -0500
@@ -307,6 +307,12 @@ static struct rule_head *iptcc_get_rule_
 static struct chain_head *
 iptcc_find_chain_by_offset(TC_HANDLE_T handle, unsigned int offset)
 {
+/*+PCD*/
+       /*
+       * Use the offset of the chain entry in the ipt entry comefrom
+       * field as loaded by iptcc_find_chain_by_offset.
+       */
+#if 0
        struct list_head *pos;

        if (list_empty(&handle->chains))
@@ -317,6 +323,11 @@ iptcc_find_chain_by_offset(TC_HANDLE_T h
                if (offset >= c->head_offset && offset <= c->foot_offset)
                        return c;
        }
+#else
+      STRUCT_ENTRY * e = ((STRUCT_ENTRY *)((char
*)handle->entries->entrytable + offset));
+      return (struct chain_head *)((char *)e + e->comefrom);
+#endif
+/*-PCD*/

        return NULL;
 }
@@ -420,7 +431,13 @@ static void __iptcc_p_add_chain(TC_HANDL
        c->head_offset = offset;
        c->index = *num;

-       iptc_insert_chain(h, c);
+/*+PCD
+* Don't waste cycles finding alphabetical place to insert chains
+* on load. Do that when we're adding a new chain instead.
+*/
+//     iptc_insert_chain(h, c);
+       list_add_tail(&c->list, &h->chains);
+/*-PCD*/

        h->chain_iterator_cur = c;
 }
@@ -494,6 +511,15 @@ new_rule:
                r->index = *num;
                r->offset = offset;
                memcpy(r->entry, e, e->next_offset);
+/*+PCD*/
+               /*
+               * Load the offset of the chain entry relative to the
+               * ipt entry into the ipt entry comefrom field for use
+               * by iptcc_find_chain_by_offset in the second pass.
+               */
+               if (h->chain_iterator_cur->num_rules == 0)
+                       e->comefrom = (char *)h->chain_iterator_cur - (char
*)e;
+/*-PCD*/
                r->counter_map.maptype = COUNTER_MAP_NORMAL_MAP;
                r->counter_map.mappos = r->index;

@@ -534,7 +560,6 @@ out_inc:
        return 0;
 }

-
 /* parse an iptables blob into it's pieces */
 static int parse_table(TC_HANDLE_T h)
 {
@@ -545,7 +570,6 @@ static int parse_table(TC_HANDLE_T h)
        /* First pass: over ruleset blob */
        ENTRY_ITERATE(h->entries->entrytable, h->entries->size,
                        cache_add_entry, h, &prev, &num);
-
        /* Second pass: fixup parsed data from first pass */
        list_for_each_entry(c, &h->chains, list) {
                struct rule_head *r;
@@ -1048,7 +1072,8 @@ TC_NEXT_RULE(const STRUCT_ENTRY *prev, T
        DEBUGP_C("next=%p, head=%p...", &r->list,
                &(*handle)->rule_iterator_cur->chain->rules);

-       if (&r->list == &(*handle)->rule_iterator_cur->chain->rules) {
+       if (r == (struct rule_head *)(&(*handle)->rule_iterator_cur->list)
||
+               &r->list == &(*handle)->rule_iterator_cur->chain->rules) {
                (*handle)->rule_iterator_cur = NULL;
                DEBUGP_C("finished, returning NULL\n");
                return NULL;
@@ -1781,8 +1806,12 @@ TC_CREATE_CHAIN(const IPT_CHAINLABEL cha
        }

        DEBUGP("Creating chain `%s'\n", chain);
-       list_add_tail(&c->list, &(*handle)->chains);
-
+/*+PCD
+* Insert new chain alphabetically.
+*/
+//     list_add_tail(&c->list, &(*handle)->chains);
+       iptc_insert_chain(*handle, c);
+/*-PCD*/
        set_changed(*handle);

        return 1;
