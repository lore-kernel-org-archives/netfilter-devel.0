Return-Path: <SRS0=Sk6b=RF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2BC9C43381
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:35:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7590020838
	for <netfilter-devel@archiver.kernel.org>; Sat,  2 Mar 2019 18:35:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727127AbfCBSfO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 2 Mar 2019 13:35:14 -0500
Received: from mail.us.es ([193.147.175.20]:35744 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726848AbfCBSfN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 2 Mar 2019 13:35:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id C86DC1361B5
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:35:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id A8543DA86E
        for <netfilter-devel@vger.kernel.org>; Sat,  2 Mar 2019 19:35:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 9AD0ADA86A; Sat,  2 Mar 2019 19:35:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 40727DA856;
        Sat,  2 Mar 2019 19:35:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sat, 02 Mar 2019 19:35:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [31.4.223.53])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id DEC2A4265A2F;
        Sat,  2 Mar 2019 19:35:06 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 03/29] netfilter: ebtables: remove BUGPRINT messages
Date:   Sat,  2 Mar 2019 19:34:31 +0100
Message-Id: <20190302183457.3079-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190302183457.3079-1-pablo@netfilter.org>
References: <20190302183457.3079-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

They are however frequently triggered by syzkaller, so remove them.

ebtables userspace should never trigger any of these, so there is little
value in making them pr_debug (or ratelimited).

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/bridge/netfilter/ebtables.c | 131 ++++++++++++----------------------------
 1 file changed, 39 insertions(+), 92 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 6693e209efe8..f77888ec93f1 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -31,10 +31,6 @@
 /* needed for logical [in,out]-dev filtering */
 #include "../br_private.h"
 
-#define BUGPRINT(format, args...) printk("kernel msg: ebtables bug: please "\
-					 "report to author: "format, ## args)
-/* #define BUGPRINT(format, args...) */
-
 /* Each cpu has its own set of counters, so there is no need for write_lock in
  * the softirq
  * For reading or updating the counters, the user context needs to
@@ -466,8 +462,6 @@ static int ebt_verify_pointers(const struct ebt_replace *repl,
 				/* we make userspace set this right,
 				 * so there is no misunderstanding
 				 */
-				BUGPRINT("EBT_ENTRY_OR_ENTRIES shouldn't be set "
-					 "in distinguisher\n");
 				return -EINVAL;
 			}
 			if (i != NF_BR_NUMHOOKS)
@@ -485,18 +479,14 @@ static int ebt_verify_pointers(const struct ebt_replace *repl,
 			offset += e->next_offset;
 		}
 	}
-	if (offset != limit) {
-		BUGPRINT("entries_size too small\n");
+	if (offset != limit)
 		return -EINVAL;
-	}
 
 	/* check if all valid hooks have a chain */
 	for (i = 0; i < NF_BR_NUMHOOKS; i++) {
 		if (!newinfo->hook_entry[i] &&
-		   (valid_hooks & (1 << i))) {
-			BUGPRINT("Valid hook without chain\n");
+		   (valid_hooks & (1 << i)))
 			return -EINVAL;
-		}
 	}
 	return 0;
 }
@@ -523,26 +513,20 @@ ebt_check_entry_size_and_hooks(const struct ebt_entry *e,
 		/* this checks if the previous chain has as many entries
 		 * as it said it has
 		 */
-		if (*n != *cnt) {
-			BUGPRINT("nentries does not equal the nr of entries "
-				 "in the chain\n");
+		if (*n != *cnt)
 			return -EINVAL;
-		}
+
 		if (((struct ebt_entries *)e)->policy != EBT_DROP &&
 		   ((struct ebt_entries *)e)->policy != EBT_ACCEPT) {
 			/* only RETURN from udc */
 			if (i != NF_BR_NUMHOOKS ||
-			   ((struct ebt_entries *)e)->policy != EBT_RETURN) {
-				BUGPRINT("bad policy\n");
+			   ((struct ebt_entries *)e)->policy != EBT_RETURN)
 				return -EINVAL;
-			}
 		}
 		if (i == NF_BR_NUMHOOKS) /* it's a user defined chain */
 			(*udc_cnt)++;
-		if (((struct ebt_entries *)e)->counter_offset != *totalcnt) {
-			BUGPRINT("counter_offset != totalcnt");
+		if (((struct ebt_entries *)e)->counter_offset != *totalcnt)
 			return -EINVAL;
-		}
 		*n = ((struct ebt_entries *)e)->nentries;
 		*cnt = 0;
 		return 0;
@@ -550,15 +534,13 @@ ebt_check_entry_size_and_hooks(const struct ebt_entry *e,
 	/* a plain old entry, heh */
 	if (sizeof(struct ebt_entry) > e->watchers_offset ||
 	   e->watchers_offset > e->target_offset ||
-	   e->target_offset >= e->next_offset) {
-		BUGPRINT("entry offsets not in right order\n");
+	   e->target_offset >= e->next_offset)
 		return -EINVAL;
-	}
+
 	/* this is not checked anywhere else */
-	if (e->next_offset - e->target_offset < sizeof(struct ebt_entry_target)) {
-		BUGPRINT("target size too small\n");
+	if (e->next_offset - e->target_offset < sizeof(struct ebt_entry_target))
 		return -EINVAL;
-	}
+
 	(*cnt)++;
 	(*totalcnt)++;
 	return 0;
@@ -678,18 +660,15 @@ ebt_check_entry(struct ebt_entry *e, struct net *net,
 	if (e->bitmask == 0)
 		return 0;
 
-	if (e->bitmask & ~EBT_F_MASK) {
-		BUGPRINT("Unknown flag for bitmask\n");
+	if (e->bitmask & ~EBT_F_MASK)
 		return -EINVAL;
-	}
-	if (e->invflags & ~EBT_INV_MASK) {
-		BUGPRINT("Unknown flag for inv bitmask\n");
+
+	if (e->invflags & ~EBT_INV_MASK)
 		return -EINVAL;
-	}
-	if ((e->bitmask & EBT_NOPROTO) && (e->bitmask & EBT_802_3)) {
-		BUGPRINT("NOPROTO & 802_3 not allowed\n");
+
+	if ((e->bitmask & EBT_NOPROTO) && (e->bitmask & EBT_802_3))
 		return -EINVAL;
-	}
+
 	/* what hook do we belong to? */
 	for (i = 0; i < NF_BR_NUMHOOKS; i++) {
 		if (!newinfo->hook_entry[i])
@@ -748,13 +727,11 @@ ebt_check_entry(struct ebt_entry *e, struct net *net,
 	t->u.target = target;
 	if (t->u.target == &ebt_standard_target) {
 		if (gap < sizeof(struct ebt_standard_target)) {
-			BUGPRINT("Standard target size too big\n");
 			ret = -EFAULT;
 			goto cleanup_watchers;
 		}
 		if (((struct ebt_standard_target *)t)->verdict <
 		   -NUM_STANDARD_TARGETS) {
-			BUGPRINT("Invalid standard target\n");
 			ret = -EFAULT;
 			goto cleanup_watchers;
 		}
@@ -813,10 +790,9 @@ static int check_chainloops(const struct ebt_entries *chain, struct ebt_cl_stack
 		if (strcmp(t->u.name, EBT_STANDARD_TARGET))
 			goto letscontinue;
 		if (e->target_offset + sizeof(struct ebt_standard_target) >
-		   e->next_offset) {
-			BUGPRINT("Standard target size too big\n");
+		   e->next_offset)
 			return -1;
-		}
+
 		verdict = ((struct ebt_standard_target *)t)->verdict;
 		if (verdict >= 0) { /* jump to another chain */
 			struct ebt_entries *hlp2 =
@@ -825,14 +801,12 @@ static int check_chainloops(const struct ebt_entries *chain, struct ebt_cl_stack
 				if (hlp2 == cl_s[i].cs.chaininfo)
 					break;
 			/* bad destination or loop */
-			if (i == udc_cnt) {
-				BUGPRINT("bad destination\n");
+			if (i == udc_cnt)
 				return -1;
-			}
-			if (cl_s[i].cs.n) {
-				BUGPRINT("loop\n");
+
+			if (cl_s[i].cs.n)
 				return -1;
-			}
+
 			if (cl_s[i].hookmask & (1 << hooknr))
 				goto letscontinue;
 			/* this can't be 0, so the loop test is correct */
@@ -865,24 +839,21 @@ static int translate_table(struct net *net, const char *name,
 	i = 0;
 	while (i < NF_BR_NUMHOOKS && !newinfo->hook_entry[i])
 		i++;
-	if (i == NF_BR_NUMHOOKS) {
-		BUGPRINT("No valid hooks specified\n");
+	if (i == NF_BR_NUMHOOKS)
 		return -EINVAL;
-	}
-	if (newinfo->hook_entry[i] != (struct ebt_entries *)newinfo->entries) {
-		BUGPRINT("Chains don't start at beginning\n");
+
+	if (newinfo->hook_entry[i] != (struct ebt_entries *)newinfo->entries)
 		return -EINVAL;
-	}
+
 	/* make sure chains are ordered after each other in same order
 	 * as their corresponding hooks
 	 */
 	for (j = i + 1; j < NF_BR_NUMHOOKS; j++) {
 		if (!newinfo->hook_entry[j])
 			continue;
-		if (newinfo->hook_entry[j] <= newinfo->hook_entry[i]) {
-			BUGPRINT("Hook order must be followed\n");
+		if (newinfo->hook_entry[j] <= newinfo->hook_entry[i])
 			return -EINVAL;
-		}
+
 		i = j;
 	}
 
@@ -900,15 +871,11 @@ static int translate_table(struct net *net, const char *name,
 	if (ret != 0)
 		return ret;
 
-	if (i != j) {
-		BUGPRINT("nentries does not equal the nr of entries in the "
-			 "(last) chain\n");
+	if (i != j)
 		return -EINVAL;
-	}
-	if (k != newinfo->nentries) {
-		BUGPRINT("Total nentries is wrong\n");
+
+	if (k != newinfo->nentries)
 		return -EINVAL;
-	}
 
 	/* get the location of the udc, put them in an array
 	 * while we're at it, allocate the chainstack
@@ -942,7 +909,6 @@ static int translate_table(struct net *net, const char *name,
 		   ebt_get_udc_positions, newinfo, &i, cl_s);
 		/* sanity check */
 		if (i != udc_cnt) {
-			BUGPRINT("i != udc_cnt\n");
 			vfree(cl_s);
 			return -EFAULT;
 		}
@@ -1042,7 +1008,6 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
 		goto free_unlock;
 
 	if (repl->num_counters && repl->num_counters != t->private->nentries) {
-		BUGPRINT("Wrong nr. of counters requested\n");
 		ret = -EINVAL;
 		goto free_unlock;
 	}
@@ -1118,15 +1083,12 @@ static int do_replace(struct net *net, const void __user *user,
 	if (copy_from_user(&tmp, user, sizeof(tmp)) != 0)
 		return -EFAULT;
 
-	if (len != sizeof(tmp) + tmp.entries_size) {
-		BUGPRINT("Wrong len argument\n");
+	if (len != sizeof(tmp) + tmp.entries_size)
 		return -EINVAL;
-	}
 
-	if (tmp.entries_size == 0) {
-		BUGPRINT("Entries_size never zero\n");
+	if (tmp.entries_size == 0)
 		return -EINVAL;
-	}
+
 	/* overflow check */
 	if (tmp.nentries >= ((INT_MAX - sizeof(struct ebt_table_info)) /
 			NR_CPUS - SMP_CACHE_BYTES) / sizeof(struct ebt_counter))
@@ -1153,7 +1115,6 @@ static int do_replace(struct net *net, const void __user *user,
 	}
 	if (copy_from_user(
 	   newinfo->entries, tmp.entries, tmp.entries_size) != 0) {
-		BUGPRINT("Couldn't copy entries from userspace\n");
 		ret = -EFAULT;
 		goto free_entries;
 	}
@@ -1194,10 +1155,8 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 
 	if (input_table == NULL || (repl = input_table->table) == NULL ||
 	    repl->entries == NULL || repl->entries_size == 0 ||
-	    repl->counters != NULL || input_table->private != NULL) {
-		BUGPRINT("Bad table data for ebt_register_table!!!\n");
+	    repl->counters != NULL || input_table->private != NULL)
 		return -EINVAL;
-	}
 
 	/* Don't add one table to multiple lists. */
 	table = kmemdup(input_table, sizeof(struct ebt_table), GFP_KERNEL);
@@ -1235,13 +1194,10 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 				((char *)repl->hook_entry[i] - repl->entries);
 	}
 	ret = translate_table(net, repl->name, newinfo);
-	if (ret != 0) {
-		BUGPRINT("Translate_table failed\n");
+	if (ret != 0)
 		goto free_chainstack;
-	}
 
 	if (table->check && table->check(newinfo, table->valid_hooks)) {
-		BUGPRINT("The table doesn't like its own initial data, lol\n");
 		ret = -EINVAL;
 		goto free_chainstack;
 	}
@@ -1252,7 +1208,6 @@ int ebt_register_table(struct net *net, const struct ebt_table *input_table,
 	list_for_each_entry(t, &net->xt.tables[NFPROTO_BRIDGE], list) {
 		if (strcmp(t->name, table->name) == 0) {
 			ret = -EEXIST;
-			BUGPRINT("Table name already exists\n");
 			goto free_unlock;
 		}
 	}
@@ -1320,7 +1275,6 @@ static int do_update_counters(struct net *net, const char *name,
 		goto free_tmp;
 
 	if (num_counters != t->private->nentries) {
-		BUGPRINT("Wrong nr of counters\n");
 		ret = -EINVAL;
 		goto unlock_mutex;
 	}
@@ -1447,10 +1401,8 @@ static int copy_counters_to_user(struct ebt_table *t,
 	if (num_counters == 0)
 		return 0;
 
-	if (num_counters != nentries) {
-		BUGPRINT("Num_counters wrong\n");
+	if (num_counters != nentries)
 		return -EINVAL;
-	}
 
 	counterstmp = vmalloc(array_size(nentries, sizeof(*counterstmp)));
 	if (!counterstmp)
@@ -1496,15 +1448,11 @@ static int copy_everything_to_user(struct ebt_table *t, void __user *user,
 	   (tmp.num_counters ? nentries * sizeof(struct ebt_counter) : 0))
 		return -EINVAL;
 
-	if (tmp.nentries != nentries) {
-		BUGPRINT("Nentries wrong\n");
+	if (tmp.nentries != nentries)
 		return -EINVAL;
-	}
 
-	if (tmp.entries_size != entries_size) {
-		BUGPRINT("Wrong size\n");
+	if (tmp.entries_size != entries_size)
 		return -EINVAL;
-	}
 
 	ret = copy_counters_to_user(t, oldcounters, tmp.counters,
 					tmp.num_counters, nentries);
@@ -1576,7 +1524,6 @@ static int do_ebt_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 		}
 		mutex_unlock(&ebt_mutex);
 		if (copy_to_user(user, &tmp, *len) != 0) {
-			BUGPRINT("c2u Didn't work\n");
 			ret = -EFAULT;
 			break;
 		}
-- 
2.11.0


