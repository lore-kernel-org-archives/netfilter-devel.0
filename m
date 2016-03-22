From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 4/5] netfilter: x_tables: fix unconditional helper
Date: Tue, 22 Mar 2016 18:02:52 +0100
Message-ID: <1458666173-24318-5-git-send-email-fw@strlen.de>
References: <1458666173-24318-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38139 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755060AbcCVRCu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 13:02:50 -0400
In-Reply-To: <1458666173-24318-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Ben Hawkes says:

 In the mark_source_chains function (net/ipv4/netfilter/ip_tables.c) it
 is possible for a user-supplied ipt_entry structure to have a large
 next_offset field. This field is not bounds checked prior to writing a
 counter value at the supplied offset.

Problem is that mark_source_chains should not have been called --
the rule doesn't have a next entry, so its supposed to return
an absolute verdict of either ACCEPT or DROP.

However, the function conditional() doesn't work as the name implies.
It only checks that the rule is using wildcard address matching.

However, an unconditional rule must also not be using any matches
(no -m args).

The underflow validator only checked the addresses, therefore
passing the 'unconditional absolute verdict' test, while
mark_source_chains also tested for presence of matches, and thus
proceeeded to the next (not-existent) rule.

Unify this so that all the callers have same idea of 'unconditional rule'.

Reported-by: Ben Hawkes <hawkes@google.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/ipv4/netfilter/arp_tables.c | 18 +++++++++---------
 net/ipv4/netfilter/ip_tables.c  | 23 +++++++++++------------
 net/ipv6/netfilter/ip6_tables.c | 23 +++++++++++------------
 3 files changed, 31 insertions(+), 33 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 59a9610..a2002ff 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -359,11 +359,12 @@ unsigned int arpt_do_table(struct sk_buff *skb,
 }
 
 /* All zeroes == unconditional rule. */
-static inline bool unconditional(const struct arpt_arp *arp)
+static inline bool unconditional(const struct arpt_entry *e)
 {
 	static const struct arpt_arp uncond;
 
-	return memcmp(arp, &uncond, sizeof(uncond)) == 0;
+	return e->target_offset == sizeof(struct arpt_entry) &&
+	       memcmp(&e->arp, &uncond, sizeof(uncond)) == 0;
 }
 
 /* Figures out from what hook each rule can be called: returns 0 if
@@ -402,11 +403,10 @@ static int mark_source_chains(const struct xt_table_info *newinfo,
 				|= ((1 << hook) | (1 << NF_ARP_NUMHOOKS));
 
 			/* Unconditional return/END. */
-			if ((e->target_offset == sizeof(struct arpt_entry) &&
+			if ((unconditional(e) &&
 			     (strcmp(t->target.u.user.name,
 				     XT_STANDARD_TARGET) == 0) &&
-			     t->verdict < 0 && unconditional(&e->arp)) ||
-			    visited) {
+			     t->verdict < 0) || visited) {
 				unsigned int oldpos, size;
 
 				if ((strcmp(t->target.u.user.name,
@@ -542,7 +542,7 @@ static bool check_underflow(const struct arpt_entry *e)
 	const struct xt_entry_target *t;
 	unsigned int verdict;
 
-	if (!unconditional(&e->arp))
+	if (!unconditional(e))
 		return false;
 	t = arpt_get_target_c(e);
 	if (strcmp(t->u.user.name, XT_STANDARD_TARGET) != 0)
@@ -589,9 +589,9 @@ static inline int check_entry_size_and_hooks(struct arpt_entry *e,
 			newinfo->hook_entry[h] = hook_entries[h];
 		if ((unsigned char *)e - base == underflows[h]) {
 			if (!check_underflow(e)) {
-				pr_err("Underflows must be unconditional and "
-				       "use the STANDARD target with "
-				       "ACCEPT/DROP\n");
+				pr_debug("Underflows must be unconditional and "
+					 "use the STANDARD target with "
+					 "ACCEPT/DROP\n");
 				return -EINVAL;
 			}
 			newinfo->underflow[h] = underflows[h];
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 1acc6ee..45b1d97 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -168,11 +168,12 @@ get_entry(const void *base, unsigned int offset)
 
 /* All zeroes == unconditional rule. */
 /* Mildly perf critical (only if packet tracing is on) */
-static inline bool unconditional(const struct ipt_ip *ip)
+static inline bool unconditional(const struct ipt_entry *e)
 {
 	static const struct ipt_ip uncond;
 
-	return memcmp(ip, &uncond, sizeof(uncond)) == 0;
+	return e->target_offset == sizeof(struct ipt_entry) &&
+	       memcmp(&e->ip, &uncond, sizeof(uncond)) == 0;
 #undef FWINV
 }
 
@@ -229,11 +230,10 @@ get_chainname_rulenum(const struct ipt_entry *s, const struct ipt_entry *e,
 	} else if (s == e) {
 		(*rulenum)++;
 
-		if (s->target_offset == sizeof(struct ipt_entry) &&
+		if (unconditional(s) &&
 		    strcmp(t->target.u.kernel.target->name,
 			   XT_STANDARD_TARGET) == 0 &&
-		   t->verdict < 0 &&
-		   unconditional(&s->ip)) {
+		   t->verdict < 0) {
 			/* Tail of chains: STANDARD target (return/policy) */
 			*comment = *chainname == hookname
 				? comments[NF_IP_TRACE_COMMENT_POLICY]
@@ -476,11 +476,10 @@ mark_source_chains(const struct xt_table_info *newinfo,
 			e->comefrom |= ((1 << hook) | (1 << NF_INET_NUMHOOKS));
 
 			/* Unconditional return/END. */
-			if ((e->target_offset == sizeof(struct ipt_entry) &&
+			if ((unconditional(e) &&
 			     (strcmp(t->target.u.user.name,
 				     XT_STANDARD_TARGET) == 0) &&
-			     t->verdict < 0 && unconditional(&e->ip)) ||
-			    visited) {
+			     t->verdict < 0) || visited) {
 				unsigned int oldpos, size;
 
 				if ((strcmp(t->target.u.user.name,
@@ -705,7 +704,7 @@ static bool check_underflow(const struct ipt_entry *e)
 	const struct xt_entry_target *t;
 	unsigned int verdict;
 
-	if (!unconditional(&e->ip))
+	if (!unconditional(e))
 		return false;
 	t = ipt_get_target_c(e);
 	if (strcmp(t->u.user.name, XT_STANDARD_TARGET) != 0)
@@ -753,9 +752,9 @@ check_entry_size_and_hooks(struct ipt_entry *e,
 			newinfo->hook_entry[h] = hook_entries[h];
 		if ((unsigned char *)e - base == underflows[h]) {
 			if (!check_underflow(e)) {
-				pr_err("Underflows must be unconditional and "
-				       "use the STANDARD target with "
-				       "ACCEPT/DROP\n");
+				pr_debug("Underflows must be unconditional and "
+					 "use the STANDARD target with "
+					 "ACCEPT/DROP\n");
 				return -EINVAL;
 			}
 			newinfo->underflow[h] = underflows[h];
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 29e2113..85c0942 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -198,11 +198,12 @@ get_entry(const void *base, unsigned int offset)
 
 /* All zeroes == unconditional rule. */
 /* Mildly perf critical (only if packet tracing is on) */
-static inline bool unconditional(const struct ip6t_ip6 *ipv6)
+static inline bool unconditional(const struct ip6t_entry *e)
 {
 	static const struct ip6t_ip6 uncond;
 
-	return memcmp(ipv6, &uncond, sizeof(uncond)) == 0;
+	return e->target_offset == sizeof(struct ip6t_entry) &&
+	       memcmp(&e->ipv6, &uncond, sizeof(uncond)) == 0;
 }
 
 static inline const struct xt_entry_target *
@@ -258,11 +259,10 @@ get_chainname_rulenum(const struct ip6t_entry *s, const struct ip6t_entry *e,
 	} else if (s == e) {
 		(*rulenum)++;
 
-		if (s->target_offset == sizeof(struct ip6t_entry) &&
+		if (unconditional(s) &&
 		    strcmp(t->target.u.kernel.target->name,
 			   XT_STANDARD_TARGET) == 0 &&
-		    t->verdict < 0 &&
-		    unconditional(&s->ipv6)) {
+		    t->verdict < 0) {
 			/* Tail of chains: STANDARD target (return/policy) */
 			*comment = *chainname == hookname
 				? comments[NF_IP6_TRACE_COMMENT_POLICY]
@@ -488,11 +488,10 @@ mark_source_chains(const struct xt_table_info *newinfo,
 			e->comefrom |= ((1 << hook) | (1 << NF_INET_NUMHOOKS));
 
 			/* Unconditional return/END. */
-			if ((e->target_offset == sizeof(struct ip6t_entry) &&
+			if ((unconditional(e) &&
 			     (strcmp(t->target.u.user.name,
 				     XT_STANDARD_TARGET) == 0) &&
-			     t->verdict < 0 &&
-			     unconditional(&e->ipv6)) || visited) {
+			     t->verdict < 0) || visited) {
 				unsigned int oldpos, size;
 
 				if ((strcmp(t->target.u.user.name,
@@ -717,7 +716,7 @@ static bool check_underflow(const struct ip6t_entry *e)
 	const struct xt_entry_target *t;
 	unsigned int verdict;
 
-	if (!unconditional(&e->ipv6))
+	if (!unconditional(e))
 		return false;
 	t = ip6t_get_target_c(e);
 	if (strcmp(t->u.user.name, XT_STANDARD_TARGET) != 0)
@@ -765,9 +764,9 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
 			newinfo->hook_entry[h] = hook_entries[h];
 		if ((unsigned char *)e - base == underflows[h]) {
 			if (!check_underflow(e)) {
-				pr_err("Underflows must be unconditional and "
-				       "use the STANDARD target with "
-				       "ACCEPT/DROP\n");
+				pr_debug("Underflows must be unconditional and "
+					 "use the STANDARD target with "
+					 "ACCEPT/DROP\n");
 				return -EINVAL;
 			}
 			newinfo->underflow[h] = underflows[h];
-- 
2.4.10

