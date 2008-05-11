From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: [patch] iptables -L --rules to print command line version of rules
Date: Mon, 12 May 2008 01:22:23 +0200
Message-ID: <1210548143.23433.41.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-mPLRQ8gj7lEiQYnveYf9"
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:50482 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755861AbYEKXW1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 May 2008 19:22:27 -0400
Received: from henriknordstrom.net (183.159.216.81.static.tb.siw.siwnet.net [81.216.159.183])
	by vps1.henriknordstrom.net (8.13.8/8.13.8/Debian-3) with ESMTP id m4BNMOMi014056
	for <netfilter-devel@vger.kernel.org>; Mon, 12 May 2008 01:22:24 +0200
Received: from henrik ([127.0.0.1])
	(authenticated bits=0)
	by henriknordstrom.net (8.12.11.20060308/8.12.8) with ESMTP id m4BNMN5k010730
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Mon, 12 May 2008 01:22:24 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-mPLRQ8gj7lEiQYnveYf9
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This patch makes iptables -L --rules capable of printing "save" format
rules, same as iptables-save.

The patch adds the --rules option to ip(6)tables, and moves the
functions for printing "save" format rules from ip(6)tables-save.c to
ip(6)tables.c where it may be used by all commands and not only
ip(6)tables-save.

Not sure if this should be an option to -L/--list, or a new command of
it's own. Before looking at the code I thought an option to --list would
be better, but after looking at the code I am no longer sure, perhaps
it's better as a --list-rules command instead of an option to --list.

I am 
Regards
Henrik

--=-mPLRQ8gj7lEiQYnveYf9
Content-Disposition: attachment; filename=iptables-rules.patch
Content-Type: text/x-patch; name=iptables-rules.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: iptables.8.in
===================================================================
--- iptables.8.in	(revision 7519)
+++ iptables.8.in	(working copy)
@@ -381,6 +381,10 @@
 When listing rules, add line numbers to the beginning of each rule,
 corresponding to that rule's position in the chain.
 .TP
+.B "--rules"
+When listing rules, print the actual iptables rule as it would be
+entered on the command line.
+.TP
 .B "--modprobe=command"
 When adding or inserting rules into a chain, use
 .B command
Index: iptables-save.c
===================================================================
--- iptables-save.c	(revision 7519)
+++ iptables-save.c	(working copy)
@@ -31,211 +31,6 @@
 	{NULL},
 };
 
-#define IP_PARTS_NATIVE(n)			\
-(unsigned int)((n)>>24)&0xFF,			\
-(unsigned int)((n)>>16)&0xFF,			\
-(unsigned int)((n)>>8)&0xFF,			\
-(unsigned int)((n)&0xFF)
-
-#define IP_PARTS(n) IP_PARTS_NATIVE(ntohl(n))
-
-/* This assumes that mask is contiguous, and byte-bounded. */
-static void
-print_iface(char letter, const char *iface, const unsigned char *mask,
-	    int invert)
-{
-	unsigned int i;
-
-	if (mask[0] == 0)
-		return;
-
-	printf("-%c %s", letter, invert ? "! " : "");
-
-	for (i = 0; i < IFNAMSIZ; i++) {
-		if (mask[i] != 0) {
-			if (iface[i] != '\0')
-				printf("%c", iface[i]);
-		} else {
-			/* we can access iface[i-1] here, because
-			 * a few lines above we make sure that mask[0] != 0 */
-			if (iface[i-1] != '\0')
-				printf("+");
-			break;
-		}
-	}
-
-	printf(" ");
-}
-
-/* These are hardcoded backups in iptables.c, so they are safe */
-struct pprot {
-	char *name;
-	u_int8_t num;
-};
-
-/* FIXME: why don't we use /etc/protocols ? */
-static const struct pprot chain_protos[] = {
-	{ "tcp", IPPROTO_TCP },
-	{ "udp", IPPROTO_UDP },
-	{ "icmp", IPPROTO_ICMP },
-	{ "esp", IPPROTO_ESP },
-	{ "ah", IPPROTO_AH },
-	{ "sctp", IPPROTO_SCTP },
-};
-
-static void print_proto(u_int16_t proto, int invert)
-{
-	if (proto) {
-		unsigned int i;
-		const char *invertstr = invert ? "! " : "";
-
-		struct protoent *pent = getprotobynumber(proto);
-		if (pent) {
-			printf("-p %s%s ", invertstr, pent->p_name);
-			return;
-		}
-
-		for (i = 0; i < sizeof(chain_protos)/sizeof(struct pprot); i++)
-			if (chain_protos[i].num == proto) {
-				printf("-p %s%s ",
-				       invertstr, chain_protos[i].name);
-				return;
-			}
-
-		printf("-p %s%u ", invertstr, proto);
-	}
-}
-
-static int print_match(const struct ipt_entry_match *e,
-			const struct ipt_ip *ip)
-{
-	struct xtables_match *match
-		= find_match(e->u.user.name, TRY_LOAD, NULL);
-
-	if (match) {
-		printf("-m %s ", e->u.user.name);
-
-		/* some matches don't provide a save function */
-		if (match->save)
-			match->save(ip, e);
-	} else {
-		if (e->u.match_size) {
-			fprintf(stderr,
-				"Can't find library for match `%s'\n",
-				e->u.user.name);
-			exit(1);
-		}
-	}
-	return 0;
-}
-
-/* print a given ip including mask if neccessary */
-static void print_ip(char *prefix, u_int32_t ip, u_int32_t mask, int invert)
-{
-	u_int32_t bits, hmask = ntohl(mask);
-	int i;
-
-	if (!mask && !ip && !invert)
-		return;
-
-	printf("%s %s%u.%u.%u.%u",
-		prefix,
-		invert ? "! " : "",
-		IP_PARTS(ip));
-
-	if (mask == 0xFFFFFFFFU) {
-		printf("/32 ");
-		return;
-	}
-
-	i    = 32;
-	bits = 0xFFFFFFFEU;
-	while (--i >= 0 && hmask != bits)
-		bits <<= 1;
-	if (i >= 0)
-		printf("/%u ", i);
-	else
-		printf("/%u.%u.%u.%u ", IP_PARTS(mask));
-}
-
-/* We want this to be readable, so only print out neccessary fields.
- * Because that's the kind of world I want to live in.  */
-static void print_rule(const struct ipt_entry *e,
-		iptc_handle_t *h, const char *chain, int counters)
-{
-	struct ipt_entry_target *t;
-	const char *target_name;
-
-	/* print counters */
-	if (counters)
-		printf("[%llu:%llu] ", (unsigned long long)e->counters.pcnt, (unsigned long long)e->counters.bcnt);
-
-	/* print chain name */
-	printf("-A %s ", chain);
-
-	/* Print IP part. */
-	print_ip("-s", e->ip.src.s_addr,e->ip.smsk.s_addr,
-			e->ip.invflags & IPT_INV_SRCIP);
-
-	print_ip("-d", e->ip.dst.s_addr, e->ip.dmsk.s_addr,
-			e->ip.invflags & IPT_INV_DSTIP);
-
-	print_iface('i', e->ip.iniface, e->ip.iniface_mask,
-		    e->ip.invflags & IPT_INV_VIA_IN);
-
-	print_iface('o', e->ip.outiface, e->ip.outiface_mask,
-		    e->ip.invflags & IPT_INV_VIA_OUT);
-
-	print_proto(e->ip.proto, e->ip.invflags & IPT_INV_PROTO);
-
-	if (e->ip.flags & IPT_F_FRAG)
-		printf("%s-f ",
-		       e->ip.invflags & IPT_INV_FRAG ? "! " : "");
-
-	/* Print matchinfo part */
-	if (e->target_offset) {
-		IPT_MATCH_ITERATE(e, print_match, &e->ip);
-	}
-
-	/* Print target name */
-	target_name = iptc_get_target(e, h);
-	if (target_name && (*target_name != '\0'))
-#ifdef IPT_F_GOTO
-		printf("-%c %s ", e->ip.flags & IPT_F_GOTO ? 'g' : 'j', target_name);
-#else
-		printf("-j %s ", target_name);
-#endif
-
-	/* Print targinfo part */
-	t = ipt_get_target((struct ipt_entry *)e);
-	if (t->u.user.name[0]) {
-		struct xtables_target *target
-			= find_target(t->u.user.name, TRY_LOAD);
-
-		if (!target) {
-			fprintf(stderr, "Can't find library for target `%s'\n",
-				t->u.user.name);
-			exit(1);
-		}
-
-		if (target->save)
-			target->save(&e->ip, t);
-		else {
-			/* If the target size is greater than ipt_entry_target
-			 * there is something to be saved, we just don't know
-			 * how to print it */
-			if (t->u.target_size !=
-			    sizeof(struct ipt_entry_target)) {
-				fprintf(stderr, "Target `%s' is missing "
-						"save function\n",
-					t->u.user.name);
-				exit(1);
-			}
-		}
-	}
-	printf("\n");
-}
-
 /* Debugging prototype. */
 static int for_each_table(int (*func)(const char *tablename))
 {
Index: include/ip6tables.h
===================================================================
--- include/ip6tables.h	(revision 7519)
+++ include/ip6tables.h	(working copy)
@@ -22,5 +22,6 @@
 extern int for_each_chain(int (*fn)(const ip6t_chainlabel, int, ip6tc_handle_t *), int verbose, int builtinstoo, ip6tc_handle_t *handle);
 extern int flush_entries(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle);
 extern int delete_chain(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle);
+void print_rule(const struct ip6t_entry *e, ip6tc_handle_t *h, const char *chain, int counters);
 
 #endif /*_IP6TABLES_USER_H*/
Index: include/iptables.h
===================================================================
--- include/iptables.h	(revision 7519)
+++ include/iptables.h	(working copy)
@@ -23,6 +23,8 @@
 			iptc_handle_t *handle);
 extern int for_each_chain(int (*fn)(const ipt_chainlabel, int, iptc_handle_t *),
 		int verbose, int builtinstoo, iptc_handle_t *handle);
+extern void print_rule(const struct ipt_entry *e,
+		iptc_handle_t *handle, const char *chain, int counters);
 
 /* kernel revision handling */
 extern int kernel_version;
Index: iptables.c
===================================================================
--- iptables.c	(revision 7519)
+++ iptables.c	(working copy)
@@ -94,9 +94,10 @@
 #define OPT_FRAGMENT    0x00200U
 #define OPT_LINENUMBERS 0x00400U
 #define OPT_COUNTERS	0x00800U
-#define NUMBER_OF_OPT	12
+#define OPT_RULES	0x01000U
+#define NUMBER_OF_OPT	13
 static const char optflags[NUMBER_OF_OPT]
-= { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', 'f', '0', 'c'};
+= { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', 'f', '0', 'c', 'r'};
 
 static struct option original_opts[] = {
 	{.name = "append",        .has_arg = 1, .val = 'A'},
@@ -130,6 +131,7 @@
 	{.name = "modprobe",      .has_arg = 1, .val = 'M'},
 	{.name = "set-counters",  .has_arg = 1, .val = 'c'},
 	{.name = "goto",          .has_arg = 1, .val = 'g'},
+	{.name = "rules",         .has_arg = 0, .val = 'r'},
 	{NULL},
 };
 
@@ -154,19 +156,19 @@
 static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /* Well, it's better than "Re: Linux vs FreeBSD" */
 {
-	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o  -f  --line -c */
-/*INSERT*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x',' '},
-/*DELETE*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x','x'},
-/*DELETE_NUM*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*REPLACE*/   {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x',' '},
-/*APPEND*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x',' '},
-/*LIST*/      {' ','x','x','x','x',' ',' ','x','x','x',' ','x'},
-/*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
-/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x'}
+	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o  -f --line -c -r */
+/*INSERT*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x',' ','x'},
+/*DELETE*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x','x','x'},
+/*DELETE_NUM*/{'x','x','x','x','x',' ','x','x','x','x','x','x','x'},
+/*REPLACE*/   {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x',' ','x'},
+/*APPEND*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x',' ','x'},
+/*LIST*/      {' ','x','x','x','x',' ',' ','x','x','x',' ','x',' '},
+/*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x','x','x'},
+/*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x','x','x'},
+/*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x','x'},
+/*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x','x'},
+/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x','x','x'},
+/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x','x'}
 };
 
 static int inverse_for_options[NUMBER_OF_OPT] =
@@ -183,6 +185,7 @@
 /* -f */ IPT_INV_FRAG,
 /*--line*/ 0,
 /* -c */ 0,
+/* -r */ 0,
 };
 
 const char *program_version;
@@ -336,6 +339,7 @@
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"
 "  --line-numbers		print line numbers when listing\n"
+"  --rules			print iptbles rule when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
 "[!] --fragment	-f		match second or further fragments only\n"
 "  --modprobe=<command>		try to insert modules using this command\n"
@@ -1101,6 +1105,223 @@
 	return found;
 }
 
+static void print_proto(u_int16_t proto, int invert)
+{
+	if (proto) {
+		unsigned int i;
+		const char *invertstr = invert ? "! " : "";
+
+		struct protoent *pent = getprotobynumber(proto);
+		if (pent) {
+			printf("-p %s%s ", invertstr, pent->p_name);
+			return;
+		}
+
+		for (i = 0; i < sizeof(chain_protos)/sizeof(struct pprot); i++)
+			if (chain_protos[i].num == proto) {
+				printf("-p %s%s ",
+				       invertstr, chain_protos[i].name);
+				return;
+			}
+
+		printf("-p %s%u ", invertstr, proto);
+	}
+}
+
+#define IP_PARTS_NATIVE(n)			\
+(unsigned int)((n)>>24)&0xFF,			\
+(unsigned int)((n)>>16)&0xFF,			\
+(unsigned int)((n)>>8)&0xFF,			\
+(unsigned int)((n)&0xFF)
+
+#define IP_PARTS(n) IP_PARTS_NATIVE(ntohl(n))
+
+/* This assumes that mask is contiguous, and byte-bounded. */
+static void
+print_iface(char letter, const char *iface, const unsigned char *mask,
+	    int invert)
+{
+	unsigned int i;
+
+	if (mask[0] == 0)
+		return;
+
+	printf("-%c %s", letter, invert ? "! " : "");
+
+	for (i = 0; i < IFNAMSIZ; i++) {
+		if (mask[i] != 0) {
+			if (iface[i] != '\0')
+				printf("%c", iface[i]);
+		} else {
+			/* we can access iface[i-1] here, because
+			 * a few lines above we make sure that mask[0] != 0 */
+			if (iface[i-1] != '\0')
+				printf("+");
+			break;
+		}
+	}
+
+	printf(" ");
+}
+
+static int print_match_save(const struct ipt_entry_match *e,
+			const struct ipt_ip *ip)
+{
+	struct xtables_match *match
+		= find_match(e->u.user.name, TRY_LOAD, NULL);
+
+	if (match) {
+		printf("-m %s ", e->u.user.name);
+
+		/* some matches don't provide a save function */
+		if (match->save)
+			match->save(ip, e);
+	} else {
+		if (e->u.match_size) {
+			fprintf(stderr,
+				"Can't find library for match `%s'\n",
+				e->u.user.name);
+			exit(1);
+		}
+	}
+	return 0;
+}
+
+/* print a given ip including mask if neccessary */
+static void print_ip(char *prefix, u_int32_t ip, u_int32_t mask, int invert)
+{
+	u_int32_t bits, hmask = ntohl(mask);
+	int i;
+
+	if (!mask && !ip && !invert)
+		return;
+
+	printf("%s %s%u.%u.%u.%u",
+		prefix,
+		invert ? "! " : "",
+		IP_PARTS(ip));
+
+	if (mask == 0xFFFFFFFFU) {
+		printf("/32 ");
+		return;
+	}
+
+	i    = 32;
+	bits = 0xFFFFFFFEU;
+	while (--i >= 0 && hmask != bits)
+		bits <<= 1;
+	if (i >= 0)
+		printf("/%u ", i);
+	else
+		printf("/%u.%u.%u.%u ", IP_PARTS(mask));
+}
+
+/* We want this to be readable, so only print out neccessary fields.
+ * Because that's the kind of world I want to live in.  */
+void print_rule(const struct ipt_entry *e,
+		iptc_handle_t *h, const char *chain, int counters)
+{
+	struct ipt_entry_target *t;
+	const char *target_name;
+
+	/* print counters */
+	if (counters)
+		printf("[%llu:%llu] ", (unsigned long long)e->counters.pcnt, (unsigned long long)e->counters.bcnt);
+
+	/* print chain name */
+	printf("-A %s ", chain);
+
+	/* Print IP part. */
+	print_ip("-s", e->ip.src.s_addr,e->ip.smsk.s_addr,
+			e->ip.invflags & IPT_INV_SRCIP);
+
+	print_ip("-d", e->ip.dst.s_addr, e->ip.dmsk.s_addr,
+			e->ip.invflags & IPT_INV_DSTIP);
+
+	print_iface('i', e->ip.iniface, e->ip.iniface_mask,
+		    e->ip.invflags & IPT_INV_VIA_IN);
+
+	print_iface('o', e->ip.outiface, e->ip.outiface_mask,
+		    e->ip.invflags & IPT_INV_VIA_OUT);
+
+	print_proto(e->ip.proto, e->ip.invflags & IPT_INV_PROTO);
+
+	if (e->ip.flags & IPT_F_FRAG)
+		printf("%s-f ",
+		       e->ip.invflags & IPT_INV_FRAG ? "! " : "");
+
+	/* Print matchinfo part */
+	if (e->target_offset) {
+		IPT_MATCH_ITERATE(e, print_match_save, &e->ip);
+	}
+
+	/* Print target name */
+	target_name = iptc_get_target(e, h);
+	if (target_name && (*target_name != '\0'))
+#ifdef IPT_F_GOTO
+		printf("-%c %s ", e->ip.flags & IPT_F_GOTO ? 'g' : 'j', target_name);
+#else
+		printf("-j %s ", target_name);
+#endif
+
+	/* Print targinfo part */
+	t = ipt_get_target((struct ipt_entry *)e);
+	if (t->u.user.name[0]) {
+		struct xtables_target *target
+			= find_target(t->u.user.name, TRY_LOAD);
+
+		if (!target) {
+			fprintf(stderr, "Can't find library for target `%s'\n",
+				t->u.user.name);
+			exit(1);
+		}
+
+		if (target->save)
+			target->save(&e->ip, t);
+		else {
+			/* If the target size is greater than ipt_entry_target
+			 * there is something to be saved, we just don't know
+			 * how to print it */
+			if (t->u.target_size !=
+			    sizeof(struct ipt_entry_target)) {
+				fprintf(stderr, "Target `%s' is missing "
+						"save function\n",
+					t->u.user.name);
+				exit(1);
+			}
+		}
+	}
+	printf("\n");
+}
+
+static int
+list_rules(const ipt_chainlabel chain, int counters,
+	     iptc_handle_t *handle)
+{
+	const char *this = NULL;
+	int found = 0;
+
+	for (this = iptc_first_chain(handle);
+	     this;
+	     this = iptc_next_chain(handle)) {
+		const struct ipt_entry *e;
+
+		if (chain && strcmp(this, chain) != 0)
+			continue;
+
+		/* Dump out rules */
+		e = iptc_first_rule(this, handle);
+		while(e) {
+			print_rule(e, handle, this, counters);
+			e = iptc_next_rule(e, handle);
+		}
+		found = 1;
+	}
+
+	errno = ENOENT;
+	return found;
+}
+
 static struct ipt_entry *
 generate_entry(const struct ipt_entry *fw,
 	       struct iptables_rule_match *matches,
@@ -1544,6 +1765,10 @@
 			fw.counters.bcnt = cnt;
 			break;
 
+		case 'r':
+			set_option(&options, OPT_RULES, &fw.ip.invflags,
+				   invert);
+			break;
 
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
@@ -1808,8 +2033,13 @@
 				   handle);
 		break;
 	case CMD_LIST:
-		ret = list_entries(chain,
+		if (options&OPT_RULES)
+			ret = list_rules(chain,
 				   options&OPT_VERBOSE,
+				   handle);
+		else
+			ret = list_entries(chain,
+				   options&OPT_VERBOSE,
 				   options&OPT_NUMERIC,
 				   options&OPT_EXPANDED,
 				   options&OPT_LINENUMBERS,
@@ -1822,8 +2052,13 @@
 		ret = zero_entries(chain, options&OPT_VERBOSE, handle);
 		break;
 	case CMD_LIST|CMD_ZERO:
-		ret = list_entries(chain,
+		if (options&OPT_RULES)
+			ret = list_rules(chain,
 				   options&OPT_VERBOSE,
+				   handle);
+		else
+			ret = list_entries(chain,
+				   options&OPT_VERBOSE,
 				   options&OPT_NUMERIC,
 				   options&OPT_EXPANDED,
 				   options&OPT_LINENUMBERS,
Index: ip6tables.8.in
===================================================================
--- ip6tables.8.in	(revision 7519)
+++ ip6tables.8.in	(working copy)
@@ -373,6 +373,10 @@
 When listing rules, add line numbers to the beginning of each rule,
 corresponding to that rule's position in the chain.
 .TP
+.B "--rules"
+When listing rules, print the actual iptables rule as it would be
+entered on the command line.
+.TP
 .B "--modprobe=command"
 When adding or inserting rules into a chain, use
 .B command
Index: ip6tables-save.c
===================================================================
--- ip6tables-save.c	(revision 7519)
+++ ip6tables-save.c	(working copy)
@@ -33,199 +33,6 @@
 };
 
 
-/* This assumes that mask is contiguous, and byte-bounded. */
-static void
-print_iface(char letter, const char *iface, const unsigned char *mask,
-	    int invert)
-{
-	unsigned int i;
-
-	if (mask[0] == 0)
-		return;
-
-	printf("-%c %s", letter, invert ? "! " : "");
-
-	for (i = 0; i < IFNAMSIZ; i++) {
-		if (mask[i] != 0) {
-			if (iface[i] != '\0')
-				printf("%c", iface[i]);
-		} else {
-			/* we can access iface[i-1] here, because
-			 * a few lines above we make sure that mask[0] != 0 */
-			if (iface[i-1] != '\0')
-				printf("+");
-			break;
-		}
-	}
-
-	printf(" ");
-}
-
-/* These are hardcoded backups in ip6tables.c, so they are safe */
-struct pprot {
-	char *name;
-	u_int8_t num;
-};
-
-static const struct pprot chain_protos[] = {
-	{ "tcp", IPPROTO_TCP },
-	{ "udp", IPPROTO_UDP },
-	{ "icmpv6", IPPROTO_ICMPV6 },
-	{ "esp", IPPROTO_ESP },
-	{ "ah", IPPROTO_AH },
-};
-
-/* The ip6tables looks up the /etc/protocols. */
-static void print_proto(u_int16_t proto, int invert)
-{
-	if (proto) {
-		unsigned int i;
-		const char *invertstr = invert ? "! " : "";
-
-		struct protoent *pent = getprotobynumber(proto);
-		if (pent) {
-			printf("-p %s%s ",
-			       invertstr, pent->p_name);
-			return;
-		}
-
-		for (i = 0; i < sizeof(chain_protos)/sizeof(struct pprot); i++)
-			if (chain_protos[i].num == proto) {
-				printf("-p %s%s ",
-				       invertstr, chain_protos[i].name);
-				return;
-			}
-
-		printf("-p %s%u ", invertstr, proto);
-	}
-}
-
-static int print_match(const struct ip6t_entry_match *e,
-			const struct ip6t_ip6 *ip)
-{
-	struct xtables_match *match
-		= find_match(e->u.user.name, TRY_LOAD, NULL);
-
-	if (match) {
-		printf("-m %s ", e->u.user.name);
-
-		/* some matches don't provide a save function */
-		if (match->save)
-			match->save(ip, e);
-	} else {
-		if (e->u.match_size) {
-			fprintf(stderr,
-				"Can't find library for match `%s'\n",
-				e->u.user.name);
-			exit(1);
-		}
-	}
-	return 0;
-}
-
-/* print a given ip including mask if neccessary */
-static void print_ip(char *prefix, const struct in6_addr *ip, const struct in6_addr *mask, int invert)
-{
-	char buf[51];
-	int l = ipv6_prefix_length(mask);
-
-	if (l == 0 && !invert)
-		return;
-
-	printf("%s %s%s",
-		prefix,
-		invert ? "! " : "",
-		inet_ntop(AF_INET6, ip, buf, sizeof buf));
-
-	if (l == -1)
-		printf("/%s ", inet_ntop(AF_INET6, mask, buf, sizeof buf));
-	else
-		printf("/%d ", l);
-}
-
-/* We want this to be readable, so only print out neccessary fields.
- * Because that's the kind of world I want to live in.  */
-static void print_rule(const struct ip6t_entry *e,
-		       ip6tc_handle_t *h, const char *chain, int counters)
-{
-	struct ip6t_entry_target *t;
-	const char *target_name;
-
-	/* print counters */
-	if (counters)
-		printf("[%llu:%llu] ", (unsigned long long)e->counters.pcnt, (unsigned long long)e->counters.bcnt);
-
-	/* print chain name */
-	printf("-A %s ", chain);
-
-	/* Print IP part. */
-	print_ip("-s", &(e->ipv6.src), &(e->ipv6.smsk),
-			e->ipv6.invflags & IP6T_INV_SRCIP);
-
-	print_ip("-d", &(e->ipv6.dst), &(e->ipv6.dmsk),
-			e->ipv6.invflags & IP6T_INV_DSTIP);
-
-	print_iface('i', e->ipv6.iniface, e->ipv6.iniface_mask,
-		    e->ipv6.invflags & IP6T_INV_VIA_IN);
-
-	print_iface('o', e->ipv6.outiface, e->ipv6.outiface_mask,
-		    e->ipv6.invflags & IP6T_INV_VIA_OUT);
-
-	print_proto(e->ipv6.proto, e->ipv6.invflags & IP6T_INV_PROTO);
-
-#if 0
-	/* not definied in ipv6
-	 * FIXME: linux/netfilter_ipv6/ip6_tables: IP6T_INV_FRAG why definied? */
-	if (e->ipv6.flags & IPT_F_FRAG)
-		printf("%s-f ",
-		       e->ipv6.invflags & IP6T_INV_FRAG ? "! " : "");
-#endif
-
-	if (e->ipv6.flags & IP6T_F_TOS)
-		printf("%s-? %d ",
-		       e->ipv6.invflags & IP6T_INV_TOS ? "! " : "",
-		       e->ipv6.tos);
-
-	/* Print matchinfo part */
-	if (e->target_offset) {
-		IP6T_MATCH_ITERATE(e, print_match, &e->ipv6);
-	}
-
-	/* Print target name */
-	target_name = ip6tc_get_target(e, h);
-	if (target_name && (*target_name != '\0'))
-		printf("-j %s ", target_name);
-
-	/* Print targinfo part */
-	t = ip6t_get_target((struct ip6t_entry *)e);
-	if (t->u.user.name[0]) {
-		struct xtables_target *target
-			= find_target(t->u.user.name, TRY_LOAD);
-
-		if (!target) {
-			fprintf(stderr, "Can't find library for target `%s'\n",
-				t->u.user.name);
-			exit(1);
-		}
-
-		if (target->save)
-			target->save(&e->ipv6, t);
-		else {
-			/* If the target size is greater than ip6t_entry_target
-			 * there is something to be saved, we just don't know
-			 * how to print it */
-			if (t->u.target_size !=
-			    sizeof(struct ip6t_entry_target)) {
-				fprintf(stderr, "Target `%s' is missing "
-						"save function\n",
-					t->u.user.name);
-				exit(1);
-			}
-		}
-	}
-	printf("\n");
-}
-
 /* Debugging prototype. */
 static int for_each_table(int (*func)(const char *tablename))
 {
Index: ip6tables.c
===================================================================
--- ip6tables.c	(revision 7519)
+++ ip6tables.c	(working copy)
@@ -96,9 +96,10 @@
 #define OPT_VIANAMEOUT	0x00100U
 #define OPT_LINENUMBERS 0x00200U
 #define OPT_COUNTERS	0x00400U
-#define NUMBER_OF_OPT	11
+#define OPT_RULES	0x00800U
+#define NUMBER_OF_OPT	13
 static const char optflags[NUMBER_OF_OPT]
-= { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '0', 'c'};
+= { 'n', 's', 'd', 'p', 'j', 'v', 'x', 'i', 'o', '0', 'c', 'r'};
 
 static struct option original_opts[] = {
 	{.name = "append",        .has_arg = 1, .val = 'A'},
@@ -130,6 +131,7 @@
 	{.name = "line-numbers",  .has_arg = 0, .val = '0'},
 	{.name = "modprobe",      .has_arg = 1, .val = 'M'},
 	{.name = "set-counters",  .has_arg = 1, .val = 'c'},
+	{.name = "rules",         .has_arg = 0, .val = 'r'},
 	{NULL},
 };
 
@@ -154,19 +156,19 @@
 static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /* Well, it's better than "Re: Linux vs FreeBSD" */
 {
-	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o  --line -c */
-/*INSERT*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' '},
-/*DELETE*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x'},
-/*DELETE_NUM*/{'x','x','x','x','x',' ','x','x','x','x','x'},
-/*REPLACE*/   {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' '},
-/*APPEND*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' '},
-/*LIST*/      {' ','x','x','x','x',' ',' ','x','x',' ','x'},
-/*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x'},
-/*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x'},
-/*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
-/*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
-/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x'},
-/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x'}
+	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o --line -c -r */
+/*INSERT*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' ','x'},
+/*DELETE*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x','x'},
+/*DELETE_NUM*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*REPLACE*/   {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' ','x'},
+/*APPEND*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' ','x'},
+/*LIST*/      {' ','x','x','x','x',' ',' ','x','x',' ','x',' '},
+/*FLUSH*/     {'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*ZERO*/      {'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x'}
 };
 
 static int inverse_for_options[NUMBER_OF_OPT] =
@@ -182,6 +184,7 @@
 /* -o */ IP6T_INV_VIA_OUT,
 /*--line*/ 0,
 /* -c */ 0,
+/* -r */ 0,
 };
 
 const char *program_version;
@@ -329,6 +332,7 @@
 "  --table	-t table	table to manipulate (default: `filter')\n"
 "  --verbose	-v		verbose mode\n"
 "  --line-numbers		print line numbers when listing\n"
+"  --rules			print iptbles rule when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
 /*"[!] --fragment	-f		match second or further fragments only\n"*/
 "  --modprobe=<command>		try to insert modules using this command\n"
@@ -1098,6 +1102,213 @@
 	return found;
 }
 
+/* This assumes that mask is contiguous, and byte-bounded. */
+static void
+print_iface(char letter, const char *iface, const unsigned char *mask,
+	    int invert)
+{
+	unsigned int i;
+
+	if (mask[0] == 0)
+		return;
+
+	printf("-%c %s", letter, invert ? "! " : "");
+
+	for (i = 0; i < IFNAMSIZ; i++) {
+		if (mask[i] != 0) {
+			if (iface[i] != '\0')
+				printf("%c", iface[i]);
+		} else {
+			/* we can access iface[i-1] here, because
+			 * a few lines above we make sure that mask[0] != 0 */
+			if (iface[i-1] != '\0')
+				printf("+");
+			break;
+		}
+	}
+
+	printf(" ");
+}
+
+/* The ip6tables looks up the /etc/protocols. */
+static void print_proto(u_int16_t proto, int invert)
+{
+	if (proto) {
+		unsigned int i;
+		const char *invertstr = invert ? "! " : "";
+
+		struct protoent *pent = getprotobynumber(proto);
+		if (pent) {
+			printf("-p %s%s ",
+			       invertstr, pent->p_name);
+			return;
+		}
+
+		for (i = 0; i < sizeof(chain_protos)/sizeof(struct pprot); i++)
+			if (chain_protos[i].num == proto) {
+				printf("-p %s%s ",
+				       invertstr, chain_protos[i].name);
+				return;
+			}
+
+		printf("-p %s%u ", invertstr, proto);
+	}
+}
+
+static int print_match_save(const struct ip6t_entry_match *e,
+			const struct ip6t_ip6 *ip)
+{
+	struct xtables_match *match
+		= find_match(e->u.user.name, TRY_LOAD, NULL);
+
+	if (match) {
+		printf("-m %s ", e->u.user.name);
+
+		/* some matches don't provide a save function */
+		if (match->save)
+			match->save(ip, e);
+	} else {
+		if (e->u.match_size) {
+			fprintf(stderr,
+				"Can't find library for match `%s'\n",
+				e->u.user.name);
+			exit(1);
+		}
+	}
+	return 0;
+}
+
+/* print a given ip including mask if neccessary */
+static void print_ip(char *prefix, const struct in6_addr *ip, const struct in6_addr *mask, int invert)
+{
+	char buf[51];
+	int l = ipv6_prefix_length(mask);
+
+	if (l == 0 && !invert)
+		return;
+
+	printf("%s %s%s",
+		prefix,
+		invert ? "! " : "",
+		inet_ntop(AF_INET6, ip, buf, sizeof buf));
+
+	if (l == -1)
+		printf("/%s ", inet_ntop(AF_INET6, mask, buf, sizeof buf));
+	else
+		printf("/%d ", l);
+}
+
+/* We want this to be readable, so only print out neccessary fields.
+ * Because that's the kind of world I want to live in.  */
+void print_rule(const struct ip6t_entry *e,
+		       ip6tc_handle_t *h, const char *chain, int counters)
+{
+	struct ip6t_entry_target *t;
+	const char *target_name;
+
+	/* print counters */
+	if (counters)
+		printf("[%llu:%llu] ", (unsigned long long)e->counters.pcnt, (unsigned long long)e->counters.bcnt);
+
+	/* print chain name */
+	printf("-A %s ", chain);
+
+	/* Print IP part. */
+	print_ip("-s", &(e->ipv6.src), &(e->ipv6.smsk),
+			e->ipv6.invflags & IP6T_INV_SRCIP);
+
+	print_ip("-d", &(e->ipv6.dst), &(e->ipv6.dmsk),
+			e->ipv6.invflags & IP6T_INV_DSTIP);
+
+	print_iface('i', e->ipv6.iniface, e->ipv6.iniface_mask,
+		    e->ipv6.invflags & IP6T_INV_VIA_IN);
+
+	print_iface('o', e->ipv6.outiface, e->ipv6.outiface_mask,
+		    e->ipv6.invflags & IP6T_INV_VIA_OUT);
+
+	print_proto(e->ipv6.proto, e->ipv6.invflags & IP6T_INV_PROTO);
+
+#if 0
+	/* not definied in ipv6
+	 * FIXME: linux/netfilter_ipv6/ip6_tables: IP6T_INV_FRAG why definied? */
+	if (e->ipv6.flags & IPT_F_FRAG)
+		printf("%s-f ",
+		       e->ipv6.invflags & IP6T_INV_FRAG ? "! " : "");
+#endif
+
+	if (e->ipv6.flags & IP6T_F_TOS)
+		printf("%s-? %d ",
+		       e->ipv6.invflags & IP6T_INV_TOS ? "! " : "",
+		       e->ipv6.tos);
+
+	/* Print matchinfo part */
+	if (e->target_offset) {
+		IP6T_MATCH_ITERATE(e, print_match_save, &e->ipv6);
+	}
+
+	/* Print target name */
+	target_name = ip6tc_get_target(e, h);
+	if (target_name && (*target_name != '\0'))
+		printf("-j %s ", target_name);
+
+	/* Print targinfo part */
+	t = ip6t_get_target((struct ip6t_entry *)e);
+	if (t->u.user.name[0]) {
+		struct xtables_target *target
+			= find_target(t->u.user.name, TRY_LOAD);
+
+		if (!target) {
+			fprintf(stderr, "Can't find library for target `%s'\n",
+				t->u.user.name);
+			exit(1);
+		}
+
+		if (target->save)
+			target->save(&e->ipv6, t);
+		else {
+			/* If the target size is greater than ip6t_entry_target
+			 * there is something to be saved, we just don't know
+			 * how to print it */
+			if (t->u.target_size !=
+			    sizeof(struct ip6t_entry_target)) {
+				fprintf(stderr, "Target `%s' is missing "
+						"save function\n",
+					t->u.user.name);
+				exit(1);
+			}
+		}
+	}
+	printf("\n");
+}
+
+static int
+list_rules(const ip6t_chainlabel chain, int counters,
+	     ip6tc_handle_t *handle)
+{
+	const char *this = NULL;
+	int found = 0;
+
+	for (this = ip6tc_first_chain(handle);
+	     this;
+	     this = ip6tc_next_chain(handle)) {
+		const struct ip6t_entry *e;
+
+		if (chain && strcmp(this, chain) != 0)
+			continue;
+
+		/* Dump out rules */
+		e = ip6tc_first_rule(this, handle);
+		while(e) {
+			print_rule(e, handle, this, counters);
+			e = ip6tc_next_rule(e, handle);
+		}
+		found = 1;
+	}
+
+	errno = ENOENT;
+	return found;
+}
+
 static struct ip6t_entry *
 generate_entry(const struct ip6t_entry *fw,
 	       struct ip6tables_rule_match *matches,
@@ -1515,6 +1726,10 @@
 
 			break;
 
+		case 'r':
+			set_option(&options, OPT_RULES, &fw.ip.invflags,
+				   invert);
+			break;
 
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
@@ -1768,8 +1983,13 @@
 				   handle);
 		break;
 	case CMD_LIST:
-		ret = list_entries(chain,
+		if (options&OPT_RULES)
+			ret = list_rules(chain,
 				   options&OPT_VERBOSE,
+				   handle);
+		else
+			ret = list_entries(chain,
+				   options&OPT_VERBOSE,
 				   options&OPT_NUMERIC,
 				   options&OPT_EXPANDED,
 				   options&OPT_LINENUMBERS,
@@ -1782,8 +2002,13 @@
 		ret = zero_entries(chain, options&OPT_VERBOSE, handle);
 		break;
 	case CMD_LIST|CMD_ZERO:
-		ret = list_entries(chain,
+		if (options&OPT_RULES)
+			ret = list_rules(chain,
 				   options&OPT_VERBOSE,
+				   handle);
+		else
+			ret = list_entries(chain,
+				   options&OPT_VERBOSE,
 				   options&OPT_NUMERIC,
 				   options&OPT_EXPANDED,
 				   options&OPT_LINENUMBERS,

--=-mPLRQ8gj7lEiQYnveYf9--

