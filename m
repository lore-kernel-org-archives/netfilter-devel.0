Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4679FC433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 17:37:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 086C261446
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 17:37:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242103AbhD1RiM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 13:38:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240644AbhD1RiG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 13:38:06 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80AEAC061574
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Apr 2021 10:37:20 -0700 (PDT)
Received: from localhost ([::1]:34736 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lbo7j-0007AS-1n; Wed, 28 Apr 2021 19:37:19 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 2/5] xshared: Eliminate iptables_command_state->invert
Date:   Wed, 28 Apr 2021 19:36:53 +0200
Message-Id: <20210428173656.16851-3-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210428173656.16851-1-phil@nwl.cc>
References: <20210428173656.16851-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This field is not used by routines working with struct
iptables_command_state: It is merely a temporary flag used by parsers to
carry the '!' prefix until invflags have been populated (or error
checking done if unsupported).

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c            | 76 +++++++++++++++-----------------
 iptables/iptables.c             | 76 +++++++++++++++-----------------
 iptables/xshared.c              | 10 ++---
 iptables/xshared.h              |  5 +--
 iptables/xtables-eb-translate.c |  1 -
 iptables/xtables-eb.c           |  1 -
 iptables/xtables.c              | 77 +++++++++++++++------------------
 7 files changed, 113 insertions(+), 133 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index c95355b091568..60db11b7131e5 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1083,6 +1083,7 @@ int do_command6(int argc, char *argv[], char **table,
 	struct xtables_target *t;
 	unsigned long long cnt;
 	bool table_set = false;
+	bool invert = false;
 
 	/* re-set optind to 0 in case do_command6 gets called
 	 * a second time */
@@ -1111,20 +1112,17 @@ int do_command6(int argc, char *argv[], char **table,
 			 * Command selection
 			 */
 		case 'A':
-			add_command(&command, CMD_APPEND, CMD_NONE,
-				    cs.invert);
+			add_command(&command, CMD_APPEND, CMD_NONE, invert);
 			chain = optarg;
 			break;
 
 		case 'C':
-			add_command(&command, CMD_CHECK, CMD_NONE,
-			            cs.invert);
+			add_command(&command, CMD_CHECK, CMD_NONE, invert);
 			chain = optarg;
 			break;
 
 		case 'D':
-			add_command(&command, CMD_DELETE, CMD_NONE,
-				    cs.invert);
+			add_command(&command, CMD_DELETE, CMD_NONE, invert);
 			chain = optarg;
 			if (xs_has_arg(argc, argv)) {
 				rulenum = parse_rulenumber(argv[optind++]);
@@ -1133,8 +1131,7 @@ int do_command6(int argc, char *argv[], char **table,
 			break;
 
 		case 'R':
-			add_command(&command, CMD_REPLACE, CMD_NONE,
-				    cs.invert);
+			add_command(&command, CMD_REPLACE, CMD_NONE, invert);
 			chain = optarg;
 			if (xs_has_arg(argc, argv))
 				rulenum = parse_rulenumber(argv[optind++]);
@@ -1145,8 +1142,7 @@ int do_command6(int argc, char *argv[], char **table,
 			break;
 
 		case 'I':
-			add_command(&command, CMD_INSERT, CMD_NONE,
-				    cs.invert);
+			add_command(&command, CMD_INSERT, CMD_NONE, invert);
 			chain = optarg;
 			if (xs_has_arg(argc, argv))
 				rulenum = parse_rulenumber(argv[optind++]);
@@ -1155,7 +1151,7 @@ int do_command6(int argc, char *argv[], char **table,
 
 		case 'L':
 			add_command(&command, CMD_LIST,
-				    CMD_ZERO | CMD_ZERO_NUM, cs.invert);
+				    CMD_ZERO | CMD_ZERO_NUM, invert);
 			if (optarg) chain = optarg;
 			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
@@ -1165,7 +1161,7 @@ int do_command6(int argc, char *argv[], char **table,
 
 		case 'S':
 			add_command(&command, CMD_LIST_RULES,
-				    CMD_ZERO | CMD_ZERO_NUM, cs.invert);
+				    CMD_ZERO | CMD_ZERO_NUM, invert);
 			if (optarg) chain = optarg;
 			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
@@ -1174,8 +1170,7 @@ int do_command6(int argc, char *argv[], char **table,
 			break;
 
 		case 'F':
-			add_command(&command, CMD_FLUSH, CMD_NONE,
-				    cs.invert);
+			add_command(&command, CMD_FLUSH, CMD_NONE, invert);
 			if (optarg) chain = optarg;
 			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
@@ -1183,7 +1178,7 @@ int do_command6(int argc, char *argv[], char **table,
 
 		case 'Z':
 			add_command(&command, CMD_ZERO, CMD_LIST|CMD_LIST_RULES,
-				    cs.invert);
+				    invert);
 			if (optarg) chain = optarg;
 			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
@@ -1195,14 +1190,13 @@ int do_command6(int argc, char *argv[], char **table,
 
 		case 'N':
 			parse_chain(optarg);
-			add_command(&command, CMD_NEW_CHAIN, CMD_NONE,
-				    cs.invert);
+			add_command(&command, CMD_NEW_CHAIN, CMD_NONE, invert);
 			chain = optarg;
 			break;
 
 		case 'X':
 			add_command(&command, CMD_DELETE_CHAIN, CMD_NONE,
-				    cs.invert);
+				    invert);
 			if (optarg) chain = optarg;
 			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
@@ -1210,7 +1204,7 @@ int do_command6(int argc, char *argv[], char **table,
 
 		case 'E':
 			add_command(&command, CMD_RENAME_CHAIN, CMD_NONE,
-				    cs.invert);
+				    invert);
 			chain = optarg;
 			if (xs_has_arg(argc, argv))
 				newname = argv[optind++];
@@ -1223,7 +1217,7 @@ int do_command6(int argc, char *argv[], char **table,
 
 		case 'P':
 			add_command(&command, CMD_SET_POLICY, CMD_NONE,
-				    cs.invert);
+				    invert);
 			chain = optarg;
 			if (xs_has_arg(argc, argv))
 				policy = argv[optind++];
@@ -1249,7 +1243,7 @@ int do_command6(int argc, char *argv[], char **table,
 			 */
 		case 'p':
 			set_option(&cs.options, OPT_PROTOCOL, &cs.fw6.ipv6.invflags,
-				   cs.invert);
+				   invert);
 
 			/* Canonicalize into lower case */
 			for (cs.protocol = optarg; *cs.protocol; cs.protocol++)
@@ -1274,20 +1268,20 @@ int do_command6(int argc, char *argv[], char **table,
 
 		case 's':
 			set_option(&cs.options, OPT_SOURCE, &cs.fw6.ipv6.invflags,
-				   cs.invert);
+				   invert);
 			shostnetworkmask = optarg;
 			break;
 
 		case 'd':
 			set_option(&cs.options, OPT_DESTINATION, &cs.fw6.ipv6.invflags,
-				   cs.invert);
+				   invert);
 			dhostnetworkmask = optarg;
 			break;
 
 #ifdef IP6T_F_GOTO
 		case 'g':
 			set_option(&cs.options, OPT_JUMP, &cs.fw6.ipv6.invflags,
-					cs.invert);
+					invert);
 			cs.fw6.ipv6.flags |= IP6T_F_GOTO;
 			cs.jumpto = xt_parse_target(optarg);
 			break;
@@ -1295,7 +1289,7 @@ int do_command6(int argc, char *argv[], char **table,
 
 		case 'j':
 			set_option(&cs.options, OPT_JUMP, &cs.fw6.ipv6.invflags,
-					cs.invert);
+					invert);
 			command_jump(&cs, optarg);
 			break;
 
@@ -1306,7 +1300,7 @@ int do_command6(int argc, char *argv[], char **table,
 					"Empty interface is likely to be "
 					"undesired");
 			set_option(&cs.options, OPT_VIANAMEIN, &cs.fw6.ipv6.invflags,
-				   cs.invert);
+				   invert);
 			xtables_parse_interface(optarg,
 					cs.fw6.ipv6.iniface,
 					cs.fw6.ipv6.iniface_mask);
@@ -1318,7 +1312,7 @@ int do_command6(int argc, char *argv[], char **table,
 					"Empty interface is likely to be "
 					"undesired");
 			set_option(&cs.options, OPT_VIANAMEOUT, &cs.fw6.ipv6.invflags,
-				   cs.invert);
+				   invert);
 			xtables_parse_interface(optarg,
 					cs.fw6.ipv6.outiface,
 					cs.fw6.ipv6.outiface_mask);
@@ -1327,7 +1321,7 @@ int do_command6(int argc, char *argv[], char **table,
 		case 'v':
 			if (!verbose)
 				set_option(&cs.options, OPT_VERBOSE,
-					   &cs.fw6.ipv6.invflags, cs.invert);
+					   &cs.fw6.ipv6.invflags, invert);
 			verbose++;
 			break;
 
@@ -1351,16 +1345,16 @@ int do_command6(int argc, char *argv[], char **table,
 			break;
 
 		case 'm':
-			command_match(&cs);
+			command_match(&cs, invert);
 			break;
 
 		case 'n':
 			set_option(&cs.options, OPT_NUMERIC, &cs.fw6.ipv6.invflags,
-				   cs.invert);
+				   invert);
 			break;
 
 		case 't':
-			if (cs.invert)
+			if (invert)
 				xtables_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --table");
 			if (restore && table_set)
@@ -1373,11 +1367,11 @@ int do_command6(int argc, char *argv[], char **table,
 
 		case 'x':
 			set_option(&cs.options, OPT_EXPANDED, &cs.fw6.ipv6.invflags,
-				   cs.invert);
+				   invert);
 			break;
 
 		case 'V':
-			if (cs.invert)
+			if (invert)
 				printf("Not %s ;-)\n", prog_vers);
 			else
 				printf("%s v%s (legacy)\n",
@@ -1386,7 +1380,7 @@ int do_command6(int argc, char *argv[], char **table,
 
 		case '0':
 			set_option(&cs.options, OPT_LINENUMBERS, &cs.fw6.ipv6.invflags,
-				   cs.invert);
+				   invert);
 			break;
 
 		case 'M':
@@ -1396,7 +1390,7 @@ int do_command6(int argc, char *argv[], char **table,
 		case 'c':
 
 			set_option(&cs.options, OPT_COUNTERS, &cs.fw6.ipv6.invflags,
-				   cs.invert);
+				   invert);
 			pcnt = optarg;
 			bcnt = strchr(pcnt + 1, ',');
 			if (bcnt)
@@ -1434,11 +1428,11 @@ int do_command6(int argc, char *argv[], char **table,
 
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
-				if (cs.invert)
+				if (invert)
 					xtables_error(PARAMETER_PROBLEM,
 						   "multiple consecutive ! not"
 						   " allowed");
-				cs.invert = true;
+				invert = true;
 				optarg[0] = '\0';
 				continue;
 			}
@@ -1446,16 +1440,16 @@ int do_command6(int argc, char *argv[], char **table,
 			exit_tryhelp(2);
 
 		default:
-			if (command_default(&cs, &ip6tables_globals) == 1)
+			if (command_default(&cs, &ip6tables_globals, invert))
 				/*
 				 * If new options were loaded, we must retry
 				 * getopt immediately and not allow
-				 * cs.invert=false to be executed.
+				 * invert=false to be executed.
 				 */
 				continue;
 			break;
 		}
-		cs.invert = false;
+		invert = false;
 	}
 
 	if (!wait && wait_interval_set)
@@ -1481,7 +1475,7 @@ int do_command6(int argc, char *argv[], char **table,
 			   "unknown arguments found on commandline");
 	if (!command)
 		xtables_error(PARAMETER_PROBLEM, "no command specified");
-	if (cs.invert)
+	if (invert)
 		xtables_error(PARAMETER_PROBLEM,
 			   "nothing appropriate following !");
 
diff --git a/iptables/iptables.c b/iptables/iptables.c
index 7d6183116d265..0976017383b4d 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1078,6 +1078,7 @@ int do_command4(int argc, char *argv[], char **table,
 	struct xtables_target *t;
 	unsigned long long cnt;
 	bool table_set = false;
+	bool invert = false;
 
 	/* re-set optind to 0 in case do_command4 gets called
 	 * a second time */
@@ -1105,20 +1106,17 @@ int do_command4(int argc, char *argv[], char **table,
 			 * Command selection
 			 */
 		case 'A':
-			add_command(&command, CMD_APPEND, CMD_NONE,
-				    cs.invert);
+			add_command(&command, CMD_APPEND, CMD_NONE, invert);
 			chain = optarg;
 			break;
 
 		case 'C':
-			add_command(&command, CMD_CHECK, CMD_NONE,
-				    cs.invert);
+			add_command(&command, CMD_CHECK, CMD_NONE, invert);
 			chain = optarg;
 			break;
 
 		case 'D':
-			add_command(&command, CMD_DELETE, CMD_NONE,
-				    cs.invert);
+			add_command(&command, CMD_DELETE, CMD_NONE, invert);
 			chain = optarg;
 			if (xs_has_arg(argc, argv)) {
 				rulenum = parse_rulenumber(argv[optind++]);
@@ -1127,8 +1125,7 @@ int do_command4(int argc, char *argv[], char **table,
 			break;
 
 		case 'R':
-			add_command(&command, CMD_REPLACE, CMD_NONE,
-				    cs.invert);
+			add_command(&command, CMD_REPLACE, CMD_NONE, invert);
 			chain = optarg;
 			if (xs_has_arg(argc, argv))
 				rulenum = parse_rulenumber(argv[optind++]);
@@ -1139,8 +1136,7 @@ int do_command4(int argc, char *argv[], char **table,
 			break;
 
 		case 'I':
-			add_command(&command, CMD_INSERT, CMD_NONE,
-				    cs.invert);
+			add_command(&command, CMD_INSERT, CMD_NONE, invert);
 			chain = optarg;
 			if (xs_has_arg(argc, argv))
 				rulenum = parse_rulenumber(argv[optind++]);
@@ -1149,7 +1145,7 @@ int do_command4(int argc, char *argv[], char **table,
 
 		case 'L':
 			add_command(&command, CMD_LIST,
-				    CMD_ZERO | CMD_ZERO_NUM, cs.invert);
+				    CMD_ZERO | CMD_ZERO_NUM, invert);
 			if (optarg) chain = optarg;
 			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
@@ -1159,7 +1155,7 @@ int do_command4(int argc, char *argv[], char **table,
 
 		case 'S':
 			add_command(&command, CMD_LIST_RULES,
-				    CMD_ZERO|CMD_ZERO_NUM, cs.invert);
+				    CMD_ZERO|CMD_ZERO_NUM, invert);
 			if (optarg) chain = optarg;
 			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
@@ -1168,8 +1164,7 @@ int do_command4(int argc, char *argv[], char **table,
 			break;
 
 		case 'F':
-			add_command(&command, CMD_FLUSH, CMD_NONE,
-				    cs.invert);
+			add_command(&command, CMD_FLUSH, CMD_NONE, invert);
 			if (optarg) chain = optarg;
 			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
@@ -1177,7 +1172,7 @@ int do_command4(int argc, char *argv[], char **table,
 
 		case 'Z':
 			add_command(&command, CMD_ZERO, CMD_LIST|CMD_LIST_RULES,
-				    cs.invert);
+				    invert);
 			if (optarg) chain = optarg;
 			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
@@ -1189,14 +1184,13 @@ int do_command4(int argc, char *argv[], char **table,
 
 		case 'N':
 			parse_chain(optarg);
-			add_command(&command, CMD_NEW_CHAIN, CMD_NONE,
-				    cs.invert);
+			add_command(&command, CMD_NEW_CHAIN, CMD_NONE, invert);
 			chain = optarg;
 			break;
 
 		case 'X':
 			add_command(&command, CMD_DELETE_CHAIN, CMD_NONE,
-				    cs.invert);
+				    invert);
 			if (optarg) chain = optarg;
 			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
@@ -1204,7 +1198,7 @@ int do_command4(int argc, char *argv[], char **table,
 
 		case 'E':
 			add_command(&command, CMD_RENAME_CHAIN, CMD_NONE,
-				    cs.invert);
+				    invert);
 			chain = optarg;
 			if (xs_has_arg(argc, argv))
 				newname = argv[optind++];
@@ -1217,7 +1211,7 @@ int do_command4(int argc, char *argv[], char **table,
 
 		case 'P':
 			add_command(&command, CMD_SET_POLICY, CMD_NONE,
-				    cs.invert);
+				    invert);
 			chain = optarg;
 			if (xs_has_arg(argc, argv))
 				policy = argv[optind++];
@@ -1243,7 +1237,7 @@ int do_command4(int argc, char *argv[], char **table,
 			 */
 		case 'p':
 			set_option(&cs.options, OPT_PROTOCOL, &cs.fw.ip.invflags,
-				   cs.invert);
+				   invert);
 
 			/* Canonicalize into lower case */
 			for (cs.protocol = optarg; *cs.protocol; cs.protocol++)
@@ -1260,20 +1254,20 @@ int do_command4(int argc, char *argv[], char **table,
 
 		case 's':
 			set_option(&cs.options, OPT_SOURCE, &cs.fw.ip.invflags,
-				   cs.invert);
+				   invert);
 			shostnetworkmask = optarg;
 			break;
 
 		case 'd':
 			set_option(&cs.options, OPT_DESTINATION, &cs.fw.ip.invflags,
-				   cs.invert);
+				   invert);
 			dhostnetworkmask = optarg;
 			break;
 
 #ifdef IPT_F_GOTO
 		case 'g':
 			set_option(&cs.options, OPT_JUMP, &cs.fw.ip.invflags,
-				   cs.invert);
+				   invert);
 			cs.fw.ip.flags |= IPT_F_GOTO;
 			cs.jumpto = xt_parse_target(optarg);
 			break;
@@ -1281,7 +1275,7 @@ int do_command4(int argc, char *argv[], char **table,
 
 		case 'j':
 			set_option(&cs.options, OPT_JUMP, &cs.fw.ip.invflags,
-				   cs.invert);
+				   invert);
 			command_jump(&cs, optarg);
 			break;
 
@@ -1292,7 +1286,7 @@ int do_command4(int argc, char *argv[], char **table,
 					"Empty interface is likely to be "
 					"undesired");
 			set_option(&cs.options, OPT_VIANAMEIN, &cs.fw.ip.invflags,
-				   cs.invert);
+				   invert);
 			xtables_parse_interface(optarg,
 					cs.fw.ip.iniface,
 					cs.fw.ip.iniface_mask);
@@ -1304,7 +1298,7 @@ int do_command4(int argc, char *argv[], char **table,
 					"Empty interface is likely to be "
 					"undesired");
 			set_option(&cs.options, OPT_VIANAMEOUT, &cs.fw.ip.invflags,
-				   cs.invert);
+				   invert);
 			xtables_parse_interface(optarg,
 					cs.fw.ip.outiface,
 					cs.fw.ip.outiface_mask);
@@ -1312,14 +1306,14 @@ int do_command4(int argc, char *argv[], char **table,
 
 		case 'f':
 			set_option(&cs.options, OPT_FRAGMENT, &cs.fw.ip.invflags,
-				   cs.invert);
+				   invert);
 			cs.fw.ip.flags |= IPT_F_FRAG;
 			break;
 
 		case 'v':
 			if (!verbose)
 				set_option(&cs.options, OPT_VERBOSE,
-					   &cs.fw.ip.invflags, cs.invert);
+					   &cs.fw.ip.invflags, invert);
 			verbose++;
 			break;
 
@@ -1343,16 +1337,16 @@ int do_command4(int argc, char *argv[], char **table,
 			break;
 
 		case 'm':
-			command_match(&cs);
+			command_match(&cs, invert);
 			break;
 
 		case 'n':
 			set_option(&cs.options, OPT_NUMERIC, &cs.fw.ip.invflags,
-				   cs.invert);
+				   invert);
 			break;
 
 		case 't':
-			if (cs.invert)
+			if (invert)
 				xtables_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --table");
 			if (restore && table_set)
@@ -1365,11 +1359,11 @@ int do_command4(int argc, char *argv[], char **table,
 
 		case 'x':
 			set_option(&cs.options, OPT_EXPANDED, &cs.fw.ip.invflags,
-				   cs.invert);
+				   invert);
 			break;
 
 		case 'V':
-			if (cs.invert)
+			if (invert)
 				printf("Not %s ;-)\n", prog_vers);
 			else
 				printf("%s v%s (legacy)\n",
@@ -1378,7 +1372,7 @@ int do_command4(int argc, char *argv[], char **table,
 
 		case '0':
 			set_option(&cs.options, OPT_LINENUMBERS, &cs.fw.ip.invflags,
-				   cs.invert);
+				   invert);
 			break;
 
 		case 'M':
@@ -1388,7 +1382,7 @@ int do_command4(int argc, char *argv[], char **table,
 		case 'c':
 
 			set_option(&cs.options, OPT_COUNTERS, &cs.fw.ip.invflags,
-				   cs.invert);
+				   invert);
 			pcnt = optarg;
 			bcnt = strchr(pcnt + 1, ',');
 			if (bcnt)
@@ -1426,11 +1420,11 @@ int do_command4(int argc, char *argv[], char **table,
 
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
-				if (cs.invert)
+				if (invert)
 					xtables_error(PARAMETER_PROBLEM,
 						   "multiple consecutive ! not"
 						   " allowed");
-				cs.invert = true;
+				invert = true;
 				optarg[0] = '\0';
 				continue;
 			}
@@ -1438,12 +1432,12 @@ int do_command4(int argc, char *argv[], char **table,
 			exit_tryhelp(2);
 
 		default:
-			if (command_default(&cs, &iptables_globals) == 1)
+			if (command_default(&cs, &iptables_globals, invert))
 				/* cf. ip6tables.c */
 				continue;
 			break;
 		}
-		cs.invert = false;
+		invert = false;
 	}
 
 	if (!wait && wait_interval_set)
@@ -1469,7 +1463,7 @@ int do_command4(int argc, char *argv[], char **table,
 			   "unknown arguments found on commandline");
 	if (!command)
 		xtables_error(PARAMETER_PROBLEM, "no command specified");
-	if (cs.invert)
+	if (invert)
 		xtables_error(PARAMETER_PROBLEM,
 			   "nothing appropriate following !");
 
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 71f689901e1d4..18d8735f3211c 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -115,7 +115,7 @@ struct xtables_match *load_proto(struct iptables_command_state *cs)
 }
 
 int command_default(struct iptables_command_state *cs,
-		    struct xtables_globals *gl)
+		    struct xtables_globals *gl, bool invert)
 {
 	struct xtables_rule_match *matchp;
 	struct xtables_match *m;
@@ -124,7 +124,7 @@ int command_default(struct iptables_command_state *cs,
 	    (cs->target->parse != NULL || cs->target->x6_parse != NULL) &&
 	    cs->c >= cs->target->option_offset &&
 	    cs->c < cs->target->option_offset + XT_OPTION_OFFSET_SCALE) {
-		xtables_option_tpcall(cs->c, cs->argv, cs->invert,
+		xtables_option_tpcall(cs->c, cs->argv, invert,
 				      cs->target, &cs->fw);
 		return 0;
 	}
@@ -138,7 +138,7 @@ int command_default(struct iptables_command_state *cs,
 		if (cs->c < matchp->match->option_offset ||
 		    cs->c >= matchp->match->option_offset + XT_OPTION_OFFSET_SCALE)
 			continue;
-		xtables_option_mpcall(cs->c, cs->argv, cs->invert, m, &cs->fw);
+		xtables_option_mpcall(cs->c, cs->argv, invert, m, &cs->fw);
 		return 0;
 	}
 
@@ -641,13 +641,13 @@ void print_ifaces(const char *iniface, const char *outiface, uint8_t invflags,
 	printf(FMT("%-6s ", "out %s "), iface);
 }
 
-void command_match(struct iptables_command_state *cs)
+void command_match(struct iptables_command_state *cs, bool invert)
 {
 	struct option *opts = xt_params->opts;
 	struct xtables_match *m;
 	size_t size;
 
-	if (cs->invert)
+	if (invert)
 		xtables_error(PARAMETER_PROBLEM,
 			   "unexpected ! flag before --match");
 
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 9159b2b1f3768..c2ecb4aed641b 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -125,7 +125,6 @@ struct iptables_command_state {
 		struct ip6t_entry fw6;
 		struct arpt_entry arp;
 	};
-	int invert;
 	int c;
 	unsigned int options;
 	struct xtables_rule_match *matches;
@@ -154,7 +153,7 @@ extern void print_extension_helps(const struct xtables_target *,
 	const struct xtables_rule_match *);
 extern const char *proto_to_name(uint8_t, int);
 extern int command_default(struct iptables_command_state *,
-	struct xtables_globals *);
+	struct xtables_globals *, bool invert);
 extern struct xtables_match *load_proto(struct iptables_command_state *);
 extern int subcmd_main(int, char **, const struct subcommand *);
 extern void xs_init_target(struct xtables_target *);
@@ -212,7 +211,7 @@ void print_ipv6_addresses(const struct ip6t_entry *fw6, unsigned int format);
 void print_ifaces(const char *iniface, const char *outiface, uint8_t invflags,
 		  unsigned int format);
 
-void command_match(struct iptables_command_state *cs);
+void command_match(struct iptables_command_state *cs, bool invert);
 const char *xt_parse_target(const char *targetname);
 void command_jump(struct iptables_command_state *cs, const char *jumpto);
 
diff --git a/iptables/xtables-eb-translate.c b/iptables/xtables-eb-translate.c
index 83ae77cb07fb2..04b3dfa0bf455 100644
--- a/iptables/xtables-eb-translate.c
+++ b/iptables/xtables-eb-translate.c
@@ -220,7 +220,6 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 	while ((c = getopt_long(argc, argv,
 	   "-A:D:I:N:E:X::L::Z::F::P:Vhi:o:j:c:p:s:d:t:M:", opts, NULL)) != -1) {
 		cs.c = c;
-		cs.invert = ebt_invert;
 		switch (c) {
 		case 'A': /* Add a rule */
 		case 'D': /* Delete a rule */
diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index 5bb34d6d292a9..6c58adaa66c1e 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -751,7 +751,6 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table,
 	while ((c = getopt_long(argc, argv,
 	   "-A:D:C:I:N:E:X::L::Z::F::P:Vhi:o:j:c:p:s:d:t:M:", opts, NULL)) != -1) {
 		cs.c = c;
-		cs.invert = ebt_invert;
 		switch (c) {
 
 		case 'A': /* Add a rule */
diff --git a/iptables/xtables.c b/iptables/xtables.c
index c3d82014778b2..73531ca88b517 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -240,7 +240,7 @@ xtables_exit_error(enum xtables_exittype status, const char *msg, ...)
 
 static void
 set_option(unsigned int *options, unsigned int option, u_int16_t *invflg,
-	   int invert)
+	   bool invert)
 {
 	if (*options & option)
 		xtables_error(PARAMETER_PROBLEM, "multiple -%c flags not allowed",
@@ -466,6 +466,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 	struct timeval wait_interval;
 	struct xtables_target *t;
 	bool table_set = false;
+	bool invert = false;
 	int wait = 0;
 
 	memset(cs, 0, sizeof(*cs));
@@ -499,20 +500,17 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			 * Command selection
 			 */
 		case 'A':
-			add_command(&p->command, CMD_APPEND, CMD_NONE,
-				    cs->invert);
+			add_command(&p->command, CMD_APPEND, CMD_NONE, invert);
 			p->chain = optarg;
 			break;
 
 		case 'C':
-			add_command(&p->command, CMD_CHECK, CMD_NONE,
-				    cs->invert);
+			add_command(&p->command, CMD_CHECK, CMD_NONE, invert);
 			p->chain = optarg;
 			break;
 
 		case 'D':
-			add_command(&p->command, CMD_DELETE, CMD_NONE,
-				    cs->invert);
+			add_command(&p->command, CMD_DELETE, CMD_NONE, invert);
 			p->chain = optarg;
 			if (xs_has_arg(argc, argv)) {
 				p->rulenum = parse_rulenumber(argv[optind++]);
@@ -521,8 +519,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			break;
 
 		case 'R':
-			add_command(&p->command, CMD_REPLACE, CMD_NONE,
-				    cs->invert);
+			add_command(&p->command, CMD_REPLACE, CMD_NONE, invert);
 			p->chain = optarg;
 			if (xs_has_arg(argc, argv))
 				p->rulenum = parse_rulenumber(argv[optind++]);
@@ -533,8 +530,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			break;
 
 		case 'I':
-			add_command(&p->command, CMD_INSERT, CMD_NONE,
-				    cs->invert);
+			add_command(&p->command, CMD_INSERT, CMD_NONE, invert);
 			p->chain = optarg;
 			if (xs_has_arg(argc, argv))
 				p->rulenum = parse_rulenumber(argv[optind++]);
@@ -544,7 +540,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 
 		case 'L':
 			add_command(&p->command, CMD_LIST,
-				    CMD_ZERO | CMD_ZERO_NUM, cs->invert);
+				    CMD_ZERO | CMD_ZERO_NUM, invert);
 			if (optarg)
 				p->chain = optarg;
 			else if (xs_has_arg(argc, argv))
@@ -555,7 +551,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 
 		case 'S':
 			add_command(&p->command, CMD_LIST_RULES,
-				    CMD_ZERO|CMD_ZERO_NUM, cs->invert);
+				    CMD_ZERO|CMD_ZERO_NUM, invert);
 			if (optarg)
 				p->chain = optarg;
 			else if (xs_has_arg(argc, argv))
@@ -565,8 +561,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			break;
 
 		case 'F':
-			add_command(&p->command, CMD_FLUSH, CMD_NONE,
-				    cs->invert);
+			add_command(&p->command, CMD_FLUSH, CMD_NONE, invert);
 			if (optarg)
 				p->chain = optarg;
 			else if (xs_has_arg(argc, argv))
@@ -575,7 +570,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 
 		case 'Z':
 			add_command(&p->command, CMD_ZERO,
-				    CMD_LIST|CMD_LIST_RULES, cs->invert);
+				    CMD_LIST|CMD_LIST_RULES, invert);
 			if (optarg)
 				p->chain = optarg;
 			else if (xs_has_arg(argc, argv))
@@ -596,13 +591,13 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 					   "chain name may not clash "
 					   "with target name\n");
 			add_command(&p->command, CMD_NEW_CHAIN, CMD_NONE,
-				    cs->invert);
+				    invert);
 			p->chain = optarg;
 			break;
 
 		case 'X':
 			add_command(&p->command, CMD_DELETE_CHAIN, CMD_NONE,
-				    cs->invert);
+				    invert);
 			if (optarg)
 				p->chain = optarg;
 			else if (xs_has_arg(argc, argv))
@@ -611,7 +606,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 
 		case 'E':
 			add_command(&p->command, CMD_RENAME_CHAIN, CMD_NONE,
-				    cs->invert);
+				    invert);
 			p->chain = optarg;
 			if (xs_has_arg(argc, argv))
 				p->newname = argv[optind++];
@@ -624,7 +619,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 
 		case 'P':
 			add_command(&p->command, CMD_SET_POLICY, CMD_NONE,
-				    cs->invert);
+				    invert);
 			p->chain = optarg;
 			if (xs_has_arg(argc, argv))
 				p->policy = argv[optind++];
@@ -652,7 +647,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			 */
 		case 'p':
 			set_option(&cs->options, OPT_PROTOCOL,
-				   &args->invflags, cs->invert);
+				   &args->invflags, invert);
 
 			/* Canonicalize into lower case */
 			for (cs->protocol = optarg; *cs->protocol; cs->protocol++)
@@ -672,20 +667,20 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 
 		case 's':
 			set_option(&cs->options, OPT_SOURCE,
-				   &args->invflags, cs->invert);
+				   &args->invflags, invert);
 			args->shostnetworkmask = optarg;
 			break;
 
 		case 'd':
 			set_option(&cs->options, OPT_DESTINATION,
-				   &args->invflags, cs->invert);
+				   &args->invflags, invert);
 			args->dhostnetworkmask = optarg;
 			break;
 
 #ifdef IPT_F_GOTO
 		case 'g':
 			set_option(&cs->options, OPT_JUMP, &args->invflags,
-				   cs->invert);
+				   invert);
 			args->goto_set = true;
 			cs->jumpto = xt_parse_target(optarg);
 			break;
@@ -693,7 +688,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 
 		case 'j':
 			set_option(&cs->options, OPT_JUMP, &args->invflags,
-				   cs->invert);
+				   invert);
 			command_jump(cs, optarg);
 			break;
 
@@ -704,7 +699,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 					"Empty interface is likely to be "
 					"undesired");
 			set_option(&cs->options, OPT_VIANAMEIN,
-				   &args->invflags, cs->invert);
+				   &args->invflags, invert);
 			xtables_parse_interface(optarg,
 						args->iniface,
 						args->iniface_mask);
@@ -716,7 +711,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 					"Empty interface is likely to be "
 					"undesired");
 			set_option(&cs->options, OPT_VIANAMEOUT,
-				   &args->invflags, cs->invert);
+				   &args->invflags, invert);
 			xtables_parse_interface(optarg,
 						args->outiface,
 						args->outiface_mask);
@@ -729,28 +724,28 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 					"use -m frag instead");
 			}
 			set_option(&cs->options, OPT_FRAGMENT, &args->invflags,
-				   cs->invert);
+				   invert);
 			args->flags |= IPT_F_FRAG;
 			break;
 
 		case 'v':
 			if (!p->verbose)
 				set_option(&cs->options, OPT_VERBOSE,
-					   &args->invflags, cs->invert);
+					   &args->invflags, invert);
 			p->verbose++;
 			break;
 
 		case 'm':
-			command_match(cs);
+			command_match(cs, invert);
 			break;
 
 		case 'n':
 			set_option(&cs->options, OPT_NUMERIC, &args->invflags,
-				   cs->invert);
+				   invert);
 			break;
 
 		case 't':
-			if (cs->invert)
+			if (invert)
 				xtables_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --table");
 			if (p->restore && table_set)
@@ -767,11 +762,11 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 
 		case 'x':
 			set_option(&cs->options, OPT_EXPANDED, &args->invflags,
-				   cs->invert);
+				   invert);
 			break;
 
 		case 'V':
-			if (cs->invert)
+			if (invert)
 				printf("Not %s ;-)\n", prog_vers);
 			else
 				printf("%s v%s (nf_tables)\n",
@@ -801,7 +796,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 
 		case '0':
 			set_option(&cs->options, OPT_LINENUMBERS,
-				   &args->invflags, cs->invert);
+				   &args->invflags, invert);
 			break;
 
 		case 'M':
@@ -810,7 +805,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 
 		case 'c':
 			set_option(&cs->options, OPT_COUNTERS, &args->invflags,
-				   cs->invert);
+				   invert);
 			args->pcnt = optarg;
 			args->bcnt = strchr(args->pcnt + 1, ',');
 			if (args->bcnt)
@@ -853,11 +848,11 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
-				if (cs->invert)
+				if (invert)
 					xtables_error(PARAMETER_PROBLEM,
 						   "multiple consecutive ! not"
 						   " allowed");
-				cs->invert = true;
+				invert = true;
 				optarg[0] = '\0';
 				continue;
 			}
@@ -865,12 +860,12 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			exit_tryhelp(2);
 
 		default:
-			if (command_default(cs, &xtables_globals) == 1)
+			if (command_default(cs, &xtables_globals, invert))
 				/* cf. ip6tables.c */
 				continue;
 			break;
 		}
-		cs->invert = false;
+		invert = false;
 	}
 
 	if (strcmp(p->table, "nat") == 0 &&
@@ -896,7 +891,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			   "unknown arguments found on commandline");
 	if (!p->command)
 		xtables_error(PARAMETER_PROBLEM, "no command specified");
-	if (cs->invert)
+	if (invert)
 		xtables_error(PARAMETER_PROBLEM,
 			   "nothing appropriate following !");
 
-- 
2.31.0

