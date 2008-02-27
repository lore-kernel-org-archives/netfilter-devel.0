From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/05]: nf_conntrack: fix smp_processor_id() in preemptible code warning
Date: Wed, 27 Feb 2008 14:14:20 +0100 (MET)
Message-ID: <20080227131428.26831.70102.sendpatchset@localhost.localdomain>
References: <20080227131427.26831.51195.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53799 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756003AbYB0NOW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 08:14:22 -0500
In-Reply-To: <20080227131427.26831.51195.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: nf_conntrack: fix smp_processor_id() in preemptible code warning

Since we're using RCU for the conntrack hash now, we need to avoid
getting preempted or interrupted by BHs while changing the stats.

Fixes warning reported by Tilman Schmidt <tilman@imap.cc> when using
preemptible RCU:

[   48.180297] BUG: using smp_processor_id() in preemptible [00000000] code: ntpdate/3562
[   48.180297] caller is __nf_conntrack_find+0x9b/0xeb [nf_conntrack]
[   48.180297] Pid: 3562, comm: ntpdate Not tainted 2.6.25-rc2-mm1-testing #1
[   48.180297]  [<c02015b9>] debug_smp_processor_id+0x99/0xb0
[   48.180297]  [<fac643a7>] __nf_conntrack_find+0x9b/0xeb [nf_conntrack]

Tested-by: Tilman Schmidt <tilman@imap.cc>
Tested-by: Christian Casteyde <casteyde.christian@free.fr> [Bugzilla #10097]

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 2ffa8857857148a5b0c0823852d6cb2551a3ae5a
tree 62ff238b8f59b581332c36f703eb4a8878377fae
parent fccf186fa8fba308f4a478691e86399336488dd1
author Patrick McHardy <kaber@trash.net> Wed, 27 Feb 2008 13:23:55 +0100
committer Patrick McHardy <kaber@trash.net> Wed, 27 Feb 2008 13:23:55 +0100

 net/netfilter/nf_conntrack_core.c |   15 ++++++++++++---
 1 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 327e847..b77eb56 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -256,13 +256,19 @@ __nf_conntrack_find(const struct nf_conntrack_tuple *tuple)
 	struct hlist_node *n;
 	unsigned int hash = hash_conntrack(tuple);
 
+	/* Disable BHs the entire time since we normally need to disable them
+	 * at least once for the stats anyway.
+	 */
+	local_bh_disable();
 	hlist_for_each_entry_rcu(h, n, &nf_conntrack_hash[hash], hnode) {
 		if (nf_ct_tuple_equal(tuple, &h->tuple)) {
 			NF_CT_STAT_INC(found);
+			local_bh_enable();
 			return h;
 		}
 		NF_CT_STAT_INC(searched);
 	}
+	local_bh_enable();
 
 	return NULL;
 }
@@ -400,17 +406,20 @@ nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
 	struct hlist_node *n;
 	unsigned int hash = hash_conntrack(tuple);
 
-	rcu_read_lock();
+	/* Disable BHs the entire time since we need to disable them at
+	 * least once for the stats anyway.
+	 */
+	rcu_read_lock_bh();
 	hlist_for_each_entry_rcu(h, n, &nf_conntrack_hash[hash], hnode) {
 		if (nf_ct_tuplehash_to_ctrack(h) != ignored_conntrack &&
 		    nf_ct_tuple_equal(tuple, &h->tuple)) {
 			NF_CT_STAT_INC(found);
-			rcu_read_unlock();
+			rcu_read_unlock_bh();
 			return 1;
 		}
 		NF_CT_STAT_INC(searched);
 	}
-	rcu_read_unlock();
+	rcu_read_unlock_bh();
 
 	return 0;
 }
