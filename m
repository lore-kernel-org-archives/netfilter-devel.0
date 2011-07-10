From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 3/6] option: remove last traces of intrapositional negation
Date: Sun, 10 Jul 2011 20:22:15 +0200
Message-ID: <1310322139-28505-4-git-send-email-jengelh@medozas.de>
References: <1310322139-28505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:58436 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756299Ab1GJSWY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:22:24 -0400
In-Reply-To: <1310322139-28505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Intrapositional negation was deprecated in 1.4.3.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 extensions/libxt_SET.c     |    9 ---------
 extensions/libxt_rateest.c |   13 -------------
 extensions/libxt_sctp.c    |    4 ----
 extensions/libxt_set.c     |    4 ----
 extensions/libxt_tcp.c     |    5 -----
 include/xtables.h.in       |    2 --
 iptables/ip6tables.c       |    5 -----
 iptables/iptables.c        |    5 -----
 iptables/xtables.c         |   29 -----------------------------
 9 files changed, 0 insertions(+), 76 deletions(-)

diff --git a/extensions/libxt_SET.c b/extensions/libxt_SET.c
index 51c0cec..0446603 100644
--- a/extensions/libxt_SET.c
+++ b/extensions/libxt_SET.c
@@ -67,10 +67,6 @@ parse_target_v0(char **argv, int invert, unsigned int *flags,
 		xtables_error(PARAMETER_PROBLEM,
 			      "--%s can be specified only once", what);
 
-	if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
-		xtables_error(PARAMETER_PROBLEM,
-			      "Unexpected `!' after --%s", what);
-
 	if (!argv[optind]
 	    || argv[optind][0] == '-' || argv[optind][0] == '!')
 		xtables_error(PARAMETER_PROBLEM,
@@ -173,11 +169,6 @@ parse_target(char **argv, int invert, struct xt_set_info *info,
 	if (info->dim)
 		xtables_error(PARAMETER_PROBLEM,
 			      "--%s can be specified only once", what);
-
-	if (xtables_check_inverse(optarg, &invert, NULL, 0, argv))
-		xtables_error(PARAMETER_PROBLEM,
-			      "Unexpected `!' after --%s", what);
-
 	if (!argv[optind]
 	    || argv[optind][0] == '-' || argv[optind][0] == '!')
 		xtables_error(PARAMETER_PROBLEM,
diff --git a/extensions/libxt_rateest.c b/extensions/libxt_rateest.c
index 5f42a13..86bbb06 100644
--- a/extensions/libxt_rateest.c
+++ b/extensions/libxt_rateest.c
@@ -114,7 +114,6 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 
 	switch (c) {
 	case OPT_RATEEST1:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest can't be inverted");
@@ -128,7 +127,6 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST2:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest can't be inverted");
@@ -143,7 +141,6 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_BPS1:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-bps can't be inverted");
@@ -167,7 +164,6 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_PPS1:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-pps can't be inverted");
@@ -192,7 +188,6 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_BPS2:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-bps can't be inverted");
@@ -216,7 +211,6 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_PPS2:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-pps can't be inverted");
@@ -241,7 +235,6 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_DELTA:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: rateest-delta can't be inverted");
@@ -255,8 +248,6 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_EQ:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
 		if (*flags & (1 << c))
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: can't specify lt/gt/eq twice");
@@ -268,8 +259,6 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_LT:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
 		if (*flags & (1 << c))
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: can't specify lt/gt/eq twice");
@@ -281,8 +270,6 @@ rateest_parse(int c, char **argv, int invert, unsigned int *flags,
 		break;
 
 	case OPT_RATEEST_GT:
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
 		if (*flags & (1 << c))
 			xtables_error(PARAMETER_PROBLEM,
 				   "rateest: can't specify lt/gt/eq twice");
diff --git a/extensions/libxt_sctp.c b/extensions/libxt_sctp.c
index 5dbc36f..56a4cdf 100644
--- a/extensions/libxt_sctp.c
+++ b/extensions/libxt_sctp.c
@@ -257,7 +257,6 @@ sctp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 			           "Only one `--source-port' allowed");
 		einfo->flags |= XT_SCTP_SRC_PORTS;
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_sctp_ports(optarg, einfo->spts);
 		if (invert)
 			einfo->invflags |= XT_SCTP_SRC_PORTS;
@@ -269,7 +268,6 @@ sctp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--destination-port' allowed");
 		einfo->flags |= XT_SCTP_DEST_PORTS;
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_sctp_ports(optarg, einfo->dpts);
 		if (invert)
 			einfo->invflags |= XT_SCTP_DEST_PORTS;
@@ -280,8 +278,6 @@ sctp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & XT_SCTP_CHUNK_TYPES)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--chunk-types' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
 		if (!argv[optind] 
 		    || argv[optind][0] == '-' || argv[optind][0] == '!')
 			xtables_error(PARAMETER_PROBLEM,
diff --git a/extensions/libxt_set.c b/extensions/libxt_set.c
index da722c7..6b39147 100644
--- a/extensions/libxt_set.c
+++ b/extensions/libxt_set.c
@@ -64,8 +64,6 @@ set_parse_v0(int c, char **argv, int invert, unsigned int *flags,
 		if (info->u.flags[0])
 			xtables_error(PARAMETER_PROBLEM,
 				      "--match-set can be specified only once");
-
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			info->u.flags[0] |= IPSET_MATCH_INV;
 
@@ -151,8 +149,6 @@ set_parse_v1(int c, char **argv, int invert, unsigned int *flags,
 		if (info->dim)
 			xtables_error(PARAMETER_PROBLEM,
 				      "--match-set can be specified only once");
-
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		if (invert)
 			info->flags |= IPSET_INV_MATCH;
 
diff --git a/extensions/libxt_tcp.c b/extensions/libxt_tcp.c
index 4d914e3..3940d91 100644
--- a/extensions/libxt_tcp.c
+++ b/extensions/libxt_tcp.c
@@ -148,7 +148,6 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & TCP_SRC_PORTS)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--source-port' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_tcp_ports(optarg, tcpinfo->spts);
 		if (invert)
 			tcpinfo->invflags |= XT_TCP_INV_SRCPT;
@@ -159,7 +158,6 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & TCP_DST_PORTS)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--destination-port' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_tcp_ports(optarg, tcpinfo->dpts);
 		if (invert)
 			tcpinfo->invflags |= XT_TCP_INV_DSTPT;
@@ -180,8 +178,6 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one of `--syn' or `--tcp-flags' "
 				   " allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
-
 		if (!argv[optind]
 		    || argv[optind][0] == '-' || argv[optind][0] == '!')
 			xtables_error(PARAMETER_PROBLEM,
@@ -197,7 +193,6 @@ tcp_parse(int c, char **argv, int invert, unsigned int *flags,
 		if (*flags & TCP_OPTION)
 			xtables_error(PARAMETER_PROBLEM,
 				   "Only one `--tcp-option' allowed");
-		xtables_check_inverse(optarg, &invert, &optind, 0, argv);
 		parse_tcp_option(optarg, &tcpinfo->option);
 		if (invert)
 			tcpinfo->invflags |= XT_TCP_INV_OPTION;
diff --git a/include/xtables.h.in b/include/xtables.h.in
index 0dead26..d50df79 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -432,8 +432,6 @@ xtables_parse_interface(const char *arg, char *vianame, unsigned char *mask);
 /* this is a special 64bit data type that is 8-byte aligned */
 #define aligned_u64 u_int64_t __attribute__((aligned(8)))
 
-int xtables_check_inverse(const char option[], int *invert,
-	int *my_optind, int argc, char **argv);
 extern struct xtables_globals *xt_params;
 #define xtables_error (xt_params->exit_err)
 
diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index d13744c..04e5224 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1536,7 +1536,6 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			 * Option selection
 			 */
 		case 'p':
-			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
 			set_option(&cs.options, OPT_PROTOCOL, &cs.fw6.ipv6.invflags,
 				   cs.invert);
 
@@ -1562,14 +1561,12 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			break;
 
 		case 's':
-			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
 			set_option(&cs.options, OPT_SOURCE, &cs.fw6.ipv6.invflags,
 				   cs.invert);
 			shostnetworkmask = optarg;
 			break;
 
 		case 'd':
-			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
 			set_option(&cs.options, OPT_DESTINATION, &cs.fw6.ipv6.invflags,
 				   cs.invert);
 			dhostnetworkmask = optarg;
@@ -1594,7 +1591,6 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
-			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
 			set_option(&cs.options, OPT_VIANAMEIN, &cs.fw6.ipv6.invflags,
 				   cs.invert);
 			xtables_parse_interface(optarg,
@@ -1607,7 +1603,6 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
-			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
 			set_option(&cs.options, OPT_VIANAMEOUT, &cs.fw6.ipv6.invflags,
 				   cs.invert);
 			xtables_parse_interface(optarg,
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 6ceaf6b..50dc1e7 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1566,7 +1566,6 @@ int do_command4(int argc, char *argv[], char **table, struct iptc_handle **handl
 			 * Option selection
 			 */
 		case 'p':
-			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
 			set_option(&cs.options, OPT_PROTOCOL, &cs.fw.ip.invflags,
 				   cs.invert);
 
@@ -1584,14 +1583,12 @@ int do_command4(int argc, char *argv[], char **table, struct iptc_handle **handl
 			break;
 
 		case 's':
-			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
 			set_option(&cs.options, OPT_SOURCE, &cs.fw.ip.invflags,
 				   cs.invert);
 			shostnetworkmask = optarg;
 			break;
 
 		case 'd':
-			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
 			set_option(&cs.options, OPT_DESTINATION, &cs.fw.ip.invflags,
 				   cs.invert);
 			dhostnetworkmask = optarg;
@@ -1616,7 +1613,6 @@ int do_command4(int argc, char *argv[], char **table, struct iptc_handle **handl
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
-			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
 			set_option(&cs.options, OPT_VIANAMEIN, &cs.fw.ip.invflags,
 				   cs.invert);
 			xtables_parse_interface(optarg,
@@ -1629,7 +1625,6 @@ int do_command4(int argc, char *argv[], char **table, struct iptc_handle **handl
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
-			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
 			set_option(&cs.options, OPT_VIANAMEOUT, &cs.fw.ip.invflags,
 				   cs.invert);
 			xtables_parse_interface(optarg,
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 0f02592..b05df97 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -1765,35 +1765,6 @@ void xtables_save_string(const char *value)
 	}
 }
 
-/**
- * Check for option-intrapositional negation.
- * Do not use in new code.
- */
-int xtables_check_inverse(const char option[], int *invert,
-			  int *my_optind, int argc, char **argv)
-{
-	if (option == NULL || strcmp(option, "!") != 0)
-		return false;
-
-	fprintf(stderr, "Using intrapositioned negation "
-	        "(`--option ! this`) is deprecated in favor of "
-	        "extrapositioned (`! --option this`).\n");
-
-	if (*invert)
-		xt_params->exit_err(PARAMETER_PROBLEM,
-			   "Multiple `!' flags not allowed");
-	*invert = true;
-	if (my_optind != NULL) {
-		optarg = argv[*my_optind];
-		++*my_optind;
-		if (argc && *my_optind > argc)
-			xt_params->exit_err(PARAMETER_PROBLEM,
-				   "no argument following `!'");
-	}
-
-	return true;
-}
-
 const struct xtables_pprot xtables_chain_protos[] = {
 	{"tcp",       IPPROTO_TCP},
 	{"sctp",      IPPROTO_SCTP},
-- 
1.7.3.4

