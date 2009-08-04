From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 020/103] netfilter: xtables: check for standard verdicts in policies
Date: Tue,  4 Aug 2009 09:25:04 +0200
Message-ID: <1249370787-17583-21-git-send-email-jengelh@medozas.de>
References: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50624 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932546AbZHDH0z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Aug 2009 03:26:55 -0400
In-Reply-To: <1249370787-17583-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds the second check that Rusty wanted to have a long time ago. :)

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/arp_tables.c |   21 +++++++++++++++++++--
 net/ipv4/netfilter/ip_tables.c  |   21 +++++++++++++++++++--
 net/ipv6/netfilter/ip6_tables.c |   21 +++++++++++++++++++--
 3 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 064082d..7bc11ff 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -533,6 +533,21 @@ out:
 	return ret;
 }
 
+static bool check_underflow(struct arpt_entry *e)
+{
+	const struct arpt_entry_target *t;
+	unsigned int verdict;
+
+	if (!unconditional(&e->arp))
+		return false;
+	t = arpt_get_target(e);
+	if (strcmp(t->u.user.name, XT_STANDARD_TARGET) != 0)
+		return false;
+	verdict = ((struct arpt_standard_target *)t)->verdict;
+	verdict = -verdict - 1;
+	return verdict == NF_DROP || verdict == NF_ACCEPT;
+}
+
 static inline int check_entry_size_and_hooks(struct arpt_entry *e,
 					     struct xt_table_info *newinfo,
 					     unsigned char *base,
@@ -564,8 +579,10 @@ static inline int check_entry_size_and_hooks(struct arpt_entry *e,
 		if ((unsigned char *)e - base == hook_entries[h])
 			newinfo->hook_entry[h] = hook_entries[h];
 		if ((unsigned char *)e - base == underflows[h]) {
-			if (!unconditional(&e->arp)) {
-				pr_err("Underflows must be unconditional\n");
+			if (!check_underflow(e)) {
+				pr_err("Underflows must be unconditional and "
+				       "use the STANDARD target with "
+				       "ACCEPT/DROP\n");
 				return -EINVAL;
 			}
 			newinfo->underflow[h] = underflows[h];
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index 6e546d5..0b43fd7 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -708,6 +708,21 @@ find_check_entry(struct ipt_entry *e, const char *name, unsigned int size,
 	return ret;
 }
 
+static bool check_underflow(struct ipt_entry *e)
+{
+	const struct ipt_entry_target *t;
+	unsigned int verdict;
+
+	if (!unconditional(&e->ip))
+		return false;
+	t = ipt_get_target(e);
+	if (strcmp(t->u.user.name, XT_STANDARD_TARGET) != 0)
+		return false;
+	verdict = ((struct ipt_standard_target *)t)->verdict;
+	verdict = -verdict - 1;
+	return verdict == NF_DROP || verdict == NF_ACCEPT;
+}
+
 static int
 check_entry_size_and_hooks(struct ipt_entry *e,
 			   struct xt_table_info *newinfo,
@@ -740,8 +755,10 @@ check_entry_size_and_hooks(struct ipt_entry *e,
 		if ((unsigned char *)e - base == hook_entries[h])
 			newinfo->hook_entry[h] = hook_entries[h];
 		if ((unsigned char *)e - base == underflows[h]) {
-			if (!unconditional(&e->ip)) {
-				pr_err("Underflows must be unconditional\n");
+			if (!check_underflow(e)) {
+				pr_err("Underflows must be unconditional and "
+				       "use the STANDARD target with "
+				       "ACCEPT/DROP\n");
 				return -EINVAL;
 			}
 			newinfo->underflow[h] = underflows[h];
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index b0599b9..a5d0c27 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -740,6 +740,21 @@ find_check_entry(struct ip6t_entry *e, const char *name, unsigned int size,
 	return ret;
 }
 
+static bool check_underflow(struct ip6t_entry *e)
+{
+	const struct ip6t_entry_target *t;
+	unsigned int verdict;
+
+	if (!unconditional(&e->ipv6))
+		return false;
+	t = ip6t_get_target(e);
+	if (strcmp(t->u.user.name, XT_STANDARD_TARGET) != 0)
+		return false;
+	verdict = ((struct ip6t_standard_target *)t)->verdict;
+	verdict = -verdict - 1;
+	return verdict == NF_DROP || verdict == NF_ACCEPT;
+}
+
 static int
 check_entry_size_and_hooks(struct ip6t_entry *e,
 			   struct xt_table_info *newinfo,
@@ -772,8 +787,10 @@ check_entry_size_and_hooks(struct ip6t_entry *e,
 		if ((unsigned char *)e - base == hook_entries[h])
 			newinfo->hook_entry[h] = hook_entries[h];
 		if ((unsigned char *)e - base == underflows[h]) {
-			if (!unconditional(&e->ipv6)) {
-				pr_err("Underflows must be unconditional\n");
+			if (!check_underflow(e)) {
+				pr_err("Underflows must be unconditional and "
+				       "use the STANDARD target with "
+				       "ACCEPT/DROP\n");
 				return -EINVAL;
 			}
 			newinfo->underflow[h] = underflows[h];
-- 
1.6.3.3

