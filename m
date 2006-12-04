From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 02/03]: Fix iptables compat hook validation
Date: Mon,  4 Dec 2006 12:22:09 +0100 (MET)
Message-ID: <20061204112518.14395.5648.sendpatchset@localhost.localdomain>
References: <20061204112515.14395.20257.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>,
	davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: stable@kernel.org
In-Reply-To: <20061204112515.14395.20257.sendpatchset@localhost.localdomain>
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

[NETFILTER]: Fix iptables compat hook validation

In compat mode, matches and targets valid hooks checks always successful due
to not initialized e->comefrom field yet. This patch separates this checks from
translation code and moves them after mark_source_chains() call, where these
marks are initialized.

Signed-off-by: Dmitry Mishin <dim@openvz.org>
Signed-off-by; Patrick McHardy <kaber@trash.net>

---
commit 14f5487cb9bd34cd59360d2cac7dccac9b27e8ce
tree fab7cabcdb7fe450ff47bf42918f845ff3da1b86
parent 756c508367e95d6f963502e4feecb8c76aeee332
author Dmitry Mishin <dim@openvz.org> Mon, 04 Dec 2006 12:19:35 +0100
committer Patrick McHardy <kaber@trash.net> Mon, 04 Dec 2006 12:19:35 +0100

 net/ipv4/netfilter/ip_tables.c |   78 ++++++++++++++++++++++++++--------------
 1 files changed, 51 insertions(+), 27 deletions(-)

diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 2bddf84..0ff2956 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -1516,25 +1516,8 @@ static inline int compat_copy_match_from
 	void **dstptr, compat_uint_t *size, const char *name,
 	const struct ipt_ip *ip, unsigned int hookmask)
 {
-	struct ipt_entry_match *dm;
-	struct ipt_match *match;
-	int ret;
-
-	dm = (struct ipt_entry_match *)*dstptr;
-	match = m->u.kernel.match;
 	xt_compat_match_from_user(m, dstptr, size);
-
-	ret = xt_check_match(match, AF_INET, dm->u.match_size - sizeof(*dm),
-			     name, hookmask, ip->proto,
-			     ip->invflags & IPT_INV_PROTO);
-	if (!ret && m->u.kernel.match->checkentry
-	    && !m->u.kernel.match->checkentry(name, ip, match, dm->data,
-					      hookmask)) {
-		duprintf("ip_tables: check failed for `%s'.\n",
-			 m->u.kernel.match->name);
-		ret = -EINVAL;
-	}
-	return ret;
+	return 0;
 }
 
 static int compat_copy_entry_from_user(struct ipt_entry *e, void **dstptr,
@@ -1556,7 +1539,7 @@ static int compat_copy_entry_from_user(s
 	ret = IPT_MATCH_ITERATE(e, compat_copy_match_from_user, dstptr, size,
 			name, &de->ip, de->comefrom);
 	if (ret)
-		goto err;
+		return ret;
 	de->target_offset = e->target_offset - (origsize - *size);
 	t = ipt_get_target(e);
 	target = t->u.kernel.target;
@@ -1569,26 +1552,62 @@ static int compat_copy_entry_from_user(s
 		if ((unsigned char *)de - base < newinfo->underflow[h])
 			newinfo->underflow[h] -= origsize - *size;
 	}
+	return ret;
+}
+
+static inline int compat_check_match(struct ipt_entry_match *m, const char *name,
+				const struct ipt_ip *ip, unsigned int hookmask)
+{
+	struct ipt_match *match;
+	int ret;
+
+	match = m->u.kernel.match;
+	ret = xt_check_match(match, AF_INET, m->u.match_size - sizeof(*m),
+			     name, hookmask, ip->proto,
+			     ip->invflags & IPT_INV_PROTO);
+	if (!ret && m->u.kernel.match->checkentry
+	    && !m->u.kernel.match->checkentry(name, ip, match, m->data,
+					      hookmask)) {
+		duprintf("ip_tables: compat: check failed for `%s'.\n",
+			 m->u.kernel.match->name);
+		ret = -EINVAL;
+	}
+	return ret;
+}
+
+static inline int compat_check_target(struct ipt_entry *e, const char *name)
+{
+ 	struct ipt_entry_target *t;
+ 	struct ipt_target *target;
+ 	int ret;
 
-	t = ipt_get_target(de);
+	t = ipt_get_target(e);
 	target = t->u.kernel.target;
 	ret = xt_check_target(target, AF_INET, t->u.target_size - sizeof(*t),
 			      name, e->comefrom, e->ip.proto,
 			      e->ip.invflags & IPT_INV_PROTO);
-	if (ret)
-		goto err;
-
-	if (t->u.kernel.target->checkentry
-		   && !t->u.kernel.target->checkentry(name, de, target,
-						      t->data, de->comefrom)) {
+	if (!ret && t->u.kernel.target->checkentry
+		   && !t->u.kernel.target->checkentry(name, e, target,
+						      t->data, e->comefrom)) {
 		duprintf("ip_tables: compat: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
 		ret = -EINVAL;
 	}
-err:
 	return ret;
 }
 
+static inline int compat_check_entry(struct ipt_entry *e, const char *name)
+{
+	int ret;
+
+	ret = IPT_MATCH_ITERATE(e, compat_check_match, name, &e->ip,
+								e->comefrom);
+	if (ret)
+		return ret;
+
+	return compat_check_target(e, name);
+}
+
 static int
 translate_compat_table(const char *name,
 		unsigned int valid_hooks,
@@ -1677,6 +1696,11 @@ translate_compat_table(const char *name,
 	if (!mark_source_chains(newinfo, valid_hooks, entry1))
 		goto free_newinfo;
 
+	ret = IPT_ENTRY_ITERATE(entry1, newinfo->size, compat_check_entry,
+									name);
+	if (ret)
+		goto free_newinfo;
+
 	/* And one copy for every other CPU */
 	for_each_possible_cpu(i)
 		if (newinfo->entries[i] && newinfo->entries[i] != entry1)
