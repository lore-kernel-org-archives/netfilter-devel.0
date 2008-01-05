From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 13/21] Move parsing functions to xtables.c
Date: Sat, 5 Jan 2008 15:47:42 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801051546540.14194@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801041525100.8731@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:37252 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753595AbYAEOro (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Jan 2008 09:47:44 -0500
In-Reply-To: <Pine.LNX.4.64.0801041525100.8731@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Move parsing functions to xtables.c

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libipt_DNAT.c     |    6 
 extensions/libipt_NETMAP.c   |    6 
 extensions/libipt_SAME.c     |    6 
 extensions/libipt_SNAT.c     |    6 
 extensions/libipt_iprange.c  |    6 
 extensions/libipt_policy.c   |    4 
 extensions/libxt_conntrack.c |    8 -
 include/iptables.h           |    5 
 include/xtables.h            |    7 
 ip6tables.c                  |  159 ---------------------
 iptables.c                   |  198 --------------------------
 xtables.c                    |  318 +++++++++++++++++++++++++++++++++++++++++++
 12 files changed, 354 insertions(+), 375 deletions(-)

Index: iptables-modules/extensions/libipt_DNAT.c
===================================================================
--- iptables-modules.orig/extensions/libipt_DNAT.c
+++ iptables-modules/extensions/libipt_DNAT.c
@@ -62,7 +62,7 @@ parse_to(char *arg, int portok, struct i
 {
 	struct ip_nat_range range;
 	char *colon, *dash, *error;
-	struct in_addr *ip;
+	const struct in_addr *ip;
 
 	memset(&range, 0, sizeof(range));
 	colon = strchr(arg, ':');
@@ -119,13 +119,13 @@ parse_to(char *arg, int portok, struct i
 	if (dash)
 		*dash = '\0';
 
-	ip = dotted_to_addr(arg);
+	ip = numeric_to_ipaddr(arg);
 	if (!ip)
 		exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
 			   arg);
 	range.min_ip = ip->s_addr;
 	if (dash) {
-		ip = dotted_to_addr(dash+1);
+		ip = numeric_to_ipaddr(dash+1);
 		if (!ip)
 			exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
 				   dash+1);
Index: iptables-modules/extensions/libipt_NETMAP.c
===================================================================
--- iptables-modules.orig/extensions/libipt_NETMAP.c
+++ iptables-modules/extensions/libipt_NETMAP.c
@@ -68,7 +68,7 @@ static void
 parse_to(char *arg, struct ip_nat_range *range)
 {
 	char *slash;
-	struct in_addr *ip;
+	const struct in_addr *ip;
 	u_int32_t netmask;
 	unsigned int bits;
 
@@ -77,14 +77,14 @@ parse_to(char *arg, struct ip_nat_range 
 	if (slash)
 		*slash = '\0';
 
-	ip = dotted_to_addr(arg);
+	ip = numeric_to_ipaddr(arg);
 	if (!ip)
 		exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
 			   arg);
 	range->min_ip = ip->s_addr;
 	if (slash) {
 		if (strchr(slash+1, '.')) {
-			ip = dotted_to_mask(slash+1);
+			ip = numeric_to_ipmask(slash+1);
 			if (!ip)
 				exit_error(PARAMETER_PROBLEM, "Bad netmask `%s'\n",
 					   slash+1);
Index: iptables-modules/extensions/libipt_SAME.c
===================================================================
--- iptables-modules.orig/extensions/libipt_SAME.c
+++ iptables-modules/extensions/libipt_SAME.c
@@ -52,7 +52,7 @@ static void
 parse_to(char *arg, struct ip_nat_range *range)
 {
 	char *dash;
-	struct in_addr *ip;
+	const struct in_addr *ip;
 
 	range->flags |= IP_NAT_RANGE_MAP_IPS;
 	dash = strchr(arg, '-');
@@ -60,14 +60,14 @@ parse_to(char *arg, struct ip_nat_range 
 	if (dash)
 		*dash = '\0';
 
-	ip = dotted_to_addr(arg);
+	ip = numeric_to_ipaddr(arg);
 	if (!ip)
 		exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
 			   arg);
 	range->min_ip = ip->s_addr;
 
 	if (dash) {
-		ip = dotted_to_addr(dash+1);
+		ip = numeric_to_ipaddr(dash+1);
 		if (!ip)
 			exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
 				   dash+1);
Index: iptables-modules/extensions/libipt_SNAT.c
===================================================================
--- iptables-modules.orig/extensions/libipt_SNAT.c
+++ iptables-modules/extensions/libipt_SNAT.c
@@ -62,7 +62,7 @@ parse_to(char *arg, int portok, struct i
 {
 	struct ip_nat_range range;
 	char *colon, *dash, *error;
-	struct in_addr *ip;
+	const struct in_addr *ip;
 
 	memset(&range, 0, sizeof(range));
 	colon = strchr(arg, ':');
@@ -119,13 +119,13 @@ parse_to(char *arg, int portok, struct i
 	if (dash)
 		*dash = '\0';
 
-	ip = dotted_to_addr(arg);
+	ip = numeric_to_ipaddr(arg);
 	if (!ip)
 		exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
 			   arg);
 	range.min_ip = ip->s_addr;
 	if (dash) {
-		ip = dotted_to_addr(dash+1);
+		ip = numeric_to_ipaddr(dash+1);
 		if (!ip)
 			exit_error(PARAMETER_PROBLEM, "Bad IP address `%s'\n",
 				   dash+1);
Index: iptables-modules/extensions/libipt_iprange.c
===================================================================
--- iptables-modules.orig/extensions/libipt_iprange.c
+++ iptables-modules/extensions/libipt_iprange.c
@@ -29,20 +29,20 @@ static void
 parse_iprange(char *arg, struct ipt_iprange *range)
 {
 	char *dash;
-	struct in_addr *ip;
+	const struct in_addr *ip;
 
 	dash = strchr(arg, '-');
 	if (dash)
 		*dash = '\0';
 		
-	ip = dotted_to_addr(arg);
+	ip = numeric_to_ipaddr(arg);
 	if (!ip)
 		exit_error(PARAMETER_PROBLEM, "iprange match: Bad IP address `%s'\n", 
 			   arg);
 	range->min_ip = ip->s_addr;
 
 	if (dash) {
-		ip = dotted_to_addr(dash+1);
+		ip = numeric_to_ipaddr(dash+1);
 		if (!ip)
 			exit_error(PARAMETER_PROBLEM, "iprange match: Bad IP address `%s'\n",
 				   dash+1);
Index: iptables-modules/extensions/libipt_policy.c
===================================================================
--- iptables-modules.orig/extensions/libipt_policy.c
+++ iptables-modules/extensions/libipt_policy.c
@@ -183,7 +183,7 @@ static int policy_parse(int c, char **ar
 			exit_error(PARAMETER_PROBLEM,
 			           "policy match: double --tunnel-src option");
 
-		parse_hostnetworkmask(argv[optind-1], &addr, &mask, &naddr);
+		ipparse_hostnetworkmask(argv[optind-1], &addr, &mask, &naddr);
 		if (naddr > 1)
 			exit_error(PARAMETER_PROBLEM,
 			           "policy match: name resolves to multiple IPs");
@@ -198,7 +198,7 @@ static int policy_parse(int c, char **ar
 			exit_error(PARAMETER_PROBLEM,
 			           "policy match: double --tunnel-dst option");
 
-		parse_hostnetworkmask(argv[optind-1], &addr, &mask, &naddr);
+		ipparse_hostnetworkmask(argv[optind-1], &addr, &mask, &naddr);
 		if (naddr > 1)
 			exit_error(PARAMETER_PROBLEM,
 			           "policy match: name resolves to multiple IPs");
Index: iptables-modules/extensions/libxt_conntrack.c
===================================================================
--- iptables-modules.orig/extensions/libxt_conntrack.c
+++ iptables-modules/extensions/libxt_conntrack.c
@@ -206,7 +206,7 @@ static int conntrack_parse(int c, char *
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_ORIGSRC;
 
-		parse_hostnetworkmask(argv[optind-1], &addrs,
+		ipparse_hostnetworkmask(argv[optind-1], &addrs,
 					&sinfo->sipmsk[IP_CT_DIR_ORIGINAL],
 					&naddrs);
 		if(naddrs > 1)
@@ -226,7 +226,7 @@ static int conntrack_parse(int c, char *
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_ORIGDST;
 
-		parse_hostnetworkmask(argv[optind-1], &addrs,
+		ipparse_hostnetworkmask(argv[optind-1], &addrs,
 					&sinfo->dipmsk[IP_CT_DIR_ORIGINAL],
 					&naddrs);
 		if(naddrs > 1)
@@ -246,7 +246,7 @@ static int conntrack_parse(int c, char *
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_REPLSRC;
 
-		parse_hostnetworkmask(argv[optind-1], &addrs,
+		ipparse_hostnetworkmask(argv[optind-1], &addrs,
 					&sinfo->sipmsk[IP_CT_DIR_REPLY],
 					&naddrs);
 		if(naddrs > 1)
@@ -266,7 +266,7 @@ static int conntrack_parse(int c, char *
 		if (invert)
 			sinfo->invflags |= XT_CONNTRACK_REPLDST;
 
-		parse_hostnetworkmask(argv[optind-1], &addrs,
+		ipparse_hostnetworkmask(argv[optind-1], &addrs,
 					&sinfo->dipmsk[IP_CT_DIR_REPLY],
 					&naddrs);
 		if(naddrs > 1)
Index: iptables-modules/include/iptables.h
===================================================================
--- iptables-modules.orig/include/iptables.h
+++ iptables-modules/include/iptables.h
@@ -24,11 +24,6 @@ extern int line;
 extern void register_match(struct iptables_match *me);
 extern void register_target(struct iptables_target *me);
 
-extern struct in_addr *dotted_to_addr(const char *dotted);
-extern struct in_addr *dotted_to_mask(const char *dotted);
-
-extern void parse_hostnetworkmask(const char *name, struct in_addr **addrpp,
-                      struct in_addr *maskp, unsigned int *naddrs);
 extern u_int16_t parse_protocol(const char *s);
 
 extern int do_command(int argc, char *argv[], char **table,
Index: iptables-modules/include/xtables.h
===================================================================
--- iptables-modules.orig/include/xtables.h
+++ iptables-modules/include/xtables.h
@@ -239,10 +239,17 @@ extern const char *program_name, *progra
 extern const char *ipaddr_to_numeric(const struct in_addr *);
 extern const char *ipaddr_to_anyname(const struct in_addr *);
 extern const char *ipmask_to_numeric(const struct in_addr *);
+extern struct in_addr *numeric_to_ipaddr(const char *);
+extern struct in_addr *numeric_to_ipmask(const char *);
+extern void ipparse_hostnetworkmask(const char *, struct in_addr **,
+	struct in_addr *, unsigned int *);
 
+extern struct in6_addr *numeric_to_ip6addr(const char *);
 extern const char *ip6addr_to_numeric(const struct in6_addr *);
 extern const char *ip6addr_to_anyname(const struct in6_addr *);
 extern const char *ip6mask_to_numeric(const struct in6_addr *);
+extern void ip6parse_hostnetworkmask(const char *, struct in6_addr **,
+	struct in6_addr *, unsigned int *);
 
 #define _init __attribute__((constructor)) my_init
 #ifdef NO_SHARED_LIBS
Index: iptables-modules/ip6tables.c
===================================================================
--- iptables-modules.orig/ip6tables.c
+++ iptables-modules/ip6tables.c
@@ -459,71 +459,6 @@ check_inverse(const char option[], int *
 	return FALSE;
 }
 
-static struct in6_addr *
-numeric_to_addr(const char *num)
-{
-	static struct in6_addr ap;
-	int err;
-	if ((err=inet_pton(AF_INET6, num, &ap)) == 1)
-		return &ap;
-#ifdef DEBUG
-	fprintf(stderr, "\nnumeric2addr: %d\n", err);
-#endif
-	return (struct in6_addr *)NULL;
-}
-
-
-static struct in6_addr *
-host_to_addr(const char *name, unsigned int *naddr)
-{
-	struct addrinfo hints;
-        struct addrinfo *res;
-        static struct in6_addr *addr;
-	int err;
-
-	memset(&hints, 0, sizeof(hints));
-        hints.ai_flags=AI_CANONNAME;
-        hints.ai_family=AF_INET6;
-        hints.ai_socktype=SOCK_RAW;
-        hints.ai_protocol=41;
-        hints.ai_next=NULL;
-
-	*naddr = 0;
-        if ( (err=getaddrinfo(name, NULL, &hints, &res)) != 0 ){
-#ifdef DEBUG
-                fprintf(stderr,"Name2IP: %s\n",gai_strerror(err)); 
-#endif
-                return (struct in6_addr *) NULL;
-        } else {
-		if (res->ai_family != AF_INET6 ||
-		    res->ai_addrlen != sizeof(struct sockaddr_in6))
-			return (struct in6_addr *) NULL;
-
-#ifdef DEBUG
-                fprintf(stderr, "resolved: len=%d  %s ", res->ai_addrlen, 
-                    addr_to_numeric(&(((struct sockaddr_in6 *)res->ai_addr)->sin6_addr)));
-#endif
-		/* Get the first element of the address-chain */
-		addr = fw_calloc(1, sizeof(struct in6_addr));
-		memcpy(addr, &((const struct sockaddr_in6 *)res->ai_addr)->sin6_addr,
-		       sizeof(struct in6_addr));
-		freeaddrinfo(res);
-		*naddr = 1;
-		return addr;
-	}
-
-	return (struct in6_addr *) NULL;
-}
-
-static struct in6_addr *
-network_to_addr(const char *name)
-{
-	/*	abort();*/
-	/* TODO: not implemented yet, but the exception breaks the
-	 *       name resolvation */
-	return (struct in6_addr *)NULL;
-}
-
 /*
  *	All functions starting with "parse" should succeed, otherwise
  *	the program fails.
@@ -533,92 +468,6 @@ network_to_addr(const char *name)
  *	return global static data.
 */
 
-static struct in6_addr *
-parse_hostnetwork(const char *name, unsigned int *naddrs)
-{
-	struct in6_addr *addrp, *addrptmp;
-
-	if ((addrptmp = numeric_to_addr(name)) != NULL ||
-	    (addrptmp = network_to_addr(name)) != NULL) {
-		addrp = fw_malloc(sizeof(struct in6_addr));
-		memcpy(addrp, addrptmp, sizeof(*addrp));
-		*naddrs = 1;
-		return addrp;
-	}
-	if ((addrp = host_to_addr(name, naddrs)) != NULL)
-		return addrp;
-
-	exit_error(PARAMETER_PROBLEM, "host/network `%s' not found", name);
-}
-
-static struct in6_addr *
-parse_mask(char *mask)
-{
-	static struct in6_addr maskaddr;
-	struct in6_addr *addrp;
-	unsigned int bits;
-
-	if (mask == NULL) {
-		/* no mask at all defaults to 128 bits */
-		memset(&maskaddr, 0xff, sizeof maskaddr);
-		return &maskaddr;
-	}
-	if ((addrp = numeric_to_addr(mask)) != NULL)
-		return addrp;
-	if (string_to_number(mask, 0, 128, &bits) == -1)
-		exit_error(PARAMETER_PROBLEM,
-			   "invalid mask `%s' specified", mask);
-	if (bits != 0) {
-		char *p = (char *)&maskaddr;
-		memset(p, 0xff, bits / 8);
-		memset(p + (bits / 8) + 1, 0, (128 - bits) / 8);
-		p[bits / 8] = 0xff << (8 - (bits & 7));
-		return &maskaddr;
-	}
-
-	memset(&maskaddr, 0, sizeof maskaddr);
-	return &maskaddr;
-}
-
-void
-parse_hostnetworkmask(const char *name, struct in6_addr **addrpp,
-		      struct in6_addr *maskp, unsigned int *naddrs)
-{
-	struct in6_addr *addrp;
-	char buf[256];
-	char *p;
-	int i, j, n;
-
-	strncpy(buf, name, sizeof(buf) - 1);
-	buf[sizeof(buf) - 1] = '\0';
-	if ((p = strrchr(buf, '/')) != NULL) {
-		*p = '\0';
-		addrp = parse_mask(p + 1);
-	} else
-		addrp = parse_mask(NULL);
-	memcpy(maskp, addrp, sizeof(*maskp));
-
-	/* if a null mask is given, the name is ignored, like in "any/0" */
-	if (!memcmp(maskp, &in6addr_any, sizeof(in6addr_any)))
-		strcpy(buf, "::");
-
-	addrp = *addrpp = parse_hostnetwork(buf, naddrs);
-	n = *naddrs;
-	for (i = 0, j = 0; i < n; i++) {
-		int k;
-		for (k = 0; k < 4; k++)
-			addrp[j].in6_u.u6_addr32[k] &= maskp->in6_u.u6_addr32[k];
-		j++;
-		for (k = 0; k < j - 1; k++) {
-			if (IN6_ARE_ADDR_EQUAL(&addrp[k], &addrp[j - 1])) {
-				(*naddrs)--;
-				j--;
-				break;
-			}
-		}
-	}
-}
-
 /* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
 static struct ip6tables_match *
 find_proto(const char *pname, enum ip6t_tryload tryload, int nolookup, struct ip6tables_rule_match **matches)
@@ -1795,12 +1644,12 @@ int do_command6(int argc, char *argv[], 
 	}
 
 	if (shostnetworkmask)
-		parse_hostnetworkmask(shostnetworkmask, &saddrs,
-				      &(fw.ipv6.smsk), &nsaddrs);
+		ip6parse_hostnetworkmask(shostnetworkmask, &saddrs,
+		                         &fw.ipv6.smsk, &nsaddrs);
 
 	if (dhostnetworkmask)
-		parse_hostnetworkmask(dhostnetworkmask, &daddrs,
-				      &(fw.ipv6.dmsk), &ndaddrs);
+		ip6parse_hostnetworkmask(dhostnetworkmask, &daddrs,
+		                         &fw.ipv6.dmsk, &ndaddrs);
 
 	if ((nsaddrs > 1 || ndaddrs > 1) &&
 	    (fw.ipv6.invflags & (IP6T_INV_SRCIP | IP6T_INV_DSTIP)))
Index: iptables-modules/iptables.c
===================================================================
--- iptables-modules.orig/iptables.c
+++ iptables-modules/iptables.c
@@ -253,90 +253,6 @@ enum {
 	IPT_DOTTED_MASK
 };
 
-static struct in_addr *
-__dotted_to_addr(const char *dotted, int type)
-{
-	static struct in_addr addr;
-	unsigned char *addrp;
-	char *p, *q;
-	unsigned int onebyte;
-	int i;
-	char buf[20];
-
-	/* copy dotted string, because we need to modify it */
-	strncpy(buf, dotted, sizeof(buf) - 1);
-	buf[sizeof(buf) - 1] = '\0';
-	addrp = (unsigned char *) &(addr.s_addr);
-
-	p = buf;
-	for (i = 0; i < 3; i++) {
-		if ((q = strchr(p, '.')) == NULL) {
-			if (type == IPT_DOTTED_ADDR) {
-				/* autocomplete, this is a network address */
-				if (string_to_number(p, 0, 255, &onebyte) == -1)
-					return (struct in_addr *) NULL;
-
-				addrp[i] = (unsigned char) onebyte;
-				while (i < 3)
-					addrp[++i] = 0;
-
-				return &addr;
-			} else
-				return (struct in_addr *) NULL;
-		}
-
-		*q = '\0';
-		if (string_to_number(p, 0, 255, &onebyte) == -1)
-			return (struct in_addr *) NULL;
-
-		addrp[i] = (unsigned char) onebyte;
-		p = q + 1;
-	}
-
-	/* we've checked 3 bytes, now we check the last one */
-	if (string_to_number(p, 0, 255, &onebyte) == -1)
-		return (struct in_addr *) NULL;
-
-	addrp[3] = (unsigned char) onebyte;
-
-	return &addr;
-}
-
-struct in_addr *
-dotted_to_addr(const char *dotted)
-{
-	return __dotted_to_addr(dotted, IPT_DOTTED_ADDR);
-}
-
-struct in_addr *
-dotted_to_mask(const char *dotted)
-{
-	return __dotted_to_addr(dotted, IPT_DOTTED_MASK);
-}
-
-static struct in_addr *
-network_to_addr(const char *name)
-{
-	struct netent *net;
-	static struct in_addr addr;
-
-	if ((net = getnetbyname(name)) != NULL) {
-		if (net->n_addrtype != AF_INET)
-			return (struct in_addr *) NULL;
-		addr.s_addr = htonl((unsigned long) net->n_net);
-		return &addr;
-	}
-
-	return (struct in_addr *) NULL;
-}
-
-static void
-inaddrcpy(struct in_addr *dst, struct in_addr *src)
-{
-	/* memcpy(dst, src, sizeof(struct in_addr)); */
-	dst->s_addr = src->s_addr;
-}
-
 static void free_opts(int reset_offset)
 {
 	if (opts != original_opts) {
@@ -550,31 +466,6 @@ check_inverse(const char option[], int *
 	return FALSE;
 }
 
-static struct in_addr *
-host_to_addr(const char *name, unsigned int *naddr)
-{
-	struct hostent *host;
-	struct in_addr *addr;
-	unsigned int i;
-
-	*naddr = 0;
-	if ((host = gethostbyname(name)) != NULL) {
-		if (host->h_addrtype != AF_INET ||
-		    host->h_length != sizeof(struct in_addr))
-			return (struct in_addr *) NULL;
-
-		while (host->h_addr_list[*naddr] != (char *) NULL)
-			(*naddr)++;
-		addr = fw_calloc(*naddr, sizeof(struct in_addr) * *naddr);
-		for (i = 0; i < *naddr; i++)
-			inaddrcpy(&(addr[i]),
-				  (struct in_addr *) host->h_addr_list[i]);
-		return addr;
-	}
-
-	return (struct in_addr *) NULL;
-}
-
 /*
  *	All functions starting with "parse" should succeed, otherwise
  *	the program fails.
@@ -584,87 +475,6 @@ host_to_addr(const char *name, unsigned 
  *	return global static data.
 */
 
-static struct in_addr *
-parse_hostnetwork(const char *name, unsigned int *naddrs)
-{
-	struct in_addr *addrp, *addrptmp;
-
-	if ((addrptmp = dotted_to_addr(name)) != NULL ||
-	    (addrptmp = network_to_addr(name)) != NULL) {
-		addrp = fw_malloc(sizeof(struct in_addr));
-		inaddrcpy(addrp, addrptmp);
-		*naddrs = 1;
-		return addrp;
-	}
-	if ((addrp = host_to_addr(name, naddrs)) != NULL)
-		return addrp;
-
-	exit_error(PARAMETER_PROBLEM, "host/network `%s' not found", name);
-}
-
-static struct in_addr *
-parse_mask(char *mask)
-{
-	static struct in_addr maskaddr;
-	struct in_addr *addrp;
-	unsigned int bits;
-
-	if (mask == NULL) {
-		/* no mask at all defaults to 32 bits */
-		maskaddr.s_addr = 0xFFFFFFFF;
-		return &maskaddr;
-	}
-	if ((addrp = dotted_to_mask(mask)) != NULL)
-		/* dotted_to_addr already returns a network byte order addr */
-		return addrp;
-	if (string_to_number(mask, 0, 32, &bits) == -1)
-		exit_error(PARAMETER_PROBLEM,
-			   "invalid mask `%s' specified", mask);
-	if (bits != 0) {
-		maskaddr.s_addr = htonl(0xFFFFFFFF << (32 - bits));
-		return &maskaddr;
-	}
-
-	maskaddr.s_addr = 0L;
-	return &maskaddr;
-}
-
-void
-parse_hostnetworkmask(const char *name, struct in_addr **addrpp,
-		      struct in_addr *maskp, unsigned int *naddrs)
-{
-	struct in_addr *addrp;
-	char buf[256];
-	char *p;
-	int i, j, k, n;
-
-	strncpy(buf, name, sizeof(buf) - 1);
-	buf[sizeof(buf) - 1] = '\0';
-	if ((p = strrchr(buf, '/')) != NULL) {
-		*p = '\0';
-		addrp = parse_mask(p + 1);
-	} else
-		addrp = parse_mask(NULL);
-	inaddrcpy(maskp, addrp);
-
-	/* if a null mask is given, the name is ignored, like in "any/0" */
-	if (maskp->s_addr == 0L)
-		strcpy(buf, "0.0.0.0");
-
-	addrp = *addrpp = parse_hostnetwork(buf, naddrs);
-	n = *naddrs;
-	for (i = 0, j = 0; i < n; i++) {
-		addrp[j++].s_addr &= maskp->s_addr;
-		for (k = 0; k < j - 1; k++) {
-			if (addrp[k].s_addr == addrp[j - 1].s_addr) {
-				(*naddrs)--;
-				j--;
-				break;
-			}
-		}
-	}
-}
-
 /* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
 static struct iptables_match *
 find_proto(const char *pname, enum ipt_tryload tryload, int nolookup, struct iptables_rule_match **matches)
@@ -1857,12 +1667,12 @@ int do_command(int argc, char *argv[], c
 	}
 
 	if (shostnetworkmask)
-		parse_hostnetworkmask(shostnetworkmask, &saddrs,
-				      &(fw.ip.smsk), &nsaddrs);
+		ipparse_hostnetworkmask(shostnetworkmask, &saddrs,
+		                        &fw.ip.smsk, &nsaddrs);
 
 	if (dhostnetworkmask)
-		parse_hostnetworkmask(dhostnetworkmask, &daddrs,
-				      &(fw.ip.dmsk), &ndaddrs);
+		ipparse_hostnetworkmask(dhostnetworkmask, &daddrs,
+		                        &fw.ip.dmsk, &ndaddrs);
 
 	if ((nsaddrs > 1 || ndaddrs > 1) &&
 	    (fw.ip.invflags & (IPT_INV_SRCIP | IPT_INV_DSTIP)))
Index: iptables-modules/xtables.c
===================================================================
--- iptables-modules.orig/xtables.c
+++ iptables-modules/xtables.c
@@ -766,6 +766,179 @@ const char *ipmask_to_numeric(const stru
 	return buf;
 }
 
+static struct in_addr *__numeric_to_ipaddr(const char *dotted, bool is_mask)
+{
+	static struct in_addr addr;
+	unsigned char *addrp;
+	unsigned int onebyte;
+	char buf[20], *p, *q;
+	int i;
+
+	/* copy dotted string, because we need to modify it */
+	strncpy(buf, dotted, sizeof(buf) - 1);
+	buf[sizeof(buf) - 1] = '\0';
+	addrp = (void *)&addr.s_addr;
+
+	p = buf;
+	for (i = 0; i < 3; ++i) {
+		if ((q = strchr(p, '.')) == NULL) {
+			if (is_mask)
+				return NULL;
+
+			/* autocomplete, this is a network address */
+			if (!strtonum(p, NULL, &onebyte, 0, 255))
+				return NULL;
+
+			addrp[i] = onebyte;
+			while (i < 3)
+				addrp[++i] = 0;
+
+			return &addr;
+		}
+
+		*q = '\0';
+		if (!strtonum(p, NULL, &onebyte, 0, 255))
+			return NULL;
+
+		addrp[i] = onebyte;
+		p = q + 1;
+	}
+
+	/* we have checked 3 bytes, now we check the last one */
+	if (!strtonum(p, NULL, &onebyte, 0, 255))
+		return NULL;
+
+	addrp[3] = onebyte;
+	return &addr;
+}
+
+struct in_addr *numeric_to_ipaddr(const char *dotted)
+{
+	return __numeric_to_ipaddr(dotted, false);
+}
+
+struct in_addr *numeric_to_ipmask(const char *dotted)
+{
+	return __numeric_to_ipaddr(dotted, true);
+}
+
+static struct in_addr *network_to_ipaddr(const char *name)
+{
+	static struct in_addr addr;
+	struct netent *net;
+
+	if ((net = getnetbyname(name)) != NULL) {
+		if (net->n_addrtype != AF_INET)
+			return NULL;
+		addr.s_addr = htonl(net->n_net);
+		return &addr;
+	}
+
+	return NULL;
+}
+
+static struct in_addr *host_to_ipaddr(const char *name, unsigned int *naddr)
+{
+	struct hostent *host;
+	struct in_addr *addr;
+	unsigned int i;
+
+	*naddr = 0;
+	if ((host = gethostbyname(name)) != NULL) {
+		if (host->h_addrtype != AF_INET ||
+		    host->h_length != sizeof(struct in_addr))
+			return NULL;
+
+		while (host->h_addr_list[*naddr] != NULL)
+			++*naddr;
+		addr = fw_calloc(*naddr, sizeof(struct in_addr) * *naddr);
+		for (i = 0; i < *naddr; i++)
+			memcpy(&addr[i], host->h_addr_list[i],
+			       sizeof(struct in_addr));
+		return addr;
+	}
+
+	return NULL;
+}
+
+static struct in_addr *
+ipparse_hostnetwork(const char *name, unsigned int *naddrs)
+{
+	struct in_addr *addrptmp, *addrp;
+
+	if ((addrptmp = numeric_to_ipaddr(name)) != NULL ||
+	    (addrptmp = network_to_ipaddr(name)) != NULL) {
+		addrp = fw_malloc(sizeof(struct in_addr));
+		memcpy(addrp, addrptmp, sizeof(*addrp));
+		*naddrs = 1;
+		return addrp;
+	}
+	if ((addrptmp = host_to_ipaddr(name, naddrs)) != NULL)
+		return addrptmp;
+
+	exit_error(PARAMETER_PROBLEM, "host/network `%s' not found", name);
+}
+
+static struct in_addr *parse_ipmask(const char *mask)
+{
+	static struct in_addr maskaddr;
+	struct in_addr *addrp;
+	unsigned int bits;
+
+	if (mask == NULL) {
+		/* no mask at all defaults to 32 bits */
+		maskaddr.s_addr = 0xFFFFFFFF;
+		return &maskaddr;
+	}
+	if ((addrp = numeric_to_ipmask(mask)) != NULL)
+		/* dotted_to_addr already returns a network byte order addr */
+		return addrp;
+	if (string_to_number(mask, 0, 32, &bits) == -1)
+		exit_error(PARAMETER_PROBLEM,
+			   "invalid mask `%s' specified", mask);
+	if (bits != 0) {
+		maskaddr.s_addr = htonl(0xFFFFFFFF << (32 - bits));
+		return &maskaddr;
+	}
+
+	maskaddr.s_addr = 0U;
+	return &maskaddr;
+}
+
+void ipparse_hostnetworkmask(const char *name, struct in_addr **addrpp,
+                             struct in_addr *maskp, unsigned int *naddrs)
+{
+	unsigned int i, j, k, n;
+	struct in_addr *addrp;
+	char buf[256], *p;
+
+	strncpy(buf, name, sizeof(buf) - 1);
+	buf[sizeof(buf) - 1] = '\0';
+	if ((p = strrchr(buf, '/')) != NULL) {
+		*p = '\0';
+		addrp = parse_ipmask(p + 1);
+	} else {
+		addrp = parse_ipmask(NULL);
+	}
+	memcpy(maskp, addrp, sizeof(*maskp));
+
+	/* if a null mask is given, the name is ignored, like in "any/0" */
+	if (maskp->s_addr == 0U)
+		strcpy(buf, "0.0.0.0");
+
+	addrp = *addrpp = ipparse_hostnetwork(buf, naddrs);
+	n = *naddrs;
+	for (i = 0, j = 0; i < n; ++i) {
+		addrp[j++].s_addr &= maskp->s_addr;
+		for (k = 0; k < j - 1; ++k)
+			if (addrp[k].s_addr == addrp[j-1].s_addr) {
+				--*naddrs;
+				--j;
+				break;
+			}
+	}
+}
+
 const char *ip6addr_to_numeric(const struct in6_addr *addrp)
 {
 	/* 0000:0000:0000:0000:0000:000.000.000.000
@@ -846,3 +1019,148 @@ const char *ip6mask_to_numeric(const str
 	sprintf(buf, "/%d", l);
 	return buf;
 }
+
+struct in6_addr *numeric_to_ip6addr(const char *num)
+{
+	static struct in6_addr ap;
+	int err;
+
+	if ((err = inet_pton(AF_INET6, num, &ap)) == 1)
+		return &ap;
+#ifdef DEBUG
+	fprintf(stderr, "\nnumeric2addr: %d\n", err);
+#endif
+	return NULL;
+}
+
+static struct in6_addr *
+host_to_ip6addr(const char *name, unsigned int *naddr)
+{
+	static struct in6_addr *addr;
+	struct addrinfo hints;
+	struct addrinfo *res;
+	int err;
+
+	memset(&hints, 0, sizeof(hints));
+	hints.ai_flags    = AI_CANONNAME;
+	hints.ai_family   = AF_INET6;
+	hints.ai_socktype = SOCK_RAW;
+	hints.ai_protocol = IPPROTO_IPV6;
+	hints.ai_next     = NULL;
+
+	*naddr = 0;
+	if ((err = getaddrinfo(name, NULL, &hints, &res)) != 0) {
+#ifdef DEBUG
+		fprintf(stderr,"Name2IP: %s\n",gai_strerror(err));
+#endif
+		return NULL;
+	} else {
+		if (res->ai_family != AF_INET6 ||
+		    res->ai_addrlen != sizeof(struct sockaddr_in6))
+			return NULL;
+
+#ifdef DEBUG
+		fprintf(stderr, "resolved: len=%d  %s ", res->ai_addrlen,
+		        ip6addr_to_numeric(&((struct sockaddr_in6 *)res->ai_addr)->sin6_addr));
+#endif
+		/* Get the first element of the address-chain */
+		addr = fw_malloc(sizeof(struct in6_addr));
+		memcpy(addr, &((const struct sockaddr_in6 *)res->ai_addr)->sin6_addr,
+		       sizeof(struct in6_addr));
+		freeaddrinfo(res);
+		*naddr = 1;
+		return addr;
+	}
+
+	return NULL;
+}
+
+static struct in6_addr *network_to_ip6addr(const char *name)
+{
+	/*	abort();*/
+	/* TODO: not implemented yet, but the exception breaks the
+	 *       name resolvation */
+	return NULL;
+}
+
+static struct in6_addr *
+ip6parse_hostnetwork(const char *name, unsigned int *naddrs)
+{
+	struct in6_addr *addrp, *addrptmp;
+
+	if ((addrptmp = numeric_to_ip6addr(name)) != NULL ||
+	    (addrptmp = network_to_ip6addr(name)) != NULL) {
+		addrp = fw_malloc(sizeof(struct in6_addr));
+		memcpy(addrp, addrptmp, sizeof(*addrp));
+		*naddrs = 1;
+		return addrp;
+	}
+	if ((addrp = host_to_ip6addr(name, naddrs)) != NULL)
+		return addrp;
+
+	exit_error(PARAMETER_PROBLEM, "host/network `%s' not found", name);
+}
+
+static struct in6_addr *parse_ip6mask(char *mask)
+{
+	static struct in6_addr maskaddr;
+	struct in6_addr *addrp;
+	unsigned int bits;
+
+	if (mask == NULL) {
+		/* no mask at all defaults to 128 bits */
+		memset(&maskaddr, 0xff, sizeof maskaddr);
+		return &maskaddr;
+	}
+	if ((addrp = numeric_to_ip6addr(mask)) != NULL)
+		return addrp;
+	if (string_to_number(mask, 0, 128, &bits) == -1)
+		exit_error(PARAMETER_PROBLEM,
+			   "invalid mask `%s' specified", mask);
+	if (bits != 0) {
+		char *p = (void *)&maskaddr;
+		memset(p, 0xff, bits / 8);
+		memset(p + (bits / 8) + 1, 0, (128 - bits) / 8);
+		p[bits/8] = 0xff << (8 - (bits & 7));
+		return &maskaddr;
+	}
+
+	memset(&maskaddr, 0, sizeof(maskaddr));
+	return &maskaddr;
+}
+
+void ip6parse_hostnetworkmask(const char *name, struct in6_addr **addrpp,
+                              struct in6_addr *maskp, unsigned int *naddrs)
+{
+	struct in6_addr *addrp;
+	unsigned int i, j, k, n;
+	char buf[256], *p;
+
+	strncpy(buf, name, sizeof(buf) - 1);
+	buf[sizeof(buf)-1] = '\0';
+	if ((p = strrchr(buf, '/')) != NULL) {
+		*p = '\0';
+		addrp = parse_ip6mask(p + 1);
+	} else {
+		addrp = parse_ip6mask(NULL);
+	}
+	memcpy(maskp, addrp, sizeof(*maskp));
+
+	/* if a null mask is given, the name is ignored, like in "any/0" */
+	if (memcmp(maskp, &in6addr_any, sizeof(in6addr_any)) == 0)
+		strcpy(buf, "::");
+
+	addrp = *addrpp = ip6parse_hostnetwork(buf, naddrs);
+	n = *naddrs;
+	for (i = 0, j = 0; i < n; ++i) {
+		for (k = 0; k < 4; ++k)
+			addrp[j].in6_u.u6_addr32[k] &= maskp->in6_u.u6_addr32[k];
+		++j;
+		for (k = 0; k < j - 1; ++k)
+			if (IN6_ARE_ADDR_EQUAL(&addrp[k], &addrp[j - 1])) {
+				--*naddrs;
+				--j;
+				break;
+			}
+	}
+}
