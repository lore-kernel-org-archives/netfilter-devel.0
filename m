From: Dan Eble <dane@aiinet.com>
Subject: [PATCH] Negative rule numbers (command line portion)
Date: Mon, 23 Sep 2002 11:20:59 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0209231117400.32713-100000@dane-linux.aiinet.com>
Reply-To: <dane@aiinet.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

These are the changes to the command line interface for addressing rules 
from the end of a chain by negative numbers.  This feature requires the 
patch to libiptc posted a few minutes ago.

--- iptables-GPL-old/iptables.c	Mon Aug 26 08:16:06 2002
+++ iptables-GPL/iptables.c	Thu Sep 12 10:24:53 2002
@@ -343,8 +343,9 @@
 
 	printf("%s v%s\n\n"
 "Usage: %s -[AD] chain rule-specification [options]\n"
-"       %s -[RI] chain rulenum rule-specification [options]\n"
-"       %s -D chain rulenum [options]\n"
+"       %s -D chain [-]rulenum [options]\n"
+"       %s -I chain [[-]rulenum] rule-specification [options]\n"
+"       %s -R chain [-]rulenum rule-specification [options]\n"
 "       %s -[LFZ] [chain] [options]\n"
 "       %s -[NX] chain\n"
 "       %s -E old-chain-name new-chain-name\n"
@@ -352,19 +353,22 @@
 "       %s -h (print this help information)\n\n",
 	       program_name, program_version, program_name, program_name,
 	       program_name, program_name, program_name, program_name,
-	       program_name, program_name);
+	       program_name, program_name, program_name);
 
 	printf(
 "Commands:\n"
 "Either long or short options are allowed.\n"
 "  --append  -A chain		Append to chain\n"
 "  --delete  -D chain		Delete matching rule from chain\n"
-"  --delete  -D chain rulenum\n"
+"  --delete  -D chain [-]rulenum\n"
 "				Delete rule rulenum (1 = first) from chain\n"
-"  --insert  -I chain [rulenum]\n"
+"				Negative rulenum counts backwards from end\n"
+"  --insert  -I chain [[-]rulenum]\n"
 "				Insert in chain as rulenum (default 1=first)\n"
-"  --replace -R chain rulenum\n"
+"				Negative rulenum counts backwards from end\n"
+"  --replace -R chain [-]rulenum\n"
 "				Replace rule rulenum (1 = first) in chain\n"
+"				Negative rulenum counts backwards from end\n"
 "  --list    -L [chain]		List the rules in a chain or all chains\n"
 "  --flush   -F [chain]		Delete all rules in  chain or all chains\n"
 "  --zero    -Z [chain]		Zero counters in chain or all chains\n"
@@ -397,7 +401,7 @@
 "  --line-numbers		print line numbers when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
 "[!] --fragment	-f		match second or further fragments only\n"
-"  --modprobe=<command>		try to insert modules using this command\n"
+"  --modprobe=command		try to insert modules using this command\n"
 "  --set-counters PKTS BYTES	set the counter during insert/append\n"
 "[!] --version	-V		print package version.\n");
 
@@ -783,16 +787,45 @@
 	}
 }
 
-/* Can't be zero. */
+static int
+str_is_num(const char *s)
+{
+	if (*s == '-' || *s == '+')
+		s++;
+	return isdigit(*s);
+}
+
+/* Can't be zero.  Negative numbers address rules backward from the end of
+ * the list. */
 static int
 parse_rulenumber(const char *rule)
 {
 	unsigned int rulenum;
+	int sign;
+
+	if (*rule == '-') {
+		sign = -1;
+		++rule;
+	}
+	else
+		sign = 1;
 
 	if (string_to_number(rule, 1, INT_MAX, &rulenum) == -1)
 		exit_error(PARAMETER_PROBLEM,
 			   "Invalid rule number `%s'", rule);
 
+	return sign*(int)rulenum;
+}
+
+
+/* The command line indexes rules using [-N,-1] U [1,N], but the library
+ * indexes rules by [-N,1] U [0,N-1]. */
+static int
+cli_to_lib_rulenum(int rulenum)
+{
+	if (rulenum > 0)
+		return rulenum - 1;
+	else
 	return rulenum;
 }
 
@@ -1312,7 +1345,7 @@
 static int
 replace_entry(const ipt_chainlabel chain,
 	      struct ipt_entry *fw,
-	      unsigned int rulenum,
+	      int rulenum,
 	      const struct in_addr *saddr,
 	      const struct in_addr *daddr,
 	      int verbose,
@@ -1323,13 +1356,14 @@
 
 	if (verbose)
 		print_firewall_line(fw, *handle);
-	return iptc_replace_entry(chain, fw, rulenum, handle);
+	return iptc_replace_entry(chain, fw, cli_to_lib_rulenum(rulenum),
+				  handle);
 }
 
 static int
 insert_entry(const ipt_chainlabel chain,
 	     struct ipt_entry *fw,
-	     unsigned int rulenum,
+	     int rulenum,
 	     unsigned int nsaddrs,
 	     const struct in_addr saddrs[],
 	     unsigned int ndaddrs,
@@ -1346,7 +1380,9 @@
 			fw->ip.dst.s_addr = daddrs[j].s_addr;
 			if (verbose)
 				print_firewall_line(fw, *handle);
-			ret &= iptc_insert_entry(chain, fw, rulenum, handle);
+			ret &= iptc_insert_entry(chain, fw,
+						 cli_to_lib_rulenum(rulenum),
+						 handle);
 		}
 	}
 
@@ -1420,6 +1456,15 @@
 	return ret;
 }
 
+static int
+delete_num_entry(const ipt_chainlabel chain,
+		 int rulenum,
+		 iptc_handle_t *handle)
+{
+	return iptc_delete_num_entry(chain, cli_to_lib_rulenum(rulenum),
+				     handle);
+}
+
 int
 for_each_chain(int (*fn)(const ipt_chainlabel, int, iptc_handle_t *),
 	       int verbose, int builtinstoo, iptc_handle_t *handle)
@@ -1650,7 +1695,8 @@
 	const char *chain = NULL;
 	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
 	const char *policy = NULL, *newname = NULL;
-	unsigned int rulenum = 0, options = 0, command = 0;
+	unsigned int options = 0, command = 0;
+	int rulenum = 0;
 	const char *pcnt = NULL, *bcnt = NULL;
 	int ret = 1;
 	struct iptables_match *m;
@@ -1703,8 +1749,7 @@
 			add_command(&command, CMD_DELETE, CMD_NONE,
 				    invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!') {
+			if (optind < argc && str_is_num(argv[optind])) {
 				rulenum = parse_rulenumber(argv[optind++]);
 				command = CMD_DELETE_NUM;
 			}
@@ -1714,8 +1759,7 @@
 			add_command(&command, CMD_REPLACE, CMD_NONE,
 				    invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (optind < argc && str_is_num(argv[optind]))
 				rulenum = parse_rulenumber(argv[optind++]);
 			else
 				exit_error(PARAMETER_PROBLEM,
@@ -1727,8 +1771,7 @@
 			add_command(&command, CMD_INSERT, CMD_NONE,
 				    invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (optind < argc && str_is_num(argv[optind]))
 				rulenum = parse_rulenumber(argv[optind++]);
 			else rulenum = 1;
 			break;
@@ -2228,15 +2271,15 @@
 				   handle);
 		break;
 	case CMD_DELETE_NUM:
-		ret = iptc_delete_num_entry(chain, rulenum - 1, handle);
+		ret = delete_num_entry(chain, rulenum, handle);
 		break;
 	case CMD_REPLACE:
-		ret = replace_entry(chain, e, rulenum - 1,
+		ret = replace_entry(chain, e, rulenum,
 				    saddrs, daddrs, options&OPT_VERBOSE,
 				    handle);
 		break;
 	case CMD_INSERT:
-		ret = insert_entry(chain, e, rulenum - 1,
+		ret = insert_entry(chain, e, rulenum,
 				   nsaddrs, saddrs, ndaddrs, daddrs,
 				   options&OPT_VERBOSE,
 				   handle);
--- iptables-GPL-old/ip6tables.c	Mon Aug 26 10:26:23 2002
+++ iptables-GPL/ip6tables.c	Thu Sep 12 10:24:43 2002
@@ -291,8 +291,9 @@
 
 	printf("%s v%s\n\n"
 "Usage: %s -[AD] chain rule-specification [options]\n"
-"       %s -[RI] chain rulenum rule-specification [options]\n"
-"       %s -D chain rulenum [options]\n"
+"       %s -D chain [-]rulenum [options]\n"
+"       %s -I chain [[-]rulenum] rule-specification [options]\n"
+"       %s -R chain [-]rulenum rule-specification [options]\n"
 "       %s -[LFZ] [chain] [options]\n"
 "       %s -[NX] chain\n"
 "       %s -E old-chain-name new-chain-name\n"
@@ -300,19 +301,22 @@
 "       %s -h (print this help information)\n\n",
 	       program_name, program_version, program_name, program_name,
 	       program_name, program_name, program_name, program_name,
-	       program_name, program_name);
+	       program_name, program_name, program_name);
 
 	printf(
 "Commands:\n"
 "Either long or short options are allowed.\n"
 "  --append  -A chain		Append to chain\n"
 "  --delete  -D chain		Delete matching rule from chain\n"
-"  --delete  -D chain rulenum\n"
+"  --delete  -D chain [-]rulenum\n"
 "				Delete rule rulenum (1 = first) from chain\n"
-"  --insert  -I chain [rulenum]\n"
+"				Negative rulenum counts backwards from end\n"
+"  --insert  -I chain [[-]rulenum]\n"
 "				Insert in chain as rulenum (default 1=first)\n"
-"  --replace -R chain rulenum\n"
+"				Negative rulenum counts backwards from end\n"
+"  --replace -R chain [-]rulenum\n"
 "				Replace rule rulenum (1 = first) in chain\n"
+"				Negative rulenum counts backwards from end\n"
 "  --list    -L [chain]		List the rules in a chain or all chains\n"
 "  --flush   -F [chain]		Delete all rules in  chain or all chains\n"
 "  --zero    -Z [chain]		Zero counters in chain or all chains\n"
@@ -345,7 +349,7 @@
 "  --line-numbers		print line numbers when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
 /*"[!] --fragment	-f		match second or further fragments only\n"*/
-"  --modprobe=<command>		try to insert modules using this command\n"
+"  --modprobe=command		try to insert modules using this command\n"
 "  --set-counters PKTS BYTES	set the counter during insert/append\n"
 "[!] --version	-V		print package version.\n");
 
@@ -842,16 +846,44 @@
 	}
 }
 
-/* Can't be zero. */
+static int
+str_is_num(const char *s)
+{
+	if (*s == '-' || *s == '+')
+		s++;
+	return isdigit(*s);
+}
+
+/* Can't be zero.  Negative numbers address rules backward from the end of
+ * the list. */
 static int
 parse_rulenumber(const char *rule)
 {
 	unsigned int rulenum;
+	int sign;
+
+	if (*rule == '-') {
+		sign = -1;
+		++rule;
+	}
+	else
+		sign = 1;
 
 	if (string_to_number(rule, 1, INT_MAX, &rulenum) == -1)
 		exit_error(PARAMETER_PROBLEM,
 			   "Invalid rule number `%s'", rule);
 
+	return sign*(int)rulenum;
+}
+
+/* The command line indexes rules using [-N,-1] U [1,N], but the library
+ * indexes rules by [-N,1] U [0,N-1]. */
+static int
+cli_to_lib_rulenum(int rulenum)
+{
+	if (rulenum > 0)
+		return rulenum - 1;
+	else
 	return rulenum;
 }
 
@@ -1313,7 +1345,7 @@
 static int
 replace_entry(const ip6t_chainlabel chain,
 	      struct ip6t_entry *fw,
-	      unsigned int rulenum,
+	      int rulenum,
 	      const struct in6_addr *saddr,
 	      const struct in6_addr *daddr,
 	      int verbose,
@@ -1324,13 +1356,14 @@
 
 	if (verbose)
 		print_firewall_line(fw, *handle);
-	return ip6tc_replace_entry(chain, fw, rulenum, handle);
+	return ip6tc_replace_entry(chain, fw, cli_to_lib_rulenum(rulenum),
+				   handle);
 }
 
 static int
 insert_entry(const ip6t_chainlabel chain,
 	     struct ip6t_entry *fw,
-	     unsigned int rulenum,
+	     int rulenum,
 	     unsigned int nsaddrs,
 	     const struct in6_addr saddrs[],
 	     unsigned int ndaddrs,
@@ -1347,7 +1380,9 @@
 			fw->ipv6.dst = daddrs[j];
 			if (verbose)
 				print_firewall_line(fw, *handle);
-			ret &= ip6tc_insert_entry(chain, fw, rulenum, handle);
+			ret &= ip6tc_insert_entry(chain, fw,
+						  cli_to_lib_rulenum(rulenum),
+						  handle);
 		}
 	}
 
@@ -1421,6 +1456,15 @@
 	return ret;
 }
 
+static int
+delete_num_entry(const ip6t_chainlabel chain,
+		 int rulenum,
+		 ip6tc_handle_t *handle)
+{
+	return ip6tc_delete_num_entry(chain, cli_to_lib_rulenum(rulenum),
+				      handle);
+}
+
 int
 for_each_chain(int (*fn)(const ip6t_chainlabel, int, ip6tc_handle_t *),
 	       int verbose, int builtinstoo, ip6tc_handle_t *handle)
@@ -1651,7 +1695,8 @@
 	const char *chain = NULL;
 	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
 	const char *policy = NULL, *newname = NULL;
-	unsigned int rulenum = 0, options = 0, command = 0;
+	unsigned int options = 0, command = 0;
+	int rulenum = 0;
 	const char *pcnt = NULL, *bcnt = NULL;
 	int ret = 1;
 	struct ip6tables_match *m;
@@ -1705,8 +1750,7 @@
 			add_command(&command, CMD_DELETE, CMD_NONE,
 				    invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!') {
+			if (optind < argc && str_is_num(argv[optind])) {
 				rulenum = parse_rulenumber(argv[optind++]);
 				command = CMD_DELETE_NUM;
 			}
@@ -1716,8 +1760,7 @@
 			add_command(&command, CMD_REPLACE, CMD_NONE,
 				    invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (optind < argc && str_is_num(argv[optind]))
 				rulenum = parse_rulenumber(argv[optind++]);
 			else
 				exit_error(PARAMETER_PROBLEM,
@@ -1729,8 +1772,7 @@
 			add_command(&command, CMD_INSERT, CMD_NONE,
 				    invert);
 			chain = optarg;
-			if (optind < argc && argv[optind][0] != '-'
-			    && argv[optind][0] != '!')
+			if (optind < argc && str_is_num(argv[optind]))
 				rulenum = parse_rulenumber(argv[optind++]);
 			else rulenum = 1;
 			break;
@@ -2227,15 +2269,15 @@
 				   handle);
 		break;
 	case CMD_DELETE_NUM:
-		ret = ip6tc_delete_num_entry(chain, rulenum - 1, handle);
+		ret = delete_num_entry(chain, rulenum, handle);
 		break;
 	case CMD_REPLACE:
-		ret = replace_entry(chain, e, rulenum - 1,
+		ret = replace_entry(chain, e, rulenum,
 				    saddrs, daddrs, options&OPT_VERBOSE,
 				    handle);
 		break;
 	case CMD_INSERT:
-		ret = insert_entry(chain, e, rulenum - 1,
+		ret = insert_entry(chain, e, rulenum,
 				   nsaddrs, saddrs, ndaddrs, daddrs,
 				   options&OPT_VERBOSE,
 				   handle);
