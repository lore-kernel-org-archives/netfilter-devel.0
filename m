From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 3/7] netfilter: ebtables: split update_counters into two functions
Date: Mon, 15 Feb 2010 22:05:35 +0100
Message-ID: <1266267939-7736-4-git-send-email-fw@strlen.de>
References: <1266267939-7736-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([85.10.199.196]:33312 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932089Ab0BOVGu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Feb 2010 16:06:50 -0500
In-Reply-To: <1266267939-7736-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

allows to call do_update_counters() from upcoming CONFIG_COMPAT
code instead of copy&pasting the same code.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/bridge/netfilter/ebtables.c |   40 +++++++++++++++++++++++---------------
 1 files changed, 24 insertions(+), 16 deletions(-)

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 8f3529a..495b2ea 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -1241,38 +1241,31 @@ void ebt_unregister_table(struct net *net, struct ebt_table *table)
 }
 
 /* userspace just supplied us with counters */
-static int update_counters(struct net *net, const void __user *user,
-			   unsigned int len)
+static int do_update_counters(struct net *net, const char *name,
+                              struct ebt_counter __user *counters, unsigned int num_counters,
+                              const void __user *user, unsigned int len)
 {
 	int i, ret;
 	struct ebt_counter *tmp;
-	struct ebt_replace hlp;
 	struct ebt_table *t;
 
-	if (copy_from_user(&hlp, user, sizeof(hlp)))
-		return -EFAULT;
-
-	if (len != sizeof(hlp) + hlp.num_counters * sizeof(struct ebt_counter))
-		return -EINVAL;
-	if (hlp.num_counters == 0)
+	if (num_counters == 0)
 		return -EINVAL;
 
-	if (!(tmp = vmalloc(hlp.num_counters * sizeof(*tmp))))
+	if (!(tmp = vmalloc(num_counters * sizeof(*tmp))))
 		return -ENOMEM;
 
-	t = find_table_lock(net, hlp.name, &ret, &ebt_mutex);
+	t = find_table_lock(net, name, &ret, &ebt_mutex);
 	if (!t)
 		goto free_tmp;
 
-	if (hlp.num_counters != t->private->nentries) {
+	if (num_counters != t->private->nentries) {
 		BUGPRINT("Wrong nr of counters\n");
 		ret = -EINVAL;
 		goto unlock_mutex;
 	}
 
-	if ( copy_from_user(tmp, hlp.counters,
-	   hlp.num_counters * sizeof(struct ebt_counter)) ) {
-		BUGPRINT("Updata_counters && !cfu\n");
+	if (copy_from_user(tmp, counters, num_counters * sizeof(*counters))) {
 		ret = -EFAULT;
 		goto unlock_mutex;
 	}
@@ -1281,7 +1274,7 @@ static int update_counters(struct net *net, const void __user *user,
 	write_lock_bh(&t->lock);
 
 	/* we add to the counters of the first cpu */
-	for (i = 0; i < hlp.num_counters; i++) {
+	for (i = 0; i < num_counters; i++) {
 		t->private->counters[i].pcnt += tmp[i].pcnt;
 		t->private->counters[i].bcnt += tmp[i].bcnt;
 	}
@@ -1295,6 +1288,21 @@ free_tmp:
 	return ret;
 }
 
+static int update_counters(struct net *net, const void __user *user,
+                           unsigned int len)
+{
+	struct ebt_replace hlp;
+
+	if (copy_from_user(&hlp, user, sizeof(hlp)))
+		return -EFAULT;
+
+	if (len != sizeof(hlp) + hlp.num_counters * sizeof(struct ebt_counter))
+		return -EINVAL;
+
+	return do_update_counters(net, hlp.name, hlp.counters,
+				hlp.num_counters, user, len);
+}
+
 static inline int ebt_make_matchname(const struct ebt_entry_match *m,
     const char *base, char __user *ubase)
 {
-- 
1.6.4.4

