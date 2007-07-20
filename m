From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [20/43] Unifies libip[6]t_multiport.c into libipxt_multiport.c
Date: Fri, 20 Jul 2007 20:12:09 +0900 (JST)
Message-ID: <200707201112.l6KBC9Q8004193@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: kaber@trash.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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


---
 extensions/Makefile                           |    2 +-
 extensions/libip6t_multiport.c                |  464 -------------------------
 extensions/libxt_multiport.c                  |   85 +++++
 include/linux/netfilter_ipv4/ipt_multiport.h  |   29 --
 include/linux/netfilter_ipv6/ip6t_multiport.h |   30 --
 5 files changed, 86 insertions(+), 524 deletions(-)
 delete mode 100644 extensions/libip6t_multiport.c
 delete mode 100644 include/linux/netfilter_ipv4/ipt_multiport.h
 delete mode 100644 include/linux/netfilter_ipv6/ip6t_multiport.h

diff --git a/extensions/Makefile b/extensions/Makefile
index 3a7c6a2..0dd6bc6 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -6,7 +6,7 @@
 # package (HW)
 #
 PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac mark owner physdev pkttype policy realm sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
-PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit mac mark multiport owner physdev policy standard state tcp udp CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
+PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit mac mark owner physdev policy standard state tcp udp CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
 PFX_EXT_SLIB:=multiport NOTRACK
 
 ifeq ($(DO_SELINUX), 1)
diff --git a/extensions/libip6t_multiport.c b/extensions/libip6t_multiport.c
deleted file mode 100644
index 2ff77fe..0000000
--- a/extensions/libip6t_multiport.c
+++ /dev/null
@@ -1,464 +0,0 @@
-/* Shared library add-on to iptables to add multiple TCP port support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <ip6tables.h>
-/* To ensure that iptables compiles with an old kernel */
-#include "../include/linux/netfilter_ipv6/ip6t_multiport.h"
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"multiport v%s options:\n"
-" --source-ports port[,port,port...]\n"
-" --sports ...\n"
-"				match source port(s)\n"
-" --destination-ports port[,port,port...]\n"
-" --dports ...\n"
-"				match destination port(s)\n"
-" --ports port[,port,port]\n"
-"				match both source and destination port(s)\n"
-" NOTE: this kernel does not support port ranges in multiport.\n",
-IPTABLES_VERSION);
-}
-
-static void
-help_v1(void)
-{
-	printf(
-"multiport v%s options:\n"
-" --source-ports [!] port[,port:port,port...]\n"
-" --sports ...\n"
-"				match source port(s)\n"
-" --destination-ports [!] port[,port:port,port...]\n"
-" --dports ...\n"
-"				match destination port(s)\n"
-" --ports [!] port[,port:port,port]\n"
-"				match both source and destination port(s)\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "source-ports", 1, 0, '1' },
-	{ "sports", 1, 0, '1' }, /* synonym */
-	{ "destination-ports", 1, 0, '2' },
-	{ "dports", 1, 0, '2' }, /* synonym */
-	{ "ports", 1, 0, '3' },
-	{0}
-};
-
-static char *
-proto_to_name(u_int8_t proto)
-{
-	switch (proto) {
-	case IPPROTO_TCP:
-		return "tcp";
-	case IPPROTO_UDP:
-		return "udp";
-	case IPPROTO_SCTP:
-		return "sctp";
-	case IPPROTO_DCCP:
-		return "dccp";
-	default:
-		return NULL;
-	}
-}
-
-static unsigned int
-parse_multi_ports(const char *portstring, u_int16_t *ports, const char *proto)
-{
-	char *buffer, *cp, *next;
-	unsigned int i;
-
-	buffer = strdup(portstring);
-	if (!buffer) exit_error(OTHER_PROBLEM, "strdup failed");
-
-	for (cp=buffer, i=0; cp && i<IP6T_MULTI_PORTS; cp=next,i++)
-	{
-		next=strchr(cp, ',');
-		if (next) *next++='\0';
-		ports[i] = parse_port(cp, proto);
-	}
-	if (cp) exit_error(PARAMETER_PROBLEM, "too many ports specified");
-	free(buffer);
-	return i;
-}
-
-static void
-parse_multi_ports_v1(const char *portstring, 
-		     struct ip6t_multiport_v1 *multiinfo,
-		     const char *proto)
-{
-	char *buffer, *cp, *next, *range;
-	unsigned int i;
-	u_int16_t m;
-
-	buffer = strdup(portstring);
-	if (!buffer) exit_error(OTHER_PROBLEM, "strdup failed");
-
-	for (i=0; i<IP6T_MULTI_PORTS; i++)
-		multiinfo->pflags[i] = 0;
- 
-	for (cp=buffer, i=0; cp && i<IP6T_MULTI_PORTS; cp=next, i++) {
-		next=strchr(cp, ',');
- 		if (next) *next++='\0';
-		range = strchr(cp, ':');
-		if (range) {
-			if (i == IP6T_MULTI_PORTS-1)
-				exit_error(PARAMETER_PROBLEM,
-					   "too many ports specified");
-			*range++ = '\0';
-		}
-		multiinfo->ports[i] = parse_port(cp, proto);
-		if (range) {
-			multiinfo->pflags[i] = 1;
-			multiinfo->ports[++i] = parse_port(range, proto);
-			if (multiinfo->ports[i-1] >= multiinfo->ports[i])
-				exit_error(PARAMETER_PROBLEM,
-					   "invalid portrange specified");
-			m <<= 1;
-		}
- 	}
-	multiinfo->count = i;
- 	if (cp) exit_error(PARAMETER_PROBLEM, "too many ports specified");
- 	free(buffer);
-}
-
-/* Initialize the match. */
-static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
-{
-}
-
-static const char *
-check_proto(const void *e)
-{
-	const struct ip6t_entry *entry = e;
-	char *proto;
-
-	if ((proto = proto_to_name(entry->ipv6.proto)) != NULL)
-		return proto;
-	else if (!entry->ipv6.proto)
-		exit_error(PARAMETER_PROBLEM,
-			   "multiport needs `-p tcp', `-p udp', `-p sctp' or `-p dccp'");
-	else
-		exit_error(PARAMETER_PROBLEM,
-			   "multiport only works with TCP, UDP, SCTP and DCCP");
-}
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *e,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	const struct ip6t_entry *entry = e;
-	const char *proto;
-	struct ip6t_multiport *multiinfo
-		= (struct ip6t_multiport *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		check_inverse(argv[optind-1], &invert, &optind, 0);
-		proto = check_proto(entry);
-		multiinfo->count = parse_multi_ports(argv[optind-1],
-						     multiinfo->ports, proto);
-		multiinfo->flags = IP6T_MULTIPORT_SOURCE;
-		break;
-
-	case '2':
-		check_inverse(argv[optind-1], &invert, &optind, 0);
-		proto = check_proto(entry);
-		multiinfo->count = parse_multi_ports(argv[optind-1],
-						     multiinfo->ports, proto);
-		multiinfo->flags = IP6T_MULTIPORT_DESTINATION;
-		break;
-
-	case '3':
-		check_inverse(argv[optind-1], &invert, &optind, 0);
-		proto = check_proto(entry);
-		multiinfo->count = parse_multi_ports(argv[optind-1],
-						     multiinfo->ports, proto);
-		multiinfo->flags = IP6T_MULTIPORT_EITHER;
-		break;
-
-	default:
-		return 0;
-	}
-
-	if (invert)
-		exit_error(PARAMETER_PROBLEM,
-			   "multiport does not support invert");
-
-	if (*flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "multiport can only have one option");
-	*flags = 1;
-	return 1;
-}
-
-static int
-parse_v1(int c, char **argv, int invert, unsigned int *flags,
-	 const void *e,
-	 unsigned int *nfcache,
-	 struct xt_entry_match **match)
-{
-	const struct ip6t_entry *entry = e;
-	const char *proto;
-	struct ip6t_multiport_v1 *multiinfo
-		= (struct ip6t_multiport_v1 *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		check_inverse(argv[optind-1], &invert, &optind, 0);
-		proto = check_proto(entry);
-		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
-		multiinfo->flags = IP6T_MULTIPORT_SOURCE;
-		break;
-
-	case '2':
-		check_inverse(argv[optind-1], &invert, &optind, 0);
-		proto = check_proto(entry);
-		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
-		multiinfo->flags = IP6T_MULTIPORT_DESTINATION;
-		break;
-
-	case '3':
-		check_inverse(argv[optind-1], &invert, &optind, 0);
-		proto = check_proto(entry);
-		parse_multi_ports_v1(argv[optind-1], multiinfo, proto);
-		multiinfo->flags = IP6T_MULTIPORT_EITHER;
-		break;
-
-	default:
-		return 0;
-	}
-
-	if (invert)
-		multiinfo->invert = 1;
-
-	if (*flags)
-		exit_error(PARAMETER_PROBLEM,
-			   "multiport can only have one option");
-	*flags = 1;
-	return 1;
-}
-
-/* Final check; must specify something. */
-static void
-final_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM, "multiport expection an option");
-}
-
-static char *
-port_to_service(int port, u_int8_t proto)
-{
-	struct servent *service;
-
-	if ((service = getservbyport(htons(port), proto_to_name(proto))))
-		return service->s_name;
-
-	return NULL;
-}
-
-static void
-print_port(u_int16_t port, u_int8_t protocol, int numeric)
-{
-	char *service;
-
-	if (numeric || (service = port_to_service(port, protocol)) == NULL)
-		printf("%u", port);
-	else
-		printf("%s", service);
-}
-
-/* Prints out the matchinfo. */
-static void
-print(const void *ip_void,
-      const struct xt_entry_match *match,
-      int numeric)
-{
-	const struct ip6t_ip6 *ip = ip_void;
-	const struct ip6t_multiport *multiinfo
-		= (const struct ip6t_multiport *)match->data;
-	unsigned int i;
-
-	printf("multiport ");
-
-	switch (multiinfo->flags) {
-	case IP6T_MULTIPORT_SOURCE:
-		printf("sports ");
-		break;
-
-	case IP6T_MULTIPORT_DESTINATION:
-		printf("dports ");
-		break;
-
-	case IP6T_MULTIPORT_EITHER:
-		printf("ports ");
-		break;
-
-	default:
-		printf("ERROR ");
-		break;
-	}
-
-	for (i=0; i < multiinfo->count; i++) {
-		printf("%s", i ? "," : "");
-		print_port(multiinfo->ports[i], ip->proto, numeric);
-	}
-	printf(" ");
-}
-
-static void
-print_v1(const void *ip_void,
-	 const struct xt_entry_match *match,
-	 int numeric)
-{
-	const struct ip6t_ip6 *ip = ip_void;
-	const struct ip6t_multiport_v1 *multiinfo
-		= (const struct ip6t_multiport_v1 *)match->data;
-	unsigned int i;
-
-	printf("multiport ");
-
-	switch (multiinfo->flags) {
-	case IP6T_MULTIPORT_SOURCE:
-		printf("sports ");
-		break;
-
-	case IP6T_MULTIPORT_DESTINATION:
-		printf("dports ");
-		break;
-
-	case IP6T_MULTIPORT_EITHER:
-		printf("ports ");
-		break;
-
-	default:
-		printf("ERROR ");
-		break;
-	}
-
-	if (multiinfo->invert)
-		printf("! ");
-
-	for (i=0; i < multiinfo->count; i++) {
-		printf("%s", i ? "," : "");
-		print_port(multiinfo->ports[i], ip->proto, numeric);
-		if (multiinfo->pflags[i]) {
-			printf(":");
-			print_port(multiinfo->ports[++i], ip->proto, numeric);
-		}
-	}
-	printf(" ");
-}
-
-/* Saves the union ip6t_matchinfo in parsable form to stdout. */
-static void save(const void *ip_void, const struct xt_entry_match *match)
-{
-	const struct ip6t_ip6 *ip = ip_void;
-	const struct ip6t_multiport *multiinfo
-		= (const struct ip6t_multiport *)match->data;
-	unsigned int i;
-
-	switch (multiinfo->flags) {
-	case IP6T_MULTIPORT_SOURCE:
-		printf("--sports ");
-		break;
-
-	case IP6T_MULTIPORT_DESTINATION:
-		printf("--dports ");
-		break;
-
-	case IP6T_MULTIPORT_EITHER:
-		printf("--ports ");
-		break;
-	}
-
-	for (i=0; i < multiinfo->count; i++) {
-		printf("%s", i ? "," : "");
-		print_port(multiinfo->ports[i], ip->proto, 1);
-	}
-	printf(" ");
-}
-
-static void save_v1(const void *ip_void, const struct xt_entry_match *match)
-{
-	const struct ip6t_ip6 *ip = ip_void;
-	const struct ip6t_multiport_v1 *multiinfo
-		= (const struct ip6t_multiport_v1 *)match->data;
-	unsigned int i;
-
-	switch (multiinfo->flags) {
-	case IP6T_MULTIPORT_SOURCE:
-		printf("--sports ");
-		break;
-
-	case IP6T_MULTIPORT_DESTINATION:
-		printf("--dports ");
-		break;
-
-	case IP6T_MULTIPORT_EITHER:
-		printf("--ports ");
-		break;
-	}
-
-	if (multiinfo->invert)
-		printf("! ");
-
-	for (i=0; i < multiinfo->count; i++) {
-		printf("%s", i ? "," : "");
-		print_port(multiinfo->ports[i], ip->proto, 1);
-		if (multiinfo->pflags[i]) {
-			printf(":");
-			print_port(multiinfo->ports[++i], ip->proto, 1);
-		}
-	}
-	printf(" ");
-}
-
-static struct ip6tables_match multiport = {
-	.name		= "multiport",
-	.version	= IPTABLES_VERSION,
-	.size		= IP6T_ALIGN(sizeof(struct ip6t_multiport)),
-	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_multiport)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
-};
-
-static struct ip6tables_match multiport_v1 = { 
-	.next		= NULL,
-	.name		= "multiport",
-	.revision	= 1,
-	.version	= IPTABLES_VERSION,
-	.size		= IP6T_ALIGN(sizeof(struct ip6t_multiport_v1)),
-	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_multiport_v1)),
-	.help		= &help_v1,
-	.init		= &init,
-	.parse		= &parse_v1,
-	.final_check	= &final_check,
-	.print		= &print_v1,
-	.save		= &save_v1,
-	.extra_opts	= opts
-};
-
-void
-_init(void)
-{
-	register_match6(&multiport);
-	register_match6(&multiport_v1);
-}
diff --git a/extensions/libxt_multiport.c b/extensions/libxt_multiport.c
index a21674d..7d7c266 100644
--- a/extensions/libxt_multiport.c
+++ b/extensions/libxt_multiport.c
@@ -7,6 +7,7 @@
 
 #include <xtables.h>
 #include <libiptc/libiptc.h>
+#include <libiptc/libip6tc.h>
 /* To ensure that iptables compiles with an old kernel */
 #include "../include/linux/netfilter/xt_multiport.h"
 
@@ -221,6 +222,17 @@ parse(int c, char **argv, int invert, unsigned int *flags,
 }
 
 static int
+parse6(int c, char **argv, int invert, unsigned int *flags,
+	 const void *e,
+	 unsigned int *nfcache,
+	 struct xt_entry_match **match)
+{
+	const struct ip6t_entry *entry = (const struct ip6t_entry *)e;
+	return __parse(c, argv, invert, flags, match, entry->ipv6.proto,
+		       entry->ipv6.invflags);
+}
+
+static int
 __parse_v1(int c, char **argv, int invert, unsigned int *flags,
 	   struct xt_entry_match **match,
 	   u_int16_t pnum, u_int8_t invflags)
@@ -276,6 +288,17 @@ parse_v1(int c, char **argv, int invert, unsigned int *flags,
 			  entry->ip.invflags);
 }
 
+static int
+parse6_v1(int c, char **argv, int invert, unsigned int *flags,
+	  const void *e,
+	  unsigned int *nfcache,
+	  struct xt_entry_match **match)
+{
+	const struct ip6t_entry *entry = (const struct ip6t_entry *)e;
+	return __parse_v1(c, argv, invert, flags, match, entry->ipv6.proto,
+			  entry->ipv6.invflags);
+}
+
 /* Final check; must specify something. */
 static void
 final_check(unsigned int flags)
@@ -349,6 +372,13 @@ print(const void *ip_void, const struct xt_entry_match *match, int numeric)
 }
 
 static void
+print6(const void *ip_void, const struct xt_entry_match *match, int numeric)
+{
+	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
+	__print(match, numeric, ip->proto);
+}
+
+static void
 __print_v1(const struct xt_entry_match *match, int numeric, u_int16_t proto)
 {
 	const struct xt_multiport_v1 *multiinfo
@@ -396,6 +426,13 @@ print_v1(const void *ip_void, const struct xt_entry_match *match, int numeric)
 	__print_v1(match, numeric, ip->proto);
 }
 
+static void
+print6_v1(const void *ip_void, const struct xt_entry_match *match, int numeric)
+{
+	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
+	__print_v1(match, numeric, ip->proto);
+}
+
 /* Saves the union ipt_matchinfo in parsable form to stdout. */
 static void __save(const struct xt_entry_match *match, u_int16_t proto)
 {
@@ -430,6 +467,12 @@ static void save(const void *ip_void, const struct xt_entry_match *match)
 	__save(match, ip->proto);
 }
 
+static void save6(const void *ip_void, const struct xt_entry_match *match)
+{
+	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
+	__save(match, ip->proto);
+}
+
 static void __save_v1(const struct xt_entry_match *match, u_int16_t proto)
 {
 	const struct xt_multiport_v1 *multiinfo
@@ -470,6 +513,12 @@ static void save_v1(const void *ip_void, const struct xt_entry_match *match)
 	__save_v1(match, ip->proto);
 }
 
+static void save6_v1(const void *ip_void, const struct xt_entry_match *match)
+{
+	const struct ip6t_ip6 *ip = (const struct ip6t_ip6 *)ip_void;
+	__save_v1(match, ip->proto);
+}
+
 static struct xtables_match multiport = { 
 	.next		= NULL,
 	.family		= AF_INET,
@@ -487,6 +536,23 @@ static struct xtables_match multiport = {
 	.extra_opts	= opts
 };
 
+static struct xtables_match multiport6 = { 
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "multiport",
+	.revision	= 0,
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_multiport)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse6,
+	.final_check	= &final_check,
+	.print		= &print6,
+	.save		= &save6,
+	.extra_opts	= opts
+};
+
 static struct xtables_match multiport_v1 = { 
 	.next		= NULL,
 	.family		= AF_INET,
@@ -504,9 +570,28 @@ static struct xtables_match multiport_v1 = {
 	.extra_opts	= opts
 };
 
+static struct xtables_match multiport6_v1 = { 
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "multiport",
+	.version	= IPTABLES_VERSION,
+	.revision	= 1,
+	.size		= XT_ALIGN(sizeof(struct xt_multiport_v1)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_multiport_v1)),
+	.help		= &help_v1,
+	.init		= &init,
+	.parse		= &parse6_v1,
+	.final_check	= &final_check,
+	.print		= &print6_v1,
+	.save		= &save6_v1,
+	.extra_opts	= opts
+};
+
 void
 _init(void)
 {
 	xtables_register_match(&multiport);
+	xtables_register_match(&multiport6);
 	xtables_register_match(&multiport_v1);
+	xtables_register_match(&multiport6_v1);
 }
diff --git a/include/linux/netfilter_ipv4/ipt_multiport.h b/include/linux/netfilter_ipv4/ipt_multiport.h
deleted file mode 100644
index 4b95d13..0000000
--- a/include/linux/netfilter_ipv4/ipt_multiport.h
+++ /dev/null
@@ -1,29 +0,0 @@
-#ifndef _IPT_MULTIPORT_H
-#define _IPT_MULTIPORT_H
-
-enum ipt_multiport_flags
-{
-	IPT_MULTIPORT_SOURCE,
-	IPT_MULTIPORT_DESTINATION,
-	IPT_MULTIPORT_EITHER
-};
-
-#define IPT_MULTI_PORTS	15
-
-/* Must fit inside union ipt_matchinfo: 16 bytes */
-struct ipt_multiport
-{
-	u_int8_t flags;				/* Type of comparison */
-	u_int8_t count;				/* Number of ports */
-	u_int16_t ports[IPT_MULTI_PORTS];	/* Ports */
-};
-
-struct ipt_multiport_v1
-{
-	u_int8_t flags;				/* Type of comparison */
-	u_int8_t count;				/* Number of ports */
-	u_int16_t ports[IPT_MULTI_PORTS];	/* Ports */
-	u_int8_t pflags[IPT_MULTI_PORTS];	/* Port flags */
-	u_int8_t invert;			/* Invert flag */
-};
-#endif /*_IPT_MULTIPORT_H*/
diff --git a/include/linux/netfilter_ipv6/ip6t_multiport.h b/include/linux/netfilter_ipv6/ip6t_multiport.h
deleted file mode 100644
index 8c2cc9d..0000000
--- a/include/linux/netfilter_ipv6/ip6t_multiport.h
+++ /dev/null
@@ -1,30 +0,0 @@
-#ifndef _IP6T_MULTIPORT_H
-#define _IP6T_MULTIPORT_H
-
-enum ip6t_multiport_flags
-{
-	IP6T_MULTIPORT_SOURCE,
-	IP6T_MULTIPORT_DESTINATION,
-	IP6T_MULTIPORT_EITHER
-};
-
-#define IP6T_MULTI_PORTS	15
-
-/* Must fit inside union xt_matchinfo: 16 bytes */
-struct ip6t_multiport
-{
-	u_int8_t flags;				/* Type of comparison */
-	u_int8_t count;				/* Number of ports */
-	u_int16_t ports[IP6T_MULTI_PORTS];	/* Ports */
-};
-
-struct ip6t_multiport_v1
-{
-	u_int8_t flags;				/* Type of comparison */
-	u_int8_t count;				/* Number of ports */
-	u_int16_t ports[IP6T_MULTI_PORTS];	/* Ports */
-	u_int8_t pflags[IP6T_MULTI_PORTS];	/* Port flags */
-	u_int8_t invert;			/* Invert flag */
-};
-
-#endif /*_IP6T_MULTIPORT_H*/
-- 
1.5.2.2
