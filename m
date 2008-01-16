From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [11/19] libxt_conntrack r0
Date: Wed, 16 Jan 2008 14:51:30 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801161451060.4953@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:48706 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755086AbYAPNvc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Jan 2008 08:51:32 -0500
In-Reply-To: <Pine.LNX.4.64.0801161433160.4953@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Move libipt_conntrack to libxt_conntrack.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 extensions/libipt_conntrack.c                |  514 --------------------------
 extensions/libipt_conntrack.man              |   49 --
 extensions/libxt_conntrack.c                 |  517 +++++++++++++++++++++++++++
 extensions/libxt_conntrack.man               |   71 +++
 include/linux/netfilter/xt_conntrack.h       |   83 ++++
 include/linux/netfilter_ipv4/ipt_conntrack.h |   77 ----
 6 files changed, 671 insertions(+), 640 deletions(-)

Index: iptables-modules/extensions/libipt_conntrack.c
===================================================================
--- iptables-modules.orig/extensions/libipt_conntrack.c
+++ /dev/null
@@ -1,514 +0,0 @@
-/* Shared library add-on to iptables for conntrack matching support.
- * GPL (C) 2001  Marc Boucher (marc@mbsi.ca).
- */
-
-#include <stdio.h>
-#include <netdb.h>
-#include <string.h>
-#include <stdlib.h>
-#include <getopt.h>
-#include <ctype.h>
-#include <iptables.h>
-#include <linux/netfilter/nf_conntrack_common.h>
-/* For 64bit kernel / 32bit userspace */
-#include "../include/linux/netfilter_ipv4/ipt_conntrack.h"
-
-#ifndef IPT_CONNTRACK_STATE_UNTRACKED
-#define IPT_CONNTRACK_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 3))
-#endif
-
-/* Function which prints out usage message. */
-static void conntrack_help(void)
-{
-	printf(
-"conntrack match v%s options:\n"
-" [!] --ctstate [INVALID|ESTABLISHED|NEW|RELATED|UNTRACKED|SNAT|DNAT][,...]\n"
-"				State(s) to match\n"
-" [!] --ctproto	proto		Protocol to match; by number or name, eg. `tcp'\n"
-"     --ctorigsrc  [!] address[/mask]\n"
-"				Original source specification\n"
-"     --ctorigdst  [!] address[/mask]\n"
-"				Original destination specification\n"
-"     --ctreplsrc  [!] address[/mask]\n"
-"				Reply source specification\n"
-"     --ctrepldst  [!] address[/mask]\n"
-"				Reply destination specification\n"
-" [!] --ctstatus [NONE|EXPECTED|SEEN_REPLY|ASSURED|CONFIRMED][,...]\n"
-"				Status(es) to match\n"
-" [!] --ctexpire time[:time]	Match remaining lifetime in seconds against\n"
-"				value or range of values (inclusive)\n"
-"\n", IPTABLES_VERSION);
-}
-
-static const struct option conntrack_opts[] = {
-	{ "ctstate", 1, NULL, '1' },
-	{ "ctproto", 1, NULL, '2' },
-	{ "ctorigsrc", 1, NULL, '3' },
-	{ "ctorigdst", 1, NULL, '4' },
-	{ "ctreplsrc", 1, NULL, '5' },
-	{ "ctrepldst", 1, NULL, '6' },
-	{ "ctstatus", 1, NULL, '7' },
-	{ "ctexpire", 1, NULL, '8' },
-	{ }
-};
-
-static int
-parse_state(const char *state, size_t strlen, struct ipt_conntrack_info *sinfo)
-{
-	if (strncasecmp(state, "INVALID", strlen) == 0)
-		sinfo->statemask |= IPT_CONNTRACK_STATE_INVALID;
-	else if (strncasecmp(state, "NEW", strlen) == 0)
-		sinfo->statemask |= IPT_CONNTRACK_STATE_BIT(IP_CT_NEW);
-	else if (strncasecmp(state, "ESTABLISHED", strlen) == 0)
-		sinfo->statemask |= IPT_CONNTRACK_STATE_BIT(IP_CT_ESTABLISHED);
-	else if (strncasecmp(state, "RELATED", strlen) == 0)
-		sinfo->statemask |= IPT_CONNTRACK_STATE_BIT(IP_CT_RELATED);
-	else if (strncasecmp(state, "UNTRACKED", strlen) == 0)
-		sinfo->statemask |= IPT_CONNTRACK_STATE_UNTRACKED;
-	else if (strncasecmp(state, "SNAT", strlen) == 0)
-		sinfo->statemask |= IPT_CONNTRACK_STATE_SNAT;
-	else if (strncasecmp(state, "DNAT", strlen) == 0)
-		sinfo->statemask |= IPT_CONNTRACK_STATE_DNAT;
-	else
-		return 0;
-	return 1;
-}
-
-static void
-parse_states(const char *arg, struct ipt_conntrack_info *sinfo)
-{
-	const char *comma;
-
-	while ((comma = strchr(arg, ',')) != NULL) {
-		if (comma == arg || !parse_state(arg, comma-arg, sinfo))
-			exit_error(PARAMETER_PROBLEM, "Bad ctstate `%s'", arg);
-		arg = comma+1;
-	}
-
-	if (strlen(arg) == 0 || !parse_state(arg, strlen(arg), sinfo))
-		exit_error(PARAMETER_PROBLEM, "Bad ctstate `%s'", arg);
-}
-
-static int
-parse_status(const char *status, size_t strlen, struct ipt_conntrack_info *sinfo)
-{
-	if (strncasecmp(status, "NONE", strlen) == 0)
-		sinfo->statusmask |= 0;
-	else if (strncasecmp(status, "EXPECTED", strlen) == 0)
-		sinfo->statusmask |= IPS_EXPECTED;
-	else if (strncasecmp(status, "SEEN_REPLY", strlen) == 0)
-		sinfo->statusmask |= IPS_SEEN_REPLY;
-	else if (strncasecmp(status, "ASSURED", strlen) == 0)
-		sinfo->statusmask |= IPS_ASSURED;
-#ifdef IPS_CONFIRMED
-	else if (strncasecmp(status, "CONFIRMED", strlen) == 0)
-		sinfo->stausmask |= IPS_CONFIRMED;
-#endif
-	else
-		return 0;
-	return 1;
-}
-
-static void
-parse_statuses(const char *arg, struct ipt_conntrack_info *sinfo)
-{
-	const char *comma;
-
-	while ((comma = strchr(arg, ',')) != NULL) {
-		if (comma == arg || !parse_status(arg, comma-arg, sinfo))
-			exit_error(PARAMETER_PROBLEM, "Bad ctstatus `%s'", arg);
-		arg = comma+1;
-	}
-
-	if (strlen(arg) == 0 || !parse_status(arg, strlen(arg), sinfo))
-		exit_error(PARAMETER_PROBLEM, "Bad ctstatus `%s'", arg);
-}
-
-static unsigned long
-parse_expire(const char *s)
-{
-	unsigned int len;
-	
-	if (string_to_number(s, 0, 0, &len) == -1)
-		exit_error(PARAMETER_PROBLEM, "expire value invalid: `%s'\n", s);
-	else
-		return len;
-}
-
-/* If a single value is provided, min and max are both set to the value */
-static void
-parse_expires(const char *s, struct ipt_conntrack_info *sinfo)
-{
-	char *buffer;
-	char *cp;
-
-	buffer = strdup(s);
-	if ((cp = strchr(buffer, ':')) == NULL)
-		sinfo->expires_min = sinfo->expires_max = parse_expire(buffer);
-	else {
-		*cp = '\0';
-		cp++;
-
-		sinfo->expires_min = buffer[0] ? parse_expire(buffer) : 0;
-		sinfo->expires_max = cp[0] ? parse_expire(cp) : -1;
-	}
-	free(buffer);
-	
-	if (sinfo->expires_min > sinfo->expires_max)
-		exit_error(PARAMETER_PROBLEM,
-		           "expire min. range value `%lu' greater than max. "
-		           "range value `%lu'", sinfo->expires_min, sinfo->expires_max);
-}
-
-/* Function which parses command options; returns true if it
-   ate an option */
-static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
-                           const void *entry, struct xt_entry_match **match)
-{
-	struct ipt_conntrack_info *sinfo = (struct ipt_conntrack_info *)(*match)->data;
-	char *protocol = NULL;
-	unsigned int naddrs = 0;
-	struct in_addr *addrs = NULL;
-
-
-	switch (c) {
-	case '1':
-		check_inverse(optarg, &invert, &optind, 0);
-
-		parse_states(argv[optind-1], sinfo);
-		if (invert) {
-			sinfo->invflags |= IPT_CONNTRACK_STATE;
-		}
-		sinfo->flags |= IPT_CONNTRACK_STATE;
-		break;
-
-	case '2':
-		check_inverse(optarg, &invert, &optind, 0);
-
-		if(invert)
-			sinfo->invflags |= IPT_CONNTRACK_PROTO;
-
-		/* Canonicalize into lower case */
-		for (protocol = argv[optind-1]; *protocol; protocol++)
-			*protocol = tolower(*protocol);
-
-		protocol = argv[optind-1];
-		sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum = parse_protocol(protocol);
-
-		if (sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum == 0
-		    && (sinfo->invflags & IPT_INV_PROTO))
-			exit_error(PARAMETER_PROBLEM,
-				   "rule would never match protocol");
-
-		sinfo->flags |= IPT_CONNTRACK_PROTO;
-		break;
-
-	case '3':
-		check_inverse(optarg, &invert, &optind, 0);
-
-		if (invert)
-			sinfo->invflags |= IPT_CONNTRACK_ORIGSRC;
-
-		parse_hostnetworkmask(argv[optind-1], &addrs,
-					&sinfo->sipmsk[IP_CT_DIR_ORIGINAL],
-					&naddrs);
-		if(naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
-				"multiple IP addresses not allowed");
-
-		if(naddrs == 1) {
-			sinfo->tuple[IP_CT_DIR_ORIGINAL].src.ip = addrs[0].s_addr;
-		}
-
-		sinfo->flags |= IPT_CONNTRACK_ORIGSRC;
-		break;
-
-	case '4':
-		check_inverse(optarg, &invert, &optind, 0);
-
-		if (invert)
-			sinfo->invflags |= IPT_CONNTRACK_ORIGDST;
-
-		parse_hostnetworkmask(argv[optind-1], &addrs,
-					&sinfo->dipmsk[IP_CT_DIR_ORIGINAL],
-					&naddrs);
-		if(naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
-				"multiple IP addresses not allowed");
-
-		if(naddrs == 1) {
-			sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.ip = addrs[0].s_addr;
-		}
-
-		sinfo->flags |= IPT_CONNTRACK_ORIGDST;
-		break;
-
-	case '5':
-		check_inverse(optarg, &invert, &optind, 0);
-
-		if (invert)
-			sinfo->invflags |= IPT_CONNTRACK_REPLSRC;
-
-		parse_hostnetworkmask(argv[optind-1], &addrs,
-					&sinfo->sipmsk[IP_CT_DIR_REPLY],
-					&naddrs);
-		if(naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
-				"multiple IP addresses not allowed");
-
-		if(naddrs == 1) {
-			sinfo->tuple[IP_CT_DIR_REPLY].src.ip = addrs[0].s_addr;
-		}
-
-		sinfo->flags |= IPT_CONNTRACK_REPLSRC;
-		break;
-
-	case '6':
-		check_inverse(optarg, &invert, &optind, 0);
-
-		if (invert)
-			sinfo->invflags |= IPT_CONNTRACK_REPLDST;
-
-		parse_hostnetworkmask(argv[optind-1], &addrs,
-					&sinfo->dipmsk[IP_CT_DIR_REPLY],
-					&naddrs);
-		if(naddrs > 1)
-			exit_error(PARAMETER_PROBLEM,
-				"multiple IP addresses not allowed");
-
-		if(naddrs == 1) {
-			sinfo->tuple[IP_CT_DIR_REPLY].dst.ip = addrs[0].s_addr;
-		}
-
-		sinfo->flags |= IPT_CONNTRACK_REPLDST;
-		break;
-
-	case '7':
-		check_inverse(optarg, &invert, &optind, 0);
-
-		parse_statuses(argv[optind-1], sinfo);
-		if (invert) {
-			sinfo->invflags |= IPT_CONNTRACK_STATUS;
-		}
-		sinfo->flags |= IPT_CONNTRACK_STATUS;
-		break;
-
-	case '8':
-		check_inverse(optarg, &invert, &optind, 0);
-
-		parse_expires(argv[optind-1], sinfo);
-		if (invert) {
-			sinfo->invflags |= IPT_CONNTRACK_EXPIRES;
-		}
-		sinfo->flags |= IPT_CONNTRACK_EXPIRES;
-		break;
-
-	default:
-		return 0;
-	}
-
-	*flags = sinfo->flags;
-	return 1;
-}
-
-static void conntrack_check(unsigned int flags)
-{
-	if (!flags)
-		exit_error(PARAMETER_PROBLEM, "You must specify one or more options");
-}
-
-static void
-print_state(unsigned int statemask)
-{
-	const char *sep = "";
-
-	if (statemask & IPT_CONNTRACK_STATE_INVALID) {
-		printf("%sINVALID", sep);
-		sep = ",";
-	}
-	if (statemask & IPT_CONNTRACK_STATE_BIT(IP_CT_NEW)) {
-		printf("%sNEW", sep);
-		sep = ",";
-	}
-	if (statemask & IPT_CONNTRACK_STATE_BIT(IP_CT_RELATED)) {
-		printf("%sRELATED", sep);
-		sep = ",";
-	}
-	if (statemask & IPT_CONNTRACK_STATE_BIT(IP_CT_ESTABLISHED)) {
-		printf("%sESTABLISHED", sep);
-		sep = ",";
-	}
-	if (statemask & IPT_CONNTRACK_STATE_UNTRACKED) {
-		printf("%sUNTRACKED", sep);
-		sep = ",";
-	}
-	if (statemask & IPT_CONNTRACK_STATE_SNAT) {
-		printf("%sSNAT", sep);
-		sep = ",";
-	}
-	if (statemask & IPT_CONNTRACK_STATE_DNAT) {
-		printf("%sDNAT", sep);
-		sep = ",";
-	}
-	printf(" ");
-}
-
-static void
-print_status(unsigned int statusmask)
-{
-	const char *sep = "";
-
-	if (statusmask & IPS_EXPECTED) {
-		printf("%sEXPECTED", sep);
-		sep = ",";
-	}
-	if (statusmask & IPS_SEEN_REPLY) {
-		printf("%sSEEN_REPLY", sep);
-		sep = ",";
-	}
-	if (statusmask & IPS_ASSURED) {
-		printf("%sASSURED", sep);
-		sep = ",";
-	}
-#ifdef IPS_CONFIRMED
-	if (statusmask & IPS_CONFIRMED) {
-		printf("%sCONFIRMED", sep);
-		sep =",";
-	}
-#endif
-	if (statusmask == 0) {
-		printf("%sNONE", sep);
-		sep = ",";
-	}
-	printf(" ");
-}
-
-static void
-print_addr(struct in_addr *addr, struct in_addr *mask, int inv, int numeric)
-{
-	char buf[BUFSIZ];
-
-        if (inv) 
-               	printf("! ");
-
-	if (mask->s_addr == 0L && !numeric)
-		printf("%s ", "anywhere");
-	else {
-		if (numeric)
-			sprintf(buf, "%s", addr_to_dotted(addr));
-		else
-			sprintf(buf, "%s", addr_to_anyname(addr));
-		strcat(buf, mask_to_dotted(mask));
-		printf("%s ", buf);
-	}
-}
-
-/* Saves the matchinfo in parsable form to stdout. */
-static void
-matchinfo_print(const void *ip, const struct xt_entry_match *match, int numeric, const char *optpfx)
-{
-	struct ipt_conntrack_info *sinfo = (struct ipt_conntrack_info *)match->data;
-
-	if(sinfo->flags & IPT_CONNTRACK_STATE) {
-		printf("%sctstate ", optpfx);
-        	if (sinfo->invflags & IPT_CONNTRACK_STATE)
-                	printf("! ");
-		print_state(sinfo->statemask);
-	}
-
-	if(sinfo->flags & IPT_CONNTRACK_PROTO) {
-		printf("%sctproto ", optpfx);
-        	if (sinfo->invflags & IPT_CONNTRACK_PROTO)
-                	printf("! ");
-		printf("%u ", sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum);
-	}
-
-	if(sinfo->flags & IPT_CONNTRACK_ORIGSRC) {
-		printf("%sctorigsrc ", optpfx);
-
-		print_addr(
-		    (struct in_addr *)&sinfo->tuple[IP_CT_DIR_ORIGINAL].src.ip,
-		    &sinfo->sipmsk[IP_CT_DIR_ORIGINAL],
-		    sinfo->invflags & IPT_CONNTRACK_ORIGSRC,
-		    numeric);
-	}
-
-	if(sinfo->flags & IPT_CONNTRACK_ORIGDST) {
-		printf("%sctorigdst ", optpfx);
-
-		print_addr(
-		    (struct in_addr *)&sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.ip,
-		    &sinfo->dipmsk[IP_CT_DIR_ORIGINAL],
-		    sinfo->invflags & IPT_CONNTRACK_ORIGDST,
-		    numeric);
-	}
-
-	if(sinfo->flags & IPT_CONNTRACK_REPLSRC) {
-		printf("%sctreplsrc ", optpfx);
-
-		print_addr(
-		    (struct in_addr *)&sinfo->tuple[IP_CT_DIR_REPLY].src.ip,
-		    &sinfo->sipmsk[IP_CT_DIR_REPLY],
-		    sinfo->invflags & IPT_CONNTRACK_REPLSRC,
-		    numeric);
-	}
-
-	if(sinfo->flags & IPT_CONNTRACK_REPLDST) {
-		printf("%sctrepldst ", optpfx);
-
-		print_addr(
-		    (struct in_addr *)&sinfo->tuple[IP_CT_DIR_REPLY].dst.ip,
-		    &sinfo->dipmsk[IP_CT_DIR_REPLY],
-		    sinfo->invflags & IPT_CONNTRACK_REPLDST,
-		    numeric);
-	}
-
-	if(sinfo->flags & IPT_CONNTRACK_STATUS) {
-		printf("%sctstatus ", optpfx);
-        	if (sinfo->invflags & IPT_CONNTRACK_STATUS)
-                	printf("! ");
-		print_status(sinfo->statusmask);
-	}
-
-	if(sinfo->flags & IPT_CONNTRACK_EXPIRES) {
-		printf("%sctexpire ", optpfx);
-        	if (sinfo->invflags & IPT_CONNTRACK_EXPIRES)
-                	printf("! ");
-
-        	if (sinfo->expires_max == sinfo->expires_min)
-                	printf("%lu ", sinfo->expires_min);
-        	else
-                	printf("%lu:%lu ", sinfo->expires_min, sinfo->expires_max);
-	}
-}
-
-/* Prints out the matchinfo. */
-static void conntrack_print(const void *ip, const struct xt_entry_match *match,
-                            int numeric)
-{
-	matchinfo_print(ip, match, numeric, "");
-}
-
-/* Saves the matchinfo in parsable form to stdout. */
-static void conntrack_save(const void *ip, const struct xt_entry_match *match)
-{
-	matchinfo_print(ip, match, 1, "--");
-}
-
-static struct iptables_match conntrack_match = {
-	.name		= "conntrack",
-	.version	= IPTABLES_VERSION,
-	.size		= IPT_ALIGN(sizeof(struct ipt_conntrack_info)),
-	.userspacesize	= IPT_ALIGN(sizeof(struct ipt_conntrack_info)),
-	.help		= conntrack_help,
-	.parse		= conntrack_parse,
-	.final_check	= conntrack_check,
-	.print		= conntrack_print,
-	.save		= conntrack_save,
-	.extra_opts	= conntrack_opts,
-};
-
-void _init(void)
-{
-	register_match(&conntrack_match);
-}
Index: iptables-modules/extensions/libipt_conntrack.man
===================================================================
--- iptables-modules.orig/extensions/libipt_conntrack.man
+++ /dev/null
@@ -1,49 +0,0 @@
-This module, when combined with connection tracking, allows access to
-more connection tracking information than the "state" match.
-(this module is present only if iptables was compiled under a kernel
-supporting this feature)
-.TP
-.BI "--ctstate " "state"
-Where state is a comma separated list of the connection states to
-match.  Possible states are
-.B INVALID
-meaning that the packet is associated with no known connection,
-.B ESTABLISHED
-meaning that the packet is associated with a connection which has seen
-packets in both directions,
-.B NEW
-meaning that the packet has started a new connection, or otherwise
-associated with a connection which has not seen packets in both
-directions, and
-.B RELATED
-meaning that the packet is starting a new connection, but is
-associated with an existing connection, such as an FTP data transfer,
-or an ICMP error.
-.B SNAT
-A virtual state, matching if the original source address differs from
-the reply destination.
-.B DNAT
-A virtual state, matching if the original destination differs from the
-reply source.
-.TP
-.BI "--ctproto " "proto"
-Protocol to match (by number or name)
-.TP
-.BI "--ctorigsrc " "[!] \fIaddress\fP[/\fImask\fP]"
-Match against original source address
-.TP
-.BI "--ctorigdst " "[!] \fIaddress\fP[/\fImask\fP]"
-Match against original destination address
-.TP
-.BI "--ctreplsrc " "[!] \fIaddress\fP[/\fImask\fP]"
-Match against reply source address
-.TP
-.BI "--ctrepldst " "[!] \fIaddress\fB[/\fImask\fP]"
-Match against reply destination address
-.TP
-.BI "--ctstatus " "[\fINONE|EXPECTED|SEEN_REPLY|ASSURED\fP][,...]"
-Match against internal conntrack states
-.TP
-.BI "--ctexpire " "\fItime\fP[\fI:time\fP]"
-Match remaining lifetime in seconds against given value
-or range of values (inclusive)
Index: iptables-modules/extensions/libxt_conntrack.c
===================================================================
--- /dev/null
+++ iptables-modules/extensions/libxt_conntrack.c
@@ -0,0 +1,517 @@
+/* Shared library add-on to iptables for conntrack matching support.
+ * GPL (C) 2001  Marc Boucher (marc@mbsi.ca).
+ */
+
+#include <ctype.h>
+#include <getopt.h>
+#include <netdb.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <iptables.h>
+#include <linux/netfilter.h>
+#include <linux/netfilter/xt_conntrack.h>
+#include <linux/netfilter/nf_conntrack_common.h>
+
+/* Function which prints out usage message. */
+static void conntrack_mt_help(void)
+{
+	printf(
+"conntrack match options:\n"
+"[!] --ctstate {INVALID|ESTABLISHED|NEW|RELATED|UNTRACKED|SNAT|DNAT}[,...]\n"
+"                               State(s) to match\n"
+"[!] --ctproto proto            Protocol to match; by number or name, e.g. \"tcp\"\n"
+"[!] --ctorigsrc address[/mask]\n"
+"[!] --ctorigdst address[/mask]\n"
+"[!] --ctreplsrc address[/mask]\n"
+"[!] --ctrepldst address[/mask]\n"
+"                               Original/Reply source/destination address\n"
+"[!] --ctstatus {NONE|EXPECTED|SEEN_REPLY|ASSURED|CONFIRMED}[,...]\n"
+"                               Status(es) to match\n"
+"[!] --ctexpire time[:time]     Match remaining lifetime in seconds against\n"
+"                               value or range of values (inclusive)\n"
+"\n");
+}
+
+static const struct option conntrack_mt_opts[] = {
+	{.name = "ctstate",   .has_arg = true, .val = '1'},
+	{.name = "ctproto",   .has_arg = true, .val = '2'},
+	{.name = "ctorigsrc", .has_arg = true, .val = '3'},
+	{.name = "ctorigdst", .has_arg = true, .val = '4'},
+	{.name = "ctreplsrc", .has_arg = true, .val = '5'},
+	{.name = "ctrepldst", .has_arg = true, .val = '6'},
+	{.name = "ctstatus",  .has_arg = true, .val = '7'},
+	{.name = "ctexpire",  .has_arg = true, .val = '8'},
+	{},
+};
+
+static int
+parse_state(const char *state, size_t strlen, struct xt_conntrack_info *sinfo)
+{
+	if (strncasecmp(state, "INVALID", strlen) == 0)
+		sinfo->statemask |= XT_CONNTRACK_STATE_INVALID;
+	else if (strncasecmp(state, "NEW", strlen) == 0)
+		sinfo->statemask |= XT_CONNTRACK_STATE_BIT(IP_CT_NEW);
+	else if (strncasecmp(state, "ESTABLISHED", strlen) == 0)
+		sinfo->statemask |= XT_CONNTRACK_STATE_BIT(IP_CT_ESTABLISHED);
+	else if (strncasecmp(state, "RELATED", strlen) == 0)
+		sinfo->statemask |= XT_CONNTRACK_STATE_BIT(IP_CT_RELATED);
+	else if (strncasecmp(state, "UNTRACKED", strlen) == 0)
+		sinfo->statemask |= XT_CONNTRACK_STATE_UNTRACKED;
+	else if (strncasecmp(state, "SNAT", strlen) == 0)
+		sinfo->statemask |= XT_CONNTRACK_STATE_SNAT;
+	else if (strncasecmp(state, "DNAT", strlen) == 0)
+		sinfo->statemask |= XT_CONNTRACK_STATE_DNAT;
+	else
+		return 0;
+	return 1;
+}
+
+static void
+parse_states(const char *arg, struct xt_conntrack_info *sinfo)
+{
+	const char *comma;
+
+	while ((comma = strchr(arg, ',')) != NULL) {
+		if (comma == arg || !parse_state(arg, comma-arg, sinfo))
+			exit_error(PARAMETER_PROBLEM, "Bad ctstate `%s'", arg);
+		arg = comma+1;
+	}
+
+	if (strlen(arg) == 0 || !parse_state(arg, strlen(arg), sinfo))
+		exit_error(PARAMETER_PROBLEM, "Bad ctstate `%s'", arg);
+}
+
+static int
+parse_status(const char *status, size_t strlen, struct xt_conntrack_info *sinfo)
+{
+	if (strncasecmp(status, "NONE", strlen) == 0)
+		sinfo->statusmask |= 0;
+	else if (strncasecmp(status, "EXPECTED", strlen) == 0)
+		sinfo->statusmask |= IPS_EXPECTED;
+	else if (strncasecmp(status, "SEEN_REPLY", strlen) == 0)
+		sinfo->statusmask |= IPS_SEEN_REPLY;
+	else if (strncasecmp(status, "ASSURED", strlen) == 0)
+		sinfo->statusmask |= IPS_ASSURED;
+#ifdef IPS_CONFIRMED
+	else if (strncasecmp(status, "CONFIRMED", strlen) == 0)
+		sinfo->stausmask |= IPS_CONFIRMED;
+#endif
+	else
+		return 0;
+	return 1;
+}
+
+static void
+parse_statuses(const char *arg, struct xt_conntrack_info *sinfo)
+{
+	const char *comma;
+
+	while ((comma = strchr(arg, ',')) != NULL) {
+		if (comma == arg || !parse_status(arg, comma-arg, sinfo))
+			exit_error(PARAMETER_PROBLEM, "Bad ctstatus `%s'", arg);
+		arg = comma+1;
+	}
+
+	if (strlen(arg) == 0 || !parse_status(arg, strlen(arg), sinfo))
+		exit_error(PARAMETER_PROBLEM, "Bad ctstatus `%s'", arg);
+}
+
+static unsigned long
+parse_expire(const char *s)
+{
+	unsigned int len;
+
+	if (string_to_number(s, 0, 0, &len) == -1)
+		exit_error(PARAMETER_PROBLEM, "expire value invalid: `%s'\n", s);
+	else
+		return len;
+}
+
+/* If a single value is provided, min and max are both set to the value */
+static void
+parse_expires(const char *s, struct xt_conntrack_info *sinfo)
+{
+	char *buffer;
+	char *cp;
+
+	buffer = strdup(s);
+	if ((cp = strchr(buffer, ':')) == NULL)
+		sinfo->expires_min = sinfo->expires_max = parse_expire(buffer);
+	else {
+		*cp = '\0';
+		cp++;
+
+		sinfo->expires_min = buffer[0] ? parse_expire(buffer) : 0;
+		sinfo->expires_max = cp[0] ? parse_expire(cp) : -1;
+	}
+	free(buffer);
+
+	if (sinfo->expires_min > sinfo->expires_max)
+		exit_error(PARAMETER_PROBLEM,
+		           "expire min. range value `%lu' greater than max. "
+		           "range value `%lu'", sinfo->expires_min, sinfo->expires_max);
+}
+
+/* Function which parses command options; returns true if it
+   ate an option */
+static int conntrack_parse(int c, char **argv, int invert, unsigned int *flags,
+                           const void *entry, struct xt_entry_match **match)
+{
+	struct xt_conntrack_info *sinfo = (void *)(*match)->data;
+	char *protocol = NULL;
+	unsigned int naddrs = 0;
+	struct in_addr *addrs = NULL;
+
+
+	switch (c) {
+	case '1':
+		check_inverse(optarg, &invert, &optind, 0);
+
+		parse_states(argv[optind-1], sinfo);
+		if (invert) {
+			sinfo->invflags |= XT_CONNTRACK_STATE;
+		}
+		sinfo->flags |= XT_CONNTRACK_STATE;
+		break;
+
+	case '2':
+		check_inverse(optarg, &invert, &optind, 0);
+
+		if(invert)
+			sinfo->invflags |= XT_CONNTRACK_PROTO;
+
+		/* Canonicalize into lower case */
+		for (protocol = argv[optind-1]; *protocol; protocol++)
+			*protocol = tolower(*protocol);
+
+		protocol = argv[optind-1];
+		sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum = parse_protocol(protocol);
+
+		if (sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum == 0
+		    && (sinfo->invflags & XT_INV_PROTO))
+			exit_error(PARAMETER_PROBLEM,
+				   "rule would never match protocol");
+
+		sinfo->flags |= XT_CONNTRACK_PROTO;
+		break;
+
+	case '3':
+		check_inverse(optarg, &invert, &optind, 0);
+
+		if (invert)
+			sinfo->invflags |= XT_CONNTRACK_ORIGSRC;
+
+		parse_hostnetworkmask(argv[optind-1], &addrs,
+					&sinfo->sipmsk[IP_CT_DIR_ORIGINAL],
+					&naddrs);
+		if(naddrs > 1)
+			exit_error(PARAMETER_PROBLEM,
+				"multiple IP addresses not allowed");
+
+		if(naddrs == 1) {
+			sinfo->tuple[IP_CT_DIR_ORIGINAL].src.ip = addrs[0].s_addr;
+		}
+
+		sinfo->flags |= XT_CONNTRACK_ORIGSRC;
+		break;
+
+	case '4':
+		check_inverse(optarg, &invert, &optind, 0);
+
+		if (invert)
+			sinfo->invflags |= XT_CONNTRACK_ORIGDST;
+
+		parse_hostnetworkmask(argv[optind-1], &addrs,
+					&sinfo->dipmsk[IP_CT_DIR_ORIGINAL],
+					&naddrs);
+		if(naddrs > 1)
+			exit_error(PARAMETER_PROBLEM,
+				"multiple IP addresses not allowed");
+
+		if(naddrs == 1) {
+			sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.ip = addrs[0].s_addr;
+		}
+
+		sinfo->flags |= XT_CONNTRACK_ORIGDST;
+		break;
+
+	case '5':
+		check_inverse(optarg, &invert, &optind, 0);
+
+		if (invert)
+			sinfo->invflags |= XT_CONNTRACK_REPLSRC;
+
+		parse_hostnetworkmask(argv[optind-1], &addrs,
+					&sinfo->sipmsk[IP_CT_DIR_REPLY],
+					&naddrs);
+		if(naddrs > 1)
+			exit_error(PARAMETER_PROBLEM,
+				"multiple IP addresses not allowed");
+
+		if(naddrs == 1) {
+			sinfo->tuple[IP_CT_DIR_REPLY].src.ip = addrs[0].s_addr;
+		}
+
+		sinfo->flags |= XT_CONNTRACK_REPLSRC;
+		break;
+
+	case '6':
+		check_inverse(optarg, &invert, &optind, 0);
+
+		if (invert)
+			sinfo->invflags |= XT_CONNTRACK_REPLDST;
+
+		parse_hostnetworkmask(argv[optind-1], &addrs,
+					&sinfo->dipmsk[IP_CT_DIR_REPLY],
+					&naddrs);
+		if(naddrs > 1)
+			exit_error(PARAMETER_PROBLEM,
+				"multiple IP addresses not allowed");
+
+		if(naddrs == 1) {
+			sinfo->tuple[IP_CT_DIR_REPLY].dst.ip = addrs[0].s_addr;
+		}
+
+		sinfo->flags |= XT_CONNTRACK_REPLDST;
+		break;
+
+	case '7':
+		check_inverse(optarg, &invert, &optind, 0);
+
+		parse_statuses(argv[optind-1], sinfo);
+		if (invert) {
+			sinfo->invflags |= XT_CONNTRACK_STATUS;
+		}
+		sinfo->flags |= XT_CONNTRACK_STATUS;
+		break;
+
+	case '8':
+		check_inverse(optarg, &invert, &optind, 0);
+
+		parse_expires(argv[optind-1], sinfo);
+		if (invert) {
+			sinfo->invflags |= XT_CONNTRACK_EXPIRES;
+		}
+		sinfo->flags |= XT_CONNTRACK_EXPIRES;
+		break;
+
+	default:
+		return 0;
+	}
+
+	*flags = sinfo->flags;
+	return 1;
+}
+
+static void conntrack_mt_check(unsigned int flags)
+{
+	if (flags == 0)
+		exit_error(PARAMETER_PROBLEM, "You must specify one or more options");
+}
+
+static void
+print_state(unsigned int statemask)
+{
+	const char *sep = "";
+
+	if (statemask & XT_CONNTRACK_STATE_INVALID) {
+		printf("%sINVALID", sep);
+		sep = ",";
+	}
+	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_NEW)) {
+		printf("%sNEW", sep);
+		sep = ",";
+	}
+	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_RELATED)) {
+		printf("%sRELATED", sep);
+		sep = ",";
+	}
+	if (statemask & XT_CONNTRACK_STATE_BIT(IP_CT_ESTABLISHED)) {
+		printf("%sESTABLISHED", sep);
+		sep = ",";
+	}
+	if (statemask & XT_CONNTRACK_STATE_UNTRACKED) {
+		printf("%sUNTRACKED", sep);
+		sep = ",";
+	}
+	if (statemask & XT_CONNTRACK_STATE_SNAT) {
+		printf("%sSNAT", sep);
+		sep = ",";
+	}
+	if (statemask & XT_CONNTRACK_STATE_DNAT) {
+		printf("%sDNAT", sep);
+		sep = ",";
+	}
+	printf(" ");
+}
+
+static void
+print_status(unsigned int statusmask)
+{
+	const char *sep = "";
+
+	if (statusmask & IPS_EXPECTED) {
+		printf("%sEXPECTED", sep);
+		sep = ",";
+	}
+	if (statusmask & IPS_SEEN_REPLY) {
+		printf("%sSEEN_REPLY", sep);
+		sep = ",";
+	}
+	if (statusmask & IPS_ASSURED) {
+		printf("%sASSURED", sep);
+		sep = ",";
+	}
+#ifdef IPS_CONFIRMED
+	if (statusmask & IPS_CONFIRMED) {
+		printf("%sCONFIRMED", sep);
+		sep =",";
+	}
+#endif
+	if (statusmask == 0) {
+		printf("%sNONE", sep);
+		sep = ",";
+	}
+	printf(" ");
+}
+
+static void
+print_addr(struct in_addr *addr, struct in_addr *mask, int inv, int numeric)
+{
+	char buf[BUFSIZ];
+
+	if (inv)
+	       	printf("! ");
+
+	if (mask->s_addr == 0L && !numeric)
+		printf("%s ", "anywhere");
+	else {
+		if (numeric)
+			sprintf(buf, "%s", addr_to_dotted(addr));
+		else
+			sprintf(buf, "%s", addr_to_anyname(addr));
+		strcat(buf, mask_to_dotted(mask));
+		printf("%s ", buf);
+	}
+}
+
+/* Saves the matchinfo in parsable form to stdout. */
+static void
+matchinfo_print(const void *ip, const struct xt_entry_match *match, int numeric, const char *optpfx)
+{
+	struct xt_conntrack_info *sinfo = (void *)match->data;
+
+	if(sinfo->flags & XT_CONNTRACK_STATE) {
+        	if (sinfo->invflags & XT_CONNTRACK_STATE)
+                	printf("! ");
+		printf("%sctstate ", optpfx);
+		print_state(sinfo->statemask);
+	}
+
+	if(sinfo->flags & XT_CONNTRACK_PROTO) {
+        	if (sinfo->invflags & XT_CONNTRACK_PROTO)
+                	printf("! ");
+		printf("%sctproto ", optpfx);
+		printf("%u ", sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.protonum);
+	}
+
+	if(sinfo->flags & XT_CONNTRACK_ORIGSRC) {
+		if (sinfo->invflags & XT_CONNTRACK_ORIGSRC)
+			printf("! ");
+		printf("%sctorigsrc ", optpfx);
+
+		print_addr(
+		    (struct in_addr *)&sinfo->tuple[IP_CT_DIR_ORIGINAL].src.ip,
+		    &sinfo->sipmsk[IP_CT_DIR_ORIGINAL],
+		    false,
+		    numeric);
+	}
+
+	if(sinfo->flags & XT_CONNTRACK_ORIGDST) {
+		if (sinfo->invflags & XT_CONNTRACK_ORIGDST)
+			printf("! ");
+		printf("%sctorigdst ", optpfx);
+
+		print_addr(
+		    (struct in_addr *)&sinfo->tuple[IP_CT_DIR_ORIGINAL].dst.ip,
+		    &sinfo->dipmsk[IP_CT_DIR_ORIGINAL],
+		    false,
+		    numeric);
+	}
+
+	if(sinfo->flags & XT_CONNTRACK_REPLSRC) {
+		if (sinfo->invflags & XT_CONNTRACK_REPLSRC)
+			printf("! ");
+		printf("%sctreplsrc ", optpfx);
+
+		print_addr(
+		    (struct in_addr *)&sinfo->tuple[IP_CT_DIR_REPLY].src.ip,
+		    &sinfo->sipmsk[IP_CT_DIR_REPLY],
+		    false,
+		    numeric);
+	}
+
+	if(sinfo->flags & XT_CONNTRACK_REPLDST) {
+		if (sinfo->invflags & XT_CONNTRACK_REPLDST)
+			printf("! ");
+		printf("%sctrepldst ", optpfx);
+
+		print_addr(
+		    (struct in_addr *)&sinfo->tuple[IP_CT_DIR_REPLY].dst.ip,
+		    &sinfo->dipmsk[IP_CT_DIR_REPLY],
+		    false,
+		    numeric);
+	}
+
+	if(sinfo->flags & XT_CONNTRACK_STATUS) {
+        	if (sinfo->invflags & XT_CONNTRACK_STATUS)
+                	printf("! ");
+		printf("%sctstatus ", optpfx);
+		print_status(sinfo->statusmask);
+	}
+
+	if(sinfo->flags & XT_CONNTRACK_EXPIRES) {
+        	if (sinfo->invflags & XT_CONNTRACK_EXPIRES)
+                	printf("! ");
+		printf("%sctexpire ", optpfx);
+
+        	if (sinfo->expires_max == sinfo->expires_min)
+                	printf("%lu ", sinfo->expires_min);
+        	else
+                	printf("%lu:%lu ", sinfo->expires_min, sinfo->expires_max);
+	}
+}
+
+/* Prints out the matchinfo. */
+static void conntrack_print(const void *ip, const struct xt_entry_match *match,
+                            int numeric)
+{
+	matchinfo_print(ip, match, numeric, "");
+}
+
+/* Saves the matchinfo in parsable form to stdout. */
+static void conntrack_save(const void *ip, const struct xt_entry_match *match)
+{
+	matchinfo_print(ip, match, 1, "--");
+}
+
+static struct xtables_match conntrack_match = {
+	.version       = IPTABLES_VERSION,
+	.name          = "conntrack",
+	.revision      = 0,
+	.family        = AF_INET,
+	.size          = XT_ALIGN(sizeof(struct xt_conntrack_info)),
+	.userspacesize = XT_ALIGN(sizeof(struct xt_conntrack_info)),
+	.help          = conntrack_mt_help,
+	.parse         = conntrack_parse,
+	.final_check   = conntrack_mt_check,
+	.print         = conntrack_print,
+	.save          = conntrack_save,
+	.extra_opts    = conntrack_mt_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&conntrack_match);
+}
Index: iptables-modules/extensions/libxt_conntrack.man
===================================================================
--- /dev/null
+++ iptables-modules/extensions/libxt_conntrack.man
@@ -0,0 +1,71 @@
+This module, when combined with connection tracking, allows access to the
+connection tracking state for this packet/connection.
+.TP
+[\fB!\fR] \fB--ctstate\fR \fIstatelist\fR
+\fIstatelist\fR is a comma separated list of the connection states to match.
+Possible states are listed below.
+.TP
+[\fB!\fR] \fB--ctproto\fR \fIl4proto\fR
+Layer-4 protocol to match (by number or name)
+.TP
+[\fB!\fR] \fB--ctorigsrc\fR \fIaddress\fR[\fB/\fR\fImask\fR]
+Match against original source address
+.TP
+[\fB!\fR] \fB--ctorigdst\fR \fIaddress\fR[\fB/\fR\fImask\fR]
+Match against original destination address
+.TP
+[\fB!\fR] \fB--ctreplsrc\fR \fIaddress\fR[\fB/\fR\fImask\fR]
+Match against reply source address
+.TP
+[\fB!\fR] \fB--ctrepldst\fR \fIaddress\fR[\fB/\fR\fImask\fR]
+Match against reply destination address
+.TP
+[\fB!\fR] \fB--ctstatus\fR \fIstatelist\fR
+\fIstatuslist\fR is a comma separated list of the connection statuses to match.
+Possible statuses are listed below.
+.TP
+[\fB!\fR] \fB--ctexpire\fR \fItime\fR[\fB:\fR\fItime\fR]
+Match remaining lifetime in seconds against given value or range of values
+(inclusive)
+.PP
+States for \fB--ctstate\fR:
+.TP
+\fBINVALID\fR
+meaning that the packet is associated with no known connection
+.TP
+\fBNEW\fR
+meaning that the packet has started a new connection, or otherwise associated
+with a connection which has not seen packets in both directions, and
+.TP
+\fBESTABLISHED\fR
+meaning that the packet is associated with a connection which has seen packets
+in both directions,
+.TP
+\fBRELATED\fR
+meaning that the packet is starting a new connection, but is associated with an
+existing connection, such as an FTP data transfer, or an ICMP error.
+.TP
+\fBSNAT\fR
+A virtual state, matching if the original source address differs from the reply
+destination.
+.TP
+\fBDNAT\fR
+A virtual state, matching if the original destination differs from the reply
+source.
+.PP
+Statuses for \fB--ctstatus\fR:
+.TP
+\fBNONE\fR
+None of the below.
+.TP
+\fBEXPECTED\fR
+This is an expected connection (i.e. a conntrack helper set it up)
+.TP
+\fBSEEN_REPLY\fR
+Conntrack has seen packets in both directions.
+.TP
+\fBASSURED\fR
+Conntrack entry should never be early-expired.
+.TP
+\fBCONFIRMED\fR
+Connection is confirmed: originating packet has left box.
Index: iptables-modules/include/linux/netfilter/xt_conntrack.h
===================================================================
--- /dev/null
+++ iptables-modules/include/linux/netfilter/xt_conntrack.h
@@ -0,0 +1,83 @@
+/* Header file for kernel module to match connection tracking information.
+ * GPL (C) 2001  Marc Boucher (marc@mbsi.ca).
+ */
+
+#ifndef _XT_CONNTRACK_H
+#define _XT_CONNTRACK_H
+
+#include <linux/netfilter/nf_conntrack_tuple_common.h>
+
+#define XT_CONNTRACK_STATE_BIT(ctinfo) (1 << ((ctinfo)%IP_CT_IS_REPLY+1))
+#define XT_CONNTRACK_STATE_INVALID (1 << 0)
+
+#define XT_CONNTRACK_STATE_SNAT (1 << (IP_CT_NUMBER + 1))
+#define XT_CONNTRACK_STATE_DNAT (1 << (IP_CT_NUMBER + 2))
+#define XT_CONNTRACK_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 3))
+
+/* flags, invflags: */
+enum {
+	XT_CONNTRACK_STATE        = 1 << 0,
+	XT_CONNTRACK_PROTO        = 1 << 1,
+	XT_CONNTRACK_ORIGSRC      = 1 << 2,
+	XT_CONNTRACK_ORIGDST      = 1 << 3,
+	XT_CONNTRACK_REPLSRC      = 1 << 4,
+	XT_CONNTRACK_REPLDST      = 1 << 5,
+	XT_CONNTRACK_STATUS       = 1 << 6,
+	XT_CONNTRACK_EXPIRES      = 1 << 7,
+	XT_CONNTRACK_ORIGSRC_PORT = 1 << 8,
+	XT_CONNTRACK_ORIGDST_PORT = 1 << 9,
+	XT_CONNTRACK_REPLSRC_PORT = 1 << 10,
+	XT_CONNTRACK_REPLDST_PORT = 1 << 11,
+	XT_CONNTRACK_DIRECTION    = 1 << 12,
+};
+
+/* This is exposed to userspace, so remains frozen in time. */
+struct ip_conntrack_old_tuple
+{
+	struct {
+		__be32 ip;
+		union {
+			__u16 all;
+		} u;
+	} src;
+
+	struct {
+		__be32 ip;
+		union {
+			__u16 all;
+		} u;
+
+		/* The protocol. */
+		__u16 protonum;
+	} dst;
+};
+
+struct xt_conntrack_info
+{
+	unsigned int statemask, statusmask;
+
+	struct ip_conntrack_old_tuple tuple[IP_CT_DIR_MAX];
+	struct in_addr sipmsk[IP_CT_DIR_MAX], dipmsk[IP_CT_DIR_MAX];
+
+	unsigned long expires_min, expires_max;
+
+	/* Flags word */
+	u_int8_t flags;
+	/* Inverse flags */
+	u_int8_t invflags;
+};
+
+struct xt_conntrack_mtinfo1 {
+	union nf_inet_addr origsrc_addr, origsrc_mask;
+	union nf_inet_addr origdst_addr, origdst_mask;
+	union nf_inet_addr replsrc_addr, replsrc_mask;
+	union nf_inet_addr repldst_addr, repldst_mask;
+	u_int32_t expires_min, expires_max;
+	u_int16_t l4proto;
+	u_int16_t origsrc_port, origdst_port;
+	u_int16_t replsrc_port, repldst_port;
+	u_int16_t match_flags, invert_flags;
+	u_int8_t state_mask, status_mask;
+};
+
+#endif /*_XT_CONNTRACK_H*/
Index: iptables-modules/include/linux/netfilter_ipv4/ipt_conntrack.h
===================================================================
--- iptables-modules.orig/include/linux/netfilter_ipv4/ipt_conntrack.h
+++ /dev/null
@@ -1,77 +0,0 @@
-/* Header file for kernel module to match connection tracking information.
- * GPL (C) 2001  Marc Boucher (marc@mbsi.ca).
- */
-
-#ifndef _IPT_CONNTRACK_H
-#define _IPT_CONNTRACK_H
-
-#include <linux/netfilter/nf_conntrack_common.h>
-
-/* backwards compatibility crap. only exists in userspace - HW */
-#include <linux/version.h>
-#ifndef KERNEL_VERSION
-#define KERNEL_VERSION(a,b,c) (((a) << 16) | ((b) << 8) | (c))
-#endif
-
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,4,18)) || !defined IPS_EXPECTED
-#define IPS_EXPECTED	(1 << 0)
-#define IPS_SEEN_REPLY	(1 << 1)
-#define IPS_ASSURED	(1 << 2)
-#define IP_CT_DIR_ORIGINAL	0
-#define IP_CT_DIR_REPLY		1
-#define IP_CT_DIR_MAX		2
-#endif
-
-#define IPT_CONNTRACK_STATE_BIT(ctinfo) (1 << ((ctinfo)%IP_CT_IS_REPLY+1))
-#define IPT_CONNTRACK_STATE_INVALID (1 << 0)
-
-#define IPT_CONNTRACK_STATE_SNAT (1 << (IP_CT_NUMBER + 1))
-#define IPT_CONNTRACK_STATE_DNAT (1 << (IP_CT_NUMBER + 2))
-#define IPT_CONNTRACK_STATE_UNTRACKED (1 << (IP_CT_NUMBER + 3))
-
-/* flags, invflags: */
-#define IPT_CONNTRACK_STATE	0x01
-#define IPT_CONNTRACK_PROTO	0x02
-#define IPT_CONNTRACK_ORIGSRC	0x04
-#define IPT_CONNTRACK_ORIGDST	0x08
-#define IPT_CONNTRACK_REPLSRC	0x10
-#define IPT_CONNTRACK_REPLDST	0x20
-#define IPT_CONNTRACK_STATUS	0x40
-#define IPT_CONNTRACK_EXPIRES	0x80
-
-/* This is exposed to userspace, so remains frozen in time. */
-struct ip_conntrack_old_tuple
-{
-	struct {
-		u_int32_t ip;
-		union {
-			u_int16_t all;
-		} u;
-	} src;
-
-	struct {
-		u_int32_t ip;
-		union {
-			u_int16_t all;
-		} u;
-
-		/* The protocol. */
-		u_int16_t protonum;
-	} dst;
-};
-
-struct ipt_conntrack_info
-{
-	unsigned int statemask, statusmask;
-
-	struct ip_conntrack_old_tuple tuple[IP_CT_DIR_MAX];
-	struct in_addr sipmsk[IP_CT_DIR_MAX], dipmsk[IP_CT_DIR_MAX];
-
-	unsigned long expires_min, expires_max;
-
-	/* Flags word */
-	u_int8_t flags;
-	/* Inverse flags */
-	u_int8_t invflags;
-};
-#endif /*_IPT_CONNTRACK_H*/
