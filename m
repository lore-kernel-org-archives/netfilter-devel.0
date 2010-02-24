From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ip_tables: foreachs and reentrancy
Date: Wed, 24 Feb 2010 20:33:12 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002241952410.3301@obet.zrqbmnf.qr>
References: <1265970044-19518-1-git-send-email-jengelh@medozas.de> <4B856498.9040202@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:34778 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757775Ab0BXTdO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 24 Feb 2010 14:33:14 -0500
In-Reply-To: <4B856498.9040202@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-02-24 18:40, Patrick McHardy wrote:
>> Jan Engelhardt (6):
>>       netfilter: xtables: replace XT_ENTRY_ITERATE macro
>>       netfilter: xtables: optimize call flow around xt_entry_foreach
>>       netfilter: xtables: replace XT_MATCH_ITERATE macro
>>       netfilter: xtables: optimize call flow around xt_ematch_foreach
>>       netfilter: xtables: reduce arguments to translate_table
>>       netfilter: xtables2: make ip_tables reentrant
>
>I've applied patch 1-5 for now. Patch 6 doesn't add any value
>so far, so it should go in a series that actually makes use of
>this

Rusty left a note "must return absolute verdict" in ipt_REJECT
and ip6t_REJECT, so maybe he thought of something.

Irrespective of that however, there is xt_TEE in Xtables-addons which
would greatly benefit in the 6th patch (which is standalone, nothing
else is needed in the kernel to get it done), as it could then track
both the original copy and the tee'd copy through the tables, instead
of having to forget one.

Given the nftables snapshot also has some sort of reentrancy safety,
I don't see why Xtables should not have that. And since the Xtables
patch also makes it a runtime-tunable, we've got the best of all
worlds.

>(please note: I don't want any larger changes anymore in
>this release however).

Uff. That was a pretty small patchstream NF produced this time
towards upstream.

My intention was to have the entire set merged by 2.6.32, only
delayed by my own tinkering around with the get_cycle measurement of
the data collapse. But it was ready on-time for the 2.6.34 window!
What went wrong? Do we need to begin the merge-into-kabernext window
much earlier?

>BTW, I noticed some minor cosmetic problems that I didn't fix
>up to avoid clashes, please send me a patch on top to fix up
>indentation in spots like this:
>
>	/* Walk through entries, checking offsets. */
>	xt_entry_foreach(iter, entry0, newinfo->size) {
>		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
>		      entry0 + repl->size, repl->hook_entry, repl->underflow,
>		      repl->valid_hooks);
>
>Thanks!

Heh, this drives it ad absurdum.

	"Now, some people will claim that having 8-character
	indentations makes the code move too far to the right,[...]
	if you need more than 3 levels of indentation, you're screwed"

Linus, I bet you did not envision a 3-level indent (which is what
we have here in ip_tables.c) and still getting screwed in the end :-)

But oh well what don't we all do just to get code merged at all.
Here goes:

parent 0f234214d15fa914436d304ecf5c3e43449e79f9 (v2.6.33-rc8-1216-g0f23421)
commit 289654709ca94f8de4fa615b23f8e9e9f1527fae
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Wed Feb 24 20:29:05 2010 +0100

iptables: restore maintainer's idea of indent

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/arp_tables.c |   23 ++++++++++++++---------
 net/ipv4/netfilter/ip_tables.c  |   25 +++++++++++++++----------
 net/ipv6/netfilter/ip6_tables.c |   25 +++++++++++++++----------
 3 files changed, 44 insertions(+), 29 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 57098dc..f07d77f 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -644,8 +644,10 @@ static int translate_table(struct xt_table_info *newinfo, void *entry0,
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter, entry0, newinfo->size) {
 		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
-		      entry0 + repl->size, repl->hook_entry, repl->underflow,
-		      repl->valid_hooks);
+						 entry0 + repl->size,
+						 repl->hook_entry,
+						 repl->underflow,
+						 repl->valid_hooks);
 		if (ret != 0)
 			break;
 		++i;
@@ -730,7 +732,7 @@ static void get_counters(const struct xt_table_info *t,
 	i = 0;
 	xt_entry_foreach(iter, t->entries[curcpu], t->size) {
 		SET_COUNTER(counters[i], iter->counters.bcnt,
-			iter->counters.pcnt);
+			    iter->counters.pcnt);
 		++i;
 	}
 
@@ -741,7 +743,7 @@ static void get_counters(const struct xt_table_info *t,
 		xt_info_wrlock(cpu);
 		xt_entry_foreach(iter, t->entries[cpu], t->size) {
 			ADD_COUNTER(counters[i], iter->counters.bcnt,
-				iter->counters.pcnt);
+				    iter->counters.pcnt);
 			++i;
 		}
 		xt_info_wrunlock(cpu);
@@ -1356,8 +1358,11 @@ static int translate_compat_table(const char *name,
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter0, entry0, total_size) {
 		ret = check_compat_entry_size_and_hooks(iter0, info, &size,
-		      entry0, entry0 + total_size, hook_entries, underflows,
-		      name);
+							entry0,
+							entry0 + total_size,
+							hook_entries,
+							underflows,
+							name);
 		if (ret != 0)
 			goto out_unlock;
 		++j;
@@ -1401,8 +1406,8 @@ static int translate_compat_table(const char *name,
 	pos = entry1;
 	size = total_size;
 	xt_entry_foreach(iter0, entry0, total_size) {
-		ret = compat_copy_entry_from_user(iter0, &pos,
-		      &size, name, newinfo, entry1);
+		ret = compat_copy_entry_from_user(iter0, &pos, &size,
+						  name, newinfo, entry1);
 		if (ret != 0)
 			break;
 	}
@@ -1617,7 +1622,7 @@ static int compat_copy_entries_to_user(unsigned int total_size,
 	size = total_size;
 	xt_entry_foreach(iter, loc_cpu_entry, total_size) {
 		ret = compat_copy_entry_to_user(iter, &pos,
-		      &size, counters, i++);
+						&size, counters, i++);
 		if (ret != 0)
 			break;
 	}
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index c92f4e5..b29c66d 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -836,8 +836,10 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter, entry0, newinfo->size) {
 		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
-		      entry0 + repl->size, repl->hook_entry, repl->underflow,
-		      repl->valid_hooks);
+						 entry0 + repl->size,
+						 repl->hook_entry,
+						 repl->underflow,
+						 repl->valid_hooks);
 		if (ret != 0)
 			return ret;
 		++i;
@@ -918,7 +920,7 @@ get_counters(const struct xt_table_info *t,
 	i = 0;
 	xt_entry_foreach(iter, t->entries[curcpu], t->size) {
 		SET_COUNTER(counters[i], iter->counters.bcnt,
-			iter->counters.pcnt);
+			    iter->counters.pcnt);
 		++i;
 	}
 
@@ -929,7 +931,7 @@ get_counters(const struct xt_table_info *t,
 		xt_info_wrlock(cpu);
 		xt_entry_foreach(iter, t->entries[cpu], t->size) {
 			ADD_COUNTER(counters[i], iter->counters.bcnt,
-				iter->counters.pcnt);
+				    iter->counters.pcnt);
 			++i; /* macro does multi eval of i */
 		}
 		xt_info_wrunlock(cpu);
@@ -1540,7 +1542,7 @@ check_compat_entry_size_and_hooks(struct compat_ipt_entry *e,
 	j = 0;
 	xt_ematch_foreach(ematch, e) {
 		ret = compat_find_calc_match(ematch, name,
-		      &e->ip, e->comefrom, &off);
+					     &e->ip, e->comefrom, &off);
 		if (ret != 0)
 			goto release_matches;
 		++j;
@@ -1701,8 +1703,11 @@ translate_compat_table(struct net *net,
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter0, entry0, total_size) {
 		ret = check_compat_entry_size_and_hooks(iter0, info, &size,
-		      entry0, entry0 + total_size, hook_entries, underflows,
-		      name);
+							entry0,
+							entry0 + total_size,
+							hook_entries,
+							underflows,
+							name);
 		if (ret != 0)
 			goto out_unlock;
 		++j;
@@ -1746,8 +1751,8 @@ translate_compat_table(struct net *net,
 	pos = entry1;
 	size = total_size;
 	xt_entry_foreach(iter0, entry0, total_size) {
-		ret = compat_copy_entry_from_user(iter0, &pos,
-		      &size, name, newinfo, entry1);
+		ret = compat_copy_entry_from_user(iter0, &pos, &size,
+						  name, newinfo, entry1);
 		if (ret != 0)
 			break;
 	}
@@ -1927,7 +1932,7 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 	size = total_size;
 	xt_entry_foreach(iter, loc_cpu_entry, total_size) {
 		ret = compat_copy_entry_to_user(iter, &pos,
-		      &size, counters, i++);
+						&size, counters, i++);
 		if (ret != 0)
 			break;
 	}
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index f704286..9210e31 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -866,8 +866,10 @@ translate_table(struct net *net, struct xt_table_info *newinfo, void *entry0,
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter, entry0, newinfo->size) {
 		ret = check_entry_size_and_hooks(iter, newinfo, entry0,
-		      entry0 + repl->size, repl->hook_entry, repl->underflow,
-		      repl->valid_hooks);
+						 entry0 + repl->size,
+						 repl->hook_entry,
+						 repl->underflow,
+						 repl->valid_hooks);
 		if (ret != 0)
 			return ret;
 		++i;
@@ -948,7 +950,7 @@ get_counters(const struct xt_table_info *t,
 	i = 0;
 	xt_entry_foreach(iter, t->entries[curcpu], t->size) {
 		SET_COUNTER(counters[i], iter->counters.bcnt,
-			iter->counters.pcnt);
+			    iter->counters.pcnt);
 		++i;
 	}
 
@@ -959,7 +961,7 @@ get_counters(const struct xt_table_info *t,
 		xt_info_wrlock(cpu);
 		xt_entry_foreach(iter, t->entries[cpu], t->size) {
 			ADD_COUNTER(counters[i], iter->counters.bcnt,
-				iter->counters.pcnt);
+				    iter->counters.pcnt);
 			++i;
 		}
 		xt_info_wrunlock(cpu);
@@ -1573,7 +1575,7 @@ check_compat_entry_size_and_hooks(struct compat_ip6t_entry *e,
 	j = 0;
 	xt_ematch_foreach(ematch, e) {
 		ret = compat_find_calc_match(ematch, name,
-		      &e->ipv6, e->comefrom, &off);
+					     &e->ipv6, e->comefrom, &off);
 		if (ret != 0)
 			goto release_matches;
 		++j;
@@ -1734,8 +1736,11 @@ translate_compat_table(struct net *net,
 	/* Walk through entries, checking offsets. */
 	xt_entry_foreach(iter0, entry0, total_size) {
 		ret = check_compat_entry_size_and_hooks(iter0, info, &size,
-		      entry0, entry0 + total_size, hook_entries, underflows,
-		      name);
+							entry0,
+							entry0 + total_size,
+							hook_entries,
+							underflows,
+							name);
 		if (ret != 0)
 			goto out_unlock;
 		++j;
@@ -1779,8 +1784,8 @@ translate_compat_table(struct net *net,
 	pos = entry1;
 	size = total_size;
 	xt_entry_foreach(iter0, entry0, total_size) {
-		ret = compat_copy_entry_from_user(iter0, &pos,
-		      &size, name, newinfo, entry1);
+		ret = compat_copy_entry_from_user(iter0, &pos, &size,
+						  name, newinfo, entry1);
 		if (ret != 0)
 			break;
 	}
@@ -1960,7 +1965,7 @@ compat_copy_entries_to_user(unsigned int total_size, struct xt_table *table,
 	size = total_size;
 	xt_entry_foreach(iter, loc_cpu_entry, total_size) {
 		ret = compat_copy_entry_to_user(iter, &pos,
-		      &size, counters, i++);
+						&size, counters, i++);
 		if (ret != 0)
 			break;
 	}
-- 
# Created with git-export-patch
