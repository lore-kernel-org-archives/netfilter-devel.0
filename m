From: Jonas Berlin <xkr47@outerspace.dyndns.org>
Subject: [PATCH] goto port to ipv6
Date: Wed, 13 Apr 2005 08:03:01 +0000
Message-ID: <425CD235.7060909@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080904060303000909080109"
Cc: Henrik Nordstrom <hno@marasystems.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------080904060303000909080109
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

I ported the goto patch to ipv6.

The attached files are meant to be placed in patch-o-matic-ng/goto/ to
extend the current module with ipv6 functionality. The set of modified
files is naturally mutually exclusive with that of the existing goto
patches.

- --
- - xkr47
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFCXNIzxyF48ZTvn+4RAtgcAJ0U44zwA60pYDhc5RvIb38AQ9Gj0QCgu2zg
EQ3ui5RT2whIvz8KUU3UurM=
=BqS0
-----END PGP SIGNATURE-----

--------------080904060303000909080109
Content-Type: text/plain;
 name="iptables.patch_5-ipv6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iptables.patch_5-ipv6"

diff -Np -ur orig-iptables-1.3.1/ip6tables-save.c iptables-1.3.1/ip6tables-save.c
--- orig-iptables-1.3.1/ip6tables-save.c	2005-03-26 17:32:13.000000000 +0200
+++ iptables-1.3.1/ip6tables-save.c	2005-04-13 10:40:36.000000000 +0300
@@ -190,7 +190,7 @@ static void print_rule(const struct ip6t
 	/* Print target name */	
 	target_name = ip6tc_get_target(e, h);
 	if (target_name && (*target_name != '\0'))
-		printf("-j %s ", target_name);
+		printf("-%c %s ", e->ipv6.flags & IP6T_F_GOTO ? 'g' : 'j', target_name);
 
 	/* Print targinfo part */
 	t = ip6t_get_target((struct ip6t_entry *)e);
diff -Np -ur orig-iptables-1.3.1/ip6tables.8.in iptables-1.3.1/ip6tables.8.in
--- orig-iptables-1.3.1/ip6tables.8.in	2005-03-26 17:32:13.000000000 +0200
+++ iptables-1.3.1/ip6tables.8.in	2005-04-13 10:39:08.000000000 +0300
@@ -267,10 +267,18 @@ one this rule is in), one of the special
 the fate of the packet immediately, or an extension (see
 .B EXTENSIONS
 below).  If this
-option is omitted in a rule, then matching the rule will have no
+option is omitted in a rule (and
+.B -g
+is not used), then matching the rule will have no
 effect on the packet's fate, but the counters on the rule will be
 incremented.
 .TP
+.BI "-g, --goto " "chain"
+This specifies that the processing should continue in a user
+specified chain. Unlike the --jump option return will not continue
+processing in this chain but instead in the chain that called us via
+--jump.
+.TP
 .BR "-i, --in-interface " "[!] \fIname\fP"
 Name of an interface via which a packet is going to be received (only for
 packets entering the 
diff -Np -ur orig-iptables-1.3.1/ip6tables.c iptables-1.3.1/ip6tables.c
--- orig-iptables-1.3.1/ip6tables.c	2005-04-13 10:27:11.000000000 +0300
+++ iptables-1.3.1/ip6tables.c	2005-04-13 10:41:07.000000000 +0300
@@ -134,6 +134,7 @@ static struct option original_opts[] = {
 	{ "line-numbers", 0, 0, '0' },
 	{ "modprobe", 1, 0, 'M' },
 	{ "set-counters", 1, 0, 'c' },
+	{ "goto", 1, 0, 'g' },
 	{ 0 }
 };
 
@@ -331,6 +332,10 @@ exit_printhelp(struct ip6tables_rule_mat
 "				network interface name ([+] for wildcard)\n"
 "  --jump	-j target\n"
 "				target for rule (may load target extension)\n"
+#ifdef IP6T_F_GOTO
+"  --goto      -g chain\n"
+"				jump to chain with no return\n"
+#endif
 "  --match	-m match\n"
 "				extended match (may load extension)\n"
 "  --numeric	-n		numeric output of addresses and ports\n"
@@ -1296,6 +1301,9 @@ print_firewall(const struct ip6t_entry *
 	if (format & FMT_NOTABLE)
 		fputs("  ", stdout);
 
+	if(fw->ipv6.flags & IP6T_F_GOTO)
+		printf("[goto] ");
+
 	IP6T_MATCH_ITERATE(fw, print_match, &fw->ipv6, format & FMT_NUMERIC);
 
 	if (target) {
@@ -1731,7 +1739,7 @@ int do_command6(int argc, char *argv[], 
 	opterr = 0;
 
 	while ((c = getopt_long(argc, argv,
-	   "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:",
+	   "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
 		switch (c) {
 			/*
@@ -1902,6 +1910,15 @@ int do_command6(int argc, char *argv[], 
 			dhostnetworkmask = argv[optind-1];
 			break;
 
+#ifdef IP6T_F_GOTO
+		case 'g':
+			set_option(&options, OPT_JUMP, &fw.ipv6.invflags,
+				   invert);
+			fw.ipv6.flags |= IP6T_F_GOTO;
+			jumpto = parse_target(optarg);
+			break;
+#endif
+
 		case 'j':
 			set_option(&options, OPT_JUMP, &fw.ipv6.invflags,
 				   invert);
@@ -2243,6 +2260,11 @@ int do_command6(int argc, char *argv[], 
 			 * We cannot know if the plugin is corrupt, non
 			 * existant OR if the user just misspelled a
 			 * chain. */
+#ifdef IP6T_F_GOTO
+			if (fw.ipv6.flags & IP6T_F_GOTO)
+				exit_error(PARAMETER_PROBLEM,
+					   "goto '%s' is not a chain\n", jumpto);
+#endif
 			find_target(jumpto, LOAD_MUST_SUCCEED);
 		} else {
 			e = generate_entry(&fw, matches, target->t);

--------------080904060303000909080109
Content-Type: text/plain;
 name="linux.patch_5-ipv6"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="linux.patch_5-ipv6"

diff -ur --exclude-from=/tmp/srcdiff.excludes.hsvBiq -N orig-linux-2.6.11/include/linux/netfilter_ipv6/ip6_tables.h linux-2.6.11/include/linux/netfilter_ipv6/ip6_tables.h
--- orig-linux-2.6.11/include/linux/netfilter_ipv6/ip6_tables.h	2005-03-14 13:40:33.000000000 +0200
+++ linux-2.6.11/include/linux/netfilter_ipv6/ip6_tables.h	2005-03-15 04:09:12.197387923 +0200
@@ -111,7 +111,8 @@
 #define IP6T_F_PROTO		0x01	/* Set if rule cares about upper 
 					   protocols */
 #define IP6T_F_TOS		0x02	/* Match the TOS. */
-#define IP6T_F_MASK		0x03	/* All possible flag bits mask. */
+#define IP6T_F_GOTO		0x04	/* Set if jump is a goto */
+#define IP6T_F_MASK		0x07	/* All possible flag bits mask. */
 
 /* Values for "inv" field in struct ip6t_ip6. */
 #define IP6T_INV_VIA_IN		0x01	/* Invert the sense of IN IFACE. */
diff -ur --exclude-from=/tmp/srcdiff.excludes.hsvBiq -N orig-linux-2.6.11/net/ipv6/netfilter/ip6_tables.c linux-2.6.11/net/ipv6/netfilter/ip6_tables.c
--- orig-linux-2.6.11/net/ipv6/netfilter/ip6_tables.c	2005-03-14 13:40:34.000000000 +0200
+++ linux-2.6.11/net/ipv6/netfilter/ip6_tables.c	2005-03-15 03:51:43.298086457 +0200
@@ -436,7 +436,7 @@
 					continue;
 				}
 				if (table_base + v
-				    != (void *)e + e->next_offset) {
+				    != (void *)e + e->next_offset && !(e->ipv6.flags & IP6T_F_GOTO)) {
 					/* Save old back ptr in next entry */
 					struct ip6t_entry *next
 						= (void *)e + e->next_offset;

--------------080904060303000909080109--
