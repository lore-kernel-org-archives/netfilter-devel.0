From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: latest netfilter+ipsec patches
Date: Fri, 05 Mar 2004 00:44:20 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <4047BF54.5030509@trash.net>
References: <20040127103917.GC11761@sunbeam.de.gnumonks.org> <Pine.LNX.4.44.0401271207160.16067-100000@filer.marasystems.com> <20040127130739.GR11761@sunbeam.de.gnumonks.org> <20040128000938.GH11761@sunbeam.de.gnumonks.org> <401777B4.9020000@trash.net> <20040128103000.GP11761@sunbeam.de.gnumonks.org> <401D12B6.5030707@trash.net> <40301AB2.2030103@trash.net> <40337D63.6080602@trash.net> <20040218220337.GA3193@alpha.home.local> <40356624.6050209@trash.net> <4047AE0E.1080003@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010907000803010409070109"
Cc: Willy Tarreau <willy@w.ods.org>, Harald Welte <laforge@netfilter.org>,
 Tom Eastep <teastep@shorewall.net>,
 Michal Ludvig <mludvig@suse.cz>,  alex@samad.com.au,
 guillaume@morinfr.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <4047AE0E.1080003@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------010907000803010409070109
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:

> - new match "policy" for matching the policy that was used during
> decapsulation (well, the used SAs, policy checks come later), and the
> policy that will be used for encapsulation.
> 

This patch (libipt_policy.diff) was broken in the last mail, fixed
version attached.

> Regards
> Patrick

--------------010907000803010409070109
Content-Type: text/x-patch;
 name="libipt_policy.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="libipt_policy.diff"

diff -urN a/extensions/.policy-test b/extensions/.policy-test
--- a/extensions/.policy-test	1970-01-01 01:00:00.000000000 +0100
+++ b/extensions/.policy-test	2004-03-05 00:44:32.000000000 +0100
@@ -0,0 +1,3 @@
+#!/bin/sh
+#
+[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_policy.h ] && echo policy
diff -urN a/extensions/libipt_policy.c b/extensions/libipt_policy.c
--- a/extensions/libipt_policy.c	1970-01-01 01:00:00.000000000 +0100
+++ b/extensions/libipt_policy.c	2004-03-05 00:44:40.000000000 +0100
@@ -0,0 +1,421 @@
+/* Shared library add-on to iptables to add policy support. */
+#include <stdio.h>
+#include <netdb.h>
+#include <string.h>
+#include <stdlib.h>
+#include <syslog.h>
+#include <getopt.h>
+#include <netdb.h>
+#include <errno.h>
+#include <sys/socket.h>
+#include <netinet/in.h>
+#include <arpa/inet.h>
+#include <iptables.h>
+
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv4/ipt_policy.h>
+
+/* 
+ * HACK: global pointer to current matchinfo for making
+ * final checks and adjustments in final_check.
+ */
+static struct ipt_policy_info *policy_info;
+
+static void help(void)
+{
+	printf(
+"policy v%s options:\n"
+"  --dir in|out			match policy applied during decapsulation/\n"
+"				policy to be applied during encapsulation\n"
+"  --pol none|ipsec		match policy\n"
+"  --strict 			match entire policy instead of single element\n"
+"				at any position\n"
+"[!] --reqid reqid		match reqid\n"
+"[!] --spi spi			match SPI\n"
+"[!] --proto proto		match protocol (ah/esp/ipcomp)\n"
+"[!] --mode mode 		match mode (transport/tunnel)\n"
+"[!] --tunnel-src addr/mask	match tunnel source\n"
+"[!] --tunnel-dst addr/mask	match tunnel destination\n"
+"  --next 			begin next element in policy\n",
+	IPTABLES_VERSION);
+}
+
+static struct option opts[] =
+{
+	{
+		.name		= "dir",
+		.has_arg	= 1,
+		.val		= '1',
+	},
+	{
+		.name		= "pol",
+		.has_arg	= 1,
+		.val		= '2',
+	},
+	{
+		.name		= "strict",
+		.val		= '3'
+	},
+	{
+		.name		= "reqid",
+		.has_arg	= 1,
+		.val		= '4',
+	},
+	{
+		.name		= "spi",
+		.has_arg	= 1,
+		.val		= '5'
+	},
+	{
+		.name		= "tunnel-src",
+		.has_arg	= 1,
+		.val		= '6'
+	},
+	{
+		.name		= "tunnel-dst",
+		.has_arg	= 1,
+		.val		= '7'
+	},
+	{
+		.name		= "proto",
+		.has_arg	= 1,
+		.val		= '8'
+	},
+	{
+		.name		= "mode",
+		.has_arg	= 1,
+		.val		= '9'
+	},
+	{
+		.name		= "next",
+		.val		= 'a'
+	},
+	{ }
+};
+
+static void init(struct ipt_entry_match *m, unsigned int *nfcache)
+{
+	*nfcache |= NFC_UNKNOWN;
+}
+
+static int parse_direction(char *s)
+{
+	if (strcmp(s, "in") == 0)
+		return POLICY_MATCH_IN;
+	if (strcmp(s, "out") == 0)
+		return POLICY_MATCH_OUT;
+	exit_error(PARAMETER_PROBLEM, "policy_match: invalid dir `%s'", s);
+}
+
+static int parse_policy(char *s)
+{
+	if (strcmp(s, "none") == 0)
+		return POLICY_MATCH_NONE;
+	if (strcmp(s, "ipsec") == 0)
+		return 0;
+	exit_error(PARAMETER_PROBLEM, "policy match: invalid policy `%s'", s);
+}
+
+static int parse_mode(char *s)
+{
+	if (strcmp(s, "transport") == 0)
+		return POLICY_MODE_TRANSPORT;
+	if (strcmp(s, "tunnel") == 0)
+		return POLICY_MODE_TUNNEL;
+	exit_error(PARAMETER_PROBLEM, "policy match: invalid mode `%s'", s);
+}
+
+static int parse(int c, char **argv, int invert, unsigned int *flags,
+                 const struct ipt_entry *entry,
+                 unsigned int *nfcache,
+                 struct ipt_entry_match **match)
+{
+	struct ipt_policy_info *info = (void *)(*match)->data;
+	struct ipt_policy_elem *e = &info->pol[info->len];
+	struct in_addr *addr = NULL, mask;
+	unsigned int naddr = 0;
+	int mode;
+
+	check_inverse(optarg, &invert, &optind, 0);
+
+	switch (c) {
+	case '1':
+		if (info->flags & (POLICY_MATCH_IN|POLICY_MATCH_OUT))
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: double --dir option");
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: can't invert --dir option");
+
+		info->flags |= parse_direction(argv[optind-1]);
+		break;
+	case '2':
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: can't invert --policy option");
+
+		info->flags |= parse_policy(argv[optind-1]);
+		break;
+	case '3':
+		if (info->flags & POLICY_MATCH_STRICT)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: double --strict option");
+
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: can't invert --strict option");
+
+		info->flags |= POLICY_MATCH_STRICT;
+		break;
+	case '4':
+		if (e->match.reqid)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: double --reqid option");
+
+		e->match.reqid = 1;
+		e->invert.reqid = invert;
+		e->reqid = strtol(argv[optind-1], NULL, 10);
+		break;
+	case '5':
+		if (e->match.spi)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: double --spi option");
+		
+		e->match.spi = 1;
+		e->invert.spi = invert;
+		e->spi = strtol(argv[optind-1], NULL, 0x10);
+		break;
+	case '6':
+		if (e->match.saddr)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: double --tunnel-src option");
+
+		parse_hostnetworkmask(argv[optind-1], &addr, &mask, &naddr);
+		if (naddr > 1)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: name resolves to multiple IPs");
+
+		e->match.saddr = 1;
+		e->invert.saddr = invert;
+		e->saddr = addr[0].s_addr;
+		e->smask = mask.s_addr;
+                break;
+	case '7':
+		if (e->match.daddr)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: double --tunnel-dst option");
+
+		parse_hostnetworkmask(argv[optind-1], &addr, &mask, &naddr);
+		if (naddr > 1)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: name resolves to multiple IPs");
+
+		e->match.daddr = 1;
+		e->invert.daddr = invert;
+		e->daddr = addr[0].s_addr;
+		e->dmask = mask.s_addr;
+		break;
+	case '8':
+		if (e->match.proto)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: double --proto option");
+
+		e->proto = parse_protocol(argv[optind-1]);
+		if (e->proto != IPPROTO_AH && e->proto != IPPROTO_ESP &&
+		    e->proto != IPPROTO_COMP)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: protocol must ah/esp/ipcomp");
+		e->match.proto = 1;
+		e->invert.proto = invert;
+		break;
+	case '9':
+		if (e->match.mode)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: double --mode option");
+		
+		mode = parse_mode(argv[optind-1]);
+		e->match.mode = 1;
+		e->invert.mode = invert;
+		e->mode = mode;
+		break;
+	case 'a':
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: can't invert --next option");
+
+		if (++info->len == POLICY_MAX_ELEM)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: maximum policy depth reached");
+		break;
+	default:
+		return 0;
+	}
+
+	policy_info = info;
+	return 1;
+}
+
+static void final_check(unsigned int flags)
+{
+	struct ipt_policy_info *info = policy_info;
+	struct ipt_policy_elem *e;
+	int i;
+
+	if (info == NULL)
+		exit_error(PARAMETER_PROBLEM,
+		           "policy match: no parameters given");
+
+	if (!(info->flags & (POLICY_MATCH_IN|POLICY_MATCH_OUT)))
+		exit_error(PARAMETER_PROBLEM,
+		           "policy match: neither --in nor --out specified");
+
+	if (info->flags & POLICY_MATCH_NONE) {
+		if (info->flags & POLICY_MATCH_STRICT)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: policy none but --strict given");
+
+		if (info->len != 0)
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: policy none but policy given");
+	} else
+		info->len++;	/* increase len by 1, no --next after last element */
+
+	if (!(info->flags & POLICY_MATCH_STRICT) && info->len > 1)
+		exit_error(PARAMETER_PROBLEM,
+		           "policy match: multiple elements but no --strict");
+
+	for (i = 0; i < info->len; i++) {
+		e = &info->pol[i];
+		if ((e->match.saddr || e->match.daddr)
+		    && ((e->mode == POLICY_MODE_TUNNEL && e->invert.mode) ||
+		        (e->mode == POLICY_MODE_TRANSPORT && !e->invert.mode)))
+			exit_error(PARAMETER_PROBLEM,
+			           "policy match: --tunnel-src/--tunnel-dst "
+			           "is only valid in tunnel mode");
+	}
+}
+
+static void print_mode(char *prefix, u_int8_t mode, int numeric)
+{
+	printf("%smode ", prefix);
+
+	switch (mode) {
+	case POLICY_MODE_TRANSPORT:
+		printf("transport ");
+		break;
+	case POLICY_MODE_TUNNEL:
+		printf("tunnel ");
+		break;
+	default:
+		printf("??? ");
+		break;
+	}
+}
+
+#define PRINT_INVERT(x)		\
+do {				\
+	if (x)			\
+		printf("! ");	\
+} while(0)
+
+static void print_entry(char *prefix, const struct ipt_policy_elem *e,
+                        int numeric)
+{
+	if (e->match.reqid) {
+		PRINT_INVERT(e->invert.reqid);
+		printf("%sreqid %u ", prefix, e->reqid);
+	}
+	if (e->match.spi) {
+		PRINT_INVERT(e->invert.spi);
+		printf("%sspi 0x%x ", prefix, e->spi);
+	}
+	if (e->match.proto) {
+		PRINT_INVERT(e->invert.proto);
+		printf("%sproto %s ", prefix, proto_to_name(e->proto, numeric));
+	}
+	if (e->match.mode) {
+		PRINT_INVERT(e->invert.mode);
+		print_mode(prefix, e->mode, numeric);
+	}
+	if (e->match.daddr) {
+		PRINT_INVERT(e->invert.daddr);
+		printf("%stunnel-dst %s%s ", prefix,
+		       addr_to_dotted((struct in_addr *)&e->daddr),
+		       mask_to_dotted((struct in_addr *)&e->dmask));
+	}
+	if (e->match.saddr) {
+		PRINT_INVERT(e->invert.saddr);
+		printf("%stunnel-src %s%s ", prefix,
+		       addr_to_dotted((struct in_addr *)&e->saddr),
+		       mask_to_dotted((struct in_addr *)&e->smask));
+	}
+}
+
+static void print_flags(char *prefix, const struct ipt_policy_info *info)
+{
+	if (info->flags & POLICY_MATCH_IN)
+		printf("%sdir in ", prefix);
+	else
+		printf("%sdir out ", prefix);
+
+	if (info->flags & POLICY_MATCH_NONE)
+		printf("%spol none ", prefix);
+	else
+		printf("%spol ipsec ", prefix);
+
+	if (info->flags & POLICY_MATCH_STRICT)
+		printf("%sstrict ", prefix);
+}
+
+static void print(const struct ipt_ip *ip,
+                  const struct ipt_entry_match *match,
+		  int numeric)
+{
+	const struct ipt_policy_info *info = (void *)match->data;
+	unsigned int i;
+
+	printf("policy match ");
+	print_flags("", info);
+	for (i = 0; i < info->len; i++) {
+		if (info->len > 1)
+			printf("[%u] ", i);
+		print_entry("", &info->pol[i], numeric);
+	}
+
+	printf("\n");
+}
+
+static void save(const struct ipt_ip *ip, const struct ipt_entry_match *match)
+{
+	const struct ipt_policy_info *info = (void *)match->data;
+	unsigned int i;
+
+	print_flags("--", info);
+	for (i = 0; i < info->len; i++) {
+		print_entry("--", &info->pol[i], 0);
+		if (i + 1 < info->len)
+			printf("--next ");
+	}
+
+	printf("\n");
+}
+
+struct iptables_match policy =
+{
+	.name		= "policy",
+	.version	= IPTABLES_VERSION,
+	.size		= IPT_ALIGN(sizeof(struct ipt_policy_info)),
+	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_policy_info)),
+	.help		= help,
+	.init		= init,
+	.parse		= parse,
+	.final_check	= final_check,
+	.print		= print,
+	.save		= save,
+	.extra_opts	= opts
+};
+
+void _init(void)
+{
+	register_match(&policy);
+}
diff -urN a/include/iptables.h b/include/iptables.h
--- a/include/iptables.h	2004-03-05 00:43:36.000000000 +0100
+++ b/include/iptables.h	2004-03-05 00:45:29.000000000 +0100
@@ -122,6 +122,7 @@
 extern void register_match(struct iptables_match *me);
 extern void register_target(struct iptables_target *me);
 
+extern char *proto_to_name(u_int8_t proto, int nolookup);
 extern struct in_addr *dotted_to_addr(const char *dotted);
 extern char *addr_to_dotted(const struct in_addr *addrp);
 extern char *addr_to_anyname(const struct in_addr *addr);
diff -urN a/iptables.c b/iptables.c
--- a/iptables.c	2004-03-05 00:44:10.000000000 +0100
+++ b/iptables.c	2004-03-05 00:45:59.000000000 +0100
@@ -235,11 +235,12 @@
 	{ "icmp", IPPROTO_ICMP },
 	{ "esp", IPPROTO_ESP },
 	{ "ah", IPPROTO_AH },
+	{ "ipcomp", IPPROTO_COMP },
 	{ "sctp", IPPROTO_SCTP },
 	{ "all", 0 },
 };
 
-static char *
+char *
 proto_to_name(u_int8_t proto, int nolookup)
 {
 	unsigned int i;

--------------010907000803010409070109--
