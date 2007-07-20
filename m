From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [28/43] Unifies libip[6]t_tcp.c into libxt_tcp.c
Date: Fri, 20 Jul 2007 20:12:34 +0900 (JST)
Message-ID: <200707201112.l6KBCZ0o002838@toshiba.co.jp>
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
 extensions/Makefile      |    6 +-
 extensions/libip6t_tcp.c |  416 --------------------------------------------
 extensions/libipt_tcp.c  |  416 --------------------------------------------
 extensions/libxt_tcp.c   |  434 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 437 insertions(+), 835 deletions(-)
 delete mode 100644 extensions/libip6t_tcp.c
 delete mode 100644 extensions/libipt_tcp.c
 create mode 100644 extensions/libxt_tcp.c

diff --git a/extensions/Makefile b/extensions/Makefile
index b0df81c..d57fabe 100644
--- a/extensions/Makefile
+++ b/extensions/Makefile
@@ -5,9 +5,9 @@
 # header files are present in the include/linux directory of this iptables
 # package (HW)
 #
-PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac owner physdev pkttype policy realm sctp standard state tcp tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
-PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit mac owner physdev policy standard state tcp CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
-PFX_EXT_SLIB:=mark multiport tcpmss udp NOTRACK
+PF_EXT_SLIB:=ah addrtype comment connlimit connmark conntrack dscp ecn esp hashlimit helper icmp iprange length limit mac owner physdev pkttype policy realm sctp standard state tos ttl unclean CLASSIFY CONNMARK DNAT DSCP ECN LOG MARK MASQUERADE MIRROR NETMAP NFQUEUE REDIRECT REJECT SAME SNAT TCPMSS TOS TTL TRACE ULOG
+PF6_EXT_SLIB:=connlimit connmark eui64 hl icmp6 length limit mac owner physdev policy standard state CONNMARK HL LOG NFQUEUE MARK TCPMSS TRACE
+PFX_EXT_SLIB:=mark multiport tcp tcpmss udp NOTRACK
 
 ifeq ($(DO_SELINUX), 1)
 PF_EXT_SE_SLIB:=SECMARK CONNSECMARK
diff --git a/extensions/libip6t_tcp.c b/extensions/libip6t_tcp.c
deleted file mode 100644
index e0325d6..0000000
--- a/extensions/libip6t_tcp.c
+++ /dev/null
@@ -1,416 +0,0 @@
-/* Shared library add-on to iptables to add TCP support. */
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
-"TCP v%s options:\n"
-" --tcp-flags [!] mask comp	match when TCP flags & mask == comp\n"
-"				(Flags: SYN ACK FIN RST URG PSH ALL NONE)\n"
-"[!] --syn			match when only SYN flag set\n"
-"				(equivalent to --tcp-flags SYN,RST,ACK,FIN SYN)\n"
-" --source-port [!] port[:port]\n"
-" --sport ...\n"
-"				match source port(s)\n"
-" --destination-port [!] port[:port]\n"
-" --dport ...\n"
-"				match destination port(s)\n"
-" --tcp-option [!] number       match if TCP option set\n\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "source-port", 1, 0, '1' },
-	{ "sport", 1, 0, '1' }, /* synonym */
-	{ "destination-port", 1, 0, '2' },
-	{ "dport", 1, 0, '2' }, /* synonym */
-	{ "syn", 0, 0, '3' },
-	{ "tcp-flags", 1, 0, '4' },
-	{ "tcp-option", 1, 0, '5' },
-	{0}
-};
-
-static void
-parse_tcp_ports(const char *portstring, u_int16_t *ports)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(portstring);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		ports[0] = ports[1] = parse_port(buffer, "tcp");
-	else {
-		*cp = '\0';
-		cp++;
-
-		ports[0] = buffer[0] ? parse_port(buffer, "tcp") : 0;
-		ports[1] = cp[0] ? parse_port(cp, "tcp") : 0xFFFF;
-		
-		if (ports[0] > ports[1])
-			exit_error(PARAMETER_PROBLEM, 
-				   "invalid portrange (min > max)");
-	}
-	free(buffer);
-}
-
-struct tcp_flag_names {
-	const char *name;
-	unsigned int flag;
-};
-
-static struct tcp_flag_names tcp_flag_names[]
-= { { "FIN", 0x01 },
-    { "SYN", 0x02 },
-    { "RST", 0x04 },
-    { "PSH", 0x08 },
-    { "ACK", 0x10 },
-    { "URG", 0x20 },
-    { "ALL", 0x3F },
-    { "NONE", 0 },
-};
-
-static unsigned int
-parse_tcp_flag(const char *flags)
-{
-	unsigned int ret = 0;
-	char *ptr;
-	char *buffer;
-
-	buffer = strdup(flags);
-
-	for (ptr = strtok(buffer, ","); ptr; ptr = strtok(NULL, ",")) {
-		unsigned int i;
-		for (i = 0;
-		     i < sizeof(tcp_flag_names)/sizeof(struct tcp_flag_names);
-		     i++) {
-			if (strcasecmp(tcp_flag_names[i].name, ptr) == 0) {
-				ret |= tcp_flag_names[i].flag;
-				break;
-			}
-		}
-		if (i == sizeof(tcp_flag_names)/sizeof(struct tcp_flag_names))
-			exit_error(PARAMETER_PROBLEM,
-				   "Unknown TCP flag `%s'", ptr);
-		}
-
-	free(buffer);
-	return ret;
-}
-
-static void
-parse_tcp_flags(struct ip6t_tcp *tcpinfo,
-		const char *mask,
-		const char *cmp,
-		int invert)
-{
-	tcpinfo->flg_mask = parse_tcp_flag(mask);
-	tcpinfo->flg_cmp = parse_tcp_flag(cmp);
-
-	if (invert)
-		tcpinfo->invflags |= IP6T_TCP_INV_FLAGS;
-}
-
-static void
-parse_tcp_option(const char *option, u_int8_t *result)
-{
-	unsigned int ret;
-
-	if (string_to_number(option, 1, 255, &ret) == -1)
-		exit_error(PARAMETER_PROBLEM, "Bad TCP option `%s'", option);
-
-	*result = (u_int8_t)ret;
-}
-
-/* Initialize the match. */
-static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
-{
-	struct ip6t_tcp *tcpinfo = (struct ip6t_tcp *)m->data;
-
-	tcpinfo->spts[1] = tcpinfo->dpts[1] = 0xFFFF;
-}
-
-#define TCP_SRC_PORTS 0x01
-#define TCP_DST_PORTS 0x02
-#define TCP_FLAGS 0x04
-#define TCP_OPTION	0x08
-
-/* Function which parses command options; returns true if it
-   ate an option. */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ip6t_tcp *tcpinfo = (struct ip6t_tcp *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & TCP_SRC_PORTS)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--source-port' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_tcp_ports(argv[optind-1], tcpinfo->spts);
-		if (invert)
-			tcpinfo->invflags |= IP6T_TCP_INV_SRCPT;
-		*flags |= TCP_SRC_PORTS;
-		break;
-
-	case '2':
-		if (*flags & TCP_DST_PORTS)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--destination-port' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_tcp_ports(argv[optind-1], tcpinfo->dpts);
-		if (invert)
-			tcpinfo->invflags |= IP6T_TCP_INV_DSTPT;
-		*flags |= TCP_DST_PORTS;
-		break;
-
-	case '3':
-		if (*flags & TCP_FLAGS)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one of `--syn' or `--tcp-flags' "
-				   " allowed");
-		parse_tcp_flags(tcpinfo, "SYN,RST,ACK,FIN", "SYN", invert);
-		*flags |= TCP_FLAGS;
-		break;
-
-	case '4':
-		if (*flags & TCP_FLAGS)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one of `--syn' or `--tcp-flags' "
-				   " allowed");
-		check_inverse(optarg, &invert, &optind, 0);
-
-		if (!argv[optind]
-		    || argv[optind][0] == '-' || argv[optind][0] == '!')
-			exit_error(PARAMETER_PROBLEM,
-				   "--tcp-flags requires two args.");
-
-		parse_tcp_flags(tcpinfo, argv[optind-1], argv[optind], 
-				invert);
-		optind++;
-		*flags |= TCP_FLAGS;
-		break;
-
-	case '5':
-		if (*flags & TCP_OPTION)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--tcp-option' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_tcp_option(argv[optind-1], &tcpinfo->option);
-		if (invert)
-			tcpinfo->invflags |= IP6T_TCP_INV_OPTION;
-		*flags |= TCP_OPTION;
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
-	if ((service = getservbyport(htons(port), "tcp")))
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
-static void
-print_option(u_int8_t option, int invert, int numeric)
-{
-	if (option || invert)
-		printf("option=%s%u ", invert ? "!" : "", option);
-}
-
-static void
-print_tcpf(u_int8_t flags)
-{
-	int have_flag = 0;
-
-	while (flags) {
-		unsigned int i;
-
-		for (i = 0; (flags & tcp_flag_names[i].flag) == 0; i++);
-
-		if (have_flag)
-			printf(",");
-		printf("%s", tcp_flag_names[i].name);
-		have_flag = 1;
-
-		flags &= ~tcp_flag_names[i].flag;
-	}
-
-	if (!have_flag)
-		printf("NONE");
-}
-
-static void
-print_flags(u_int8_t mask, u_int8_t cmp, int invert, int numeric)
-{
-	if (mask || invert) {
-		printf("flags:%s", invert ? "!" : "");
-		if (numeric)
-			printf("0x%02X/0x%02X ", mask, cmp);
-		else {
-			print_tcpf(mask);
-			printf("/");
-			print_tcpf(cmp);
-			printf(" ");
-		}
-	}
-}
-
-/* Prints out the union ipt_matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match, int numeric)
-{
-	const struct ip6t_tcp *tcp = (struct ip6t_tcp *)match->data;
-
-	printf("tcp ");
-	print_ports("spt", tcp->spts[0], tcp->spts[1],
-		    tcp->invflags & IP6T_TCP_INV_SRCPT,
-		    numeric);
-	print_ports("dpt", tcp->dpts[0], tcp->dpts[1],
-		    tcp->invflags & IP6T_TCP_INV_DSTPT,
-		    numeric);
-	print_option(tcp->option,
-		     tcp->invflags & IP6T_TCP_INV_OPTION,
-		     numeric);
-	print_flags(tcp->flg_mask, tcp->flg_cmp,
-		    tcp->invflags & IP6T_TCP_INV_FLAGS,
-		    numeric);
-	if (tcp->invflags & ~IP6T_TCP_INV_MASK)
-		printf("Unknown invflags: 0x%X ",
-		       tcp->invflags & ~IP6T_TCP_INV_MASK);
-}
-
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
-{
-	const struct ip6t_tcp *tcpinfo = (struct ip6t_tcp *)match->data;
-
-	if (tcpinfo->spts[0] != 0
-	    || tcpinfo->spts[1] != 0xFFFF) {
-		if (tcpinfo->invflags & IP6T_TCP_INV_SRCPT)
-			printf("! ");
-		if (tcpinfo->spts[0]
-		    != tcpinfo->spts[1])
-			printf("--sport %u:%u ",
-			       tcpinfo->spts[0],
-			       tcpinfo->spts[1]);
-		else
-			printf("--sport %u ",
-			       tcpinfo->spts[0]);
-	}
-
-	if (tcpinfo->dpts[0] != 0
-	    || tcpinfo->dpts[1] != 0xFFFF) {
-		if (tcpinfo->invflags & IP6T_TCP_INV_DSTPT)
-			printf("! ");
-		if (tcpinfo->dpts[0]
-		    != tcpinfo->dpts[1])
-			printf("--dport %u:%u ",
-			       tcpinfo->dpts[0],
-			       tcpinfo->dpts[1]);
-		else
-			printf("--dport %u ",
-			       tcpinfo->dpts[0]);
-	}
-
-	if (tcpinfo->option
-	    || (tcpinfo->invflags & IP6T_TCP_INV_OPTION)) {
-		if (tcpinfo->invflags & IP6T_TCP_INV_OPTION)
-			printf("! ");
-		printf("--tcp-option %u ", tcpinfo->option);
-	}
-
-	if (tcpinfo->flg_mask
-	    || (tcpinfo->invflags & IP6T_TCP_INV_FLAGS)) {
-		if (tcpinfo->invflags & IP6T_TCP_INV_FLAGS)
-			printf("! ");
-
-		printf("--tcp-flags ");
-		if (tcpinfo->flg_mask != 0xFF) {
-			print_tcpf(tcpinfo->flg_mask);
-		}
-		printf(" ");
-		print_tcpf(tcpinfo->flg_cmp);
-		printf(" ");
-	}
-}
-
-static struct ip6tables_match tcp = {
-	.name 		= "tcp",
-	.version	= IPTABLES_VERSION,
-	.size		= IP6T_ALIGN(sizeof(struct ip6t_tcp)),
-	.userspacesize	= IP6T_ALIGN(sizeof(struct ip6t_tcp)),
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
-	register_match6(&tcp);
-}
diff --git a/extensions/libipt_tcp.c b/extensions/libipt_tcp.c
deleted file mode 100644
index d788506..0000000
--- a/extensions/libipt_tcp.c
+++ /dev/null
@@ -1,416 +0,0 @@
-/* Shared library add-on to iptables to add TCP support. */
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
-"TCP v%s options:\n"
-" --tcp-flags [!] mask comp	match when TCP flags & mask == comp\n"
-"				(Flags: SYN ACK FIN RST URG PSH ALL NONE)\n"
-"[!] --syn			match when only SYN flag set\n"
-"				(equivalent to --tcp-flags SYN,RST,ACK,FIN SYN)\n"
-" --source-port [!] port[:port]\n"
-" --sport ...\n"
-"				match source port(s)\n"
-" --destination-port [!] port[:port]\n"
-" --dport ...\n"
-"				match destination port(s)\n"
-" --tcp-option [!] number       match if TCP option set\n\n",
-IPTABLES_VERSION);
-}
-
-static struct option opts[] = {
-	{ "source-port", 1, 0, '1' },
-	{ "sport", 1, 0, '1' }, /* synonym */
-	{ "destination-port", 1, 0, '2' },
-	{ "dport", 1, 0, '2' }, /* synonym */
-	{ "syn", 0, 0, '3' },
-	{ "tcp-flags", 1, 0, '4' },
-	{ "tcp-option", 1, 0, '5' },
-	{0}
-};
-
-static void
-parse_tcp_ports(const char *portstring, u_int16_t *ports)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(portstring);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		ports[0] = ports[1] = parse_port(buffer, "tcp");
-	else {
-		*cp = '\0';
-		cp++;
-
-		ports[0] = buffer[0] ? parse_port(buffer, "tcp") : 0;
-		ports[1] = cp[0] ? parse_port(cp, "tcp") : 0xFFFF;
-
-		if (ports[0] > ports[1])
-			exit_error(PARAMETER_PROBLEM,
-				   "invalid portrange (min > max)");
-	}
-	free(buffer);
-}
-
-struct tcp_flag_names {
-	const char *name;
-	unsigned int flag;
-};
-
-static struct tcp_flag_names tcp_flag_names[]
-= { { "FIN", 0x01 },
-    { "SYN", 0x02 },
-    { "RST", 0x04 },
-    { "PSH", 0x08 },
-    { "ACK", 0x10 },
-    { "URG", 0x20 },
-    { "ALL", 0x3F },
-    { "NONE", 0 },
-};
-
-static unsigned int
-parse_tcp_flag(const char *flags)
-{
-	unsigned int ret = 0;
-	char *ptr;
-	char *buffer;
-
-	buffer = strdup(flags);
-
-	for (ptr = strtok(buffer, ","); ptr; ptr = strtok(NULL, ",")) {
-		unsigned int i;
-		for (i = 0;
-		     i < sizeof(tcp_flag_names)/sizeof(struct tcp_flag_names);
-		     i++) {
-			if (strcasecmp(tcp_flag_names[i].name, ptr) == 0) {
-				ret |= tcp_flag_names[i].flag;
-				break;
-			}
-		}
-		if (i == sizeof(tcp_flag_names)/sizeof(struct tcp_flag_names))
-			exit_error(PARAMETER_PROBLEM,
-				   "Unknown TCP flag `%s'", ptr);
-		}
-
-	free(buffer);
-	return ret;
-}
-
-static void
-parse_tcp_flags(struct ipt_tcp *tcpinfo,
-		const char *mask,
-		const char *cmp,
-		int invert)
-{
-	tcpinfo->flg_mask = parse_tcp_flag(mask);
-	tcpinfo->flg_cmp = parse_tcp_flag(cmp);
-
-	if (invert)
-		tcpinfo->invflags |= IPT_TCP_INV_FLAGS;
-}
-
-static void
-parse_tcp_option(const char *option, u_int8_t *result)
-{
-	unsigned int ret;
-
-	if (string_to_number(option, 1, 255, &ret) == -1)
-		exit_error(PARAMETER_PROBLEM, "Bad TCP option `%s'", option);
-
-	*result = (u_int8_t)ret;
-}
-
-/* Initialize the match. */
-static void
-init(struct xt_entry_match *m, unsigned int *nfcache)
-{
-	struct ipt_tcp *tcpinfo = (struct ipt_tcp *)m->data;
-
-	tcpinfo->spts[1] = tcpinfo->dpts[1] = 0xFFFF;
-}
-
-#define TCP_SRC_PORTS 0x01
-#define TCP_DST_PORTS 0x02
-#define TCP_FLAGS 0x04
-#define TCP_OPTION	0x08
-
-/* Function which parses command options; returns true if it
-   ate an option. */
-static int
-parse(int c, char **argv, int invert, unsigned int *flags,
-      const void *entry,
-      unsigned int *nfcache,
-      struct xt_entry_match **match)
-{
-	struct ipt_tcp *tcpinfo = (struct ipt_tcp *)(*match)->data;
-
-	switch (c) {
-	case '1':
-		if (*flags & TCP_SRC_PORTS)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--source-port' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_tcp_ports(argv[optind-1], tcpinfo->spts);
-		if (invert)
-			tcpinfo->invflags |= IPT_TCP_INV_SRCPT;
-		*flags |= TCP_SRC_PORTS;
-		break;
-
-	case '2':
-		if (*flags & TCP_DST_PORTS)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--destination-port' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_tcp_ports(argv[optind-1], tcpinfo->dpts);
-		if (invert)
-			tcpinfo->invflags |= IPT_TCP_INV_DSTPT;
-		*flags |= TCP_DST_PORTS;
-		break;
-
-	case '3':
-		if (*flags & TCP_FLAGS)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one of `--syn' or `--tcp-flags' "
-				   " allowed");
-		parse_tcp_flags(tcpinfo, "SYN,RST,ACK,FIN", "SYN", invert);
-		*flags |= TCP_FLAGS;
-		break;
-
-	case '4':
-		if (*flags & TCP_FLAGS)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one of `--syn' or `--tcp-flags' "
-				   " allowed");
-		check_inverse(optarg, &invert, &optind, 0);
-
-		if (!argv[optind]
-		    || argv[optind][0] == '-' || argv[optind][0] == '!')
-			exit_error(PARAMETER_PROBLEM,
-				   "--tcp-flags requires two args.");
-
-		parse_tcp_flags(tcpinfo, argv[optind-1], argv[optind],
-				invert);
-		optind++;
-		*flags |= TCP_FLAGS;
-		break;
-
-	case '5':
-		if (*flags & TCP_OPTION)
-			exit_error(PARAMETER_PROBLEM,
-				   "Only one `--tcp-option' allowed");
-		check_inverse(optarg, &invert, &optind, 0);
-		parse_tcp_option(argv[optind-1], &tcpinfo->option);
-		if (invert)
-			tcpinfo->invflags |= IPT_TCP_INV_OPTION;
-		*flags |= TCP_OPTION;
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
-	if ((service = getservbyport(htons(port), "tcp")))
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
-static void
-print_option(u_int8_t option, int invert, int numeric)
-{
-	if (option || invert)
-		printf("option=%s%u ", invert ? "!" : "", option);
-}
-
-static void
-print_tcpf(u_int8_t flags)
-{
-	int have_flag = 0;
-
-	while (flags) {
-		unsigned int i;
-
-		for (i = 0; (flags & tcp_flag_names[i].flag) == 0; i++);
-
-		if (have_flag)
-			printf(",");
-		printf("%s", tcp_flag_names[i].name);
-		have_flag = 1;
-
-		flags &= ~tcp_flag_names[i].flag;
-	}
-
-	if (!have_flag)
-		printf("NONE");
-}
-
-static void
-print_flags(u_int8_t mask, u_int8_t cmp, int invert, int numeric)
-{
-	if (mask || invert) {
-		printf("flags:%s", invert ? "!" : "");
-		if (numeric)
-			printf("0x%02X/0x%02X ", mask, cmp);
-		else {
-			print_tcpf(mask);
-			printf("/");
-			print_tcpf(cmp);
-			printf(" ");
-		}
-	}
-}
-
-/* Prints out the union ipt_matchinfo. */
-static void
-print(const void *ip,
-      const struct xt_entry_match *match, int numeric)
-{
-	const struct ipt_tcp *tcp = (struct ipt_tcp *)match->data;
-
-	printf("tcp ");
-	print_ports("spt", tcp->spts[0], tcp->spts[1],
-		    tcp->invflags & IPT_TCP_INV_SRCPT,
-		    numeric);
-	print_ports("dpt", tcp->dpts[0], tcp->dpts[1],
-		    tcp->invflags & IPT_TCP_INV_DSTPT,
-		    numeric);
-	print_option(tcp->option,
-		     tcp->invflags & IPT_TCP_INV_OPTION,
-		     numeric);
-	print_flags(tcp->flg_mask, tcp->flg_cmp,
-		    tcp->invflags & IPT_TCP_INV_FLAGS,
-		    numeric);
-	if (tcp->invflags & ~IPT_TCP_INV_MASK)
-		printf("Unknown invflags: 0x%X ",
-		       tcp->invflags & ~IPT_TCP_INV_MASK);
-}
-
-/* Saves the union ipt_matchinfo in parsable form to stdout. */
-static void save(const void *ip, const struct xt_entry_match *match)
-{
-	const struct ipt_tcp *tcpinfo = (struct ipt_tcp *)match->data;
-
-	if (tcpinfo->spts[0] != 0
-	    || tcpinfo->spts[1] != 0xFFFF) {
-		if (tcpinfo->invflags & IPT_TCP_INV_SRCPT)
-			printf("! ");
-		if (tcpinfo->spts[0]
-		    != tcpinfo->spts[1])
-			printf("--sport %u:%u ",
-			       tcpinfo->spts[0],
-			       tcpinfo->spts[1]);
-		else
-			printf("--sport %u ",
-			       tcpinfo->spts[0]);
-	}
-
-	if (tcpinfo->dpts[0] != 0
-	    || tcpinfo->dpts[1] != 0xFFFF) {
-		if (tcpinfo->invflags & IPT_TCP_INV_DSTPT)
-			printf("! ");
-		if (tcpinfo->dpts[0]
-		    != tcpinfo->dpts[1])
-			printf("--dport %u:%u ",
-			       tcpinfo->dpts[0],
-			       tcpinfo->dpts[1]);
-		else
-			printf("--dport %u ",
-			       tcpinfo->dpts[0]);
-	}
-
-	if (tcpinfo->option
-	    || (tcpinfo->invflags & IPT_TCP_INV_OPTION)) {
-		if (tcpinfo->invflags & IPT_TCP_INV_OPTION)
-			printf("! ");
-		printf("--tcp-option %u ", tcpinfo->option);
-	}
-
-	if (tcpinfo->flg_mask
-	    || (tcpinfo->invflags & IPT_TCP_INV_FLAGS)) {
-		if (tcpinfo->invflags & IPT_TCP_INV_FLAGS)
-			printf("! ");
-		printf("--tcp-flags ");
-		if (tcpinfo->flg_mask != 0xFF) {
-			print_tcpf(tcpinfo->flg_mask);
-		}
-		printf(" ");
-		print_tcpf(tcpinfo->flg_cmp);
-		printf(" ");
-	}
-}
-
-static struct iptables_match tcp = { 
-	.next		= NULL,
-	.name		= "tcp",
-	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_tcp)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_tcp)),
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
-	register_match(&tcp);
-}
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
new file mode 100644
index 0000000..c3a53b7
--- /dev/null
+++ b/extensions/libxt_tcp.c
@@ -0,0 +1,434 @@
+/* Shared library add-on to iptables to add TCP support. */
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
+"TCP v%s options:\n"
+" --tcp-flags [!] mask comp	match when TCP flags & mask == comp\n"
+"				(Flags: SYN ACK FIN RST URG PSH ALL NONE)\n"
+"[!] --syn			match when only SYN flag set\n"
+"				(equivalent to --tcp-flags SYN,RST,ACK,FIN SYN)\n"
+" --source-port [!] port[:port]\n"
+" --sport ...\n"
+"				match source port(s)\n"
+" --destination-port [!] port[:port]\n"
+" --dport ...\n"
+"				match destination port(s)\n"
+" --tcp-option [!] number       match if TCP option set\n\n",
+IPTABLES_VERSION);
+}
+
+static struct option opts[] = {
+	{ "source-port", 1, 0, '1' },
+	{ "sport", 1, 0, '1' }, /* synonym */
+	{ "destination-port", 1, 0, '2' },
+	{ "dport", 1, 0, '2' }, /* synonym */
+	{ "syn", 0, 0, '3' },
+	{ "tcp-flags", 1, 0, '4' },
+	{ "tcp-option", 1, 0, '5' },
+	{0}
+};
+
+static void
+parse_tcp_ports(const char *portstring, u_int16_t *ports)
+{
+	char *buffer;
+	char *cp;
+
+	buffer = strdup(portstring);
+	if ((cp = strchr(buffer, ':')) == NULL)
+		ports[0] = ports[1] = parse_port(buffer, "tcp");
+	else {
+		*cp = '\0';
+		cp++;
+
+		ports[0] = buffer[0] ? parse_port(buffer, "tcp") : 0;
+		ports[1] = cp[0] ? parse_port(cp, "tcp") : 0xFFFF;
+
+		if (ports[0] > ports[1])
+			exit_error(PARAMETER_PROBLEM,
+				   "invalid portrange (min > max)");
+	}
+	free(buffer);
+}
+
+struct tcp_flag_names {
+	const char *name;
+	unsigned int flag;
+};
+
+static struct tcp_flag_names tcp_flag_names[]
+= { { "FIN", 0x01 },
+    { "SYN", 0x02 },
+    { "RST", 0x04 },
+    { "PSH", 0x08 },
+    { "ACK", 0x10 },
+    { "URG", 0x20 },
+    { "ALL", 0x3F },
+    { "NONE", 0 },
+};
+
+static unsigned int
+parse_tcp_flag(const char *flags)
+{
+	unsigned int ret = 0;
+	char *ptr;
+	char *buffer;
+
+	buffer = strdup(flags);
+
+	for (ptr = strtok(buffer, ","); ptr; ptr = strtok(NULL, ",")) {
+		unsigned int i;
+		for (i = 0;
+		     i < sizeof(tcp_flag_names)/sizeof(struct tcp_flag_names);
+		     i++) {
+			if (strcasecmp(tcp_flag_names[i].name, ptr) == 0) {
+				ret |= tcp_flag_names[i].flag;
+				break;
+			}
+		}
+		if (i == sizeof(tcp_flag_names)/sizeof(struct tcp_flag_names))
+			exit_error(PARAMETER_PROBLEM,
+				   "Unknown TCP flag `%s'", ptr);
+		}
+
+	free(buffer);
+	return ret;
+}
+
+static void
+parse_tcp_flags(struct xt_tcp *tcpinfo,
+		const char *mask,
+		const char *cmp,
+		int invert)
+{
+	tcpinfo->flg_mask = parse_tcp_flag(mask);
+	tcpinfo->flg_cmp = parse_tcp_flag(cmp);
+
+	if (invert)
+		tcpinfo->invflags |= XT_TCP_INV_FLAGS;
+}
+
+static void
+parse_tcp_option(const char *option, u_int8_t *result)
+{
+	unsigned int ret;
+
+	if (string_to_number(option, 1, 255, &ret) == -1)
+		exit_error(PARAMETER_PROBLEM, "Bad TCP option `%s'", option);
+
+	*result = (u_int8_t)ret;
+}
+
+/* Initialize the match. */
+static void
+init(struct xt_entry_match *m, unsigned int *nfcache)
+{
+	struct xt_tcp *tcpinfo = (struct xt_tcp *)m->data;
+
+	tcpinfo->spts[1] = tcpinfo->dpts[1] = 0xFFFF;
+}
+
+#define TCP_SRC_PORTS 0x01
+#define TCP_DST_PORTS 0x02
+#define TCP_FLAGS 0x04
+#define TCP_OPTION	0x08
+
+/* Function which parses command options; returns true if it
+   ate an option. */
+static int
+parse(int c, char **argv, int invert, unsigned int *flags,
+      const void *entry,
+      unsigned int *nfcache,
+      struct xt_entry_match **match)
+{
+	struct xt_tcp *tcpinfo = (struct xt_tcp *)(*match)->data;
+
+	switch (c) {
+	case '1':
+		if (*flags & TCP_SRC_PORTS)
+			exit_error(PARAMETER_PROBLEM,
+				   "Only one `--source-port' allowed");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_tcp_ports(argv[optind-1], tcpinfo->spts);
+		if (invert)
+			tcpinfo->invflags |= XT_TCP_INV_SRCPT;
+		*flags |= TCP_SRC_PORTS;
+		break;
+
+	case '2':
+		if (*flags & TCP_DST_PORTS)
+			exit_error(PARAMETER_PROBLEM,
+				   "Only one `--destination-port' allowed");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_tcp_ports(argv[optind-1], tcpinfo->dpts);
+		if (invert)
+			tcpinfo->invflags |= XT_TCP_INV_DSTPT;
+		*flags |= TCP_DST_PORTS;
+		break;
+
+	case '3':
+		if (*flags & TCP_FLAGS)
+			exit_error(PARAMETER_PROBLEM,
+				   "Only one of `--syn' or `--tcp-flags' "
+				   " allowed");
+		parse_tcp_flags(tcpinfo, "SYN,RST,ACK,FIN", "SYN", invert);
+		*flags |= TCP_FLAGS;
+		break;
+
+	case '4':
+		if (*flags & TCP_FLAGS)
+			exit_error(PARAMETER_PROBLEM,
+				   "Only one of `--syn' or `--tcp-flags' "
+				   " allowed");
+		check_inverse(optarg, &invert, &optind, 0);
+
+		if (!argv[optind]
+		    || argv[optind][0] == '-' || argv[optind][0] == '!')
+			exit_error(PARAMETER_PROBLEM,
+				   "--tcp-flags requires two args.");
+
+		parse_tcp_flags(tcpinfo, argv[optind-1], argv[optind],
+				invert);
+		optind++;
+		*flags |= TCP_FLAGS;
+		break;
+
+	case '5':
+		if (*flags & TCP_OPTION)
+			exit_error(PARAMETER_PROBLEM,
+				   "Only one `--tcp-option' allowed");
+		check_inverse(optarg, &invert, &optind, 0);
+		parse_tcp_option(argv[optind-1], &tcpinfo->option);
+		if (invert)
+			tcpinfo->invflags |= XT_TCP_INV_OPTION;
+		*flags |= TCP_OPTION;
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
+	if ((service = getservbyport(htons(port), "tcp")))
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
+static void
+print_option(u_int8_t option, int invert, int numeric)
+{
+	if (option || invert)
+		printf("option=%s%u ", invert ? "!" : "", option);
+}
+
+static void
+print_tcpf(u_int8_t flags)
+{
+	int have_flag = 0;
+
+	while (flags) {
+		unsigned int i;
+
+		for (i = 0; (flags & tcp_flag_names[i].flag) == 0; i++);
+
+		if (have_flag)
+			printf(",");
+		printf("%s", tcp_flag_names[i].name);
+		have_flag = 1;
+
+		flags &= ~tcp_flag_names[i].flag;
+	}
+
+	if (!have_flag)
+		printf("NONE");
+}
+
+static void
+print_flags(u_int8_t mask, u_int8_t cmp, int invert, int numeric)
+{
+	if (mask || invert) {
+		printf("flags:%s", invert ? "!" : "");
+		if (numeric)
+			printf("0x%02X/0x%02X ", mask, cmp);
+		else {
+			print_tcpf(mask);
+			printf("/");
+			print_tcpf(cmp);
+			printf(" ");
+		}
+	}
+}
+
+/* Prints out the union ipt_matchinfo. */
+static void
+print(const void *ip,
+      const struct xt_entry_match *match, int numeric)
+{
+	const struct xt_tcp *tcp = (struct xt_tcp *)match->data;
+
+	printf("tcp ");
+	print_ports("spt", tcp->spts[0], tcp->spts[1],
+		    tcp->invflags & XT_TCP_INV_SRCPT,
+		    numeric);
+	print_ports("dpt", tcp->dpts[0], tcp->dpts[1],
+		    tcp->invflags & XT_TCP_INV_DSTPT,
+		    numeric);
+	print_option(tcp->option,
+		     tcp->invflags & XT_TCP_INV_OPTION,
+		     numeric);
+	print_flags(tcp->flg_mask, tcp->flg_cmp,
+		    tcp->invflags & XT_TCP_INV_FLAGS,
+		    numeric);
+	if (tcp->invflags & ~XT_TCP_INV_MASK)
+		printf("Unknown invflags: 0x%X ",
+		       tcp->invflags & ~XT_TCP_INV_MASK);
+}
+
+/* Saves the union ipt_matchinfo in parsable form to stdout. */
+static void save(const void *ip, const struct xt_entry_match *match)
+{
+	const struct xt_tcp *tcpinfo = (struct xt_tcp *)match->data;
+
+	if (tcpinfo->spts[0] != 0
+	    || tcpinfo->spts[1] != 0xFFFF) {
+		if (tcpinfo->invflags & XT_TCP_INV_SRCPT)
+			printf("! ");
+		if (tcpinfo->spts[0]
+		    != tcpinfo->spts[1])
+			printf("--sport %u:%u ",
+			       tcpinfo->spts[0],
+			       tcpinfo->spts[1]);
+		else
+			printf("--sport %u ",
+			       tcpinfo->spts[0]);
+	}
+
+	if (tcpinfo->dpts[0] != 0
+	    || tcpinfo->dpts[1] != 0xFFFF) {
+		if (tcpinfo->invflags & XT_TCP_INV_DSTPT)
+			printf("! ");
+		if (tcpinfo->dpts[0]
+		    != tcpinfo->dpts[1])
+			printf("--dport %u:%u ",
+			       tcpinfo->dpts[0],
+			       tcpinfo->dpts[1]);
+		else
+			printf("--dport %u ",
+			       tcpinfo->dpts[0]);
+	}
+
+	if (tcpinfo->option
+	    || (tcpinfo->invflags & XT_TCP_INV_OPTION)) {
+		if (tcpinfo->invflags & XT_TCP_INV_OPTION)
+			printf("! ");
+		printf("--tcp-option %u ", tcpinfo->option);
+	}
+
+	if (tcpinfo->flg_mask
+	    || (tcpinfo->invflags & XT_TCP_INV_FLAGS)) {
+		if (tcpinfo->invflags & XT_TCP_INV_FLAGS)
+			printf("! ");
+		printf("--tcp-flags ");
+		if (tcpinfo->flg_mask != 0xFF) {
+			print_tcpf(tcpinfo->flg_mask);
+		}
+		printf(" ");
+		print_tcpf(tcpinfo->flg_cmp);
+		printf(" ");
+	}
+}
+
+static struct xtables_match tcp = { 
+	.next		= NULL,
+	.family		= AF_INET,
+	.name		= "tcp",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_tcp)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcp)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts,
+};
+
+static struct xtables_match tcp6 = { 
+	.next		= NULL,
+	.family		= AF_INET6,
+	.name		= "tcp",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_tcp)),
+	.userspacesize	= XT_ALIGN(sizeof(struct xt_tcp)),
+	.help		= &help,
+	.init		= &init,
+	.parse		= &parse,
+	.final_check	= &final_check,
+	.print		= &print,
+	.save		= &save,
+	.extra_opts	= opts,
+};
+
+void
+_init(void)
+{
+	xtables_register_match(&tcp);
+	xtables_register_match(&tcp6);
+}
-- 
1.5.2.2
