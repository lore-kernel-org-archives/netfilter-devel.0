From: Dan Eble <dane@aiinet.com>
Subject: [PATCH] Default policy for user-defined chains.
Date: Thu, 12 Sep 2002 16:07:56 -0400 (EDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.33.0209121600340.9308-100000@dane-linux.aiinet.com>
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

/*
 * Outlook sucks (but I'm sure you knew that).  Sending with Pine.
 * Sorry again.  Flame dane@aiinet.com and I'll pass it on to the
 * IS department. :-)
 */

Well, not exactly--this is better!

SUMMARY
=======
This change allows one to address rules relative to the end of a chain
instead of the beginning, by using a negative rule number.  I exchanged
"unsigned int rulenum" for "int rulenum" everywhere it was found in in
libiptc.  Non-negative numbers do the same thing they always have.  The
reduction in maximum value from UINT_MAX to INT_MAX is not a problem,
because the CLI had restricted rulenum to [1,INT_MAX] anyway.

EXAMPLE
=======
Create a chain that drops packets by default:

    iptables -N acl
    iptables -A acl -j DROP

The final rule in the chain can be addressed as -1, so to append rules
without disturbing the final rule, insert at -2:

    iptables -I acl -2 <rule-spec-1> -j RETURN
    iptables -I acl -2 <rule-spec-2> -j RETURN

The result:

    : acl - [0:0]
    -A acl <rule-spec-1> -j RETURN
    -A acl <rule-spec-2> -j RETURN
    -A acl -j DROP

This offers great flexibility, since the default rule is not restricted to
built-in actions, and there may even be multiple rules to implement the
default behavior.

MOTIVATION
==========
I made this change to simplify the following style of configuration.  It
uses a number of ACLs, *all* of which a packet must pass through before it
is accepted.  Thanks to negative rule numbers, I don't have to count the
rules in an ACL to determine where to insert a new rule.

    *mangle
    :PREROUTING ACCEPT [0:0]
    -A PREROUTING -i eth0 -j acl-eth0-mac
    -A PREROUTING -i eth0 -j acl-eth0-ip
    -A PREROUTING -i eth0 -j <additional-chains-here>
    :acl-eth0-mac - [0:0]
    -A acl-eth0-mac -m mac --mac-source <mac1> -j RETURN
    -A acl-eth0-mac -m mac --mac-source <mac2> -j RETURN
    -A acl-eth0-mac -m mac --mac-source <mac3> -j RETURN
    -A acl-eth0-mac -j DROP
    :acl-eth0-ip - [0:0]
    -A acl-eth0-ip -s <net1> -j RETURN
    -A acl-eth0-ip -s <host2> -j DROP
    -A acl-eth0-ip -s <net3> -j RETURN
    -A acl-eth0-ip -j REJECT

TESTING
=======
I have tested the boundary conditions for I, A, R, and D options with
`iptables' for both empty and nonempty chains.  Everything works as I
believe it should.

I have not tested using `ip6tables', but a diff of the diffs (ipv4 against
ipv6) shows nothing amiss, for what that's worth.

I have not tested any of the counter functions, in part because I'm not
sure what would be satisfactory.  Suggestions are welcome.

QUESTIONS FOR PEOPLE WITH MORE THAN TWO DAYS' NETFILTER EXPERIENCE
==================================================================
1. Have I missed anything important? (other than some testing...)
2. The functions to read, zero, and set counters seemed to permit
operating on an entry at c->end.  This looked bad to me so I changed it;
was this appropriate?  Is there a way to use the CLI to confirm that it
actually was a bug, and to confirm that I actually fixed it?
3. I removed the "prepend" flag from insert_rules() for two reasons: (a)
insert_rules did not use it, and (b) callers used the value inconsistently
(at least it looked like they did).  Is that OK?

PATCH
=====
diff -burN iptables-1.2.7a/include/libiptc/libip6tc.h iptables-1.2.7a-new/include/libiptc/libip6tc.h
--- iptables-1.2.7a/include/libiptc/libip6tc.h	Mon Feb 25 04:00:36 2002
+++ iptables-1.2.7a-new/include/libiptc/libip6tc.h	Thu Sep 12 08:15:10 2002
@@ -57,13 +57,13 @@
 /* Insert the entry `fw' in chain `chain' into position `rulenum'. */
 int ip6tc_insert_entry(const ip6t_chainlabel chain,
 		       const struct ip6t_entry *e,
-		       unsigned int rulenum,
+		       int rulenum,
 		       ip6tc_handle_t *handle);
 
 /* Atomically replace rule `rulenum' in `chain' with `fw'. */
 int ip6tc_replace_entry(const ip6t_chainlabel chain,
 			const struct ip6t_entry *e,
-			unsigned int rulenum,
+			int rulenum,
 			ip6tc_handle_t *handle);
 
 /* Append entry `fw' to chain `chain'. Equivalent to insert with
@@ -80,7 +80,7 @@
 
 /* Delete the rule in position `rulenum' in `chain'. */
 int ip6tc_delete_num_entry(const ip6t_chainlabel chain,
-			   unsigned int rulenum,
+			   int rulenum,
 			   ip6tc_handle_t *handle);
 
 /* Check the packet `fw' on chain `chain'. Returns the verdict, or
@@ -122,17 +122,17 @@
 
 /* read packet and byte counters for a specific rule */
 struct ip6t_counters *ip6tc_read_counter(const ip6t_chainlabel chain,
-					unsigned int rulenum,
+					int rulenum,
 					ip6tc_handle_t *handle);
 
 /* zero packet and byte counters for a specific rule */
 int ip6tc_zero_counter(const ip6t_chainlabel chain,
-		       unsigned int rulenum,
+		       int rulenum,
 		       ip6tc_handle_t *handle);
 
 /* set packet and byte counters for a specific rule */
 int ip6tc_set_counter(const ip6t_chainlabel chain,
-		      unsigned int rulenum,
+		      int rulenum,
 		      struct ip6t_counters *counters,
 		      ip6tc_handle_t *handle);
 
diff -burN iptables-1.2.7a/include/libiptc/libiptc.h iptables-1.2.7a-new/include/libiptc/libiptc.h
--- iptables-1.2.7a/include/libiptc/libiptc.h	Thu Apr 19 12:35:39 2001
+++ iptables-1.2.7a-new/include/libiptc/libiptc.h	Thu Sep 12 08:08:18 2002
@@ -65,13 +65,13 @@
 /* Insert the entry `e' in chain `chain' into position `rulenum'. */
 int iptc_insert_entry(const ipt_chainlabel chain,
 		      const struct ipt_entry *e,
-		      unsigned int rulenum,
+		      int rulenum,
 		      iptc_handle_t *handle);
 
 /* Atomically replace rule `rulenum' in `chain' with `e'. */
 int iptc_replace_entry(const ipt_chainlabel chain,
 		       const struct ipt_entry *e,
-		       unsigned int rulenum,
+		       int rulenum,
 		       iptc_handle_t *handle);
 
 /* Append entry `e' to chain `chain'.  Equivalent to insert with
@@ -89,7 +89,7 @@
 
 /* Delete the rule in position `rulenum' in `chain'. */
 int iptc_delete_num_entry(const ipt_chainlabel chain,
-			  unsigned int rulenum,
+			  int rulenum,
 			  iptc_handle_t *handle);
 
 /* Check the packet `e' on chain `chain'.  Returns the verdict, or
@@ -132,17 +132,17 @@
 
 /* read packet and byte counters for a specific rule */
 struct ipt_counters *iptc_read_counter(const ipt_chainlabel chain,
-				       unsigned int rulenum,
+				       int rulenum,
 				       iptc_handle_t *handle);
 
 /* zero packet and byte counters for a specific rule */
 int iptc_zero_counter(const ipt_chainlabel chain,
-		      unsigned int rulenum,
+		      int rulenum,
 		      iptc_handle_t *handle);
 
 /* set packet and byte counters for a specific rule */
 int iptc_set_counter(const ipt_chainlabel chain,
-		     unsigned int rulenum,
+		     int rulenum,
 		     struct ipt_counters *counters,
 		     iptc_handle_t *handle);
 
diff -burN iptables-1.2.7a/ip6tables.c iptables-1.2.7a-new/ip6tables.c
--- iptables-1.2.7a/ip6tables.c	Mon Aug 26 10:26:23 2002
+++ iptables-1.2.7a-new/ip6tables.c	Thu Sep 12 10:24:43 2002
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
diff -burN iptables-1.2.7a/iptables.c iptables-1.2.7a-new/iptables.c
--- iptables-1.2.7a/iptables.c	Mon Aug 26 08:16:06 2002
+++ iptables-1.2.7a-new/iptables.c	Thu Sep 12 10:24:53 2002
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
diff -burN iptables-1.2.7a/libiptc/libiptc.c iptables-1.2.7a-new/libiptc/libiptc.c
--- iptables-1.2.7a/libiptc/libiptc.c	Wed May 29 09:08:16 2002
+++ iptables-1.2.7a-new/libiptc/libiptc.c	Thu Sep 12 10:20:56 2002
@@ -180,6 +180,90 @@
 	return entry2offset(h, index2entry(h, index));
 }
 
+/* rulenum=0 finds first rule (c->start),
+ * rulenum=1 finds second rule, etc.
+ * index_out receives the index of the found entry.
+ */
+static STRUCT_ENTRY *
+rulenum2entry_forward(const TC_HANDLE_T handle, struct chain_cache *c,
+		      unsigned int rulenum, int *index_out)
+{
+	unsigned int index;
+	STRUCT_ENTRY *entry;
+
+	/* Find the base entry/index. */
+	entry = c->start;
+	index = entry2index(handle, entry);
+
+	/* Find the true entry/index relative to the base entry/index. */
+	if (rulenum) {
+		if (rulenum > UINT_MAX - index) { /* catch overflow */
+			errno = E2BIG;
+			return 0;
+		}
+		index += rulenum;
+		entry = index2entry(handle, index);
+		if (!entry || entry > c->end) {
+			errno = E2BIG;
+			return 0;
+		}
+	}
+
+	if (index_out)
+		*index_out = index;
+
+	return entry;
+}
+
+/* rulenum=0 finds end-of-list (c->end),
+ * rulenum=1 finds last rule, etc.
+ * index_out receives the index of the found entry.
+ */
+static STRUCT_ENTRY *
+rulenum2entry_reverse(const TC_HANDLE_T handle, struct chain_cache *c,
+		      unsigned int rulenum, int *index_out)
+{
+	unsigned int index;
+	STRUCT_ENTRY *entry;
+
+	/* Find the base entry/index. */
+	entry = c->end;
+	index = entry2index(handle, entry);
+
+	/* Find the true entry/index relative to the base entry/index. */
+	if (rulenum) {
+		if (rulenum > index) { /* catch underflow */
+			errno = E2BIG;
+			return 0;
+		}
+		index -= rulenum;
+		entry = index2entry(handle, index);
+		if (!entry || entry < c->start) {
+			errno = E2BIG;
+			return 0;
+		}
+	}
+
+	if (index_out)
+		*index_out = index;
+
+	return entry;
+}
+
+/* General access of an entry from the beginning or end of a chain, depending
+ * on the sign of rulenum.  The ambiguous case of rulenum=0 is resolved in
+ * favor of the forward direction for backward compatibility.
+ */
+static STRUCT_ENTRY *
+rulenum2entry(const TC_HANDLE_T handle, struct chain_cache *c,
+	      int rulenum, int *index_out)
+{
+	if (rulenum >= 0)
+		return rulenum2entry_forward(handle, c, rulenum, index_out);
+	else
+		return rulenum2entry_reverse(handle, c, -rulenum, index_out);
+}
+
 static const char *
 get_errorlabel(TC_HANDLE_T h, unsigned int offset)
 {
@@ -699,13 +783,11 @@
 	return 1;
 }
 
-/* If prepend is set, then we are prepending to a chain: if the
- * insertion position is an entry point, keep the entry point. */
+/* If the insertion position is an entry point, keep the entry point. */
 static int
 insert_rules(unsigned int num_rules, unsigned int rules_size,
 	     const STRUCT_ENTRY *insert,
 	     unsigned int offset, unsigned int num_rules_offset,
-	     int prepend,
 	     TC_HANDLE_T *handle)
 {
 	TC_HANDLE_T newh;
@@ -909,10 +991,10 @@
 int
 TC_INSERT_ENTRY(const IPT_CHAINLABEL chain,
 		const STRUCT_ENTRY *e,
-		unsigned int rulenum,
+		int rulenum,
 		TC_HANDLE_T *handle)
 {
-	unsigned int chainindex, offset;
+	unsigned int index, offset;
 	STRUCT_ENTRY_TARGET old;
 	struct chain_cache *c;
 	STRUCT_ENTRY *tmp;
@@ -924,22 +1006,24 @@
 		return 0;
 	}
 
-	chainindex = entry2index(*handle, c->start);
+	if (rulenum >= 0)
+		tmp = rulenum2entry_forward(*handle, c, rulenum, &index);
+	else {
+		/* Add -1 to insert *after* the requested entry. */
+		tmp = rulenum2entry_reverse(*handle, c, -rulenum - 1, &index);
+	}
 
-	tmp = index2entry(*handle, chainindex + rulenum);
-	if (!tmp || tmp > c->end) {
-		errno = E2BIG;
+	if (!tmp)
 		return 0;
-	}
-	offset = index2offset(*handle, chainindex + rulenum);
+
+	offset = entry2offset(*handle, tmp);
 
 	/* Mapping target actually alters entry, but that's
            transparent to the caller. */
 	if (!map_target(*handle, (STRUCT_ENTRY *)e, offset, &old))
 		return 0;
 
-	ret = insert_rules(1, e->next_offset, e, offset,
-			   chainindex + rulenum, rulenum == 0, handle);
+	ret = insert_rules(1, e->next_offset, e, offset, index, handle);
 	unmap_target((STRUCT_ENTRY *)e, &old);
 	return ret;
 }
@@ -948,10 +1032,10 @@
 int
 TC_REPLACE_ENTRY(const IPT_CHAINLABEL chain,
 		 const STRUCT_ENTRY *e,
-		 unsigned int rulenum,
+		 int rulenum,
 		 TC_HANDLE_T *handle)
 {
-	unsigned int chainindex, offset;
+	unsigned int index, offset;
 	STRUCT_ENTRY_TARGET old;
 	struct chain_cache *c;
 	STRUCT_ENTRY *tmp;
@@ -964,25 +1048,25 @@
 		return 0;
 	}
 
-	chainindex = entry2index(*handle, c->start);
-
-	tmp = index2entry(*handle, chainindex + rulenum);
-	if (!tmp || tmp >= c->end) {
+	tmp = rulenum2entry(*handle, c, rulenum, &index);
+	if (!tmp)
+		return 0;
+	else if (tmp == c->end) {
 		errno = E2BIG;
 		return 0;
 	}
 
-	offset = index2offset(*handle, chainindex + rulenum);
+	offset = entry2offset(*handle, tmp);
+
 	/* Replace = delete and insert. */
 	if (!delete_rules(1, get_entry(*handle, offset)->next_offset,
-			  offset, chainindex + rulenum, handle))
+			  offset, index, handle))
 		return 0;
 
 	if (!map_target(*handle, (STRUCT_ENTRY *)e, offset, &old))
 		return 0;
 
-	ret = insert_rules(1, e->next_offset, e, offset,
-			   chainindex + rulenum, 1, handle);
+	ret = insert_rules(1, e->next_offset, e, offset, index, handle);
 	unmap_target((STRUCT_ENTRY *)e, &old);
 	return ret;
 }
@@ -994,26 +1078,7 @@
 		const STRUCT_ENTRY *e,
 		TC_HANDLE_T *handle)
 {
-	struct chain_cache *c;
-	STRUCT_ENTRY_TARGET old;
-	int ret;
-
-	iptc_fn = TC_APPEND_ENTRY;
-	if (!(c = find_label(chain, *handle))) {
-		errno = ENOENT;
-		return 0;
-	}
-
-	if (!map_target(*handle, (STRUCT_ENTRY *)e,
-			entry2offset(*handle, c->end), &old))
-		return 0;
-
-	ret = insert_rules(1, e->next_offset, e,
-			   entry2offset(*handle, c->end),
-			   entry2index(*handle, c->end),
-			   0, handle);
-	unmap_target((STRUCT_ENTRY *)e, &old);
-	return ret;
+	return TC_INSERT_ENTRY(chain, e, -1, handle);
 }
 
 static inline int
@@ -1121,7 +1186,7 @@
 /* Delete the rule in position `rulenum' in `chain'. */
 int
 TC_DELETE_NUM_ENTRY(const IPT_CHAINLABEL chain,
-		    unsigned int rulenum,
+		    int rulenum,
 		    TC_HANDLE_T *handle)
 {
 	unsigned int index;
@@ -1135,16 +1200,11 @@
 		return 0;
 	}
 
-	index = entry2index(*handle, c->start) + rulenum;
-
-	if (index >= entry2index(*handle, c->end)) {
-		errno = E2BIG;
+	e = rulenum2entry(*handle, c, rulenum, &index);
+	if (!e)
 		return 0;
-	}
-
-	e = index2entry(*handle, index);
-	if (e == NULL) {
-		errno = EINVAL;
+	else if (e == c->end) {
+		errno = E2BIG;
 		return 0;
 	}
 
@@ -1213,12 +1273,11 @@
 
 STRUCT_COUNTERS *
 TC_READ_COUNTER(const IPT_CHAINLABEL chain,
-		unsigned int rulenum,
+		int rulenum,
 		TC_HANDLE_T *handle)
 {
 	STRUCT_ENTRY *e;
 	struct chain_cache *c;
-	unsigned int chainindex, end;
 
 	iptc_fn = TC_READ_COUNTER;
 	CHECK(*handle);
@@ -1228,27 +1287,25 @@
 		return NULL;
 	}
 
-	chainindex = entry2index(*handle, c->start);
-	end = entry2index(*handle, c->end);
-
-	if (chainindex + rulenum > end) {
+	e = rulenum2entry(*handle, c, rulenum, NULL);
+	if (!e)
+		return 0;
+	else if (e == c->end) {
 		errno = E2BIG;
-		return NULL;
+		return 0;
 	}
 
-	e = index2entry(*handle, chainindex + rulenum);
-
 	return &e->counters;
 }
 
 int
 TC_ZERO_COUNTER(const IPT_CHAINLABEL chain,
-		unsigned int rulenum,
+		int rulenum,
 		TC_HANDLE_T *handle)
 {
 	STRUCT_ENTRY *e;
 	struct chain_cache *c;
-	unsigned int chainindex, end;
+	unsigned int index;
 	
 	iptc_fn = TC_ZERO_COUNTER;
 	CHECK(*handle);
@@ -1258,21 +1315,16 @@
 		return 0;
 	}
 
-	chainindex = entry2index(*handle, c->start);
-	end = entry2index(*handle, c->end);
-
-	if (chainindex + rulenum > end) {
+	e = rulenum2entry(*handle, c, rulenum, &index);
+	if (!e)
+		return 0;
+	else if (e == c->end) {
 		errno = E2BIG;
 		return 0;
 	}
 
-	e = index2entry(*handle, chainindex + rulenum);
-
-	if ((*handle)->counter_map[chainindex + rulenum].maptype
-			== COUNTER_MAP_NORMAL_MAP) {
-		(*handle)->counter_map[chainindex + rulenum].maptype
-			 = COUNTER_MAP_ZEROED;
-	}
+	if ((*handle)->counter_map[index].maptype == COUNTER_MAP_NORMAL_MAP)
+		(*handle)->counter_map[index].maptype = COUNTER_MAP_ZEROED;
 
 	set_changed(*handle);
 
@@ -1281,13 +1333,13 @@
 
 int 
 TC_SET_COUNTER(const IPT_CHAINLABEL chain,
-	       unsigned int rulenum,
+	       int rulenum,
 	       STRUCT_COUNTERS *counters,
 	       TC_HANDLE_T *handle)
 {
 	STRUCT_ENTRY *e;
 	struct chain_cache *c;
-	unsigned int chainindex, end;
+	unsigned int index;
 
 	iptc_fn = TC_SET_COUNTER;
 	CHECK(*handle);
@@ -1297,18 +1349,15 @@
 		return 0;
 	}
 
-	chainindex = entry2index(*handle, c->start);
-	end = entry2index(*handle, c->end);
-
-	if (chainindex + rulenum > end) {
+	e = rulenum2entry(*handle, c, rulenum, &index);
+	if (!e)
+		return 0;
+	else if (e == c->end) {
 		errno = E2BIG;
 		return 0;
 	}
 
-	e = index2entry(*handle, chainindex + rulenum);
-
-	(*handle)->counter_map[chainindex + rulenum].maptype
-		= COUNTER_MAP_SET;
+	(*handle)->counter_map[index].maptype = COUNTER_MAP_SET;
 
 	memcpy(&e->counters, counters, sizeof(STRUCT_COUNTERS));
 
@@ -1371,7 +1420,7 @@
 	ret = insert_rules(2, sizeof(newc), &newc.head,
 			   index2offset(*handle, (*handle)->new_number - 1),
 			   (*handle)->new_number - 1,
-			   0, handle);
+			   handle);
 	return ret;
 }

-- 
Dan Eble <dane@aiinet.com>           _____  .
Applied Innovation Inc.             |  _  |/|
Dublin, OH  43017-3271              | |_| | |
614-923-1185 or 800-247-9482 x2051  |__/|_|_|
