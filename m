From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 10/16] libxtables: prefix/order - ipaddr/ipmask to ascii output
Date: Mon,  9 Feb 2009 18:34:54 +0100
Message-ID: <1234200900-5964-11-git-send-email-jengelh@medozas.de>
References: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:51470 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580AbZBIRfF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 12:35:05 -0500
In-Reply-To: <1234200900-5964-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libipt_DNAT.c     |    4 ++--
 extensions/libipt_NETMAP.c   |    4 ++--
 extensions/libipt_SAME.c     |    8 ++++----
 extensions/libipt_SNAT.c     |    4 ++--
 extensions/libipt_policy.c   |    8 ++++----
 extensions/libxt_TPROXY.c    |    4 ++--
 extensions/libxt_conntrack.c |   14 +++++++-------
 extensions/libxt_iprange.c   |   32 ++++++++++++++++----------------
 include/xtables.h.in         |   12 ++++++------
 ip6tables.c                  |   12 ++++++------
 iptables.c                   |   12 ++++++------
 xtables.c                    |   20 ++++++++++----------
 12 files changed, 67 insertions(+), 67 deletions(-)

diff --git a/extensions/libipt_DNAT.c b/extensions/libipt_DNAT.c
index e884b03..42695bb 100644
--- a/extensions/libipt_DNAT.c
+++ b/extensions/libipt_DNAT.c
@@ -195,10 +195,10 @@ static void print_range(const struct ip_nat_range *r)
 		struct in_addr a;
 
 		a.s_addr = r->min_ip;
-		printf("%s", ipaddr_to_numeric(&a));
+		printf("%s", xtables_ipaddr_to_numeric(&a));
 		if (r->max_ip != r->min_ip) {
 			a.s_addr = r->max_ip;
-			printf("-%s", ipaddr_to_numeric(&a));
+			printf("-%s", xtables_ipaddr_to_numeric(&a));
 		}
 	}
 	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
diff --git a/extensions/libipt_NETMAP.c b/extensions/libipt_NETMAP.c
index d8f34cc..33f48c9 100644
--- a/extensions/libipt_NETMAP.c
+++ b/extensions/libipt_NETMAP.c
@@ -148,11 +148,11 @@ static void NETMAP_print(const void *ip, const struct xt_entry_target *target,
 	int bits;
 
 	a.s_addr = r->min_ip;
-	printf("%s", ipaddr_to_numeric(&a));
+	printf("%s", xtables_ipaddr_to_numeric(&a));
 	a.s_addr = ~(r->min_ip ^ r->max_ip);
 	bits = netmask2bits(a.s_addr);
 	if (bits < 0)
-		printf("/%s", ipaddr_to_numeric(&a));
+		printf("/%s", xtables_ipaddr_to_numeric(&a));
 	else
 		printf("/%d", bits);
 }
diff --git a/extensions/libipt_SAME.c b/extensions/libipt_SAME.c
index 6cb09af..1ca38ff 100644
--- a/extensions/libipt_SAME.c
+++ b/extensions/libipt_SAME.c
@@ -151,13 +151,13 @@ static void SAME_print(const void *ip, const struct xt_entry_target *target,
 
 		a.s_addr = r->min_ip;
 
-		printf("%s", ipaddr_to_numeric(&a));
+		printf("%s", xtables_ipaddr_to_numeric(&a));
 		a.s_addr = r->max_ip;
 		
 		if (r->min_ip == r->max_ip)
 			printf(" ");
 		else
-			printf("-%s ", ipaddr_to_numeric(&a));
+			printf("-%s ", xtables_ipaddr_to_numeric(&a));
 		if (r->flags & IP_NAT_RANGE_PROTO_RANDOM) 
 			random_selection = 1;
 	}
@@ -181,13 +181,13 @@ static void SAME_save(const void *ip, const struct xt_entry_target *target)
 		struct in_addr a;
 
 		a.s_addr = r->min_ip;
-		printf("--to %s", ipaddr_to_numeric(&a));
+		printf("--to %s", xtables_ipaddr_to_numeric(&a));
 		a.s_addr = r->max_ip;
 
 		if (r->min_ip == r->max_ip)
 			printf(" ");
 		else
-			printf("-%s ", ipaddr_to_numeric(&a));
+			printf("-%s ", xtables_ipaddr_to_numeric(&a));
 		if (r->flags & IP_NAT_RANGE_PROTO_RANDOM) 
 			random_selection = 1;
 	}
diff --git a/extensions/libipt_SNAT.c b/extensions/libipt_SNAT.c
index 8c28c0e..2afcbb1 100644
--- a/extensions/libipt_SNAT.c
+++ b/extensions/libipt_SNAT.c
@@ -196,10 +196,10 @@ static void print_range(const struct ip_nat_range *r)
 		struct in_addr a;
 
 		a.s_addr = r->min_ip;
-		printf("%s", ipaddr_to_numeric(&a));
+		printf("%s", xtables_ipaddr_to_numeric(&a));
 		if (r->max_ip != r->min_ip) {
 			a.s_addr = r->max_ip;
-			printf("-%s", ipaddr_to_numeric(&a));
+			printf("-%s", xtables_ipaddr_to_numeric(&a));
 		}
 	}
 	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
diff --git a/extensions/libipt_policy.c b/extensions/libipt_policy.c
index 9c70182..6b044d8 100644
--- a/extensions/libipt_policy.c
+++ b/extensions/libipt_policy.c
@@ -352,14 +352,14 @@ static void print_entry(char *prefix, const struct ipt_policy_elem *e,
 	if (e->match.daddr) {
 		PRINT_INVERT(e->invert.daddr);
 		printf("%stunnel-dst %s%s ", prefix,
-		       ipaddr_to_numeric((const void *)&e->daddr),
-		       ipmask_to_numeric((const void *)&e->dmask));
+		       xtables_ipaddr_to_numeric((const void *)&e->daddr),
+		       xtables_ipmask_to_numeric((const void *)&e->dmask));
 	}
 	if (e->match.saddr) {
 		PRINT_INVERT(e->invert.saddr);
 		printf("%stunnel-src %s%s ", prefix,
-		       ipaddr_to_numeric((const void *)&e->saddr),
-		       ipmask_to_numeric((const void *)&e->smask));
+		       xtables_ipaddr_to_numeric((const void *)&e->saddr),
+		       xtables_ipmask_to_numeric((const void *)&e->smask));
 	}
 }
 
diff --git a/extensions/libxt_TPROXY.c b/extensions/libxt_TPROXY.c
index d0933ae..2398c84 100644
--- a/extensions/libxt_TPROXY.c
+++ b/extensions/libxt_TPROXY.c
@@ -114,7 +114,7 @@ static void tproxy_tg_print(const void *ip, const struct xt_entry_target *target
 {
 	const struct xt_tproxy_target_info *info = (const void *)target->data;
 	printf("TPROXY redirect %s:%u mark 0x%x/0x%x",
-	       ipaddr_to_numeric((const struct in_addr *)&info->laddr),
+	       xtables_ipaddr_to_numeric((const struct in_addr *)&info->laddr),
 	       ntohs(info->lport), (unsigned int)info->mark_value,
 	       (unsigned int)info->mark_mask);
 }
@@ -125,7 +125,7 @@ static void tproxy_tg_save(const void *ip, const struct xt_entry_target *target)
 
 	printf("--on-port %u ", ntohs(info->lport));
 	printf("--on-ip %s ",
-	       ipaddr_to_numeric((const struct in_addr *)&info->laddr));
+	       xtables_ipaddr_to_numeric((const struct in_addr *)&info->laddr));
 	printf("--tproxy-mark 0x%x/0x%x ",
 	       (unsigned int)info->mark_value, (unsigned int)info->mark_mask);
 }
diff --git a/extensions/libxt_conntrack.c b/extensions/libxt_conntrack.c
index facd0fc..ffa279c 100644
--- a/extensions/libxt_conntrack.c
+++ b/extensions/libxt_conntrack.c
@@ -761,9 +761,9 @@ conntrack_dump_addr(const union nf_inet_addr *addr,
 			return;
 		}
 		if (numeric)
-			printf("%s ", ipaddr_to_numeric(&addr->in));
+			printf("%s ", xtables_ipaddr_to_numeric(&addr->in));
 		else
-			printf("%s ", ipaddr_to_anyname(&addr->in));
+			printf("%s ", xtables_ipaddr_to_anyname(&addr->in));
 	} else if (family == NFPROTO_IPV6) {
 		if (!numeric && addr->ip6[0] == 0 && addr->ip6[1] == 0 &&
 		    addr->ip6[2] == 0 && addr->ip6[3] == 0) {
@@ -771,9 +771,9 @@ conntrack_dump_addr(const union nf_inet_addr *addr,
 			return;
 		}
 		if (numeric)
-			printf("%s ", ip6addr_to_numeric(&addr->in6));
+			printf("%s ", xtables_ip6addr_to_numeric(&addr->in6));
 		else
-			printf("%s ", ip6addr_to_anyname(&addr->in6));
+			printf("%s ", xtables_ip6addr_to_anyname(&addr->in6));
 	}
 }
 
@@ -789,10 +789,10 @@ print_addr(struct in_addr *addr, struct in_addr *mask, int inv, int numeric)
 		printf("%s ", "anywhere");
 	else {
 		if (numeric)
-			sprintf(buf, "%s", ipaddr_to_numeric(addr));
+			strcpy(buf, xtables_ipaddr_to_numeric(addr));
 		else
-			sprintf(buf, "%s", ipaddr_to_anyname(addr));
-		strcat(buf, ipmask_to_numeric(mask));
+			strcpy(buf, xtables_ipaddr_to_anyname(addr));
+		strcat(buf, xtables_ipmask_to_numeric(mask));
 		printf("%s ", buf);
 	}
 }
diff --git a/extensions/libxt_iprange.c b/extensions/libxt_iprange.c
index 0fe2b4f..9fdc70a 100644
--- a/extensions/libxt_iprange.c
+++ b/extensions/libxt_iprange.c
@@ -250,15 +250,15 @@ iprange_mt4_print(const void *ip, const struct xt_entry_match *match,
 		 * ipaddr_to_numeric() uses a static buffer, so cannot
 		 * combine the printf() calls.
 		 */
-		printf("%s", ipaddr_to_numeric(&info->src_min.in));
-		printf("-%s ", ipaddr_to_numeric(&info->src_max.in));
+		printf("%s", xtables_ipaddr_to_numeric(&info->src_min.in));
+		printf("-%s ", xtables_ipaddr_to_numeric(&info->src_max.in));
 	}
 	if (info->flags & IPRANGE_DST) {
 		printf("destination IP range ");
 		if (info->flags & IPRANGE_DST_INV)
 			printf("! ");
-		printf("%s", ipaddr_to_numeric(&info->dst_min.in));
-		printf("-%s ", ipaddr_to_numeric(&info->dst_max.in));
+		printf("%s", xtables_ipaddr_to_numeric(&info->dst_min.in));
+		printf("-%s ", xtables_ipaddr_to_numeric(&info->dst_max.in));
 	}
 }
 
@@ -276,15 +276,15 @@ iprange_mt6_print(const void *ip, const struct xt_entry_match *match,
 		 * ipaddr_to_numeric() uses a static buffer, so cannot
 		 * combine the printf() calls.
 		 */
-		printf("%s", ip6addr_to_numeric(&info->src_min.in6));
-		printf("-%s ", ip6addr_to_numeric(&info->src_max.in6));
+		printf("%s", xtables_ip6addr_to_numeric(&info->src_min.in6));
+		printf("-%s ", xtables_ip6addr_to_numeric(&info->src_max.in6));
 	}
 	if (info->flags & IPRANGE_DST) {
 		printf("destination IP range ");
 		if (info->flags & IPRANGE_DST_INV)
 			printf("! ");
-		printf("%s", ip6addr_to_numeric(&info->dst_min.in6));
-		printf("-%s ", ip6addr_to_numeric(&info->dst_max.in6));
+		printf("%s", xtables_ip6addr_to_numeric(&info->dst_min.in6));
+		printf("-%s ", xtables_ip6addr_to_numeric(&info->dst_max.in6));
 	}
 }
 
@@ -315,14 +315,14 @@ static void iprange_mt4_save(const void *ip, const struct xt_entry_match *match)
 	if (info->flags & IPRANGE_SRC) {
 		if (info->flags & IPRANGE_SRC_INV)
 			printf("! ");
-		printf("--src-range %s", ipaddr_to_numeric(&info->src_min.in));
-		printf("-%s ", ipaddr_to_numeric(&info->src_max.in));
+		printf("--src-range %s", xtables_ipaddr_to_numeric(&info->src_min.in));
+		printf("-%s ", xtables_ipaddr_to_numeric(&info->src_max.in));
 	}
 	if (info->flags & IPRANGE_DST) {
 		if (info->flags & IPRANGE_DST_INV)
 			printf("! ");
-		printf("--dst-range %s", ipaddr_to_numeric(&info->dst_min.in));
-		printf("-%s ", ipaddr_to_numeric(&info->dst_max.in));
+		printf("--dst-range %s", xtables_ipaddr_to_numeric(&info->dst_min.in));
+		printf("-%s ", xtables_ipaddr_to_numeric(&info->dst_max.in));
 	}
 }
 
@@ -333,14 +333,14 @@ static void iprange_mt6_save(const void *ip, const struct xt_entry_match *match)
 	if (info->flags & IPRANGE_SRC) {
 		if (info->flags & IPRANGE_SRC_INV)
 			printf("! ");
-		printf("--src-range %s", ip6addr_to_numeric(&info->src_min.in6));
-		printf("-%s ", ip6addr_to_numeric(&info->src_max.in6));
+		printf("--src-range %s", xtables_ip6addr_to_numeric(&info->src_min.in6));
+		printf("-%s ", xtables_ip6addr_to_numeric(&info->src_max.in6));
 	}
 	if (info->flags & IPRANGE_DST) {
 		if (info->flags & IPRANGE_DST_INV)
 			printf("! ");
-		printf("--dst-range %s", ip6addr_to_numeric(&info->dst_min.in6));
-		printf("-%s ", ip6addr_to_numeric(&info->dst_max.in6));
+		printf("--dst-range %s", xtables_ip6addr_to_numeric(&info->dst_min.in6));
+		printf("-%s ", xtables_ip6addr_to_numeric(&info->dst_max.in6));
 	}
 }
 
diff --git a/include/xtables.h.in b/include/xtables.h.in
index e5737cb..3099de8 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -207,18 +207,18 @@ void exit_error(enum xtables_exittype, const char *, ...)
 	__attribute__((noreturn, format(printf,2,3)));
 extern void xtables_param_act(unsigned int, const char *, ...);
 
-extern const char *ipaddr_to_numeric(const struct in_addr *);
-extern const char *ipaddr_to_anyname(const struct in_addr *);
-extern const char *ipmask_to_numeric(const struct in_addr *);
+extern const char *xtables_ipaddr_to_numeric(const struct in_addr *);
+extern const char *xtables_ipaddr_to_anyname(const struct in_addr *);
+extern const char *xtables_ipmask_to_numeric(const struct in_addr *);
 extern struct in_addr *numeric_to_ipaddr(const char *);
 extern struct in_addr *numeric_to_ipmask(const char *);
 extern void ipparse_hostnetworkmask(const char *, struct in_addr **,
 	struct in_addr *, unsigned int *);
 
 extern struct in6_addr *numeric_to_ip6addr(const char *);
-extern const char *ip6addr_to_numeric(const struct in6_addr *);
-extern const char *ip6addr_to_anyname(const struct in6_addr *);
-extern const char *ip6mask_to_numeric(const struct in6_addr *);
+extern const char *xtables_ip6addr_to_numeric(const struct in6_addr *);
+extern const char *xtables_ip6addr_to_anyname(const struct in6_addr *);
+extern const char *xtables_ip6mask_to_numeric(const struct in6_addr *);
 extern void ip6parse_hostnetworkmask(const char *, struct in6_addr **,
 	struct in6_addr *, unsigned int *);
 
diff --git a/ip6tables.c b/ip6tables.c
index cbacd89..f741c52 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -809,10 +809,10 @@ print_firewall(const struct ip6t_entry *fw,
 		printf(FMT("%-19s ","%s "), "anywhere");
 	else {
 		if (format & FMT_NUMERIC)
-			sprintf(buf, "%s", ip6addr_to_numeric(&fw->ipv6.src));
+			strcpy(buf, xtables_ip6addr_to_numeric(&fw->ipv6.src));
 		else
-			sprintf(buf, "%s", ip6addr_to_anyname(&fw->ipv6.src));
-		strcat(buf, ip6mask_to_numeric(&fw->ipv6.smsk));
+			strcpy(buf, xtables_ip6addr_to_anyname(&fw->ipv6.src));
+		strcat(buf, xtables_ip6mask_to_numeric(&fw->ipv6.smsk));
 		printf(FMT("%-19s ","%s "), buf);
 	}
 
@@ -822,10 +822,10 @@ print_firewall(const struct ip6t_entry *fw,
 		printf(FMT("%-19s ","-> %s"), "anywhere");
 	else {
 		if (format & FMT_NUMERIC)
-			sprintf(buf, "%s", ip6addr_to_numeric(&fw->ipv6.dst));
+			strcpy(buf, xtables_ip6addr_to_numeric(&fw->ipv6.dst));
 		else
-			sprintf(buf, "%s", ip6addr_to_anyname(&fw->ipv6.dst));
-		strcat(buf, ip6mask_to_numeric(&fw->ipv6.dmsk));
+			strcpy(buf, xtables_ip6addr_to_anyname(&fw->ipv6.dst));
+		strcat(buf, xtables_ip6mask_to_numeric(&fw->ipv6.dmsk));
 		printf(FMT("%-19s ","-> %s"), buf);
 	}
 
diff --git a/iptables.c b/iptables.c
index 9adc209..d3906fc 100644
--- a/iptables.c
+++ b/iptables.c
@@ -803,10 +803,10 @@ print_firewall(const struct ipt_entry *fw,
 		printf(FMT("%-19s ","%s "), "anywhere");
 	else {
 		if (format & FMT_NUMERIC)
-			sprintf(buf, "%s", ipaddr_to_numeric(&fw->ip.src));
+			strcpy(buf, xtables_ipaddr_to_numeric(&fw->ip.src));
 		else
-			sprintf(buf, "%s", ipaddr_to_anyname(&fw->ip.src));
-		strcat(buf, ipmask_to_numeric(&fw->ip.smsk));
+			strcpy(buf, xtables_ipaddr_to_anyname(&fw->ip.src));
+		strcat(buf, xtables_ipmask_to_numeric(&fw->ip.smsk));
 		printf(FMT("%-19s ","%s "), buf);
 	}
 
@@ -815,10 +815,10 @@ print_firewall(const struct ipt_entry *fw,
 		printf(FMT("%-19s ","-> %s"), "anywhere");
 	else {
 		if (format & FMT_NUMERIC)
-			sprintf(buf, "%s", ipaddr_to_numeric(&fw->ip.dst));
+			strcpy(buf, xtables_ipaddr_to_numeric(&fw->ip.dst));
 		else
-			sprintf(buf, "%s", ipaddr_to_anyname(&fw->ip.dst));
-		strcat(buf, ipmask_to_numeric(&fw->ip.dmsk));
+			strcpy(buf, xtables_ipaddr_to_anyname(&fw->ip.dst));
+		strcat(buf, xtables_ipmask_to_numeric(&fw->ip.dmsk));
 		printf(FMT("%-19s ","-> %s"), buf);
 	}
 
diff --git a/xtables.c b/xtables.c
index 3ffefa2..07275f6 100644
--- a/xtables.c
+++ b/xtables.c
@@ -748,7 +748,7 @@ void xtables_param_act(unsigned int status, const char *p1, ...)
 	va_end(args);
 }
 
-const char *ipaddr_to_numeric(const struct in_addr *addrp)
+const char *xtables_ipaddr_to_numeric(const struct in_addr *addrp)
 {
 	static char buf[20];
 	const unsigned char *bytep = (const void *)&addrp->s_addr;
@@ -778,7 +778,7 @@ static const char *ipaddr_to_network(const struct in_addr *addr)
 	return NULL;
 }
 
-const char *ipaddr_to_anyname(const struct in_addr *addr)
+const char *xtables_ipaddr_to_anyname(const struct in_addr *addr)
 {
 	const char *name;
 
@@ -786,10 +786,10 @@ const char *ipaddr_to_anyname(const struct in_addr *addr)
 	    (name = ipaddr_to_network(addr)) != NULL)
 		return name;
 
-	return ipaddr_to_numeric(addr);
+	return xtables_ipaddr_to_numeric(addr);
 }
 
-const char *ipmask_to_numeric(const struct in_addr *mask)
+const char *xtables_ipmask_to_numeric(const struct in_addr *mask)
 {
 	static char buf[20];
 	uint32_t maskaddr, bits;
@@ -809,7 +809,7 @@ const char *ipmask_to_numeric(const struct in_addr *mask)
 		sprintf(buf, "/%d", i);
 	else
 		/* mask was not a decent combination of 1's and 0's */
-		sprintf(buf, "/%s", ipaddr_to_numeric(mask));
+		sprintf(buf, "/%s", xtables_ipaddr_to_numeric(mask));
 
 	return buf;
 }
@@ -987,7 +987,7 @@ void ipparse_hostnetworkmask(const char *name, struct in_addr **addrpp,
 	}
 }
 
-const char *ip6addr_to_numeric(const struct in6_addr *addrp)
+const char *xtables_ip6addr_to_numeric(const struct in6_addr *addrp)
 {
 	/* 0000:0000:0000:0000:0000:000.000.000.000
 	 * 0000:0000:0000:0000:0000:0000:0000:0000 */
@@ -1020,14 +1020,14 @@ static const char *ip6addr_to_host(const struct in6_addr *addr)
 	return hostname;
 }
 
-const char *ip6addr_to_anyname(const struct in6_addr *addr)
+const char *xtables_ip6addr_to_anyname(const struct in6_addr *addr)
 {
 	const char *name;
 
 	if ((name = ip6addr_to_host(addr)) != NULL)
 		return name;
 
-	return ip6addr_to_numeric(addr);
+	return xtables_ip6addr_to_numeric(addr);
 }
 
 static int ip6addr_prefix_length(const struct in6_addr *k)
@@ -1054,14 +1054,14 @@ static int ip6addr_prefix_length(const struct in6_addr *k)
 	return bits;
 }
 
-const char *ip6mask_to_numeric(const struct in6_addr *addrp)
+const char *xtables_ip6mask_to_numeric(const struct in6_addr *addrp)
 {
 	static char buf[50+2];
 	int l = ip6addr_prefix_length(addrp);
 
 	if (l == -1) {
 		strcpy(buf, "/");
-		strcat(buf, ip6addr_to_numeric(addrp));
+		strcat(buf, xtables_ip6addr_to_numeric(addrp));
 		return buf;
 	}
 	sprintf(buf, "/%d", l);
-- 
1.6.1.2

