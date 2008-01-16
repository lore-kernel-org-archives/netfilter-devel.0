From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [12/19] bunch o' renames
Date: Wed, 16 Jan 2008 14:51:46 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801161451320.4953@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48707 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753659AbYAPNvr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:51:47 -0500
In-Reply-To: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Move a few functions from iptables.c/ip6tables.c to xtables.c
so they are available for combined (both AF_INET and AF_INET6)
libxt modules. Rename overlapping function names.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libipt_DNAT.c     |    4 -
 extensions/libipt_NETMAP.c   |    4 -
 extensions/libipt_SAME.c     |    8 +-
 extensions/libipt_SNAT.c     |    4 -
 extensions/libipt_policy.c   |    8 +-
 extensions/libxt_conntrack.c |    7 +-
 include/iptables.h           |    3 
 include/xtables.h            |    8 ++
 ip6tables.c                  |   91 ++------------------------
 iptables.c                   |   84 +-----------------------
 xtables.c                    |  148 +++++++++++++++++++++++++++++++++++++++++++
 11 files changed, 190 insertions(+), 179 deletions(-)

Index: iptables-modules/extensions/libipt_DNAT.c
===================================================================
--- iptables-modules.orig/extensions/libipt_DNAT.c
+++ iptables-modules/extensions/libipt_DNAT.c
@@ -198,10 +198,10 @@ static void print_range(const struct ip_
 		struct in_addr a;
 
 		a.s_addr = r->min_ip;
-		printf("%s", addr_to_dotted(&a));
+		printf("%s", ipaddr_to_numeric(&a));
 		if (r->max_ip != r->min_ip) {
 			a.s_addr = r->max_ip;
-			printf("-%s", addr_to_dotted(&a));
+			printf("-%s", ipaddr_to_numeric(&a));
 		}
 	}
 	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
Index: iptables-modules/extensions/libipt_NETMAP.c
===================================================================
--- iptables-modules.orig/extensions/libipt_NETMAP.c
+++ iptables-modules/extensions/libipt_NETMAP.c
@@ -154,11 +154,11 @@ static void NETMAP_print(const void *ip,
 	int bits;
 
 	a.s_addr = r->min_ip;
-	printf("%s", addr_to_dotted(&a));
+	printf("%s", ipaddr_to_numeric(&a));
 	a.s_addr = ~(r->min_ip ^ r->max_ip);
 	bits = netmask2bits(a.s_addr);
 	if (bits < 0)
-		printf("/%s", addr_to_dotted(&a));
+		printf("/%s", ipaddr_to_numeric(&a));
 	else
 		printf("/%d", bits);
 }
Index: iptables-modules/extensions/libipt_SAME.c
===================================================================
--- iptables-modules.orig/extensions/libipt_SAME.c
+++ iptables-modules/extensions/libipt_SAME.c
@@ -159,13 +159,13 @@ static void SAME_print(const void *ip, c
 
 		a.s_addr = r->min_ip;
 
-		printf("%s", addr_to_dotted(&a));
+		printf("%s", ipaddr_to_numeric(&a));
 		a.s_addr = r->max_ip;
 		
 		if (r->min_ip == r->max_ip)
 			printf(" ");
 		else
-			printf("-%s ", addr_to_dotted(&a));
+			printf("-%s ", ipaddr_to_numeric(&a));
 		if (r->flags & IP_NAT_RANGE_PROTO_RANDOM) 
 			random = 1;
 	}
@@ -190,13 +190,13 @@ static void SAME_save(const void *ip, co
 		struct in_addr a;
 
 		a.s_addr = r->min_ip;
-		printf("--to %s", addr_to_dotted(&a));
+		printf("--to %s", ipaddr_to_numeric(&a));
 		a.s_addr = r->max_ip;
 
 		if (r->min_ip == r->max_ip)
 			printf(" ");
 		else
-			printf("-%s ", addr_to_dotted(&a));
+			printf("-%s ", ipaddr_to_numeric(&a));
 		if (r->flags & IP_NAT_RANGE_PROTO_RANDOM) 
 			random = 1;
 	}
Index: iptables-modules/extensions/libipt_SNAT.c
===================================================================
--- iptables-modules.orig/extensions/libipt_SNAT.c
+++ iptables-modules/extensions/libipt_SNAT.c
@@ -199,10 +199,10 @@ static void print_range(const struct ip_
 		struct in_addr a;
 
 		a.s_addr = r->min_ip;
-		printf("%s", addr_to_dotted(&a));
+		printf("%s", ipaddr_to_numeric(&a));
 		if (r->max_ip != r->min_ip) {
 			a.s_addr = r->max_ip;
-			printf("-%s", addr_to_dotted(&a));
+			printf("-%s", ipaddr_to_numeric(&a));
 		}
 	}
 	if (r->flags & IP_NAT_RANGE_PROTO_SPECIFIED) {
Index: iptables-modules/extensions/libipt_policy.c
===================================================================
--- iptables-modules.orig/extensions/libipt_policy.c
+++ iptables-modules/extensions/libipt_policy.c
@@ -353,14 +353,14 @@ static void print_entry(char *prefix, co
 	if (e->match.daddr) {
 		PRINT_INVERT(e->invert.daddr);
 		printf("%stunnel-dst %s%s ", prefix,
-		       addr_to_dotted((struct in_addr *)&e->daddr),
-		       mask_to_dotted((struct in_addr *)&e->dmask));
+		       ipaddr_to_numeric((const void *)&e->daddr),
+		       ipmask_to_numeric((const void *)&e->dmask));
 	}
 	if (e->match.saddr) {
 		PRINT_INVERT(e->invert.saddr);
 		printf("%stunnel-src %s%s ", prefix,
-		       addr_to_dotted((struct in_addr *)&e->saddr),
-		       mask_to_dotted((struct in_addr *)&e->smask));
+		       ipaddr_to_numeric((const void *)&e->saddr),
+		       ipmask_to_numeric((const void *)&e->smask));
 	}
 }
 
Index: iptables-modules/extensions/libxt_conntrack.c
===================================================================
--- iptables-modules.orig/extensions/libxt_conntrack.c
+++ iptables-modules/extensions/libxt_conntrack.c
@@ -9,6 +9,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <iptables.h>
+#include <xtables.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/xt_conntrack.h>
 #include <linux/netfilter/nf_conntrack_common.h>
@@ -388,10 +389,10 @@ print_addr(struct in_addr *addr, struct 
 		printf("%s ", "anywhere");
 	else {
 		if (numeric)
-			sprintf(buf, "%s", addr_to_dotted(addr));
+			sprintf(buf, "%s", ipaddr_to_numeric(addr));
 		else
-			sprintf(buf, "%s", addr_to_anyname(addr));
-		strcat(buf, mask_to_dotted(mask));
+			sprintf(buf, "%s", ipaddr_to_anyname(addr));
+		strcat(buf, ipmask_to_numeric(mask));
 		printf("%s ", buf);
 	}
 }
Index: iptables-modules/include/iptables.h
===================================================================
--- iptables-modules.orig/include/iptables.h
+++ iptables-modules/include/iptables.h
@@ -26,9 +26,6 @@ extern void register_target(struct iptab
 
 extern struct in_addr *dotted_to_addr(const char *dotted);
 extern struct in_addr *dotted_to_mask(const char *dotted);
-extern char *addr_to_dotted(const struct in_addr *addrp);
-extern char *addr_to_anyname(const struct in_addr *addr);
-extern char *mask_to_dotted(const struct in_addr *mask);
 
 extern void parse_hostnetworkmask(const char *name, struct in_addr **addrpp,
                       struct in_addr *maskp, unsigned int *naddrs);
Index: iptables-modules/include/xtables.h
===================================================================
--- iptables-modules.orig/include/xtables.h
+++ iptables-modules/include/xtables.h
@@ -236,6 +236,14 @@ void exit_error(enum exittype, const cha
 extern void param_act(unsigned int, const char *, ...);
 extern const char *program_name, *program_version;
 
+extern const char *ipaddr_to_numeric(const struct in_addr *);
+extern const char *ipaddr_to_anyname(const struct in_addr *);
+extern const char *ipmask_to_numeric(const struct in_addr *);
+
+extern const char *ip6addr_to_numeric(const struct in6_addr *);
+extern const char *ip6addr_to_anyname(const struct in6_addr *);
+extern const char *ip6mask_to_numeric(const struct in6_addr *);
+
 #ifdef NO_SHARED_LIBS
 #	ifdef _INIT
 #		undef _init
Index: iptables-modules/ip6tables.c
===================================================================
--- iptables-modules.orig/ip6tables.c
+++ iptables-modules/ip6tables.c
@@ -250,13 +250,6 @@ proto_to_name(u_int8_t proto, int nolook
 	return NULL;
 }
 
-static void
-in6addrcpy(struct in6_addr *dst, struct in6_addr *src)
-{
-	memcpy(dst, src, sizeof(struct in6_addr));
-	/* dst->s6_addr = src->s6_addr; */
-}
-
 static void free_opts(int reset_offset)
 {
 	if (opts != original_opts) {
@@ -466,15 +459,6 @@ check_inverse(const char option[], int *
 	return FALSE;
 }
 
-static char *
-addr_to_numeric(const struct in6_addr *addrp)
-{
-	/* 0000:0000:0000:0000:0000:000.000.000.000
-	 * 0000:0000:0000:0000:0000:0000:0000:0000 */
-	static char buf[50+1];
-	return (char *)inet_ntop(AF_INET6, addrp, buf, sizeof(buf));
-}
-
 static struct in6_addr *
 numeric_to_addr(const char *num)
 {
@@ -521,8 +505,8 @@ host_to_addr(const char *name, unsigned 
 #endif
 		/* Get the first element of the address-chain */
 		addr = fw_calloc(1, sizeof(struct in6_addr));
-		in6addrcpy(addr, (struct in6_addr *)
-			&((struct sockaddr_in6 *)res->ai_addr)->sin6_addr);
+		memcpy(addr, &((const struct sockaddr_in6 *)res->ai_addr)->sin6_addr,
+		       sizeof(struct in6_addr));
 		freeaddrinfo(res);
 		*naddr = 1;
 		return addr;
@@ -531,50 +515,6 @@ host_to_addr(const char *name, unsigned 
 	return (struct in6_addr *) NULL;
 }
 
-static char *
-addr_to_host(const struct in6_addr *addr)
-{
-	struct sockaddr_in6 saddr;
-	int err;
-	static char hostname[NI_MAXHOST];
-
-	memset(&saddr, 0, sizeof(struct sockaddr_in6));
-	in6addrcpy(&(saddr.sin6_addr),(struct in6_addr *)addr);
-	saddr.sin6_family = AF_INET6;
-
-        if ( (err=getnameinfo((struct sockaddr *)&saddr,
-			       sizeof(struct sockaddr_in6),
-			       hostname, sizeof(hostname)-1,
-			       NULL, 0, 0)) != 0 ){
-#ifdef DEBUG
-                fprintf(stderr,"IP2Name: %s\n",gai_strerror(err)); 
-#endif
-                return (char *) NULL;
-        } else {
-#ifdef DEBUG
-		fprintf (stderr, "\naddr2host: %s\n", hostname);
-#endif
-
-		return hostname;
-	}
-
-	return (char *) NULL;
-}
-
-static char *
-mask_to_numeric(const struct in6_addr *addrp)
-{
-	static char buf[50+2];
-	int l = ipv6_prefix_length(addrp);
-	if (l == -1) {
-		strcpy(buf, "/");
-		strcat(buf, addr_to_numeric(addrp));
-		return buf;
-	}
-	sprintf(buf, "/%d", l);
-	return buf;
-}
-
 static struct in6_addr *
 network_to_addr(const char *name)
 {
@@ -584,17 +524,6 @@ network_to_addr(const char *name)
 	return (struct in6_addr *)NULL;
 }
 
-static char *
-addr_to_anyname(const struct in6_addr *addr)
-{
-	char *name;
-
-	if ((name = addr_to_host(addr)) != NULL)
-		return name;
-
-	return addr_to_numeric(addr);
-}
-
 /*
  *	All functions starting with "parse" should succeed, otherwise
  *	the program fails.
@@ -612,7 +541,7 @@ parse_hostnetwork(const char *name, unsi
 	if ((addrptmp = numeric_to_addr(name)) != NULL ||
 	    (addrptmp = network_to_addr(name)) != NULL) {
 		addrp = fw_malloc(sizeof(struct in6_addr));
-		in6addrcpy(addrp, addrptmp);
+		memcpy(addrp, addrptmp, sizeof(*addrp));
 		*naddrs = 1;
 		return addrp;
 	}
@@ -667,7 +596,7 @@ parse_hostnetworkmask(const char *name, 
 		addrp = parse_mask(p + 1);
 	} else
 		addrp = parse_mask(NULL);
-	in6addrcpy(maskp, addrp);
+	memcpy(maskp, addrp, sizeof(*maskp));
 
 	/* if a null mask is given, the name is ignored, like in "any/0" */
 	if (!memcmp(maskp, &in6addr_any, sizeof(in6addr_any)))
@@ -1029,10 +958,10 @@ print_firewall(const struct ip6t_entry *
 		printf(FMT("%-19s ","%s "), "anywhere");
 	else {
 		if (format & FMT_NUMERIC)
-			sprintf(buf, "%s", addr_to_numeric(&(fw->ipv6.src)));
+			sprintf(buf, "%s", ip6addr_to_numeric(&fw->ipv6.src));
 		else
-			sprintf(buf, "%s", addr_to_anyname(&(fw->ipv6.src)));
-		strcat(buf, mask_to_numeric(&(fw->ipv6.smsk)));
+			sprintf(buf, "%s", ip6addr_to_anyname(&fw->ipv6.src));
+		strcat(buf, ip6mask_to_numeric(&fw->ipv6.smsk));
 		printf(FMT("%-19s ","%s "), buf);
 	}
 
@@ -1042,10 +971,10 @@ print_firewall(const struct ip6t_entry *
 		printf(FMT("%-19s","-> %s"), "anywhere");
 	else {
 		if (format & FMT_NUMERIC)
-			sprintf(buf, "%s", addr_to_numeric(&(fw->ipv6.dst)));
+			sprintf(buf, "%s", ip6addr_to_numeric(&fw->ipv6.dst));
 		else
-			sprintf(buf, "%s", addr_to_anyname(&(fw->ipv6.dst)));
-		strcat(buf, mask_to_numeric(&(fw->ipv6.dmsk)));
+			sprintf(buf, "%s", ip6addr_to_anyname(&fw->ipv6.dst));
+		strcat(buf, ip6mask_to_numeric(&fw->ipv6.dmsk));
 		printf(FMT("%-19s","-> %s"), buf);
 	}
 
Index: iptables-modules/iptables.c
===================================================================
--- iptables-modules.orig/iptables.c
+++ iptables-modules/iptables.c
@@ -575,18 +575,6 @@ host_to_addr(const char *name, unsigned 
 	return (struct in_addr *) NULL;
 }
 
-static char *
-addr_to_host(const struct in_addr *addr)
-{
-	struct hostent *host;
-
-	if ((host = gethostbyaddr((char *) addr,
-				  sizeof(struct in_addr), AF_INET)) != NULL)
-		return (char *) host->h_name;
-
-	return (char *) NULL;
-}
-
 /*
  *	All functions starting with "parse" should succeed, otherwise
  *	the program fails.
@@ -765,66 +753,6 @@ parse_target(const char *targetname)
 	return targetname;
 }
 
-static char *
-addr_to_network(const struct in_addr *addr)
-{
-	struct netent *net;
-
-	if ((net = getnetbyaddr((long) ntohl(addr->s_addr), AF_INET)) != NULL)
-		return (char *) net->n_name;
-
-	return (char *) NULL;
-}
-
-char *
-addr_to_dotted(const struct in_addr *addrp)
-{
-	static char buf[20];
-	const unsigned char *bytep;
-
-	bytep = (const unsigned char *) &(addrp->s_addr);
-	sprintf(buf, "%d.%d.%d.%d", bytep[0], bytep[1], bytep[2], bytep[3]);
-	return buf;
-}
-
-char *
-addr_to_anyname(const struct in_addr *addr)
-{
-	char *name;
-
-	if ((name = addr_to_host(addr)) != NULL ||
-	    (name = addr_to_network(addr)) != NULL)
-		return name;
-
-	return addr_to_dotted(addr);
-}
-
-char *
-mask_to_dotted(const struct in_addr *mask)
-{
-	int i;
-	static char buf[20];
-	u_int32_t maskaddr, bits;
-
-	maskaddr = ntohl(mask->s_addr);
-
-	if (maskaddr == 0xFFFFFFFFL)
-		/* we don't want to see "/32" */
-		return "";
-
-	i = 32;
-	bits = 0xFFFFFFFEL;
-	while (--i >= 0 && maskaddr != bits)
-		bits <<= 1;
-	if (i >= 0)
-		sprintf(buf, "/%d", i);
-	else
-		/* mask was not a decent combination of 1's and 0's */
-		sprintf(buf, "/%s", addr_to_dotted(mask));
-
-	return buf;
-}
-
 static void
 set_option(unsigned int *options, unsigned int option, u_int8_t *invflg,
 	   int invert)
@@ -1066,10 +994,10 @@ print_firewall(const struct ipt_entry *f
 		printf(FMT("%-19s ","%s "), "anywhere");
 	else {
 		if (format & FMT_NUMERIC)
-			sprintf(buf, "%s", addr_to_dotted(&(fw->ip.src)));
+			sprintf(buf, "%s", ipaddr_to_numeric(&fw->ip.src));
 		else
-			sprintf(buf, "%s", addr_to_anyname(&(fw->ip.src)));
-		strcat(buf, mask_to_dotted(&(fw->ip.smsk)));
+			sprintf(buf, "%s", ipaddr_to_anyname(&fw->ip.src));
+		strcat(buf, ipmask_to_numeric(&fw->ip.smsk));
 		printf(FMT("%-19s ","%s "), buf);
 	}
 
@@ -1078,10 +1006,10 @@ print_firewall(const struct ipt_entry *f
 		printf(FMT("%-19s ","-> %s"), "anywhere");
 	else {
 		if (format & FMT_NUMERIC)
-			sprintf(buf, "%s", addr_to_dotted(&(fw->ip.dst)));
+			sprintf(buf, "%s", ipaddr_to_numeric(&fw->ip.dst));
 		else
-			sprintf(buf, "%s", addr_to_anyname(&(fw->ip.dst)));
-		strcat(buf, mask_to_dotted(&(fw->ip.dmsk)));
+			sprintf(buf, "%s", ipaddr_to_anyname(&fw->ip.dst));
+		strcat(buf, ipmask_to_numeric(&fw->ip.dmsk));
 		printf(FMT("%-19s ","-> %s"), buf);
 	}
 
Index: iptables-modules/xtables.c
===================================================================
--- iptables-modules.orig/xtables.c
+++ iptables-modules/xtables.c
@@ -29,6 +29,7 @@
 #include <sys/stat.h>
 #include <sys/types.h>
 #include <sys/wait.h>
+#include <arpa/inet.h>
 
 #include <xtables.h>
 
@@ -702,3 +703,150 @@ void param_act(unsigned int status, cons
 
 	va_end(args);
 }
+
+const char *ipaddr_to_numeric(const struct in_addr *addrp)
+{
+	static char buf[20];
+	const unsigned char *bytep = (const void *)&addrp->s_addr;
+
+	sprintf(buf, "%u.%u.%u.%u", bytep[0], bytep[1], bytep[2], bytep[3]);
+	return buf;
+}
+
+static const char *ipaddr_to_host(const struct in_addr *addr)
+{
+	struct hostent *host;
+
+	host = gethostbyaddr(addr, sizeof(struct in_addr), AF_INET);
+	if (host == NULL)
+		return NULL;
+
+	return host->h_name;
+}
+
+static const char *ipaddr_to_network(const struct in_addr *addr)
+{
+	struct netent *net;
+
+	if ((net = getnetbyaddr(ntohl(addr->s_addr), AF_INET)) != NULL)
+		return net->n_name;
+
+	return NULL;
+}
+
+const char *ipaddr_to_anyname(const struct in_addr *addr)
+{
+	const char *name;
+
+	if ((name = ipaddr_to_host(addr)) != NULL ||
+	    (name = ipaddr_to_network(addr)) != NULL)
+		return name;
+
+	return ipaddr_to_numeric(addr);
+}
+
+const char *ipmask_to_numeric(const struct in_addr *mask)
+{
+	static char buf[20];
+	uint32_t maskaddr, bits;
+	int i;
+
+	maskaddr = ntohl(mask->s_addr);
+
+	if (maskaddr == 0xFFFFFFFFL)
+		/* we don't want to see "/32" */
+		return "";
+
+	i = 32;
+	bits = 0xFFFFFFFEL;
+	while (--i >= 0 && maskaddr != bits)
+		bits <<= 1;
+	if (i >= 0)
+		sprintf(buf, "/%d", i);
+	else
+		/* mask was not a decent combination of 1's and 0's */
+		sprintf(buf, "/%s", ipaddr_to_numeric(mask));
+
+	return buf;
+}
+
+const char *ip6addr_to_numeric(const struct in6_addr *addrp)
+{
+	/* 0000:0000:0000:0000:0000:000.000.000.000
+	 * 0000:0000:0000:0000:0000:0000:0000:0000 */
+	static char buf[50+1];
+	return inet_ntop(AF_INET6, addrp, buf, sizeof(buf));
+}
+
+static const char *ip6addr_to_host(const struct in6_addr *addr)
+{
+	static char hostname[NI_MAXHOST];
+	struct sockaddr_in6 saddr;
+	int err;
+
+	memset(&saddr, 0, sizeof(struct sockaddr_in6));
+	memcpy(&saddr.sin6_addr, addr, sizeof(*addr));
+	saddr.sin6_family = AF_INET6;
+
+	err = getnameinfo((const void *)&saddr, sizeof(struct sockaddr_in6),
+	      hostname, sizeof(hostname) - 1, NULL, 0, 0);
+	if (err != 0) {
+#ifdef DEBUG
+		fprintf(stderr,"IP2Name: %s\n",gai_strerror(err));
+#endif
+		return NULL;
+	}
+
+#ifdef DEBUG
+	fprintf (stderr, "\naddr2host: %s\n", hostname);
+#endif
+	return hostname;
+}
+
+const char *ip6addr_to_anyname(const struct in6_addr *addr)
+{
+	const char *name;
+
+	if ((name = ip6addr_to_host(addr)) != NULL)
+		return name;
+
+	return ip6addr_to_numeric(addr);
+}
+
+static int ip6addr_prefix_length(const struct in6_addr *k)
+{
+	unsigned int bits = 0;
+	uint32_t a, b, c, d;
+
+	a = k->s6_addr32[0];
+	b = k->s6_addr32[1];
+	c = k->s6_addr32[2];
+	d = k->s6_addr32[3];
+	while (a & 0x80000000U) {
+		++bits;
+		a <<= 1;
+		a  |= (b >> 31) & 1;
+		b <<= 1;
+		b  |= (c >> 31) & 1;
+		c <<= 1;
+		c  |= (d >> 31) & 1;
+		d <<= 1;
+	}
+	if (a != 0 || b != 0 || c != 0 || d != 0)
+		return -1;
+	return bits;
+}
+
+const char *ip6mask_to_numeric(const struct in6_addr *addrp)
+{
+	static char buf[50+2];
+	int l = ip6addr_prefix_length(addrp);
+
+	if (l == -1) {
+		strcpy(buf, "/");
+		strcat(buf, ip6addr_to_numeric(addrp));
+		return buf;
+	}
+	sprintf(buf, "/%d", l);
+	return buf;
+}
