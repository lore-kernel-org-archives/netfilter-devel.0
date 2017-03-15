From: Lorenzo Colitti <lorenzo@google.com>
Subject: [PATCH iptables 1/2] iptables: remove duplicated argument parsing code
Date: Wed, 15 Mar 2017 22:45:52 +0900
Message-ID: <20170315134553.35772-2-lorenzo@google.com>
References: <20170315134553.35772-1-lorenzo@google.com>
Cc: pablo@netfilter.org, jscherpelz@google.com,
        subashab@codeaurora.org, zlpnobody@gmail.com,
        Lorenzo Colitti <lorenzo@google.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f52.google.com ([74.125.83.52]:36231 "EHLO
        mail-pg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751152AbdCONqJ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2017 09:46:09 -0400
Received: by mail-pg0-f52.google.com with SMTP id g2so9445972pge.3
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2017 06:46:08 -0700 (PDT)
In-Reply-To: <20170315134553.35772-1-lorenzo@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

1. Factor out repeated code to a new xs_has_arg function.
2. Add a new parse_wait_time option to parse the value of -w.
3. Make parse_wait_interval take argc and argv so its callers
   can be simpler.

Signed-off-by: Lorenzo Colitti <lorenzo@google.com>
---
 iptables/ip6tables.c   | 62 +++++++++++++-------------------------------------
 iptables/iptables.c    | 62 +++++++++++++-------------------------------------
 iptables/xshared.c     | 35 ++++++++++++++++++++++++++--
 iptables/xshared.h     |  4 +++-
 iptables/xtables-arp.c | 30 ++++++++----------------
 iptables/xtables.c     | 58 ++++++++++++++--------------------------------
 6 files changed, 95 insertions(+), 156 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index 0bd415dec5..4d77721b04 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -1400,8 +1400,7 @@ int do_command6(int argc, char *argv[], char **table,
 			add_command(&command, CMD_DELETE, CMD_NONE,
 				    cs.invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!') {
+			if (xs_has_arg(argc, argv)) {
 				rulenum = parse_rulenumber(argv[optind++]);
 				command = CMD_DELETE_NUM;
 			}
@@ -1411,8 +1410,7 @@ int do_command6(int argc, char *argv[], char **table,
 			add_command(&command, CMD_REPLACE, CMD_NONE,
 				    cs.invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				rulenum = parse_rulenumber(argv[optind++]);
 			else
 				xtables_error(PARAMETER_PROBLEM,
@@ -1424,8 +1422,7 @@ int do_command6(int argc, char *argv[], char **table,
 			add_command(&command, CMD_INSERT, CMD_NONE,
 				    cs.invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				rulenum = parse_rulenumber(argv[optind++]);
 			else rulenum = 1;
 			break;
@@ -1434,11 +1431,9 @@ int do_command6(int argc, char *argv[], char **table,
 			add_command(&command, CMD_LIST,
 				    CMD_ZERO | CMD_ZERO_NUM, cs.invert);
 			if (optarg) chain = optarg;
-			else if (optind < argc && argv[optind][0] != '-'
-				 && argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				rulenum = parse_rulenumber(argv[optind++]);
 			break;
 
@@ -1446,11 +1441,9 @@ int do_command6(int argc, char *argv[], char **table,
 			add_command(&command, CMD_LIST_RULES,
 				    CMD_ZERO | CMD_ZERO_NUM, cs.invert);
 			if (optarg) chain = optarg;
-			else if (optind < argc && argv[optind][0] != '-'
-				 && argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				rulenum = parse_rulenumber(argv[optind++]);
 			break;
 
@@ -1458,8 +1451,7 @@ int do_command6(int argc, char *argv[], char **table,
 			add_command(&command, CMD_FLUSH, CMD_NONE,
 				    cs.invert);
 			if (optarg) chain = optarg;
-			else if (optind < argc && argv[optind][0] != '-'
-				 && argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
 			break;
 
@@ -1467,11 +1459,9 @@ int do_command6(int argc, char *argv[], char **table,
 			add_command(&command, CMD_ZERO, CMD_LIST|CMD_LIST_RULES,
 				    cs.invert);
 			if (optarg) chain = optarg;
-			else if (optind < argc && argv[optind][0] != '-'
-				&& argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
-			if (optind < argc && argv[optind][0] != '-'
-				&& argv[optind][0] != '!') {
+			if (xs_has_arg(argc, argv)) {
 				rulenum = parse_rulenumber(argv[optind++]);
 				command = CMD_ZERO_NUM;
 			}
@@ -1488,8 +1478,7 @@ int do_command6(int argc, char *argv[], char **table,
 			add_command(&command, CMD_DELETE_CHAIN, CMD_NONE,
 				    cs.invert);
 			if (optarg) chain = optarg;
-			else if (optind < argc && argv[optind][0] != '-'
-				 && argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
 			break;
 
@@ -1497,8 +1486,7 @@ int do_command6(int argc, char *argv[], char **table,
 			add_command(&command, CMD_RENAME_CHAIN, CMD_NONE,
 				    cs.invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				newname = argv[optind++];
 			else
 				xtables_error(PARAMETER_PROBLEM,
@@ -1511,8 +1499,7 @@ int do_command6(int argc, char *argv[], char **table,
 			add_command(&command, CMD_SET_POLICY, CMD_NONE,
 				    cs.invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				policy = argv[optind++];
 			else
 				xtables_error(PARAMETER_PROBLEM,
@@ -1622,16 +1609,7 @@ int do_command6(int argc, char *argv[], char **table,
 					      "You cannot use `-w' from "
 					      "ip6tables-restore");
 			}
-			wait = -1;
-			if (optarg) {
-				if (sscanf(optarg, "%i", &wait) != 1)
-					xtables_error(PARAMETER_PROBLEM,
-						"wait seconds not numeric");
-			} else if (optind < argc && argv[optind][0] != '-'
-						 && argv[optind][0] != '!')
-				if (sscanf(argv[optind++], "%i", &wait) != 1)
-					xtables_error(PARAMETER_PROBLEM,
-						"wait seconds not numeric");
+			wait = parse_wait_time(argc, argv);
 			break;
 
 		case 'W':
@@ -1640,14 +1618,7 @@ int do_command6(int argc, char *argv[], char **table,
 					      "You cannot use `-W' from "
 					      "ip6tables-restore");
 			}
-			if (optarg)
-				parse_wait_interval(optarg, &wait_interval);
-			else if (optind < argc &&
-				argv[optind][0] != '-' &&
-				argv[optind][0] != '!')
-				parse_wait_interval(argv[optind++],
-						    &wait_interval);
-
+			parse_wait_interval(argc, argv, &wait_interval);
 			wait_interval_set = true;
 			break;
 
@@ -1697,8 +1668,7 @@ int do_command6(int argc, char *argv[], char **table,
 			bcnt = strchr(pcnt + 1, ',');
 			if (bcnt)
 			    bcnt++;
-			if (!bcnt && optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (!bcnt && xs_has_arg(argc, argv))
 				bcnt = argv[optind++];
 			if (!bcnt)
 				xtables_error(PARAMETER_PROBLEM,
diff --git a/iptables/iptables.c b/iptables/iptables.c
index e0d092f0b6..04be5abb10 100644
--- a/iptables/iptables.c
+++ b/iptables/iptables.c
@@ -1393,8 +1393,7 @@ int do_command4(int argc, char *argv[], char **table,
 			add_command(&command, CMD_DELETE, CMD_NONE,
 				    cs.invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!') {
+			if (xs_has_arg(argc, argv)) {
 				rulenum = parse_rulenumber(argv[optind++]);
 				command = CMD_DELETE_NUM;
 			}
@@ -1404,8 +1403,7 @@ int do_command4(int argc, char *argv[], char **table,
 			add_command(&command, CMD_REPLACE, CMD_NONE,
 				    cs.invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				rulenum = parse_rulenumber(argv[optind++]);
 			else
 				xtables_error(PARAMETER_PROBLEM,
@@ -1417,8 +1415,7 @@ int do_command4(int argc, char *argv[], char **table,
 			add_command(&command, CMD_INSERT, CMD_NONE,
 				    cs.invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				rulenum = parse_rulenumber(argv[optind++]);
 			else rulenum = 1;
 			break;
@@ -1427,11 +1424,9 @@ int do_command4(int argc, char *argv[], char **table,
 			add_command(&command, CMD_LIST,
 				    CMD_ZERO | CMD_ZERO_NUM, cs.invert);
 			if (optarg) chain = optarg;
-			else if (optind < argc && argv[optind][0] != '-'
-				 && argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				rulenum = parse_rulenumber(argv[optind++]);
 			break;
 
@@ -1439,11 +1434,9 @@ int do_command4(int argc, char *argv[], char **table,
 			add_command(&command, CMD_LIST_RULES,
 				    CMD_ZERO|CMD_ZERO_NUM, cs.invert);
 			if (optarg) chain = optarg;
-			else if (optind < argc && argv[optind][0] != '-'
-				 && argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				rulenum = parse_rulenumber(argv[optind++]);
 			break;
 
@@ -1451,8 +1444,7 @@ int do_command4(int argc, char *argv[], char **table,
 			add_command(&command, CMD_FLUSH, CMD_NONE,
 				    cs.invert);
 			if (optarg) chain = optarg;
-			else if (optind < argc && argv[optind][0] != '-'
-				 && argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
 			break;
 
@@ -1460,11 +1452,9 @@ int do_command4(int argc, char *argv[], char **table,
 			add_command(&command, CMD_ZERO, CMD_LIST|CMD_LIST_RULES,
 				    cs.invert);
 			if (optarg) chain = optarg;
-			else if (optind < argc && argv[optind][0] != '-'
-				&& argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
-			if (optind < argc && argv[optind][0] != '-'
-				&& argv[optind][0] != '!') {
+			if (xs_has_arg(argc, argv)) {
 				rulenum = parse_rulenumber(argv[optind++]);
 				command = CMD_ZERO_NUM;
 			}
@@ -1481,8 +1471,7 @@ int do_command4(int argc, char *argv[], char **table,
 			add_command(&command, CMD_DELETE_CHAIN, CMD_NONE,
 				    cs.invert);
 			if (optarg) chain = optarg;
-			else if (optind < argc && argv[optind][0] != '-'
-				 && argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
 			break;
 
@@ -1490,8 +1479,7 @@ int do_command4(int argc, char *argv[], char **table,
 			add_command(&command, CMD_RENAME_CHAIN, CMD_NONE,
 				    cs.invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				newname = argv[optind++];
 			else
 				xtables_error(PARAMETER_PROBLEM,
@@ -1504,8 +1492,7 @@ int do_command4(int argc, char *argv[], char **table,
 			add_command(&command, CMD_SET_POLICY, CMD_NONE,
 				    cs.invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				policy = argv[optind++];
 			else
 				xtables_error(PARAMETER_PROBLEM,
@@ -1613,16 +1600,7 @@ int do_command4(int argc, char *argv[], char **table,
 					      "You cannot use `-w' from "
 					      "iptables-restore");
 			}
-			wait = -1;
-			if (optarg) {
-				if (sscanf(optarg, "%i", &wait) != 1)
-					xtables_error(PARAMETER_PROBLEM,
-						"wait seconds not numeric");
-			} else if (optind < argc && argv[optind][0] != '-'
-						 && argv[optind][0] != '!')
-				if (sscanf(argv[optind++], "%i", &wait) != 1)
-					xtables_error(PARAMETER_PROBLEM,
-						"wait seconds not numeric");
+			wait = parse_wait_time(argc, argv);
 			break;
 
 		case 'W':
@@ -1631,14 +1609,7 @@ int do_command4(int argc, char *argv[], char **table,
 					      "You cannot use `-W' from "
 					      "iptables-restore");
 			}
-			if (optarg)
-				parse_wait_interval(optarg, &wait_interval);
-			else if (optind < argc &&
-				 argv[optind][0] != '-' &&
-				 argv[optind][0] != '!')
-				parse_wait_interval(argv[optind++],
-						    &wait_interval);
-
+			parse_wait_interval(argc, argv, &wait_interval);
 			wait_interval_set = true;
 			break;
 
@@ -1688,8 +1659,7 @@ int do_command4(int argc, char *argv[], char **table,
 			bcnt = strchr(pcnt + 1, ',');
 			if (bcnt)
 			    bcnt++;
-			if (!bcnt && optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (!bcnt && xs_has_arg(argc, argv))
 				bcnt = argv[optind++];
 			if (!bcnt)
 				xtables_error(PARAMETER_PROBLEM,
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 383ecf2cf2..dd5f8be028 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -284,12 +284,36 @@ bool xtables_lock(int wait, struct timeval *wait_interval)
 	}
 }
 
-void parse_wait_interval(const char *str, struct timeval *wait_interval)
+int parse_wait_time(int argc, char *argv[])
 {
+	int wait = -1;
+
+	if (optarg) {
+		if (sscanf(optarg, "%i", &wait) != 1)
+			xtables_error(PARAMETER_PROBLEM,
+				"wait seconds not numeric");
+	} else if (xs_has_arg(argc, argv))
+		if (sscanf(argv[optind++], "%i", &wait) != 1)
+			xtables_error(PARAMETER_PROBLEM,
+				"wait seconds not numeric");
+
+	return wait;
+}
+
+void parse_wait_interval(int argc, char *argv[], struct timeval *wait_interval)
+{
+	const char *arg;
 	unsigned int usec;
 	int ret;
 
-	ret = sscanf(str, "%u", &usec);
+	if (optarg)
+		arg = optarg;
+	else if (xs_has_arg(argc, argv))
+		arg = argv[optind++];
+	else
+		return;
+
+	ret = sscanf(arg, "%u", &usec);
 	if (ret == 1) {
 		if (usec > 999999)
 			xtables_error(PARAMETER_PROBLEM,
@@ -302,3 +326,10 @@ void parse_wait_interval(const char *str, struct timeval *wait_interval)
 	}
 	xtables_error(PARAMETER_PROBLEM, "wait interval not numeric");
 }
+
+inline bool xs_has_arg(int argc, char *argv[])
+{
+	return optind < argc &&
+	       argv[optind][0] != '-' &&
+	       argv[optind][0] != '!';
+}
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 18b1cf3764..d8a697ae66 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -88,7 +88,9 @@ extern void xs_init_target(struct xtables_target *);
 extern void xs_init_match(struct xtables_match *);
 bool xtables_lock(int wait, struct timeval *wait_interval);
 
-void parse_wait_interval(const char *str, struct timeval *wait_interval);
+int parse_wait_time(int argc, char *argv[]);
+void parse_wait_interval(int argc, char *argv[], struct timeval *wait_interval);
+bool xs_has_arg(int argc, char *argv[]);
 
 extern const struct xtables_afinfo *afinfo;
 
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index bd6d57c2d8..6aa000a14d 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -984,8 +984,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 			add_command(&command, CMD_DELETE, CMD_NONE,
 				    invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!') {
+			if (xs_has_arg(argc, argv)) {
 				rulenum = parse_rulenumber(argv[optind++]);
 				command = CMD_DELETE_NUM;
 			}
@@ -995,8 +994,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 			add_command(&command, CMD_REPLACE, CMD_NONE,
 				    invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				rulenum = parse_rulenumber(argv[optind++]);
 			else
 				xtables_error(PARAMETER_PROBLEM,
@@ -1008,8 +1006,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 			add_command(&command, CMD_INSERT, CMD_NONE,
 				    invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				rulenum = parse_rulenumber(argv[optind++]);
 			else rulenum = 1;
 			break;
@@ -1018,8 +1015,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 			add_command(&command, CMD_LIST, CMD_ZERO,
 				    invert);
 			if (optarg) chain = optarg;
-			else if (optind < argc && argv[optind][0] != '-'
-				 && argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
 			break;
 
@@ -1027,8 +1023,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 			add_command(&command, CMD_FLUSH, CMD_NONE,
 				    invert);
 			if (optarg) chain = optarg;
-			else if (optind < argc && argv[optind][0] != '-'
-				 && argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
 			break;
 
@@ -1036,8 +1031,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 			add_command(&command, CMD_ZERO, CMD_LIST,
 				    invert);
 			if (optarg) chain = optarg;
-			else if (optind < argc && argv[optind][0] != '-'
-				&& argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
 			break;
 
@@ -1059,8 +1053,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 			add_command(&command, CMD_DELETE_CHAIN, CMD_NONE,
 				    invert);
 			if (optarg) chain = optarg;
-			else if (optind < argc && argv[optind][0] != '-'
-				 && argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				chain = argv[optind++];
 			break;
 
@@ -1068,8 +1061,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 			add_command(&command, CMD_RENAME_CHAIN, CMD_NONE,
 				    invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				newname = argv[optind++];
 			else
 				xtables_error(PARAMETER_PROBLEM,
@@ -1082,8 +1074,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 			add_command(&command, CMD_SET_POLICY, CMD_NONE,
 				    invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				policy = argv[optind++];
 			else
 				xtables_error(PARAMETER_PROBLEM,
@@ -1286,8 +1277,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table)
 			set_option(&options, OPT_COUNTERS, &cs.fw.arp.invflags,
 				   invert);
 			pcnt = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				bcnt = argv[optind++];
 			else
 				xtables_error(PARAMETER_PROBLEM,
diff --git a/iptables/xtables.c b/iptables/xtables.c
index d222ae991d..45a764470a 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -744,8 +744,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			add_command(&p->command, CMD_DELETE, CMD_NONE,
 				    cs->invert);
 			p->chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!') {
+			if (xs_has_arg(argc, argv)) {
 				p->rulenum = parse_rulenumber(argv[optind++]);
 				p->command = CMD_DELETE_NUM;
 			}
@@ -755,8 +754,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			add_command(&p->command, CMD_REPLACE, CMD_NONE,
 				    cs->invert);
 			p->chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				p->rulenum = parse_rulenumber(argv[optind++]);
 			else
 				xtables_error(PARAMETER_PROBLEM,
@@ -768,8 +766,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			add_command(&p->command, CMD_INSERT, CMD_NONE,
 				    cs->invert);
 			p->chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				p->rulenum = parse_rulenumber(argv[optind++]);
 			else
 				p->rulenum = 1;
@@ -780,11 +777,9 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 				    CMD_ZERO | CMD_ZERO_NUM, cs->invert);
 			if (optarg)
 				p->chain = optarg;
-			else if (optind < argc && argv[optind][0] != '-'
-				 && argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				p->chain = argv[optind++];
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				p->rulenum = parse_rulenumber(argv[optind++]);
 			break;
 
@@ -793,11 +788,9 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 				    CMD_ZERO|CMD_ZERO_NUM, cs->invert);
 			if (optarg)
 				p->chain = optarg;
-			else if (optind < argc && argv[optind][0] != '-'
-				 && argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				p->chain = argv[optind++];
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				p->rulenum = parse_rulenumber(argv[optind++]);
 			break;
 
@@ -806,8 +799,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 				    cs->invert);
 			if (optarg)
 				p->chain = optarg;
-			else if (optind < argc && argv[optind][0] != '-'
-				 && argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				p->chain = argv[optind++];
 			break;
 
@@ -816,11 +808,9 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 				    CMD_LIST|CMD_LIST_RULES, cs->invert);
 			if (optarg)
 				p->chain = optarg;
-			else if (optind < argc && argv[optind][0] != '-'
-				&& argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				p->chain = argv[optind++];
-			if (optind < argc && argv[optind][0] != '-'
-				&& argv[optind][0] != '!') {
+			if (xs_has_arg(argc, argv)) {
 				p->rulenum = parse_rulenumber(argv[optind++]);
 				p->command = CMD_ZERO_NUM;
 			}
@@ -845,8 +835,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 				    cs->invert);
 			if (optarg)
 				p->chain = optarg;
-			else if (optind < argc && argv[optind][0] != '-'
-				 && argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				p->chain = argv[optind++];
 			break;
 
@@ -854,8 +843,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			add_command(&p->command, CMD_RENAME_CHAIN, CMD_NONE,
 				    cs->invert);
 			p->chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				p->newname = argv[optind++];
 			else
 				xtables_error(PARAMETER_PROBLEM,
@@ -868,8 +856,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			add_command(&p->command, CMD_SET_POLICY, CMD_NONE,
 				    cs->invert);
 			p->chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (xs_has_arg(argc, argv))
 				p->policy = argv[optind++];
 			else
 				xtables_error(PARAMETER_PROBLEM,
@@ -1014,15 +1001,8 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 					      "You cannot use `-w' from "
 					      "iptables-restore");
 			}
-			if (optarg) {
-				if (sscanf(optarg, "%i", &wait) != 1)
-					xtables_error(PARAMETER_PROBLEM,
-						      "wait seconds not numeric");
-			} else if (optind < argc && argv[optind][0] != '-'
-				   && argv[optind][0] != '!')
-				if (sscanf(argv[optind++], "%i", &wait) != 1)
-					xtables_error(PARAMETER_PROBLEM,
-						      "wait seconds not numeric");
+
+			wait = parse_wait_time(argc, argv);
 			break;
 
 		case 'W':
@@ -1033,9 +1013,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			}
 			if (optarg)
 				parse_wait_interval(optarg, &wait_interval);
-			else if (optind < argc &&
-				   argv[optind][0] != '-' &&
-				   argv[optind][0] != '!')
+			else if (xs_has_arg(argc, argv))
 				parse_wait_interval(argv[optind++],
 						    &wait_interval);
 
@@ -1058,9 +1036,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			args->bcnt = strchr(args->pcnt + 1, ',');
 			if (args->bcnt)
 			    args->bcnt++;
-			if (!args->bcnt && optind < argc &&
-			    argv[optind][0] != '-' &&
-			    argv[optind][0] != '!')
+			if (!args->bcnt && xs_has_arg(argc, argv))
 				args->bcnt = argv[optind++];
 			if (!args->bcnt)
 				xtables_error(PARAMETER_PROBLEM,
-- 
2.12.0.367.g23dc2f6d3c-goog

