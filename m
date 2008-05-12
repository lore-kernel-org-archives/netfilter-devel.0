From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: [patch 4/4] iptables --list chain rulenum
Date: Mon, 12 May 2008 20:40:24 +0200
Message-ID: <1210617624.3442.45.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Za28OwFoa1yTdGSZqOc8"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:48470 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbYELSk1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 14:40:27 -0400
Received: from henriknordstrom.net (183.159.216.81.static.tb.siw.siwnet.net [81.216.159.183])
	by vps1.henriknordstrom.net (8.13.8/8.13.8/Debian-3) with ESMTP id m4CIeOF3030633
	for <netfilter-devel@vger.kernel.org>; Mon, 12 May 2008 20:40:24 +0200
Received: from henrik ([127.0.0.1])
	(authenticated bits=0)
	by henriknordstrom.net (8.12.11.20060308/8.12.8) with ESMTP id m4CIePRH029611
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Mon, 12 May 2008 20:40:25 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-Za28OwFoa1yTdGSZqOc8
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Excent --list (and --list-rules) to allow selection of a single rule
number

iptables --list INPUT 4
iptables --list-rules INPUT 4

list rule number 4 in INPUT.

Regards
Henrik

--=-Za28OwFoa1yTdGSZqOc8
Content-Disposition: attachment; filename=iptables-list-rulenum.patch
Content-Type: text/x-patch; name=iptables-list-rulenum.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: iptables/ip6tables.c
===================================================================
--- iptables.orig/ip6tables.c
+++ iptables/ip6tables.c
@@ -282,14 +282,15 @@ exit_printhelp(struct ip6tables_rule_mat
 "Usage: %s -[AD] chain rule-specification [options]\n"
 "       %s -[RI] chain rulenum rule-specification [options]\n"
 "       %s -D chain rulenum [options]\n"
-"       %s -[LFZ] [chain] [options]\n"
+"       %s -[LS] [chain [rulenum]] [options]\n"
+"       %s -[FZ] [chain] [options]\n"
 "       %s -[NX] chain\n"
 "       %s -E old-chain-name new-chain-name\n"
 "       %s -P chain target [options]\n"
 "       %s -h (print this help information)\n\n",
 	       program_name, program_version, program_name, program_name,
 	       program_name, program_name, program_name, program_name,
-	       program_name, program_name);
+	       program_name, program_name, program_name);
 
 	printf(
 "Commands:\n"
@@ -302,9 +303,10 @@ exit_printhelp(struct ip6tables_rule_mat
 "				Insert in chain as rulenum (default 1=first)\n"
 "  --replace -R chain rulenum\n"
 "				Replace rule rulenum (1 = first) in chain\n"
-"  --list    -L [chain]		List the rules in a chain or all chains\n"
-"  --list-rules\n"
-"            -S [chain]         Print the rules in a chain or all chains\n"
+"  --list    -L [chain [rulenum]]\n"
+"				List the rules in a chain or all chains\n"
+"  --list-rules -S [chain [rulenum]]\n"
+"				Print the rules in a chain or all chains\n"
 "  --flush   -F [chain]		Delete all rules in  chain or all chains\n"
 "  --zero    -Z [chain]		Zero counters in chain or all chains\n"
 "  --new     -N chain		Create a new user-defined chain\n"
@@ -1051,7 +1053,7 @@ delete_chain(const ip6t_chainlabel chain
 }
 
 static int
-list_entries(const ip6t_chainlabel chain, int verbose, int numeric,
+list_entries(const ip6t_chainlabel chain, int rulenum, int verbose, int numeric,
 	     int expanded, int linenumbers, ip6tc_handle_t *handle)
 {
 	int found = 0;
@@ -1084,16 +1086,19 @@ list_entries(const ip6t_chainlabel chain
 
 		if (found) printf("\n");
 
-		print_header(format, this, handle);
+		if (!rulenum)
+		    print_header(format, this, handle);
 		i = ip6tc_first_rule(this, handle);
 
 		num = 0;
 		while (i) {
-			print_firewall(i,
-				       ip6tc_get_target(i, handle),
-				       num++,
-				       format,
-				       *handle);
+			num++;
+			if (!rulenum || num == rulenum)
+				print_firewall(i,
+					       ip6tc_get_target(i, handle),
+					       num,
+					       format,
+					       *handle);
 			i = ip6tc_next_rule(i, handle);
 		}
 		found = 1;
@@ -1287,7 +1292,7 @@ void print_rule(const struct ip6t_entry 
 }
 
 static int
-list_rules(const ip6t_chainlabel chain, int counters,
+list_rules(const ip6t_chainlabel chain, int rulenum, int counters,
 	     ip6tc_handle_t *handle)
 {
 	const char *this = NULL;
@@ -1298,7 +1303,7 @@ list_rules(const ip6t_chainlabel chain, 
 
 	/* Dump out chain names first,
 	 * thereby preventing dependency conflicts */
-	for (this = ip6tc_first_chain(handle);
+	if (!rulenum) for (this = ip6tc_first_chain(handle);
 	     this;
 	     this = ip6tc_next_chain(handle)) {
 		if (chain && strcmp(this, chain) != 0)
@@ -1319,6 +1324,7 @@ list_rules(const ip6t_chainlabel chain, 
 	     this;
 	     this = ip6tc_next_chain(handle)) {
 		const struct ip6t_entry *e;
+		int num = 0;
 
 		if (chain && strcmp(this, chain) != 0)
 			continue;
@@ -1326,7 +1332,9 @@ list_rules(const ip6t_chainlabel chain, 
 		/* Dump out rules */
 		e = ip6tc_first_rule(this, handle);
 		while(e) {
-			print_rule(e, handle, this, counters);
+			num++;
+			if (!rulenum || num == rulenum)
+			    print_rule(e, handle, this, counters);
 			e = ip6tc_next_rule(e, handle);
 		}
 		found = 1;
@@ -1492,6 +1500,9 @@ int do_command6(int argc, char *argv[], 
 			else if (optind < argc && argv[optind][0] != '-'
 				 && argv[optind][0] != '!')
 				chain = argv[optind++];
+			if (optind < argc && argv[optind][0] != '-'
+			    && argv[optind][0] != '!')
+				rulenum = parse_rulenumber(argv[optind++]);
 			break;
 
 		case 'S':
@@ -1501,6 +1512,9 @@ int do_command6(int argc, char *argv[], 
 			else if (optind < argc && argv[optind][0] != '-'
 				 && argv[optind][0] != '!')
 				chain = argv[optind++];
+			if (optind < argc && argv[optind][0] != '-'
+			    && argv[optind][0] != '!')
+				rulenum = parse_rulenumber(argv[optind++]);
 			break;
 
 		case 'F':
@@ -2022,6 +2036,7 @@ int do_command6(int argc, char *argv[], 
 	case CMD_LIST:
 	case CMD_LIST|CMD_ZERO:
 		ret = list_entries(chain,
+				   rulenum,
 				   options&OPT_VERBOSE,
 				   options&OPT_NUMERIC,
 				   options&OPT_EXPANDED,
@@ -2034,6 +2049,7 @@ int do_command6(int argc, char *argv[], 
 	case CMD_LIST_RULES:
 	case CMD_LIST_RULES|CMD_ZERO:
 		ret = list_rules(chain,
+				   rulenum,
 				   options&OPT_VERBOSE,
 				   handle);
 		if (ret && (command & CMD_ZERO))
Index: iptables/iptables.c
===================================================================
--- iptables.orig/iptables.c
+++ iptables/iptables.c
@@ -285,14 +285,15 @@ exit_printhelp(struct iptables_rule_matc
 "Usage: %s -[AD] chain rule-specification [options]\n"
 "       %s -[RI] chain rulenum rule-specification [options]\n"
 "       %s -D chain rulenum [options]\n"
-"       %s -[LFZ] [chain] [options]\n"
+"       %s -[LS] [chain [rulenum]] [options]\n"
+"       %s -[FZ] [chain] [options]\n"
 "       %s -[NX] chain\n"
 "       %s -E old-chain-name new-chain-name\n"
 "       %s -P chain target [options]\n"
 "       %s -h (print this help information)\n\n",
 	       program_name, program_version, program_name, program_name,
 	       program_name, program_name, program_name, program_name,
-	       program_name, program_name);
+	       program_name, program_name, program_name);
 
 	printf(
 "Commands:\n"
@@ -305,9 +306,10 @@ exit_printhelp(struct iptables_rule_matc
 "				Insert in chain as rulenum (default 1=first)\n"
 "  --replace -R chain rulenum\n"
 "				Replace rule rulenum (1 = first) in chain\n"
-"  --list    -L [chain]		List the rules in a chain or all chains\n"
-"  --list-rules\n"
-"            -S [chain]         Print the rules in a chain or all chains\n"
+"  --list    -L [chain [rulenum]]\n"
+"				List the rules in a chain or all chains\n"
+"  --list-rules -S [chain [rulenum]]\n"
+"				Print the rules in a chain or all chains\n"
 "  --flush   -F [chain]		Delete all rules in  chain or all chains\n"
 "  --zero    -Z [chain]		Zero counters in chain or all chains\n"
 "  --new     -N chain		Create a new user-defined chain\n"
@@ -1054,7 +1056,7 @@ delete_chain(const ipt_chainlabel chain,
 }
 
 static int
-list_entries(const ipt_chainlabel chain, int verbose, int numeric,
+list_entries(const ipt_chainlabel chain, int rulenum, int verbose, int numeric,
 	     int expanded, int linenumbers, iptc_handle_t *handle)
 {
 	int found = 0;
@@ -1087,16 +1089,19 @@ list_entries(const ipt_chainlabel chain,
 
 		if (found) printf("\n");
 
-		print_header(format, this, handle);
+		if (!rulenum)
+			print_header(format, this, handle);
 		i = iptc_first_rule(this, handle);
 
 		num = 0;
 		while (i) {
-			print_firewall(i,
-				       iptc_get_target(i, handle),
-				       num++,
-				       format,
-				       *handle);
+			num++;
+			if (!rulenum || num == rulenum)
+				print_firewall(i,
+					       iptc_get_target(i, handle),
+					       num,
+					       format,
+					       *handle);
 			i = iptc_next_rule(i, handle);
 		}
 		found = 1;
@@ -1300,7 +1305,7 @@ void print_rule(const struct ipt_entry *
 }
 
 static int
-list_rules(const ipt_chainlabel chain, int counters,
+list_rules(const ipt_chainlabel chain, int rulenum, int counters,
 	     iptc_handle_t *handle)
 {
 	const char *this = NULL;
@@ -1311,7 +1316,7 @@ list_rules(const ipt_chainlabel chain, i
 
 	/* Dump out chain names first,
 	 * thereby preventing dependency conflicts */
-	for (this = iptc_first_chain(handle);
+	if (!rulenum) for (this = iptc_first_chain(handle);
 	     this;
 	     this = iptc_next_chain(handle)) {
 		if (chain && strcmp(this, chain) != 0)
@@ -1332,6 +1337,7 @@ list_rules(const ipt_chainlabel chain, i
 	     this;
 	     this = iptc_next_chain(handle)) {
 		const struct ipt_entry *e;
+		int num = 0;
 
 		if (chain && strcmp(this, chain) != 0)
 			continue;
@@ -1339,7 +1345,9 @@ list_rules(const ipt_chainlabel chain, i
 		/* Dump out rules */
 		e = iptc_first_rule(this, handle);
 		while(e) {
-			print_rule(e, handle, this, counters);
+			num++;
+			if (!rulenum || num == rulenum)
+			    print_rule(e, handle, this, counters);
 			e = iptc_next_rule(e, handle);
 		}
 		found = 1;
@@ -1519,6 +1527,9 @@ int do_command(int argc, char *argv[], c
 			else if (optind < argc && argv[optind][0] != '-'
 				 && argv[optind][0] != '!')
 				chain = argv[optind++];
+			if (optind < argc && argv[optind][0] != '-'
+			    && argv[optind][0] != '!')
+				rulenum = parse_rulenumber(argv[optind++]);
 			break;
 
 		case 'S':
@@ -1528,6 +1539,9 @@ int do_command(int argc, char *argv[], c
 			else if (optind < argc && argv[optind][0] != '-'
 				 && argv[optind][0] != '!')
 				chain = argv[optind++];
+			if (optind < argc && argv[optind][0] != '-'
+			    && argv[optind][0] != '!')
+				rulenum = parse_rulenumber(argv[optind++]);
 			break;
 
 		case 'F':
@@ -2073,6 +2087,7 @@ int do_command(int argc, char *argv[], c
 	case CMD_LIST:
 	case CMD_LIST|CMD_ZERO:
 		ret = list_entries(chain,
+				   rulenum,
 				   options&OPT_VERBOSE,
 				   options&OPT_NUMERIC,
 				   options&OPT_EXPANDED,
@@ -2085,6 +2100,7 @@ int do_command(int argc, char *argv[], c
 	case CMD_LIST_RULES:
 	case CMD_LIST_RULES|CMD_ZERO:
 		ret = list_rules(chain,
+				   rulenum,
 				   options&OPT_VERBOSE,
 				   handle);
 		if (ret && (command & CMD_ZERO))

--=-Za28OwFoa1yTdGSZqOc8--

