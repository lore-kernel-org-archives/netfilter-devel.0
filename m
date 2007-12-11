From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/02]: ip_tables: fix compat copy race
Date: Tue, 11 Dec 2007 18:42:11 +0100 (MET)
Message-ID: <20071211174208.1042.41041.sendpatchset@localhost.localdomain>
References: <20071211174205.1042.29518.sendpatchset@localhost.localdomain>
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:53977 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbXLKRmM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Dec 2007 12:42:12 -0500
In-Reply-To: <20071211174205.1042.29518.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

[NETFILTER]: ip_tables: fix compat copy race

When copying entries to user, the kernel makes two passes through the
data, first copying all the entries, then fixing up names and counters.
On the second pass it copies the kernel and match data from userspace
to the kernel again to find the corresponding structures, expecting
that kernel pointers contained in the data are still valid.

This is obviously broken, fix by avoiding the second pass completely
and fixing names and counters while dumping the ruleset, using the
kernel-internal data structures.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 060d71fa0ce1d805708890701e55a40b1f15d4a7
tree ca0488fb9ec5b7c3a1f22dc851ab26f989641138
parent 4e5080caf7901c74983fcd47af4b2789bcf9fb1c
author Patrick McHardy <kaber@trash.net> Tue, 11 Dec 2007 18:24:45 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 11 Dec 2007 18:24:45 +0100

 net/ipv4/netfilter/ip_tables.c |   57 ++++++++--------------------------------
 net/netfilter/x_tables.c       |    8 ++++--
 2 files changed, 18 insertions(+), 47 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 4b10b98..b9b189c 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1492,8 +1492,10 @@ static inline int compat_copy_match_to_user(struct ipt_entry_match *m,
 	return xt_compat_match_to_user(m, dstptr, size);
 }
 
-static int compat_copy_entry_to_user(struct ipt_entry *e,
-		void __user **dstptr, compat_uint_t *size)
+static int
+compat_copy_entry_to_user(struct ipt_entry *e, void __user **dstptr,
+			  compat_uint_t *size, struct xt_counters *counters,
+			  unsigned int *i)
 {
 	struct ipt_entry_target *t;
 	struct compat_ipt_entry __user *ce;
@@ -1507,6 +1509,9 @@ static int compat_copy_entry_to_user(struct ipt_entry *e,
 	if (copy_to_user(ce, e, sizeof(struct ipt_entry)))
 		goto out;
 
+	if (copy_to_user(&ce->counters, &counters[*i], sizeof(counters[*i])))
+		goto out;
+
 	*dstptr += sizeof(struct compat_ipt_entry);
 	ret = IPT_MATCH_ITERATE(e, compat_copy_match_to_user, dstptr, size);
 	target_offset = e->target_offset - (origsize - *size);
@@ -1522,6 +1527,8 @@ static int compat_copy_entry_to_user(struct ipt_entry *e,
 		goto out;
 	if (put_user(next_offset, &ce->next_offset))
 		goto out;
+
+	(*i)++;
 	return 0;
 out:
 	return ret;
@@ -1937,14 +1944,13 @@ struct compat_ipt_get_entries
 static int compat_copy_entries_to_user(unsigned int total_size,
 		     struct xt_table *table, void __user *userptr)
 {
-	unsigned int off, num;
-	struct compat_ipt_entry e;
 	struct xt_counters *counters;
 	struct xt_table_info *private = table->private;
 	void __user *pos;
 	unsigned int size;
 	int ret = 0;
 	void *loc_cpu_entry;
+	unsigned int i = 0;
 
 	counters = alloc_counters(table);
 	if (IS_ERR(counters))
@@ -1958,48 +1964,9 @@ static int compat_copy_entries_to_user(unsigned int total_size,
 	pos = userptr;
 	size = total_size;
 	ret = IPT_ENTRY_ITERATE(loc_cpu_entry, total_size,
-			compat_copy_entry_to_user, &pos, &size);
-	if (ret)
-		goto free_counters;
-
-	/* ... then go back and fix counters and names */
-	for (off = 0, num = 0; off < size; off += e.next_offset, num++) {
-		unsigned int i;
-		struct ipt_entry_match m;
-		struct ipt_entry_target t;
+				compat_copy_entry_to_user,
+				&pos, &size, counters, &i);
 
-		ret = -EFAULT;
-		if (copy_from_user(&e, userptr + off,
-					sizeof(struct compat_ipt_entry)))
-			goto free_counters;
-		if (copy_to_user(userptr + off +
-			offsetof(struct compat_ipt_entry, counters),
-			 &counters[num], sizeof(counters[num])))
-			goto free_counters;
-
-		for (i = sizeof(struct compat_ipt_entry);
-				i < e.target_offset; i += m.u.match_size) {
-			if (copy_from_user(&m, userptr + off + i,
-					sizeof(struct ipt_entry_match)))
-				goto free_counters;
-			if (copy_to_user(userptr + off + i +
-				offsetof(struct ipt_entry_match, u.user.name),
-				m.u.kernel.match->name,
-				strlen(m.u.kernel.match->name) + 1))
-				goto free_counters;
-		}
-
-		if (copy_from_user(&t, userptr + off + e.target_offset,
-					sizeof(struct ipt_entry_target)))
-			goto free_counters;
-		if (copy_to_user(userptr + off + e.target_offset +
-			offsetof(struct ipt_entry_target, u.user.name),
-			t.u.kernel.target->name,
-			strlen(t.u.kernel.target->name) + 1))
-			goto free_counters;
-	}
-	ret = 0;
-free_counters:
 	vfree(counters);
 	return ret;
 }
diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index d9a3bde..b6160e4 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -377,7 +377,9 @@ int xt_compat_match_to_user(struct xt_entry_match *m, void __user **dstptr,
 	u_int16_t msize = m->u.user.match_size - off;
 
 	if (copy_to_user(cm, m, sizeof(*cm)) ||
-	    put_user(msize, &cm->u.user.match_size))
+	    put_user(msize, &cm->u.user.match_size) ||
+	    copy_to_user(cm->u.user.name, m->u.kernel.match->name,
+			 strlen(m->u.kernel.match->name) + 1))
 		return -EFAULT;
 
 	if (match->compat_to_user) {
@@ -468,7 +470,9 @@ int xt_compat_target_to_user(struct xt_entry_target *t, void __user **dstptr,
 	u_int16_t tsize = t->u.user.target_size - off;
 
 	if (copy_to_user(ct, t, sizeof(*ct)) ||
-	    put_user(tsize, &ct->u.user.target_size))
+	    put_user(tsize, &ct->u.user.target_size) ||
+	    copy_to_user(ct->u.user.name, t->u.kernel.target->name,
+			 strlen(t->u.kernel.target->name) + 1))
 		return -EFAULT;
 
 	if (target->compat_to_user) {
