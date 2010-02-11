From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 05/10] netfilter: ebtables: split copy_everything_to_user into two functions
Date: Thu, 11 Feb 2010 15:12:35 +0100
Message-ID: <1265897559-10610-6-git-send-email-fw@strlen.de>
References: <1265897559-10610-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:53719 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752381Ab0BKOMn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 09:12:43 -0500
In-Reply-To: <1265897559-10610-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

once CONFIG_COMPAT support is added to ebtables, the new
copy_counters_to_user function can be called instead of duplicating
code.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 patch was not present in v1 patch series.

 net/bridge/netfilter/ebtables.c |   62 ++++++++++++++++++++++++---------------
 1 files changed, 38 insertions(+), 24 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index c506581..c32ec11 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1340,14 +1340,47 @@ static inline int ebt_make_names(struct ebt_entry *e, char *base, char __user *u
 	return 0;
 }
 
+static int copy_counters_to_user(struct ebt_table *t, struct ebt_counter *oldcounters,
+                                 void __user *user, unsigned int num_counters,
+                                 unsigned int nentries)
+{
+	struct ebt_counter *counterstmp;
+	int ret = 0;
+
+	/* userspace might not need the counters */
+	if (num_counters == 0)
+		return 0;
+
+	if (num_counters != nentries) {
+		BUGPRINT("Num_counters wrong\n");
+		return -EINVAL;
+	}
+
+	counterstmp = vmalloc(nentries * sizeof(*counterstmp));
+	if (!counterstmp) {
+		MEMPRINT("Couldn't copy counters, out of memory\n");
+		return -ENOMEM;
+	}
+	write_lock_bh(&t->lock);
+	get_counters(oldcounters, counterstmp, nentries);
+	write_unlock_bh(&t->lock);
+
+	if (copy_to_user(user, counterstmp,
+	   nentries * sizeof(struct ebt_counter)))
+		ret = -EFAULT;
+	vfree(counterstmp);
+	return ret;
+}
+
 /* called with ebt_mutex locked */
 static int copy_everything_to_user(struct ebt_table *t, void __user *user,
    int *len, int cmd)
 {
 	struct ebt_replace tmp;
-	struct ebt_counter *counterstmp, *oldcounters;
+	struct ebt_counter *oldcounters;
 	unsigned int entries_size, nentries;
 	char *entries;
+	int ret;
 
 	if (cmd == EBT_SO_GET_ENTRIES) {
 		entries_size = t->private->entries_size;
@@ -1382,29 +1415,10 @@ static int copy_everything_to_user(struct ebt_table *t, void __user *user,
 		return -EINVAL;
 	}
 
-	/* userspace might not need the counters */
-	if (tmp.num_counters) {
-		if (tmp.num_counters != nentries) {
-			BUGPRINT("Num_counters wrong\n");
-			return -EINVAL;
-		}
-		counterstmp = vmalloc(nentries * sizeof(*counterstmp));
-		if (!counterstmp) {
-			MEMPRINT("Couldn't copy counters, out of memory\n");
-			return -ENOMEM;
-		}
-		write_lock_bh(&t->lock);
-		get_counters(oldcounters, counterstmp, nentries);
-		write_unlock_bh(&t->lock);
-
-		if (copy_to_user(tmp.counters, counterstmp,
-		   nentries * sizeof(struct ebt_counter))) {
-			BUGPRINT("Couldn't copy counters to userspace\n");
-			vfree(counterstmp);
-			return -EFAULT;
-		}
-		vfree(counterstmp);
-	}
+	ret = copy_counters_to_user(t, oldcounters, tmp.counters,
+					tmp.num_counters, nentries);
+	if (ret)
+		return ret;
 
 	if (copy_to_user(tmp.entries, entries, entries_size)) {
 		BUGPRINT("Couldn't copy entries to userspace\n");
-- 
1.6.3.3

