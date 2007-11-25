From: Patrick McHardy <kaber@trash.net>
Subject: [RFC IPTABLES 4/4]: Add xt_rateest match
Date: Sun, 25 Nov 2007 18:12:00 +0100
Message-ID: <4749ACE0.70303@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------090601030109070906030801"
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:64266 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753411AbXKYRMi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 12:12:38 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------090601030109070906030801
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit


--------------090601030109070906030801
Content-Type: text/x-patch;
 name="04-libxt_rateest.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="04-libxt_rateest.diff"

[IPTABLES]: Add xt_rateest match

Signed-off-by: Patrick McHardy <kaber@trash.net>
Index: include/linux/netfilter/xt_rateest.h
===================================================================
--- include/linux/netfilter/xt_rateest.h	(Revision 0)
+++ include/linux/netfilter/xt_rateest.h	(Revision 0)
@@ -0,0 +1,33 @@
+#ifndef _XT_RATEEST_MATCH_H
+#define _XT_RATEEST_MATCH_H
+
+enum xt_rateest_match_flags {
+	XT_RATEEST_MATCH_INVERT	= 0x01,
+	XT_RATEEST_MATCH_ABS	= 0x02,
+	XT_RATEEST_MATCH_REL	= 0x04,
+	XT_RATEEST_MATCH_DELTA	= 0x08,
+	XT_RATEEST_MATCH_BPS	= 0x10,
+	XT_RATEEST_MATCH_PPS	= 0x20,
+};
+
+enum xt_rateest_match_mode {
+	XT_RATEEST_MATCH_NONE,
+	XT_RATEEST_MATCH_EQ,
+	XT_RATEEST_MATCH_LT,
+	XT_RATEEST_MATCH_GT,
+};
+
+struct xt_rateest_match_info {
+	char			name1[IFNAMSIZ];
+	char			name2[IFNAMSIZ];
+	u_int16_t		flags;
+	u_int16_t		mode;
+	u_int32_t		bps1;
+	u_int32_t		pps1;
+	u_int32_t		bps2;
+	u_int32_t		pps2;
+	struct xt_rateest	*est1 __attribute__((aligned(8)));
+	struct xt_rateest	*est2 __attribute__((aligned(8)));
+};
+
+#endif /* _XT_RATEEST_MATCH_H */
Index: extensions/Makefile
===================================================================
--- extensions/Makefile	(Revision 7083)
+++ extensions/Makefile	(Arbeitskopie)
@@ -7,7 +7,7 @@
 #
 PF_EXT_SLIB:=ah addrtype conntrack ecn icmp iprange owner policy realm recent tos ttl unclean CLUSTERIP DNAT ECN LOG MASQUERADE MIRROR NETMAP REDIRECT REJECT SAME SNAT TOS TTL ULOG
 PF6_EXT_SLIB:=ah dst eui64 frag hbh hl icmp6 ipv6header mh owner policy rt HL LOG REJECT
-PFX_EXT_SLIB:=connbytes connmark connlimit comment dccp dscp esp hashlimit helper length limit mac mark multiport physdev pkttype quota sctp state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK RATEEST TCPMSS TRACE
+PFX_EXT_SLIB:=connbytes connmark connlimit comment dccp dscp esp hashlimit helper length limit mac mark multiport physdev pkttype quota rateest sctp state statistic standard string tcp tcpmss time u32 udp CLASSIFY CONNMARK DSCP MARK NFLOG NFQUEUE NOTRACK RATEEST TCPMSS TRACE
 
 PF_EXT_SELINUX_SLIB:=
 PF6_EXT_SELINUX_SLIB:=
Index: extensions/libxt_rateest.c
===================================================================
--- extensions/libxt_rateest.c	(Revision 0)
+++ extensions/libxt_rateest.c	(Revision 0)
@@ -0,0 +1,461 @@
+#include <stdio.h>
+#include <string.h>
+#include <stdlib.h>
+#include <stddef.h>
+#include <getopt.h>
+
+#include <xtables.h>
+#include <linux/netfilter/xt_rateest.h>
+
+/* Ugly hack to pass info to final_check function. We should fix the API */
+static struct xt_rateest_match_info *rateest_info;
+
+static void rateest_help(void)
+{
+	printf(
+"rateest match v%s options:\n"
+" --rateest1 name		Rate estimator name\n"
+" --rateest2 name		Rate estimator name\n"
+" --rateest-delta		Compare difference(s) to given rate(s)\n"
+" --rateest-bps1 [bps]		Compare bps\n"
+" --rateest-pps1 [pps]		Compare pps\n"
+" --rateest-bps2 [bps]		Compare bps\n"
+" --rateest-pps2 [pps]		Compare pps\n"
+" [!] --rateest-lt		Match if rate is less than given rate/estimator\n"
+" [!] --rateest-gt		Match if rate is greater than given rate/estimator\n"
+" [!] --rateest-eq		Match if rate is equal to given rate/estimator\n"
+"\n",
+	       IPTABLES_VERSION);
+}
+
+enum rateest_options {
+	OPT_RATEEST1,
+	OPT_RATEEST2,
+	OPT_RATEEST_BPS1,
+	OPT_RATEEST_PPS1,
+	OPT_RATEEST_BPS2,
+	OPT_RATEEST_PPS2,
+	OPT_RATEEST_DELTA,
+	OPT_RATEEST_LT,
+	OPT_RATEEST_GT,
+	OPT_RATEEST_EQ,
+};
+
+static const struct option rateest_opts[] = {
+	{ "rateest1",		1, NULL, OPT_RATEEST1 },
+	{ "rateest",		1, NULL, OPT_RATEEST1 }, /* alias for absolute mode */
+	{ "rateest2",		1, NULL, OPT_RATEEST2 },
+	{ "rateest-bps1",	0, NULL, OPT_RATEEST_BPS1 },
+	{ "rateest-pps1",	0, NULL, OPT_RATEEST_PPS1 },
+	{ "rateest-bps2",	0, NULL, OPT_RATEEST_BPS2 },
+	{ "rateest-pps2",	0, NULL, OPT_RATEEST_PPS2 },
+	{ "rateest-bps",	0, NULL, OPT_RATEEST_BPS2 }, /* alias for absolute mode */
+	{ "rateest-pps",	0, NULL, OPT_RATEEST_PPS2 }, /* alias for absolute mode */
+	{ "rateest-delta",	0, NULL, OPT_RATEEST_DELTA },
+	{ "rateest-lt",		0, NULL, OPT_RATEEST_LT },
+	{ "rateest-gt",		0, NULL, OPT_RATEEST_GT },
+	{ "rateest-eq",		0, NULL, OPT_RATEEST_EQ },
+	{ },
+};
+
+/* Copied from iproute. See http://physics.nist.gov/cuu/Units/binary.html */
+static const struct rate_suffix {
+	const char *name;
+	double scale;
+} suffixes[] = {
+	{ "bit",	1. },
+	{ "Kibit",	1024. },
+	{ "kbit",	1000. },
+	{ "mibit",	1024.*1024. },
+	{ "mbit",	1000000. },
+	{ "gibit",	1024.*1024.*1024. },
+	{ "gbit",	1000000000. },
+	{ "tibit",	1024.*1024.*1024.*1024. },
+	{ "tbit",	1000000000000. },
+	{ "Bps",	8. },
+	{ "KiBps",	8.*1024. },
+	{ "KBps",	8000. },
+	{ "MiBps",	8.*1024*1024. },
+	{ "MBps",	8000000. },
+	{ "GiBps",	8.*1024.*1024.*1024. },
+	{ "GBps",	8000000000. },
+	{ "TiBps",	8.*1024.*1024.*1024.*1024. },
+	{ "TBps",	8000000000000. },
+	{ }
+};
+
+static int
+rateest_get_rate(u_int32_t *rate, const char *str)
+{
+	char *p;
+	double bps = strtod(str, &p);
+	const struct rate_suffix *s;
+
+	if (p == str)
+		return -1;
+
+	if (*p == '\0') {
+		*rate = bps / 8.;	/* assume bytes/sec */
+		return 0;
+	}
+
+	for (s = suffixes; s->name; ++s) {
+		if (strcasecmp(s->name, p) == 0) {
+			*rate = (bps * s->scale) / 8.;
+			return 0;
+		}
+	}
+
+	return -1;
+}
+
+static int
+rateest_parse(int c, char **argv, int invert, unsigned int *flags,
+	      const void *entry, struct xt_entry_match **match)
+{
+	struct xt_rateest_match_info *info = (void *)(*match)->data;
+
+	rateest_info = info;
+
+	switch (c) {
+	case OPT_RATEEST1:
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: rateest can't be inverted");
+
+		if (*flags & (1 << c))
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: can't specify --rateest1 twice");
+		*flags |= 1 << c;
+		
+		strncpy(info->name1, optarg, sizeof(info->name1) - 1);
+		break;
+
+	case OPT_RATEEST2:
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: rateest can't be inverted");
+
+		if (*flags & (1 << c))
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: can't specify --rateest2 twice");
+		*flags |= 1 << c;
+
+		strncpy(info->name2, optarg, sizeof(info->name2) - 1);
+		info->flags |= XT_RATEEST_MATCH_REL;
+		break;
+
+	case OPT_RATEEST_BPS1:
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: rateest-bps can't be inverted");
+
+		if (*flags & (1 << c))
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: can't specify --rateest-bps1 twice");
+		*flags |= 1 << c;
+
+		info->flags |= XT_RATEEST_MATCH_BPS;
+
+		/* The rate is optional and only required in absolute mode */
+		if (!argv[optind] || *argv[optind] == '-' || *argv[optind] == '!')
+			break;
+
+		if (rateest_get_rate(&info->bps1, argv[optind]) < 0)
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: could not parse rate `%s'",
+				   argv[optind]);
+		optind++;
+		break;
+
+	case OPT_RATEEST_PPS1:
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: rateest-pps can't be inverted");
+
+		if (*flags & (1 << c))
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: can't specify --rateest-pps1 twice");
+		*flags |= 1 << c;
+
+		info->flags |= XT_RATEEST_MATCH_PPS;
+
+		/* The rate is optional and only required in absolute mode */
+		if (!argv[optind] || *argv[optind] == '-' || *argv[optind] == '!')
+			break;
+
+		if (string_to_number(argv[optind], 0, 0, &info->pps1) < 0)
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: could not parse pps `%s'",
+				   argv[optind]);
+		optind++;
+		break;
+
+	case OPT_RATEEST_BPS2:
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: rateest-bps can't be inverted");
+
+		if (*flags & (1 << c))
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: can't specify --rateest-bps2 twice");
+		*flags |= 1 << c;
+
+		info->flags |= XT_RATEEST_MATCH_BPS;
+
+		/* The rate is optional and only required in absolute mode */
+		if (!argv[optind] || *argv[optind] == '-' || *argv[optind] == '!')
+			break;
+
+		if (rateest_get_rate(&info->bps2, argv[optind]) < 0)
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: could not parse rate `%s'",
+				   argv[optind]);
+		optind++;
+		break;
+
+	case OPT_RATEEST_PPS2:
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: rateest-pps can't be inverted");
+
+		if (*flags & (1 << c))
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: can't specify --rateest-pps2 twice");
+		*flags |= 1 << c;
+
+		info->flags |= XT_RATEEST_MATCH_PPS;
+
+		/* The rate is optional and only required in absolute mode */
+		if (!argv[optind] || *argv[optind] == '-' || *argv[optind] == '!')
+			break;
+
+		if (string_to_number(argv[optind], 0, 0, &info->pps2) < 0)
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: could not parse pps `%s'",
+				   argv[optind]);
+		optind++;
+		break;
+
+	case OPT_RATEEST_DELTA:
+		check_inverse(optarg, &invert, &optind, 0);
+		if (invert)
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: rateest-delta can't be inverted");
+
+		if (*flags & (1 << c))
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: can't specify --rateest-delta twice");
+		*flags |= 1 << c;
+
+		info->flags |= XT_RATEEST_MATCH_DELTA;
+		break;
+
+	case OPT_RATEEST_EQ:
+		check_inverse(argv[optind-1], &invert, &optind, 0);
+
+		if (*flags & (1 << c))
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: can't specify lt/gt/eq twice");
+		*flags |= 1 << c;
+
+		info->mode = XT_RATEEST_MATCH_EQ;
+		if (invert)
+			info->flags |= XT_RATEEST_MATCH_INVERT;
+		break;
+
+	case OPT_RATEEST_LT:
+		check_inverse(argv[optind-1], &invert, &optind, 0);
+
+		if (*flags & (1 << c))
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: can't specify lt/gt/eq twice");
+		*flags |= 1 << c;
+
+		info->mode = XT_RATEEST_MATCH_LT;
+		if (invert)
+			info->flags |= XT_RATEEST_MATCH_INVERT;
+		break;
+
+	case OPT_RATEEST_GT:
+		check_inverse(argv[optind-1], &invert, &optind, 0);
+
+		if (*flags & (1 << c))
+			exit_error(PARAMETER_PROBLEM,
+				   "rateest: can't specify lt/gt/eq twice");
+		*flags |= 1 << c;
+
+		info->mode = XT_RATEEST_MATCH_GT;
+		if (invert)
+			info->flags |= XT_RATEEST_MATCH_INVERT;
+		break;
+
+	default:
+		return 0;
+	}
+
+	return 1;
+}
+
+static void
+rateest_final_check(unsigned int flags)
+{
+	struct xt_rateest_match_info *info = rateest_info;
+
+	if (!(info->flags & XT_RATEEST_MATCH_REL))
+		info->flags |= XT_RATEEST_MATCH_ABS;
+}
+
+static void
+rateest_print_rate(u_int32_t rate, int numeric)
+{
+	double tmp = (double)rate*8;
+
+	if (numeric)
+		printf("%u ", rate);
+	else if (tmp >= 1000.0*1000000.0)
+		printf("%.0fMbit ", tmp/1000000.0);
+	else if (tmp >= 1000.0 * 1000.0)
+		printf("%.0fKbit ", tmp/1000.0);
+	else
+		printf("%.0fbit ", tmp);
+}
+
+static void
+rateest_print_mode(struct xt_rateest_match_info *info, const char *prefix)
+{
+	if (info->flags & XT_RATEEST_MATCH_INVERT)
+		printf("! ");
+
+	switch (info->mode) {
+	case XT_RATEEST_MATCH_EQ:
+		printf("%seq ", prefix);
+		break;
+	case XT_RATEEST_MATCH_LT:
+		printf("%slt ", prefix);
+		break;
+	case XT_RATEEST_MATCH_GT:
+		printf("%sgt ", prefix);
+		break;
+	default:
+		exit(1);
+	}
+}
+
+static void
+rateest_print(const void *ip, const struct xt_entry_match *match, int numeric)
+{
+	struct xt_rateest_match_info *info = (void *)match->data;
+
+	printf("rateest match ");
+
+	printf("%s ", info->name1);
+	if (info->flags & XT_RATEEST_MATCH_DELTA)
+		printf("delta ");
+
+	if (info->flags & XT_RATEEST_MATCH_BPS) {
+		printf("bps ");
+		if (info->flags & XT_RATEEST_MATCH_DELTA)
+			rateest_print_rate(info->bps1, numeric);
+		if (info->flags & XT_RATEEST_MATCH_ABS) {
+			rateest_print_mode(info, "");
+			rateest_print_rate(info->bps2, numeric);
+		}
+	}
+	if (info->flags & XT_RATEEST_MATCH_PPS) {
+		printf("pps ");
+		if (info->flags & XT_RATEEST_MATCH_DELTA)
+			printf("%u ", info->pps1);
+		if (info->flags & XT_RATEEST_MATCH_ABS) {
+			rateest_print_mode(info, "");
+			printf("%u ", info->pps2);
+		}
+	}
+
+	if (info->flags & XT_RATEEST_MATCH_REL) {
+		rateest_print_mode(info, "");
+
+		printf("%s ", info->name2);
+		if (info->flags & XT_RATEEST_MATCH_DELTA)
+			printf("delta ");
+
+		if (info->flags & XT_RATEEST_MATCH_BPS) {
+			printf("bps ");
+			if (info->flags & XT_RATEEST_MATCH_DELTA)
+				rateest_print_rate(info->bps2, numeric);
+		}
+		if (info->flags & XT_RATEEST_MATCH_PPS) {
+			printf("pps ");
+			if (info->flags & XT_RATEEST_MATCH_DELTA)
+				printf("%u ", info->pps2);
+		}
+	}
+}
+
+static void
+rateest_save(const void *ip, const struct xt_entry_match *match)
+{
+	struct xt_rateest_match_info *info = (void *)match->data;
+
+	if (info->flags & XT_RATEEST_MATCH_REL) {
+		printf("--rateest1 %s ", info->name1);
+		if (info->flags & XT_RATEEST_MATCH_BPS)
+			printf("--rateest-bps ");
+		if (info->flags & XT_RATEEST_MATCH_PPS)
+			printf("--rateest-pps ");
+		rateest_print_mode(info, "--rateest-");
+		printf("--rateest2 %s ", info->name2);
+	} else {
+		printf("--rateest %s ", info->name1);
+		if (info->flags & XT_RATEEST_MATCH_BPS) {
+			printf("--rateest-bps ");
+			rateest_print_mode(info, "--rateest-");
+			rateest_print_rate(info->bps2, 0);
+		}
+		if (info->flags & XT_RATEEST_MATCH_PPS) {
+			printf("--rateest-pps ");
+			rateest_print_mode(info, "--rateest-");
+			printf("%u ", info->pps2);
+		}
+	}
+}
+
+static struct xtables_match rateest_match4 = {
+	.family		= AF_INET,
+	.name		= "rateest",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_rateest_match_info)),
+	.userspacesize	= XT_ALIGN(offsetof(struct xt_rateest_match_info, est1)),
+	.help		= rateest_help,
+	.parse		= rateest_parse,
+	.final_check	= rateest_final_check,
+	.print		= rateest_print,
+	.save		= rateest_save,
+	.extra_opts	= rateest_opts,
+};
+
+static struct xtables_match rateest_match6 = {
+	.family		= AF_INET6,
+	.name		= "rateest",
+	.version	= IPTABLES_VERSION,
+	.size		= XT_ALIGN(sizeof(struct xt_rateest_match_info)),
+	.userspacesize	= XT_ALIGN(offsetof(struct xt_rateest_match_info, est1)),
+	.help		= rateest_help,
+	.parse		= rateest_parse,
+	.final_check	= rateest_final_check,
+	.print		= rateest_print,
+	.save		= rateest_save,
+	.extra_opts	= rateest_opts,
+};
+
+void _init(void)
+{
+	xtables_register_match(&rateest_match4);
+	xtables_register_match(&rateest_match6);
+}

--------------090601030109070906030801--
