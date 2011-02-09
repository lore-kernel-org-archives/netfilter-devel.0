From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 01/11] src: collect do_command variables in a struct
Date: Wed,  9 Feb 2011 02:48:46 +0100
Message-ID: <1297216137-18505-2-git-send-email-jengelh@medozas.de>
References: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38708 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756009Ab1BIBtD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Feb 2011 20:49:03 -0500
In-Reply-To: <1297216137-18505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This will make it easier to put the code for the cases into separate
functions.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 ip6tables.c |  323 ++++++++++++++++++++++++++++++-----------------------------
 iptables.c  |  323 ++++++++++++++++++++++++++++++-----------------------------
 2 files changed, 330 insertions(+), 316 deletions(-)

diff --git a/ip6tables.c b/ip6tables.c
index 8c1b504..cb9e1f5 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -1288,32 +1288,39 @@ static void clear_rule_matches(struct xtables_rule_match **matches)
 	*matches = NULL;
 }
 
+struct iptables_command_state {
+	struct ip6t_entry fw;
+	int invert;
+	int c;
+	unsigned int options;
+	struct xtables_rule_match *matches;
+	struct xtables_target *target;
+	char *protocol;
+	int proto_used;
+};
+
 int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **handle)
 {
-	struct ip6t_entry fw, *e = NULL;
-	int invert = 0;
+	struct iptables_command_state cs;
+	struct ip6t_entry *e = NULL;
 	unsigned int nsaddrs = 0, ndaddrs = 0;
 	struct in6_addr *saddrs = NULL, *daddrs = NULL;
 	struct in6_addr *smasks = NULL, *dmasks = NULL;
 
-	int c, verbose = 0;
+	int verbose = 0;
 	const char *chain = NULL;
 	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
 	const char *policy = NULL, *newname = NULL;
-	unsigned int rulenum = 0, options = 0, command = 0;
+	unsigned int rulenum = 0, command = 0;
 	const char *pcnt = NULL, *bcnt = NULL;
 	int ret = 1;
 	struct xtables_match *m;
-	struct xtables_rule_match *matches = NULL;
 	struct xtables_rule_match *matchp;
-	struct xtables_target *target = NULL;
 	struct xtables_target *t;
 	const char *jumpto = "";
-	char *protocol = NULL;
-	int proto_used = 0;
 	unsigned long long cnt;
 
-	memset(&fw, 0, sizeof(fw));
+	memset(&cs, 0, sizeof(cs));
 
 	/* re-set optind to 0 in case do_command gets called
 	 * a second time */
@@ -1334,22 +1341,22 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 	opterr = 0;
 
 	opts = xt_params->orig_opts;
-	while ((c = getopt_long(argc, argv,
+	while ((cs.c = getopt_long(argc, argv,
 	   "-A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
-		switch (c) {
+		switch (cs.c) {
 			/*
 			 * Command selection
 			 */
 		case 'A':
 			add_command(&command, CMD_APPEND, CMD_NONE,
-				    invert);
+				    cs.invert);
 			chain = optarg;
 			break;
 
 		case 'D':
 			add_command(&command, CMD_DELETE, CMD_NONE,
-				    invert);
+				    cs.invert);
 			chain = optarg;
 			if (optind < argc && argv[optind][0] != '-'
 			    && argv[optind][0] != '!') {
@@ -1360,7 +1367,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 		case 'R':
 			add_command(&command, CMD_REPLACE, CMD_NONE,
-				    invert);
+				    cs.invert);
 			chain = optarg;
 			if (optind < argc && argv[optind][0] != '-'
 			    && argv[optind][0] != '!')
@@ -1373,7 +1380,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 		case 'I':
 			add_command(&command, CMD_INSERT, CMD_NONE,
-				    invert);
+				    cs.invert);
 			chain = optarg;
 			if (optind < argc && argv[optind][0] != '-'
 			    && argv[optind][0] != '!')
@@ -1383,7 +1390,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 		case 'L':
 			add_command(&command, CMD_LIST,
-				    CMD_ZERO | CMD_ZERO_NUM, invert);
+				    CMD_ZERO | CMD_ZERO_NUM, cs.invert);
 			if (optarg) chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
 				 && argv[optind][0] != '!')
@@ -1395,7 +1402,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 		case 'S':
 			add_command(&command, CMD_LIST_RULES,
-				    CMD_ZERO | CMD_ZERO_NUM, invert);
+				    CMD_ZERO | CMD_ZERO_NUM, cs.invert);
 			if (optarg) chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
 				 && argv[optind][0] != '!')
@@ -1407,7 +1414,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 		case 'F':
 			add_command(&command, CMD_FLUSH, CMD_NONE,
-				    invert);
+				    cs.invert);
 			if (optarg) chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
 				 && argv[optind][0] != '!')
@@ -1416,7 +1423,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 		case 'Z':
 			add_command(&command, CMD_ZERO, CMD_LIST|CMD_LIST_RULES,
-				    invert);
+				    cs.invert);
 			if (optarg) chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
 				&& argv[optind][0] != '!')
@@ -1438,13 +1445,13 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 					   "chain name may not clash "
 					   "with target name\n");
 			add_command(&command, CMD_NEW_CHAIN, CMD_NONE,
-				    invert);
+				    cs.invert);
 			chain = optarg;
 			break;
 
 		case 'X':
 			add_command(&command, CMD_DELETE_CHAIN, CMD_NONE,
-				    invert);
+				    cs.invert);
 			if (optarg) chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
 				 && argv[optind][0] != '!')
@@ -1453,7 +1460,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 		case 'E':
 			add_command(&command, CMD_RENAME_CHAIN, CMD_NONE,
-				    invert);
+				    cs.invert);
 			chain = optarg;
 			if (optind < argc && argv[optind][0] != '-'
 			    && argv[optind][0] != '!')
@@ -1467,7 +1474,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 		case 'P':
 			add_command(&command, CMD_SET_POLICY, CMD_NONE,
-				    invert);
+				    cs.invert);
 			chain = optarg;
 			if (optind < argc && argv[optind][0] != '-'
 			    && argv[optind][0] != '!')
@@ -1483,86 +1490,86 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				optarg = argv[optind];
 
 			/* ip6tables -p icmp -h */
-			if (!matches && protocol)
-				xtables_find_match(protocol, XTF_TRY_LOAD,
-					&matches);
+			if (!cs.matches && cs.protocol)
+				xtables_find_match(cs.protocol, XTF_TRY_LOAD,
+					&cs.matches);
 
-			exit_printhelp(matches);
+			exit_printhelp(cs.matches);
 
 			/*
 			 * Option selection
 			 */
 		case 'p':
-			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
-			set_option(&options, OPT_PROTOCOL, &fw.ipv6.invflags,
-				   invert);
+			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
+			set_option(&cs.options, OPT_PROTOCOL, &cs.fw.ipv6.invflags,
+				   cs.invert);
 
 			/* Canonicalize into lower case */
-			for (protocol = optarg; *protocol; protocol++)
-				*protocol = tolower(*protocol);
+			for (cs.protocol = optarg; *cs.protocol; cs.protocol++)
+				*cs.protocol = tolower(*cs.protocol);
 
-			protocol = optarg;
-			fw.ipv6.proto = xtables_parse_protocol(protocol);
-			fw.ipv6.flags |= IP6T_F_PROTO;
+			cs.protocol = optarg;
+			cs.fw.ipv6.proto = xtables_parse_protocol(cs.protocol);
+			cs.fw.ipv6.flags |= IP6T_F_PROTO;
 
-			if (fw.ipv6.proto == 0
-			    && (fw.ipv6.invflags & IP6T_INV_PROTO))
+			if (cs.fw.ipv6.proto == 0
+			    && (cs.fw.ipv6.invflags & IP6T_INV_PROTO))
 				xtables_error(PARAMETER_PROBLEM,
 					   "rule would never match protocol");
 
-			if (is_exthdr(fw.ipv6.proto)
-			    && (fw.ipv6.invflags & IP6T_INV_PROTO) == 0)
+			if (is_exthdr(cs.fw.ipv6.proto)
+			    && (cs.fw.ipv6.invflags & IP6T_INV_PROTO) == 0)
 				fprintf(stderr,
 					"Warning: never matched protocol: %s. "
 					"use extension match instead.\n",
-					protocol);
+					cs.protocol);
 			break;
 
 		case 's':
-			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
-			set_option(&options, OPT_SOURCE, &fw.ipv6.invflags,
-				   invert);
+			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
+			set_option(&cs.options, OPT_SOURCE, &cs.fw.ipv6.invflags,
+				   cs.invert);
 			shostnetworkmask = optarg;
 			break;
 
 		case 'd':
-			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
-			set_option(&options, OPT_DESTINATION, &fw.ipv6.invflags,
-				   invert);
+			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
+			set_option(&cs.options, OPT_DESTINATION, &cs.fw.ipv6.invflags,
+				   cs.invert);
 			dhostnetworkmask = optarg;
 			break;
 
 #ifdef IP6T_F_GOTO
 		case 'g':
-			set_option(&options, OPT_JUMP, &fw.ipv6.invflags,
-					invert);
-			fw.ipv6.flags |= IP6T_F_GOTO;
+			set_option(&cs.options, OPT_JUMP, &cs.fw.ipv6.invflags,
+					cs.invert);
+			cs.fw.ipv6.flags |= IP6T_F_GOTO;
 			jumpto = parse_target(optarg);
 			break;
 #endif
 
 		case 'j':
-			set_option(&options, OPT_JUMP, &fw.ipv6.invflags,
-				   invert);
+			set_option(&cs.options, OPT_JUMP, &cs.fw.ipv6.invflags,
+				   cs.invert);
 			jumpto = parse_target(optarg);
 			/* TRY_LOAD (may be chain name) */
-			target = xtables_find_target(jumpto, XTF_TRY_LOAD);
+			cs.target = xtables_find_target(jumpto, XTF_TRY_LOAD);
 
-			if (target) {
+			if (cs.target) {
 				size_t size;
 
 				size = IP6T_ALIGN(sizeof(struct ip6t_entry_target))
-					+ target->size;
-
-				target->t = xtables_calloc(1, size);
-				target->t->u.target_size = size;
-				strcpy(target->t->u.user.name, jumpto);
-				target->t->u.user.revision = target->revision;
-				if (target->init != NULL)
-					target->init(target->t);
+					+ cs.target->size;
+
+				cs.target->t = xtables_calloc(1, size);
+				cs.target->t->u.target_size = size;
+				strcpy(cs.target->t->u.user.name, jumpto);
+				cs.target->t->u.user.revision = cs.target->revision;
+				if (cs.target->init != NULL)
+					cs.target->init(cs.target->t);
 				opts = xtables_merge_options(ip6tables_globals.orig_opts, opts,
-						     target->extra_opts,
-						     &target->option_offset);
+						     cs.target->extra_opts,
+						     &cs.target->option_offset);
 				if (opts == NULL)
 					xtables_error(OTHER_PROBLEM,
 						   "can't alloc memory!");
@@ -1575,12 +1582,12 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
-			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
-			set_option(&options, OPT_VIANAMEIN, &fw.ipv6.invflags,
-				   invert);
+			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
+			set_option(&cs.options, OPT_VIANAMEIN, &cs.fw.ipv6.invflags,
+				   cs.invert);
 			xtables_parse_interface(optarg,
-					fw.ipv6.iniface,
-					fw.ipv6.iniface_mask);
+					cs.fw.ipv6.iniface,
+					cs.fw.ipv6.iniface_mask);
 			break;
 
 		case 'o':
@@ -1588,30 +1595,30 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
-			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
-			set_option(&options, OPT_VIANAMEOUT, &fw.ipv6.invflags,
-				   invert);
+			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
+			set_option(&cs.options, OPT_VIANAMEOUT, &cs.fw.ipv6.invflags,
+				   cs.invert);
 			xtables_parse_interface(optarg,
-					fw.ipv6.outiface,
-					fw.ipv6.outiface_mask);
+					cs.fw.ipv6.outiface,
+					cs.fw.ipv6.outiface_mask);
 			break;
 
 		case 'v':
 			if (!verbose)
-				set_option(&options, OPT_VERBOSE,
-					   &fw.ipv6.invflags, invert);
+				set_option(&cs.options, OPT_VERBOSE,
+					   &cs.fw.ipv6.invflags, cs.invert);
 			verbose++;
 			break;
 
 		case 'm': {
 			size_t size;
 
-			if (invert)
+			if (cs.invert)
 				xtables_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --match");
 
 			m = xtables_find_match(optarg, XTF_LOAD_MUST_SUCCEED,
-			    &matches);
+			    &cs.matches);
 			size = IP6T_ALIGN(sizeof(struct ip6t_entry_match))
 					 + m->size;
 			m->m = xtables_calloc(1, size);
@@ -1627,24 +1634,24 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		break;
 
 		case 'n':
-			set_option(&options, OPT_NUMERIC, &fw.ipv6.invflags,
-				   invert);
+			set_option(&cs.options, OPT_NUMERIC, &cs.fw.ipv6.invflags,
+				   cs.invert);
 			break;
 
 		case 't':
-			if (invert)
+			if (cs.invert)
 				xtables_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --table");
 			*table = optarg;
 			break;
 
 		case 'x':
-			set_option(&options, OPT_EXPANDED, &fw.ipv6.invflags,
-				   invert);
+			set_option(&cs.options, OPT_EXPANDED, &cs.fw.ipv6.invflags,
+				   cs.invert);
 			break;
 
 		case 'V':
-			if (invert)
+			if (cs.invert)
 				printf("Not %s ;-)\n", prog_vers);
 			else
 				printf("%s v%s\n",
@@ -1652,8 +1659,8 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			exit(0);
 
 		case '0':
-			set_option(&options, OPT_LINENUMBERS, &fw.ipv6.invflags,
-				   invert);
+			set_option(&cs.options, OPT_LINENUMBERS, &cs.fw.ipv6.invflags,
+				   cs.invert);
 			break;
 
 		case 'M':
@@ -1662,8 +1669,8 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 		case 'c':
 
-			set_option(&options, OPT_COUNTERS, &fw.ipv6.invflags,
-				   invert);
+			set_option(&cs.options, OPT_COUNTERS, &cs.fw.ipv6.invflags,
+				   cs.invert);
 			pcnt = optarg;
 			bcnt = strchr(pcnt + 1, ',');
 			if (bcnt)
@@ -1680,22 +1687,22 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				xtables_error(PARAMETER_PROBLEM,
 					"-%c packet counter not numeric",
 					opt2char(OPT_COUNTERS));
-			fw.counters.pcnt = cnt;
+			cs.fw.counters.pcnt = cnt;
 
 			if (sscanf(bcnt, "%llu", &cnt) != 1)
 				xtables_error(PARAMETER_PROBLEM,
 					"-%c byte counter not numeric",
 					opt2char(OPT_COUNTERS));
-			fw.counters.bcnt = cnt;
+			cs.fw.counters.bcnt = cnt;
 			break;
 
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
-				if (invert)
+				if (cs.invert)
 					xtables_error(PARAMETER_PROBLEM,
 						   "multiple consecutive ! not"
 						   " allowed");
-				invert = TRUE;
+				cs.invert = TRUE;
 				optarg[0] = '\0';
 				continue;
 			}
@@ -1703,24 +1710,24 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			exit_tryhelp(2);
 
 		default:
-			if (target == NULL || target->parse == NULL ||
-			    c < target->option_offset ||
-			    c >= target->option_offset + XT_OPTION_OFFSET_SCALE ||
-			    !target->parse(c - target->option_offset,
-					       argv, invert,
-					       &target->tflags,
-					       &fw, &target->t)) {
-				for (matchp = matches; matchp; matchp = matchp->next) {
+			if (cs.target == NULL || cs.target->parse == NULL ||
+			    cs.c < cs.target->option_offset ||
+			    cs.c >= cs.target->option_offset + XT_OPTION_OFFSET_SCALE ||
+			    !cs.target->parse(cs.c - cs.target->option_offset,
+					       argv, cs.invert,
+					       &cs.target->tflags,
+					       &cs.fw, &cs.target->t)) {
+				for (matchp = cs.matches; matchp; matchp = matchp->next) {
 					if (matchp->completed ||
 					    matchp->match->parse == NULL)
 						continue;
-					if (c < matchp->match->option_offset ||
-					    c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
+					if (cs.c < matchp->match->option_offset ||
+					    cs.c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
 						continue;
-					if (matchp->match->parse(c - matchp->match->option_offset,
-						     argv, invert,
+					if (matchp->match->parse(cs.c - matchp->match->option_offset,
+						     argv, cs.invert,
 						     &matchp->match->mflags,
-						     &fw,
+						     &cs.fw,
 						     &matchp->match->m))
 						break;
 				}
@@ -1750,19 +1757,19 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				 *   loaded
 				 */
 				if (m == NULL
-				    && protocol
-				    && (!find_proto(protocol, XTF_DONT_LOAD,
-						   options&OPT_NUMERIC, NULL)
-					|| (find_proto(protocol, XTF_DONT_LOAD,
-							options&OPT_NUMERIC, NULL)
-					    && (proto_used == 0))
+				    && cs.protocol
+				    && (!find_proto(cs.protocol, XTF_DONT_LOAD,
+						   cs.options&OPT_NUMERIC, NULL)
+					|| (find_proto(cs.protocol, XTF_DONT_LOAD,
+							cs.options&OPT_NUMERIC, NULL)
+					    && (cs.proto_used == 0))
 				       )
-				    && (m = find_proto(protocol, XTF_TRY_LOAD,
-						       options&OPT_NUMERIC, &matches))) {
+				    && (m = find_proto(cs.protocol, XTF_TRY_LOAD,
+						       cs.options&OPT_NUMERIC, &cs.matches))) {
 					/* Try loading protocol */
 					size_t size;
 
-					proto_used = 1;
+					cs.proto_used = 1;
 
 					size = IP6T_ALIGN(sizeof(struct ip6t_entry_match))
 							 + m->size;
@@ -1782,7 +1789,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				}
 
 				if (!m) {
-					if (c == '?') {
+					if (cs.c == '?') {
 						if (optopt) {
 							xtables_error(
 							   PARAMETER_PROBLEM,
@@ -1803,15 +1810,15 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 				}
 			}
 		}
-		invert = FALSE;
+		cs.invert = FALSE;
 	}
 
-	for (matchp = matches; matchp; matchp = matchp->next)
+	for (matchp = cs.matches; matchp; matchp = matchp->next)
 		if (matchp->match->final_check != NULL)
 			matchp->match->final_check(matchp->match->mflags);
 
-	if (target != NULL && target->final_check != NULL)
-		target->final_check(target->tflags);
+	if (cs.target != NULL && cs.target->final_check != NULL)
+		cs.target->final_check(cs.target->tflags);
 
 	/* Fix me: must put inverse options checking here --MN */
 
@@ -1820,14 +1827,14 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 			   "unknown arguments found on commandline");
 	if (!command)
 		xtables_error(PARAMETER_PROBLEM, "no command specified");
-	if (invert)
+	if (cs.invert)
 		xtables_error(PARAMETER_PROBLEM,
 			   "nothing appropriate following !");
 
 	if (command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND)) {
-		if (!(options & OPT_DESTINATION))
+		if (!(cs.options & OPT_DESTINATION))
 			dhostnetworkmask = "::0/0";
-		if (!(options & OPT_SOURCE))
+		if (!(cs.options & OPT_SOURCE))
 			shostnetworkmask = "::0/0";
 	}
 
@@ -1840,7 +1847,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 					  &dmasks, &ndaddrs);
 
 	if ((nsaddrs > 1 || ndaddrs > 1) &&
-	    (fw.ipv6.invflags & (IP6T_INV_SRCIP | IP6T_INV_DSTIP)))
+	    (cs.fw.ipv6.invflags & (IP6T_INV_SRCIP | IP6T_INV_DSTIP)))
 		xtables_error(PARAMETER_PROBLEM, "! not allowed with multiple"
 			   " source or destination IP addresses");
 
@@ -1848,7 +1855,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		xtables_error(PARAMETER_PROBLEM, "Replacement rule does not "
 			   "specify a unique address");
 
-	generic_opt_check(command, options);
+	generic_opt_check(command, cs.options);
 
 	if (chain != NULL && strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
 		xtables_error(PARAMETER_PROBLEM,
@@ -1875,7 +1882,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		if (strcmp(chain, "PREROUTING") == 0
 		    || strcmp(chain, "INPUT") == 0) {
 			/* -o not valid with incoming packets. */
-			if (options & OPT_VIANAMEOUT)
+			if (cs.options & OPT_VIANAMEOUT)
 				xtables_error(PARAMETER_PROBLEM,
 					   "Can't use -%c with %s\n",
 					   opt2char(OPT_VIANAMEOUT),
@@ -1885,57 +1892,57 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		if (strcmp(chain, "POSTROUTING") == 0
 		    || strcmp(chain, "OUTPUT") == 0) {
 			/* -i not valid with outgoing packets */
-			if (options & OPT_VIANAMEIN)
+			if (cs.options & OPT_VIANAMEIN)
 				xtables_error(PARAMETER_PROBLEM,
 					   "Can't use -%c with %s\n",
 					   opt2char(OPT_VIANAMEIN),
 					   chain);
 		}
 
-		if (target && ip6tc_is_chain(jumpto, *handle)) {
+		if (cs.target && ip6tc_is_chain(jumpto, *handle)) {
 			fprintf(stderr,
 				"Warning: using chain %s, not extension\n",
 				jumpto);
 
-			if (target->t)
-				free(target->t);
+			if (cs.target->t)
+				free(cs.target->t);
 
-			target = NULL;
+			cs.target = NULL;
 		}
 
 		/* If they didn't specify a target, or it's a chain
 		   name, use standard. */
-		if (!target
+		if (!cs.target
 		    && (strlen(jumpto) == 0
 			|| ip6tc_is_chain(jumpto, *handle))) {
 			size_t size;
 
-			target = xtables_find_target(IP6T_STANDARD_TARGET,
+			cs.target = xtables_find_target(IP6T_STANDARD_TARGET,
 					XTF_LOAD_MUST_SUCCEED);
 
 			size = sizeof(struct ip6t_entry_target)
-				+ target->size;
-			target->t = xtables_calloc(1, size);
-			target->t->u.target_size = size;
-			strcpy(target->t->u.user.name, jumpto);
-			if (target->init != NULL)
-				target->init(target->t);
+				+ cs.target->size;
+			cs.target->t = xtables_calloc(1, size);
+			cs.target->t->u.target_size = size;
+			strcpy(cs.target->t->u.user.name, jumpto);
+			if (cs.target->init != NULL)
+				cs.target->init(cs.target->t);
 		}
 
-		if (!target) {
+		if (!cs.target) {
 			/* it is no chain, and we can't load a plugin.
 			 * We cannot know if the plugin is corrupt, non
 			 * existant OR if the user just misspelled a
 			 * chain. */
 #ifdef IP6T_F_GOTO
-			if (fw.ipv6.flags & IP6T_F_GOTO)
+			if (cs.fw.ipv6.flags & IP6T_F_GOTO)
 				xtables_error(PARAMETER_PROBLEM,
 						"goto '%s' is not a chain\n", jumpto);
 #endif
 			xtables_find_target(jumpto, XTF_LOAD_MUST_SUCCEED);
 		} else {
-			e = generate_entry(&fw, matches, target->t);
-			free(target->t);
+			e = generate_entry(&cs.fw, cs.matches, cs.target->t);
+			free(cs.target->t);
 		}
 	}
 
@@ -1944,15 +1951,15 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		ret = append_entry(chain, e,
 				   nsaddrs, saddrs, smasks,
 				   ndaddrs, daddrs, dmasks,
-				   options&OPT_VERBOSE,
+				   cs.options&OPT_VERBOSE,
 				   *handle);
 		break;
 	case CMD_DELETE:
 		ret = delete_entry(chain, e,
 				   nsaddrs, saddrs, smasks,
 				   ndaddrs, daddrs, dmasks,
-				   options&OPT_VERBOSE,
-				   *handle, matches, target);
+				   cs.options&OPT_VERBOSE,
+				   *handle, cs.matches, cs.target);
 		break;
 	case CMD_DELETE_NUM:
 		ret = ip6tc_delete_num_entry(chain, rulenum - 1, *handle);
@@ -1960,20 +1967,20 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 	case CMD_REPLACE:
 		ret = replace_entry(chain, e, rulenum - 1,
 				    saddrs, smasks, daddrs, dmasks,
-				    options&OPT_VERBOSE, *handle);
+				    cs.options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_INSERT:
 		ret = insert_entry(chain, e, rulenum - 1,
 				   nsaddrs, saddrs, smasks,
 				   ndaddrs, daddrs, dmasks,
-				   options&OPT_VERBOSE,
+				   cs.options&OPT_VERBOSE,
 				   *handle);
 		break;
 	case CMD_FLUSH:
-		ret = flush_entries(chain, options&OPT_VERBOSE, *handle);
+		ret = flush_entries(chain, cs.options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_ZERO:
-		ret = zero_entries(chain, options&OPT_VERBOSE, *handle);
+		ret = zero_entries(chain, cs.options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_ZERO_NUM:
 		ret = ip6tc_zero_counter(chain, rulenum, *handle);
@@ -1983,14 +1990,14 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 	case CMD_LIST|CMD_ZERO_NUM:
 		ret = list_entries(chain,
 				   rulenum,
-				   options&OPT_VERBOSE,
-				   options&OPT_NUMERIC,
-				   options&OPT_EXPANDED,
-				   options&OPT_LINENUMBERS,
+				   cs.options&OPT_VERBOSE,
+				   cs.options&OPT_NUMERIC,
+				   cs.options&OPT_EXPANDED,
+				   cs.options&OPT_LINENUMBERS,
 				   *handle);
 		if (ret && (command & CMD_ZERO))
 			ret = zero_entries(chain,
-					   options&OPT_VERBOSE, *handle);
+					   cs.options&OPT_VERBOSE, *handle);
 		if (ret && (command & CMD_ZERO_NUM))
 			ret = ip6tc_zero_counter(chain, rulenum, *handle);
 		break;
@@ -1999,11 +2006,11 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 	case CMD_LIST_RULES|CMD_ZERO_NUM:
 		ret = list_rules(chain,
 				   rulenum,
-				   options&OPT_VERBOSE,
+				   cs.options&OPT_VERBOSE,
 				   *handle);
 		if (ret && (command & CMD_ZERO))
 			ret = zero_entries(chain,
-					   options&OPT_VERBOSE, *handle);
+					   cs.options&OPT_VERBOSE, *handle);
 		if (ret && (command & CMD_ZERO_NUM))
 			ret = ip6tc_zero_counter(chain, rulenum, *handle);
 		break;
@@ -2011,13 +2018,13 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 		ret = ip6tc_create_chain(chain, *handle);
 		break;
 	case CMD_DELETE_CHAIN:
-		ret = delete_chain(chain, options&OPT_VERBOSE, *handle);
+		ret = delete_chain(chain, cs.options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_RENAME_CHAIN:
 		ret = ip6tc_rename_chain(chain, newname,	*handle);
 		break;
 	case CMD_SET_POLICY:
-		ret = ip6tc_set_policy(chain, policy, options&OPT_COUNTERS ? &fw.counters : NULL, *handle);
+		ret = ip6tc_set_policy(chain, policy, cs.options&OPT_COUNTERS ? &cs.fw.counters : NULL, *handle);
 		break;
 	default:
 		/* We should never reach this... */
@@ -2027,7 +2034,7 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 	if (verbose > 1)
 		dump_entries6(*handle);
 
-	clear_rule_matches(&matches);
+	clear_rule_matches(&cs.matches);
 
 	if (e != NULL) {
 		free(e);
diff --git a/iptables.c b/iptables.c
index 2459b64..5f62ae5 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1311,32 +1311,39 @@ get_kernel_version(void) {
 	kernel_version = LINUX_VERSION(x, y, z);
 }
 
+struct iptables_command_state {
+	struct ipt_entry fw;
+	int invert;
+	int c;
+	unsigned int options;
+	struct xtables_rule_match *matches;
+	struct xtables_target *target;
+	char *protocol;
+	int proto_used;
+};
+
 int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle)
 {
-	struct ipt_entry fw, *e = NULL;
-	int invert = 0;
+	struct iptables_command_state cs;
+	struct ipt_entry *e = NULL;
 	unsigned int nsaddrs = 0, ndaddrs = 0;
 	struct in_addr *saddrs = NULL, *smasks = NULL;
 	struct in_addr *daddrs = NULL, *dmasks = NULL;
 
-	int c, verbose = 0;
+	int verbose = 0;
 	const char *chain = NULL;
 	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
 	const char *policy = NULL, *newname = NULL;
-	unsigned int rulenum = 0, options = 0, command = 0;
+	unsigned int rulenum = 0, command = 0;
 	const char *pcnt = NULL, *bcnt = NULL;
 	int ret = 1;
 	struct xtables_match *m;
-	struct xtables_rule_match *matches = NULL;
 	struct xtables_rule_match *matchp;
-	struct xtables_target *target = NULL;
 	struct xtables_target *t;
 	const char *jumpto = "";
-	char *protocol = NULL;
-	int proto_used = 0;
 	unsigned long long cnt;
 
-	memset(&fw, 0, sizeof(fw));
+	memset(&cs, 0, sizeof(cs));
 
 	/* re-set optind to 0 in case do_command gets called
 	 * a second time */
@@ -1357,22 +1364,22 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 	opterr = 0;
 
 	opts = xt_params->orig_opts;
-	while ((c = getopt_long(argc, argv,
+	while ((cs.c = getopt_long(argc, argv,
 	   "-A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
-		switch (c) {
+		switch (cs.c) {
 			/*
 			 * Command selection
 			 */
 		case 'A':
 			add_command(&command, CMD_APPEND, CMD_NONE,
-				    invert);
+				    cs.invert);
 			chain = optarg;
 			break;
 
 		case 'D':
 			add_command(&command, CMD_DELETE, CMD_NONE,
-				    invert);
+				    cs.invert);
 			chain = optarg;
 			if (optind < argc && argv[optind][0] != '-'
 			    && argv[optind][0] != '!') {
@@ -1383,7 +1390,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 		case 'R':
 			add_command(&command, CMD_REPLACE, CMD_NONE,
-				    invert);
+				    cs.invert);
 			chain = optarg;
 			if (optind < argc && argv[optind][0] != '-'
 			    && argv[optind][0] != '!')
@@ -1396,7 +1403,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 		case 'I':
 			add_command(&command, CMD_INSERT, CMD_NONE,
-				    invert);
+				    cs.invert);
 			chain = optarg;
 			if (optind < argc && argv[optind][0] != '-'
 			    && argv[optind][0] != '!')
@@ -1406,7 +1413,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 		case 'L':
 			add_command(&command, CMD_LIST,
-				    CMD_ZERO | CMD_ZERO_NUM, invert);
+				    CMD_ZERO | CMD_ZERO_NUM, cs.invert);
 			if (optarg) chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
 				 && argv[optind][0] != '!')
@@ -1418,7 +1425,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 		case 'S':
 			add_command(&command, CMD_LIST_RULES,
-				    CMD_ZERO|CMD_ZERO_NUM, invert);
+				    CMD_ZERO|CMD_ZERO_NUM, cs.invert);
 			if (optarg) chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
 				 && argv[optind][0] != '!')
@@ -1430,7 +1437,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 		case 'F':
 			add_command(&command, CMD_FLUSH, CMD_NONE,
-				    invert);
+				    cs.invert);
 			if (optarg) chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
 				 && argv[optind][0] != '!')
@@ -1439,7 +1446,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 		case 'Z':
 			add_command(&command, CMD_ZERO, CMD_LIST|CMD_LIST_RULES,
-				    invert);
+				    cs.invert);
 			if (optarg) chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
 				&& argv[optind][0] != '!')
@@ -1461,13 +1468,13 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 					   "chain name may not clash "
 					   "with target name\n");
 			add_command(&command, CMD_NEW_CHAIN, CMD_NONE,
-				    invert);
+				    cs.invert);
 			chain = optarg;
 			break;
 
 		case 'X':
 			add_command(&command, CMD_DELETE_CHAIN, CMD_NONE,
-				    invert);
+				    cs.invert);
 			if (optarg) chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
 				 && argv[optind][0] != '!')
@@ -1476,7 +1483,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 		case 'E':
 			add_command(&command, CMD_RENAME_CHAIN, CMD_NONE,
-				    invert);
+				    cs.invert);
 			chain = optarg;
 			if (optind < argc && argv[optind][0] != '-'
 			    && argv[optind][0] != '!')
@@ -1490,7 +1497,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 		case 'P':
 			add_command(&command, CMD_SET_POLICY, CMD_NONE,
-				    invert);
+				    cs.invert);
 			chain = optarg;
 			if (optind < argc && argv[optind][0] != '-'
 			    && argv[optind][0] != '!')
@@ -1506,80 +1513,80 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				optarg = argv[optind];
 
 			/* iptables -p icmp -h */
-			if (!matches && protocol)
-				xtables_find_match(protocol,
-					XTF_TRY_LOAD, &matches);
+			if (!cs.matches && cs.protocol)
+				xtables_find_match(cs.protocol,
+					XTF_TRY_LOAD, &cs.matches);
 
-			exit_printhelp(matches);
+			exit_printhelp(cs.matches);
 
 			/*
 			 * Option selection
 			 */
 		case 'p':
-			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
-			set_option(&options, OPT_PROTOCOL, &fw.ip.invflags,
-				   invert);
+			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
+			set_option(&cs.options, OPT_PROTOCOL, &cs.fw.ip.invflags,
+				   cs.invert);
 
 			/* Canonicalize into lower case */
-			for (protocol = optarg; *protocol; protocol++)
-				*protocol = tolower(*protocol);
+			for (cs.protocol = optarg; *cs.protocol; cs.protocol++)
+				*cs.protocol = tolower(*cs.protocol);
 
-			protocol = optarg;
-			fw.ip.proto = xtables_parse_protocol(protocol);
+			cs.protocol = optarg;
+			cs.fw.ip.proto = xtables_parse_protocol(cs.protocol);
 
-			if (fw.ip.proto == 0
-			    && (fw.ip.invflags & IPT_INV_PROTO))
+			if (cs.fw.ip.proto == 0
+			    && (cs.fw.ip.invflags & IPT_INV_PROTO))
 				xtables_error(PARAMETER_PROBLEM,
 					   "rule would never match protocol");
 			break;
 
 		case 's':
-			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
-			set_option(&options, OPT_SOURCE, &fw.ip.invflags,
-				   invert);
+			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
+			set_option(&cs.options, OPT_SOURCE, &cs.fw.ip.invflags,
+				   cs.invert);
 			shostnetworkmask = optarg;
 			break;
 
 		case 'd':
-			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
-			set_option(&options, OPT_DESTINATION, &fw.ip.invflags,
-				   invert);
+			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
+			set_option(&cs.options, OPT_DESTINATION, &cs.fw.ip.invflags,
+				   cs.invert);
 			dhostnetworkmask = optarg;
 			break;
 
 #ifdef IPT_F_GOTO
 		case 'g':
-			set_option(&options, OPT_JUMP, &fw.ip.invflags,
-				   invert);
-			fw.ip.flags |= IPT_F_GOTO;
+			set_option(&cs.options, OPT_JUMP, &cs.fw.ip.invflags,
+				   cs.invert);
+			cs.fw.ip.flags |= IPT_F_GOTO;
 			jumpto = parse_target(optarg);
 			break;
 #endif
 
 		case 'j':
-			set_option(&options, OPT_JUMP, &fw.ip.invflags,
-				   invert);
+			set_option(&cs.options, OPT_JUMP, &cs.fw.ip.invflags,
+				   cs.invert);
 			jumpto = parse_target(optarg);
 			/* TRY_LOAD (may be chain name) */
-			target = xtables_find_target(jumpto, XTF_TRY_LOAD);
+			cs.target = xtables_find_target(jumpto, XTF_TRY_LOAD);
 
-			if (target) {
+			if (cs.target) {
 				size_t size;
 
 				size = IPT_ALIGN(sizeof(struct ipt_entry_target))
-					+ target->size;
-
-				target->t = xtables_calloc(1, size);
-				target->t->u.target_size = size;
-				strcpy(target->t->u.user.name, jumpto);
-				target->t->u.user.revision = target->revision;
-				if (target->init != NULL)
-					target->init(target->t);
+					+ cs.target->size;
+
+				cs.target->t = xtables_calloc(1, size);
+				cs.target->t->u.target_size = size;
+				strcpy(cs.target->t->u.user.name, jumpto);
+				cs.target->t->u.user.revision = cs.target->revision;
+				if (cs.target->init != NULL)
+					cs.target->init(cs.target->t);
 				opts = xtables_merge_options(
 						     iptables_globals.orig_opts,
 						     opts,
-						     target->extra_opts,
-						     &target->option_offset);
+						     cs.target->extra_opts,
+						     &cs.target->option_offset);
 				if (opts == NULL)
 					xtables_error(OTHER_PROBLEM,
 						   "can't alloc memory!");
@@ -1592,12 +1599,12 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
-			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
-			set_option(&options, OPT_VIANAMEIN, &fw.ip.invflags,
-				   invert);
+			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
+			set_option(&cs.options, OPT_VIANAMEIN, &cs.fw.ip.invflags,
+				   cs.invert);
 			xtables_parse_interface(optarg,
-					fw.ip.iniface,
-					fw.ip.iniface_mask);
+					cs.fw.ip.iniface,
+					cs.fw.ip.iniface_mask);
 			break;
 
 		case 'o':
@@ -1605,36 +1612,36 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
-			xtables_check_inverse(optarg, &invert, &optind, argc, argv);
-			set_option(&options, OPT_VIANAMEOUT, &fw.ip.invflags,
-				   invert);
+			xtables_check_inverse(optarg, &cs.invert, &optind, argc, argv);
+			set_option(&cs.options, OPT_VIANAMEOUT, &cs.fw.ip.invflags,
+				   cs.invert);
 			xtables_parse_interface(optarg,
-					fw.ip.outiface,
-					fw.ip.outiface_mask);
+					cs.fw.ip.outiface,
+					cs.fw.ip.outiface_mask);
 			break;
 
 		case 'f':
-			set_option(&options, OPT_FRAGMENT, &fw.ip.invflags,
-				   invert);
-			fw.ip.flags |= IPT_F_FRAG;
+			set_option(&cs.options, OPT_FRAGMENT, &cs.fw.ip.invflags,
+				   cs.invert);
+			cs.fw.ip.flags |= IPT_F_FRAG;
 			break;
 
 		case 'v':
 			if (!verbose)
-				set_option(&options, OPT_VERBOSE,
-					   &fw.ip.invflags, invert);
+				set_option(&cs.options, OPT_VERBOSE,
+					   &cs.fw.ip.invflags, cs.invert);
 			verbose++;
 			break;
 
 		case 'm': {
 			size_t size;
 
-			if (invert)
+			if (cs.invert)
 				xtables_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --match");
 
 			m = xtables_find_match(optarg, XTF_LOAD_MUST_SUCCEED,
-			    &matches);
+			    &cs.matches);
 			size = IPT_ALIGN(sizeof(struct ipt_entry_match))
 					 + m->size;
 			m->m = xtables_calloc(1, size);
@@ -1658,24 +1665,24 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 		break;
 
 		case 'n':
-			set_option(&options, OPT_NUMERIC, &fw.ip.invflags,
-				   invert);
+			set_option(&cs.options, OPT_NUMERIC, &cs.fw.ip.invflags,
+				   cs.invert);
 			break;
 
 		case 't':
-			if (invert)
+			if (cs.invert)
 				xtables_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --table");
 			*table = optarg;
 			break;
 
 		case 'x':
-			set_option(&options, OPT_EXPANDED, &fw.ip.invflags,
-				   invert);
+			set_option(&cs.options, OPT_EXPANDED, &cs.fw.ip.invflags,
+				   cs.invert);
 			break;
 
 		case 'V':
-			if (invert)
+			if (cs.invert)
 				printf("Not %s ;-)\n", prog_vers);
 			else
 				printf("%s v%s\n",
@@ -1683,8 +1690,8 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			exit(0);
 
 		case '0':
-			set_option(&options, OPT_LINENUMBERS, &fw.ip.invflags,
-				   invert);
+			set_option(&cs.options, OPT_LINENUMBERS, &cs.fw.ip.invflags,
+				   cs.invert);
 			break;
 
 		case 'M':
@@ -1693,8 +1700,8 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 		case 'c':
 
-			set_option(&options, OPT_COUNTERS, &fw.ip.invflags,
-				   invert);
+			set_option(&cs.options, OPT_COUNTERS, &cs.fw.ip.invflags,
+				   cs.invert);
 			pcnt = optarg;
 			bcnt = strchr(pcnt + 1, ',');
 			if (bcnt)
@@ -1711,23 +1718,23 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				xtables_error(PARAMETER_PROBLEM,
 					"-%c packet counter not numeric",
 					opt2char(OPT_COUNTERS));
-			fw.counters.pcnt = cnt;
+			cs.fw.counters.pcnt = cnt;
 
 			if (sscanf(bcnt, "%llu", &cnt) != 1)
 				xtables_error(PARAMETER_PROBLEM,
 					"-%c byte counter not numeric",
 					opt2char(OPT_COUNTERS));
-			fw.counters.bcnt = cnt;
+			cs.fw.counters.bcnt = cnt;
 			break;
 
 
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
-				if (invert)
+				if (cs.invert)
 					xtables_error(PARAMETER_PROBLEM,
 						   "multiple consecutive ! not"
 						   " allowed");
-				invert = TRUE;
+				cs.invert = TRUE;
 				optarg[0] = '\0';
 				continue;
 			}
@@ -1735,24 +1742,24 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			exit_tryhelp(2);
 
 		default:
-			if (target == NULL || target->parse == NULL ||
-			    c < target->option_offset ||
-			    c >= target->option_offset + XT_OPTION_OFFSET_SCALE ||
-			    !target->parse(c - target->option_offset,
-					       argv, invert,
-					       &target->tflags,
-					       &fw, &target->t)) {
-				for (matchp = matches; matchp; matchp = matchp->next) {
+			if (cs.target == NULL || cs.target->parse == NULL ||
+			    cs.c < cs.target->option_offset ||
+			    cs.c >= cs.target->option_offset + XT_OPTION_OFFSET_SCALE ||
+			    !cs.target->parse(cs.c - cs.target->option_offset,
+					       argv, cs.invert,
+					       &cs.target->tflags,
+					       &cs.fw, &cs.target->t)) {
+				for (matchp = cs.matches; matchp; matchp = matchp->next) {
 					if (matchp->completed ||
 					    matchp->match->parse == NULL)
 						continue;
-					if (c < matchp->match->option_offset ||
-					    c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
+					if (cs.c < matchp->match->option_offset ||
+					    cs.c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
 						continue;
-					if (matchp->match->parse(c - matchp->match->option_offset,
-						     argv, invert,
+					if (matchp->match->parse(cs.c - matchp->match->option_offset,
+						     argv, cs.invert,
 						     &matchp->match->mflags,
-						     &fw,
+						     &cs.fw,
 						     &matchp->match->m))
 						break;
 				}
@@ -1782,19 +1789,19 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				 *   loaded
 				 */
 				if (m == NULL
-				    && protocol
-				    && (!find_proto(protocol, XTF_DONT_LOAD,
-						   options&OPT_NUMERIC, NULL)
-					|| (find_proto(protocol, XTF_DONT_LOAD,
-							options&OPT_NUMERIC, NULL)
-					    && (proto_used == 0))
+				    && cs.protocol
+				    && (!find_proto(cs.protocol, XTF_DONT_LOAD,
+						   cs.options&OPT_NUMERIC, NULL)
+					|| (find_proto(cs.protocol, XTF_DONT_LOAD,
+							cs.options&OPT_NUMERIC, NULL)
+					    && (cs.proto_used == 0))
 				       )
-				    && (m = find_proto(protocol, XTF_TRY_LOAD,
-						       options&OPT_NUMERIC, &matches))) {
+				    && (m = find_proto(cs.protocol, XTF_TRY_LOAD,
+						       cs.options&OPT_NUMERIC, &cs.matches))) {
 					/* Try loading protocol */
 					size_t size;
 
-					proto_used = 1;
+					cs.proto_used = 1;
 
 					size = IPT_ALIGN(sizeof(struct ipt_entry_match))
 							 + m->size;
@@ -1819,7 +1826,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 					continue;
 				}
 				if (!m) {
-					if (c == '?') {
+					if (cs.c == '?') {
 						if (optopt) {
 							xtables_error(
 							   PARAMETER_PROBLEM,
@@ -1840,7 +1847,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 				}
 			}
 		}
-		invert = FALSE;
+		cs.invert = FALSE;
 	}
 
 	if (strcmp(*table, "nat") == 0 &&
@@ -1850,12 +1857,12 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			"\nThe \"nat\" table is not intended for filtering, "
 		        "the use of DROP is therefore inhibited.\n\n");
 
-	for (matchp = matches; matchp; matchp = matchp->next)
+	for (matchp = cs.matches; matchp; matchp = matchp->next)
 		if (matchp->match->final_check != NULL)
 			matchp->match->final_check(matchp->match->mflags);
 
-	if (target != NULL && target->final_check != NULL)
-		target->final_check(target->tflags);
+	if (cs.target != NULL && cs.target->final_check != NULL)
+		cs.target->final_check(cs.target->tflags);
 
 	/* Fix me: must put inverse options checking here --MN */
 
@@ -1864,14 +1871,14 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 			   "unknown arguments found on commandline");
 	if (!command)
 		xtables_error(PARAMETER_PROBLEM, "no command specified");
-	if (invert)
+	if (cs.invert)
 		xtables_error(PARAMETER_PROBLEM,
 			   "nothing appropriate following !");
 
 	if (command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND)) {
-		if (!(options & OPT_DESTINATION))
+		if (!(cs.options & OPT_DESTINATION))
 			dhostnetworkmask = "0.0.0.0/0";
-		if (!(options & OPT_SOURCE))
+		if (!(cs.options & OPT_SOURCE))
 			shostnetworkmask = "0.0.0.0/0";
 	}
 
@@ -1884,7 +1891,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 					 &dmasks, &ndaddrs);
 
 	if ((nsaddrs > 1 || ndaddrs > 1) &&
-	    (fw.ip.invflags & (IPT_INV_SRCIP | IPT_INV_DSTIP)))
+	    (cs.fw.ip.invflags & (IPT_INV_SRCIP | IPT_INV_DSTIP)))
 		xtables_error(PARAMETER_PROBLEM, "! not allowed with multiple"
 			   " source or destination IP addresses");
 
@@ -1892,7 +1899,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 		xtables_error(PARAMETER_PROBLEM, "Replacement rule does not "
 			   "specify a unique address");
 
-	generic_opt_check(command, options);
+	generic_opt_check(command, cs.options);
 
 	if (chain != NULL && strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
 		xtables_error(PARAMETER_PROBLEM,
@@ -1919,7 +1926,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 		if (strcmp(chain, "PREROUTING") == 0
 		    || strcmp(chain, "INPUT") == 0) {
 			/* -o not valid with incoming packets. */
-			if (options & OPT_VIANAMEOUT)
+			if (cs.options & OPT_VIANAMEOUT)
 				xtables_error(PARAMETER_PROBLEM,
 					   "Can't use -%c with %s\n",
 					   opt2char(OPT_VIANAMEOUT),
@@ -1929,59 +1936,59 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 		if (strcmp(chain, "POSTROUTING") == 0
 		    || strcmp(chain, "OUTPUT") == 0) {
 			/* -i not valid with outgoing packets */
-			if (options & OPT_VIANAMEIN)
+			if (cs.options & OPT_VIANAMEIN)
 				xtables_error(PARAMETER_PROBLEM,
 					   "Can't use -%c with %s\n",
 					   opt2char(OPT_VIANAMEIN),
 					   chain);
 		}
 
-		if (target && iptc_is_chain(jumpto, *handle)) {
+		if (cs.target && iptc_is_chain(jumpto, *handle)) {
 			fprintf(stderr,
 				"Warning: using chain %s, not extension\n",
 				jumpto);
 
-			if (target->t)
-				free(target->t);
+			if (cs.target->t)
+				free(cs.target->t);
 
-			target = NULL;
+			cs.target = NULL;
 		}
 
 		/* If they didn't specify a target, or it's a chain
 		   name, use standard. */
-		if (!target
+		if (!cs.target
 		    && (strlen(jumpto) == 0
 			|| iptc_is_chain(jumpto, *handle))) {
 			size_t size;
 
-			target = xtables_find_target(IPT_STANDARD_TARGET,
+			cs.target = xtables_find_target(IPT_STANDARD_TARGET,
 					 XTF_LOAD_MUST_SUCCEED);
 
 			size = sizeof(struct ipt_entry_target)
-				+ target->size;
-			target->t = xtables_calloc(1, size);
-			target->t->u.target_size = size;
-			strcpy(target->t->u.user.name, jumpto);
+				+ cs.target->size;
+			cs.target->t = xtables_calloc(1, size);
+			cs.target->t->u.target_size = size;
+			strcpy(cs.target->t->u.user.name, jumpto);
 			if (!iptc_is_chain(jumpto, *handle))
-				target->t->u.user.revision = target->revision;
-			if (target->init != NULL)
-				target->init(target->t);
+				cs.target->t->u.user.revision = cs.target->revision;
+			if (cs.target->init != NULL)
+				cs.target->init(cs.target->t);
 		}
 
-		if (!target) {
+		if (!cs.target) {
 			/* it is no chain, and we can't load a plugin.
 			 * We cannot know if the plugin is corrupt, non
 			 * existant OR if the user just misspelled a
 			 * chain. */
 #ifdef IPT_F_GOTO
-			if (fw.ip.flags & IPT_F_GOTO)
+			if (cs.fw.ip.flags & IPT_F_GOTO)
 				xtables_error(PARAMETER_PROBLEM,
 					   "goto '%s' is not a chain\n", jumpto);
 #endif
 			xtables_find_target(jumpto, XTF_LOAD_MUST_SUCCEED);
 		} else {
-			e = generate_entry(&fw, matches, target->t);
-			free(target->t);
+			e = generate_entry(&cs.fw, cs.matches, cs.target->t);
+			free(cs.target->t);
 		}
 	}
 
@@ -1990,15 +1997,15 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 		ret = append_entry(chain, e,
 				   nsaddrs, saddrs, smasks,
 				   ndaddrs, daddrs, dmasks,
-				   options&OPT_VERBOSE,
+				   cs.options&OPT_VERBOSE,
 				   *handle);
 		break;
 	case CMD_DELETE:
 		ret = delete_entry(chain, e,
 				   nsaddrs, saddrs, smasks,
 				   ndaddrs, daddrs, dmasks,
-				   options&OPT_VERBOSE,
-				   *handle, matches, target);
+				   cs.options&OPT_VERBOSE,
+				   *handle, cs.matches, cs.target);
 		break;
 	case CMD_DELETE_NUM:
 		ret = iptc_delete_num_entry(chain, rulenum - 1, *handle);
@@ -2006,20 +2013,20 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 	case CMD_REPLACE:
 		ret = replace_entry(chain, e, rulenum - 1,
 				    saddrs, smasks, daddrs, dmasks,
-				    options&OPT_VERBOSE, *handle);
+				    cs.options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_INSERT:
 		ret = insert_entry(chain, e, rulenum - 1,
 				   nsaddrs, saddrs, smasks,
 				   ndaddrs, daddrs, dmasks,
-				   options&OPT_VERBOSE,
+				   cs.options&OPT_VERBOSE,
 				   *handle);
 		break;
 	case CMD_FLUSH:
-		ret = flush_entries(chain, options&OPT_VERBOSE, *handle);
+		ret = flush_entries(chain, cs.options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_ZERO:
-		ret = zero_entries(chain, options&OPT_VERBOSE, *handle);
+		ret = zero_entries(chain, cs.options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_ZERO_NUM:
 		ret = iptc_zero_counter(chain, rulenum, *handle);
@@ -2029,14 +2036,14 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 	case CMD_LIST|CMD_ZERO_NUM:
 		ret = list_entries(chain,
 				   rulenum,
-				   options&OPT_VERBOSE,
-				   options&OPT_NUMERIC,
-				   options&OPT_EXPANDED,
-				   options&OPT_LINENUMBERS,
+				   cs.options&OPT_VERBOSE,
+				   cs.options&OPT_NUMERIC,
+				   cs.options&OPT_EXPANDED,
+				   cs.options&OPT_LINENUMBERS,
 				   *handle);
 		if (ret && (command & CMD_ZERO))
 			ret = zero_entries(chain,
-					   options&OPT_VERBOSE, *handle);
+					   cs.options&OPT_VERBOSE, *handle);
 		if (ret && (command & CMD_ZERO_NUM))
 			ret = iptc_zero_counter(chain, rulenum, *handle);
 		break;
@@ -2045,11 +2052,11 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 	case CMD_LIST_RULES|CMD_ZERO_NUM:
 		ret = list_rules(chain,
 				   rulenum,
-				   options&OPT_VERBOSE,
+				   cs.options&OPT_VERBOSE,
 				   *handle);
 		if (ret && (command & CMD_ZERO))
 			ret = zero_entries(chain,
-					   options&OPT_VERBOSE, *handle);
+					   cs.options&OPT_VERBOSE, *handle);
 		if (ret && (command & CMD_ZERO_NUM))
 			ret = iptc_zero_counter(chain, rulenum, *handle);
 		break;
@@ -2057,13 +2064,13 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 		ret = iptc_create_chain(chain, *handle);
 		break;
 	case CMD_DELETE_CHAIN:
-		ret = delete_chain(chain, options&OPT_VERBOSE, *handle);
+		ret = delete_chain(chain, cs.options&OPT_VERBOSE, *handle);
 		break;
 	case CMD_RENAME_CHAIN:
 		ret = iptc_rename_chain(chain, newname,	*handle);
 		break;
 	case CMD_SET_POLICY:
-		ret = iptc_set_policy(chain, policy, options&OPT_COUNTERS ? &fw.counters : NULL, *handle);
+		ret = iptc_set_policy(chain, policy, cs.options&OPT_COUNTERS ? &cs.fw.counters : NULL, *handle);
 		break;
 	default:
 		/* We should never reach this... */
@@ -2073,7 +2080,7 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 	if (verbose > 1)
 		dump_entries(*handle);
 
-	clear_rule_matches(&matches);
+	clear_rule_matches(&cs.matches);
 
 	if (e != NULL) {
 		free(e);
-- 
1.7.1

