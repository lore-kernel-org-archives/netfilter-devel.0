From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: Fix {ip,ip6,arp}_tables hook validation
Date: Tue, 21 Nov 2006 11:30:50 +0100
Message-ID: <4562D55A.4060004@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010309040607030709010502"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------010309040607030709010502
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

This patch fixes a regression from the "[NETFILTER]: Missed and
reordered checks in iptables" patch. I'll send a new backport
to the -stable guys as well.

Please apply, thanks.



--------------010309040607030709010502
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: Fix {ip,ip6,arp}_tables hook validation

Commit 590bdf7fd2292b47c428111cb1360e312eff207e introduced a regression
in match/target hook validation. mark_source_chains builds a bitmask
for each rule representing the hooks it can be reached from, which is
then used by the matches and targets to make sure they are only called
from valid hooks. The patch moved the match/target specific validation
before the mark_source_chains call, at which point the mask is always zero.

This patch returns back to the old order and moves the standard checks
to mark_source_chains. This allows to get rid of a special case for
standard targets as a nice side-effect.

Signed-off-by: Dmitry Mishin <dim@openvz.org>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b8a25b3ee8cbef39ebfcd7028c09ed6cd76b1488
tree 927db35a9e29098e01117be2e4ebef3663f6deb2
parent 3b8b1fc76b8f4d2f491d565cb56eb482da8c5007
author Dmitry Mishin <dim@openvz.org> Tue, 21 Nov 2006 10:59:00 +0100
committer Patrick McHardy <kaber@trash.net> Tue, 21 Nov 2006 11:26:09 +0100

 net/ipv4/netfilter/arp_tables.c |   48 ++++++++++++++--------------
 net/ipv4/netfilter/ip_tables.c  |   68 ++++++++++++++-------------------------
 net/ipv6/netfilter/ip6_tables.c |   59 +++++++++++++---------------------
 3 files changed, 72 insertions(+), 103 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 413c2d0..71b76ad 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -375,6 +375,13 @@ static int mark_source_chains(struct xt_
 			    && unconditional(&e->arp)) {
 				unsigned int oldpos, size;
 
+				if (t->verdict < -NF_MAX_VERDICT - 1) {
+					duprintf("mark_source_chains: bad "
+						"negative verdict (%i)\n",
+								t->verdict);
+					return 0;
+				}
+
 				/* Return: backtrack through the last
 				 * big jump.
 				 */
@@ -404,6 +411,14 @@ static int mark_source_chains(struct xt_
 				if (strcmp(t->target.u.user.name,
 					   ARPT_STANDARD_TARGET) == 0
 				    && newpos >= 0) {
+					if (newpos > newinfo->size -
+						sizeof(struct arpt_entry)) {
+						duprintf("mark_source_chains: "
+							"bad verdict (%i)\n",
+								newpos);
+						return 0;
+					}
+
 					/* This a jump; chase it. */
 					duprintf("Jump rule %u -> %u\n",
 						 pos, newpos);
@@ -426,8 +441,6 @@ static int mark_source_chains(struct xt_
 static inline int standard_check(const struct arpt_entry_target *t,
 				 unsigned int max_offset)
 {
-	struct arpt_standard_target *targ = (void *)t;
-
 	/* Check standard info. */
 	if (t->u.target_size
 	    != ARPT_ALIGN(sizeof(struct arpt_standard_target))) {
@@ -437,18 +450,6 @@ static inline int standard_check(const s
 		return 0;
 	}
 
-	if (targ->verdict >= 0
-	    && targ->verdict > max_offset - sizeof(struct arpt_entry)) {
-		duprintf("arpt_standard_check: bad verdict (%i)\n",
-			 targ->verdict);
-		return 0;
-	}
-
-	if (targ->verdict < -NF_MAX_VERDICT - 1) {
-		duprintf("arpt_standard_check: bad negative verdict (%i)\n",
-			 targ->verdict);
-		return 0;
-	}
 	return 1;
 }
 
@@ -627,18 +628,20 @@ static int translate_table(const char *n
 		}
 	}
 
+	if (!mark_source_chains(newinfo, valid_hooks, entry0)) {
+		duprintf("Looping hook\n");
+		return -ELOOP;
+	}
+
 	/* Finally, each sanity check must pass */
 	i = 0;
 	ret = ARPT_ENTRY_ITERATE(entry0, newinfo->size,
 				 check_entry, name, size, &i);
 
-	if (ret != 0)
-		goto cleanup;
-
-	ret = -ELOOP;
-	if (!mark_source_chains(newinfo, valid_hooks, entry0)) {
-		duprintf("Looping hook\n");
-		goto cleanup;
+	if (ret != 0) {
+		ARPT_ENTRY_ITERATE(entry0, newinfo->size,
+				cleanup_entry, &i);
+		return ret;
 	}
 
 	/* And one copy for every other CPU */
@@ -647,9 +650,6 @@ static int translate_table(const char *n
 			memcpy(newinfo->entries[i], entry0, newinfo->size);
 	}
 
-	return 0;
-cleanup:
-	ARPT_ENTRY_ITERATE(entry0, newinfo->size, cleanup_entry, &i);
 	return ret;
 }
 
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 8a45543..2bddf84 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -401,6 +401,13 @@ mark_source_chains(struct xt_table_info 
 			    && unconditional(&e->ip)) {
 				unsigned int oldpos, size;
 
+				if (t->verdict < -NF_MAX_VERDICT - 1) {
+					duprintf("mark_source_chains: bad "
+						"negative verdict (%i)\n",
+								t->verdict);
+					return 0;
+				}
+
 				/* Return: backtrack through the last
 				   big jump. */
 				do {
@@ -438,6 +445,13 @@ #endif
 				if (strcmp(t->target.u.user.name,
 					   IPT_STANDARD_TARGET) == 0
 				    && newpos >= 0) {
+					if (newpos > newinfo->size -
+						sizeof(struct ipt_entry)) {
+						duprintf("mark_source_chains: "
+							"bad verdict (%i)\n",
+								newpos);
+						return 0;
+					}
 					/* This a jump; chase it. */
 					duprintf("Jump rule %u -> %u\n",
 						 pos, newpos);
@@ -470,27 +484,6 @@ cleanup_match(struct ipt_entry_match *m,
 }
 
 static inline int
-standard_check(const struct ipt_entry_target *t,
-	       unsigned int max_offset)
-{
-	struct ipt_standard_target *targ = (void *)t;
-
-	/* Check standard info. */
-	if (targ->verdict >= 0
-	    && targ->verdict > max_offset - sizeof(struct ipt_entry)) {
-		duprintf("ipt_standard_check: bad verdict (%i)\n",
-			 targ->verdict);
-		return 0;
-	}
-	if (targ->verdict < -NF_MAX_VERDICT - 1) {
-		duprintf("ipt_standard_check: bad negative verdict (%i)\n",
-			 targ->verdict);
-		return 0;
-	}
-	return 1;
-}
-
-static inline int
 check_match(struct ipt_entry_match *m,
 	    const char *name,
 	    const struct ipt_ip *ip,
@@ -576,12 +569,7 @@ check_entry(struct ipt_entry *e, const c
 	if (ret)
 		goto err;
 
-	if (t->u.kernel.target == &ipt_standard_target) {
-		if (!standard_check(t, size)) {
-			ret = -EINVAL;
-			goto err;
-		}
-	} else if (t->u.kernel.target->checkentry
+	if (t->u.kernel.target->checkentry
 		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
 						      e->comefrom)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
@@ -718,17 +706,19 @@ translate_table(const char *name,
 		}
 	}
 
+	if (!mark_source_chains(newinfo, valid_hooks, entry0))
+		return -ELOOP;
+
 	/* Finally, each sanity check must pass */
 	i = 0;
 	ret = IPT_ENTRY_ITERATE(entry0, newinfo->size,
 				check_entry, name, size, &i);
 
-	if (ret != 0)
-		goto cleanup;
-
-	ret = -ELOOP;
-	if (!mark_source_chains(newinfo, valid_hooks, entry0))
-		goto cleanup;
+	if (ret != 0) {
+		IPT_ENTRY_ITERATE(entry0, newinfo->size,
+				cleanup_entry, &i);
+		return ret;
+	}
 
 	/* And one copy for every other CPU */
 	for_each_possible_cpu(i) {
@@ -736,9 +726,6 @@ translate_table(const char *name,
 			memcpy(newinfo->entries[i], entry0, newinfo->size);
 	}
 
-	return 0;
-cleanup:
-	IPT_ENTRY_ITERATE(entry0, newinfo->size, cleanup_entry, &i);
 	return ret;
 }
 
@@ -1591,18 +1578,13 @@ static int compat_copy_entry_from_user(s
 	if (ret)
 		goto err;
 
-	ret = -EINVAL;
-	if (t->u.kernel.target == &ipt_standard_target) {
-		if (!standard_check(t, *size))
-			goto err;
-	} else if (t->u.kernel.target->checkentry
+	if (t->u.kernel.target->checkentry
 		   && !t->u.kernel.target->checkentry(name, de, target,
 						      t->data, de->comefrom)) {
 		duprintf("ip_tables: compat: check failed for `%s'.\n",
 			 t->u.kernel.target->name);
-		goto err;
+		ret = -EINVAL;
 	}
-	ret = 0;
 err:
 	return ret;
 }
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 204e021..626dcaf 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -440,6 +440,13 @@ mark_source_chains(struct xt_table_info 
 			    && unconditional(&e->ipv6)) {
 				unsigned int oldpos, size;
 
+				if (t->verdict < -NF_MAX_VERDICT - 1) {
+					duprintf("mark_source_chains: bad "
+						"negative verdict (%i)\n",
+								t->verdict);
+					return 0;
+				}
+
 				/* Return: backtrack through the last
 				   big jump. */
 				do {
@@ -477,6 +484,13 @@ #endif
 				if (strcmp(t->target.u.user.name,
 					   IP6T_STANDARD_TARGET) == 0
 				    && newpos >= 0) {
+					if (newpos > newinfo->size -
+						sizeof(struct ip6t_entry)) {
+						duprintf("mark_source_chains: "
+							"bad verdict (%i)\n",
+								newpos);
+						return 0;
+					}
 					/* This a jump; chase it. */
 					duprintf("Jump rule %u -> %u\n",
 						 pos, newpos);
@@ -509,27 +523,6 @@ cleanup_match(struct ip6t_entry_match *m
 }
 
 static inline int
-standard_check(const struct ip6t_entry_target *t,
-	       unsigned int max_offset)
-{
-	struct ip6t_standard_target *targ = (void *)t;
-
-	/* Check standard info. */
-	if (targ->verdict >= 0
-	    && targ->verdict > max_offset - sizeof(struct ip6t_entry)) {
-		duprintf("ip6t_standard_check: bad verdict (%i)\n",
-			 targ->verdict);
-		return 0;
-	}
-	if (targ->verdict < -NF_MAX_VERDICT - 1) {
-		duprintf("ip6t_standard_check: bad negative verdict (%i)\n",
-			 targ->verdict);
-		return 0;
-	}
-	return 1;
-}
-
-static inline int
 check_match(struct ip6t_entry_match *m,
 	    const char *name,
 	    const struct ip6t_ip6 *ipv6,
@@ -616,12 +609,7 @@ check_entry(struct ip6t_entry *e, const 
 	if (ret)
 		goto err;
 
-	if (t->u.kernel.target == &ip6t_standard_target) {
-		if (!standard_check(t, size)) {
-			ret = -EINVAL;
-			goto err;
-		}
-	} else if (t->u.kernel.target->checkentry
+	if (t->u.kernel.target->checkentry
 		   && !t->u.kernel.target->checkentry(name, e, target, t->data,
 						      e->comefrom)) {
 		duprintf("ip_tables: check failed for `%s'.\n",
@@ -758,17 +746,19 @@ translate_table(const char *name,
 		}
 	}
 
+	if (!mark_source_chains(newinfo, valid_hooks, entry0))
+		return -ELOOP;
+
 	/* Finally, each sanity check must pass */
 	i = 0;
 	ret = IP6T_ENTRY_ITERATE(entry0, newinfo->size,
 				check_entry, name, size, &i);
 
-	if (ret != 0)
-		goto cleanup;
-
-	ret = -ELOOP;
-	if (!mark_source_chains(newinfo, valid_hooks, entry0))
-		goto cleanup;
+	if (ret != 0) {
+		IP6T_ENTRY_ITERATE(entry0, newinfo->size,
+				   cleanup_entry, &i);
+		return ret;
+	}
 
 	/* And one copy for every other CPU */
 	for_each_possible_cpu(i) {
@@ -777,9 +767,6 @@ translate_table(const char *name,
 	}
 
 	return 0;
-cleanup:
-	IP6T_ENTRY_ITERATE(entry0, newinfo->size, cleanup_entry, &i);
-	return ret;
 }
 
 /* Gets counters. */

--------------010309040607030709010502--
