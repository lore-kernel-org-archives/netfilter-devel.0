From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 1/5] nft: xtables: add generic parsing infrastructure to interpret commands
Date: Mon, 14 Apr 2014 12:41:02 +0200
Message-ID: <1397472066-13011-2-git-send-email-pablo@netfilter.org>
References: <1397472066-13011-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45226 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753004AbaDNKlQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2014 06:41:16 -0400
In-Reply-To: <1397472066-13011-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Split the code to parse arguments and to issue command so we reuse this
for the iptables to nft translation infrastructure.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 iptables/nft-shared.h |   15 ++
 iptables/xtables.c    |  445 ++++++++++++++++++++++++++-----------------------
 2 files changed, 249 insertions(+), 211 deletions(-)

diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 145f19d..d4bc31e 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -175,6 +175,21 @@ struct xtables_args {
 #define CMD_ZERO_NUM		0x2000U
 #define CMD_CHECK		0x4000U
 
+struct nft_xt_cmd_parse {
+	unsigned int			command;
+	unsigned int			rulenum;
+	char				*table;
+	char				*chain;
+	char				*newname;
+	char				*policy;
+	bool				restore;
+	int				verbose;
+};
+
+void do_parse(struct nft_handle *h, int argc, char *argv[],
+	      struct nft_xt_cmd_parse *p, struct iptables_command_state *cs,
+	      struct xtables_args *args);
+
 /*
  * ARP
  */
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 45a5ac6..8aa58af 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -678,25 +678,17 @@ static void command_match(struct iptables_command_state *cs)
 		xtables_error(OTHER_PROBLEM, "can't alloc memory!");
 }
 
-int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
-		bool restore)
+void do_parse(struct nft_handle *h, int argc, char *argv[],
+	      struct nft_xt_cmd_parse *p, struct iptables_command_state *cs,
+	      struct xtables_args *args)
 {
-	struct iptables_command_state cs;
-	int verbose = 0;
-	const char *chain = NULL;
-	const char *policy = NULL, *newname = NULL;
-	unsigned int rulenum = 0, command = 0;
-	int ret = 1;
 	struct xtables_match *m;
 	struct xtables_rule_match *matchp;
 	struct xtables_target *t;
-	struct xtables_args args = {
-		.family	= h->family,
-	};
 
-	memset(&cs, 0, sizeof(cs));
-	cs.jumpto = "";
-	cs.argv = argv;
+	memset(cs, 0, sizeof(*cs));
+	cs->jumpto = "";
+	cs->argv = argv;
 
 	/* re-set optind to 0 in case do_command4 gets called
 	 * a second time */
@@ -721,43 +713,43 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 		xtables_error(PARAMETER_PROBLEM, "Unknown family");
 
 	opts = xt_params->orig_opts;
-	while ((cs.c = getopt_long(argc, argv,
+	while ((cs->c = getopt_long(argc, argv,
 	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:fbvnt:m:xc:g:46",
 					   opts, NULL)) != -1) {
-		switch (cs.c) {
+		switch (cs->c) {
 			/*
 			 * Command selection
 			 */
 		case 'A':
-			add_command(&command, CMD_APPEND, CMD_NONE,
-				    cs.invert);
-			chain = optarg;
+			add_command(&p->command, CMD_APPEND, CMD_NONE,
+				    cs->invert);
+			p->chain = optarg;
 			break;
 
 		case 'C':
-			add_command(&command, CMD_CHECK, CMD_NONE,
-				    cs.invert);
-			chain = optarg;
+			add_command(&p->command, CMD_CHECK, CMD_NONE,
+				    cs->invert);
+			p->chain = optarg;
 			break;
 
 		case 'D':
-			add_command(&command, CMD_DELETE, CMD_NONE,
-				    cs.invert);
-			chain = optarg;
+			add_command(&p->command, CMD_DELETE, CMD_NONE,
+				    cs->invert);
+			p->chain = optarg;
 			if (optind < argc && argv[optind][0] != '-'
 			    && argv[optind][0] != '!') {
-				rulenum = parse_rulenumber(argv[optind++]);
-				command = CMD_DELETE_NUM;
+				p->rulenum = parse_rulenumber(argv[optind++]);
+				p->command = CMD_DELETE_NUM;
 			}
 			break;
 
 		case 'R':
-			add_command(&command, CMD_REPLACE, CMD_NONE,
-				    cs.invert);
-			chain = optarg;
+			add_command(&p->command, CMD_REPLACE, CMD_NONE,
+				    cs->invert);
+			p->chain = optarg;
 			if (optind < argc && argv[optind][0] != '-'
 			    && argv[optind][0] != '!')
-				rulenum = parse_rulenumber(argv[optind++]);
+				p->rulenum = parse_rulenumber(argv[optind++]);
 			else
 				xtables_error(PARAMETER_PROBLEM,
 					   "-%c requires a rule number",
@@ -765,59 +757,64 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 			break;
 
 		case 'I':
-			add_command(&command, CMD_INSERT, CMD_NONE,
-				    cs.invert);
-			chain = optarg;
+			add_command(&p->command, CMD_INSERT, CMD_NONE,
+				    cs->invert);
+			p->chain = optarg;
 			if (optind < argc && argv[optind][0] != '-'
 			    && argv[optind][0] != '!')
-				rulenum = parse_rulenumber(argv[optind++]);
-			else rulenum = 1;
+				p->rulenum = parse_rulenumber(argv[optind++]);
+			else
+				p->rulenum = 1;
 			break;
 
 		case 'L':
-			add_command(&command, CMD_LIST,
-				    CMD_ZERO | CMD_ZERO_NUM, cs.invert);
-			if (optarg) chain = optarg;
+			add_command(&p->command, CMD_LIST,
+				    CMD_ZERO | CMD_ZERO_NUM, cs->invert);
+			if (optarg)
+				p->chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
 				 && argv[optind][0] != '!')
-				chain = argv[optind++];
+				p->chain = argv[optind++];
 			if (optind < argc && argv[optind][0] != '-'
 			    && argv[optind][0] != '!')
-				rulenum = parse_rulenumber(argv[optind++]);
+				p->rulenum = parse_rulenumber(argv[optind++]);
 			break;
 
 		case 'S':
-			add_command(&command, CMD_LIST_RULES,
-				    CMD_ZERO|CMD_ZERO_NUM, cs.invert);
-			if (optarg) chain = optarg;
+			add_command(&p->command, CMD_LIST_RULES,
+				    CMD_ZERO|CMD_ZERO_NUM, cs->invert);
+			if (optarg)
+				p->chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
 				 && argv[optind][0] != '!')
-				chain = argv[optind++];
+				p->chain = argv[optind++];
 			if (optind < argc && argv[optind][0] != '-'
 			    && argv[optind][0] != '!')
-				rulenum = parse_rulenumber(argv[optind++]);
+				p->rulenum = parse_rulenumber(argv[optind++]);
 			break;
 
 		case 'F':
-			add_command(&command, CMD_FLUSH, CMD_NONE,
-				    cs.invert);
-			if (optarg) chain = optarg;
+			add_command(&p->command, CMD_FLUSH, CMD_NONE,
+				    cs->invert);
+			if (optarg)
+				p->chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
 				 && argv[optind][0] != '!')
-				chain = argv[optind++];
+				p->chain = argv[optind++];
 			break;
 
 		case 'Z':
-			add_command(&command, CMD_ZERO, CMD_LIST|CMD_LIST_RULES,
-				    cs.invert);
-			if (optarg) chain = optarg;
+			add_command(&p->command, CMD_ZERO,
+				    CMD_LIST|CMD_LIST_RULES, cs->invert);
+			if (optarg)
+				p->chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
 				&& argv[optind][0] != '!')
-				chain = argv[optind++];
+				p->chain = argv[optind++];
 			if (optind < argc && argv[optind][0] != '-'
 				&& argv[optind][0] != '!') {
-				rulenum = parse_rulenumber(argv[optind++]);
-				command = CMD_ZERO_NUM;
+				p->rulenum = parse_rulenumber(argv[optind++]);
+				p->command = CMD_ZERO_NUM;
 			}
 			break;
 
@@ -830,27 +827,28 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 				xtables_error(PARAMETER_PROBLEM,
 					   "chain name may not clash "
 					   "with target name\n");
-			add_command(&command, CMD_NEW_CHAIN, CMD_NONE,
-				    cs.invert);
-			chain = optarg;
+			add_command(&p->command, CMD_NEW_CHAIN, CMD_NONE,
+				    cs->invert);
+			p->chain = optarg;
 			break;
 
 		case 'X':
-			add_command(&command, CMD_DELETE_CHAIN, CMD_NONE,
-				    cs.invert);
-			if (optarg) chain = optarg;
+			add_command(&p->command, CMD_DELETE_CHAIN, CMD_NONE,
+				    cs->invert);
+			if (optarg)
+				p->chain = optarg;
 			else if (optind < argc && argv[optind][0] != '-'
 				 && argv[optind][0] != '!')
-				chain = argv[optind++];
+				p->chain = argv[optind++];
 			break;
 
 		case 'E':
-			add_command(&command, CMD_RENAME_CHAIN, CMD_NONE,
-				    cs.invert);
-			chain = optarg;
+			add_command(&p->command, CMD_RENAME_CHAIN, CMD_NONE,
+				    cs->invert);
+			p->chain = optarg;
 			if (optind < argc && argv[optind][0] != '-'
 			    && argv[optind][0] != '!')
-				newname = argv[optind++];
+				p->newname = argv[optind++];
 			else
 				xtables_error(PARAMETER_PROBLEM,
 					   "-%c requires old-chain-name and "
@@ -859,12 +857,12 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 			break;
 
 		case 'P':
-			add_command(&command, CMD_SET_POLICY, CMD_NONE,
-				    cs.invert);
-			chain = optarg;
+			add_command(&p->command, CMD_SET_POLICY, CMD_NONE,
+				    cs->invert);
+			p->chain = optarg;
 			if (optind < argc && argv[optind][0] != '-'
 			    && argv[optind][0] != '!')
-				policy = argv[optind++];
+				p->policy = argv[optind++];
 			else
 				xtables_error(PARAMETER_PROBLEM,
 					   "-%c requires a chain and a policy",
@@ -876,57 +874,58 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 				optarg = argv[optind];
 
 			/* iptables -p icmp -h */
-			if (!cs.matches && cs.protocol)
-				xtables_find_match(cs.protocol,
-					XTF_TRY_LOAD, &cs.matches);
+			if (!cs->matches && cs->protocol)
+				xtables_find_match(cs->protocol,
+					XTF_TRY_LOAD, &cs->matches);
 
-			exit_printhelp(cs.matches);
+			exit_printhelp(cs->matches);
 
 			/*
 			 * Option selection
 			 */
 		case 'p':
-			set_option(&cs.options, OPT_PROTOCOL, &args.invflags,
-				   cs.invert);
+			set_option(&cs->options, OPT_PROTOCOL,
+				   &args->invflags, cs->invert);
 
 			/* Canonicalize into lower case */
-			for (cs.protocol = optarg; *cs.protocol; cs.protocol++)
-				*cs.protocol = tolower(*cs.protocol);
+			for (cs->protocol = optarg; *cs->protocol; cs->protocol++)
+				*cs->protocol = tolower(*cs->protocol);
 
-			cs.protocol = optarg;
-			args.proto = xtables_parse_protocol(cs.protocol);
+			cs->protocol = optarg;
+			args->proto = xtables_parse_protocol(cs->protocol);
 
-			if (args.proto == 0 && (args.invflags & XT_INV_PROTO))
+			if (args->proto == 0 &&
+			    (args->invflags & XT_INV_PROTO))
 				xtables_error(PARAMETER_PROBLEM,
 					   "rule would never match protocol");
 
 			/* This needs to happen here to parse extensions */
-			h->ops->proto_parse(&cs, &args);
+			h->ops->proto_parse(cs, args);
 			break;
 
 		case 's':
-			set_option(&cs.options, OPT_SOURCE, &args.invflags,
-				   cs.invert);
-			args.shostnetworkmask = optarg;
+			set_option(&cs->options, OPT_SOURCE,
+				   &args->invflags, cs->invert);
+			args->shostnetworkmask = optarg;
 			break;
 
 		case 'd':
-			set_option(&cs.options, OPT_DESTINATION,
-				   &args.invflags, cs.invert);
-			args.dhostnetworkmask = optarg;
+			set_option(&cs->options, OPT_DESTINATION,
+				   &args->invflags, cs->invert);
+			args->dhostnetworkmask = optarg;
 			break;
 
 #ifdef IPT_F_GOTO
 		case 'g':
-			set_option(&cs.options, OPT_JUMP, &args.invflags,
-				   cs.invert);
-			args.goto_set = true;
-			cs.jumpto = parse_target(optarg);
+			set_option(&cs->options, OPT_JUMP, &args->invflags,
+				   cs->invert);
+			args->goto_set = true;
+			cs->jumpto = parse_target(optarg);
 			break;
 #endif
 
 		case 'j':
-			command_jump(&cs);
+			command_jump(cs);
 			break;
 
 
@@ -935,11 +934,11 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
-			set_option(&cs.options, OPT_VIANAMEIN, &args.invflags,
-				   cs.invert);
+			set_option(&cs->options, OPT_VIANAMEIN,
+				   &args->invflags, cs->invert);
 			xtables_parse_interface(optarg,
-						args.iniface,
-						args.iniface_mask);
+						args->iniface,
+						args->iniface_mask);
 			break;
 
 		case 'o':
@@ -947,54 +946,54 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
-			set_option(&cs.options, OPT_VIANAMEOUT, &args.invflags,
-				   cs.invert);
+			set_option(&cs->options, OPT_VIANAMEOUT,
+				   &args->invflags, cs->invert);
 			xtables_parse_interface(optarg,
-						args.outiface,
-						args.outiface_mask);
+						args->outiface,
+						args->outiface_mask);
 			break;
 
 		case 'f':
-			if (args.family == AF_INET6) {
+			if (args->family == AF_INET6) {
 				xtables_error(PARAMETER_PROBLEM,
 					"`-f' is not supported in IPv6, "
 					"use -m frag instead");
 			}
-			set_option(&cs.options, OPT_FRAGMENT, &args.invflags,
-				   cs.invert);
-			args.flags |= IPT_F_FRAG;
+			set_option(&cs->options, OPT_FRAGMENT, &args->invflags,
+				   cs->invert);
+			args->flags |= IPT_F_FRAG;
 			break;
 
 		case 'v':
-			if (!verbose)
-				set_option(&cs.options, OPT_VERBOSE,
-					   &args.invflags, cs.invert);
-			verbose++;
+			if (!p->verbose)
+				set_option(&cs->options, OPT_VERBOSE,
+					   &args->invflags, cs->invert);
+			p->verbose++;
 			break;
 
 		case 'm':
-			command_match(&cs);
+			command_match(cs);
 			break;
 
 		case 'n':
-			set_option(&cs.options, OPT_NUMERIC, &args.invflags,
-				   cs.invert);
+			set_option(&cs->options, OPT_NUMERIC, &args->invflags,
+				   cs->invert);
 			break;
 
 		case 't':
-			if (cs.invert)
+			if (cs->invert)
 				xtables_error(PARAMETER_PROBLEM,
 					   "unexpected ! flag before --table");
-			*table = optarg;
+			p->table = optarg;
 			break;
 
 		case 'x':
-			set_option(&cs.options, OPT_EXPANDED, &args.invflags,
-				   cs.invert);
+			set_option(&cs->options, OPT_EXPANDED, &args->invflags,
+				   cs->invert);
 			break;
 
 		case 'V':
-			if (cs.invert)
+			if (cs->invert)
 				printf("Not %s ;-)\n", prog_vers);
 			else
 				printf("%s v%s\n",
@@ -1002,7 +1001,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 			exit(0);
 
 		case 'w':
-			if (restore) {
+			if (p->restore) {
 				xtables_error(PARAMETER_PROBLEM,
 					      "You cannot use `-w' from "
 					      "iptables-restore");
@@ -1010,8 +1009,8 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 			break;
 
 		case '0':
-			set_option(&cs.options, OPT_LINENUMBERS,
-				   &args.invflags, cs.invert);
+			set_option(&cs->options, OPT_LINENUMBERS,
+				   &args->invflags, cs->invert);
 			break;
 
 		case 'M':
@@ -1019,45 +1018,44 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 			break;
 
 		case 'c':
-
-			set_option(&cs.options, OPT_COUNTERS, &args.invflags,
-				   cs.invert);
-			args.pcnt = optarg;
-			args.bcnt = strchr(args.pcnt + 1, ',');
-			if (args.bcnt)
-			    args.bcnt++;
-			if (!args.bcnt && optind < argc &&
+			set_option(&cs->options, OPT_COUNTERS, &args->invflags,
+				   cs->invert);
+			args->pcnt = optarg;
+			args->bcnt = strchr(args->pcnt + 1, ',');
+			if (args->bcnt)
+			    args->bcnt++;
+			if (!args->bcnt && optind < argc &&
 			    argv[optind][0] != '-' &&
 			    argv[optind][0] != '!')
-				args.bcnt = argv[optind++];
-			if (!args.bcnt)
+				args->bcnt = argv[optind++];
+			if (!args->bcnt)
 				xtables_error(PARAMETER_PROBLEM,
 					"-%c requires packet and byte counter",
 					opt2char(OPT_COUNTERS));
 
-			if (sscanf(args.pcnt, "%llu", &args.pcnt_cnt) != 1)
+			if (sscanf(args->pcnt, "%llu", &args->pcnt_cnt) != 1)
 				xtables_error(PARAMETER_PROBLEM,
 					"-%c packet counter not numeric",
 					opt2char(OPT_COUNTERS));
 
-			if (sscanf(args.bcnt, "%llu", &args.bcnt_cnt) != 1)
+			if (sscanf(args->bcnt, "%llu", &args->bcnt_cnt) != 1)
 				xtables_error(PARAMETER_PROBLEM,
 					"-%c byte counter not numeric",
 					opt2char(OPT_COUNTERS));
 			break;
 
 		case '4':
-			if (args.family != AF_INET)
+			if (args->family != AF_INET)
 				exit_tryhelp(2);
 
-			h->ops = nft_family_ops_lookup(args.family);
+			h->ops = nft_family_ops_lookup(args->family);
 			break;
 
 		case '6':
-			args.family = AF_INET6;
+			args->family = AF_INET6;
 			xtables_set_nfproto(AF_INET6);
 
-			h->ops = nft_family_ops_lookup(args.family);
+			h->ops = nft_family_ops_lookup(args->family);
 			if (h->ops == NULL)
 				xtables_error(PARAMETER_PROBLEM,
 					      "Unknown family");
@@ -1065,11 +1063,11 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 
 		case 1: /* non option */
 			if (optarg[0] == '!' && optarg[1] == '\0') {
-				if (cs.invert)
+				if (cs->invert)
 					xtables_error(PARAMETER_PROBLEM,
 						   "multiple consecutive ! not"
 						   " allowed");
-				cs.invert = TRUE;
+				cs->invert = TRUE;
 				optarg[0] = '\0';
 				continue;
 			}
@@ -1077,78 +1075,78 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 			exit_tryhelp(2);
 
 		default:
-			if (command_default(&cs, &xtables_globals) == 1)
+			if (command_default(cs, &xtables_globals) == 1)
 				/* cf. ip6tables.c */
 				continue;
 			break;
 		}
-		cs.invert = FALSE;
+		cs->invert = FALSE;
 	}
 
-	if (strcmp(*table, "nat") == 0 &&
-	    ((policy != NULL && strcmp(policy, "DROP") == 0) ||
-	    (cs.jumpto != NULL && strcmp(cs.jumpto, "DROP") == 0)))
+	if (strcmp(p->table, "nat") == 0 &&
+	    ((p->policy != NULL && strcmp(p->policy, "DROP") == 0) ||
+	    (cs->jumpto != NULL && strcmp(cs->jumpto, "DROP") == 0)))
 		xtables_error(PARAMETER_PROBLEM,
 			"\nThe \"nat\" table is not intended for filtering, "
 			"the use of DROP is therefore inhibited.\n\n");
 
-	for (matchp = cs.matches; matchp; matchp = matchp->next)
+	for (matchp = cs->matches; matchp; matchp = matchp->next)
 		xtables_option_mfcall(matchp->match);
-	if (cs.target != NULL)
-		xtables_option_tfcall(cs.target);
+	if (cs->target != NULL)
+		xtables_option_tfcall(cs->target);
 
 	/* Fix me: must put inverse options checking here --MN */
 
 	if (optind < argc)
 		xtables_error(PARAMETER_PROBLEM,
 			   "unknown arguments found on commandline");
-	if (!command)
+	if (!p->command)
 		xtables_error(PARAMETER_PROBLEM, "no command specified");
-	if (cs.invert)
+	if (cs->invert)
 		xtables_error(PARAMETER_PROBLEM,
 			   "nothing appropriate following !");
 
 	/* Set only if required, needed by xtables-restore */
 	if (h->family == AF_UNSPEC)
-		h->family = args.family;
+		h->family = args->family;
 
-	h->ops->post_parse(command, &cs, &args);
+	h->ops->post_parse(p->command, cs, args);
 
-	if (command == CMD_REPLACE &&
-	    (args.s.naddrs != 1 || args.d.naddrs != 1))
+	if (p->command == CMD_REPLACE &&
+	    (args->s.naddrs != 1 || args->d.naddrs != 1))
 		xtables_error(PARAMETER_PROBLEM, "Replacement rule does not "
 			   "specify a unique address");
 
-	generic_opt_check(command, cs.options);
+	generic_opt_check(p->command, cs->options);
 
-	if (chain != NULL && strlen(chain) >= XT_EXTENSION_MAXNAMELEN)
+	if (p->chain != NULL && strlen(p->chain) >= XT_EXTENSION_MAXNAMELEN)
 		xtables_error(PARAMETER_PROBLEM,
 			   "chain name `%s' too long (must be under %u chars)",
-			   chain, XT_EXTENSION_MAXNAMELEN);
-
-	if (command == CMD_APPEND
-	    || command == CMD_DELETE
-	    || command == CMD_CHECK
-	    || command == CMD_INSERT
-	    || command == CMD_REPLACE) {
-		if (strcmp(chain, "PREROUTING") == 0
-		    || strcmp(chain, "INPUT") == 0) {
+			   p->chain, XT_EXTENSION_MAXNAMELEN);
+
+	if (p->command == CMD_APPEND ||
+	    p->command == CMD_DELETE ||
+	    p->command == CMD_CHECK ||
+	    p->command == CMD_INSERT ||
+	    p->command == CMD_REPLACE) {
+		if (strcmp(p->chain, "PREROUTING") == 0
+		    || strcmp(p->chain, "INPUT") == 0) {
 			/* -o not valid with incoming packets. */
-			if (cs.options & OPT_VIANAMEOUT)
+			if (cs->options & OPT_VIANAMEOUT)
 				xtables_error(PARAMETER_PROBLEM,
 					   "Can't use -%c with %s\n",
 					   opt2char(OPT_VIANAMEOUT),
-					   chain);
+					   p->chain);
 		}
 
-		if (strcmp(chain, "POSTROUTING") == 0
-		    || strcmp(chain, "OUTPUT") == 0) {
+		if (strcmp(p->chain, "POSTROUTING") == 0
+		    || strcmp(p->chain, "OUTPUT") == 0) {
 			/* -i not valid with outgoing packets */
-			if (cs.options & OPT_VIANAMEIN)
+			if (cs->options & OPT_VIANAMEIN)
 				xtables_error(PARAMETER_PROBLEM,
 					   "Can't use -%c with %s\n",
 					   opt2char(OPT_VIANAMEIN),
-					   chain);
+					   p->chain);
 		}
 
 		/*
@@ -1157,90 +1155,115 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 		 * nf_table will spot the error if the chain does not exists.
 		 */
 	}
+}
+
+int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
+		bool restore)
+{
+	int ret = 1;
+	struct nft_xt_cmd_parse p = {
+		.table		= *table,
+		.restore	= restore,
+	};
+	struct iptables_command_state cs;
+	struct xtables_args args = {
+		.family = h->family,
+	};
+
+	do_parse(h, argc, argv, &p, &cs, &args);
 
-	switch (command) {
+	switch (p.command) {
 	case CMD_APPEND:
-		ret = add_entry(chain, *table, &cs, 0, h->family,
-				args.s, args.d, cs.options&OPT_VERBOSE,
-				h, true);
+		ret = add_entry(p.chain, p.table, &cs, 0, h->family,
+				args.s, args.d,
+				cs.options & OPT_VERBOSE, h, true);
 		break;
 	case CMD_DELETE:
-		ret = delete_entry(chain, *table, &cs, h->family,
-				   args.s, args.d, cs.options&OPT_VERBOSE, h);
+		ret = delete_entry(p.chain, p.table, &cs, h->family,
+				   args.s, args.d,
+				   cs.options & OPT_VERBOSE, h);
 		break;
 	case CMD_DELETE_NUM:
-		ret = nft_rule_delete_num(h, chain, *table, rulenum - 1, verbose);
+		ret = nft_rule_delete_num(h, p.chain, p.table,
+					  p.rulenum - 1, p.verbose);
 		break;
 	case CMD_CHECK:
-		ret = check_entry(chain, *table, &cs, h->family,
-				   args.s, args.d, cs.options&OPT_VERBOSE, h);
+		ret = check_entry(p.chain, p.table, &cs, h->family,
+				  args.s, args.d,
+				  cs.options & OPT_VERBOSE, h);
 		break;
 	case CMD_REPLACE:
-		ret = replace_entry(chain, *table, &cs, rulenum - 1,
+		ret = replace_entry(p.chain, p.table, &cs, p.rulenum - 1,
 				    h->family, args.s, args.d,
-				    cs.options&OPT_VERBOSE, h);
+				    cs.options & OPT_VERBOSE, h);
 		break;
 	case CMD_INSERT:
-		ret = add_entry(chain, *table, &cs, rulenum - 1, h->family,
-				args.s, args.d, cs.options&OPT_VERBOSE, h,
-				false);
+		ret = add_entry(p.chain, p.table, &cs, p.rulenum - 1,
+				h->family, args.s, args.d,
+				cs.options&OPT_VERBOSE, h, false);
 		break;
 	case CMD_FLUSH:
-		ret = nft_rule_flush(h, chain, *table);
+		ret = nft_rule_flush(h, p.chain, p.table);
 		break;
 	case CMD_ZERO:
-		ret = nft_chain_zero_counters(h, chain, *table);
+		ret = nft_chain_zero_counters(h, p.chain, p.table);
 		break;
 	case CMD_ZERO_NUM:
-		ret = nft_rule_zero_counters(h, chain, *table, rulenum - 1);
+		ret = nft_rule_zero_counters(h, p.chain, p.table,
+					     p.rulenum - 1);
 		break;
 	case CMD_LIST:
 	case CMD_LIST|CMD_ZERO:
 	case CMD_LIST|CMD_ZERO_NUM:
-		ret = list_entries(h, chain, *table,
-				   rulenum,
-				   cs.options&OPT_VERBOSE,
-				   cs.options&OPT_NUMERIC,
-				   cs.options&OPT_EXPANDED,
-				   cs.options&OPT_LINENUMBERS);
-		if (ret && (command & CMD_ZERO))
-			ret = nft_chain_zero_counters(h, chain, *table);
-		if (ret && (command & CMD_ZERO_NUM))
-			ret = nft_rule_zero_counters(h, chain, *table,
-						     rulenum - 1);
+		ret = list_entries(h, p.chain, p.table, p.rulenum,
+				   cs.options & OPT_VERBOSE,
+				   cs.options & OPT_NUMERIC,
+				   cs.options & OPT_EXPANDED,
+				   cs.options & OPT_LINENUMBERS);
+		if (ret && (p.command & CMD_ZERO)) {
+			ret = nft_chain_zero_counters(h, p.chain,
+						      p.table);
+		}
+		if (ret && (p.command & CMD_ZERO_NUM)) {
+			ret = nft_rule_zero_counters(h, p.chain, p.table,
+						     p.rulenum - 1);
+		}
 		break;
 	case CMD_LIST_RULES:
 	case CMD_LIST_RULES|CMD_ZERO:
 	case CMD_LIST_RULES|CMD_ZERO_NUM:
-		ret = list_rules(h, chain, *table, rulenum, cs.options&OPT_VERBOSE);
-		if (ret && (command & CMD_ZERO))
-			ret = nft_chain_zero_counters(h, chain, *table);
-		if (ret && (command & CMD_ZERO_NUM))
-			ret = nft_rule_zero_counters(h, chain, *table,
-						     rulenum - 1);
+		ret = list_rules(h, p.chain, p.table, p.rulenum,
+				 cs.options & OPT_VERBOSE);
+		if (ret && (p.command & CMD_ZERO)) {
+			ret = nft_chain_zero_counters(h, p.chain,
+						      p.table);
+		}
+		if (ret && (p.command & CMD_ZERO_NUM)) {
+			ret = nft_rule_zero_counters(h, p.chain, p.table,
+						     p.rulenum - 1);
+		}
 		break;
 	case CMD_NEW_CHAIN:
-		ret = nft_chain_user_add(h, chain, *table);
+		ret = nft_chain_user_add(h, p.chain, p.table);
 		break;
 	case CMD_DELETE_CHAIN:
-		ret = nft_chain_user_del(h, chain, *table);
+		ret = nft_chain_user_del(h, p.chain, p.table);
 		break;
 	case CMD_RENAME_CHAIN:
-		ret = nft_chain_user_rename(h, chain, *table, newname);
+		ret = nft_chain_user_rename(h, p.chain, p.table, p.newname);
 		break;
 	case CMD_SET_POLICY:
-		ret = nft_chain_set(h, *table, chain, policy, NULL);
+		ret = nft_chain_set(h, p.table, p.chain, p.policy, NULL);
 		if (ret < 0)
 			xtables_error(PARAMETER_PROBLEM, "Wrong policy `%s'\n",
-				      policy);
+				      p.policy);
 		break;
 	default:
 		/* We should never reach this... */
 		exit_tryhelp(2);
 	}
 
-/*	if (verbose > 1)
-		dump_entries(*handle); */
+	*table = p.table;
 
 	xtables_rule_matches_free(&cs.matches);
 
-- 
1.7.10.4

