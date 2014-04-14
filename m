From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 2/5] nft: xtables-restore: add generic parsing infrastructure
Date: Mon, 14 Apr 2014 12:41:03 +0200
Message-ID: <1397472066-13011-3-git-send-email-pablo@netfilter.org>
References: <1397472066-13011-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45234 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754459AbaDNKlR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:41:17 -0400
In-Reply-To: <1397472066-13011-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This allows us to reuse the xtables-restore parser code in the
translation infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-shared.h      |   35 ++++++
 iptables/xtables-restore.c |  271 ++++++++++++++++++++++++++------------------
 2 files changed, 195 insertions(+), 111 deletions(-)

diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index d4bc31e..584cd5f 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -190,6 +190,41 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 	      struct nft_xt_cmd_parse *p, struct iptables_command_state *cs,
 	      struct xtables_args *args);
 
+struct nft_xt_restore_parse {
+	FILE		*in;
+	int		testing;
+	const char	*tablename;
+};
+
+struct nft_chain_list;
+
+struct nft_xt_restore_cb {
+	void (*table_new)(struct nft_handle *h, const char *table);
+	struct nft_chain_list *(*chain_list)(struct nft_handle *h);
+	int (*chains_purge)(struct nft_handle *h, const char *table,
+			    struct nft_chain_list *clist);
+	void (*chain_del)(struct nft_chain_list *clist, const char *curtable,
+			  const char *chain);
+	int (*chain_set)(struct nft_handle *h, const char *table,
+			 const char *chain, const char *policy,
+			 const struct xt_counters *counters);
+	int (*chain_user_add)(struct nft_handle *h, const char *chain,
+			      const char *table);
+
+	int (*rule_flush)(struct nft_handle *h, const char *chain, const char *table);
+
+	int (*do_command)(struct nft_handle *h, int argc, char *argv[],
+			  char **table, bool restore);
+
+	int (*commit)(struct nft_handle *h);
+	int (*abort)(struct nft_handle *h);
+};
+
+void xtables_restore_parse(struct nft_handle *h,
+			   struct nft_xt_restore_parse *p,
+			   struct nft_xt_restore_cb *cb,
+			   int argc, char *argv[]);
+
 /*
  * ARP
  */
diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
index 3cb095f..f5e4553 100644
--- a/iptables/xtables-restore.c
+++ b/iptables/xtables-restore.c
@@ -159,107 +159,62 @@ static void add_param_to_argv(char *parsestart)
 	}
 }
 
+static struct nft_chain_list *get_chain_list(struct nft_handle *h)
+{
+	struct nft_chain_list *chain_list;
+
+	chain_list = nft_chain_dump(h);
+	if (chain_list == NULL)
+		xtables_error(OTHER_PROBLEM, "cannot retrieve chain list\n");
+
+	return chain_list;
+}
+
+static void chain_delete(struct nft_chain_list *clist, const char *curtable,
+			 const char *chain)
+{
+	struct nft_chain *chain_obj;
+
+	chain_obj = nft_chain_list_find(clist, curtable, chain);
+	/* This chain has been found, delete from list. Later
+	 * on, unvisited chains will be purged out.
+	 */
+	if (chain_obj != NULL)
+		nft_chain_list_del(chain_obj);
+}
+
+struct nft_xt_restore_cb restore_cb = {
+	.chain_list	= get_chain_list,
+	.commit		= nft_commit,
+	.abort		= nft_abort,
+	.chains_purge	= nft_table_purge_chains,
+	.rule_flush	= nft_rule_flush,
+	.chain_del	= chain_delete,
+	.do_command	= do_commandx,
+	.chain_set	= nft_chain_set,
+	.chain_user_add	= nft_chain_user_add,
+};
+
 static const struct xtc_ops xtc_ops = {
 	.strerror	= nft_strerror,
 };
 
-static int
-xtables_restore_main(int family, const char *progname, int argc, char *argv[])
+void xtables_restore_parse(struct nft_handle *h,
+			   struct nft_xt_restore_parse *p,
+			   struct nft_xt_restore_cb *cb,
+			   int argc, char *argv[])
 {
-	struct nft_handle h = {
-		.family = family,
-		.restore = true,
-	};
 	char buffer[10240];
-	int c;
+	int in_table = 0;
 	char curtable[XT_TABLE_MAXNAMELEN + 1];
-	FILE *in;
-	int in_table = 0, testing = 0;
-	const char *tablename = NULL;
 	const struct xtc_ops *ops = &xtc_ops;
-	struct nft_chain_list *chain_list;
-	struct nft_chain *chain_obj;
-
-	line = 0;
-
-	xtables_globals.program_name = progname;
-	c = xtables_init_all(&xtables_globals, family);
-	if (c < 0) {
-		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
-				xtables_globals.program_name,
-				xtables_globals.program_version);
-		exit(1);
-	}
-#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
-	init_extensions();
-	init_extensions4();
-#endif
-
-	if (nft_init(&h, xtables_ipv4) < 0) {
-		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
-				xtables_globals.program_name,
-				xtables_globals.program_version,
-				strerror(errno));
-		exit(EXIT_FAILURE);
-	}
+	struct nft_chain_list *chain_list = NULL;
 
-	while ((c = getopt_long(argc, argv, "bcvthnM:T:46", options, NULL)) != -1) {
-		switch (c) {
-			case 'b':
-				fprintf(stderr, "-b/--binary option is not implemented\n");
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
-				print_usage("xtables-restore",
-					    IPTABLES_VERSION);
-				break;
-			case 'n':
-				noflush = 1;
-				break;
-			case 'M':
-				xtables_modprobe_program = optarg;
-				break;
-			case 'T':
-				tablename = optarg;
-				break;
-			case '4':
-				h.family = AF_INET;
-				break;
-			case '6':
-				h.family = AF_INET6;
-				xtables_set_nfproto(AF_INET6);
-				break;
-		}
-	}
-
-	if (optind == argc - 1) {
-		in = fopen(argv[optind], "re");
-		if (!in) {
-			fprintf(stderr, "Can't open %s: %s\n", argv[optind],
-				strerror(errno));
-			exit(1);
-		}
-	}
-	else if (optind < argc) {
-		fprintf(stderr, "Unknown arguments found on commandline\n");
-		exit(1);
-	}
-	else in = stdin;
-
-	chain_list = nft_chain_dump(&h);
-	if (chain_list == NULL)
-		xtables_error(OTHER_PROBLEM, "cannot retrieve chain list\n");
+	if (cb->chain_list)
+		chain_list = cb->chain_list(h);
 
 	/* Grab standard input. */
-	while (fgets(buffer, sizeof(buffer), in)) {
+	while (fgets(buffer, sizeof(buffer), p->in)) {
 		int ret = 0;
 
 		line++;
@@ -270,22 +225,24 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 				fputs(buffer, stdout);
 			continue;
 		} else if ((strcmp(buffer, "COMMIT\n") == 0) && (in_table)) {
-			if (!testing) {
+			if (!p->testing) {
 				/* Commit per table, although we support
 				 * global commit at once, stick by now to
 				 * the existing behaviour.
 				 */
 				DEBUGP("Calling commit\n");
-				ret = nft_commit(&h);
+				if (cb->commit)
+					ret = cb->commit(h);
 			} else {
 				DEBUGP("Not calling commit, testing\n");
-				ret = nft_abort(&h);
+				if (cb->abort)
+					ret = cb->abort(h);
 			}
 			in_table = 0;
 
 			/* Purge out unused chains in this table */
-			if (!testing)
-				nft_table_purge_chains(&h, curtable, chain_list);
+			if (!p->testing && cb->chains_purge)
+				cb->chains_purge(h, curtable, chain_list);
 
 		} else if ((buffer[0] == '*') && (!in_table)) {
 			/* New table */
@@ -302,18 +259,22 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 			strncpy(curtable, table, XT_TABLE_MAXNAMELEN);
 			curtable[XT_TABLE_MAXNAMELEN] = '\0';
 
-			if (tablename && (strcmp(tablename, table) != 0))
+			if (p->tablename && (strcmp(p->tablename, table) != 0))
 				continue;
 
 			if (noflush == 0) {
 				DEBUGP("Cleaning all chains of table '%s'\n",
 					table);
-				nft_rule_flush(&h, NULL, table);
+				if (cb->rule_flush)
+					cb->rule_flush(h, NULL, table);
 			}
 
 			ret = 1;
 			in_table = 1;
 
+			if (cb->table_new)
+				cb->table_new(h, table);
+
 		} else if ((buffer[0] == ':') && (in_table)) {
 			/* New chain. */
 			char *policy, *chain = NULL;
@@ -328,13 +289,8 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 				exit(1);
 			}
 
-			chain_obj = nft_chain_list_find(chain_list,
-							curtable, chain);
-			/* This chain has been found, delete from list. Later
-			 * on, unvisited chains will be purged out.
-			 */
-			if (chain_obj != NULL)
-				nft_chain_list_del(chain_obj);
+			if (cb->chain_del)
+				cb->chain_del(chain_list, curtable, chain);
 
 			if (strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
 				xtables_error(PARAMETER_PROBLEM,
@@ -362,7 +318,8 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 							   "for chain '%s'\n", chain);
 
 				}
-				if (nft_chain_set(&h, curtable, chain, policy, &count) < 0) {
+				if (cb->chain_set &&
+				    cb->chain_set(h, curtable, chain, policy, &count) < 0) {
 					xtables_error(OTHER_PROBLEM,
 						      "Can't set policy `%s'"
 						      " on `%s' line %u: %s\n",
@@ -374,7 +331,8 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 				ret = 1;
 
 			} else {
-				if (nft_chain_user_add(&h, chain, curtable) < 0) {
+				if (cb->chain_user_add &&
+				    cb->chain_user_add(h, chain, curtable) < 0) {
 					if (errno == EEXIST)
 						continue;
 
@@ -441,10 +399,14 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 			for (a = 0; a < newargc; a++)
 				DEBUGP("argv[%u]: %s\n", a, newargv[a]);
 
-			ret = do_commandx(&h, newargc, newargv,
-					  &newargv[2], true);
+			ret = cb->do_command(h, newargc, newargv,
+					    &newargv[2], true);
 			if (ret < 0) {
-				ret = nft_abort(&h);
+				if (cb->abort)
+					ret = cb->abort(h);
+				else
+					ret = 0;
+
 				if (ret < 0) {
 					fprintf(stderr, "failed to abort "
 							"commit operation\n");
@@ -455,7 +417,7 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 			free_argv();
 			fflush(stdout);
 		}
-		if (tablename && (strcmp(tablename, curtable) != 0))
+		if (p->tablename && (strcmp(p->tablename, curtable) != 0))
 			continue;
 		if (!ret) {
 			fprintf(stderr, "%s: line %u failed\n",
@@ -468,8 +430,95 @@ xtables_restore_main(int family, const char *progname, int argc, char *argv[])
 				xt_params->program_name, line + 1);
 		exit(1);
 	}
+}
+
+static int
+xtables_restore_main(int family, const char *progname, int argc, char *argv[])
+{
+	struct nft_handle h = {
+		.family = family,
+		.restore = true,
+	};
+	int c;
+	struct nft_xt_restore_parse p = {};
+
+	line = 0;
+
+	xtables_globals.program_name = progname;
+	c = xtables_init_all(&xtables_globals, family);
+	if (c < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize xtables\n",
+				xtables_globals.program_name,
+				xtables_globals.program_version);
+		exit(1);
+	}
+#if defined(ALL_INCLUSIVE) || defined(NO_SHARED_LIBS)
+	init_extensions();
+	init_extensions4();
+#endif
+
+	if (nft_init(&h, xtables_ipv4) < 0) {
+		fprintf(stderr, "%s/%s Failed to initialize nft: %s\n",
+				xtables_globals.program_name,
+				xtables_globals.program_version,
+				strerror(errno));
+		exit(EXIT_FAILURE);
+	}
+
+	while ((c = getopt_long(argc, argv, "bcvthnM:T:46", options, NULL)) != -1) {
+		switch (c) {
+			case 'b':
+				fprintf(stderr, "-b/--binary option is not implemented\n");
+				break;
+			case 'c':
+				counters = 1;
+				break;
+			case 'v':
+				verbose = 1;
+				break;
+			case 't':
+				p.testing = 1;
+				break;
+			case 'h':
+				print_usage("xtables-restore",
+					    IPTABLES_VERSION);
+				break;
+			case 'n':
+				noflush = 1;
+				break;
+			case 'M':
+				xtables_modprobe_program = optarg;
+				break;
+			case 'T':
+				p.tablename = optarg;
+				break;
+			case '4':
+				h.family = AF_INET;
+				break;
+			case '6':
+				h.family = AF_INET6;
+				xtables_set_nfproto(AF_INET6);
+				break;
+		}
+	}
+
+	if (optind == argc - 1) {
+		p.in = fopen(argv[optind], "re");
+		if (!p.in) {
+			fprintf(stderr, "Can't open %s: %s\n", argv[optind],
+				strerror(errno));
+			exit(1);
+		}
+	} else if (optind < argc) {
+		fprintf(stderr, "Unknown arguments found on commandline\n");
+		exit(1);
+	} else {
+		p.in = stdin;
+	}
+
+	xtables_restore_parse(&h, &p, &restore_cb, argc, argv);
 
-	fclose(in);
+	fclose(p.in);
 	return 0;
 }
 
-- 
1.7.10.4

