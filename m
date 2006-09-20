From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 17/39]: ip_tables: fix module refcount leaks in compat
	error paths
Date: Wed, 20 Sep 2006 10:24:13 +0200 (MEST)
Message-ID: <20060920082504.14636.52638.sendpatchset@localhost.localdomain>
References: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: davem@davemloft.net
In-Reply-To: <20060920082442.14636.6806.sendpatchset@localhost.localdomain>
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

[NETFILTER]: ip_tables: fix module refcount leaks in compat error paths

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 6f432129cbce18fb8d5de208e49552dcc473b4be
tree 57d41f85a2b8a2334d481a7fcd8ff13c137561a0
parent 850a4981b57001c022d4b69a24d163404823ddb3
author Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:36:19 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 20 Sep 2006 09:36:19 +0200

 net/ipv4/netfilter/ip_tables.c |   39 +++++++++++++++++++++++++++------------
 1 files changed, 27 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 38e1e4f..3d5d4a4 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1529,7 +1529,7 @@ check_compat_entry_size_and_hooks(struct
 	ret = IPT_MATCH_ITERATE(e, compat_check_calc_match, name, &e->ip,
 			e->comefrom, &off, &j);
 	if (ret != 0)
-		goto out;
+		goto cleanup_matches;
 
 	t = ipt_get_target(e);
 	target = try_then_request_module(xt_find_target(AF_INET,
@@ -1539,7 +1539,7 @@ check_compat_entry_size_and_hooks(struct
 	if (IS_ERR(target) || !target) {
 		duprintf("check_entry: `%s' not found\n", t->u.user.name);
 		ret = target ? PTR_ERR(target) : -ENOENT;
-		goto out;
+		goto cleanup_matches;
 	}
 	t->u.kernel.target = target;
 
@@ -1566,14 +1566,17 @@ check_compat_entry_size_and_hooks(struct
 
 	(*i)++;
 	return 0;
+
 out:
+	module_put(t->u.kernel.target->me);
+cleanup_matches:
 	IPT_MATCH_ITERATE(e, cleanup_match, &j);
 	return ret;
 }
 
 static inline int compat_copy_match_from_user(struct ipt_entry_match *m,
 	void **dstptr, compat_uint_t *size, const char *name,
-	const struct ipt_ip *ip, unsigned int hookmask)
+	const struct ipt_ip *ip, unsigned int hookmask, int *i)
 {
 	struct ipt_entry_match *dm;
 	struct ipt_match *match;
@@ -1590,16 +1593,22 @@ static inline int compat_copy_match_from
 			     name, hookmask, ip->proto,
 			     ip->invflags & IPT_INV_PROTO);
 	if (ret)
-		return ret;
+		goto err;
 
 	if (m->u.kernel.match->checkentry
 	    && !m->u.kernel.match->checkentry(name, ip, match, dm->data,
 					      hookmask)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
 			 m->u.kernel.match->name);
-		return -EINVAL;
+		ret = -EINVAL;
+		goto err;
 	}
+	(*i)++;
 	return 0;
+
+err:
+	module_put(m->u.kernel.match->me);
+	return ret;
 }
 
 static int compat_copy_entry_from_user(struct ipt_entry *e, void **dstptr,
@@ -1610,18 +1619,19 @@ static int compat_copy_entry_from_user(s
 	struct ipt_target *target;
 	struct ipt_entry *de;
 	unsigned int origsize;
-	int ret, h;
+	int ret, h, j;
 
 	ret = 0;
 	origsize = *size;
 	de = (struct ipt_entry *)*dstptr;
 	memcpy(de, e, sizeof(struct ipt_entry));
 
+	j = 0;
 	*dstptr += sizeof(struct compat_ipt_entry);
 	ret = IPT_MATCH_ITERATE(e, compat_copy_match_from_user, dstptr, size,
-			name, &de->ip, de->comefrom);
+			name, &de->ip, de->comefrom, &j);
 	if (ret)
-		goto out;
+		goto cleanup_matches;
 	de->target_offset = e->target_offset - (origsize - *size);
 	t = ipt_get_target(e);
 	target = t->u.kernel.target;
@@ -1644,21 +1654,26 @@ static int compat_copy_entry_from_user(s
 			      name, e->comefrom, e->ip.proto,
 			      e->ip.invflags & IPT_INV_PROTO);
 	if (ret)
-		goto out;
+		goto err;
 
 	ret = -EINVAL;
 	if (t->u.kernel.target == &ipt_standard_target) {
 		if (!standard_check(t, *size))
-			goto out;
+			goto err;
 	} else if (t->u.kernel.target->checkentry
 		   && !t->u.kernel.target->checkentry(name, de, target,
 						      t->data, de->comefrom)) {
 		duprintf("ip_tables: compat: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
-		goto out;
+		goto err;
 	}
 	ret = 0;
-out:
+	return ret;
+
+err:
+	module_put(t->u.kernel.target->me);
+cleanup_matches:
+	IPT_MATCH_ITERATE(e, cleanup_match, &j);
 	return ret;
 }
 
