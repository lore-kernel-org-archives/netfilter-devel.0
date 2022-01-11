Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D188C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 15:05:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244318AbiAKPFg (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 10:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244287AbiAKPFf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 10:05:35 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD51C06173F
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Jan 2022 07:05:35 -0800 (PST)
Received: from localhost ([::1]:59140 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1n7IiL-0007Yb-7B; Tue, 11 Jan 2022 16:05:33 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 07/11] xshared: Move do_parse to shared space
Date:   Tue, 11 Jan 2022 16:04:25 +0100
Message-Id: <20220111150429.29110-8-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111150429.29110-1-phil@nwl.cc>
References: <20220111150429.29110-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Small adjustments were needed:

- Pass line variable via xt_cmd_parse, xshared.c does not have it in
  namespace.
- Replace opts, prog_name and prog_vers defines by the respective
  xt_params field reference.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-shared.h        |   4 -
 iptables/xshared.c           | 553 ++++++++++++++++++++++++++++++++++
 iptables/xshared.h           |   5 +
 iptables/xtables-translate.c |   1 +
 iptables/xtables.c           | 556 +----------------------------------
 5 files changed, 560 insertions(+), 559 deletions(-)

diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index 195e5fed43075..c3241f4b8c726 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -174,10 +174,6 @@ void nft_ipv46_parse_target(struct xtables_target *t, void *data);
 bool compare_matches(struct xtables_rule_match *mt1, struct xtables_rule_match *mt2);
 bool compare_targets(struct xtables_target *tg1, struct xtables_target *tg2);
 
-void do_parse(int argc, char *argv[],
-	      struct xt_cmd_parse *p, struct iptables_command_state *cs,
-	      struct xtables_args *args);
-
 struct nftnl_chain_list;
 
 struct nft_xt_restore_cb {
diff --git a/iptables/xshared.c b/iptables/xshared.c
index efee7a30b39fd..4c8ee3aa20278 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1262,3 +1262,556 @@ void exit_tryhelp(int status, int line)
 	xtables_free_opts(1);
 	exit(status);
 }
+
+static void check_empty_interface(struct xtables_args *args, const char *arg)
+{
+	const char *msg = "Empty interface is likely to be undesired";
+
+	if (*arg != '\0')
+		return;
+
+	if (args->family != NFPROTO_ARP)
+		xtables_error(PARAMETER_PROBLEM, msg);
+
+	fprintf(stderr, "%s", msg);
+}
+
+static void check_inverse(struct xtables_args *args, const char option[],
+			  bool *invert, int *optidx, int argc)
+{
+	switch (args->family) {
+	case NFPROTO_ARP:
+		break;
+	default:
+		return;
+	}
+
+	if (!option || strcmp(option, "!"))
+		return;
+
+	fprintf(stderr, "Using intrapositioned negation (`--option ! this`) "
+		"is deprecated in favor of extrapositioned (`! --option this`).\n");
+
+	if (*invert)
+		xtables_error(PARAMETER_PROBLEM,
+			      "Multiple `!' flags not allowed");
+	*invert = true;
+	if (optidx) {
+		*optidx = *optidx + 1;
+		if (argc && *optidx > argc)
+			xtables_error(PARAMETER_PROBLEM,
+				      "no argument following `!'");
+	}
+}
+
+void do_parse(int argc, char *argv[],
+	      struct xt_cmd_parse *p, struct iptables_command_state *cs,
+	      struct xtables_args *args)
+{
+	struct xtables_match *m;
+	struct xtables_rule_match *matchp;
+	bool wait_interval_set = false;
+	struct timeval wait_interval;
+	struct xtables_target *t;
+	bool table_set = false;
+	bool invert = false;
+	int wait = 0;
+
+	/* re-set optind to 0 in case do_command4 gets called
+	 * a second time */
+	optind = 0;
+
+	/* clear mflags in case do_command4 gets called a second time
+	 * (we clear the global list of all matches for security)*/
+	for (m = xtables_matches; m; m = m->next)
+		m->mflags = 0;
+
+	for (t = xtables_targets; t; t = t->next) {
+		t->tflags = 0;
+		t->used = 0;
+	}
+
+	/* Suppress error messages: we may add new options if we
+	   demand-load a protocol. */
+	opterr = 0;
+
+	xt_params->opts = xt_params->orig_opts;
+	while ((cs->c = getopt_long(argc, argv, xt_params->optstring,
+				    xt_params->opts, NULL)) != -1) {
+		switch (cs->c) {
+			/*
+			 * Command selection
+			 */
+		case 'A':
+			add_command(&p->command, CMD_APPEND, CMD_NONE, invert);
+			p->chain = optarg;
+			break;
+
+		case 'C':
+			add_command(&p->command, CMD_CHECK, CMD_NONE, invert);
+			p->chain = optarg;
+			break;
+
+		case 'D':
+			add_command(&p->command, CMD_DELETE, CMD_NONE, invert);
+			p->chain = optarg;
+			if (xs_has_arg(argc, argv)) {
+				p->rulenum = parse_rulenumber(argv[optind++]);
+				p->command = CMD_DELETE_NUM;
+			}
+			break;
+
+		case 'R':
+			add_command(&p->command, CMD_REPLACE, CMD_NONE, invert);
+			p->chain = optarg;
+			if (xs_has_arg(argc, argv))
+				p->rulenum = parse_rulenumber(argv[optind++]);
+			else
+				xtables_error(PARAMETER_PROBLEM,
+					   "-%c requires a rule number",
+					   cmd2char(CMD_REPLACE));
+			break;
+
+		case 'I':
+			add_command(&p->command, CMD_INSERT, CMD_NONE, invert);
+			p->chain = optarg;
+			if (xs_has_arg(argc, argv))
+				p->rulenum = parse_rulenumber(argv[optind++]);
+			else
+				p->rulenum = 1;
+			break;
+
+		case 'L':
+			add_command(&p->command, CMD_LIST,
+				    CMD_ZERO | CMD_ZERO_NUM, invert);
+			if (optarg)
+				p->chain = optarg;
+			else if (xs_has_arg(argc, argv))
+				p->chain = argv[optind++];
+			if (xs_has_arg(argc, argv))
+				p->rulenum = parse_rulenumber(argv[optind++]);
+			break;
+
+		case 'S':
+			add_command(&p->command, CMD_LIST_RULES,
+				    CMD_ZERO|CMD_ZERO_NUM, invert);
+			if (optarg)
+				p->chain = optarg;
+			else if (xs_has_arg(argc, argv))
+				p->chain = argv[optind++];
+			if (xs_has_arg(argc, argv))
+				p->rulenum = parse_rulenumber(argv[optind++]);
+			break;
+
+		case 'F':
+			add_command(&p->command, CMD_FLUSH, CMD_NONE, invert);
+			if (optarg)
+				p->chain = optarg;
+			else if (xs_has_arg(argc, argv))
+				p->chain = argv[optind++];
+			break;
+
+		case 'Z':
+			add_command(&p->command, CMD_ZERO,
+				    CMD_LIST|CMD_LIST_RULES, invert);
+			if (optarg)
+				p->chain = optarg;
+			else if (xs_has_arg(argc, argv))
+				p->chain = argv[optind++];
+			if (xs_has_arg(argc, argv)) {
+				p->rulenum = parse_rulenumber(argv[optind++]);
+				p->command = CMD_ZERO_NUM;
+			}
+			break;
+
+		case 'N':
+			parse_chain(optarg);
+			add_command(&p->command, CMD_NEW_CHAIN, CMD_NONE,
+				    invert);
+			p->chain = optarg;
+			break;
+
+		case 'X':
+			add_command(&p->command, CMD_DELETE_CHAIN, CMD_NONE,
+				    invert);
+			if (optarg)
+				p->chain = optarg;
+			else if (xs_has_arg(argc, argv))
+				p->chain = argv[optind++];
+			break;
+
+		case 'E':
+			add_command(&p->command, CMD_RENAME_CHAIN, CMD_NONE,
+				    invert);
+			p->chain = optarg;
+			if (xs_has_arg(argc, argv))
+				p->newname = argv[optind++];
+			else
+				xtables_error(PARAMETER_PROBLEM,
+					   "-%c requires old-chain-name and "
+					   "new-chain-name",
+					    cmd2char(CMD_RENAME_CHAIN));
+			break;
+
+		case 'P':
+			add_command(&p->command, CMD_SET_POLICY, CMD_NONE,
+				    invert);
+			p->chain = optarg;
+			if (xs_has_arg(argc, argv))
+				p->policy = argv[optind++];
+			else
+				xtables_error(PARAMETER_PROBLEM,
+					   "-%c requires a chain and a policy",
+					   cmd2char(CMD_SET_POLICY));
+			break;
+
+		case 'h':
+			if (!optarg)
+				optarg = argv[optind];
+
+			/* iptables -p icmp -h */
+			if (!cs->matches && cs->protocol)
+				xtables_find_match(cs->protocol,
+					XTF_TRY_LOAD, &cs->matches);
+
+			xt_params->print_help(cs->matches);
+			p->command = CMD_NONE;
+			return;
+
+			/*
+			 * Option selection
+			 */
+		case 'p':
+			check_inverse(args, optarg, &invert, &optind, argc);
+			set_option(&cs->options, OPT_PROTOCOL,
+				   &args->invflags, invert);
+
+			/* Canonicalize into lower case */
+			for (cs->protocol = argv[optind - 1];
+			     *cs->protocol; cs->protocol++)
+				*cs->protocol = tolower(*cs->protocol);
+
+			cs->protocol = argv[optind - 1];
+			args->proto = xtables_parse_protocol(cs->protocol);
+
+			if (args->proto == 0 &&
+			    (args->invflags & XT_INV_PROTO))
+				xtables_error(PARAMETER_PROBLEM,
+					   "rule would never match protocol");
+
+			/* This needs to happen here to parse extensions */
+			if (p->ops->proto_parse)
+				p->ops->proto_parse(cs, args);
+			break;
+
+		case 's':
+			check_inverse(args, optarg, &invert, &optind, argc);
+			set_option(&cs->options, OPT_SOURCE,
+				   &args->invflags, invert);
+			args->shostnetworkmask = argv[optind - 1];
+			break;
+
+		case 'd':
+			check_inverse(args, optarg, &invert, &optind, argc);
+			set_option(&cs->options, OPT_DESTINATION,
+				   &args->invflags, invert);
+			args->dhostnetworkmask = argv[optind - 1];
+			break;
+
+#ifdef IPT_F_GOTO
+		case 'g':
+			set_option(&cs->options, OPT_JUMP, &args->invflags,
+				   invert);
+			args->goto_set = true;
+			cs->jumpto = xt_parse_target(optarg);
+			break;
+#endif
+
+		case 2:/* src-mac */
+			check_inverse(args, optarg, &invert, &optind, argc);
+			set_option(&cs->options, OPT_S_MAC, &args->invflags,
+				   invert);
+			args->src_mac = argv[optind - 1];
+			break;
+
+		case 3:/* dst-mac */
+			check_inverse(args, optarg, &invert, &optind, argc);
+			set_option(&cs->options, OPT_D_MAC, &args->invflags,
+				   invert);
+			args->dst_mac = argv[optind - 1];
+			break;
+
+		case 'l':/* hardware length */
+			check_inverse(args, optarg, &invert, &optind, argc);
+			set_option(&cs->options, OPT_H_LENGTH, &args->invflags,
+				   invert);
+			args->arp_hlen = argv[optind - 1];
+			break;
+
+		case 8: /* was never supported, not even in arptables-legacy */
+			xtables_error(PARAMETER_PROBLEM, "not supported");
+		case 4:/* opcode */
+			check_inverse(args, optarg, &invert, &optind, argc);
+			set_option(&cs->options, OPT_OPCODE, &args->invflags,
+				   invert);
+			args->arp_opcode = argv[optind - 1];
+			break;
+
+		case 5:/* h-type */
+			check_inverse(args, optarg, &invert, &optind, argc);
+			set_option(&cs->options, OPT_H_TYPE, &args->invflags,
+				   invert);
+			args->arp_htype = argv[optind - 1];
+			break;
+
+		case 6:/* proto-type */
+			check_inverse(args, optarg, &invert, &optind, argc);
+			set_option(&cs->options, OPT_P_TYPE, &args->invflags,
+				   invert);
+			args->arp_ptype = argv[optind - 1];
+			break;
+
+		case 'j':
+			set_option(&cs->options, OPT_JUMP, &args->invflags,
+				   invert);
+			command_jump(cs, argv[optind - 1]);
+			break;
+
+		case 'i':
+			check_empty_interface(args, optarg);
+			check_inverse(args, optarg, &invert, &optind, argc);
+			set_option(&cs->options, OPT_VIANAMEIN,
+				   &args->invflags, invert);
+			xtables_parse_interface(argv[optind - 1],
+						args->iniface,
+						args->iniface_mask);
+			break;
+
+		case 'o':
+			check_empty_interface(args, optarg);
+			check_inverse(args, optarg, &invert, &optind, argc);
+			set_option(&cs->options, OPT_VIANAMEOUT,
+				   &args->invflags, invert);
+			xtables_parse_interface(argv[optind - 1],
+						args->outiface,
+						args->outiface_mask);
+			break;
+
+		case 'f':
+			if (args->family == AF_INET6) {
+				xtables_error(PARAMETER_PROBLEM,
+					"`-f' is not supported in IPv6, "
+					"use -m frag instead");
+			}
+			set_option(&cs->options, OPT_FRAGMENT, &args->invflags,
+				   invert);
+			args->flags |= IPT_F_FRAG;
+			break;
+
+		case 'v':
+			if (!p->verbose)
+				set_option(&cs->options, OPT_VERBOSE,
+					   &args->invflags, invert);
+			p->verbose++;
+			break;
+
+		case 'm':
+			command_match(cs, invert);
+			break;
+
+		case 'n':
+			set_option(&cs->options, OPT_NUMERIC, &args->invflags,
+				   invert);
+			break;
+
+		case 't':
+			if (invert)
+				xtables_error(PARAMETER_PROBLEM,
+					   "unexpected ! flag before --table");
+			if (p->restore && table_set)
+				xtables_error(PARAMETER_PROBLEM,
+					      "The -t option cannot be used in %s.\n",
+					      xt_params->program_name);
+			p->table = optarg;
+			table_set = true;
+			break;
+
+		case 'x':
+			set_option(&cs->options, OPT_EXPANDED, &args->invflags,
+				   invert);
+			break;
+
+		case 'V':
+			if (invert)
+				printf("Not %s ;-)\n",
+				       xt_params->program_version);
+			else
+				printf("%s v%s\n",
+				       xt_params->program_name,
+				       xt_params->program_version);
+			exit(0);
+
+		case 'w':
+			if (p->restore) {
+				xtables_error(PARAMETER_PROBLEM,
+					      "You cannot use `-w' from "
+					      "iptables-restore");
+			}
+
+			wait = parse_wait_time(argc, argv);
+			break;
+
+		case 'W':
+			if (p->restore) {
+				xtables_error(PARAMETER_PROBLEM,
+					      "You cannot use `-W' from "
+					      "iptables-restore");
+			}
+
+			parse_wait_interval(argc, argv, &wait_interval);
+			wait_interval_set = true;
+			break;
+
+		case '0':
+			set_option(&cs->options, OPT_LINENUMBERS,
+				   &args->invflags, invert);
+			break;
+
+		case 'M':
+			xtables_modprobe_program = optarg;
+			break;
+
+		case 'c':
+			set_option(&cs->options, OPT_COUNTERS, &args->invflags,
+				   invert);
+			args->pcnt = optarg;
+			args->bcnt = strchr(args->pcnt + 1, ',');
+			if (args->bcnt)
+			    args->bcnt++;
+			if (!args->bcnt && xs_has_arg(argc, argv))
+				args->bcnt = argv[optind++];
+			if (!args->bcnt)
+				xtables_error(PARAMETER_PROBLEM,
+					"-%c requires packet and byte counter",
+					opt2char(OPT_COUNTERS));
+
+			if (sscanf(args->pcnt, "%llu", &args->pcnt_cnt) != 1)
+				xtables_error(PARAMETER_PROBLEM,
+					"-%c packet counter not numeric",
+					opt2char(OPT_COUNTERS));
+
+			if (sscanf(args->bcnt, "%llu", &args->bcnt_cnt) != 1)
+				xtables_error(PARAMETER_PROBLEM,
+					"-%c byte counter not numeric",
+					opt2char(OPT_COUNTERS));
+			break;
+
+		case '4':
+			if (args->family == AF_INET)
+				break;
+
+			if (p->restore && args->family == AF_INET6)
+				return;
+
+			exit_tryhelp(2, p->line);
+
+		case '6':
+			if (args->family == AF_INET6)
+				break;
+
+			if (p->restore && args->family == AF_INET)
+				return;
+
+			exit_tryhelp(2, p->line);
+
+		case 1: /* non option */
+			if (optarg[0] == '!' && optarg[1] == '\0') {
+				if (invert)
+					xtables_error(PARAMETER_PROBLEM,
+						   "multiple consecutive ! not"
+						   " allowed");
+				invert = true;
+				optarg[0] = '\0';
+				continue;
+			}
+			fprintf(stderr, "Bad argument `%s'\n", optarg);
+			exit_tryhelp(2, p->line);
+
+		default:
+			if (command_default(cs, xt_params, invert))
+				/* cf. ip6tables.c */
+				continue;
+			break;
+		}
+		invert = false;
+	}
+
+	if (strcmp(p->table, "nat") == 0 &&
+	    ((p->policy != NULL && strcmp(p->policy, "DROP") == 0) ||
+	    (cs->jumpto != NULL && strcmp(cs->jumpto, "DROP") == 0)))
+		xtables_error(PARAMETER_PROBLEM,
+			"\nThe \"nat\" table is not intended for filtering, "
+			"the use of DROP is therefore inhibited.\n\n");
+
+	if (!wait && wait_interval_set)
+		xtables_error(PARAMETER_PROBLEM,
+			      "--wait-interval only makes sense with --wait\n");
+
+	for (matchp = cs->matches; matchp; matchp = matchp->next)
+		xtables_option_mfcall(matchp->match);
+	if (cs->target != NULL)
+		xtables_option_tfcall(cs->target);
+
+	/* Fix me: must put inverse options checking here --MN */
+
+	if (optind < argc)
+		xtables_error(PARAMETER_PROBLEM,
+			   "unknown arguments found on commandline");
+	if (!p->command)
+		xtables_error(PARAMETER_PROBLEM, "no command specified");
+	if (invert)
+		xtables_error(PARAMETER_PROBLEM,
+			   "nothing appropriate following !");
+
+	if (p->ops->post_parse)
+		p->ops->post_parse(p->command, cs, args);
+
+	if (p->command == CMD_REPLACE &&
+	    (args->s.naddrs != 1 || args->d.naddrs != 1))
+		xtables_error(PARAMETER_PROBLEM, "Replacement rule does not "
+			   "specify a unique address");
+
+	generic_opt_check(p->command, cs->options);
+
+	if (p->chain != NULL && strlen(p->chain) >= XT_EXTENSION_MAXNAMELEN)
+		xtables_error(PARAMETER_PROBLEM,
+			   "chain name `%s' too long (must be under %u chars)",
+			   p->chain, XT_EXTENSION_MAXNAMELEN);
+
+	if (p->command == CMD_APPEND ||
+	    p->command == CMD_DELETE ||
+	    p->command == CMD_DELETE_NUM ||
+	    p->command == CMD_CHECK ||
+	    p->command == CMD_INSERT ||
+	    p->command == CMD_REPLACE) {
+		if (strcmp(p->chain, "PREROUTING") == 0
+		    || strcmp(p->chain, "INPUT") == 0) {
+			/* -o not valid with incoming packets. */
+			if (cs->options & OPT_VIANAMEOUT)
+				xtables_error(PARAMETER_PROBLEM,
+					   "Can't use -%c with %s\n",
+					   opt2char(OPT_VIANAMEOUT),
+					   p->chain);
+		}
+
+		if (strcmp(p->chain, "POSTROUTING") == 0
+		    || strcmp(p->chain, "OUTPUT") == 0) {
+			/* -i not valid with outgoing packets */
+			if (cs->options & OPT_VIANAMEIN)
+				xtables_error(PARAMETER_PROBLEM,
+					   "Can't use -%c with %s\n",
+					   opt2char(OPT_VIANAMEIN),
+					   p->chain);
+		}
+	}
+}
diff --git a/iptables/xshared.h b/iptables/xshared.h
index 34730be6ce004..13ea05fef87e0 100644
--- a/iptables/xshared.h
+++ b/iptables/xshared.h
@@ -311,9 +311,14 @@ struct xt_cmd_parse {
 	const char			*newname;
 	const char			*policy;
 	bool				restore;
+	int				line;
 	int				verbose;
 	bool				xlate;
 	struct xt_cmd_parse_ops		*ops;
 };
 
+void do_parse(int argc, char *argv[],
+	      struct xt_cmd_parse *p, struct iptables_command_state *cs,
+	      struct xtables_args *args);
+
 #endif /* IPTABLES_XSHARED_H */
diff --git a/iptables/xtables-translate.c b/iptables/xtables-translate.c
index c287d3bdc75e0..6a1cdac14a7da 100644
--- a/iptables/xtables-translate.c
+++ b/iptables/xtables-translate.c
@@ -251,6 +251,7 @@ static int do_command_xlate(struct nft_handle *h, int argc, char *argv[],
 	struct xt_cmd_parse p = {
 		.table		= *table,
 		.restore	= restore,
+		.line		= line,
 		.xlate		= true,
 		.ops		= &h->ops->cmd_parse,
 	};
diff --git a/iptables/xtables.c b/iptables/xtables.c
index 59fc63d0fee86..051d5c7b7f98b 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -95,10 +95,6 @@ struct xtables_globals xtables_globals = {
 	.print_help = xtables_printhelp,
 };
 
-#define opts xt_params->opts
-#define prog_name xt_params->program_name
-#define prog_vers xt_params->program_version
-
 /*
  *	All functions starting with "parse" should succeed, otherwise
  *	the program fails.
@@ -145,557 +141,6 @@ list_rules(struct nft_handle *h, const char *chain, const char *table,
 	return nft_cmd_rule_list_save(h, chain, table, rulenum, counters);
 }
 
-static void check_empty_interface(struct xtables_args *args, const char *arg)
-{
-	const char *msg = "Empty interface is likely to be undesired";
-
-	if (*arg != '\0')
-		return;
-
-	if (args->family != NFPROTO_ARP)
-		xtables_error(PARAMETER_PROBLEM, msg);
-
-	fprintf(stderr, "%s", msg);
-}
-
-static void check_inverse(struct xtables_args *args, const char option[],
-			  bool *invert, int *optidx, int argc)
-{
-	switch (args->family) {
-	case NFPROTO_ARP:
-		break;
-	default:
-		return;
-	}
-
-	if (!option || strcmp(option, "!"))
-		return;
-
-	fprintf(stderr, "Using intrapositioned negation (`--option ! this`) "
-		"is deprecated in favor of extrapositioned (`! --option this`).\n");
-
-	if (*invert)
-		xtables_error(PARAMETER_PROBLEM,
-			      "Multiple `!' flags not allowed");
-	*invert = true;
-	if (optidx) {
-		*optidx = *optidx + 1;
-		if (argc && *optidx > argc)
-			xtables_error(PARAMETER_PROBLEM,
-				      "no argument following `!'");
-	}
-}
-
-void do_parse(int argc, char *argv[],
-	      struct xt_cmd_parse *p, struct iptables_command_state *cs,
-	      struct xtables_args *args)
-{
-	struct xtables_match *m;
-	struct xtables_rule_match *matchp;
-	bool wait_interval_set = false;
-	struct timeval wait_interval;
-	struct xtables_target *t;
-	bool table_set = false;
-	bool invert = false;
-	int wait = 0;
-
-	/* re-set optind to 0 in case do_command4 gets called
-	 * a second time */
-	optind = 0;
-
-	/* clear mflags in case do_command4 gets called a second time
-	 * (we clear the global list of all matches for security)*/
-	for (m = xtables_matches; m; m = m->next)
-		m->mflags = 0;
-
-	for (t = xtables_targets; t; t = t->next) {
-		t->tflags = 0;
-		t->used = 0;
-	}
-
-	/* Suppress error messages: we may add new options if we
-	   demand-load a protocol. */
-	opterr = 0;
-
-	opts = xt_params->orig_opts;
-	while ((cs->c = getopt_long(argc, argv, xt_params->optstring,
-					   opts, NULL)) != -1) {
-		switch (cs->c) {
-			/*
-			 * Command selection
-			 */
-		case 'A':
-			add_command(&p->command, CMD_APPEND, CMD_NONE, invert);
-			p->chain = optarg;
-			break;
-
-		case 'C':
-			add_command(&p->command, CMD_CHECK, CMD_NONE, invert);
-			p->chain = optarg;
-			break;
-
-		case 'D':
-			add_command(&p->command, CMD_DELETE, CMD_NONE, invert);
-			p->chain = optarg;
-			if (xs_has_arg(argc, argv)) {
-				p->rulenum = parse_rulenumber(argv[optind++]);
-				p->command = CMD_DELETE_NUM;
-			}
-			break;
-
-		case 'R':
-			add_command(&p->command, CMD_REPLACE, CMD_NONE, invert);
-			p->chain = optarg;
-			if (xs_has_arg(argc, argv))
-				p->rulenum = parse_rulenumber(argv[optind++]);
-			else
-				xtables_error(PARAMETER_PROBLEM,
-					   "-%c requires a rule number",
-					   cmd2char(CMD_REPLACE));
-			break;
-
-		case 'I':
-			add_command(&p->command, CMD_INSERT, CMD_NONE, invert);
-			p->chain = optarg;
-			if (xs_has_arg(argc, argv))
-				p->rulenum = parse_rulenumber(argv[optind++]);
-			else
-				p->rulenum = 1;
-			break;
-
-		case 'L':
-			add_command(&p->command, CMD_LIST,
-				    CMD_ZERO | CMD_ZERO_NUM, invert);
-			if (optarg)
-				p->chain = optarg;
-			else if (xs_has_arg(argc, argv))
-				p->chain = argv[optind++];
-			if (xs_has_arg(argc, argv))
-				p->rulenum = parse_rulenumber(argv[optind++]);
-			break;
-
-		case 'S':
-			add_command(&p->command, CMD_LIST_RULES,
-				    CMD_ZERO|CMD_ZERO_NUM, invert);
-			if (optarg)
-				p->chain = optarg;
-			else if (xs_has_arg(argc, argv))
-				p->chain = argv[optind++];
-			if (xs_has_arg(argc, argv))
-				p->rulenum = parse_rulenumber(argv[optind++]);
-			break;
-
-		case 'F':
-			add_command(&p->command, CMD_FLUSH, CMD_NONE, invert);
-			if (optarg)
-				p->chain = optarg;
-			else if (xs_has_arg(argc, argv))
-				p->chain = argv[optind++];
-			break;
-
-		case 'Z':
-			add_command(&p->command, CMD_ZERO,
-				    CMD_LIST|CMD_LIST_RULES, invert);
-			if (optarg)
-				p->chain = optarg;
-			else if (xs_has_arg(argc, argv))
-				p->chain = argv[optind++];
-			if (xs_has_arg(argc, argv)) {
-				p->rulenum = parse_rulenumber(argv[optind++]);
-				p->command = CMD_ZERO_NUM;
-			}
-			break;
-
-		case 'N':
-			parse_chain(optarg);
-			add_command(&p->command, CMD_NEW_CHAIN, CMD_NONE,
-				    invert);
-			p->chain = optarg;
-			break;
-
-		case 'X':
-			add_command(&p->command, CMD_DELETE_CHAIN, CMD_NONE,
-				    invert);
-			if (optarg)
-				p->chain = optarg;
-			else if (xs_has_arg(argc, argv))
-				p->chain = argv[optind++];
-			break;
-
-		case 'E':
-			add_command(&p->command, CMD_RENAME_CHAIN, CMD_NONE,
-				    invert);
-			p->chain = optarg;
-			if (xs_has_arg(argc, argv))
-				p->newname = argv[optind++];
-			else
-				xtables_error(PARAMETER_PROBLEM,
-					   "-%c requires old-chain-name and "
-					   "new-chain-name",
-					    cmd2char(CMD_RENAME_CHAIN));
-			break;
-
-		case 'P':
-			add_command(&p->command, CMD_SET_POLICY, CMD_NONE,
-				    invert);
-			p->chain = optarg;
-			if (xs_has_arg(argc, argv))
-				p->policy = argv[optind++];
-			else
-				xtables_error(PARAMETER_PROBLEM,
-					   "-%c requires a chain and a policy",
-					   cmd2char(CMD_SET_POLICY));
-			break;
-
-		case 'h':
-			if (!optarg)
-				optarg = argv[optind];
-
-			/* iptables -p icmp -h */
-			if (!cs->matches && cs->protocol)
-				xtables_find_match(cs->protocol,
-					XTF_TRY_LOAD, &cs->matches);
-
-			xt_params->print_help(cs->matches);
-			p->command = CMD_NONE;
-			return;
-
-			/*
-			 * Option selection
-			 */
-		case 'p':
-			check_inverse(args, optarg, &invert, &optind, argc);
-			set_option(&cs->options, OPT_PROTOCOL,
-				   &args->invflags, invert);
-
-			/* Canonicalize into lower case */
-			for (cs->protocol = argv[optind - 1];
-			     *cs->protocol; cs->protocol++)
-				*cs->protocol = tolower(*cs->protocol);
-
-			cs->protocol = argv[optind - 1];
-			args->proto = xtables_parse_protocol(cs->protocol);
-
-			if (args->proto == 0 &&
-			    (args->invflags & XT_INV_PROTO))
-				xtables_error(PARAMETER_PROBLEM,
-					   "rule would never match protocol");
-
-			/* This needs to happen here to parse extensions */
-			if (p->ops->proto_parse)
-				p->ops->proto_parse(cs, args);
-			break;
-
-		case 's':
-			check_inverse(args, optarg, &invert, &optind, argc);
-			set_option(&cs->options, OPT_SOURCE,
-				   &args->invflags, invert);
-			args->shostnetworkmask = argv[optind - 1];
-			break;
-
-		case 'd':
-			check_inverse(args, optarg, &invert, &optind, argc);
-			set_option(&cs->options, OPT_DESTINATION,
-				   &args->invflags, invert);
-			args->dhostnetworkmask = argv[optind - 1];
-			break;
-
-#ifdef IPT_F_GOTO
-		case 'g':
-			set_option(&cs->options, OPT_JUMP, &args->invflags,
-				   invert);
-			args->goto_set = true;
-			cs->jumpto = xt_parse_target(optarg);
-			break;
-#endif
-
-		case 2:/* src-mac */
-			check_inverse(args, optarg, &invert, &optind, argc);
-			set_option(&cs->options, OPT_S_MAC, &args->invflags,
-				   invert);
-			args->src_mac = argv[optind - 1];
-			break;
-
-		case 3:/* dst-mac */
-			check_inverse(args, optarg, &invert, &optind, argc);
-			set_option(&cs->options, OPT_D_MAC, &args->invflags,
-				   invert);
-			args->dst_mac = argv[optind - 1];
-			break;
-
-		case 'l':/* hardware length */
-			check_inverse(args, optarg, &invert, &optind, argc);
-			set_option(&cs->options, OPT_H_LENGTH, &args->invflags,
-				   invert);
-			args->arp_hlen = argv[optind - 1];
-			break;
-
-		case 8: /* was never supported, not even in arptables-legacy */
-			xtables_error(PARAMETER_PROBLEM, "not supported");
-		case 4:/* opcode */
-			check_inverse(args, optarg, &invert, &optind, argc);
-			set_option(&cs->options, OPT_OPCODE, &args->invflags,
-				   invert);
-			args->arp_opcode = argv[optind - 1];
-			break;
-
-		case 5:/* h-type */
-			check_inverse(args, optarg, &invert, &optind, argc);
-			set_option(&cs->options, OPT_H_TYPE, &args->invflags,
-				   invert);
-			args->arp_htype = argv[optind - 1];
-			break;
-
-		case 6:/* proto-type */
-			check_inverse(args, optarg, &invert, &optind, argc);
-			set_option(&cs->options, OPT_P_TYPE, &args->invflags,
-				   invert);
-			args->arp_ptype = argv[optind - 1];
-			break;
-
-		case 'j':
-			set_option(&cs->options, OPT_JUMP, &args->invflags,
-				   invert);
-			command_jump(cs, argv[optind - 1]);
-			break;
-
-		case 'i':
-			check_empty_interface(args, optarg);
-			check_inverse(args, optarg, &invert, &optind, argc);
-			set_option(&cs->options, OPT_VIANAMEIN,
-				   &args->invflags, invert);
-			xtables_parse_interface(argv[optind - 1],
-						args->iniface,
-						args->iniface_mask);
-			break;
-
-		case 'o':
-			check_empty_interface(args, optarg);
-			check_inverse(args, optarg, &invert, &optind, argc);
-			set_option(&cs->options, OPT_VIANAMEOUT,
-				   &args->invflags, invert);
-			xtables_parse_interface(argv[optind - 1],
-						args->outiface,
-						args->outiface_mask);
-			break;
-
-		case 'f':
-			if (args->family == AF_INET6) {
-				xtables_error(PARAMETER_PROBLEM,
-					"`-f' is not supported in IPv6, "
-					"use -m frag instead");
-			}
-			set_option(&cs->options, OPT_FRAGMENT, &args->invflags,
-				   invert);
-			args->flags |= IPT_F_FRAG;
-			break;
-
-		case 'v':
-			if (!p->verbose)
-				set_option(&cs->options, OPT_VERBOSE,
-					   &args->invflags, invert);
-			p->verbose++;
-			break;
-
-		case 'm':
-			command_match(cs, invert);
-			break;
-
-		case 'n':
-			set_option(&cs->options, OPT_NUMERIC, &args->invflags,
-				   invert);
-			break;
-
-		case 't':
-			if (invert)
-				xtables_error(PARAMETER_PROBLEM,
-					   "unexpected ! flag before --table");
-			if (p->restore && table_set)
-				xtables_error(PARAMETER_PROBLEM,
-					      "The -t option cannot be used in %s.\n",
-					      xt_params->program_name);
-			p->table = optarg;
-			table_set = true;
-			break;
-
-		case 'x':
-			set_option(&cs->options, OPT_EXPANDED, &args->invflags,
-				   invert);
-			break;
-
-		case 'V':
-			if (invert)
-				printf("Not %s ;-)\n", prog_vers);
-			else
-				printf("%s v%s\n",
-				       prog_name, prog_vers);
-			exit(0);
-
-		case 'w':
-			if (p->restore) {
-				xtables_error(PARAMETER_PROBLEM,
-					      "You cannot use `-w' from "
-					      "iptables-restore");
-			}
-
-			wait = parse_wait_time(argc, argv);
-			break;
-
-		case 'W':
-			if (p->restore) {
-				xtables_error(PARAMETER_PROBLEM,
-					      "You cannot use `-W' from "
-					      "iptables-restore");
-			}
-
-			parse_wait_interval(argc, argv, &wait_interval);
-			wait_interval_set = true;
-			break;
-
-		case '0':
-			set_option(&cs->options, OPT_LINENUMBERS,
-				   &args->invflags, invert);
-			break;
-
-		case 'M':
-			xtables_modprobe_program = optarg;
-			break;
-
-		case 'c':
-			set_option(&cs->options, OPT_COUNTERS, &args->invflags,
-				   invert);
-			args->pcnt = optarg;
-			args->bcnt = strchr(args->pcnt + 1, ',');
-			if (args->bcnt)
-			    args->bcnt++;
-			if (!args->bcnt && xs_has_arg(argc, argv))
-				args->bcnt = argv[optind++];
-			if (!args->bcnt)
-				xtables_error(PARAMETER_PROBLEM,
-					"-%c requires packet and byte counter",
-					opt2char(OPT_COUNTERS));
-
-			if (sscanf(args->pcnt, "%llu", &args->pcnt_cnt) != 1)
-				xtables_error(PARAMETER_PROBLEM,
-					"-%c packet counter not numeric",
-					opt2char(OPT_COUNTERS));
-
-			if (sscanf(args->bcnt, "%llu", &args->bcnt_cnt) != 1)
-				xtables_error(PARAMETER_PROBLEM,
-					"-%c byte counter not numeric",
-					opt2char(OPT_COUNTERS));
-			break;
-
-		case '4':
-			if (args->family == AF_INET)
-				break;
-
-			if (p->restore && args->family == AF_INET6)
-				return;
-
-			exit_tryhelp(2, line);
-
-		case '6':
-			if (args->family == AF_INET6)
-				break;
-
-			if (p->restore && args->family == AF_INET)
-				return;
-
-			exit_tryhelp(2, line);
-
-		case 1: /* non option */
-			if (optarg[0] == '!' && optarg[1] == '\0') {
-				if (invert)
-					xtables_error(PARAMETER_PROBLEM,
-						   "multiple consecutive ! not"
-						   " allowed");
-				invert = true;
-				optarg[0] = '\0';
-				continue;
-			}
-			fprintf(stderr, "Bad argument `%s'\n", optarg);
-			exit_tryhelp(2, line);
-
-		default:
-			if (command_default(cs, xt_params, invert))
-				/* cf. ip6tables.c */
-				continue;
-			break;
-		}
-		invert = false;
-	}
-
-	if (strcmp(p->table, "nat") == 0 &&
-	    ((p->policy != NULL && strcmp(p->policy, "DROP") == 0) ||
-	    (cs->jumpto != NULL && strcmp(cs->jumpto, "DROP") == 0)))
-		xtables_error(PARAMETER_PROBLEM,
-			"\nThe \"nat\" table is not intended for filtering, "
-			"the use of DROP is therefore inhibited.\n\n");
-
-	if (!wait && wait_interval_set)
-		xtables_error(PARAMETER_PROBLEM,
-			      "--wait-interval only makes sense with --wait\n");
-
-	for (matchp = cs->matches; matchp; matchp = matchp->next)
-		xtables_option_mfcall(matchp->match);
-	if (cs->target != NULL)
-		xtables_option_tfcall(cs->target);
-
-	/* Fix me: must put inverse options checking here --MN */
-
-	if (optind < argc)
-		xtables_error(PARAMETER_PROBLEM,
-			   "unknown arguments found on commandline");
-	if (!p->command)
-		xtables_error(PARAMETER_PROBLEM, "no command specified");
-	if (invert)
-		xtables_error(PARAMETER_PROBLEM,
-			   "nothing appropriate following !");
-
-	if (p->ops->post_parse)
-		p->ops->post_parse(p->command, cs, args);
-
-	if (p->command == CMD_REPLACE &&
-	    (args->s.naddrs != 1 || args->d.naddrs != 1))
-		xtables_error(PARAMETER_PROBLEM, "Replacement rule does not "
-			   "specify a unique address");
-
-	generic_opt_check(p->command, cs->options);
-
-	if (p->chain != NULL && strlen(p->chain) >= XT_EXTENSION_MAXNAMELEN)
-		xtables_error(PARAMETER_PROBLEM,
-			   "chain name `%s' too long (must be under %u chars)",
-			   p->chain, XT_EXTENSION_MAXNAMELEN);
-
-	if (p->command == CMD_APPEND ||
-	    p->command == CMD_DELETE ||
-	    p->command == CMD_DELETE_NUM ||
-	    p->command == CMD_CHECK ||
-	    p->command == CMD_INSERT ||
-	    p->command == CMD_REPLACE) {
-		if (strcmp(p->chain, "PREROUTING") == 0
-		    || strcmp(p->chain, "INPUT") == 0) {
-			/* -o not valid with incoming packets. */
-			if (cs->options & OPT_VIANAMEOUT)
-				xtables_error(PARAMETER_PROBLEM,
-					   "Can't use -%c with %s\n",
-					   opt2char(OPT_VIANAMEOUT),
-					   p->chain);
-		}
-
-		if (strcmp(p->chain, "POSTROUTING") == 0
-		    || strcmp(p->chain, "OUTPUT") == 0) {
-			/* -i not valid with outgoing packets */
-			if (cs->options & OPT_VIANAMEIN)
-				xtables_error(PARAMETER_PROBLEM,
-					   "Can't use -%c with %s\n",
-					   opt2char(OPT_VIANAMEIN),
-					   p->chain);
-		}
-	}
-}
-
 int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 		bool restore)
 {
@@ -703,6 +148,7 @@ int do_commandx(struct nft_handle *h, int argc, char *argv[], char **table,
 	struct xt_cmd_parse p = {
 		.table		= *table,
 		.restore	= restore,
+		.line		= line,
 		.ops		= &h->ops->cmd_parse,
 	};
 	struct iptables_command_state cs = {
-- 
2.34.1

