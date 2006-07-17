From: "Paul C. Diem" <PCDiem@FoxValley.net>
Subject: RE: Chain Sorting
Date: Sun, 16 Jul 2006 21:29:36 -0500
Message-ID: <FFEPKIHJDEDDAAFOFDGFOELOCBAA.PCDiem@FoxValley.net>
References: <44BA4284.9010604@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="windows-1250"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
In-Reply-To: <44BA4284.9010604@netfilter.org>
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

Again, my apologies for not being familiar with maintaining my mods with cvs
and the proper way to submit patches. Here's a diff of the changes I've made
to libiptc.c including the modification to load/use the chain entry offset
for use by the parse and the modification to insert new chains in the proper
order and not sort chains on init:

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



-----Original Message-----
From: netfilter-devel-bounces@lists.netfilter.org
[mailto:netfilter-devel-bounces@lists.netfilter.org]On Behalf Of Pablo Neira
Ayuso
Sent: Sunday, July 16, 2006 8:44 AM
To: Paul C. Diem
Cc: netfilter-devel@lists.netfilter.org
Subject: Re: Chain Sorting


Paul C. Diem wrote:
> In my quest to speed up the TC_INIT, I found that the libiptc.c searches
the
> chain list for the alphabetically correct place to insert chains as it
> converts from the blob to the chain list. However, when adding a new chain
> in TC_CREATE_CHAIN, it simply adds the new chain to the end of the list.
>
> This leaves the chains unsorted when written back to the kernel and uses
> lots of cycles when loading. I patched libiptc.c to simply add chains to
the
> end of the list when loading and use iptc_insert_chain in TC_CREATE_CHAIN
to
> insert newly created chains into the proper order. My
> TC_INIT time with 4106 chains went from about 1.09 real seconds to about
> 0.05 real seconds.

This seems interesting, please, could send post the patch?

--
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris


--
No virus found in this incoming message.
Checked by AVG Free Edition.
Version: 7.1.394 / Virus Database: 268.10.1/389 - Release Date: 7/14/2006
