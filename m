From: Herve Eychenne <rv@wallfire.org>
Subject: [PATCH] multiple changes/fixes
Date: Fri, 27 Aug 2004 15:37:00 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <20040827133700.GT23981@eychenne.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="Rgf3q3z9SdmXC6oT"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


--Rgf3q3z9SdmXC6oT
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

 Hi,

The attached patch contains the following changes, some of them
having been discussed on this mailing-list during the last days.
So here it is:

- up tp now iptables-save (with or without -c) used to dump counters
  for builtin-chains, which was wrong (useless when not called with -c).
  This is now fixed: counters are dumped _only_ with -c option.
- ip{,6}tables-save (with or without -c) used to dump dummy counters
  (always [0:0]) for user-chains, which was wrong (never needed,
  as it makes no sense for user-chains, right?). Fixed as well.
- old iptables-restore -c used to restore old iptables-save dumps
  (without -c) without any complaints about missing counters
  (for rules, as counters for builtin-chains were dumped anyway).
  With this patch, the new iptables-restore -c acts likewise:
  it restores iptables-save dumps (without -c) without error, but
  issues a warning about the lack of the expected counters.
- Note: dump files created by new iptables-save command (without -c)
  won't be restorable with old iptables-restore -c.
  People who really have to use previous iptables-restore versions
  can use iptables-save -c (new version).

- removed the -t (--test) option from ip{,6}tables-restore, now
  replaced by -S (--simulate) below.
- added tc_set_nocommit to libip{,6}tc, which enables not to commit
  ruleset changes to the kernel.
- added -S (--simulate) switch to ip{,6}tables{,-restore}, which
  replaces old partially undocumented -t (--test) option of
  ip{,6}tables-restore, and now uses the iptc nocommit facility.
  That is useful for validating the rule syntax, for example.
  Added -S to ip{,6}tables{,-restore} help messages and man pages.
- Note: like we said in a thread on netfilter-devel, --simulate is
  not a pure virtual simulation, as it may have the side effect
  of loading iptable_* kernel modules and their dependencies, notably
  ip_conntrack, which can lead to performance issues after the
  simulation.
  In the future, we could remove modules added by the simulation
  automatically.

- added -t (--table) option to ip{,6}tables-restore, which enables to
  restore only a specific table of the input file.
  When --table is specified, other tables in the input file are
  not parsed/validated. The file can be validated with --simulate,
  though.
  TODO: enable to specify --table option several times with
  ip{,6}tables-{save,restore}

- ip{,6}tables-{save,restore} called with wrong options now fails,
  as it should.
- added -C (--no-comments) option to ip{,6}tables-save: no comment is
  printed, enabling to compare dumps without pre-processing.
- added help message to ip{,6}tables-save.
- completed ip{,6}tables-{save,restore}.8 with missing (formerly
  undocumented) options.
- ip{,6}tables-restore.8 contained "None known as of iptables-1.2.1
  release". Changed it to iptables-1.2.10, as there was a problem with
  the order of matches.

- removed --binary option everywhere because it was not documented,
  not implemented, because there are very few chances it may ever be,
  and because it will be so easy to add these few lines back if we want
  to implement it someday.
- changed "magic" initial value of 'line' variable to 0 (instead of -1), =
as
  line 0 is a good remarquable value as well, and this avoids to add extr=
a
  tests to display correct error information in every case with
  ip{,6}tables{,-restore}.
- added the reason of the failure when ip{,6}tables-restore fails at a
  particular line.
- fixed wrong call to strerror(), changing it to ip{,6}tc_strerror()
  on error when creating a chain, in ip{,6}tables.c
- removed all useless exit() calls after exit_error()
- fixed multiple typos, spaces and indentations. Global cleanup of the co=
de.
- even more synchronisation between IPv4 and IPv6 parts.


I tried my best not to forget anything, especially regarding global
coherence, synchronisation between IPv4 and IPv6 parts, or between
options, help messages and man pages.
Yet, this patch touches quite simple but multiple things, so one never
knows... Further reviews/testing welcome!

 Herve

--=20
 _
(=B0=3D  Herv=E9 Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/

--Rgf3q3z9SdmXC6oT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="iptables.patch3"

diff -ruN iptables.ori/Makefile iptables.new/Makefile
--- iptables.ori/Makefile	2004-06-25 13:18:57.000000000 +0200
+++ iptables.new/Makefile	2004-08-27 03:16:20.000000000 +0200
@@ -26,7 +26,7 @@
 # directory for new iptables releases
 RELEASE_DIR:=/tmp
 
-# Need libc6 for this.  FIXME: Should covert to autoconf.
+# Need libc6 for this.  FIXME: Should convert to autoconf.
 ifeq ($(shell [ -f /usr/include/netinet/ip6.h ] && echo YES), YES)
 DO_IPV6:=1
 endif
diff -ruN iptables.ori/include/libiptc/libip6tc.h iptables.new/include/libiptc/libip6tc.h
--- iptables.ori/include/libiptc/libip6tc.h	2003-05-05 21:33:40.000000000 +0200
+++ iptables.new/include/libiptc/libip6tc.h	2004-08-13 12:22:46.000000000 +0200
@@ -20,15 +20,15 @@
 /* Transparent handle type. */
 typedef struct ip6tc_handle *ip6tc_handle_t;
 
-/* Does this chain exist? */
-int ip6tc_is_chain(const char *chain, const ip6tc_handle_t handle);
-
 /* Take a snapshot of the rules. Returns NULL on error. */
 ip6tc_handle_t ip6tc_init(const char *tablename);
 
 /* Cleanup after ip6tc_init(). */
 void ip6tc_free(ip6tc_handle_t *h);
 
+/* Enable not to commit anything to the kernel. */
+void ip6tc_set_nocommit(ip6tc_handle_t *h);
+
 /* Iterator functions to run through the chains.  Returns NULL at end. */
 const char *ip6tc_first_chain(ip6tc_handle_t *handle);
 const char *ip6tc_next_chain(ip6tc_handle_t *handle);
@@ -45,6 +45,9 @@
 const char *ip6tc_get_target(const struct ip6t_entry *e,
 			     ip6tc_handle_t *handle);
 
+/* Does this chain exist? */
+int ip6tc_is_chain(const char *chain, const ip6tc_handle_t handle);
+
 /* Is this a built-in chain? */
 int ip6tc_builtin(const char *chain, const ip6tc_handle_t handle);
 
diff -ruN iptables.ori/include/libiptc/libiptc.h iptables.new/include/libiptc/libiptc.h
--- iptables.ori/include/libiptc/libiptc.h	2003-05-02 17:30:11.000000000 +0200
+++ iptables.new/include/libiptc/libiptc.h	2004-07-23 17:59:21.000000000 +0200
@@ -28,15 +28,15 @@
 /* Transparent handle type. */
 typedef struct iptc_handle *iptc_handle_t;
 
-/* Does this chain exist? */
-int iptc_is_chain(const char *chain, const iptc_handle_t handle);
-
 /* Take a snapshot of the rules.  Returns NULL on error. */
 iptc_handle_t iptc_init(const char *tablename);
 
 /* Cleanup after iptc_init(). */
 void iptc_free(iptc_handle_t *h);
 
+/* Enable not to commit anything to the kernel. */
+void iptc_set_nocommit(iptc_handle_t *h);
+
 /* Iterator functions to run through the chains.  Returns NULL at end. */
 const char *iptc_first_chain(iptc_handle_t *handle);
 const char *iptc_next_chain(iptc_handle_t *handle);
@@ -53,6 +53,9 @@
 const char *iptc_get_target(const struct ipt_entry *e,
 			    iptc_handle_t *handle);
 
+/* Does this chain exist? */
+int iptc_is_chain(const char *chain, const iptc_handle_t handle);
+
 /* Is this a built-in chain? */
 int iptc_builtin(const char *chain, const iptc_handle_t handle);
 
diff -ruN iptables.ori/ip6tables-restore.8 iptables.new/ip6tables-restore.8
--- iptables.ori/ip6tables-restore.8	2002-06-14 09:39:58.000000000 +0200
+++ iptables.new/ip6tables-restore.8	2004-08-27 03:10:54.000000000 +0200
@@ -21,24 +21,46 @@
 .SH NAME
 ip6tables-restore \- Restore IPv6 Tables
 .SH SYNOPSIS
-.BR "ip6tables-restore " "[-c] [-n]"
+.BR "ip6tables-restore " "[-c] [-n] [-t table] [-M cmd] [-v] [-S] [-h]"
 .br
 .SH DESCRIPTION
 .PP
 .B ip6tables-restore
 is used to restore IPv6 Tables from data specified on STDIN. Use 
-I/O redirection provided by your shell to read from a file
+I/O redirection provided by your shell to read from a file.
 .TP
 \fB\-c\fR, \fB\-\-counters\fR
-restore the values of all packet and byte counters
-.TP
-\fB\-n\fR, \fB\-\-noflush\fR 
+restore the values of all packet and byte counters.
 .TP
+\fB\-n\fR, \fB\-\-noflush\fR
 don't flush the previous contents of the table. If not specified, 
 .B ip6tables-restore
-flushes (deletes) all previous contents of the respective IPv6 Table.
+flush (delete) all previous contents of the respective IPv6 Table.
+.TP
+\fB\-t\fR, \fB\-\-table\fR \fBtablename\fR
+restrict restoration to only one table, even if multiple tables are
+present in the input file.  When this option is specified, other tables
+in the input file are not parsed, thus not validated.
+.TP
+\fB\-M\fR \fBcommand\fR, \fB\-\-modprobe\fR \fBcommand\fR
+if iptables needs to load kernel modules, load them with this command.
+.TP
+\fB\-v\fR, \fB\-\-verbose\fR
+verbose output.
+.TP
+\fB\-S\fR, \fB\-\-simulate\fR
+simulate the restoration, do not commit ruleset changes to the kernel.
+Yet, this is not a pure virtual simulation, as it may have the side
+effect of loading iptable_* kernel modules and their possible
+dependencies.
+.\" (add later, as nat table is not implemented yet) @@
+.\" , notably ip_conntrack, which can lead to performance issues
+.\" after the simulation.
+.TP
+\fB\-h\fR, \fB\-\-help\fR
+display help message.
 .SH BUGS
-None known as of iptables-1.2.1 release
+None known as of iptables-1.2.10 release
 .SH AUTHORS
 Harald Welte <laforge@gnumonks.org>
 .br
diff -ruN iptables.ori/ip6tables-restore.c iptables.new/ip6tables-restore.c
--- iptables.ori/ip6tables-restore.c	2004-05-26 18:04:48.000000000 +0200
+++ iptables.new/ip6tables-restore.c	2004-08-26 23:33:03.000000000 +0200
@@ -1,4 +1,4 @@
-/* Code to restore the iptables state, from file by ip6tables-save. 
+/* Code to restore the ip6tables state, from file by ip6tables-save.
  * Author:  Andras Kis-Szabo <kisza@sch.bme.hu>
  *
  * based on iptables-restore
@@ -21,96 +21,97 @@
 #ifdef DEBUG
 #define DEBUGP(x, args...) fprintf(stderr, x, ## args)
 #else
-#define DEBUGP(x, args...) 
+#define DEBUGP(x, args...)
 #endif
 
-static int binary = 0, counters = 0, verbose = 0, noflush = 0;
+static int counters = 0, verbose = 0, noflush = 0;
 
 /* Keeping track of external matches and targets.  */
 static struct option options[] = {
-	{ "binary", 0, 0, 'b' },
 	{ "counters", 0, 0, 'c' },
 	{ "verbose", 0, 0, 'v' },
-	{ "test", 0, 0, 't' },
+	{ "table", 1, 0, 't' },
 	{ "help", 0, 0, 'h' },
-	{ "noflush", 0, 0, 'n'},
-	{ "modprobe", 1, 0, 'M'},
+	{ "noflush", 0, 0, 'n' },
+	{ "modprobe", 1, 0, 'M' },
+	{ "simulate", 0, 0, 'S' },
 	{ 0 }
 };
 
-static void print_usage(const char *name, const char *version) __attribute__((noreturn));
-
-static void print_usage(const char *name, const char *version)
-{
-	fprintf(stderr, "Usage: %s [-b] [-c] [-v] [-t] [-h]\n"
-			"	   [ --binary ]\n"
+static void
+print_usage(const char *name, const char *version) {
+	fprintf(stderr, "%s v%s\n\n"
+			"Usage: %s [-c] [-n] [-t table] [-M cmd] [-S] [-v] [-h]\n"
 			"	   [ --counters ]\n"
-			"	   [ --verbose ]\n"
-			"	   [ --test ]\n"
-			"	   [ --help ]\n"
 			"	   [ --noflush ]\n"
-		        "          [ --modprobe=<command>]\n", name);
-		
-	exit(1);
+		        "	   [ --table name ]\n"
+		        "	   [ --modprobe=<command> ]\n"
+			"	   [ --simulate ]\n"
+			"	   [ --verbose ]\n"
+			"	   [ --help ]\n",
+		name, version, name);
 }
 
-ip6tc_handle_t create_handle(const char *tablename, const char* modprobe)
-{
-	ip6tc_handle_t handle;
-
-	handle = ip6tc_init(tablename);
+static ip6tc_handle_t
+create_handle(const char *tablename, const char* modprobe, int simulate) {
+	ip6tc_handle_t handle = ip6tc_init(tablename);
 
 	if (!handle) {
-		/* try to insmod the module if iptc_init failed */
+		/* try to insmod the module if ip6tc_init failed */
 		ip6tables_insmod("ip6_tables", modprobe);
 		handle = ip6tc_init(tablename);
 	}
 
-	if (!handle) {
+	if (!handle)
 		exit_error(PARAMETER_PROBLEM, "%s: unable to initialize"
-			"table '%s'\n", program_name, tablename);
-		exit(1);
-	}
+			   "table '%s'\n", program_name, tablename);
+	if (simulate)
+		ip6tc_set_nocommit(&handle);
 	return handle;
 }
 
-int parse_counters(char *string, struct ip6t_counters *ctr)
-{
-	return (sscanf(string, "[%llu:%llu]", (unsigned long long *)&ctr->pcnt, (unsigned long long *)&ctr->bcnt) == 2);
+static int
+parse_counters(const char *string, struct ip6t_counters *ctr) {
+	return (sscanf(string, "[%llu:%llu]",
+		       (unsigned long long *)&ctr->pcnt,
+		       (unsigned long long *)&ctr->bcnt) == 2);
 }
 
 /* global new argv and argc */
 static char *newargv[255];
 static int newargc;
 
-/* function adding one argument to newargv, updating newargc 
+/* function adding one argument to newargv, updating newargc
  * returns true if argument added, false otherwise */
-static int add_argv(char *what) {
+static int
+add_argv(const char *what) {
 	DEBUGP("add_argv: %s\n", what);
 	if (what && ((newargc + 1) < sizeof(newargv)/sizeof(char *))) {
 		newargv[newargc] = strdup(what);
 		newargc++;
 		return 1;
-	} else 
+	} else
 		return 0;
 }
 
-static void free_argv(void) {
+static void
+free_argv(void) {
 	int i;
 
 	for (i = 0; i < newargc; i++)
 		free(newargv[i]);
 }
 
-int main(int argc, char *argv[])
-{
+int
+main(int argc, char *argv[]) {
 	ip6tc_handle_t handle = NULL;
 	char buffer[10240];
 	int c;
 	char curtable[IP6T_TABLE_MAXNAMELEN + 1];
 	FILE *in;
-	const char *modprobe = 0;
-	int in_table = 0, testing = 0;
+	const char *modprobe = NULL;
+	int in_table = 0, simulate = 0;
+	const char *tablename = NULL;
 
 	program_name = "ip6tables-restore";
 	program_version = IPTABLES_VERSION;
@@ -120,113 +121,106 @@
 	init_extensions();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcvthnM:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "cvt:nM:Sh", options, NULL)) != -1) {
 		switch (c) {
-			case 'b':
-				binary = 1;
-				break;
-			case 'c':
-				counters = 1;
-				break;
-			case 'v':
-				verbose = 1;
-				break;
-			case 't':
-				testing = 1;
-				break;
-			case 'h':
-				print_usage("ip6tables-restore",
-					    IPTABLES_VERSION);
-				break;
-			case 'n':
-				noflush = 1;
-				break;
-			case 'M':
-				modprobe = optarg;
-				break;
+		case 'c':
+			counters = 1;
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		case 't': /* Select specific table. */
+			tablename = optarg;
+			break;
+		case 'n':
+			noflush = 1;
+			break;
+		case 'M':
+			modprobe = optarg;
+			break;
+		case 'S':
+			simulate = 1;
+			break;
+		case 'h':
+			print_usage(program_name, IPTABLES_VERSION);
+			exit(0);
+		case '?':
+			exit_tryhelp(PARAMETER_PROBLEM);
 		}
 	}
-	
+
 	if (optind == argc - 1) {
 		in = fopen(argv[optind], "r");
 		if (!in) {
-			fprintf(stderr, "Can't open %s: %s", argv[optind],
+			fprintf(stderr, "Can't open %s: %s\n", argv[optind],
 				strerror(errno));
 			exit(1);
 		}
 	}
 	else if (optind < argc) {
-		fprintf(stderr, "Unknown arguments found on commandline");
+		fprintf(stderr, "%s: unknown arguments found on commandline\n",
+			program_name);
 		exit(1);
 	}
 	else in = stdin;
-	
+
 	/* Grab standard input. */
 	while (fgets(buffer, sizeof(buffer), in)) {
-		int ret = 0;
+		int ret = 0; /* error by default */
 
 		line++;
 		if (buffer[0] == '\n')
 			continue;
-		else if (buffer[0] == '#') {
+		else if (buffer[0] == '#') { /* comment */
 			if (verbose)
 				fputs(buffer, stdout);
 			continue;
-		} else if ((strcmp(buffer, "COMMIT\n") == 0) && (in_table)) {
-			if (!testing) {
-				DEBUGP("Calling commit\n");
-				ret = ip6tc_commit(&handle);
-			} else {
-				DEBUGP("Not calling commit, testing\n");
-				ret = 1;
-			}
+		} else if (in_table && !strcmp(buffer, "COMMIT\n")) {
+			DEBUGP("Calling commit\n");
+			ret = ip6tc_commit(&handle);
 			in_table = 0;
-		} else if ((buffer[0] == '*') && (!in_table)) {
-			/* New table */
-			char *table;
-
-			table = strtok(buffer+1, " \t\n");
+		} else if (!in_table && buffer[0] == '*') { /* new table */
+			char *table = strtok(buffer+1, " \t\n");
 			DEBUGP("line %u, table '%s'\n", line, table);
-			if (!table) {
-				exit_error(PARAMETER_PROBLEM, 
-					"%s: line %u table name invalid\n",
-					program_name, line);
-				exit(1);
-			}
+			if (!table)
+				exit_error(PARAMETER_PROBLEM,
+					   "%s: line %u table name invalid\n",
+					   program_name, line);
+
+			if (tablename != NULL && strcmp(tablename, table))
+				continue; /* not the selected table */
+
 			strncpy(curtable, table, IP6T_TABLE_MAXNAMELEN);
 			curtable[IP6T_TABLE_MAXNAMELEN] = '\0';
 
 			if (handle)
 				ip6tc_free(&handle);
 
-			handle = create_handle(table, modprobe);
+			handle = create_handle(table, modprobe, simulate);
+
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
 
-			ret = 1;
 			in_table = 1;
-
-		} else if ((buffer[0] == ':') && (in_table)) {
-			/* New chain. */
+			continue; /* ok */
+		} else if (in_table && buffer[0] == ':') { /* new chain */
 			char *policy, *chain;
 
 			chain = strtok(buffer+1, " \t\n");
 			DEBUGP("line %u, chain '%s'\n", line, chain);
-			if (!chain) {
+			if (!chain)
 				exit_error(PARAMETER_PROBLEM,
 					   "%s: line %u chain name invalid\n",
 					   program_name, line);
-				exit(1);
-			}
 
 			if (!ip6tc_builtin(chain, handle)) {
 				DEBUGP("Creating new chain '%s'\n", chain);
@@ -234,34 +228,35 @@
 					exit_error(PARAMETER_PROBLEM,
 						   "error creating chain "
 						   "'%s':%s\n", chain,
-						   strerror(errno));
+						   ip6tc_strerror(errno));
 			}
 
 			policy = strtok(NULL, " \t\n");
 			DEBUGP("line %u, policy '%s'\n", line, policy);
-			if (!policy) {
+			if (!policy)
 				exit_error(PARAMETER_PROBLEM,
 					   "%s: line %u policy invalid\n",
 					   program_name, line);
-				exit(1);
-			}
 
-			if (strcmp(policy, "-") != 0) {
+			if (strcmp(policy, "-") != 0) { /* builtin chain? */
 				struct ip6t_counters count;
 
 				if (counters) {
-					char *ctrs;
-					ctrs = strtok(NULL, " \t\n");
-
-					parse_counters(ctrs, &count);
-
-				} else {
-					memset(&count, 0, 
+					char *ctrs = strtok(NULL, " \t\n");
+					if (ctrs != NULL)
+						parse_counters(ctrs, &count);
+					else {
+						fprintf(stderr, "%s: Warning: no counter could be found at line %u. Assuming [0:0].\n",
+							program_name, line);
+						memset(&count, 0,
+						       sizeof(struct ip6t_counters));
+					}
+				} else
+					memset(&count, 0,
 					       sizeof(struct ip6t_counters));
-				}
 
 				DEBUGP("Setting policy of chain %s to %s\n",
-					chain, policy);
+				       chain, policy);
 
 				if (!ip6tc_set_policy(chain, policy, &count,
 						     &handle))
@@ -271,9 +266,7 @@
 						chain, policy, line,
 						ip6tc_strerror(errno));
 			}
-
-			ret = 1;
-
+			continue; /* ok */
 		} else if (in_table) {
 			int a;
 			char *ptr = buffer;
@@ -318,7 +311,7 @@
 			add_argv(argv[0]);
 			add_argv("-t");
 			add_argv((char *) &curtable);
-			
+
 			if (counters && pcnt && bcnt) {
 				add_argv("--set-counters");
 				add_argv((char *) pcnt);
@@ -331,13 +324,13 @@
 
 			quote_open = 0;
 			param_start = parsestart;
-			
+
 			for (curchar = parsestart; *curchar; curchar++) {
 				if (*curchar == '"') {
 					/* quote_open cannot be true if there
-					 * was no previous character.  Thus, 
+					 * was no previous character.  Thus,
 					 * curchar-1 has to be within bounds */
-					if (quote_open && 
+					if (quote_open &&
 					    *(curchar-1) != '\\') {
 						quote_open = 0;
 						*curchar = ' ';
@@ -345,7 +338,7 @@
 						quote_open = 1;
 						param_start++;
 					}
-				} 
+				}
 				if (*curchar == ' '
 				    || *curchar == '\t'
 				    || * curchar == '\n') {
@@ -360,7 +353,7 @@
 						param_start++;
 						continue;
 					}
-					
+
 					/* end of one parameter */
 					strncpy(param_buffer, param_start,
 						param_len);
@@ -368,12 +361,10 @@
 
 					/* check if table name specified */
 					if (!strncmp(param_buffer, "-t", 3)
-                                            || !strncmp(param_buffer, "--table", 8)) {
-						exit_error(PARAMETER_PROBLEM, 
+                                            || !strncmp(param_buffer, "--table", 8))
+						exit_error(PARAMETER_PROBLEM,
 						   "Line %u seems to have a "
 						   "-t table option.\n", line);
-						exit(1);
-					}
 
 					add_argv(param_buffer);
 					param_start += param_len + 1;
@@ -388,20 +379,22 @@
 			for (a = 0; a < newargc; a++)
 				DEBUGP("argv[%u]: %s\n", a, newargv[a]);
 
-			ret = do_command6(newargc, newargv, 
+			ret = do_command6(newargc, newargv,
 					 &newargv[2], &handle);
 
 			free_argv();
-		}
+		} else if (tablename != NULL)
+			continue;
+
 		if (!ret) {
-			fprintf(stderr, "%s: line %u failed\n",
-					program_name, line);
+			fprintf(stderr, "%s: line %u failed: %s\n",
+				program_name, line, ip6tc_strerror(errno));
 			exit(1);
 		}
 	}
 	if (in_table) {
 		fprintf(stderr, "%s: COMMIT expected at line %u\n",
-				program_name, line + 1);
+			program_name, line + 1);
 		exit(1);
 	}
 
diff -ruN iptables.ori/ip6tables-save.8 iptables.new/ip6tables-save.8
--- iptables.ori/ip6tables-save.8	2002-06-14 09:39:58.000000000 +0200
+++ iptables.new/ip6tables-save.8	2004-08-27 03:14:28.000000000 +0200
@@ -21,7 +21,7 @@
 .SH NAME
 ip6tables-save \- Save IPv6 Tables
 .SH SYNOPSIS
-.BR "ip6tables-save " "[-c] [-t table]"
+.BR "ip6tables-save " "[-c] [-t table] [-C] [-h]"
 .br
 .SH DESCRIPTION
 .PP
@@ -30,12 +30,17 @@
 to STDOUT. Use I/O-redirection provided by your shell to write to a file.
 .TP
 \fB\-c\fR, \fB\-\-counters\fR
-include the current values of all packet and byte counters in the output
+include the current values of all packet and byte counters in the output.
 .TP
 \fB\-t\fR, \fB\-\-table\fR \fBtablename\fR
-.TP
 restrict output to only one table. If not specified, output includes all
 available tables.
+.TP
+\fB\-C\fR, \fB\-\-no-comments\fR
+do not output any comment. Useful for comparing two dump files.
+.TP
+\fB\-h\fR, \fB\-\-help\fR
+display help message.
 .SH BUGS
 None known as of iptables-1.2.1 release
 .SH AUTHORS
diff -ruN iptables.ori/ip6tables-save.c iptables.new/ip6tables-save.c
--- iptables.ori/ip6tables-save.c	2004-05-26 18:04:48.000000000 +0200
+++ iptables.new/ip6tables-save.c	2004-08-26 16:45:22.000000000 +0200
@@ -1,7 +1,7 @@
 /* Code to save the ip6tables state, in human readable-form. */
 /* Author:  Andras Kis-Szabo <kisza@sch.bme.hu>
  * Original code: iptables-save
- * Authors: Paul 'Rusty' Russel <rusty@linuxcare.com.au> and
+ * Authors: Paul 'Rusty' Russell <rusty@linuxcare.com.au> and
  * 	    Harald Welte <laforge@gnumonks.org>
  * This code is distributed under the terms of GNU GPL v2
  */
@@ -18,22 +18,31 @@
 #include "libiptc/libip6tc.h"
 #include "ip6tables.h"
 
-static int binary = 0, counters = 0;
+static int counters = 0, no_comments = 0;
 
 static struct option options[] = {
-	{ "binary", 0, 0, 'b' },
 	{ "counters", 0, 0, 'c' },
-	{ "dump", 0, 0, 'd' },
 	{ "table", 1, 0, 't' },
+	{ "no-comments", 0, 0, 'C' },
+	{ "help", 0, 0, 'h' },
 	{ 0 }
 };
 
+static void
+print_usage(const char *name, const char *version) {
+	fprintf(stderr, "%s v%s\n\n"
+			"Usage: %s [-c] [-t table] [-C] [-h]\n"
+			"	   [ --counters ]\n"
+		        "	   [ --table name ]\n"
+		        "	   [ --no-comments ]\n"
+			"	   [ --help ]\n",
+		name, version, name);
+}
 
 /* This assumes that mask is contiguous, and byte-bounded. */
 static void
 print_iface(char letter, const char *iface, const unsigned char *mask,
-	    int invert)
-{
+	    int invert) {
 	unsigned int i;
 
 	if (mask[0] == 0)
@@ -46,15 +55,15 @@
 			if (iface[i] != '\0')
 				printf("%c", iface[i]);
 		} else {
-			/* we can access iface[i-1] here, because 
+			/* we can access iface[i-1] here, because
 			 * a few lines above we make sure that mask[0] != 0 */
 			if (iface[i-1] != '\0')
-				printf("+");
+				putchar('+');
 			break;
 		}
 	}
 
-	printf(" ");
+	putchar(' ');
 }
 
 /* These are hardcoded backups in ip6tables.c, so they are safe */
@@ -72,17 +81,16 @@
 };
 
 /* The ip6tables looks up the /etc/protocols. */
-static void print_proto(u_int16_t proto, int invert)
-{
+static void
+print_proto(u_int16_t proto, int invert) {
 	if (proto) {
 		unsigned int i;
 		const char *invertstr = invert ? "! " : "";
 
-                struct protoent *pent = getprotobynumber(proto);
-                if (pent) {
-			printf("-p %s%s ",
-			       invertstr, pent->p_name);
-	                return;
+		struct protoent *pent = getprotobynumber(proto);
+		if (pent) {
+			printf("-p %s%s ", invertstr, pent->p_name);
+			return;
 		}
 
 		for (i = 0; i < sizeof(chain_protos)/sizeof(struct pprot); i++)
@@ -96,9 +104,8 @@
 	}
 }
 
-static int print_match(const struct ip6t_entry_match *e,
-			const struct ip6t_ip6 *ip)
-{
+static int
+print_match(const struct ip6t_entry_match *e, const struct ip6t_ip6 *ip) {
 	struct ip6tables_match *match
 		= find_match(e->u.user.name, TRY_LOAD, NULL);
 
@@ -120,8 +127,9 @@
 }
 
 /* print a given ip including mask if neccessary */
-static void print_ip(char *prefix, const struct in6_addr *ip, const struct in6_addr *mask, int invert)
-{
+static void
+print_ip(const char *prefix, const struct in6_addr *ip,
+	 const struct in6_addr *mask, int invert) {
 	char buf[51];
 	int l = ipv6_prefix_length(mask);
 
@@ -141,22 +149,24 @@
 
 /* We want this to be readable, so only print out neccessary fields.
  * Because that's the kind of world I want to live in.  */
-static void print_rule(const struct ip6t_entry *e, 
-		ip6tc_handle_t *h, const char *chain, int counters)
-{
+static void
+print_rule(const struct ip6t_entry *e, ip6tc_handle_t *h, const char *chain,
+	   int counters) {
 	struct ip6t_entry_target *t;
 	const char *target_name;
 
 	/* print counters */
 	if (counters)
-		printf("[%llu:%llu] ", (unsigned long long)e->counters.pcnt, (unsigned long long)e->counters.bcnt);
+		printf("[%llu:%llu] ",
+		       (unsigned long long)e->counters.pcnt,
+		       (unsigned long long)e->counters.bcnt);
 
 	/* print chain name */
 	printf("-A %s ", chain);
 
 	/* Print IP part. */
 	print_ip("-s", &(e->ipv6.src), &(e->ipv6.smsk),
-			e->ipv6.invflags & IP6T_INV_SRCIP);	
+			e->ipv6.invflags & IP6T_INV_SRCIP);
 
 	print_ip("-d", &(e->ipv6.dst), &(e->ipv6.dmsk),
 			e->ipv6.invflags & IP6T_INV_DSTIP);
@@ -179,7 +189,7 @@
 
 	if (e->ipv6.flags & IP6T_F_TOS)
 		printf("%s-? %d ",
-		       e->ipv6.invflags & IP6T_INV_TOS ? "! " : "", 
+		       e->ipv6.invflags & IP6T_INV_TOS ? "! " : "",
 		       e->ipv6.tos);
 
 	/* Print matchinfo part */
@@ -187,7 +197,7 @@
 		IP6T_MATCH_ITERATE(e, print_match, &e->ipv6);
 	}
 
-	/* Print target name */	
+	/* Print target name */
 	target_name = ip6tc_get_target(e, h);
 	if (target_name && (*target_name != '\0'))
 		printf("-j %s ", target_name);
@@ -210,7 +220,7 @@
 			/* If the target size is greater than ip6t_entry_target
 			 * there is something to be saved, we just don't know
 			 * how to print it */
-			if (t->u.target_size != 
+			if (t->u.target_size !=
 			    sizeof(struct ip6t_entry_target)) {
 				fprintf(stderr, "Target `%s' is missing "
 						"save function\n",
@@ -219,12 +229,11 @@
 			}
 		}
 	}
-	printf("\n");
+	putchar('\n');
 }
 
-/* Debugging prototype. */
-static int for_each_table(int (*func)(const char *tablename))
-{
+static int
+for_each_table(int (*func)(const char *tablename)) {
         int ret = 1;
 	FILE *procfile = NULL;
 	char tablename[IP6T_TABLE_MAXNAMELEN+1];
@@ -235,7 +244,7 @@
 
 	while (fgets(tablename, sizeof(tablename), procfile)) {
 		if (tablename[strlen(tablename) - 1] != '\n')
-			exit_error(OTHER_PROBLEM, 
+			exit_error(OTHER_PROBLEM,
 				   "Badly formed tablename `%s'\n",
 				   tablename);
 		tablename[strlen(tablename) - 1] = '\0';
@@ -244,12 +253,12 @@
 
 	return ret;
 }
-	
 
-static int do_output(const char *tablename)
-{
+static int
+do_output(const char *tablename) {
 	ip6tc_handle_t h;
 	const char *chain = NULL;
+	time_t now;
 
 	if (!tablename)
 		return for_each_table(&do_output);
@@ -259,54 +268,51 @@
  		exit_error(OTHER_PROBLEM, "Can't initialize: %s\n",
 			   ip6tc_strerror(errno));
 
-	if (!binary) {
-		time_t now = time(NULL);
-
+	if (!no_comments) {
+		now = time(NULL);
 		printf("# Generated by ip6tables-save v%s on %s",
 		       IPTABLES_VERSION, ctime(&now));
-		printf("*%s\n", tablename);
-
-		/* Dump out chain names first, 
-		 * thereby preventing dependency conflicts */
-		for (chain = ip6tc_first_chain(&h);
-		     chain;
-		     chain = ip6tc_next_chain(&h)) {
-
-			printf(":%s ", chain);
-			if (ip6tc_builtin(chain, h)) {
-				struct ip6t_counters count;
-				printf("%s ",
-				       ip6tc_get_policy(chain, &count, &h));
-				printf("[%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
-			} else {
-				printf("- [0:0]\n");
-			}
-		}
+	}
+	printf("*%s\n", tablename);
 
+	/* Dump out chain names first,
+	 * thereby preventing dependency conflicts */
+	for (chain = ip6tc_first_chain(&h);
+	     chain;
+	     chain = ip6tc_next_chain(&h)) {
+		printf(":%s ", chain);
+		if (ip6tc_builtin(chain, h)) {
+			struct ip6t_counters count;
+			printf("%s", ip6tc_get_policy(chain, &count, &h));
+			if (counters)
+				printf(" [%llu:%llu]",
+				       (unsigned long long)count.pcnt,
+				       (unsigned long long)count.bcnt);
+		} else
+			putchar('-');
+		putchar('\n');
+	}
 
-		for (chain = ip6tc_first_chain(&h);
-		     chain;
-		     chain = ip6tc_next_chain(&h)) {
-			const struct ip6t_entry *e;
-
-			/* Dump out rules */
-			e = ip6tc_first_rule(chain, &h);
-			while(e) {
-				print_rule(e, &h, chain, counters);
-				e = ip6tc_next_rule(e, &h);
-			}
+	for (chain = ip6tc_first_chain(&h);
+	     chain;
+	     chain = ip6tc_next_chain(&h)) {
+		const struct ip6t_entry *e;
+
+		/* Dump out rules */
+		e = ip6tc_first_rule(chain, &h);
+		while (e) {
+			print_rule(e, &h, chain, counters);
+			e = ip6tc_next_rule(e, &h);
 		}
+	}
 
+	puts("COMMIT");
+	if (!no_comments) {
 		now = time(NULL);
-		printf("COMMIT\n");
 		printf("# Completed on %s", ctime(&now));
-	} else {
-		/* Binary, huh?  OK. */
-		exit_error(OTHER_PROBLEM, "Binary NYI\n");
 	}
 
 	ip6tc_free(&h);
-
 	return 1;
 }
 
@@ -314,8 +320,8 @@
  * :Chain name POLICY packets bytes
  * rule
  */
-int main(int argc, char *argv[])
-{
+int
+main(int argc, char *argv[]) {
 	const char *tablename = NULL;
 	int c;
 
@@ -326,28 +332,28 @@
 	init_extensions();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "ct:Ch", options, NULL)) != -1) {
 		switch (c) {
-		case 'b':
-			binary = 1;
-			break;
-
 		case 'c':
 			counters = 1;
 			break;
-
-		case 't':
-			/* Select specific table. */
+		case 't': /* Select specific table. */
 			tablename = optarg;
 			break;
-		case 'd':
-			do_output(tablename);
+		case 'C':
+			no_comments = 1;
+			break;
+		case 'h':
+			print_usage(program_name, IPTABLES_VERSION);
 			exit(0);
+		case '?':
+			exit_tryhelp(PARAMETER_PROBLEM);
 		}
 	}
 
 	if (optind < argc) {
-		fprintf(stderr, "Unknown arguments found on commandline");
+		fprintf(stderr, "%s: unknown arguments found on commandline\n",
+			program_name);
 		exit(1);
 	}
 
diff -ruN iptables.ori/ip6tables.8.in iptables.new/ip6tables.8.in
--- iptables.ori/ip6tables.8.in	2004-07-08 19:15:08.000000000 +0200
+++ iptables.new/ip6tables.8.in	2004-08-27 03:12:23.000000000 +0200
@@ -145,7 +145,7 @@
 versions of this command: the rule can be specified as a number in the
 chain (starting at 1 for the first rule) or a rule to match.
 .TP
-.B "-I, --insert"
+.BR "-I, --insert " "\fIchain\fP [\fIrulenum\fP] \fIrule-specification\fP"
 Insert one or more rules in the selected chain as the given rule
 number.  So, if the rule number is 1, the rule or rules are inserted
 at the head of the chain.  This is also the default if no rule number
@@ -272,8 +272,8 @@
 incremented.
 .TP
 .BR "-i, --in-interface " "[!] \fIname\fP"
-Name of an interface via which a packet is going to be received (only for
-packets entering the 
+Name of an interface via which a packet was received (only for
+packets entering the
 .BR INPUT ,
 .B FORWARD
 and
@@ -348,6 +348,15 @@
 When adding or inserting rules into a chain, use
 .B command
 to load any necessary modules (targets, match extensions, etc).
+.TP
+.B "-S, --simulate"
+simulate the restoration, do not commit ruleset changes to the kernel.
+Yet, this is not a pure virtual simulation, as it may have the side
+effect of loading iptable_* kernel modules and their possible
+dependencies.
+.\" (add later, as nat table is not implemented yet) @@
+.\" , notably ip_conntrack, which can lead to performance issues
+.\" after the simulation.
 .SH MATCH EXTENSIONS
 ip6tables can use extended packet matching modules.  These are loaded
 in two ways: implicitly, when
@@ -389,7 +398,7 @@
 This 
 .B ip6tables
 is very similar to ipchains by Rusty Russell.  The main difference is
-that the chains 
+that the chains
 .B INPUT
 and
 .B OUTPUT
@@ -399,7 +408,7 @@
 involves both INPUT and OUTPUT chains); previously a forwarded packet
 would pass through all three.
 .PP
-The other main difference is that 
+The other main difference is that
 .B -i
 refers to the input interface;
 .B -o
diff -ruN iptables.ori/ip6tables.c iptables.new/ip6tables.c
--- iptables.ori/ip6tables.c	2004-07-08 14:54:38.000000000 +0200
+++ iptables.new/ip6tables.c	2004-08-27 03:05:09.000000000 +0200
@@ -139,14 +139,15 @@
 	{ "line-numbers", 0, 0, '0' },
 	{ "modprobe", 1, 0, 'M' },
 	{ "set-counters", 1, 0, 'c' },
+	{ "simulate", 0, 0, 'S' },
 	{ 0 }
 };
 
 /* we need this for ip6tables-restore. ip6tables-restore.c sets line to the
  * current line of the input file, in order to give a more precise error
  * message. ip6tables itself doesn't need this, so it is initialized to the
- * magic number of -1 */
-int line = -1;
+ * magic number of 0 */
+int line = 0;
 
 #ifndef __OPTIMIZE__
 struct ip6t_entry_target *
@@ -284,7 +285,7 @@
 void
 exit_tryhelp(int status)
 {
-	if (line != -1)
+	if (line != 0)
 		fprintf(stderr, "Error occurred at line: %d\n", line);
 	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
 			program_name, program_name );
@@ -298,17 +299,19 @@
 	struct ip6tables_target *t = NULL;
 
 	printf("%s v%s\n\n"
-"Usage: %s -[AD] chain rule-specification [options]\n"
-"       %s -[RI] chain rulenum rule-specification [options]\n"
-"       %s -D chain rulenum [options]\n"
-"       %s -[LFZ] [chain] [options]\n"
-"       %s -[NX] chain\n"
-"       %s -E old-chain-name new-chain-name\n"
-"       %s -P chain target [options]\n"
+"Usage: %s [-t table] -[AD] chain rule-specification [options]\n"
+"       %s [-t table] -I chain [rulenum] rule-specification [options]\n"
+"       %s [-t table] -R chain rulenum rule-specification [options]\n"
+"       %s [-t table] -D chain rulenum [options]\n"
+"       %s [-t table] -[LFZ] [chain] [options]\n"
+"       %s [-t table] -N chain\n"
+"       %s [-t table] -X [chain]\n"
+"       %s [-t table] -P chain target [options]\n"
+"       %s [-t table] -E old-chain-name new-chain-name\n"
 "       %s -h (print this help information)\n\n",
 	       program_name, program_version, program_name, program_name,
 	       program_name, program_name, program_name, program_name,
-	       program_name, program_name);
+	       program_name, program_name, program_name, program_name);
 
 	printf(
 "Commands:\n"
@@ -349,25 +352,27 @@
 "  --out-interface -o [!] output name[+]\n"
 "				network interface name ([+] for wildcard)\n"
 "  --table	-t table	table to manipulate (default: `filter')\n"
-"  --verbose	-v		verbose mode\n"
 "  --line-numbers		print line numbers when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
 /*"[!] --fragment	-f		match second or further fragments only\n"*/
-"  --modprobe=<command>		try to insert modules using this command\n"
 "  --set-counters PKTS BYTES	set the counter during insert/append\n"
+
+"  --verbose	-v		verbose mode\n"
+"  --simulate	-S		simulate the restoration (no kernel commit)\n"
+"  --modprobe=<command>		try to insert modules using this command\n"
 "[!] --version	-V		print package version.\n");
 
-	/* Print out any special helps. A user might like to be able to add a --help 
-	   to the commandline, and see expected results. So we call help for all 
-	   specified matches & targets */
+	/* Print out any special helps. A user might like to be able
+	   to add a --help to the commandline, and see expected
+	   results. So we call help for all specified matches & targets */
 	for (t = ip6tables_targets; t; t = t->next) {
 		if (t->used) {
-			printf("\n");
+			putchar('\n');
 			t->help();
 		}
 	}
 	for (matchp = matches; matchp; matchp = matchp->next) {
-		printf("\n");
+		putchar('\n');
 		matchp->match->help();
 	}
 	exit(0);
@@ -707,7 +712,8 @@
 }
 
 struct ip6tables_match *
-find_match(const char *name, enum ip6t_tryload tryload, struct ip6tables_rule_match **matches)
+find_match(const char *name, enum ip6t_tryload tryload,
+	   struct ip6tables_rule_match **matches)
 {
 	struct ip6tables_match *ptr;
  	int icmphack = 0;
@@ -782,7 +788,8 @@
 
 /* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
 static struct ip6tables_match *
-find_proto(const char *pname, enum ip6t_tryload tryload, int nolookup, struct ip6tables_rule_match **matches)
+find_proto(const char *pname, enum ip6t_tryload tryload, int nolookup,
+	   struct ip6tables_rule_match **matches)
 {
 	unsigned int proto;
 
@@ -901,8 +908,8 @@
 }
 
 int
-string_to_number_ll(const char *s, unsigned long long min, unsigned long long max,
-		 unsigned long long *ret)
+string_to_number_ll(const char *s, unsigned long long min,
+		    unsigned long long max, unsigned long long *ret)
 {
 	unsigned long long number;
 	char *end;
@@ -922,7 +929,7 @@
 
 int
 string_to_number_l(const char *s, unsigned long min, unsigned long max,
-		 unsigned long *ret)
+		   unsigned long *ret)
 {
 	int result;
 	unsigned long long number;
@@ -934,7 +941,7 @@
 }
 
 int string_to_number(const char *s, unsigned int min, unsigned int max,
-		unsigned int *ret)
+		     unsigned int *ret)
 {
 	int result;
 	unsigned long number;
@@ -1177,13 +1184,12 @@
 	}
 	printf(FMT(" %-19s ","%s "), "source");
 	printf(FMT(" %-19s "," %s "), "destination");
-	printf("\n");
+	putchar('\n');
 }
 
 
 static int
-print_match(const struct ip6t_entry_match *m,
-	    const struct ip6t_ip6 *ip,
+print_match(const struct ip6t_entry_match *m, const struct ip6t_ip6 *ip,
 	    int numeric)
 {
 	struct ip6tables_match *match = find_match(m->u.user.name, TRY_LOAD, NULL);
@@ -1324,8 +1330,7 @@
 }
 
 static void
-print_firewall_line(const struct ip6t_entry *fw,
-		    const ip6tc_handle_t h)
+print_firewall_line(const struct ip6t_entry *fw, const ip6tc_handle_t h)
 {
 	struct ip6t_entry_target *t;
 
@@ -1413,7 +1418,8 @@
 
 	size = sizeof(struct ip6t_entry);
 	for (matchp = matches; matchp; matchp = matchp->next)
-		size += IP6T_ALIGN(sizeof(struct ip6t_entry_match)) + matchp->match->size;
+		size += IP6T_ALIGN(sizeof(struct ip6t_entry_match))
+		  + matchp->match->size;
 
 	mask = fw_calloc(1, size
 			 + IP6T_ALIGN(sizeof(struct ip6t_entry_target))
@@ -1426,7 +1432,8 @@
 		memset(mptr, 0xFF,
 		       IP6T_ALIGN(sizeof(struct ip6t_entry_match))
 		       + matchp->match->userspacesize);
-		mptr += IP6T_ALIGN(sizeof(struct ip6t_entry_match)) + matchp->match->size;
+		mptr += IP6T_ALIGN(sizeof(struct ip6t_entry_match))
+		  + matchp->match->size;
 	}
 
 	memset(mptr, 0xFF, 
@@ -1503,8 +1510,7 @@
 }
 
 int
-flush_entries(const ip6t_chainlabel chain, int verbose,
-	      ip6tc_handle_t *handle)
+flush_entries(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle)
 {
 	if (!chain)
 		return for_each_chain(flush_entries, verbose, 1, handle);
@@ -1515,8 +1521,7 @@
 }
 
 static int
-zero_entries(const ip6t_chainlabel chain, int verbose,
-	     ip6tc_handle_t *handle)
+zero_entries(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle)
 {
 	if (!chain)
 		return for_each_chain(zero_entries, verbose, 1, handle);
@@ -1527,8 +1532,7 @@
 }
 
 int
-delete_chain(const ip6t_chainlabel chain, int verbose,
-	     ip6tc_handle_t *handle)
+delete_chain(const ip6t_chainlabel chain, int verbose, ip6tc_handle_t *handle)
 {
 	if (!chain)
 		return for_each_chain(delete_chain, verbose, 0, handle);
@@ -1570,7 +1574,7 @@
 		if (chain && strcmp(chain, this) != 0)
 			continue;
 
-		if (found) printf("\n");
+		if (found) putchar('\n');
 
 		print_header(format, this, handle);
 		i = ip6tc_first_rule(this, handle);
@@ -1700,7 +1704,7 @@
 	unsigned int nsaddrs = 0, ndaddrs = 0;
 	struct in6_addr *saddrs = NULL, *daddrs = NULL;
 
-	int c, verbose = 0;
+	int c, verbose = 0, simulate = 0;
 	const char *chain = NULL;
 	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
 	const char *policy = NULL, *newname = NULL;
@@ -1739,7 +1743,7 @@
 	opterr = 0;
 
 	while ((c = getopt_long(argc, argv,
-	   "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvnt:m:xc:",
+	   "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:vnt:m:xc:S",
 					   opts, NULL)) != -1) {
 		switch (c) {
 			/*
@@ -1885,7 +1889,7 @@
 				*protocol = tolower(*protocol);
 
 			protocol = argv[optind-1];
-			if ( strcmp(protocol,"ipv6-icmp") == 0)
+			if (strcmp(protocol, "ipv6-icmp") == 0)
 				protocol = icmp6p;
 			fw.ipv6.proto = parse_protocol(protocol);
 			fw.ipv6.flags |= IP6T_F_PROTO;
@@ -1930,7 +1934,8 @@
 				target->t->u.target_size = size;
 				strcpy(target->t->u.user.name, jumpto);
 				target->init(target->t, &fw.nfcache);
-				opts = merge_options(opts, target->extra_opts, &target->option_offset);
+				opts = merge_options(opts, target->extra_opts,
+						     &target->option_offset);
 			}
 			break;
 
@@ -2039,6 +2044,9 @@
 			
 			break;
 
+		case 'S':
+			simulate = 1;
+			break;
 
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
@@ -2124,7 +2132,6 @@
 					optind--;
 					continue;
 				}
-
 				if (!m)
 					exit_error(PARAMETER_PROBLEM,
 						   "Unknown arg `%s'",
@@ -2194,8 +2201,11 @@
 
 	if (!*handle)
 		exit_error(VERSION_PROBLEM,
-			"can't initialize ip6tables table `%s': %s",
-			*table, ip6tc_strerror(errno));
+			   "can't initialize ip6tables table `%s': %s",
+			   *table, ip6tc_strerror(errno));
+
+	if (simulate)
+		ip6tc_set_nocommit(handle);
 
 	if (command == CMD_APPEND
 	    || command == CMD_DELETE
diff -ruN iptables.ori/iptables-restore.8 iptables.new/iptables-restore.8
--- iptables.ori/iptables-restore.8	2002-06-14 09:39:58.000000000 +0200
+++ iptables.new/iptables-restore.8	2004-08-27 03:09:48.000000000 +0200
@@ -21,24 +21,44 @@
 .SH NAME
 iptables-restore \- Restore IP Tables
 .SH SYNOPSIS
-.BR "iptables-restore " "[-c] [-n]"
+.BR "iptables-restore " "[-c] [-n] [-t table] [-M cmd] [-v] [-S] [-h]"
 .br
 .SH DESCRIPTION
 .PP
 .B iptables-restore
 is used to restore IP Tables from data specified on STDIN. Use 
-I/O redirection provided by your shell to read from a file
+I/O redirection provided by your shell to read from a file.
 .TP
 \fB\-c\fR, \fB\-\-counters\fR
-restore the values of all packet and byte counters
-.TP
-\fB\-n\fR, \fB\-\-noflush\fR 
+restore the values of all packet and byte counters.
 .TP
+\fB\-n\fR, \fB\-\-noflush\fR
 don't flush the previous contents of the table. If not specified, 
 .B iptables-restore
-flushes (deletes) all previous contents of the respective IP Table.
+flush (delete) all previous contents of the respective IP Table.
+.TP
+\fB\-t\fR, \fB\-\-table\fR \fBtablename\fR
+restrict restoration to only one table, even if multiple tables are
+present in the input file.  When this option is specified, other tables
+in the input file are not parsed, thus not validated.
+.TP
+\fB\-M\fR \fBcommand\fR, \fB\-\-modprobe\fR \fBcommand\fR
+if iptables needs to load kernel modules, load them with this command.
+.TP
+\fB\-v\fR, \fB\-\-verbose\fR
+verbose output.
+.TP
+\fB\-S\fR, \fB\-\-simulate\fR
+simulate the restoration, do not commit ruleset changes to the kernel.
+Yet, this is not a pure virtual simulation, as it may have the side
+effect of loading iptable_* kernel modules and their possible
+dependencies, notably ip_conntrack, which can lead to performance
+issues after the simulation.
+.TP
+\fB\-h\fR, \fB\-\-help\fR
+display help message.
 .SH BUGS
-None known as of iptables-1.2.1 release
+None known as of iptables-1.2.10 release
 .SH AUTHOR
 Harald Welte <laforge@gnumonks.org>
 .SH SEE ALSO
diff -ruN iptables.ori/iptables-restore.c iptables.new/iptables-restore.c
--- iptables.ori/iptables-restore.c	2004-06-25 13:18:57.000000000 +0200
+++ iptables.new/iptables-restore.c	2004-08-26 23:29:21.000000000 +0200
@@ -1,4 +1,4 @@
-/* Code to restore the iptables state, from file by iptables-save. 
+/* Code to restore the iptables state, from file by iptables-save.
  * (C) 2000-2002 by Harald Welte <laforge@gnumonks.org>
  * based on previous code from Rusty Russell <rusty@linuxcare.com.au>
  *
@@ -18,44 +18,40 @@
 #ifdef DEBUG
 #define DEBUGP(x, args...) fprintf(stderr, x, ## args)
 #else
-#define DEBUGP(x, args...) 
+#define DEBUGP(x, args...)
 #endif
 
-static int binary = 0, counters = 0, verbose = 0, noflush = 0;
+static int counters = 0, verbose = 0, noflush = 0;
 
 /* Keeping track of external matches and targets.  */
 static struct option options[] = {
-	{ "binary", 0, 0, 'b' },
 	{ "counters", 0, 0, 'c' },
 	{ "verbose", 0, 0, 'v' },
-	{ "test", 0, 0, 't' },
+	{ "table", 1, 0, 't' },
 	{ "help", 0, 0, 'h' },
-	{ "noflush", 0, 0, 'n'},
-	{ "modprobe", 1, 0, 'M'},
+	{ "noflush", 0, 0, 'n' },
+	{ "modprobe", 1, 0, 'M' },
+	{ "simulate", 0, 0, 'S' },
 	{ 0 }
 };
 
-static void print_usage(const char *name, const char *version) __attribute__((noreturn));
-
-static void print_usage(const char *name, const char *version)
-{
-	fprintf(stderr, "Usage: %s [-b] [-c] [-v] [-t] [-h]\n"
-			"	   [ --binary ]\n"
+static void
+print_usage(const char *name, const char *version) {
+	fprintf(stderr, "%s v%s\n\n"
+			"Usage: %s [-c] [-n] [-t table] [-M cmd] [-S] [-v] [-h]\n"
 			"	   [ --counters ]\n"
-			"	   [ --verbose ]\n"
-			"	   [ --test ]\n"
-			"	   [ --help ]\n"
 			"	   [ --noflush ]\n"
-		        "          [ --modprobe=<command>]\n", name);
-		
-	exit(1);
+		        "	   [ --table name ]\n"
+		        "	   [ --modprobe=<command> ]\n"
+			"	   [ --simulate ]\n"
+			"	   [ --verbose ]\n"
+			"	   [ --help ]\n",
+		name, version, name);
 }
 
-iptc_handle_t create_handle(const char *tablename, const char* modprobe )
-{
-	iptc_handle_t handle;
-
-	handle = iptc_init(tablename);
+static iptc_handle_t
+create_handle(const char *tablename, const char* modprobe, int simulate) {
+	iptc_handle_t handle = iptc_init(tablename);
 
 	if (!handle) {
 		/* try to insmod the module if iptc_init failed */
@@ -63,36 +59,40 @@
 		handle = iptc_init(tablename);
 	}
 
-	if (!handle) {
+	if (!handle)
 		exit_error(PARAMETER_PROBLEM, "%s: unable to initialize"
-			"table '%s'\n", program_name, tablename);
-		exit(1);
-	}
+			   "table '%s'\n", program_name, tablename);
+	if (simulate)
+		iptc_set_nocommit(&handle);
 	return handle;
 }
 
-int parse_counters(char *string, struct ipt_counters *ctr)
-{
-	return (sscanf(string, "[%llu:%llu]", (unsigned long long *)&ctr->pcnt, (unsigned long long *)&ctr->bcnt) == 2);
+static int
+parse_counters(const char *string, struct ipt_counters *ctr) {
+	return (sscanf(string, "[%llu:%llu]",
+		       (unsigned long long *)&ctr->pcnt,
+		       (unsigned long long *)&ctr->bcnt) == 2);
 }
 
 /* global new argv and argc */
 static char *newargv[255];
 static int newargc;
 
-/* function adding one argument to newargv, updating newargc 
+/* function adding one argument to newargv, updating newargc
  * returns true if argument added, false otherwise */
-static int add_argv(char *what) {
+static int
+add_argv(const char *what) {
 	DEBUGP("add_argv: %s\n", what);
 	if (what && ((newargc + 1) < sizeof(newargv)/sizeof(char *))) {
 		newargv[newargc] = strdup(what);
 		newargc++;
 		return 1;
-	} else 
+	} else
 		return 0;
 }
 
-static void free_argv(void) {
+static void
+free_argv(void) {
 	int i;
 
 	for (i = 0; i < newargc; i++)
@@ -112,8 +112,9 @@
 	int c;
 	char curtable[IPT_TABLE_MAXNAMELEN + 1];
 	FILE *in;
-	const char *modprobe = 0;
-	int in_table = 0, testing = 0;
+	const char *modprobe = NULL;
+	int in_table = 0, simulate = 0;
+	const char *tablename = NULL;
 
 	program_name = "iptables-restore";
 	program_version = IPTABLES_VERSION;
@@ -123,148 +124,142 @@
 	init_extensions();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcvthnM:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "cvt:nM:Sh", options, NULL)) != -1) {
 		switch (c) {
-			case 'b':
-				binary = 1;
-				break;
-			case 'c':
-				counters = 1;
-				break;
-			case 'v':
-				verbose = 1;
-				break;
-			case 't':
-				testing = 1;
-				break;
-			case 'h':
-				print_usage("iptables-restore",
-					    IPTABLES_VERSION);
-				break;
-			case 'n':
-				noflush = 1;
-				break;
-			case 'M':
-				modprobe = optarg;
-				break;
+		case 'c':
+			counters = 1;
+			break;
+		case 'v':
+			verbose = 1;
+			break;
+		case 't': /* Select specific table. */
+			tablename = optarg;
+			break;
+		case 'n':
+			noflush = 1;
+			break;
+		case 'M':
+			modprobe = optarg;
+			break;
+		case 'S':
+			simulate = 1;
+			break;
+		case 'h':
+			print_usage(program_name, IPTABLES_VERSION);
+			exit(0);
+		case '?':
+			exit_tryhelp(PARAMETER_PROBLEM);
 		}
 	}
-	
+
 	if (optind == argc - 1) {
 		in = fopen(argv[optind], "r");
 		if (!in) {
-			fprintf(stderr, "Can't open %s: %s", argv[optind],
+			fprintf(stderr, "Can't open %s: %s\n", argv[optind],
 				strerror(errno));
 			exit(1);
 		}
 	}
 	else if (optind < argc) {
-		fprintf(stderr, "Unknown arguments found on commandline");
+		fprintf(stderr, "%s: unknown arguments found on commandline\n",
+			program_name);
 		exit(1);
 	}
 	else in = stdin;
-	
+
 	/* Grab standard input. */
 	while (fgets(buffer, sizeof(buffer), in)) {
-		int ret = 0;
+		int ret = 0; /* error by default */
 
 		line++;
 		if (buffer[0] == '\n')
 			continue;
-		else if (buffer[0] == '#') {
+		else if (buffer[0] == '#') { /* comment */
 			if (verbose)
 				fputs(buffer, stdout);
 			continue;
-		} else if ((strcmp(buffer, "COMMIT\n") == 0) && (in_table)) {
-			if (!testing) {
-				DEBUGP("Calling commit\n");
-				ret = iptc_commit(&handle);
-			} else {
-				DEBUGP("Not calling commit, testing\n");
-				ret = 1;
-			}
+		} else if (in_table && !strcmp(buffer, "COMMIT\n")) {
+			DEBUGP("Calling commit\n");
+			ret = iptc_commit(&handle);
 			in_table = 0;
-		} else if ((buffer[0] == '*') && (!in_table)) {
-			/* New table */
-			char *table;
-
-			table = strtok(buffer+1, " \t\n");
+		} else if (!in_table && buffer[0] == '*') { /* new table */
+			char *table = strtok(buffer+1, " \t\n");
 			DEBUGP("line %u, table '%s'\n", line, table);
-			if (!table) {
-				exit_error(PARAMETER_PROBLEM, 
-					"%s: line %u table name invalid\n",
-					program_name, line);
-				exit(1);
-			}
+			if (!table)
+				exit_error(PARAMETER_PROBLEM,
+					   "%s: line %u table name invalid\n",
+					   program_name, line);
+
+			if (tablename != NULL && strcmp(tablename, table))
+				continue; /* not the selected table */
+
 			strncpy(curtable, table, IPT_TABLE_MAXNAMELEN);
 			curtable[IPT_TABLE_MAXNAMELEN] = '\0';
 
 			if (handle)
 				iptc_free(&handle);
 
-			handle = create_handle(table, modprobe);
+			handle = create_handle(table, modprobe, simulate);
+
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
 
-			ret = 1;
 			in_table = 1;
-
-		} else if ((buffer[0] == ':') && (in_table)) {
-			/* New chain. */
+			continue; /* ok */
+		} else if (in_table && buffer[0] == ':') { /* new chain */
 			char *policy, *chain;
 
 			chain = strtok(buffer+1, " \t\n");
 			DEBUGP("line %u, chain '%s'\n", line, chain);
-			if (!chain) {
+			if (!chain)
 				exit_error(PARAMETER_PROBLEM,
 					   "%s: line %u chain name invalid\n",
 					   program_name, line);
-				exit(1);
-			}
 
 			if (!iptc_builtin(chain, handle)) {
 				DEBUGP("Creating new chain '%s'\n", chain);
-				if (!iptc_create_chain(chain, &handle)) 
-					exit_error(PARAMETER_PROBLEM, 
+				if (!iptc_create_chain(chain, &handle))
+					exit_error(PARAMETER_PROBLEM,
 						   "error creating chain "
-						   "'%s':%s\n", chain, 
-						   strerror(errno));
+						   "'%s':%s\n", chain,
+						   iptc_strerror(errno));
 			}
 
 			policy = strtok(NULL, " \t\n");
 			DEBUGP("line %u, policy '%s'\n", line, policy);
-			if (!policy) {
+			if (!policy)
 				exit_error(PARAMETER_PROBLEM,
 					   "%s: line %u policy invalid\n",
 					   program_name, line);
-				exit(1);
-			}
 
-			if (strcmp(policy, "-") != 0) {
+			if (strcmp(policy, "-") != 0) { /* builtin chain? */
 				struct ipt_counters count;
 
 				if (counters) {
-					char *ctrs;
-					ctrs = strtok(NULL, " \t\n");
-
-					parse_counters(ctrs, &count);
-
-				} else {
-					memset(&count, 0, 
+					char *ctrs = strtok(NULL, " \t\n");
+					if (ctrs != NULL)
+						parse_counters(ctrs, &count);
+					else {
+						fprintf(stderr, "%s: Warning: no counter could be found at line %u. Assuming [0:0].\n",
+							program_name, line);
+						memset(&count, 0,
+						       sizeof(struct ipt_counters));
+					}
+				} else
+					memset(&count, 0,
 					       sizeof(struct ipt_counters));
-				}
 
 				DEBUGP("Setting policy of chain %s to %s\n",
-					chain, policy);
+				       chain, policy);
 
 				if (!iptc_set_policy(chain, policy, &count,
 						     &handle))
@@ -274,9 +269,7 @@
 						chain, policy, line,
 						iptc_strerror(errno));
 			}
-
-			ret = 1;
-
+			continue; /* ok */
 		} else if (in_table) {
 			int a;
 			char *ptr = buffer;
@@ -321,7 +314,7 @@
 			add_argv(argv[0]);
 			add_argv("-t");
 			add_argv((char *) &curtable);
-			
+
 			if (counters && pcnt && bcnt) {
 				add_argv("--set-counters");
 				add_argv((char *) pcnt);
@@ -334,13 +327,13 @@
 
 			quote_open = 0;
 			param_start = parsestart;
-			
+
 			for (curchar = parsestart; *curchar; curchar++) {
 				if (*curchar == '"') {
 					/* quote_open cannot be true if there
-					 * was no previous character.  Thus, 
+					 * was no previous character.  Thus,
 					 * curchar-1 has to be within bounds */
-					if (quote_open && 
+					if (quote_open &&
 					    *(curchar-1) != '\\') {
 						quote_open = 0;
 						*curchar = ' ';
@@ -348,7 +341,7 @@
 						quote_open = 1;
 						param_start++;
 					}
-				} 
+				}
 				if (*curchar == ' '
 				    || *curchar == '\t'
 				    || * curchar == '\n') {
@@ -363,7 +356,7 @@
 						param_start++;
 						continue;
 					}
-					
+
 					/* end of one parameter */
 					strncpy(param_buffer, param_start,
 						param_len);
@@ -371,12 +364,10 @@
 
 					/* check if table name specified */
 					if (!strncmp(param_buffer, "-t", 3)
-                                            || !strncmp(param_buffer, "--table", 8)) {
-						exit_error(PARAMETER_PROBLEM, 
+                                            || !strncmp(param_buffer, "--table", 8))
+						exit_error(PARAMETER_PROBLEM,
 						   "Line %u seems to have a "
 						   "-t table option.\n", line);
-						exit(1);
-					}
 
 					add_argv(param_buffer);
 					param_start += param_len + 1;
@@ -391,20 +382,22 @@
 			for (a = 0; a < newargc; a++)
 				DEBUGP("argv[%u]: %s\n", a, newargv[a]);
 
-			ret = do_command(newargc, newargv, 
+			ret = do_command(newargc, newargv,
 					 &newargv[2], &handle);
 
 			free_argv();
-		}
+		} else if (tablename != NULL)
+			continue;
+
 		if (!ret) {
-			fprintf(stderr, "%s: line %u failed\n",
-					program_name, line);
+			fprintf(stderr, "%s: line %u failed: %s\n",
+				program_name, line, iptc_strerror(errno));
 			exit(1);
 		}
 	}
 	if (in_table) {
 		fprintf(stderr, "%s: COMMIT expected at line %u\n",
-				program_name, line + 1);
+			program_name, line + 1);
 		exit(1);
 	}
 
diff -ruN iptables.ori/iptables-save.8 iptables.new/iptables-save.8
--- iptables.ori/iptables-save.8	2002-06-14 09:39:58.000000000 +0200
+++ iptables.new/iptables-save.8	2004-08-20 21:44:28.000000000 +0200
@@ -21,7 +21,7 @@
 .SH NAME
 iptables-save \- Save IP Tables
 .SH SYNOPSIS
-.BR "iptables-save " "[-c] [-t table]"
+.BR "iptables-save " "[-c] [-t table] [-C] [-h]"
 .br
 .SH DESCRIPTION
 .PP
@@ -30,12 +30,17 @@
 to STDOUT. Use I/O-redirection provided by your shell to write to a file.
 .TP
 \fB\-c\fR, \fB\-\-counters\fR
-include the current values of all packet and byte counters in the output
+include the current values of all packet and byte counters in the output.
 .TP
 \fB\-t\fR, \fB\-\-table\fR \fBtablename\fR
-.TP
 restrict output to only one table. If not specified, output includes all
 available tables.
+.TP
+\fB\-C\fR, \fB\-\-no-comments\fR
+do not output any comment. Useful for comparing two dump files.
+.TP
+\fB\-h\fR, \fB\-\-help\fR
+display help message.
 .SH BUGS
 None known as of iptables-1.2.1 release
 .SH AUTHOR
diff -ruN iptables.ori/iptables-save.c iptables.new/iptables-save.c
--- iptables.ori/iptables-save.c	2004-06-25 13:18:57.000000000 +0200
+++ iptables.new/iptables-save.c	2004-08-26 16:45:06.000000000 +0200
@@ -17,16 +17,6 @@
 #include "libiptc/libiptc.h"
 #include "iptables.h"
 
-static int binary = 0, counters = 0;
-
-static struct option options[] = {
-	{ "binary", 0, 0, 'b' },
-	{ "counters", 0, 0, 'c' },
-	{ "dump", 0, 0, 'd' },
-	{ "table", 1, 0, 't' },
-	{ 0 }
-};
-
 #define IP_PARTS_NATIVE(n)			\
 (unsigned int)((n)>>24)&0xFF,			\
 (unsigned int)((n)>>16)&0xFF,			\
@@ -35,11 +25,31 @@
 
 #define IP_PARTS(n) IP_PARTS_NATIVE(ntohl(n))
 
+static int counters = 0, no_comments = 0;
+
+static struct option options[] = {
+	{ "counters", 0, 0, 'c' },
+	{ "table", 1, 0, 't' },
+	{ "no-comments", 0, 0, 'C' },
+	{ "help", 0, 0, 'h' },
+	{ 0 }
+};
+
+static void
+print_usage(const char *name, const char *version) {
+	fprintf(stderr, "%s v%s\n\n"
+			"Usage: %s [-c] [-t table] [-C] [-h]\n"
+			"	   [ --counters ]\n"
+		        "	   [ --table name ]\n"
+		        "	   [ --no-comments ]\n"
+			"	   [ --help ]\n",
+		name, version, name);
+}
+
 /* This assumes that mask is contiguous, and byte-bounded. */
 static void
 print_iface(char letter, const char *iface, const unsigned char *mask,
-	    int invert)
-{
+	    int invert) {
 	unsigned int i;
 
 	if (mask[0] == 0)
@@ -52,15 +62,15 @@
 			if (iface[i] != '\0')
 				printf("%c", iface[i]);
 		} else {
-			/* we can access iface[i-1] here, because 
+			/* we can access iface[i-1] here, because
 			 * a few lines above we make sure that mask[0] != 0 */
 			if (iface[i-1] != '\0')
-				printf("+");
+				putchar('+');
 			break;
 		}
 	}
 
-	printf(" ");
+	putchar(' ');
 }
 
 /* These are hardcoded backups in iptables.c, so they are safe */
@@ -79,8 +89,8 @@
 	{ "sctp", IPPROTO_SCTP },
 };
 
-static void print_proto(u_int16_t proto, int invert)
-{
+static void
+print_proto(u_int16_t proto, int invert) {
 	if (proto) {
 		unsigned int i;
 		const char *invertstr = invert ? "! " : "";
@@ -103,8 +113,8 @@
 }
 
 #if 0
-static int non_zero(const void *ptr, size_t size)
-{
+static int
+non_zero(const void *ptr, size_t size) {
 	unsigned int i;
 
 	for (i = 0; i < size; i++)
@@ -115,9 +125,8 @@
 }
 #endif
 
-static int print_match(const struct ipt_entry_match *e,
-			const struct ipt_ip *ip)
-{
+static int
+print_match(const struct ipt_entry_match *e, const struct ipt_ip *ip) {
 	struct iptables_match *match
 		= find_match(e->u.user.name, TRY_LOAD, NULL);
 
@@ -139,8 +148,8 @@
 }
 
 /* print a given ip including mask if neccessary */
-static void print_ip(char *prefix, u_int32_t ip, u_int32_t mask, int invert)
-{
+static void
+print_ip(const char *prefix, u_int32_t ip, u_int32_t mask, int invert) {
 	if (!mask && !ip)
 		return;
 
@@ -149,30 +158,32 @@
 		invert ? "! " : "",
 		IP_PARTS(ip));
 
-	if (mask != 0xffffffff) 
+	if (mask != 0xffffffff)
 		printf("/%u.%u.%u.%u ", IP_PARTS(mask));
 	else
-		printf(" ");
+		putchar(' ');
 }
 
 /* We want this to be readable, so only print out neccessary fields.
  * Because that's the kind of world I want to live in.  */
-static void print_rule(const struct ipt_entry *e, 
-		iptc_handle_t *h, const char *chain, int counters)
-{
+static void
+print_rule(const struct ipt_entry *e, iptc_handle_t *h,
+	   const char *chain, int counters) {
 	struct ipt_entry_target *t;
 	const char *target_name;
 
 	/* print counters */
 	if (counters)
-		printf("[%llu:%llu] ", (unsigned long long)e->counters.pcnt, (unsigned long long)e->counters.bcnt);
+		printf("[%llu:%llu] ",
+		       (unsigned long long)e->counters.pcnt,
+		       (unsigned long long)e->counters.bcnt);
 
 	/* print chain name */
 	printf("-A %s ", chain);
 
 	/* Print IP part. */
 	print_ip("-s", e->ip.src.s_addr,e->ip.smsk.s_addr,
-			e->ip.invflags & IPT_INV_SRCIP);	
+			e->ip.invflags & IPT_INV_SRCIP);
 
 	print_ip("-d", e->ip.dst.s_addr, e->ip.dmsk.s_addr,
 			e->ip.invflags & IPT_INV_DSTIP);
@@ -194,7 +205,7 @@
 		IPT_MATCH_ITERATE(e, print_match, &e->ip);
 	}
 
-	/* Print target name */	
+	/* Print target name */
 	target_name = iptc_get_target(e, h);
 	if (target_name && (*target_name != '\0'))
 		printf("-j %s ", target_name);
@@ -217,7 +228,7 @@
 			/* If the target size is greater than ipt_entry_target
 			 * there is something to be saved, we just don't know
 			 * how to print it */
-			if (t->u.target_size != 
+			if (t->u.target_size !=
 			    sizeof(struct ipt_entry_target)) {
 				fprintf(stderr, "Target `%s' is missing "
 						"save function\n",
@@ -226,12 +237,11 @@
 			}
 		}
 	}
-	printf("\n");
+	putchar('\n');
 }
 
-/* Debugging prototype. */
-static int for_each_table(int (*func)(const char *tablename))
-{
+static int
+for_each_table(int (*func)(const char *tablename)) {
         int ret = 1;
 	FILE *procfile = NULL;
 	char tablename[IPT_TABLE_MAXNAMELEN+1];
@@ -242,7 +252,7 @@
 
 	while (fgets(tablename, sizeof(tablename), procfile)) {
 		if (tablename[strlen(tablename) - 1] != '\n')
-			exit_error(OTHER_PROBLEM, 
+			exit_error(OTHER_PROBLEM,
 				   "Badly formed tablename `%s'\n",
 				   tablename);
 		tablename[strlen(tablename) - 1] = '\0';
@@ -251,12 +261,12 @@
 
 	return ret;
 }
-	
 
-static int do_output(const char *tablename)
-{
+static int
+do_output(const char *tablename) {
 	iptc_handle_t h;
 	const char *chain = NULL;
+	time_t now;
 
 	if (!tablename)
 		return for_each_table(&do_output);
@@ -266,54 +276,51 @@
  		exit_error(OTHER_PROBLEM, "Can't initialize: %s\n",
 			   iptc_strerror(errno));
 
-	if (!binary) {
-		time_t now = time(NULL);
-
+	if (!no_comments) {
+		now = time(NULL);
 		printf("# Generated by iptables-save v%s on %s",
 		       IPTABLES_VERSION, ctime(&now));
-		printf("*%s\n", tablename);
+	}
+	printf("*%s\n", tablename);
 
-		/* Dump out chain names first, 
-		 * thereby preventing dependency conflicts */
-		for (chain = iptc_first_chain(&h);
-		     chain;
-		     chain = iptc_next_chain(&h)) {
-			
-			printf(":%s ", chain);
-			if (iptc_builtin(chain, h)) {
-				struct ipt_counters count;
-				printf("%s ",
-				       iptc_get_policy(chain, &count, &h));
-				printf("[%llu:%llu]\n", (unsigned long long)count.pcnt, (unsigned long long)count.bcnt);
-			} else {
-				printf("- [0:0]\n");
-			}
-		}
-				
+	/* Dump out chain names first,
+	 * thereby preventing dependency conflicts */
+	for (chain = iptc_first_chain(&h);
+	     chain;
+	     chain = iptc_next_chain(&h)) {
+		printf(":%s ", chain);
+		if (iptc_builtin(chain, h)) {
+			struct ipt_counters count;
+			printf("%s", iptc_get_policy(chain, &count, &h));
+			if (counters)
+				printf(" [%llu:%llu]",
+				       (unsigned long long)count.pcnt,
+				       (unsigned long long)count.bcnt);
+		} else
+			putchar('-');
+		putchar('\n');
+	}
 
-		for (chain = iptc_first_chain(&h);
-		     chain;
-		     chain = iptc_next_chain(&h)) {
-			const struct ipt_entry *e;
-
-			/* Dump out rules */
-			e = iptc_first_rule(chain, &h);
-			while(e) {
-				print_rule(e, &h, chain, counters);
-				e = iptc_next_rule(e, &h);
-			}
+	for (chain = iptc_first_chain(&h);
+	     chain;
+	     chain = iptc_next_chain(&h)) {
+		const struct ipt_entry *e;
+
+		/* Dump out rules */
+		e = iptc_first_rule(chain, &h);
+		while (e) {
+			print_rule(e, &h, chain, counters);
+			e = iptc_next_rule(e, &h);
 		}
+	}
 
+	puts("COMMIT");
+	if (!no_comments) {
 		now = time(NULL);
-		printf("COMMIT\n");
 		printf("# Completed on %s", ctime(&now));
-	} else {
-		/* Binary, huh?  OK. */
-		exit_error(OTHER_PROBLEM, "Binary NYI\n");
 	}
 
 	iptc_free(&h);
-
 	return 1;
 }
 
@@ -339,28 +346,28 @@
 	init_extensions();
 #endif
 
-	while ((c = getopt_long(argc, argv, "bcdt:", options, NULL)) != -1) {
+	while ((c = getopt_long(argc, argv, "ct:Ch", options, NULL)) != -1) {
 		switch (c) {
-		case 'b':
-			binary = 1;
-			break;
-
 		case 'c':
 			counters = 1;
 			break;
-
-		case 't':
-			/* Select specific table. */
+		case 't': /* Select specific table. */
 			tablename = optarg;
 			break;
-		case 'd':
-			do_output(tablename);
+		case 'C':
+			no_comments = 1;
+			break;
+		case 'h':
+			print_usage(program_name, IPTABLES_VERSION);
 			exit(0);
+		case '?':
+			exit_tryhelp(PARAMETER_PROBLEM);
 		}
 	}
 
 	if (optind < argc) {
-		fprintf(stderr, "Unknown arguments found on commandline");
+		fprintf(stderr, "%s: unknown arguments found on commandline\n",
+			program_name);
 		exit(1);
 	}
 
diff -ruN iptables.ori/iptables.8.in iptables.new/iptables.8.in
--- iptables.ori/iptables.8.in	2004-07-08 19:14:35.000000000 +0200
+++ iptables.new/iptables.8.in	2004-08-27 03:11:36.000000000 +0200
@@ -280,7 +280,7 @@
 .TP
 .BR "-i, --in-interface " "[!] \fIname\fP"
 Name of an interface via which a packet was received (only for
-packets entering the 
+packets entering the
 .BR INPUT ,
 .B FORWARD
 and
@@ -354,6 +354,13 @@
 When adding or inserting rules into a chain, use
 .B command
 to load any necessary modules (targets, match extensions, etc).
+.TP
+.B "-S, --simulate"
+simulate the restoration, do not commit ruleset changes to the kernel.
+Yet, this is not a pure virtual simulation, as it may have the side
+effect of loading iptable_* kernel modules and their possible
+dependencies, notably ip_conntrack, which can lead to performance
+issues after the simulation.
 .SH MATCH EXTENSIONS
 iptables can use extended packet matching modules.  These are loaded
 in two ways: implicitly, when
diff -ruN iptables.ori/iptables.c iptables.new/iptables.c
--- iptables.ori/iptables.c	2004-07-08 14:54:48.000000000 +0200
+++ iptables.new/iptables.c	2004-08-26 15:50:55.000000000 +0200
@@ -138,14 +138,15 @@
 	{ "line-numbers", 0, 0, '0' },
 	{ "modprobe", 1, 0, 'M' },
 	{ "set-counters", 1, 0, 'c' },
+	{ "simulate", 0, 0, 'S' },
 	{ 0 }
 };
 
 /* we need this for iptables-restore.  iptables-restore.c sets line to the
  * current line of the input file, in order  to give a more precise error
  * message.  iptables itself doesn't need this, so it is initialized to the
- * magic number of -1 */
-int line = -1;
+ * magic number of 0 */
+int line = 0;
 
 #ifndef __OPTIMIZE__
 struct ipt_entry_target *
@@ -338,7 +339,7 @@
 void
 exit_tryhelp(int status)
 {
-	if (line != -1)
+	if (line != 0)
 		fprintf(stderr, "Error occurred at line: %d\n", line);
 	fprintf(stderr, "Try `%s -h' or '%s --help' for more information.\n",
 			program_name, program_name );
@@ -352,17 +353,19 @@
 	struct iptables_target *t = NULL;
 
 	printf("%s v%s\n\n"
-"Usage: %s -[AD] chain rule-specification [options]\n"
-"       %s -[RI] chain rulenum rule-specification [options]\n"
-"       %s -D chain rulenum [options]\n"
-"       %s -[LFZ] [chain] [options]\n"
-"       %s -[NX] chain\n"
-"       %s -E old-chain-name new-chain-name\n"
-"       %s -P chain target [options]\n"
+"Usage: %s [-t table] -[AD] chain rule-specification [options]\n"
+"       %s [-t table] -I chain [rulenum] rule-specification [options]\n"
+"       %s [-t table] -R chain rulenum rule-specification [options]\n"
+"       %s [-t table] -D chain rulenum [options]\n"
+"       %s [-t table] -[LFZ] [chain] [options]\n"
+"       %s [-t table] -N chain\n"
+"       %s [-t table] -X [chain]\n"
+"       %s [-t table] -P chain target [options]\n"
+"       %s [-t table] -E old-chain-name new-chain-name\n"
 "       %s -h (print this help information)\n\n",
 	       program_name, program_version, program_name, program_name,
 	       program_name, program_name, program_name, program_name,
-	       program_name, program_name);
+	       program_name, program_name, program_name, program_name);
 
 	printf(
 "Commands:\n"
@@ -403,12 +406,14 @@
 "  --out-interface -o [!] output name[+]\n"
 "				network interface name ([+] for wildcard)\n"
 "  --table	-t table	table to manipulate (default: `filter')\n"
-"  --verbose	-v		verbose mode\n"
 "  --line-numbers		print line numbers when listing\n"
 "  --exact	-x		expand numbers (display exact values)\n"
 "[!] --fragment	-f		match second or further fragments only\n"
-"  --modprobe=<command>		try to insert modules using this command\n"
 "  --set-counters PKTS BYTES	set the counter during insert/append\n"
+
+"  --verbose	-v		verbose mode\n"
+"  --simulate	-S		simulate the restoration (no kernel commit)\n"
+"  --modprobe=<command>		try to insert modules using this command\n"
 "[!] --version	-V		print package version.\n");
 
 	/* Print out any special helps. A user might like to be able
@@ -416,12 +421,12 @@
 	   results. So we call help for all specified matches & targets */
 	for (t = iptables_targets; t ;t = t->next) {
 		if (t->used) {
-			printf("\n");
+			putchar('\n');
 			t->help();
 		}
 	}
 	for (matchp = matches; matchp; matchp = matchp->next) {
-		printf("\n");
+		putchar('\n');
 		matchp->match->help();
 	}
 	exit(0);
@@ -664,7 +669,8 @@
 }
 
 struct iptables_match *
-find_match(const char *name, enum ipt_tryload tryload, struct iptables_rule_match **matches)
+find_match(const char *name, enum ipt_tryload tryload,
+	   struct iptables_rule_match **matches)
 {
 	struct iptables_match *ptr;
 
@@ -722,7 +728,8 @@
 
 /* Christophe Burki wants `-p 6' to imply `-m tcp'.  */
 static struct iptables_match *
-find_proto(const char *pname, enum ipt_tryload tryload, int nolookup, struct iptables_rule_match **matches)
+find_proto(const char *pname, enum ipt_tryload tryload, int nolookup,
+	   struct iptables_rule_match **matches)
 {
 	unsigned int proto;
 
@@ -901,8 +908,8 @@
 }
 
 int
-string_to_number_ll(const char *s, unsigned long long min, unsigned long long max,
-		 unsigned long long *ret)
+string_to_number_ll(const char *s, unsigned long long min,
+		    unsigned long long max, unsigned long long *ret)
 {
 	unsigned long long number;
 	char *end;
@@ -922,7 +929,7 @@
 
 int
 string_to_number_l(const char *s, unsigned long min, unsigned long max,
-		 unsigned long *ret)
+		   unsigned long *ret)
 {
 	int result;
 	unsigned long long number;
@@ -934,7 +941,7 @@
 }
 
 int string_to_number(const char *s, unsigned int min, unsigned int max,
-		unsigned int *ret)
+		     unsigned int *ret)
 {
 	int result;
 	unsigned long number;
@@ -1177,13 +1184,12 @@
 	}
 	printf(FMT(" %-19s ","%s "), "source");
 	printf(FMT(" %-19s "," %s "), "destination");
-	printf("\n");
+	putchar('\n');
 }
 
 
 static int
-print_match(const struct ipt_entry_match *m,
-	    const struct ipt_ip *ip,
+print_match(const struct ipt_entry_match *m, const struct ipt_ip *ip,
 	    int numeric)
 {
 	struct iptables_match *match = find_match(m->u.user.name, TRY_LOAD, NULL);
@@ -1322,8 +1328,7 @@
 }
 
 static void
-print_firewall_line(const struct ipt_entry *fw,
-		    const iptc_handle_t h)
+print_firewall_line(const struct ipt_entry *fw, const iptc_handle_t h)
 {
 	struct ipt_entry_target *t;
 
@@ -1411,7 +1416,8 @@
 
 	size = sizeof(struct ipt_entry);
 	for (matchp = matches; matchp; matchp = matchp->next)
-		size += IPT_ALIGN(sizeof(struct ipt_entry_match)) + matchp->match->size;
+		size += IPT_ALIGN(sizeof(struct ipt_entry_match))
+		  + matchp->match->size;
 
 	mask = fw_calloc(1, size
 			 + IPT_ALIGN(sizeof(struct ipt_entry_target))
@@ -1424,7 +1430,8 @@
 		memset(mptr, 0xFF,
 		       IPT_ALIGN(sizeof(struct ipt_entry_match))
 		       + matchp->match->userspacesize);
-		mptr += IPT_ALIGN(sizeof(struct ipt_entry_match)) + matchp->match->size;
+		mptr += IPT_ALIGN(sizeof(struct ipt_entry_match))
+		  + matchp->match->size;
 	}
 
 	memset(mptr, 0xFF,
@@ -1501,8 +1508,7 @@
 }
 
 int
-flush_entries(const ipt_chainlabel chain, int verbose,
-	      iptc_handle_t *handle)
+flush_entries(const ipt_chainlabel chain, int verbose, iptc_handle_t *handle)
 {
 	if (!chain)
 		return for_each_chain(flush_entries, verbose, 1, handle);
@@ -1513,8 +1519,7 @@
 }
 
 static int
-zero_entries(const ipt_chainlabel chain, int verbose,
-	     iptc_handle_t *handle)
+zero_entries(const ipt_chainlabel chain, int verbose, iptc_handle_t *handle)
 {
 	if (!chain)
 		return for_each_chain(zero_entries, verbose, 1, handle);
@@ -1525,8 +1530,7 @@
 }
 
 int
-delete_chain(const ipt_chainlabel chain, int verbose,
-	     iptc_handle_t *handle)
+delete_chain(const ipt_chainlabel chain, int verbose, iptc_handle_t *handle)
 {
 	if (!chain)
 		return for_each_chain(delete_chain, verbose, 0, handle);
@@ -1568,7 +1572,7 @@
 		if (chain && strcmp(chain, this) != 0)
 			continue;
 
-		if (found) printf("\n");
+		if (found) putchar('\n');
 
 		print_header(format, this, handle);
 		i = iptc_first_rule(this, handle);
@@ -1698,7 +1702,7 @@
 	unsigned int nsaddrs = 0, ndaddrs = 0;
 	struct in_addr *saddrs = NULL, *daddrs = NULL;
 
-	int c, verbose = 0;
+	int c, verbose = 0, simulate = 0;
 	const char *chain = NULL;
 	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
 	const char *policy = NULL, *newname = NULL;
@@ -1736,7 +1740,7 @@
 	opterr = 0;
 
 	while ((c = getopt_long(argc, argv,
-	   "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:",
+	   "-A:D:R:I:L::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fvnt:m:xc:S",
 					   opts, NULL)) != -1) {
 		switch (c) {
 			/*
@@ -1924,7 +1928,8 @@
 				target->t->u.target_size = size;
 				strcpy(target->t->u.user.name, jumpto);
 				target->init(target->t, &fw.nfcache);
-				opts = merge_options(opts, target->extra_opts, &target->option_offset);
+				opts = merge_options(opts, target->extra_opts,
+						     &target->option_offset);
 			}
 			break;
 
@@ -2040,6 +2045,9 @@
 			
 			break;
 
+		case 'S':
+			simulate = 1;
+			break;
 
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
@@ -2197,6 +2205,9 @@
 			   "can't initialize iptables table `%s': %s",
 			   *table, iptc_strerror(errno));
 
+	if (simulate)
+		iptc_set_nocommit(handle);
+
 	if (command == CMD_APPEND
 	    || command == CMD_DELETE
 	    || command == CMD_INSERT
diff -ruN iptables.ori/libiptc/libip4tc.c iptables.new/libiptc/libip4tc.c
--- iptables.ori/libiptc/libip4tc.c	2004-05-26 18:04:49.000000000 +0200
+++ iptables.new/libiptc/libip4tc.c	2004-08-13 12:27:33.000000000 +0200
@@ -92,6 +92,7 @@
 #define TC_GET_RAW_SOCKET	iptc_get_raw_socket
 #define TC_INIT			iptc_init
 #define TC_FREE			iptc_free
+#define TC_SET_NOCOMMIT		iptc_set_nocommit
 #define TC_COMMIT		iptc_commit
 #define TC_STRERROR		iptc_strerror
 
diff -ruN iptables.ori/libiptc/libip6tc.c iptables.new/libiptc/libip6tc.c
--- iptables.ori/libiptc/libip6tc.c	2004-05-26 18:04:49.000000000 +0200
+++ iptables.new/libiptc/libip6tc.c	2004-08-13 12:28:25.000000000 +0200
@@ -87,6 +87,7 @@
 #define TC_GET_RAW_SOCKET	ip6tc_get_raw_socket
 #define TC_INIT			ip6tc_init
 #define TC_FREE			ip6tc_free
+#define TC_SET_NOCOMMIT		ip6tc_set_nocommit
 #define TC_COMMIT		ip6tc_commit
 #define TC_STRERROR		ip6tc_strerror
 
diff -ruN iptables.ori/libiptc/libiptc.c iptables.new/libiptc/libiptc.c
--- iptables.ori/libiptc/libiptc.c	2004-05-26 18:04:49.000000000 +0200
+++ iptables.new/libiptc/libiptc.c	2004-08-13 12:26:21.000000000 +0200
@@ -78,6 +78,8 @@
 
 STRUCT_TC_HANDLE
 {
+	/* Do not commit anything to the kernel if this flag is set. */
+	int nocommit;
 	/* Have changes been made? */
 	int changed;
 	/* Size in here reflects original state. */
@@ -109,6 +111,12 @@
 	h->changed = 1;
 }
 
+void
+TC_SET_NOCOMMIT(TC_HANDLE_T *h)
+{
+	(*h)->nocommit = 1;
+}
+
 #ifdef IPTC_DEBUG
 static void do_check(TC_HANDLE_T h, unsigned int line);
 #define CHECK(h) do { if (!getenv("IPTC_NO_CHECK")) do_check((h), __LINE__); } while(0)
@@ -230,6 +238,7 @@
 	}
 
 	h->changed = 0;
+	h->nocommit = 0;
 	h->cache_num_chains = 0;
 	h->cache_chain_heads = NULL;
 	h->counter_map = (void *)h
@@ -854,6 +863,7 @@
 	if (!newh)
 		return 0;
 	newh->info = newinfo;
+	newh->nocommit = (*handle)->nocommit;
 
 	/* Copy pre... */
 	memcpy(newh->entries.entrytable, (*handle)->entries.entrytable,offset);
@@ -1732,17 +1742,17 @@
 
 	CHECK(*handle);
 
-	counterlen = sizeof(STRUCT_COUNTERS_INFO)
-			+ sizeof(STRUCT_COUNTERS) * (*handle)->new_number;
-
 #if 0
 	TC_DUMP_ENTRIES(*handle);
 #endif
 
-	/* Don't commit if nothing changed. */
-	if (!(*handle)->changed)
+	/* Don't commit if nothing changed or if we are is nocommit mode. */
+	if (!(*handle)->changed || (*handle)->nocommit)
 		goto finished;
 
+	counterlen = sizeof(STRUCT_COUNTERS_INFO)
+			+ sizeof(STRUCT_COUNTERS) * (*handle)->new_number;
+
 	repl = malloc(sizeof(*repl) + (*handle)->entries.size);
 	if (!repl) {
 		errno = ENOMEM;

--Rgf3q3z9SdmXC6oT--
