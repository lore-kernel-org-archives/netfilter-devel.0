From: Max Kellermann <max@duempel.org>
Subject: [iptables PATCH trunk7285 2/7] whitespace cleanup
Date: Sun, 27 Jan 2008 19:25:03 +0100
Message-ID: <20080127182503.15959.57882.stgit@woodpecker.roonstrasse.net>
References: <20080127182421.15959.52088.stgit@woodpecker.roonstrasse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:56467 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753362AbYA0SgO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 27 Jan 2008 13:36:14 -0500
In-Reply-To: <20080127182421.15959.52088.stgit@woodpecker.roonstrasse.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


---

 extensions/libxt_quota.c |   56 +++++++++++++++++++++++-----------------------
 ip6tables-restore.c      |   38 ++++++++++++++++---------------
 ip6tables-save.c         |   30 ++++++++++++-------------
 ip6tables.c              |   30 ++++++++++++-------------
 iptables-restore.c       |   34 ++++++++++++++--------------
 iptables-save.c          |   22 +++++++++---------
 iptables.c               |   26 +++++++++++----------
 7 files changed, 118 insertions(+), 118 deletions(-)


diff --git a/extensions/libxt_quota.c b/extensions/libxt_quota.c
index 9f96226..7d73033 100644
--- a/extensions/libxt_quota.c
+++ b/extensions/libxt_quota.c
@@ -12,69 +12,69 @@
 #include <linux/netfilter/xt_quota.h>
 
 static const struct option quota_opts[] = {
-        {"quota", 1, NULL, '1'},
-        { }
+	{"quota", 1, NULL, '1'},
+	{ }
 };
 
 /* print usage */
 static void quota_help(void)
 {
-        printf("quota options:\n"
-               " --quota quota			quota (bytes)\n" "\n");
+	printf("quota options:\n"
+	       " --quota quota			quota (bytes)\n" "\n");
 }
 
 /* print matchinfo */
 static void
 quota_print(const void *ip, const struct xt_entry_match *match, int numeric)
 {
-        struct xt_quota_info *q = (struct xt_quota_info *) match->data;
-        printf("quota: %llu bytes", (unsigned long long) q->quota);
+	struct xt_quota_info *q = (struct xt_quota_info *) match->data;
+	printf("quota: %llu bytes", (unsigned long long) q->quota);
 }
 
 /* save matchinfo */
 static void
 quota_save(const void *ip, const struct xt_entry_match *match)
 {
-        struct xt_quota_info *q = (struct xt_quota_info *) match->data;
-        printf("--quota %llu ", (unsigned long long) q->quota);
+	struct xt_quota_info *q = (struct xt_quota_info *) match->data;
+	printf("--quota %llu ", (unsigned long long) q->quota);
 }
 
 /* parse quota option */
 static int
 parse_quota(const char *s, u_int64_t * quota)
 {
-        *quota = strtoull(s, (char **) NULL, 10);
+	*quota = strtoull(s, (char **) NULL, 10);
 
 #ifdef DEBUG_XT_QUOTA
-        printf("Quota: %llu\n", *quota);
+	printf("Quota: %llu\n", *quota);
 #endif
 
-        if (*quota == -1)
-                exit_error(PARAMETER_PROBLEM, "quota invalid: '%s'\n", s);
-        else
-                return 1;
+	if (*quota == -1)
+		exit_error(PARAMETER_PROBLEM, "quota invalid: '%s'\n", s);
+	else
+		return 1;
 }
 
 /* parse all options, returning true if we found any for us */
 static int
 quota_parse(int c, char **argv, int invert, unsigned int *flags,
-            const void *entry, struct xt_entry_match **match)
+	    const void *entry, struct xt_entry_match **match)
 {
-        struct xt_quota_info *info = (struct xt_quota_info *) (*match)->data;
+	struct xt_quota_info *info = (struct xt_quota_info *) (*match)->data;
 
-        switch (c) {
-        case '1':
-                if (check_inverse(optarg, &invert, NULL, 0))
-                        exit_error(PARAMETER_PROBLEM, "quota: unexpected '!'");
-                if (!parse_quota(optarg, &info->quota))
-                        exit_error(PARAMETER_PROBLEM,
-                                   "bad quota: '%s'", optarg);
-                break;
+	switch (c) {
+	case '1':
+		if (check_inverse(optarg, &invert, NULL, 0))
+			exit_error(PARAMETER_PROBLEM, "quota: unexpected '!'");
+		if (!parse_quota(optarg, &info->quota))
+			exit_error(PARAMETER_PROBLEM,
+				   "bad quota: '%s'", optarg);
+		break;
 
-        default:
-                return 0;
-        }
-        return 1;
+	default:
+		return 0;
+	}
+	return 1;
 }
 
 struct xtables_match quota_match = {
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index c8b8e35..ea05b87 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -1,10 +1,10 @@
-/* Code to restore the iptables state, from file by ip6tables-save. 
+/* Code to restore the iptables state, from file by ip6tables-save.
  * Author:  Andras Kis-Szabo <kisza@sch.bme.hu>
  *
  * based on iptables-restore
  * Authors:
- * 	Harald Welte <laforge@gnumonks.org>
- * 	Rusty Russell <rusty@linuxcare.com.au>
+ *      Harald Welte <laforge@gnumonks.org>
+ *      Rusty Russell <rusty@linuxcare.com.au>
  * This code is distributed under the terms of GNU GPL v2
  *
  * $Id: ip6tables-restore.c 7083 2007-10-23 14:22:34Z /C=EU/ST=EU/CN=Patrick McHardy/emailAddress=kaber@trash.net $
@@ -22,7 +22,7 @@
 #ifdef DEBUG
 #define DEBUGP(x, args...) fprintf(stderr, x, ## args)
 #else
-#define DEBUGP(x, args...) 
+#define DEBUGP(x, args...)
 #endif
 
 static int binary = 0, counters = 0, verbose = 0, noflush = 0;
@@ -50,8 +50,8 @@ static void print_usage(const char *name, const char *version)
 			"	   [ --test ]\n"
 			"	   [ --help ]\n"
 			"	   [ --noflush ]\n"
-		        "          [ --modprobe=<command>]\n", name);
-		
+			"          [ --modprobe=<command>]\n", name);
+
 	exit(1);
 }
 
@@ -92,7 +92,7 @@ static int parse_counters(char *string, struct ip6t_counters *ctr)
 static char *newargv[255];
 static int newargc;
 
-/* function adding one argument to newargv, updating newargc 
+/* function adding one argument to newargv, updating newargc
  * returns true if argument added, false otherwise */
 static int add_argv(char *what) {
 	DEBUGP("add_argv: %s\n", what);
@@ -100,7 +100,7 @@ static int add_argv(char *what) {
 		newargv[newargc] = strdup(what);
 		newargc++;
 		return 1;
-	} else 
+	} else
 		return 0;
 }
 
@@ -163,7 +163,7 @@ int main(int argc, char *argv[])
 				break;
 		}
 	}
-	
+
 	if (optind == argc - 1) {
 		in = fopen(argv[optind], "r");
 		if (!in) {
@@ -177,7 +177,7 @@ int main(int argc, char *argv[])
 		exit(1);
 	}
 	else in = stdin;
-	
+
 	/* Grab standard input. */
 	while (fgets(buffer, sizeof(buffer), in)) {
 		int ret = 0;
@@ -205,7 +205,7 @@ int main(int argc, char *argv[])
 			table = strtok(buffer+1, " \t\n");
 			DEBUGP("line %u, table '%s'\n", line, table);
 			if (!table) {
-				exit_error(PARAMETER_PROBLEM, 
+				exit_error(PARAMETER_PROBLEM,
 					"%s: line %u table name invalid\n",
 					program_name, line);
 				exit(1);
@@ -220,12 +220,12 @@ int main(int argc, char *argv[])
 			if (noflush == 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
 					table);
-				for_each_chain(flush_entries, verbose, 1, 
+				for_each_chain(flush_entries, verbose, 1,
 						&handle);
-	
+
 				DEBUGP("Deleting all user-defined chains "
 				       "of table '%s'\n", table);
-				for_each_chain(delete_chain, verbose, 0, 
+				for_each_chain(delete_chain, verbose, 0,
 						&handle) ;
 			}
 
@@ -285,7 +285,7 @@ int main(int argc, char *argv[])
 							  "for chain '%s'\n", chain);
 
 				} else {
-					memset(&count, 0, 
+					memset(&count, 0,
 					       sizeof(struct ip6t_counters));
 				}
 
@@ -347,7 +347,7 @@ int main(int argc, char *argv[])
 			add_argv(argv[0]);
 			add_argv("-t");
 			add_argv((char *) &curtable);
-			
+
 			if (counters && pcnt && bcnt) {
 				add_argv("--set-counters");
 				add_argv((char *) pcnt);
@@ -360,7 +360,7 @@ int main(int argc, char *argv[])
 
 			quote_open = 0;
 			param_start = parsestart;
-			
+
 			for (curchar = parsestart; *curchar; curchar++) {
 				if (*curchar == '"') {
 					/* quote_open cannot be true if there
@@ -398,7 +398,7 @@ int main(int argc, char *argv[])
 					/* check if table name specified */
 					if (!strncmp(param_buffer, "-t", 3)
                                             || !strncmp(param_buffer, "--table", 8)) {
-						exit_error(PARAMETER_PROBLEM, 
+						exit_error(PARAMETER_PROBLEM,
 						   "Line %u seems to have a "
 						   "-t table option.\n", line);
 						exit(1);
@@ -417,7 +417,7 @@ int main(int argc, char *argv[])
 			for (a = 0; a < newargc; a++)
 				DEBUGP("argv[%u]: %s\n", a, newargv[a]);
 
-			ret = do_command6(newargc, newargv, 
+			ret = do_command6(newargc, newargv,
 					 &newargv[2], &handle);
 
 			free_argv();
diff --git a/ip6tables-save.c b/ip6tables-save.c
index af86f4b..fe57cfd 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -2,7 +2,7 @@
 /* Author:  Andras Kis-Szabo <kisza@sch.bme.hu>
  * Original code: iptables-save
  * Authors: Paul 'Rusty' Russel <rusty@linuxcare.com.au> and
- * 	    Harald Welte <laforge@gnumonks.org>
+ *          Harald Welte <laforge@gnumonks.org>
  * This code is distributed under the terms of GNU GPL v2
  */
 #include <getopt.h>
@@ -49,7 +49,7 @@ print_iface(char letter, const char *iface, const unsigned char *mask,
 			if (iface[i] != '\0')
 				printf("%c", iface[i]);
 		} else {
-			/* we can access iface[i-1] here, because 
+			/* we can access iface[i-1] here, because
 			 * a few lines above we make sure that mask[0] != 0 */
 			if (iface[i-1] != '\0')
 				printf("+");
@@ -81,11 +81,11 @@ static void print_proto(u_int16_t proto, int invert)
 		unsigned int i;
 		const char *invertstr = invert ? "! " : "";
 
-                struct protoent *pent = getprotobynumber(proto);
-                if (pent) {
+		struct protoent *pent = getprotobynumber(proto);
+		if (pent) {
 			printf("-p %s%s ",
 			       invertstr, pent->p_name);
-	                return;
+			return;
 		}
 
 		for (i = 0; i < sizeof(chain_protos)/sizeof(struct pprot); i++)
@@ -144,8 +144,8 @@ static void print_ip(char *prefix, const struct in6_addr *ip, const struct in6_a
 
 /* We want this to be readable, so only print out neccessary fields.
  * Because that's the kind of world I want to live in.  */
-static void print_rule(const struct ip6t_entry *e, 
-		ip6tc_handle_t *h, const char *chain, int counters)
+static void print_rule(const struct ip6t_entry *e,
+		       ip6tc_handle_t *h, const char *chain, int counters)
 {
 	struct ip6t_entry_target *t;
 	const char *target_name;
@@ -159,7 +159,7 @@ static void print_rule(const struct ip6t_entry *e,
 
 	/* Print IP part. */
 	print_ip("-s", &(e->ipv6.src), &(e->ipv6.smsk),
-			e->ipv6.invflags & IP6T_INV_SRCIP);	
+			e->ipv6.invflags & IP6T_INV_SRCIP);
 
 	print_ip("-d", &(e->ipv6.dst), &(e->ipv6.dmsk),
 			e->ipv6.invflags & IP6T_INV_DSTIP);
@@ -182,7 +182,7 @@ static void print_rule(const struct ip6t_entry *e,
 
 	if (e->ipv6.flags & IP6T_F_TOS)
 		printf("%s-? %d ",
-		       e->ipv6.invflags & IP6T_INV_TOS ? "! " : "", 
+		       e->ipv6.invflags & IP6T_INV_TOS ? "! " : "",
 		       e->ipv6.tos);
 
 	/* Print matchinfo part */
@@ -190,7 +190,7 @@ static void print_rule(const struct ip6t_entry *e,
 		IP6T_MATCH_ITERATE(e, print_match, &e->ipv6);
 	}
 
-	/* Print target name */	
+	/* Print target name */
 	target_name = ip6tc_get_target(e, h);
 	if (target_name && (*target_name != '\0'))
 		printf("-j %s ", target_name);
@@ -213,7 +213,7 @@ static void print_rule(const struct ip6t_entry *e,
 			/* If the target size is greater than ip6t_entry_target
 			 * there is something to be saved, we just don't know
 			 * how to print it */
-			if (t->u.target_size != 
+			if (t->u.target_size !=
 			    sizeof(struct ip6t_entry_target)) {
 				fprintf(stderr, "Target `%s' is missing "
 						"save function\n",
@@ -228,7 +228,7 @@ static void print_rule(const struct ip6t_entry *e,
 /* Debugging prototype. */
 static int for_each_table(int (*func)(const char *tablename))
 {
-        int ret = 1;
+	int ret = 1;
 	FILE *procfile = NULL;
 	char tablename[IP6T_TABLE_MAXNAMELEN+1];
 
@@ -249,7 +249,7 @@ static int for_each_table(int (*func)(const char *tablename))
 
 	return ret;
 }
-	
+
 
 static int do_output(const char *tablename)
 {
@@ -261,7 +261,7 @@ static int do_output(const char *tablename)
 
 	h = ip6tc_init(tablename);
 	if (!h)
- 		exit_error(OTHER_PROBLEM, "Can't initialize: %s\n",
+		exit_error(OTHER_PROBLEM, "Can't initialize: %s\n",
 			   ip6tc_strerror(errno));
 
 	if (!binary) {
@@ -271,7 +271,7 @@ static int do_output(const char *tablename)
 		       IPTABLES_VERSION, ctime(&now));
 		printf("*%s\n", tablename);
 
-		/* Dump out chain names first, 
+		/* Dump out chain names first,
 		 * thereby preventing dependency conflicts */
 		for (chain = ip6tc_first_chain(&h);
 		     chain;
diff --git a/ip6tables.c b/ip6tables.c
index 94dadf3..acdb043 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -337,8 +337,8 @@ exit_printhelp(struct ip6tables_rule_match *matches)
 "  --set-counters PKTS BYTES	set the counter during insert/append\n"
 "[!] --version	-V		print package version.\n");
 
-	/* Print out any special helps. A user might like to be able to add a --help 
-	   to the commandline, and see expected results. So we call help for all 
+	/* Print out any special helps. A user might like to be able to add a --help
+	   to the commandline, and see expected results. So we call help for all
 	   specified matches & targets */
 	for (t = xtables_targets; t; t = t->next) {
 		if (t->used) {
@@ -495,7 +495,7 @@ parse_protocol(const char *s)
 
 		/* first deal with the special case of 'all' to prevent
 		 * people from being able to redefine 'all' in nsswitch
-		 * and/or provoke expensive [not working] ldap/nis/... 
+		 * and/or provoke expensive [not working] ldap/nis/...
 		 * lookups */
 		if (!strcmp(s, "all"))
 			return 0;
@@ -802,7 +802,7 @@ print_firewall(const struct ip6t_entry *fw,
 	}
 
 	fputc(fw->ipv6.invflags & IP6T_INV_SRCIP ? '!' : ' ', stdout);
-	if (!memcmp(&fw->ipv6.smsk, &in6addr_any, sizeof in6addr_any) 
+	if (!memcmp(&fw->ipv6.smsk, &in6addr_any, sizeof in6addr_any)
 	    && !(format & FMT_NUMERIC))
 		printf(FMT("%-19s ","%s "), "anywhere");
 	else {
@@ -950,7 +950,7 @@ make_delete_mask(struct ip6t_entry *fw, struct ip6tables_rule_match *matches)
 		mptr += IP6T_ALIGN(sizeof(struct ip6t_entry_match)) + matchp->match->size;
 	}
 
-	memset(mptr, 0xFF, 
+	memset(mptr, 0xFF,
 	       IP6T_ALIGN(sizeof(struct ip6t_entry_target))
 	       + xtables_targets->userspacesize);
 
@@ -991,7 +991,7 @@ int
 for_each_chain(int (*fn)(const ip6t_chainlabel, int, ip6tc_handle_t *),
 	       int verbose, int builtinstoo, ip6tc_handle_t *handle)
 {
-        int ret = 1;
+	int ret = 1;
 	const char *chain;
 	char *chains;
 	unsigned int i, chaincount = 0;
@@ -1000,7 +1000,7 @@ for_each_chain(int (*fn)(const ip6t_chainlabel, int, ip6tc_handle_t *),
 	while (chain) {
 		chaincount++;
 		chain = ip6tc_next_chain(handle);
-        }
+	}
 
 	chains = fw_malloc(sizeof(ip6t_chainlabel) * chaincount);
 	i = 0;
@@ -1009,18 +1009,18 @@ for_each_chain(int (*fn)(const ip6t_chainlabel, int, ip6tc_handle_t *),
 		strcpy(chains + i*sizeof(ip6t_chainlabel), chain);
 		i++;
 		chain = ip6tc_next_chain(handle);
-        }
+	}
 
 	for (i = 0; i < chaincount; i++) {
 		if (!builtinstoo
 		    && ip6tc_builtin(chains + i*sizeof(ip6t_chainlabel),
 				    *handle) == 1)
 			continue;
-	        ret &= fn(chains + i*sizeof(ip6t_chainlabel), verbose, handle);
+		ret &= fn(chains + i*sizeof(ip6t_chainlabel), verbose, handle);
 	}
 
 	free(chains);
-        return ret;
+	return ret;
 }
 
 int
@@ -1055,7 +1055,7 @@ delete_chain(const ip6t_chainlabel chain, int verbose,
 		return for_each_chain(delete_chain, verbose, 0, handle);
 
 	if (verbose)
-	        fprintf(stdout, "Deleting chain `%s'\n", chain);
+		fprintf(stdout, "Deleting chain `%s'\n", chain);
 	return ip6tc_delete_chain(chain, handle);
 }
 
@@ -1367,7 +1367,7 @@ int do_command6(int argc, char *argv[], char **table, ip6tc_handle_t *handle)
 			    && (fw.ipv6.invflags & IP6T_INV_PROTO))
 				exit_error(PARAMETER_PROBLEM,
 					   "rule would never match protocol");
-			
+
 			if (is_exthdr(fw.ipv6.proto)
 			    && (fw.ipv6.invflags & IP6T_INV_PROTO) == 0)
 				fprintf(stderr,
@@ -1542,7 +1542,7 @@ int do_command6(int argc, char *argv[], char **table, ip6tc_handle_t *handle)
 					       &target->tflags,
 					       &fw, &target->t))) {
 				for (matchp = matches; matchp; matchp = matchp->next) {
-					if (matchp->completed) 
+					if (matchp->completed)
 						continue;
 					if (matchp->match->parse(c - matchp->match->option_offset,
 						     argv, invert,
@@ -1579,7 +1579,7 @@ int do_command6(int argc, char *argv[], char **table, ip6tc_handle_t *handle)
 				if (m == NULL
 				    && protocol
 				    && (!find_proto(protocol, DONT_LOAD,
-						   options&OPT_NUMERIC, NULL) 
+						   options&OPT_NUMERIC, NULL)
 					|| (find_proto(protocol, DONT_LOAD,
 							options&OPT_NUMERIC, NULL)
 					    && (proto_used == 0))
@@ -1588,7 +1588,7 @@ int do_command6(int argc, char *argv[], char **table, ip6tc_handle_t *handle)
 						       options&OPT_NUMERIC, &matches))) {
 					/* Try loading protocol */
 					size_t size;
-					
+
 					proto_used = 1;
 
 					size = IP6T_ALIGN(sizeof(struct ip6t_entry_match))
diff --git a/iptables-restore.c b/iptables-restore.c
index e244763..f328bd8 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -1,4 +1,4 @@
-/* Code to restore the iptables state, from file by iptables-save. 
+/* Code to restore the iptables state, from file by iptables-save.
  * (C) 2000-2002 by Harald Welte <laforge@gnumonks.org>
  * based on previous code from Rusty Russell <rusty@linuxcare.com.au>
  *
@@ -19,7 +19,7 @@
 #ifdef DEBUG
 #define DEBUGP(x, args...) fprintf(stderr, x, ## args)
 #else
-#define DEBUGP(x, args...) 
+#define DEBUGP(x, args...)
 #endif
 
 static int binary = 0, counters = 0, verbose = 0, noflush = 0;
@@ -49,8 +49,8 @@ static void print_usage(const char *name, const char *version)
 			"	   [ --help ]\n"
 			"	   [ --noflush ]\n"
 			"	   [ --table=<TABLE> ]\n"
-		        "          [ --modprobe=<command>]\n", name);
-		
+			"          [ --modprobe=<command>]\n", name);
+
 	exit(1);
 }
 
@@ -168,7 +168,7 @@ main(int argc, char *argv[])
 				break;
 		}
 	}
-	
+
 	if (optind == argc - 1) {
 		in = fopen(argv[optind], "r");
 		if (!in) {
@@ -182,7 +182,7 @@ main(int argc, char *argv[])
 		exit(1);
 	}
 	else in = stdin;
-	
+
 	/* Grab standard input. */
 	while (fgets(buffer, sizeof(buffer), in)) {
 		int ret = 0;
@@ -210,7 +210,7 @@ main(int argc, char *argv[])
 			table = strtok(buffer+1, " \t\n");
 			DEBUGP("line %u, table '%s'\n", line, table);
 			if (!table) {
-				exit_error(PARAMETER_PROBLEM, 
+				exit_error(PARAMETER_PROBLEM,
 					"%s: line %u table name invalid\n",
 					program_name, line);
 				exit(1);
@@ -227,12 +227,12 @@ main(int argc, char *argv[])
 			if (noflush == 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
 					table);
-				for_each_chain(flush_entries, verbose, 1, 
+				for_each_chain(flush_entries, verbose, 1,
 						&handle);
-	
+
 				DEBUGP("Deleting all user-defined chains "
 				       "of table '%s'\n", table);
-				for_each_chain(delete_chain, verbose, 0, 
+				for_each_chain(delete_chain, verbose, 0,
 						&handle) ;
 			}
 
@@ -292,7 +292,7 @@ main(int argc, char *argv[])
 							   "for chain '%s'\n", chain);
 
 				} else {
-					memset(&count, 0, 
+					memset(&count, 0,
 					       sizeof(struct ipt_counters));
 				}
 
@@ -355,7 +355,7 @@ main(int argc, char *argv[])
 			add_argv(argv[0]);
 			add_argv("-t");
 			add_argv((char *) &curtable);
-			
+
 			if (counters && pcnt && bcnt) {
 				add_argv("--set-counters");
 				add_argv((char *) pcnt);
@@ -368,7 +368,7 @@ main(int argc, char *argv[])
 
 			quote_open = 0;
 			param_len = 0;
-			
+
 			for (curchar = parsestart; *curchar; curchar++) {
 				char param_buffer[1024];
 
@@ -404,8 +404,8 @@ main(int argc, char *argv[])
 
 					/* check if table name specified */
 					if (!strncmp(param_buffer, "-t", 3)
-                                            || !strncmp(param_buffer, "--table", 8)) {
-						exit_error(PARAMETER_PROBLEM, 
+					    || !strncmp(param_buffer, "--table", 8)) {
+						exit_error(PARAMETER_PROBLEM,
 						   "Line %u seems to have a "
 						   "-t table option.\n", line);
 						exit(1);
@@ -430,7 +430,7 @@ main(int argc, char *argv[])
 					param_buffer[param_len++] = *curchar;
 
 					if (param_len >= sizeof(param_buffer))
-						exit_error(PARAMETER_PROBLEM, 
+						exit_error(PARAMETER_PROBLEM,
 						   "Parameter too long!");
 				}
 			}
@@ -441,7 +441,7 @@ main(int argc, char *argv[])
 			for (a = 0; a < newargc; a++)
 				DEBUGP("argv[%u]: %s\n", a, newargv[a]);
 
-			ret = do_command(newargc, newargv, 
+			ret = do_command(newargc, newargv,
 					 &newargv[2], &handle);
 
 			free_argv();
diff --git a/iptables-save.c b/iptables-save.c
index be5e893..f8a61c2 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -55,7 +55,7 @@ print_iface(char letter, const char *iface, const unsigned char *mask,
 			if (iface[i] != '\0')
 				printf("%c", iface[i]);
 		} else {
-			/* we can access iface[i-1] here, because 
+			/* we can access iface[i-1] here, because
 			 * a few lines above we make sure that mask[0] != 0 */
 			if (iface[i-1] != '\0')
 				printf("+");
@@ -172,7 +172,7 @@ static void print_ip(char *prefix, u_int32_t ip, u_int32_t mask, int invert)
 
 /* We want this to be readable, so only print out neccessary fields.
  * Because that's the kind of world I want to live in.  */
-static void print_rule(const struct ipt_entry *e, 
+static void print_rule(const struct ipt_entry *e,
 		iptc_handle_t *h, const char *chain, int counters)
 {
 	struct ipt_entry_target *t;
@@ -187,7 +187,7 @@ static void print_rule(const struct ipt_entry *e,
 
 	/* Print IP part. */
 	print_ip("-s", e->ip.src.s_addr,e->ip.smsk.s_addr,
-			e->ip.invflags & IPT_INV_SRCIP);	
+			e->ip.invflags & IPT_INV_SRCIP);
 
 	print_ip("-d", e->ip.dst.s_addr, e->ip.dmsk.s_addr,
 			e->ip.invflags & IPT_INV_DSTIP);
@@ -209,7 +209,7 @@ static void print_rule(const struct ipt_entry *e,
 		IPT_MATCH_ITERATE(e, print_match, &e->ip);
 	}
 
-	/* Print target name */	
+	/* Print target name */
 	target_name = iptc_get_target(e, h);
 	if (target_name && (*target_name != '\0'))
 #ifdef IPT_F_GOTO
@@ -236,7 +236,7 @@ static void print_rule(const struct ipt_entry *e,
 			/* If the target size is greater than ipt_entry_target
 			 * there is something to be saved, we just don't know
 			 * how to print it */
-			if (t->u.target_size != 
+			if (t->u.target_size !=
 			    sizeof(struct ipt_entry_target)) {
 				fprintf(stderr, "Target `%s' is missing "
 						"save function\n",
@@ -251,7 +251,7 @@ static void print_rule(const struct ipt_entry *e,
 /* Debugging prototype. */
 static int for_each_table(int (*func)(const char *tablename))
 {
-        int ret = 1;
+	int ret = 1;
 	FILE *procfile = NULL;
 	char tablename[IPT_TABLE_MAXNAMELEN+1];
 
@@ -272,7 +272,7 @@ static int for_each_table(int (*func)(const char *tablename))
 
 	return ret;
 }
-	
+
 
 static int do_output(const char *tablename)
 {
@@ -284,7 +284,7 @@ static int do_output(const char *tablename)
 
 	h = iptc_init(tablename);
 	if (!h)
- 		exit_error(OTHER_PROBLEM, "Can't initialize: %s\n",
+		exit_error(OTHER_PROBLEM, "Can't initialize: %s\n",
 			   iptc_strerror(errno));
 
 	if (!binary) {
@@ -294,12 +294,12 @@ static int do_output(const char *tablename)
 		       IPTABLES_VERSION, ctime(&now));
 		printf("*%s\n", tablename);
 
-		/* Dump out chain names first, 
+		/* Dump out chain names first,
 		 * thereby preventing dependency conflicts */
 		for (chain = iptc_first_chain(&h);
 		     chain;
 		     chain = iptc_next_chain(&h)) {
-			
+
 			printf(":%s ", chain);
 			if (iptc_builtin(chain, h)) {
 				struct ipt_counters count;
@@ -310,7 +310,7 @@ static int do_output(const char *tablename)
 				printf("- [0:0]\n");
 			}
 		}
-				
+
 
 		for (chain = iptc_first_chain(&h);
 		     chain;
diff --git a/iptables.c b/iptables.c
index ab072cc..43e3653 100644
--- a/iptables.c
+++ b/iptables.c
@@ -1058,7 +1058,7 @@ delete_chain(const ipt_chainlabel chain, int verbose,
 		return for_each_chain(delete_chain, verbose, 0, handle);
 
 	if (verbose)
-	        fprintf(stdout, "Deleting chain `%s'\n", chain);
+		fprintf(stdout, "Deleting chain `%s'\n", chain);
 	return iptc_delete_chain(chain, handle);
 }
 
@@ -1180,7 +1180,7 @@ get_kernel_version(void) {
 	if (uname(&uts) == -1) {
 		fprintf(stderr, "Unable to retrieve kernel version.\n");
 		free_opts(1);
-		exit(1); 
+		exit(1);
 	}
 
 	sscanf(uts.release, "%d.%d.%d", &x, &y, &z);
@@ -1337,7 +1337,7 @@ int do_command(int argc, char *argv[], char **table, iptc_handle_t *handle)
 				newname = argv[optind++];
 			else
 				exit_error(PARAMETER_PROBLEM,
-				           "-%c requires old-chain-name and "
+					   "-%c requires old-chain-name and "
 					   "new-chain-name",
 					    cmd2char(CMD_RENAME_CHAIN));
 			break;
@@ -1429,8 +1429,8 @@ int do_command(int argc, char *argv[], char **table, iptc_handle_t *handle)
 					     target->revision);
 				if (target->init != NULL)
 					target->init(target->t);
-				opts = merge_options(opts, 
-						     target->extra_opts, 
+				opts = merge_options(opts,
+						     target->extra_opts,
 						     &target->option_offset);
 				if (opts == NULL)
 					exit_error(OTHER_PROBLEM,
@@ -1488,8 +1488,8 @@ int do_command(int argc, char *argv[], char **table, iptc_handle_t *handle)
 				m->init(m->m);
 			if (m != m->next) {
 				/* Merge options for non-cloned matches */
-				opts = merge_options(opts, 
-						     m->extra_opts, 
+				opts = merge_options(opts,
+						     m->extra_opts,
 						     &m->option_offset);
 				if (opts == NULL)
 					exit_error(OTHER_PROBLEM,
@@ -1579,7 +1579,7 @@ int do_command(int argc, char *argv[], char **table, iptc_handle_t *handle)
 					       &target->tflags,
 					       &fw, &target->t))) {
 				for (matchp = matches; matchp; matchp = matchp->next) {
-					if (matchp->completed) 
+					if (matchp->completed)
 						continue;
 					if (matchp->match->parse(c - matchp->match->option_offset,
 						     argv, invert,
@@ -1616,7 +1616,7 @@ int do_command(int argc, char *argv[], char **table, iptc_handle_t *handle)
 				if (m == NULL
 				    && protocol
 				    && (!find_proto(protocol, DONT_LOAD,
-						   options&OPT_NUMERIC, NULL) 
+						   options&OPT_NUMERIC, NULL)
 					|| (find_proto(protocol, DONT_LOAD,
 							options&OPT_NUMERIC, NULL)
 					    && (proto_used == 0))
@@ -1625,7 +1625,7 @@ int do_command(int argc, char *argv[], char **table, iptc_handle_t *handle)
 						       options&OPT_NUMERIC, &matches))) {
 					/* Try loading protocol */
 					size_t size;
-					
+
 					proto_used = 1;
 
 					size = IPT_ALIGN(sizeof(struct ipt_entry_match))
@@ -1640,7 +1640,7 @@ int do_command(int argc, char *argv[], char **table, iptc_handle_t *handle)
 						m->init(m->m);
 
 					opts = merge_options(opts,
-							     m->extra_opts, 
+							     m->extra_opts,
 							     &m->option_offset);
 					if (opts == NULL)
 						exit_error(OTHER_PROBLEM,
@@ -1685,11 +1685,11 @@ int do_command(int argc, char *argv[], char **table, iptc_handle_t *handle)
 
 	if (shostnetworkmask)
 		ipparse_hostnetworkmask(shostnetworkmask, &saddrs,
-		                        &fw.ip.smsk, &nsaddrs);
+					&fw.ip.smsk, &nsaddrs);
 
 	if (dhostnetworkmask)
 		ipparse_hostnetworkmask(dhostnetworkmask, &daddrs,
-		                        &fw.ip.dmsk, &ndaddrs);
+					&fw.ip.dmsk, &ndaddrs);
 
 	if ((nsaddrs > 1 || ndaddrs > 1) &&
 	    (fw.ip.invflags & (IPT_INV_SRCIP | IPT_INV_DSTIP)))


