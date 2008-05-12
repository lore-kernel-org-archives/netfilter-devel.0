From: Henrik Nordstrom <henrik@henriknordstrom.net>
Subject: [patch 3/4] iptables --list-rules command
Date: Mon, 12 May 2008 20:38:19 +0200
Message-ID: <1210617499.3442.41.camel@henriknordstrom.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-jiThNsmaTUY8Z+0mWBio"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from vps1.henriknordstrom.net ([195.20.207.177]:38360 "EHLO
	vps1.henriknordstrom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755907AbYELSih (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 May 2008 14:38:37 -0400
Received: from henriknordstrom.net (183.159.216.81.static.tb.siw.siwnet.net [81.216.159.183])
	by vps1.henriknordstrom.net (8.13.8/8.13.8/Debian-3) with ESMTP id m4CIcIYU028325
	for <netfilter-devel@vger.kernel.org>; Mon, 12 May 2008 20:38:18 +0200
Received: from henrik ([127.0.0.1])
	(authenticated bits=0)
	by henriknordstrom.net (8.12.11.20060308/8.12.8) with ESMTP id m4CIcJ8U029515
	(version=TLSv1/SSLv3 cipher=RC4-MD5 bits=128 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Mon, 12 May 2008 20:38:19 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-jiThNsmaTUY8Z+0mWBio
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

Adds iptables --list-rules (-S) command, acting as a combination of
iptables --list and iptables-save.

The primary motivation behind this patch is to get iptables-save like
output capabilities in iptables-restore, allowing "iptables-restore -n"
to be used as a consistent API to iptables for all kind of operations,
not only blind updates..

As a bonus iptables also gets the capability of printing the rules
as-is.

This completely replaces the earlier patch which added the --rules
option.

Regards
Henrik

--=-jiThNsmaTUY8Z+0mWBio
Content-Disposition: attachment; filename=iptables-list-rules.patch
Content-Type: text/x-patch; name=iptables-list-rules.patch; charset=UTF-8
Content-Transfer-Encoding: 7bit

Index: iptables/include/ip6tables.h
===================================================================
--- iptables.orig/include/ip6tables.h
+++ iptables/include/ip6tables.h
@@ -22,5 +22,6 @@ extern int do_command6(int argc, char *a
 extern int for_each_chain(int (*fn)(const ip6t_chainlabel, int, ip6tc_handle_t *), int verbose, int builtinstoo, ip6tc_handle_t *handle);
 extern int flush_entries(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle);
 extern int delete_chain(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle);
+void print_rule(const struct ip6t_entry *e, ip6tc_handle_t *h, const char *chain, int counters);
 
 #endif /*_IP6TABLES_USER_H*/
Index: iptables/include/iptables.h
===================================================================
--- iptables.orig/include/iptables.h
+++ iptables/include/iptables.h
@@ -23,6 +23,8 @@ extern int flush_entries(const ipt_chain
 			iptc_handle_t *handle);
 extern int for_each_chain(int (*fn)(const ipt_chainlabel, int, iptc_handle_t *),
 		int verbose, int builtinstoo, iptc_handle_t *handle);
+extern void print_rule(const struct ipt_entry *e,
+		iptc_handle_t *handle, const char *chain, int counters);
 
 /* kernel revision handling */
 extern int kernel_version;
Index: iptables/ip6tables-save.c
===================================================================
--- iptables.orig/ip6tables-save.c
+++ iptables/ip6tables-save.c
@@ -33,199 +33,6 @@ static const struct option options[] = {
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
Index: iptables/ip6tables.8.in
===================================================================
--- iptables.orig/ip6tables.8.in
+++ iptables/ip6tables.8.in
@@ -197,6 +197,11 @@ arguments given. The exact rules are sup
  ip6tables -L -v
 .fi
 .TP
+.BR "-S, --list-rules " "[\fIchain\fP]"
+Print all rules in the selected chain.  If no chain is selected, all
+chains are printed like iptables-save. Like every other iptables command,
+it applies to the specified table (filter is the default).
+.TP
 .BR "-F, --flush " "[\fIchain\fP]"
 Flush the selected chain (all the chains in the table if none is given).
 This is equivalent to deleting all the rules one by one.
Index: iptables/ip6tables.c
===================================================================
--- iptables.orig/ip6tables.c
+++ iptables/ip6tables.c
@@ -78,9 +78,10 @@
 #define CMD_DELETE_CHAIN	0x0200U
 #define CMD_SET_POLICY		0x0400U
 #define CMD_RENAME_CHAIN	0x0800U
-#define NUMBER_OF_CMD	13
+#define CMD_LIST_RULES		0x1000U
+#define NUMBER_OF_CMD	14
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
-				 'N', 'X', 'P', 'E' };
+				 'N', 'X', 'P', 'E', 'S' };
 
 #define OPTION_OFFSET 256
 
@@ -106,6 +107,7 @@ static struct option original_opts[] = {
 	{.name = "insert",        .has_arg = 1, .val = 'I'},
 	{.name = "replace",       .has_arg = 1, .val = 'R'},
 	{.name = "list",          .has_arg = 2, .val = 'L'},
+	{.name = "list-rules",    .has_arg = 2, .val = 'S'},
 	{.name = "flush",         .has_arg = 2, .val = 'F'},
 	{.name = "zero",          .has_arg = 2, .val = 'Z'},
 	{.name = "new-chain",     .has_arg = 1, .val = 'N'},
@@ -154,7 +156,7 @@ static unsigned int global_option_offset
 static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /* Well, it's better than "Re: Linux vs FreeBSD" */
 {
-	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o  --line -c */
+	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o --line -c */
 /*INSERT*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x',' '},
 /*DELETE*/    {'x',' ',' ',' ',' ',' ','x',' ',' ','x','x'},
 /*DELETE_NUM*/{'x','x','x','x','x',' ','x','x','x','x','x'},
@@ -166,7 +168,8 @@ static char commands_v_options[NUMBER_OF
 /*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
 /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x'},
 /*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x',' '},
-/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x'}
+/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x'},
+/*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x'}
 };
 
 static int inverse_for_options[NUMBER_OF_OPT] =
@@ -300,6 +303,8 @@ exit_printhelp(struct ip6tables_rule_mat
 "  --replace -R chain rulenum\n"
 "				Replace rule rulenum (1 = first) in chain\n"
 "  --list    -L [chain]		List the rules in a chain or all chains\n"
+"  --list-rules\n"
+"            -S [chain]         Print the rules in a chain or all chains\n"
 "  --flush   -F [chain]		Delete all rules in  chain or all chains\n"
 "  --zero    -Z [chain]		Zero counters in chain or all chains\n"
 "  --new     -N chain		Create a new user-defined chain\n"
@@ -1098,6 +1103,239 @@ list_entries(const ip6t_chainlabel chain
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
+	/* print counters for iptables-save */
+	if (counters > 0)
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
+	/* print counters for iptables -R */
+	if (counters < 0)
+		printf("-c %llu %llu ", (unsigned long long)e->counters.pcnt, (unsigned long long)e->counters.bcnt);
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
+	if (counters)
+	    counters = -1;		/* iptables -c format */
+
+	/* Dump out chain names first,
+	 * thereby preventing dependency conflicts */
+	for (this = ip6tc_first_chain(handle);
+	     this;
+	     this = ip6tc_next_chain(handle)) {
+		if (chain && strcmp(this, chain) != 0)
+			continue;
+
+		if (ip6tc_builtin(this, *handle)) {
+			struct ip6t_counters count;
+			printf("-P %s %s", this, ip6tc_get_policy(this, &count, handle));
+			if (counters)
+			    printf(" -c %llu %llu", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
+			printf("\n");
+		} else {
+			printf("-N %s\n", this);
+		}
+	}
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
@@ -1201,7 +1439,7 @@ int do_command6(int argc, char *argv[], 
 	opterr = 0;
 
 	while ((c = getopt_long(argc, argv,
-	   "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:",
+	   "-A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:",
 					   opts, NULL)) != -1) {
 		switch (c) {
 			/*
@@ -1256,6 +1494,15 @@ int do_command6(int argc, char *argv[], 
 				chain = argv[optind++];
 			break;
 
+		case 'S':
+			add_command(&command, CMD_LIST_RULES, CMD_ZERO,
+				    invert);
+			if (optarg) chain = optarg;
+			else if (optind < argc && argv[optind][0] != '-'
+				 && argv[optind][0] != '!')
+				chain = argv[optind++];
+			break;
+
 		case 'F':
 			add_command(&command, CMD_FLUSH, CMD_NONE,
 				    invert);
@@ -1266,7 +1513,7 @@ int do_command6(int argc, char *argv[], 
 			break;
 
 		case 'Z':
-			add_command(&command, CMD_ZERO, CMD_LIST,
+			add_command(&command, CMD_ZERO, CMD_LIST|CMD_LIST_RULES,
 				    invert);
 			if (optarg) chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
@@ -1515,7 +1762,6 @@ int do_command6(int argc, char *argv[], 
 
 			break;
 
-
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
 				if (invert)
@@ -1767,20 +2013,13 @@ int do_command6(int argc, char *argv[], 
 				   options&OPT_VERBOSE,
 				   handle);
 		break;
-	case CMD_LIST:
-		ret = list_entries(chain,
-				   options&OPT_VERBOSE,
-				   options&OPT_NUMERIC,
-				   options&OPT_EXPANDED,
-				   options&OPT_LINENUMBERS,
-				   handle);
-		break;
 	case CMD_FLUSH:
 		ret = flush_entries(chain, options&OPT_VERBOSE, handle);
 		break;
 	case CMD_ZERO:
 		ret = zero_entries(chain, options&OPT_VERBOSE, handle);
 		break;
+	case CMD_LIST:
 	case CMD_LIST|CMD_ZERO:
 		ret = list_entries(chain,
 				   options&OPT_VERBOSE,
@@ -1788,7 +2027,16 @@ int do_command6(int argc, char *argv[], 
 				   options&OPT_EXPANDED,
 				   options&OPT_LINENUMBERS,
 				   handle);
-		if (ret)
+		if (ret && (command & CMD_ZERO))
+			ret = zero_entries(chain,
+					   options&OPT_VERBOSE, handle);
+		break;
+	case CMD_LIST_RULES:
+	case CMD_LIST_RULES|CMD_ZERO:
+		ret = list_rules(chain,
+				   options&OPT_VERBOSE,
+				   handle);
+		if (ret && (command & CMD_ZERO))
 			ret = zero_entries(chain,
 					   options&OPT_VERBOSE, handle);
 		break;
Index: iptables/iptables-save.c
===================================================================
--- iptables.orig/iptables-save.c
+++ iptables/iptables-save.c
@@ -31,211 +31,6 @@ static const struct option options[] = {
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
Index: iptables/iptables.8.in
===================================================================
--- iptables.orig/iptables.8.in
+++ iptables/iptables.8.in
@@ -205,6 +205,11 @@ arguments given. The exact rules are sup
  iptables -L -v
 .fi
 .TP
+.BR "-S, --list-rules " "[\fIchain\fP]"
+Print all rules in the selected chain.  If no chain is selected, all
+chains are printed like iptables-save. Like every other iptables command,
+it applies to the specified table (filter is the default).
+.TP
 .BR "-F, --flush " "[\fIchain\fP]"
 Flush the selected chain (all the chains in the table if none is given).
 This is equivalent to deleting all the rules one by one.
Index: iptables/iptables.c
===================================================================
--- iptables.orig/iptables.c
+++ iptables/iptables.c
@@ -75,9 +75,10 @@
 #define CMD_DELETE_CHAIN	0x0200U
 #define CMD_SET_POLICY		0x0400U
 #define CMD_RENAME_CHAIN	0x0800U
-#define NUMBER_OF_CMD	13
+#define CMD_LIST_RULES		0x1000U
+#define NUMBER_OF_CMD	14
 static const char cmdflags[] = { 'I', 'D', 'D', 'R', 'A', 'L', 'F', 'Z',
-				 'N', 'X', 'P', 'E' };
+				 'N', 'X', 'P', 'E', 'S' };
 
 #define OPTION_OFFSET 256
 
@@ -104,6 +105,7 @@ static struct option original_opts[] = {
 	{.name = "insert",        .has_arg = 1, .val = 'I'},
 	{.name = "replace",       .has_arg = 1, .val = 'R'},
 	{.name = "list",          .has_arg = 2, .val = 'L'},
+	{.name = "list-rules",    .has_arg = 2, .val = 'S'},
 	{.name = "flush",         .has_arg = 2, .val = 'F'},
 	{.name = "zero",          .has_arg = 2, .val = 'Z'},
 	{.name = "new-chain",     .has_arg = 1, .val = 'N'},
@@ -154,7 +156,7 @@ static unsigned int global_option_offset
 static char commands_v_options[NUMBER_OF_CMD][NUMBER_OF_OPT] =
 /* Well, it's better than "Re: Linux vs FreeBSD" */
 {
-	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o  -f  --line -c */
+	/*     -n  -s  -d  -p  -j  -v  -x  -i  -o  -f --line -c */
 /*INSERT*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x',' '},
 /*DELETE*/    {'x',' ',' ',' ',' ',' ','x',' ',' ',' ','x','x'},
 /*DELETE_NUM*/{'x','x','x','x','x',' ','x','x','x','x','x','x'},
@@ -166,7 +168,8 @@ static char commands_v_options[NUMBER_OF
 /*NEW_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*DEL_CHAIN*/ {'x','x','x','x','x',' ','x','x','x','x','x','x'},
 /*SET_POLICY*/{'x','x','x','x','x',' ','x','x','x','x','x',' '},
-/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x'}
+/*RENAME*/    {'x','x','x','x','x',' ','x','x','x','x','x','x'},
+/*LIST_RULES*/{'x','x','x','x','x',' ','x','x','x','x','x','x'}
 };
 
 static int inverse_for_options[NUMBER_OF_OPT] =
@@ -303,6 +306,8 @@ exit_printhelp(struct iptables_rule_matc
 "  --replace -R chain rulenum\n"
 "				Replace rule rulenum (1 = first) in chain\n"
 "  --list    -L [chain]		List the rules in a chain or all chains\n"
+"  --list-rules\n"
+"            -S [chain]         Print the rules in a chain or all chains\n"
 "  --flush   -F [chain]		Delete all rules in  chain or all chains\n"
 "  --zero    -Z [chain]		Zero counters in chain or all chains\n"
 "  --new     -N chain		Create a new user-defined chain\n"
@@ -1101,6 +1106,249 @@ list_entries(const ipt_chainlabel chain,
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
+	/* print counters for iptables-save */
+	if (counters > 0)
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
+	/* print counters for iptables -R */
+	if (counters < 0)
+		printf("-c %llu %llu ", (unsigned long long)e->counters.pcnt, (unsigned long long)e->counters.bcnt);
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
+	if (counters)
+	    counters = -1;		/* iptables -c format */
+
+	/* Dump out chain names first,
+	 * thereby preventing dependency conflicts */
+	for (this = iptc_first_chain(handle);
+	     this;
+	     this = iptc_next_chain(handle)) {
+		if (chain && strcmp(this, chain) != 0)
+			continue;
+
+		if (iptc_builtin(this, *handle)) {
+			struct ipt_counters count;
+			printf("-P %s %s", this, iptc_get_policy(this, &count, handle));
+			if (counters)
+			    printf(" -c %llu %llu", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
+			printf("\n");
+		} else {
+			printf("-N %s\n", this);
+		}
+	}
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
@@ -1218,7 +1466,7 @@ int do_command(int argc, char *argv[], c
 	opterr = 0;
 
 	while ((c = getopt_long(argc, argv,
-	   "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
+	   "-A:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:",
 					   opts, NULL)) != -1) {
 		switch (c) {
 			/*
@@ -1273,6 +1521,15 @@ int do_command(int argc, char *argv[], c
 				chain = argv[optind++];
 			break;
 
+		case 'S':
+			add_command(&command, CMD_LIST_RULES, CMD_ZERO,
+				    invert);
+			if (optarg) chain = optarg;
+			else if (optind < argc && argv[optind][0] != '-'
+				 && argv[optind][0] != '!')
+				chain = argv[optind++];
+			break;
+
 		case 'F':
 			add_command(&command, CMD_FLUSH, CMD_NONE,
 				    invert);
@@ -1283,7 +1540,7 @@ int do_command(int argc, char *argv[], c
 			break;
 
 		case 'Z':
-			add_command(&command, CMD_ZERO, CMD_LIST,
+			add_command(&command, CMD_ZERO, CMD_LIST|CMD_LIST_RULES,
 				    invert);
 			if (optarg) chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
@@ -1807,20 +2064,13 @@ int do_command(int argc, char *argv[], c
 				   options&OPT_VERBOSE,
 				   handle);
 		break;
-	case CMD_LIST:
-		ret = list_entries(chain,
-				   options&OPT_VERBOSE,
-				   options&OPT_NUMERIC,
-				   options&OPT_EXPANDED,
-				   options&OPT_LINENUMBERS,
-				   handle);
-		break;
 	case CMD_FLUSH:
 		ret = flush_entries(chain, options&OPT_VERBOSE, handle);
 		break;
 	case CMD_ZERO:
 		ret = zero_entries(chain, options&OPT_VERBOSE, handle);
 		break;
+	case CMD_LIST:
 	case CMD_LIST|CMD_ZERO:
 		ret = list_entries(chain,
 				   options&OPT_VERBOSE,
@@ -1828,7 +2078,16 @@ int do_command(int argc, char *argv[], c
 				   options&OPT_EXPANDED,
 				   options&OPT_LINENUMBERS,
 				   handle);
-		if (ret)
+		if (ret && (command & CMD_ZERO))
+			ret = zero_entries(chain,
+					   options&OPT_VERBOSE, handle);
+		break;
+	case CMD_LIST_RULES:
+	case CMD_LIST_RULES|CMD_ZERO:
+		ret = list_rules(chain,
+				   options&OPT_VERBOSE,
+				   handle);
+		if (ret && (command & CMD_ZERO))
 			ret = zero_entries(chain,
 					   options&OPT_VERBOSE, handle);
 		break;

--=-jiThNsmaTUY8Z+0mWBio--

