From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [iptables PATCH] ebtables-compat: parser cleanups
Date: Thu, 12 Feb 2015 11:44:08 +0100
Message-ID: <20150212104408.27161.96322.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:46611 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753387AbbBLKoU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2015 05:44:20 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Kill:
 * commented code in the parser
 * ebtables daemon stuff
 * ebtables 'atomic' operations

We can bring back the code later and get in shape if required.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 iptables/xtables-eb.c |  167 ++-----------------------------------------------
 1 file changed, 7 insertions(+), 160 deletions(-)

diff --git a/iptables/xtables-eb.c b/iptables/xtables-eb.c
index efbb3cd..632a3a0 100644
--- a/iptables/xtables-eb.c
+++ b/iptables/xtables-eb.c
@@ -282,12 +282,6 @@ static struct option ebt_original_options[] =
 	{ "new-chain"      , required_argument, 0, 'N' },
 	{ "rename-chain"   , required_argument, 0, 'E' },
 	{ "delete-chain"   , optional_argument, 0, 'X' },
-	{ "atomic-init"    , no_argument      , 0, 7   },
-	{ "atomic-commit"  , no_argument      , 0, 8   },
-	{ "atomic-file"    , required_argument, 0, 9   },
-	{ "atomic-save"    , no_argument      , 0, 10  },
-	{ "init-table"     , no_argument      , 0, 11  },
-	{ "concurrent"     , no_argument      , 0, 13  },
 	{ 0 }
 };
 
@@ -425,10 +419,6 @@ static void print_help(const struct xtables_target *t,
 "--new-chain -N chain          : create a user defined chain\n"
 "--rename-chain -E old new     : rename a chain\n"
 "--delete-chain -X [chain]     : delete a user defined chain\n"
-"--atomic-commit               : update the kernel w/t table contained in <FILE>\n"
-"--atomic-init                 : put the initial kernel table into <FILE>\n"
-"--atomic-save                 : put the current kernel table into <FILE>\n"
-"--atomic-file file            : set <FILE> to file\n\n"
 "Options:\n"
 "--proto  -p [!] proto         : protocol hexadecimal, by name or LENGTH\n"
 "--src    -s [!] address[/mask]: source mac address\n"
@@ -440,10 +430,7 @@ static void print_help(const struct xtables_target *t,
 "--set-counters -c chain\n"
 "          pcnt bcnt           : set the counters of the to be added rule\n"
 "--modprobe -M program         : try to insert modules using this program\n"
-"--concurrent                  : use a file lock to support concurrent scripts\n"
 "--version -V                  : print package version\n\n"
-"Environment variable:\n"
-/*ATOMIC_ENV_VARIABLE "          : if set <FILE> (see above) will equal its value"*/
 "\n\n");
 	for (; m != NULL; m = m->next) {
 		printf("\n");
@@ -453,9 +440,6 @@ static void print_help(const struct xtables_target *t,
 		printf("\n");
 		t->help();
 	}
-
-//	if (table->help)
-//		table->help(ebt_hooknames);
 }
 
 /* Execute command L */
@@ -791,10 +775,6 @@ int do_commandeb(struct nft_handle *h, int argc, char *argv[], char **table)
 			chain = optarg;
 			selected_chain = get_current_chain(chain);
 			flags |= OPT_COMMAND;
-			/*if (!(replace->flags & OPT_KERNELDATA))
-				ebt_get_kernel_table(replace, 0);*/
-			/*if (optarg && (optarg[0] == '-' || !strcmp(optarg, "!")))
-				ebt_print_error2("No chain name specified");*/
 			if (c == 'N') {
 				ret = nft_chain_user_add(h, chain, *table);
 				break;
@@ -876,27 +856,6 @@ print_zero:
 				if (flags & OPT_ZERO && c != 'L')
 					goto print_zero;
 			}
-
-#ifdef SILENT_DAEMON
-			if (c== 'L' && exec_style == EXEC_STYLE_DAEMON)
-				xtables_error(PARAMETER_PROBLEM,
-					      "-L not supported in daemon mode");
-#endif
-
-			/*if (!(replace->flags & OPT_KERNELDATA))
-				ebt_get_kernel_table(replace, 0);
-			i = -1;
-			if (optind < argc && argv[optind][0] != '-') {
-				if ((i = ebt_get_chainnr(replace, argv[optind])) == -1)
-					ebt_print_error2("Chain '%s' doesn't exist", argv[optind]);
-				optind++;
-			}
-			if (i != -1) {
-				if (c == 'Z')
-					zerochain = i;
-				else
-					replace->selected_chain = i;
-			}*/
 			break;
 		case 'V': /* Version */
 			if (OPT_COMMANDS)
@@ -909,11 +868,6 @@ print_zero:
 			printf("%s %s\n", prog_name, prog_vers);
 			exit(0);
 		case 'h': /* Help */
-#ifdef SILENT_DAEMON
-			if (exec_style == EXEC_STYLE_DAEMON)
-				xtables_error(PARAMETER_PROBLEM,
-					      "-h not supported in daemon mode");
-#endif
 			if (OPT_COMMANDS)
 				xtables_error(PARAMETER_PROBLEM,
 					      "Multiple commands are not allowed");
@@ -921,25 +875,16 @@ print_zero:
 
 			/* All other arguments should be extension names */
 			while (optind < argc) {
-				/*struct ebt_u_match *m;
-				struct ebt_u_watcher *w;*/
-
 				if (!strcasecmp("list_extensions", argv[optind])) {
 					ebt_list_extensions(xtables_targets, cs.matches);
 					exit(0);
 				}
-				/*if ((m = ebt_find_match(argv[optind])))
-					ebt_add_match(new_entry, m);
-				else if ((w = ebt_find_watcher(argv[optind])))
-					ebt_add_watcher(new_entry, w);
-				else {*/
-					if (!(t = xtables_find_target(argv[optind], XTF_TRY_LOAD)))
-						xtables_error(PARAMETER_PROBLEM,"Extension '%s' not found", argv[optind]);
-					if (flags & OPT_JUMP)
-						xtables_error(PARAMETER_PROBLEM,"Sorry, you can only see help for one target extension at a time");
-					flags |= OPT_JUMP;
-					cs.target = t;
-				//}
+				if (!(t = xtables_find_target(argv[optind], XTF_TRY_LOAD)))
+					xtables_error(PARAMETER_PROBLEM,"Extension '%s' not found", argv[optind]);
+				if (flags & OPT_JUMP)
+					xtables_error(PARAMETER_PROBLEM,"Sorry, you can only see help for one target extension at a time");
+				flags |= OPT_JUMP;
+				cs.target = t;
 				optind++;
 			}
 			break;
@@ -1152,65 +1097,6 @@ big_iface_length:
 					       "Use --Lmac2 with -L");
 			flags |= LIST_MAC2;
 			break;
-		case 8 : /* atomic-commit */
-/*			if (exec_style == EXEC_STYLE_DAEMON)
-				ebt_print_error2("--atomic-commit is not supported in daemon mode");
-			replace->command = c;
-			if (OPT_COMMANDS)
-				ebt_print_error2("Multiple commands are not allowed");
-			replace->flags |= OPT_COMMAND;
-			if (!replace->filename)
-				ebt_print_error2("No atomic file specified");*/
-			/* Get the information from the file */
-			/*ebt_get_table(replace, 0);*/
-			/* We don't want the kernel giving us its counters,
-			 * they would overwrite the counters extracted from
-			 * the file */
-			/*replace->num_counters = 0;*/
-			/* Make sure the table will be written to the kernel */
-			/*free(replace->filename);
-			replace->filename = NULL;
-			break;*/
-		/*case 7 :*/ /* atomic-init */
-		/*case 10:*/ /* atomic-save */
-		/*case 11:*/ /* init-table */
-		/*	if (exec_style == EXEC_STYLE_DAEMON) {
-				if (c == 7) {
-					ebt_print_error2("--atomic-init is not supported in daemon mode");
-				} else if (c == 10)
-					ebt_print_error2("--atomic-save is not supported in daemon mode");
-				ebt_print_error2("--init-table is not supported in daemon mode");
-			}
-			replace->command = c;
-			if (OPT_COMMANDS)
-				ebt_print_error2("Multiple commands are not allowed");
-			if (c != 11 && !replace->filename)
-				ebt_print_error2("No atomic file specified");
-			replace->flags |= OPT_COMMAND;
-			{
-				char *tmp = replace->filename;*/
-
-				/* Get the kernel table */
-				/*replace->filename = NULL;
-				ebt_get_kernel_table(replace, c == 10 ? 0 : 1);
-				replace->filename = tmp;
-			}
-			break;
-		case 9 :*/ /* atomic */
-			/*if (exec_style == EXEC_STYLE_DAEMON)
-				ebt_print_error2("--atomic is not supported in daemon mode");
-			if (OPT_COMMANDS)
-				ebt_print_error2("--atomic has to come before the command");*/
-			/* A possible memory leak here, but this is not
-			 * executed in daemon mode */
-			/*replace->filename = (char *)malloc(strlen(optarg) + 1);
-			strcpy(replace->filename, optarg);
-			break;
-		case 13 : *//* concurrent */
-			/*signal(SIGINT, sighandler);
-			signal(SIGTERM, sighandler);
-			use_lockfd = 1;
-			break;*/
 		case 1 :
 			if (!strcmp(optarg, "!"))
 				ebt_check_inverse2(optarg, argc, argv);
@@ -1248,21 +1134,6 @@ big_iface_length:
 					goto check_extension;
 				}
 			}
-			/*
-			if (w == NULL && c == '?')
-				ebt_print_error2("Unknown argument: '%s'", argv[optind - 1], (char)optopt, (char)c);
-			else if (w == NULL) {
-				if (!strcmp(t->name, "standard"))
-					ebt_print_error2("Unknown argument: don't forget the -t option");
-				else
-					ebt_print_error2("Target-specific option does not correspond with specified target");
-			}
-			if (ebt_errormsg[0] != '\0')
-				return -1;
-			if (w->used == 0) {
-				ebt_add_watcher(new_entry, w);
-				w->used = 1;
-			}*/
 check_extension:
 			if (command != 'A' && command != 'I' &&
 			    command != 'D' && command != 'C')
@@ -1272,13 +1143,6 @@ check_extension:
 		ebt_invert = 0;
 	}
 
-	/* Just in case we didn't catch an error */
-	/*if (ebt_errormsg[0] != '\0')
-		return -1;
-
-	if (!(table = ebt_find_table(replace->name)))
-		ebt_print_error2("Bad table name");*/
-
 	if (command == 'h' && !(flags & OPT_ZERO)) {
 		print_help(cs.target, cs.matches, *table);
 		if (exec_style == EXEC_STYLE_PRG)
@@ -1342,24 +1206,7 @@ check_extension:
 	} else if (command == 'D') {
 		ret = delete_entry(h, chain, *table, &cs, rule_nr - 1,
 				   rule_nr_end, flags&OPT_VERBOSE);
-	} /*else if (replace->command == 'C') {
-		ebt_change_counters(replace, new_entry, rule_nr, rule_nr_end, &(new_entry->cnt_surplus), chcounter);
-		if (ebt_errormsg[0] != '\0')
-			return -1;
-	}*/
-	/* Commands -N, -E, -X, --atomic-commit, --atomic-commit, --atomic-save,
-	 * --init-table fall through */
-
-	/*if (ebt_errormsg[0] != '\0')
-		return -1;
-	if (table->check)
-		table->check(replace);
-
-	if (exec_style == EXEC_STYLE_PRG) {*//* Implies ebt_errormsg[0] == '\0' */
-		/*ebt_deliver_table(replace);
-
-		if (replace->nentries)
-			ebt_deliver_counters(replace);*/
+	}
 
 	ebt_cs_clean(&cs);
 	return ret;

