From: jamal <hadi@cyberus.ca>
Subject: [PATCH] libxtables: Kill program_name, program_version and
	xtables_program_name
Date: Fri, 13 Feb 2009 10:46:35 -0500
Message-ID: <1234539995.4078.21.camel@dogo.mojatatu.com>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-ihR7JY62PTnmFRa3WChh"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:51162 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbZBMPsg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Feb 2009 10:48:36 -0500
Received: by ewy14 with SMTP id 14so1051465ewy.13
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Feb 2009 07:48:31 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--=-ihR7JY62PTnmFRa3WChh
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

general followup cleanup

The one thing i wasnt sure of is what to do with ltmain.sh

cheers,
jamal

--=-ihR7JY62PTnmFRa3WChh
Content-Disposition: attachment; filename=iptv3-5
Content-Type: text/plain; name=iptv3-5; charset=UTF-8
Content-Transfer-Encoding: 7bit

commit bf7c45e94a449c37c72323ef5845b43b3b3fa58e
Author: Jamal Hadi Salim <hadi@cyberus.ca>
Date:   Fri Feb 13 10:42:24 2009 -0500

    Kill program_name, program_version and xtables_program_name
    
    Signed-off-by: Jamal Hadi Salim <hadi@cyberus.ca>

diff --git a/include/xtables.h.in b/include/xtables.h.in
index ab3bb06..5c49c3e 100644
--- a/include/xtables.h.in
+++ b/include/xtables.h.in
@@ -192,7 +192,6 @@ struct xtables_globals
 	void (*exit_err)(enum xtables_exittype status, const char *msg, ...) __attribute__((noreturn, format(printf,2,3)));
 };
 
-extern const char *xtables_program_name;
 extern const char *xtables_modprobe_program;
 extern struct xtables_match *xtables_matches;
 extern struct xtables_target *xtables_targets;
diff --git a/ip6tables-restore.c b/ip6tables-restore.c
index 0f06a1c..09efc72 100644
--- a/ip6tables-restore.c
+++ b/ip6tables-restore.c
@@ -71,7 +71,8 @@ static struct ip6tc_handle *create_handle(const char *tablename)
 
 	if (!handle) {
 		exit_error(PARAMETER_PROBLEM, "%s: unable to initialize "
-			"table '%s'\n", program_name, tablename);
+			"table '%s'\n",ip6tables_globals.program_name,
+			tablename);
 		exit(1);
 	}
 	return handle;
@@ -126,11 +127,8 @@ int main(int argc, char *argv[])
 	FILE *in;
 	int in_table = 0, testing = 0;
 
-	program_name = "ip6tables-restore";
-	program_version = IPTABLES_VERSION;
 	line = 0;
 
-	xtables_program_name = program_name;
 	ip6tables_globals.program_name = "ip6tables-restore";
 	c = xtables_init_all(&ip6tables_globals, NFPROTO_IPV6);
 	if (c < 0) {
@@ -215,7 +213,8 @@ int main(int argc, char *argv[])
 			if (!table) {
 				exit_error(PARAMETER_PROBLEM,
 					"%s: line %u table name invalid\n",
-					program_name, line);
+					ip6tables_globals.program_name,
+					line);
 				exit(1);
 			}
 			strncpy(curtable, table, IP6T_TABLE_MAXNAMELEN);
@@ -249,7 +248,8 @@ int main(int argc, char *argv[])
 			if (!chain) {
 				exit_error(PARAMETER_PROBLEM,
 					   "%s: line %u chain name invalid\n",
-					   program_name, line);
+					   ip6tables_globals.program_name,
+					   line);
 				exit(1);
 			}
 
@@ -276,7 +276,8 @@ int main(int argc, char *argv[])
 			if (!policy) {
 				exit_error(PARAMETER_PROBLEM,
 					   "%s: line %u policy invalid\n",
-					   program_name, line);
+					   ip6tables_globals.program_name,
+					   line);
 				exit(1);
 			}
 
@@ -441,13 +442,15 @@ int main(int argc, char *argv[])
 		}
 		if (!ret) {
 			fprintf(stderr, "%s: line %u failed\n",
-					program_name, line);
+					ip6tables_globals.program_name,
+					line);
 			exit(1);
 		}
 	}
 	if (in_table) {
 		fprintf(stderr, "%s: COMMIT expected at line %u\n",
-				program_name, line + 1);
+				ip6tables_globals.program_name,
+				line + 1);
 		exit(1);
 	}
 
diff --git a/ip6tables-save.c b/ip6tables-save.c
index 9de34b5..874542d 100644
--- a/ip6tables-save.c
+++ b/ip6tables-save.c
@@ -136,10 +136,6 @@ int main(int argc, char *argv[])
 	const char *tablename = NULL;
 	int c;
 
-	program_name = "ip6tables-save";
-	program_version = IPTABLES_VERSION;
-
-	xtables_program_name = program_name;
 	ip6tables_globals.program_name = "ip6tables-save";
 	c = xtables_init_all(&ip6tables_globals, NFPROTO_IPV6);
 	if (c < 0) {
diff --git a/ip6tables-standalone.c b/ip6tables-standalone.c
index b40c79b..c0ca645 100644
--- a/ip6tables-standalone.c
+++ b/ip6tables-standalone.c
@@ -49,10 +49,6 @@ main(int argc, char *argv[])
 	char *table = "filter";
 	struct ip6tc_handle *handle = NULL;
 
-	program_name = "ip6tables";
-	program_version = IPTABLES_VERSION;
-
-	xtables_program_name = program_name;
 	ip6tables_globals.program_name = "ip6tables";
 	ret = xtables_init_all(&ip6tables_globals, NFPROTO_IPV6);
 	if (ret < 0) {
diff --git a/ip6tables.c b/ip6tables.c
index 3cc124a..346f19b 100644
--- a/ip6tables.c
+++ b/ip6tables.c
@@ -194,9 +194,8 @@ static int inverse_for_options[NUMBER_OF_OPT] =
 /* -c */ 0,
 };
 
-const char *program_version;
-const char *program_name;
-
+#define prog_name ip6tables_globals.program_name
+#define prog_vers ip6tables_globals.program_version
 /* A few hardcoded protocols for 'all' and in case the user has no
    /etc/protocols */
 struct pprot {
@@ -228,7 +227,7 @@ exit_tryhelp(int status)
 	if (line != -1)
 		fprintf(stderr, "Error occurred at line: %d\n", line);
 	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
-			program_name, program_name );
+			prog_name, prog_name );
 	xtables_free_opts(1);
 	exit(status);
 }
@@ -249,9 +248,9 @@ exit_printhelp(struct ip6tables_rule_match *matches)
 "       %s -E old-chain-name new-chain-name\n"
 "       %s -P chain target [options]\n"
 "       %s -h (print this help information)\n\n",
-	       program_name, program_version, program_name, program_name,
-	       program_name, program_name, program_name, program_name,
-	       program_name, program_name, program_name);
+	       prog_name, prog_vers, prog_name, prog_name,
+	       prog_name, prog_name, prog_name, prog_name,
+	       prog_name, prog_name, prog_name);
 
 	printf(
 "Commands:\n"
@@ -329,7 +328,7 @@ ip6tables_exit_error(enum xtables_exittype status, const char *msg, ...)
 	va_list args;
 
 	va_start(args, msg);
-	fprintf(stderr, "%s v%s: ", program_name, program_version);
+	fprintf(stderr, "%s v%s: ", prog_name, prog_vers);
 	vfprintf(stderr, msg, args);
 	va_end(args);
 	fprintf(stderr, "\n");
@@ -1629,10 +1628,10 @@ int do_command6(int argc, char *argv[], char **table, struct ip6tc_handle **hand
 
 		case 'V':
 			if (invert)
-				printf("Not %s ;-)\n", program_version);
+				printf("Not %s ;-)\n", prog_vers);
 			else
 				printf("%s v%s\n",
-				       program_name, program_version);
+				       prog_name, prog_vers);
 			exit(0);
 
 		case '0':
diff --git a/iptables-restore.c b/iptables-restore.c
index c52af0a..c8eb2e3 100644
--- a/iptables-restore.c
+++ b/iptables-restore.c
@@ -41,6 +41,8 @@ static const struct option options[] = {
 
 static void print_usage(const char *name, const char *version) __attribute__((noreturn));
 
+#define prog_name iptables_globals.program_name
+
 static void print_usage(const char *name, const char *version)
 {
 	fprintf(stderr, "Usage: %s [-b] [-c] [-v] [-t] [-h]\n"
@@ -70,7 +72,7 @@ static struct iptc_handle *create_handle(const char *tablename)
 
 	if (!handle) {
 		exit_error(PARAMETER_PROBLEM, "%s: unable to initialize "
-			"table '%s'\n", program_name, tablename);
+			"table '%s'\n", prog_name, tablename);
 		exit(1);
 	}
 	return handle;
@@ -128,11 +130,8 @@ main(int argc, char *argv[])
 	int in_table = 0, testing = 0;
 	const char *tablename = NULL;
 
-	program_name = "iptables-restore";
-	program_version = IPTABLES_VERSION;
 	line = 0;
 
-	xtables_program_name = program_name;
 	iptables_globals.program_name = "iptables-restore";
 	c = xtables_init_all(&iptables_globals, NFPROTO_IPV4);
 	if (c < 0) {
@@ -220,7 +219,7 @@ main(int argc, char *argv[])
 			if (!table) {
 				exit_error(PARAMETER_PROBLEM,
 					"%s: line %u table name invalid\n",
-					program_name, line);
+					prog_name, line);
 				exit(1);
 			}
 			strncpy(curtable, table, IPT_TABLE_MAXNAMELEN);
@@ -256,7 +255,7 @@ main(int argc, char *argv[])
 			if (!chain) {
 				exit_error(PARAMETER_PROBLEM,
 					   "%s: line %u chain name invalid\n",
-					   program_name, line);
+					   prog_name, line);
 				exit(1);
 			}
 
@@ -283,7 +282,7 @@ main(int argc, char *argv[])
 			if (!policy) {
 				exit_error(PARAMETER_PROBLEM,
 					   "%s: line %u policy invalid\n",
-					   program_name, line);
+					   prog_name, line);
 				exit(1);
 			}
 
@@ -450,13 +449,13 @@ main(int argc, char *argv[])
 			continue;
 		if (!ret) {
 			fprintf(stderr, "%s: line %u failed\n",
-					program_name, line);
+					prog_name, line);
 			exit(1);
 		}
 	}
 	if (in_table) {
 		fprintf(stderr, "%s: COMMIT expected at line %u\n",
-				program_name, line + 1);
+				prog_name, line + 1);
 		exit(1);
 	}
 
diff --git a/iptables-save.c b/iptables-save.c
index 312673a..e273435 100644
--- a/iptables-save.c
+++ b/iptables-save.c
@@ -136,10 +136,6 @@ main(int argc, char *argv[])
 	const char *tablename = NULL;
 	int c;
 
-	program_name = "iptables-save";
-	program_version = IPTABLES_VERSION;
-
-	xtables_program_name = program_name;
 	iptables_globals.program_name = "iptables-save";
 	c = xtables_init_all(&iptables_globals, NFPROTO_IPV4);
 	if (c < 0) {
diff --git a/iptables-standalone.c b/iptables-standalone.c
index 6090ea1..208f71d 100644
--- a/iptables-standalone.c
+++ b/iptables-standalone.c
@@ -50,10 +50,6 @@ main(int argc, char *argv[])
 	char *table = "filter";
 	struct iptc_handle *handle = NULL;
 
-	program_name = "iptables";
-	program_version = IPTABLES_VERSION;
-
-	xtables_program_name = program_name;
 	iptables_globals.program_name = "iptables";
 	ret = xtables_init_all(&iptables_globals, NFPROTO_IPV4);
 	if (ret < 0) {
diff --git a/iptables-xml.c b/iptables-xml.c
index 4bb0557..4f8701e 100644
--- a/iptables-xml.c
+++ b/iptables-xml.c
@@ -26,13 +26,19 @@
 #endif
 
 /* no need to link with iptables.o */
-const char *program_name;
-const char *program_version;
 
 #ifndef IPTABLES_MULTI
 int line = 0;
 #endif
 
+struct xtables_globals iptables_xml_globals = {
+	.option_offset = 0,
+	.program_version = IPTABLES_VERSION,
+	.program_name = "iptables-xml",
+};
+#define prog_name iptables_xml_globals.program_name
+#define prog_vers iptables_xml_globals.program_version
+
 static void print_usage(const char *name, const char *version)
 	    __attribute__ ((noreturn));
 
@@ -294,7 +300,7 @@ saveChain(char *chain, char *policy, struct ipt_counters *ctr)
 	if (nextChain >= maxChains) {
 		exit_error(PARAMETER_PROBLEM,
 			   "%s: line %u chain name invalid\n",
-			   program_name, line);
+			   prog_name, line);
 		exit(1);
 	};
 	chains[nextChain].chain = strdup(chain);
@@ -618,12 +624,6 @@ do_rule(char *pcnt, char *bcnt, int argc, char *argv[], int argvattr[])
 	do_rule_part(NULL, NULL, 1, argc, argv, argvattr);
 }
 
-struct xtables_globals iptables_xml_globals = {
-	.option_offset = 0,
-	.program_version = IPTABLES_VERSION,
-	.program_name = "iptables-xml",
-};
-
 #ifdef IPTABLES_MULTI
 int
 iptables_xml_main(int argc, char *argv[])
@@ -636,8 +636,6 @@ main(int argc, char *argv[])
 	int c;
 	FILE *in;
 
-	program_name = "iptables-xml";
-	program_version = IPTABLES_VERSION;
 	line = 0;
 
 	xtables_set_params(&iptables_xml_globals);
@@ -703,7 +701,7 @@ main(int argc, char *argv[])
 			if (!table) {
 				exit_error(PARAMETER_PROBLEM,
 					   "%s: line %u table name invalid\n",
-					   program_name, line);
+					   prog_name, line);
 				exit(1);
 			}
 			openTable(table);
@@ -720,7 +718,7 @@ main(int argc, char *argv[])
 			if (!chain) {
 				exit_error(PARAMETER_PROBLEM,
 					   "%s: line %u chain name invalid\n",
-					   program_name, line);
+					   prog_name, line);
 				exit(1);
 			}
 
@@ -731,7 +729,7 @@ main(int argc, char *argv[])
 			if (!policy) {
 				exit_error(PARAMETER_PROBLEM,
 					   "%s: line %u policy invalid\n",
-					   program_name, line);
+					   prog_name, line);
 				exit(1);
 			}
 
@@ -864,13 +862,13 @@ main(int argc, char *argv[])
 		}
 		if (!ret) {
 			fprintf(stderr, "%s: line %u failed\n",
-				program_name, line);
+				prog_name, line);
 			exit(1);
 		}
 	}
 	if (curTable[0]) {
 		fprintf(stderr, "%s: COMMIT expected at line %u\n",
-			program_name, line + 1);
+			prog_name, line + 1);
 		exit(1);
 	}
 
diff --git a/iptables.c b/iptables.c
index c83da15..f4ff28e 100644
--- a/iptables.c
+++ b/iptables.c
@@ -196,8 +196,8 @@ static int inverse_for_options[NUMBER_OF_OPT] =
 /* -c */ 0,
 };
 
-const char *program_version;
-const char *program_name;
+#define prog_name iptables_globals.program_name
+#define prog_vers iptables_globals.program_version
 
 int kernel_version;
 
@@ -241,7 +241,7 @@ exit_tryhelp(int status)
 	if (line != -1)
 		fprintf(stderr, "Error occurred at line: %d\n", line);
 	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
-			program_name, program_name );
+			prog_name, prog_name );
 	xtables_free_opts(1);
 	exit(status);
 }
@@ -262,9 +262,9 @@ exit_printhelp(struct iptables_rule_match *matches)
 "       %s -E old-chain-name new-chain-name\n"
 "       %s -P chain target [options]\n"
 "       %s -h (print this help information)\n\n",
-	       program_name, program_version, program_name, program_name,
-	       program_name, program_name, program_name, program_name,
-	       program_name, program_name, program_name);
+	       prog_name, prog_vers, prog_name, prog_name,
+	       prog_name, prog_name, prog_name, prog_name,
+	       prog_name, prog_name, prog_name);
 
 	printf(
 "Commands:\n"
@@ -342,7 +342,7 @@ iptables_exit_error(enum xtables_exittype status, const char *msg, ...)
 	va_list args;
 
 	va_start(args, msg);
-	fprintf(stderr, "%s v%s: ", program_name, program_version);
+	fprintf(stderr, "%s v%s: ", prog_name, prog_vers);
 	vfprintf(stderr, msg, args);
 	va_end(args);
 	fprintf(stderr, "\n");
@@ -1655,10 +1655,10 @@ int do_command(int argc, char *argv[], char **table, struct iptc_handle **handle
 
 		case 'V':
 			if (invert)
-				printf("Not %s ;-)\n", program_version);
+				printf("Not %s ;-)\n", prog_vers);
 			else
 				printf("%s v%s\n",
-				       program_name, program_version);
+				       prog_name, prog_vers);
 			exit(0);
 
 		case '0':
diff --git a/xtables.c b/xtables.c
index 7e87cd2..78c62e1 100644
--- a/xtables.c
+++ b/xtables.c
@@ -150,11 +150,6 @@ static const struct xtables_afinfo afinfo_ipv6 = {
 
 static const struct xtables_afinfo *afinfo;
 
-/**
- * Program will set this to its own name.
- */
-const char *xtables_program_name;
-
 /* Search path for Xtables .so files */
 static const char *xtables_libdir;
 
@@ -691,7 +686,7 @@ void xtables_register_match(struct xtables_match *me)
 	if (strcmp(me->version, XTABLES_VERSION) != 0) {
 		fprintf(stderr, "%s: match \"%s\" has version \"%s\", "
 		        "but \"%s\" is required.\n",
-			xtables_program_name, me->name,
+			xt_params->program_name, me->name,
 			me->version, XTABLES_VERSION);
 		exit(1);
 	}
@@ -699,14 +694,14 @@ void xtables_register_match(struct xtables_match *me)
 	/* Revision field stole a char from name. */
 	if (strlen(me->name) >= XT_FUNCTION_MAXNAMELEN-1) {
 		fprintf(stderr, "%s: target `%s' has invalid name\n",
-			xtables_program_name, me->name);
+			xt_params->program_name, me->name);
 		exit(1);
 	}
 
 	if (me->family >= NPROTO) {
 		fprintf(stderr,
 			"%s: BUG: match %s has invalid protocol family\n",
-			xtables_program_name, me->name);
+			xt_params->program_name, me->name);
 		exit(1);
 	}
 
@@ -720,7 +715,7 @@ void xtables_register_match(struct xtables_match *me)
 		    old->family == me->family) {
 			fprintf(stderr,
 				"%s: match `%s' already registered.\n",
-				xtables_program_name, me->name);
+				xt_params->program_name, me->name);
 			exit(1);
 		}
 
@@ -744,7 +739,7 @@ void xtables_register_match(struct xtables_match *me)
 
 	if (me->size != XT_ALIGN(me->size)) {
 		fprintf(stderr, "%s: match `%s' has invalid size %u.\n",
-			xtables_program_name, me->name, (unsigned int)me->size);
+			xt_params->program_name, me->name, (unsigned int)me->size);
 		exit(1);
 	}
 
@@ -764,7 +759,7 @@ void xtables_register_target(struct xtables_target *me)
 	if (strcmp(me->version, XTABLES_VERSION) != 0) {
 		fprintf(stderr, "%s: target \"%s\" has version \"%s\", "
 		        "but \"%s\" is required.\n",
-			xtables_program_name, me->name,
+			xt_params->program_name, me->name,
 			me->version, XTABLES_VERSION);
 		exit(1);
 	}
@@ -772,14 +767,14 @@ void xtables_register_target(struct xtables_target *me)
 	/* Revision field stole a char from name. */
 	if (strlen(me->name) >= XT_FUNCTION_MAXNAMELEN-1) {
 		fprintf(stderr, "%s: target `%s' has invalid name\n",
-			xtables_program_name, me->name);
+			xt_params->program_name, me->name);
 		exit(1);
 	}
 
 	if (me->family >= NPROTO) {
 		fprintf(stderr,
 			"%s: BUG: target %s has invalid protocol family\n",
-			xtables_program_name, me->name);
+			xt_params->program_name, me->name);
 		exit(1);
 	}
 
@@ -795,7 +790,7 @@ void xtables_register_target(struct xtables_target *me)
 		    old->family == me->family) {
 			fprintf(stderr,
 				"%s: target `%s' already registered.\n",
-				xtables_program_name, me->name);
+				xt_params->program_name, me->name);
 			exit(1);
 		}
 
@@ -819,7 +814,7 @@ void xtables_register_target(struct xtables_target *me)
 
 	if (me->size != XT_ALIGN(me->size)) {
 		fprintf(stderr, "%s: target `%s' has invalid size %u.\n",
-			xtables_program_name, me->name, (unsigned int)me->size);
+			xt_params->program_name, me->name, (unsigned int)me->size);
 		exit(1);
 	}
 

--=-ihR7JY62PTnmFRa3WChh--

