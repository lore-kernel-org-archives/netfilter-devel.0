From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/56] netfilter: xtables: move functions around
Date: Tue, 29 Jun 2010 10:42:43 +0200
Message-ID: <1277801017-30600-4-git-send-email-jengelh@medozas.de>
References: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44222 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753917Ab0F2Inm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:43:42 -0400
In-Reply-To: <1277801017-30600-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

For the next patch, the builtin_mt object needs to be available ahead
of ip6t_do_table if we want to do without predeclartions.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/ipv4/netfilter/arp_tables.c |   77 +++++++-------
 net/ipv4/netfilter/ip_tables.c  |  192 ++++++++++++++++++------------------
 net/ipv6/netfilter/ip6_tables.c |  208 ++++++++++++++++++++-------------------
 3 files changed, 241 insertions(+), 236 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index 16c0ba0..ec89fd4 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -218,6 +218,26 @@ static inline int arp_checkentry(const struct arpt_arp *arp)
 	return 1;
 }
 
+#ifdef CONFIG_COMPAT
+static void compat_standard_from_user(void *dst, const void *src)
+{
+	int v = *(compat_int_t *)src;
+
+	if (v > 0)
+		v += xt_compat_calc_jump(NFPROTO_ARP, v);
+	memcpy(dst, &v, sizeof(v));
+}
+
+static int compat_standard_to_user(void __user *dst, const void *src)
+{
+	compat_int_t cv = *(int *)src;
+
+	if (cv > 0)
+		cv -= xt_compat_calc_jump(NFPROTO_ARP, cv);
+	return copy_to_user(dst, &cv, sizeof(cv)) ? -EFAULT : 0;
+}
+#endif
+
 static unsigned int
 arpt_error(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -228,6 +248,25 @@ arpt_error(struct sk_buff *skb, const struct xt_action_param *par)
 	return NF_DROP;
 }
 
+static struct xt_target arpt_builtin_tg[] __read_mostly = {
+	{
+		.name             = ARPT_STANDARD_TARGET,
+		.targetsize       = sizeof(int),
+		.family           = NFPROTO_ARP,
+#ifdef CONFIG_COMPAT
+		.compatsize       = sizeof(compat_int_t),
+		.compat_from_user = compat_standard_from_user,
+		.compat_to_user   = compat_standard_to_user,
+#endif
+	},
+	{
+		.name             = ARPT_ERROR_TARGET,
+		.target           = arpt_error,
+		.targetsize       = ARPT_FUNCTION_MAXNAMELEN,
+		.family           = NFPROTO_ARP,
+	},
+};
+
 static inline const struct arpt_entry_target *
 arpt_get_target_c(const struct arpt_entry *e)
 {
@@ -821,24 +860,6 @@ static int copy_entries_to_user(unsigned int total_size,
 }
 
 #ifdef CONFIG_COMPAT
-static void compat_standard_from_user(void *dst, const void *src)
-{
-	int v = *(compat_int_t *)src;
-
-	if (v > 0)
-		v += xt_compat_calc_jump(NFPROTO_ARP, v);
-	memcpy(dst, &v, sizeof(v));
-}
-
-static int compat_standard_to_user(void __user *dst, const void *src)
-{
-	compat_int_t cv = *(int *)src;
-
-	if (cv > 0)
-		cv -= xt_compat_calc_jump(NFPROTO_ARP, cv);
-	return copy_to_user(dst, &cv, sizeof(cv)) ? -EFAULT : 0;
-}
-
 static int compat_calc_entry(const struct arpt_entry *e,
 			     const struct xt_table_info *info,
 			     const void *base, struct xt_table_info *newinfo)
@@ -1821,26 +1842,6 @@ void arpt_unregister_table(struct xt_table *table)
 	xt_free_table_info(private);
 }
 
-/* The built-in targets: standard (NULL) and error. */
-static struct xt_target arpt_builtin_tg[] __read_mostly = {
-	{
-		.name             = ARPT_STANDARD_TARGET,
-		.targetsize       = sizeof(int),
-		.family           = NFPROTO_ARP,
-#ifdef CONFIG_COMPAT
-		.compatsize       = sizeof(compat_int_t),
-		.compat_from_user = compat_standard_from_user,
-		.compat_to_user   = compat_standard_to_user,
-#endif
-	},
-	{
-		.name             = ARPT_ERROR_TARGET,
-		.target           = arpt_error,
-		.targetsize       = ARPT_FUNCTION_MAXNAMELEN,
-		.family           = NFPROTO_ARP,
-	},
-};
-
 static struct nf_sockopt_ops arpt_sockopts = {
 	.pf		= PF_INET,
 	.set_optmin	= ARPT_BASE_CTL,
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index b38c118..e98347f 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -159,6 +159,73 @@ ip_checkentry(const struct ipt_ip *ip)
 	return true;
 }
 
+/* Returns 1 if the type and code is matched by the range, 0 otherwise */
+static inline bool
+icmp_type_code_match(u_int8_t test_type, u_int8_t min_code, u_int8_t max_code,
+		     u_int8_t type, u_int8_t code,
+		     bool invert)
+{
+	return ((test_type == 0xFF) ||
+		(type == test_type && code >= min_code && code <= max_code))
+		^ invert;
+}
+
+static bool
+icmp_match(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct icmphdr *ic;
+	struct icmphdr _icmph;
+	const struct ipt_icmp *icmpinfo = par->matchinfo;
+
+	/* Must not be a fragment. */
+	if (par->fragoff != 0)
+		return false;
+
+	ic = skb_header_pointer(skb, par->thoff, sizeof(_icmph), &_icmph);
+	if (ic == NULL) {
+		/* We've been asked to examine this packet, and we
+		 * can't.  Hence, no choice but to drop.
+		 */
+		duprintf("Dropping evil ICMP tinygram.\n");
+		par->hotdrop = true;
+		return false;
+	}
+
+	return icmp_type_code_match(icmpinfo->type,
+				    icmpinfo->code[0],
+				    icmpinfo->code[1],
+				    ic->type, ic->code,
+				    !!(icmpinfo->invflags&IPT_ICMP_INV));
+}
+
+static int icmp_checkentry(const struct xt_mtchk_param *par)
+{
+	const struct ipt_icmp *icmpinfo = par->matchinfo;
+
+	/* Must specify no unknown invflags */
+	return (icmpinfo->invflags & ~IPT_ICMP_INV) ? -EINVAL : 0;
+}
+
+#ifdef CONFIG_COMPAT
+static void compat_standard_from_user(void *dst, const void *src)
+{
+	int v = *(compat_int_t *)src;
+
+	if (v > 0)
+		v += xt_compat_calc_jump(AF_INET, v);
+	memcpy(dst, &v, sizeof(v));
+}
+
+static int compat_standard_to_user(void __user *dst, const void *src)
+{
+	compat_int_t cv = *(int *)src;
+
+	if (cv > 0)
+		cv -= xt_compat_calc_jump(AF_INET, cv);
+	return copy_to_user(dst, &cv, sizeof(cv)) ? -EFAULT : 0;
+}
+#endif
+
 static unsigned int
 ipt_error(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -168,6 +235,36 @@ ipt_error(struct sk_buff *skb, const struct xt_action_param *par)
 	return NF_DROP;
 }
 
+static struct xt_target ipt_builtin_tg[] __read_mostly = {
+	{
+		.name             = IPT_STANDARD_TARGET,
+		.targetsize       = sizeof(int),
+		.family           = NFPROTO_IPV4,
+#ifdef CONFIG_COMPAT
+		.compatsize       = sizeof(compat_int_t),
+		.compat_from_user = compat_standard_from_user,
+		.compat_to_user   = compat_standard_to_user,
+#endif
+	},
+	{
+		.name             = IPT_ERROR_TARGET,
+		.target           = ipt_error,
+		.targetsize       = IPT_FUNCTION_MAXNAMELEN,
+		.family           = NFPROTO_IPV4,
+	},
+};
+
+static struct xt_match ipt_builtin_mt[] __read_mostly = {
+	{
+		.name       = "icmp",
+		.match      = icmp_match,
+		.matchsize  = sizeof(struct ipt_icmp),
+		.checkentry = icmp_checkentry,
+		.proto      = IPPROTO_ICMP,
+		.family     = NFPROTO_IPV4,
+	},
+};
+
 /* Performance critical */
 static inline struct ipt_entry *
 get_entry(const void *base, unsigned int offset)
@@ -1013,24 +1110,6 @@ copy_entries_to_user(unsigned int total_size,
 }
 
 #ifdef CONFIG_COMPAT
-static void compat_standard_from_user(void *dst, const void *src)
-{
-	int v = *(compat_int_t *)src;
-
-	if (v > 0)
-		v += xt_compat_calc_jump(AF_INET, v);
-	memcpy(dst, &v, sizeof(v));
-}
-
-static int compat_standard_to_user(void __user *dst, const void *src)
-{
-	compat_int_t cv = *(int *)src;
-
-	if (cv > 0)
-		cv -= xt_compat_calc_jump(AF_INET, cv);
-	return copy_to_user(dst, &cv, sizeof(cv)) ? -EFAULT : 0;
-}
-
 static int compat_calc_entry(const struct ipt_entry *e,
 			     const struct xt_table_info *info,
 			     const void *base, struct xt_table_info *newinfo)
@@ -2120,72 +2199,6 @@ void ipt_unregister_table(struct net *net, struct xt_table *table)
 	xt_free_table_info(private);
 }
 
-/* Returns 1 if the type and code is matched by the range, 0 otherwise */
-static inline bool
-icmp_type_code_match(u_int8_t test_type, u_int8_t min_code, u_int8_t max_code,
-		     u_int8_t type, u_int8_t code,
-		     bool invert)
-{
-	return ((test_type == 0xFF) ||
-		(type == test_type && code >= min_code && code <= max_code))
-		^ invert;
-}
-
-static bool
-icmp_match(const struct sk_buff *skb, struct xt_action_param *par)
-{
-	const struct icmphdr *ic;
-	struct icmphdr _icmph;
-	const struct ipt_icmp *icmpinfo = par->matchinfo;
-
-	/* Must not be a fragment. */
-	if (par->fragoff != 0)
-		return false;
-
-	ic = skb_header_pointer(skb, par->thoff, sizeof(_icmph), &_icmph);
-	if (ic == NULL) {
-		/* We've been asked to examine this packet, and we
-		 * can't.  Hence, no choice but to drop.
-		 */
-		duprintf("Dropping evil ICMP tinygram.\n");
-		par->hotdrop = true;
-		return false;
-	}
-
-	return icmp_type_code_match(icmpinfo->type,
-				    icmpinfo->code[0],
-				    icmpinfo->code[1],
-				    ic->type, ic->code,
-				    !!(icmpinfo->invflags&IPT_ICMP_INV));
-}
-
-static int icmp_checkentry(const struct xt_mtchk_param *par)
-{
-	const struct ipt_icmp *icmpinfo = par->matchinfo;
-
-	/* Must specify no unknown invflags */
-	return (icmpinfo->invflags & ~IPT_ICMP_INV) ? -EINVAL : 0;
-}
-
-static struct xt_target ipt_builtin_tg[] __read_mostly = {
-	{
-		.name             = IPT_STANDARD_TARGET,
-		.targetsize       = sizeof(int),
-		.family           = NFPROTO_IPV4,
-#ifdef CONFIG_COMPAT
-		.compatsize       = sizeof(compat_int_t),
-		.compat_from_user = compat_standard_from_user,
-		.compat_to_user   = compat_standard_to_user,
-#endif
-	},
-	{
-		.name             = IPT_ERROR_TARGET,
-		.target           = ipt_error,
-		.targetsize       = IPT_FUNCTION_MAXNAMELEN,
-		.family           = NFPROTO_IPV4,
-	},
-};
-
 static struct nf_sockopt_ops ipt_sockopts = {
 	.pf		= PF_INET,
 	.set_optmin	= IPT_BASE_CTL,
@@ -2203,17 +2216,6 @@ static struct nf_sockopt_ops ipt_sockopts = {
 	.owner		= THIS_MODULE,
 };
 
-static struct xt_match ipt_builtin_mt[] __read_mostly = {
-	{
-		.name       = "icmp",
-		.match      = icmp_match,
-		.matchsize  = sizeof(struct ipt_icmp),
-		.checkentry = icmp_checkentry,
-		.proto      = IPPROTO_ICMP,
-		.family     = NFPROTO_IPV4,
-	},
-};
-
 static int __net_init ip_tables_net_init(struct net *net)
 {
 	return xt_proto_init(net, NFPROTO_IPV4);
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index dc41d6d..2bcf20b 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -82,13 +82,13 @@ EXPORT_SYMBOL_GPL(ip6t_alloc_initial_table);
 int
 ip6t_ext_hdr(u8 nexthdr)
 {
-	return ( (nexthdr == IPPROTO_HOPOPTS)   ||
-		 (nexthdr == IPPROTO_ROUTING)   ||
-		 (nexthdr == IPPROTO_FRAGMENT)  ||
-		 (nexthdr == IPPROTO_ESP)       ||
-		 (nexthdr == IPPROTO_AH)        ||
-		 (nexthdr == IPPROTO_NONE)      ||
-		 (nexthdr == IPPROTO_DSTOPTS) );
+	return nexthdr == IPPROTO_HOPOPTS ||
+	       nexthdr == IPPROTO_ROUTING ||
+	       nexthdr == IPPROTO_FRAGMENT ||
+	       nexthdr == IPPROTO_ESP ||
+	       nexthdr == IPPROTO_AH ||
+	       nexthdr == IPPROTO_NONE ||
+	       nexthdr == IPPROTO_DSTOPTS;
 }
 
 /* Returns whether matches rule or not. */
@@ -191,6 +191,73 @@ ip6_checkentry(const struct ip6t_ip6 *ipv6)
 	return true;
 }
 
+/* Returns 1 if the type and code is matched by the range, 0 otherwise */
+static inline bool
+icmp6_type_code_match(u_int8_t test_type, u_int8_t min_code, u_int8_t max_code,
+		     u_int8_t type, u_int8_t code,
+		     bool invert)
+{
+	return (type == test_type && code >= min_code && code <= max_code)
+		^ invert;
+}
+
+static bool
+icmp6_match(const struct sk_buff *skb, struct xt_action_param *par)
+{
+	const struct icmp6hdr *ic;
+	struct icmp6hdr _icmph;
+	const struct ip6t_icmp *icmpinfo = par->matchinfo;
+
+	/* Must not be a fragment. */
+	if (par->fragoff != 0)
+		return false;
+
+	ic = skb_header_pointer(skb, par->thoff, sizeof(_icmph), &_icmph);
+	if (ic == NULL) {
+		/* We've been asked to examine this packet, and we
+		 * can't.  Hence, no choice but to drop.
+		 */
+		duprintf("Dropping evil ICMP tinygram.\n");
+		par->hotdrop = true;
+		return false;
+	}
+
+	return icmp6_type_code_match(icmpinfo->type,
+				     icmpinfo->code[0],
+				     icmpinfo->code[1],
+				     ic->icmp6_type, ic->icmp6_code,
+				     !!(icmpinfo->invflags&IP6T_ICMP_INV));
+}
+
+/* Called when user tries to insert an entry of this type. */
+static int icmp6_checkentry(const struct xt_mtchk_param *par)
+{
+	const struct ip6t_icmp *icmpinfo = par->matchinfo;
+
+	/* Must specify no unknown invflags */
+	return (icmpinfo->invflags & ~IP6T_ICMP_INV) ? -EINVAL : 0;
+}
+
+#ifdef CONFIG_COMPAT
+static void compat_standard_from_user(void *dst, const void *src)
+{
+	int v = *(compat_int_t *)src;
+
+	if (v > 0)
+		v += xt_compat_calc_jump(AF_INET6, v);
+	memcpy(dst, &v, sizeof(v));
+}
+
+static int compat_standard_to_user(void __user *dst, const void *src)
+{
+	compat_int_t cv = *(int *)src;
+
+	if (cv > 0)
+		cv -= xt_compat_calc_jump(AF_INET6, cv);
+	return copy_to_user(dst, &cv, sizeof(cv)) ? -EFAULT : 0;
+}
+#endif
+
 static unsigned int
 ip6t_error(struct sk_buff *skb, const struct xt_action_param *par)
 {
@@ -200,6 +267,37 @@ ip6t_error(struct sk_buff *skb, const struct xt_action_param *par)
 	return NF_DROP;
 }
 
+/* The built-in targets: standard (NULL) and error. */
+static struct xt_target ip6t_builtin_tg[] __read_mostly = {
+	{
+		.name             = IP6T_STANDARD_TARGET,
+		.targetsize       = sizeof(int),
+		.family           = NFPROTO_IPV6,
+#ifdef CONFIG_COMPAT
+		.compatsize       = sizeof(compat_int_t),
+		.compat_from_user = compat_standard_from_user,
+		.compat_to_user   = compat_standard_to_user,
+#endif
+	},
+	{
+		.name             = IP6T_ERROR_TARGET,
+		.target           = ip6t_error,
+		.targetsize       = IP6T_FUNCTION_MAXNAMELEN,
+		.family           = NFPROTO_IPV6,
+	},
+};
+
+static struct xt_match ip6t_builtin_mt[] __read_mostly = {
+	{
+		.name       = "icmp6",
+		.match      = icmp6_match,
+		.matchsize  = sizeof(struct ip6t_icmp),
+		.checkentry = icmp6_checkentry,
+		.proto      = IPPROTO_ICMPV6,
+		.family     = NFPROTO_IPV6,
+	},
+};
+
 static inline struct ip6t_entry *
 get_entry(const void *base, unsigned int offset)
 {
@@ -1028,24 +1126,6 @@ copy_entries_to_user(unsigned int total_size,
 }
 
 #ifdef CONFIG_COMPAT
-static void compat_standard_from_user(void *dst, const void *src)
-{
-	int v = *(compat_int_t *)src;
-
-	if (v > 0)
-		v += xt_compat_calc_jump(AF_INET6, v);
-	memcpy(dst, &v, sizeof(v));
-}
-
-static int compat_standard_to_user(void __user *dst, const void *src)
-{
-	compat_int_t cv = *(int *)src;
-
-	if (cv > 0)
-		cv -= xt_compat_calc_jump(AF_INET6, cv);
-	return copy_to_user(dst, &cv, sizeof(cv)) ? -EFAULT : 0;
-}
-
 static int compat_calc_entry(const struct ip6t_entry *e,
 			     const struct xt_table_info *info,
 			     const void *base, struct xt_table_info *newinfo)
@@ -2136,73 +2216,6 @@ void ip6t_unregister_table(struct net *net, struct xt_table *table)
 	xt_free_table_info(private);
 }
 
-/* Returns 1 if the type and code is matched by the range, 0 otherwise */
-static inline bool
-icmp6_type_code_match(u_int8_t test_type, u_int8_t min_code, u_int8_t max_code,
-		     u_int8_t type, u_int8_t code,
-		     bool invert)
-{
-	return (type == test_type && code >= min_code && code <= max_code)
-		^ invert;
-}
-
-static bool
-icmp6_match(const struct sk_buff *skb, struct xt_action_param *par)
-{
-	const struct icmp6hdr *ic;
-	struct icmp6hdr _icmph;
-	const struct ip6t_icmp *icmpinfo = par->matchinfo;
-
-	/* Must not be a fragment. */
-	if (par->fragoff != 0)
-		return false;
-
-	ic = skb_header_pointer(skb, par->thoff, sizeof(_icmph), &_icmph);
-	if (ic == NULL) {
-		/* We've been asked to examine this packet, and we
-		 * can't.  Hence, no choice but to drop.
-		 */
-		duprintf("Dropping evil ICMP tinygram.\n");
-		par->hotdrop = true;
-		return false;
-	}
-
-	return icmp6_type_code_match(icmpinfo->type,
-				     icmpinfo->code[0],
-				     icmpinfo->code[1],
-				     ic->icmp6_type, ic->icmp6_code,
-				     !!(icmpinfo->invflags&IP6T_ICMP_INV));
-}
-
-/* Called when user tries to insert an entry of this type. */
-static int icmp6_checkentry(const struct xt_mtchk_param *par)
-{
-	const struct ip6t_icmp *icmpinfo = par->matchinfo;
-
-	/* Must specify no unknown invflags */
-	return (icmpinfo->invflags & ~IP6T_ICMP_INV) ? -EINVAL : 0;
-}
-
-/* The built-in targets: standard (NULL) and error. */
-static struct xt_target ip6t_builtin_tg[] __read_mostly = {
-	{
-		.name             = IP6T_STANDARD_TARGET,
-		.targetsize       = sizeof(int),
-		.family           = NFPROTO_IPV6,
-#ifdef CONFIG_COMPAT
-		.compatsize       = sizeof(compat_int_t),
-		.compat_from_user = compat_standard_from_user,
-		.compat_to_user   = compat_standard_to_user,
-#endif
-	},
-	{
-		.name             = IP6T_ERROR_TARGET,
-		.target           = ip6t_error,
-		.targetsize       = IP6T_FUNCTION_MAXNAMELEN,
-		.family           = NFPROTO_IPV6,
-	},
-};
-
 static struct nf_sockopt_ops ip6t_sockopts = {
 	.pf		= PF_INET6,
 	.set_optmin	= IP6T_BASE_CTL,
@@ -2220,17 +2233,6 @@ static struct nf_sockopt_ops ip6t_sockopts = {
 	.owner		= THIS_MODULE,
 };
 
-static struct xt_match ip6t_builtin_mt[] __read_mostly = {
-	{
-		.name       = "icmp6",
-		.match      = icmp6_match,
-		.matchsize  = sizeof(struct ip6t_icmp),
-		.checkentry = icmp6_checkentry,
-		.proto      = IPPROTO_ICMPV6,
-		.family     = NFPROTO_IPV6,
-	},
-};
-
 static int __net_init ip6_tables_net_init(struct net *net)
 {
 	return xt_proto_init(net, NFPROTO_IPV6);
-- 
1.7.1

