From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 26/43] Unifies libip[6]t_udp.c
Date: Sun, 15 Jul 2007 03:11:09 +0900 (JST)
Message-ID: <200707141811.l6EIBAo4017774@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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
 extensions/Makefile                 |    6 +-
 extensions/libip6t_udp.c            |  228 --------------------------------
 extensions/libipt_udp.c             |  230 --------------------------------
 extensions/libxt_udp.c              |  249 +++++++++++++++++++++++++++++++++++
 include/linux/netfilter/xt_tcpudp.h |   36 +++++
 5 files changed, 288 insertions(+), 461 deletions(-)
 delete mode 100644 extensions/libip6t_udp.c
 delete mode 100644 extensions/libipt_udp.c
 create mode 100644 extensions/libxt_udp.c
 create mode 100644 include/linux/netfilter/xt_tcpudp.h

diff --git a/extensions/Makefile b/extensions/Makefile
index 62054f7..8bfb40d 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac owner physdev pkttype policy realm sctp standard state tcp tcpmss tos ttl udp unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
-PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit mac owner physdev policy standard state tcp udp CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
-PFX_EXT_SLIB:=mark multiport NOTRACK
+PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac owner physdev pkttype policy realm sctp standard state tcp tcpmss tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
+PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit mac owner physdev policy standard state tcp CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
+PFX_EXT_SLIB:=mark multiport udp NOTRACK
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=SECMARK CONNSECMARK
diff --git a/extensions/libip6t_udp.c b/extensions/libip6t_udp.c
deleted file mode 100644
index 3355de2..0000000
--- a/extensions/libip6t_udp.c
+++ /dev/null
@@ -1,228 +0,0 @@
-/* Shared library add-on to iptables to add UDP support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <ip6tables.h>
-#include <linux/netfilter_ipv6/ip6_tables.h>
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"UDP v%s options:\n"
-" --source-port [!] port[:port]\n"
-" --sport ...\n"
-"				match source port(s)\n"
-" --destination-port [!] port[:port]\n"
-" --dport ...\n"
-"				match destination port(s)\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "source-port", 1, 0, '1' },
-	{ "sport", 1, 0, '1' }, /* synonym */
-	{ "destination-port", 1, 0, '2' },
-	{ "dport", 1, 0, '2' }, /* synonym */
-	{0}
-};
-
-static void
-parse_udp_ports(const char *portstring, u_int16_t *ports)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(portstring);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		ports[0] = ports[1] = parse_port(buffer, "udp");
-	else {
-		*cp = '\0';
-		cp++;
-
-		ports[0] = buffer[0] ? parse_port(buffer, "udp") : 0;
-		ports[1] = cp[0] ? parse_port(cp, "udp") : 0xFFFF;
-
-		if (ports[0] > ports[1])
-			exit_error(PARAMETER_PROBLEM,
-				   "invalid portrange (min > max)");
-	}
-	free(buffer);
-}
-
-/* Initialize the match. */
-static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
-{
-	struct ip6t_udp *udpinfo = (struct ip6t_udp *)m->data;
-
-	udpinfo->spts[1] = udpinfo->dpts[1] = 0xFFFF;
-}
-
-#define UDP_SRC_PORTS 0x01
-#define UDP_DST_PORTS 0x02
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ip6t_udp *udpinfo = (struct ip6t_udp *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & UDP_SRC_PORTS)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--source-port' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_udp_ports(argv[optind-1], udpinfo->spts);
-		if (invert)
-			udpinfo->invflags |= IP6T_UDP_INV_SRCPT;
-		*flags |= UDP_SRC_PORTS;
-		break;
-
-	case '2':
-		if (*flags & UDP_DST_PORTS)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--destination-port' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_udp_ports(argv[optind-1], udpinfo->dpts);
-		if (invert)
-			udpinfo->invflags |= IP6T_UDP_INV_DSTPT;
-		*flags |= UDP_DST_PORTS;
-		break;
-
-	default:
-		return 0;
-	}
-
-	return 1;
-}
-
-/* Final check; we don't care. */
-static void
-final_check(unsigned int flags)
-{
-}
-
-static char *
-port_to_service(int port)
-{
-	struct servent *service;
-
-	if ((service = getservbyport(htons(port), "udp")))
-		return service->s_name;
-
-	return NULL;
-}
-
-static void
-print_port(u_int16_t port, int numeric)
-{
-	char *service;
-
-	if (numeric || (service = port_to_service(port)) == NULL)
-		printf("%u", port);
-	else
-		printf("%s", service);
-}
-
-static void
-print_ports(const char *name, u_int16_t min, u_int16_t max,
-	    int invert, int numeric)
-{
-	const char *inv = invert ? "!" : "";
-
-	if (min != 0 || max != 0xFFFF || invert) {
-		printf("%s", name);
-		if (min == max) {
-			printf(":%s", inv);
-			print_port(min, numeric);
-		} else {
-			printf("s:%s", inv);
-			print_port(min, numeric);
-			printf(":");
-			print_port(max, numeric);
-		}
-		printf(" ");
-	}
-}
-
-/* Prints out the union ipt_matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match, int numeric)
-{
-	const struct ip6t_udp *udp = (struct ip6t_udp *)match->data;
-
-	printf("udp ");
-	print_ports("spt", udp->spts[0], udp->spts[1],
-		    udp->invflags & IP6T_UDP_INV_SRCPT,
-		    numeric);
-	print_ports("dpt", udp->dpts[0], udp->dpts[1],
-		    udp->invflags & IP6T_UDP_INV_DSTPT,
-		    numeric);
-	if (udp->invflags & ~IP6T_UDP_INV_MASK)
-		printf("Unknown invflags: 0x%X ",
-		       udp->invflags & ~IP6T_UDP_INV_MASK);
-}
-
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
-{
-	const struct ip6t_udp *udpinfo = (struct ip6t_udp *)match->data;
-
-	if (udpinfo->spts[0] != 0
-	    || udpinfo->spts[1] != 0xFFFF) {
-		if (udpinfo->invflags & IP6T_UDP_INV_SRCPT)
-			printf("! ");
-		if (udpinfo->spts[0]
-		    != udpinfo->spts[1])
-			printf("--sport %u:%u ",
-			       udpinfo->spts[0],
-			       udpinfo->spts[1]);
-		else
-			printf("--sport %u ",
-			       udpinfo->spts[0]);
-	}
-
-	if (udpinfo->dpts[0] != 0
-	    || udpinfo->dpts[1] != 0xFFFF) {
-		if (udpinfo->invflags & IP6T_UDP_INV_DSTPT)
-			printf("! ");
-		if (udpinfo->dpts[0]
-		    != udpinfo->dpts[1])
-			printf("--dport %u:%u ",
-			       udpinfo->dpts[0],
-			       udpinfo->dpts[1]);
-		else
-			printf("--dport %u ",
-			       udpinfo->dpts[0]);
-	}
-}
-
-static struct ip6tables_match udp = {
-	.name		= "udp",
-	.version	= IPTABLES_VERSION,
-	.size		= IP6T_ALIGN(sizeof(struct ip6t_udp)),
-	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_udp)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts,
-};
-
-void
-_init(void)
-{
-	register_match6(&udp);
-}
diff --git a/extensions/libipt_udp.c b/extensions/libipt_udp.c
deleted file mode 100644
index 5e7b4a2..0000000
--- a/extensions/libipt_udp.c
+++ /dev/null
@@ -1,230 +0,0 @@
-/* Shared library add-on to iptables to add UDP support. */
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <iptables.h>
-#include <linux/netfilter_ipv4/ip_tables.h>
-
-/* Function which prints out usage message. */
-static void
-help(void)
-{
-	printf(
-"UDP v%s options:\n"
-" --source-port [!] port[:port]\n"
-" --sport ...\n"
-"				match source port(s)\n"
-" --destination-port [!] port[:port]\n"
-" --dport ...\n"
-"				match destination port(s)\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "source-port", 1, 0, '1' },
-	{ "sport", 1, 0, '1' }, /* synonym */
-	{ "destination-port", 1, 0, '2' },
-	{ "dport", 1, 0, '2' }, /* synonym */
-	{0}
-};
-
-static void
-parse_udp_ports(const char *portstring, u_int16_t *ports)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(portstring);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		ports[0] = ports[1] = parse_port(buffer, "udp");
-	else {
-		*cp = '\0';
-		cp++;
-
-		ports[0] = buffer[0] ? parse_port(buffer, "udp") : 0;
-		ports[1] = cp[0] ? parse_port(cp, "udp") : 0xFFFF;
-
-		if (ports[0] > ports[1])
-			exit_error(PARAMETER_PROBLEM,
-				   "invalid portrange (min > max)");
-	}
-	free(buffer);
-}
-
-/* Initialize the match. */
-static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
-{
-	struct ipt_udp *udpinfo = (struct ipt_udp *)m->data;
-
-	udpinfo->spts[1] = udpinfo->dpts[1] = 0xFFFF;
-}
-
-#define UDP_SRC_PORTS 0x01
-#define UDP_DST_PORTS 0x02
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ipt_udp *udpinfo = (struct ipt_udp *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & UDP_SRC_PORTS)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--source-port' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_udp_ports(argv[optind-1], udpinfo->spts);
-		if (invert)
-			udpinfo->invflags |= IPT_UDP_INV_SRCPT;
-		*flags |= UDP_SRC_PORTS;
-		break;
-
-	case '2':
-		if (*flags & UDP_DST_PORTS)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--destination-port' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_udp_ports(argv[optind-1], udpinfo->dpts);
-		if (invert)
-			udpinfo->invflags |= IPT_UDP_INV_DSTPT;
-		*flags |= UDP_DST_PORTS;
-		break;
-
-	default:
-		return 0;
-	}
-
-	return 1;
-}
-
-/* Final check; we don't care. */
-static void
-final_check(unsigned int flags)
-{
-}
-
-static char *
-port_to_service(int port)
-{
-	struct servent *service;
-
-	if ((service = getservbyport(htons(port), "udp")))
-		return service->s_name;
-
-	return NULL;
-}
-
-static void
-print_port(u_int16_t port, int numeric)
-{
-	char *service;
-
-	if (numeric || (service = port_to_service(port)) == NULL)
-		printf("%u", port);
-	else
-		printf("%s", service);
-}
-
-static void
-print_ports(const char *name, u_int16_t min, u_int16_t max,
-	    int invert, int numeric)
-{
-	const char *inv = invert ? "!" : "";
-
-	if (min != 0 || max != 0xFFFF || invert) {
-		printf("%s", name);
-		if (min == max) {
-			printf(":%s", inv);
-			print_port(min, numeric);
-		} else {
-			printf("s:%s", inv);
-			print_port(min, numeric);
-			printf(":");
-			print_port(max, numeric);
-		}
-		printf(" ");
-	}
-}
-
-/* Prints out the union ipt_matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match, int numeric)
-{
-	const struct ipt_udp *udp = (struct ipt_udp *)match->data;
-
-	printf("udp ");
-	print_ports("spt", udp->spts[0], udp->spts[1],
-		    udp->invflags & IPT_UDP_INV_SRCPT,
-		    numeric);
-	print_ports("dpt", udp->dpts[0], udp->dpts[1],
-		    udp->invflags & IPT_UDP_INV_DSTPT,
-		    numeric);
-	if (udp->invflags & ~IPT_UDP_INV_MASK)
-		printf("Unknown invflags: 0x%X ",
-		       udp->invflags & ~IPT_UDP_INV_MASK);
-}
-
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
-{
-	const struct ipt_udp *udpinfo = (struct ipt_udp *)match->data;
-
-	if (udpinfo->spts[0] != 0
-	    || udpinfo->spts[1] != 0xFFFF) {
-		if (udpinfo->invflags & IPT_UDP_INV_SRCPT)
-			printf("! ");
-		if (udpinfo->spts[0]
-		    != udpinfo->spts[1])
-			printf("--sport %u:%u ",
-			       udpinfo->spts[0],
-			       udpinfo->spts[1]);
-		else
-			printf("--sport %u ",
-			       udpinfo->spts[0]);
-	}
-
-	if (udpinfo->dpts[0] != 0
-	    || udpinfo->dpts[1] != 0xFFFF) {
-		if (udpinfo->invflags & IPT_UDP_INV_DSTPT)
-			printf("! ");
-		if (udpinfo->dpts[0]
-		    != udpinfo->dpts[1])
-			printf("--dport %u:%u ",
-			       udpinfo->dpts[0],
-			       udpinfo->dpts[1]);
-		else
-			printf("--dport %u ",
-			       udpinfo->dpts[0]);
-	}
-}
-
-static
-struct iptables_match udp = { 
-	.next		= NULL,
-	.name		= "udp",
-	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_udp)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_udp)),
-	.help		= &help,
-	.init		= &init,
-	.parse		= &parse,
-	.final_check	= &final_check,
-	.print		= &print,
-	.save		= &save,
-	.extra_opts	= opts
-};
-
-void
-_init(void)
-{
-	register_match(&udp);
-}
diff --git a/extensions/libxt_udp.c b/extensions/libxt_udp.c
new file mode 100644
index 0000000..c379536
--- /dev/null
+++ b/extensions/libxt_udp.c
@@ -0,0 +1,249 @@
+/* Shared library add-on to iptables to add UDP support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <getopt.h>
+#include <xtables.h>
+#include <linux/netfilter/xt_tcpudp.h>
+
+/* Function which prints out usage message. */
+static void
+help(void)
+{
+	printf(
+"UDP v%s options:\n"
+" --source-port [!] port[:port]\n"
+" --sport ...\n"
+"				match source port(s)\n"
+" --destination-port [!] port[:port]\n"
+" --dport ...\n"
+"				match destination port(s)\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "source-port", 1, 0, '1' },
+	{ "sport", 1, 0, '1' }, /* synonym */
+	{ "destination-port", 1, 0, '2' },
+	{ "dport", 1, 0, '2' }, /* synonym */
+	{0}
+};
+
+static void
+parse_udp_ports(const char *portstring, u_int16_t *ports)
+{
+	char *buffer;
+	char *cp;
+
+	buffer = strdup(portstring);
+	if ((cp = strchr(buffer, ':')) == NULL)
+		ports[0] = ports[1] = parse_port(buffer, "udp");
+	else {
+		*cp = '\0';
+		cp++;
+
+		ports[0] = buffer[0] ? parse_port(buffer, "udp") : 0;
+		ports[1] = cp[0] ? parse_port(cp, "udp") : 0xFFFF;
+
+		if (ports[0] > ports[1])
+			exit_error(PARAMETER_PROBLEM,
+				   "invalid portrange (min > max)");
+	}
+	free(buffer);
+}
+
+/* Initialize the match. */
+static void
+init(struct xt_entry_match *m, unsigned int *nfcache)
+{
+	struct xt_udp *udpinfo = (struct xt_udp *)m->data;
+
+	udpinfo->spts[1] = udpinfo->dpts[1] = 0xFFFF;
+}
+
+#define UDP_SRC_PORTS 0x01
+#define UDP_DST_PORTS 0x02
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const void *entry,
+      unsigned int *nfcache,
+      struct xt_entry_match **match)
+{
+	struct xt_udp *udpinfo = (struct xt_udp *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags & UDP_SRC_PORTS)
+			exit_error(PARAMETER_PROBLEM,
+				   "Only one `--source-port' allowed");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_udp_ports(argv[optind-1], udpinfo->spts);
+		if (invert)
+			udpinfo->invflags |= XT_UDP_INV_SRCPT;
+		*flags |= UDP_SRC_PORTS;
+		break;
+
+	case '2':
+		if (*flags & UDP_DST_PORTS)
+			exit_error(PARAMETER_PROBLEM,
+				   "Only one `--destination-port' allowed");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_udp_ports(argv[optind-1], udpinfo->dpts);
+		if (invert)
+			udpinfo->invflags |= XT_UDP_INV_DSTPT;
+		*flags |= UDP_DST_PORTS;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+/* Final check; we don't care. */
+static void
+final_check(unsigned int flags)
+{
+}
+
+static char *
+port_to_service(int port)
+{
+	struct servent *service;
+
+	if ((service = getservbyport(htons(port), "udp")))
+		return service->s_name;
+
+	return NULL;
+}
+
+static void
+print_port(u_int16_t port, int numeric)
+{
+	char *service;
+
+	if (numeric || (service = port_to_service(port)) == NULL)
+		printf("%u", port);
+	else
+		printf("%s", service);
+}
+
+static void
+print_ports(const char *name, u_int16_t min, u_int16_t max,
+	    int invert, int numeric)
+{
+	const char *inv = invert ? "!" : "";
+
+	if (min != 0 || max != 0xFFFF || invert) {
+		printf("%s", name);
+		if (min == max) {
+			printf(":%s", inv);
+			print_port(min, numeric);
+		} else {
+			printf("s:%s", inv);
+			print_port(min, numeric);
+			printf(":");
+			print_port(max, numeric);
+		}
+		printf(" ");
+	}
+}
+
+/* Prints out the union ipt_matchinfo. */
+static void
+print(const void *ip,
+      const struct xt_entry_match *match, int numeric)
+{
+	const struct xt_udp *udp = (struct xt_udp *)match->data;
+
+	printf("udp ");
+	print_ports("spt", udp->spts[0], udp->spts[1],
+		    udp->invflags & XT_UDP_INV_SRCPT,
+		    numeric);
+	print_ports("dpt", udp->dpts[0], udp->dpts[1],
+		    udp->invflags & XT_UDP_INV_DSTPT,
+		    numeric);
+	if (udp->invflags & ~XT_UDP_INV_MASK)
+		printf("Unknown invflags: 0x%X ",
+		       udp->invflags & ~XT_UDP_INV_MASK);
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_udp *udpinfo = (struct xt_udp *)match->data;
+
+	if (udpinfo->spts[0] != 0
+	    || udpinfo->spts[1] != 0xFFFF) {
+		if (udpinfo->invflags & XT_UDP_INV_SRCPT)
+			printf("! ");
+		if (udpinfo->spts[0]
+		    != udpinfo->spts[1])
+			printf("--sport %u:%u ",
+			       udpinfo->spts[0],
+			       udpinfo->spts[1]);
+		else
+			printf("--sport %u ",
+			       udpinfo->spts[0]);
+	}
+
+	if (udpinfo->dpts[0] != 0
+	    || udpinfo->dpts[1] != 0xFFFF) {
+		if (udpinfo->invflags & XT_UDP_INV_DSTPT)
+			printf("! ");
+		if (udpinfo->dpts[0]
+		    != udpinfo->dpts[1])
+			printf("--dport %u:%u ",
+			       udpinfo->dpts[0],
+			       udpinfo->dpts[1]);
+		else
+			printf("--dport %u ",
+			       udpinfo->dpts[0]);
+	}
+}
+
+static
+struct xtables_match udp = { 
+	.next		= NULL,
+	.family		= AF_INET,
+	.name		= "udp",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_udp)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_udp)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+static
+struct xtables_match udp6 = { 
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "udp",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_udp)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_udp)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts
+};
+
+void
+_init(void)
+{
+	xtables_register_match(&udp);
+	xtables_register_match(&udp6);
+}
diff --git a/include/linux/netfilter/xt_tcpudp.h b/include/linux/netfilter/xt_tcpudp.h
new file mode 100644
index 0000000..78bc65f
--- /dev/null
+++ b/include/linux/netfilter/xt_tcpudp.h
@@ -0,0 +1,36 @@
+#ifndef _XT_TCPUDP_H
+#define _XT_TCPUDP_H
+
+/* TCP matching stuff */
+struct xt_tcp
+{
+	u_int16_t spts[2];			/* Source port range. */
+	u_int16_t dpts[2];			/* Destination port range. */
+	u_int8_t option;			/* TCP Option iff non-zero*/
+	u_int8_t flg_mask;			/* TCP flags mask byte */
+	u_int8_t flg_cmp;			/* TCP flags compare byte */
+	u_int8_t invflags;			/* Inverse flags */
+};
+
+/* Values for "inv" field in struct ipt_tcp. */
+#define XT_TCP_INV_SRCPT	0x01	/* Invert the sense of source ports. */
+#define XT_TCP_INV_DSTPT	0x02	/* Invert the sense of dest ports. */
+#define XT_TCP_INV_FLAGS	0x04	/* Invert the sense of TCP flags. */
+#define XT_TCP_INV_OPTION	0x08	/* Invert the sense of option test. */
+#define XT_TCP_INV_MASK		0x0F	/* All possible flags. */
+
+/* UDP matching stuff */
+struct xt_udp
+{
+	u_int16_t spts[2];			/* Source port range. */
+	u_int16_t dpts[2];			/* Destination port range. */
+	u_int8_t invflags;			/* Inverse flags */
+};
+
+/* Values for "invflags" field in struct ipt_udp. */
+#define XT_UDP_INV_SRCPT	0x01	/* Invert the sense of source ports. */
+#define XT_UDP_INV_DSTPT	0x02	/* Invert the sense of dest ports. */
+#define XT_UDP_INV_MASK	0x03	/* All possible flags. */
+
+
+#endif
-- 
1.5.2.2
