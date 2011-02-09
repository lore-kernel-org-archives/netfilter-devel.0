From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 03/11] src: share iptables_command_state across the two programs
Date: Wed,  9 Feb 2011 02:48:48 +0100
Message-ID: <1297216137-18505-4-git-send-email-jengelh@medozas.de>
References: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38715 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009Ab1BIBtF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Feb 2011 20:49:05 -0500
In-Reply-To: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

struct iptables_command_state and quite a bit of the code looks worthy
of deduplication.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |   74 ++++++++++++++++++++++++----------------------------------
 iptables.c  |   12 ---------
 xshared.h   |   18 ++++++++++++++
 3 files changed, 49 insertions(+), 55 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 947f3c9..dac0c52 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1288,18 +1288,6 @@ static void clear_rule_matches(struct xtables_rule_match **matches)
 	*matches = NULL;
 }
 
-struct iptables_command_state {
-	struct ip6t_entry fw;
-	int invert;
-	int c;
-	unsigned int options;
-	struct xtables_rule_match *matches;
-	struct xtables_target *target;
-	char *protocol;
-	int proto_used;
-	char **argv;
-};
-
 static void command_default(struct iptables_command_state *cs)
 {
 	struct xtables_rule_match *matchp;
@@ -1311,7 +1299,7 @@ static void command_default(struct iptables_command_state *cs)
 	    !cs->target->parse(cs->c - cs->target->option_offset,
 			       cs->argv, cs->invert,
 			       &cs->target->tflags,
-			       &cs->fw, &cs->target->t)) {
+			       &cs->fw6, &cs->target->t)) {
 		for (matchp = cs->matches; matchp; matchp = matchp->next) {
 			if (matchp->completed ||
 			    matchp->match->parse == NULL)
@@ -1322,7 +1310,7 @@ static void command_default(struct iptables_command_state *cs)
 			if (matchp->match->parse(cs->c - matchp->match->option_offset,
 				     cs->argv, cs->invert,
 				     &matchp->match->mflags,
-				     &cs->fw,
+				     &cs->fw6,
 				     &matchp->match->m))
 				break;
 		}
@@ -1609,7 +1597,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			 */
 		case 'p':
 			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
-			set_option(&cs.options, OPT_PROTOCOL, &cs.fw.ipv6.invflags,
+			set_option(&cs.options, OPT_PROTOCOL, &cs.fw6.ipv6.invflags,
 				   cs.invert);
 
 			/* Canonicalize into lower case */
@@ -1617,16 +1605,16 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				*cs.protocol = tolower(*cs.protocol);
 
 			cs.protocol = optarg;
-			cs.fw.ipv6.proto = xtables_parse_protocol(cs.protocol);
-			cs.fw.ipv6.flags |= IP6T_F_PROTO;
+			cs.fw6.ipv6.proto = xtables_parse_protocol(cs.protocol);
+			cs.fw6.ipv6.flags |= IP6T_F_PROTO;
 
-			if (cs.fw.ipv6.proto == 0
-			    && (cs.fw.ipv6.invflags & IP6T_INV_PROTO))
+			if (cs.fw6.ipv6.proto == 0
+			    && (cs.fw6.ipv6.invflags & IP6T_INV_PROTO))
 				xtables_error(PARAMETER_PROBLEM,
 					   "rule would never match protocol");
 
-			if (is_exthdr(cs.fw.ipv6.proto)
-			    && (cs.fw.ipv6.invflags & IP6T_INV_PROTO) == 0)
+			if (is_exthdr(cs.fw6.ipv6.proto)
+			    && (cs.fw6.ipv6.invflags & IP6T_INV_PROTO) == 0)
 				fprintf(stderr,
 					"Warning: never matched protocol: %s. "
 					"use extension match instead.\n",
@@ -1635,29 +1623,29 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 		case 's':
 			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
-			set_option(&cs.options, OPT_SOURCE, &cs.fw.ipv6.invflags,
+			set_option(&cs.options, OPT_SOURCE, &cs.fw6.ipv6.invflags,
 				   cs.invert);
 			shostnetworkmask = optarg;
 			break;
 
 		case 'd':
 			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
-			set_option(&cs.options, OPT_DESTINATION, &cs.fw.ipv6.invflags,
+			set_option(&cs.options, OPT_DESTINATION, &cs.fw6.ipv6.invflags,
 				   cs.invert);
 			dhostnetworkmask = optarg;
 			break;
 
 #ifdef IP6T_F_GOTO
 		case 'g':
-			set_option(&cs.options, OPT_JUMP, &cs.fw.ipv6.invflags,
+			set_option(&cs.options, OPT_JUMP, &cs.fw6.ipv6.invflags,
 					cs.invert);
-			cs.fw.ipv6.flags |= IP6T_F_GOTO;
+			cs.fw6.ipv6.flags |= IP6T_F_GOTO;
 			jumpto = parse_target(optarg);
 			break;
 #endif
 
 		case 'j':
-			set_option(&cs.options, OPT_JUMP, &cs.fw.ipv6.invflags,
+			set_option(&cs.options, OPT_JUMP, &cs.fw6.ipv6.invflags,
 				   cs.invert);
 			jumpto = parse_target(optarg);
 			/* TRY_LOAD (may be chain name) */
@@ -1691,11 +1679,11 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 					"Empty interface is likely to be "
 					"undesired");
 			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
-			set_option(&cs.options, OPT_VIANAMEIN, &cs.fw.ipv6.invflags,
+			set_option(&cs.options, OPT_VIANAMEIN, &cs.fw6.ipv6.invflags,
 				   cs.invert);
 			xtables_parse_interface(optarg,
-					cs.fw.ipv6.iniface,
-					cs.fw.ipv6.iniface_mask);
+					cs.fw6.ipv6.iniface,
+					cs.fw6.ipv6.iniface_mask);
 			break;
 
 		case 'o':
@@ -1704,17 +1692,17 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 					"Empty interface is likely to be "
 					"undesired");
 			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
-			set_option(&cs.options, OPT_VIANAMEOUT, &cs.fw.ipv6.invflags,
+			set_option(&cs.options, OPT_VIANAMEOUT, &cs.fw6.ipv6.invflags,
 				   cs.invert);
 			xtables_parse_interface(optarg,
-					cs.fw.ipv6.outiface,
-					cs.fw.ipv6.outiface_mask);
+					cs.fw6.ipv6.outiface,
+					cs.fw6.ipv6.outiface_mask);
 			break;
 
 		case 'v':
 			if (!verbose)
 				set_option(&cs.options, OPT_VERBOSE,
-					   &cs.fw.ipv6.invflags, cs.invert);
+					   &cs.fw6.ipv6.invflags, cs.invert);
 			verbose++;
 			break;
 
@@ -1742,7 +1730,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		break;
 
 		case 'n':
-			set_option(&cs.options, OPT_NUMERIC, &cs.fw.ipv6.invflags,
+			set_option(&cs.options, OPT_NUMERIC, &cs.fw6.ipv6.invflags,
 				   cs.invert);
 			break;
 
@@ -1754,7 +1742,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			break;
 
 		case 'x':
-			set_option(&cs.options, OPT_EXPANDED, &cs.fw.ipv6.invflags,
+			set_option(&cs.options, OPT_EXPANDED, &cs.fw6.ipv6.invflags,
 				   cs.invert);
 			break;
 
@@ -1767,7 +1755,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			exit(0);
 
 		case '0':
-			set_option(&cs.options, OPT_LINENUMBERS, &cs.fw.ipv6.invflags,
+			set_option(&cs.options, OPT_LINENUMBERS, &cs.fw6.ipv6.invflags,
 				   cs.invert);
 			break;
 
@@ -1777,7 +1765,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 		case 'c':
 
-			set_option(&cs.options, OPT_COUNTERS, &cs.fw.ipv6.invflags,
+			set_option(&cs.options, OPT_COUNTERS, &cs.fw6.ipv6.invflags,
 				   cs.invert);
 			pcnt = optarg;
 			bcnt = strchr(pcnt + 1, ',');
@@ -1795,13 +1783,13 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				xtables_error(PARAMETER_PROBLEM,
 					"-%c packet counter not numeric",
 					opt2char(OPT_COUNTERS));
-			cs.fw.counters.pcnt = cnt;
+			cs.fw6.counters.pcnt = cnt;
 
 			if (sscanf(bcnt, "%llu", &cnt) != 1)
 				xtables_error(PARAMETER_PROBLEM,
 					"-%c byte counter not numeric",
 					opt2char(OPT_COUNTERS));
-			cs.fw.counters.bcnt = cnt;
+			cs.fw6.counters.bcnt = cnt;
 			break;
 
 		case 1: /* non option */
@@ -1858,7 +1846,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 					  &dmasks, &ndaddrs);
 
 	if ((nsaddrs > 1 || ndaddrs > 1) &&
-	    (cs.fw.ipv6.invflags & (IP6T_INV_SRCIP | IP6T_INV_DSTIP)))
+	    (cs.fw6.ipv6.invflags & (IP6T_INV_SRCIP | IP6T_INV_DSTIP)))
 		xtables_error(PARAMETER_PROBLEM, "! not allowed with multiple"
 			   " source or destination IP addresses");
 
@@ -1946,13 +1934,13 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			 * existant OR if the user just misspelled a
 			 * chain. */
 #ifdef IP6T_F_GOTO
-			if (cs.fw.ipv6.flags & IP6T_F_GOTO)
+			if (cs.fw6.ipv6.flags & IP6T_F_GOTO)
 				xtables_error(PARAMETER_PROBLEM,
 						"goto '%s' is not a chain\n", jumpto);
 #endif
 			xtables_find_target(jumpto, XTF_LOAD_MUST_SUCCEED);
 		} else {
-			e = generate_entry(&cs.fw, cs.matches, cs.target->t);
+			e = generate_entry(&cs.fw6, cs.matches, cs.target->t);
 			free(cs.target->t);
 		}
 	}
@@ -2035,7 +2023,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		ret = ip6tc_rename_chain(chain, newname,	*handle);
 		break;
 	case CMD_SET_POLICY:
-		ret = ip6tc_set_policy(chain, policy, cs.options&OPT_COUNTERS ? &cs.fw.counters : NULL, *handle);
+		ret = ip6tc_set_policy(chain, policy, cs.options&OPT_COUNTERS ? &cs.fw6.counters : NULL, *handle);
 		break;
 	default:
 		/* We should never reach this... */
diff --git a/iptables.c b/iptables.c
index 4303cdf..6881981 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1311,18 +1311,6 @@ get_kernel_version(void) {
 	kernel_version = LINUX_VERSION(x, y, z);
 }
 
-struct iptables_command_state {
-	struct ipt_entry fw;
-	int invert;
-	int c;
-	unsigned int options;
-	struct xtables_rule_match *matches;
-	struct xtables_target *target;
-	char *protocol;
-	int proto_used;
-	char **argv;
-};
-
 static void command_default(struct iptables_command_state *cs)
 {
 	struct xtables_rule_match *matchp;
diff --git a/xshared.h b/xshared.h
index e5b2a02..4a7f96f 100644
--- a/xshared.h
+++ b/xshared.h
@@ -1,9 +1,27 @@
 #ifndef IPTABLES_XSHARED_H
 #define IPTABLES_XSHARED_H 1
 
+#include <linux/netfilter_ipv4/ip_tables.h>
+#include <linux/netfilter_ipv6/ip6_tables.h>
+
 struct xtables_rule_match;
 struct xtables_target;
 
+struct iptables_command_state {
+	union {
+		struct ipt_entry fw;
+		struct ip6t_entry fw6;
+	};
+	int invert;
+	int c;
+	unsigned int options;
+	struct xtables_rule_match *matches;
+	struct xtables_target *target;
+	char *protocol;
+	int proto_used;
+	char **argv;
+};
+
 enum {
 	XT_OPTION_OFFSET_SCALE = 256,
 };
-- 
1.7.1

