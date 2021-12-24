Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7FA5BC433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Dec 2021 17:18:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344145AbhLXRSL (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Dec 2021 12:18:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhLXRSK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Dec 2021 12:18:10 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D41CC061401
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Dec 2021 09:18:10 -0800 (PST)
Received: from localhost ([::1]:59084 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1n0oCm-0004vG-GH; Fri, 24 Dec 2021 18:18:08 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 11/11] ip6tables: Use the shared do_parse, too
Date:   Fri, 24 Dec 2021 18:17:54 +0100
Message-Id: <20211224171754.14210-12-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211224171754.14210-1-phil@nwl.cc>
References: <20211224171754.14210-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Same change as with iptables, merely have to set IP6T_F_PROTO flag in
ipv6_proto_parse().

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/ip6tables.c | 499 +++----------------------------------------
 iptables/xshared.c   |   4 +
 2 files changed, 37 insertions(+), 466 deletions(-)

diff --git a/iptables/ip6tables.c b/iptables/ip6tables.c
index b4604f83cf8a4..fa3e6c1506e71 100644
--- a/iptables/ip6tables.c
+++ b/iptables/ip6tables.c
@@ -90,21 +90,12 @@ static struct option original_opts[] = {
 struct xtables_globals ip6tables_globals = {
 	.option_offset = 0,
 	.program_version = PACKAGE_VERSION " (legacy)",
+	.optstring = OPTSTRING_COMMON "R:S::W::" "46bg:h::m:nvw::x",
 	.orig_opts = original_opts,
 	.compat_rev = xtables_compatible_revision,
+	.print_help = xtables_printhelp,
 };
 
-#define opts ip6tables_globals.opts
-#define prog_name ip6tables_globals.program_name
-#define prog_vers ip6tables_globals.program_version
-
-static void
-exit_printhelp(const struct xtables_rule_match *matches)
-{
-	xtables_printhelp(matches);
-	exit(0);
-}
-
 /*
  *	All functions starting with "parse" should succeed, otherwise
  *	the program fails.
@@ -114,15 +105,6 @@ exit_printhelp(const struct xtables_rule_match *matches)
  *	return global static data.
 */
 
-/* These are invalid numbers as upper layer protocol */
-static int is_exthdr(uint16_t proto)
-{
-	return (proto == IPPROTO_ROUTING ||
-		proto == IPPROTO_FRAGMENT ||
-		proto == IPPROTO_AH ||
-		proto == IPPROTO_DSTOPTS);
-}
-
 static int
 print_match(const struct xt_entry_match *m,
 	    const struct ip6t_ip6 *ip,
@@ -714,10 +696,21 @@ generate_entry(const struct ip6t_entry *fw,
 int do_command6(int argc, char *argv[], char **table,
 		struct xtc_handle **handle, bool restore)
 {
+	struct xt_cmd_parse p = {
+		.table		= *table,
+		.restore	= restore,
+		.line		= line,
+		.proto_parse	= ipv6_proto_parse,
+		.post_parse	= ipv6_post_parse,
+	};
 	struct iptables_command_state cs = {
 		.jumpto	= "",
 		.argv	= argv,
 	};
+	struct xtables_args args = {
+		.family = AF_INET6,
+		.wait_interval.tv_sec = 1,
+	};
 	struct ip6t_entry *e = NULL;
 	unsigned int nsaddrs = 0, ndaddrs = 0;
 	struct in6_addr *saddrs = NULL, *daddrs = NULL;
@@ -728,437 +721,28 @@ int do_command6(int argc, char *argv[], char **table,
 	struct timeval wait_interval = {
 		.tv_sec	= 1,
 	};
-	bool wait_interval_set = false;
 	const char *chain = NULL;
-	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
 	const char *policy = NULL, *newname = NULL;
 	unsigned int rulenum = 0, command = 0;
-	const char *pcnt = NULL, *bcnt = NULL;
 	int ret = 1;
-	struct xtables_match *m;
-	struct xtables_rule_match *matchp;
-	struct xtables_target *t;
-	unsigned long long cnt;
-	bool table_set = false;
-	uint16_t invflags = 0;
-	bool invert = false;
-
-	/* re-set optind to 0 in case do_command6 gets called
-	 * a second time */
-	optind = 0;
-
-	/* clear mflags in case do_command6 gets called a second time
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
-           demand-load a protocol. */
-	opterr = 0;
-
-	opts = xt_params->orig_opts;
-	while ((cs.c = getopt_long(argc, argv,
-	   "-:A:C:D:R:I:L::S::M:F::Z::N:X::E:P:Vh::o:p:s:d:j:i:bvw::W::nt:m:xc:g:46",
-					   opts, NULL)) != -1) {
-		switch (cs.c) {
-			/*
-			 * Command selection
-			 */
-		case 'A':
-			add_command(&command, CMD_APPEND, CMD_NONE, invert);
-			chain = optarg;
-			break;
-
-		case 'C':
-			add_command(&command, CMD_CHECK, CMD_NONE, invert);
-			chain = optarg;
-			break;
-
-		case 'D':
-			add_command(&command, CMD_DELETE, CMD_NONE, invert);
-			chain = optarg;
-			if (xs_has_arg(argc, argv)) {
-				rulenum = parse_rulenumber(argv[optind++]);
-				command = CMD_DELETE_NUM;
-			}
-			break;
-
-		case 'R':
-			add_command(&command, CMD_REPLACE, CMD_NONE, invert);
-			chain = optarg;
-			if (xs_has_arg(argc, argv))
-				rulenum = parse_rulenumber(argv[optind++]);
-			else
-				xtables_error(PARAMETER_PROBLEM,
-					   "-%c requires a rule number",
-					   cmd2char(CMD_REPLACE));
-			break;
-
-		case 'I':
-			add_command(&command, CMD_INSERT, CMD_NONE, invert);
-			chain = optarg;
-			if (xs_has_arg(argc, argv))
-				rulenum = parse_rulenumber(argv[optind++]);
-			else rulenum = 1;
-			break;
-
-		case 'L':
-			add_command(&command, CMD_LIST,
-				    CMD_ZERO | CMD_ZERO_NUM, invert);
-			if (optarg) chain = optarg;
-			else if (xs_has_arg(argc, argv))
-				chain = argv[optind++];
-			if (xs_has_arg(argc, argv))
-				rulenum = parse_rulenumber(argv[optind++]);
-			break;
-
-		case 'S':
-			add_command(&command, CMD_LIST_RULES,
-				    CMD_ZERO | CMD_ZERO_NUM, invert);
-			if (optarg) chain = optarg;
-			else if (xs_has_arg(argc, argv))
-				chain = argv[optind++];
-			if (xs_has_arg(argc, argv))
-				rulenum = parse_rulenumber(argv[optind++]);
-			break;
-
-		case 'F':
-			add_command(&command, CMD_FLUSH, CMD_NONE, invert);
-			if (optarg) chain = optarg;
-			else if (xs_has_arg(argc, argv))
-				chain = argv[optind++];
-			break;
-
-		case 'Z':
-			add_command(&command, CMD_ZERO, CMD_LIST|CMD_LIST_RULES,
-				    invert);
-			if (optarg) chain = optarg;
-			else if (xs_has_arg(argc, argv))
-				chain = argv[optind++];
-			if (xs_has_arg(argc, argv)) {
-				rulenum = parse_rulenumber(argv[optind++]);
-				command = CMD_ZERO_NUM;
-			}
-			break;
-
-		case 'N':
-			parse_chain(optarg);
-			add_command(&command, CMD_NEW_CHAIN, CMD_NONE, invert);
-			chain = optarg;
-			break;
-
-		case 'X':
-			add_command(&command, CMD_DELETE_CHAIN, CMD_NONE,
-				    invert);
-			if (optarg) chain = optarg;
-			else if (xs_has_arg(argc, argv))
-				chain = argv[optind++];
-			break;
-
-		case 'E':
-			add_command(&command, CMD_RENAME_CHAIN, CMD_NONE,
-				    invert);
-			chain = optarg;
-			if (xs_has_arg(argc, argv))
-				newname = argv[optind++];
-			else
-				xtables_error(PARAMETER_PROBLEM,
-					   "-%c requires old-chain-name and "
-					   "new-chain-name",
-					    cmd2char(CMD_RENAME_CHAIN));
-			break;
-
-		case 'P':
-			add_command(&command, CMD_SET_POLICY, CMD_NONE,
-				    invert);
-			chain = optarg;
-			if (xs_has_arg(argc, argv))
-				policy = argv[optind++];
-			else
-				xtables_error(PARAMETER_PROBLEM,
-					   "-%c requires a chain and a policy",
-					   cmd2char(CMD_SET_POLICY));
-			break;
-
-		case 'h':
-			if (!optarg)
-				optarg = argv[optind];
 
-			/* ip6tables -p icmp -h */
-			if (!cs.matches && cs.protocol)
-				xtables_find_match(cs.protocol, XTF_TRY_LOAD,
-					&cs.matches);
-
-			exit_printhelp(cs.matches);
-
-			/*
-			 * Option selection
-			 */
-		case 'p':
-			set_option(&cs.options, OPT_PROTOCOL, &invflags,
-				   invert);
-
-			/* Canonicalize into lower case */
-			for (cs.protocol = optarg; *cs.protocol; cs.protocol++)
-				*cs.protocol = tolower(*cs.protocol);
-
-			cs.protocol = optarg;
-			cs.fw6.ipv6.proto = xtables_parse_protocol(cs.protocol);
-			cs.fw6.ipv6.flags |= IP6T_F_PROTO;
-
-			if (cs.fw6.ipv6.proto == 0 && (invflags & XT_INV_PROTO))
-				xtables_error(PARAMETER_PROBLEM,
-					   "rule would never match protocol");
-
-			if (is_exthdr(cs.fw6.ipv6.proto)
-			    && (invflags & XT_INV_PROTO) == 0)
-				fprintf(stderr,
-					"Warning: never matched protocol: %s. "
-					"use extension match instead.\n",
-					cs.protocol);
-			break;
-
-		case 's':
-			set_option(&cs.options, OPT_SOURCE, &invflags, invert);
-			shostnetworkmask = optarg;
-			break;
-
-		case 'd':
-			set_option(&cs.options, OPT_DESTINATION, &invflags,
-				   invert);
-			dhostnetworkmask = optarg;
-			break;
-
-#ifdef IP6T_F_GOTO
-		case 'g':
-			set_option(&cs.options, OPT_JUMP, &invflags, invert);
-			cs.fw6.ipv6.flags |= IP6T_F_GOTO;
-			cs.jumpto = xt_parse_target(optarg);
-			break;
-#endif
-
-		case 'j':
-			set_option(&cs.options, OPT_JUMP, &invflags, invert);
-			command_jump(&cs, optarg);
-			break;
-
-
-		case 'i':
-			if (*optarg == '\0')
-				xtables_error(PARAMETER_PROBLEM,
-					"Empty interface is likely to be "
-					"undesired");
-			set_option(&cs.options, OPT_VIANAMEIN, &invflags,
-				   invert);
-			xtables_parse_interface(optarg,
-					cs.fw6.ipv6.iniface,
-					cs.fw6.ipv6.iniface_mask);
-			break;
-
-		case 'o':
-			if (*optarg == '\0')
-				xtables_error(PARAMETER_PROBLEM,
-					"Empty interface is likely to be "
-					"undesired");
-			set_option(&cs.options, OPT_VIANAMEOUT, &invflags,
-				   invert);
-			xtables_parse_interface(optarg,
-					cs.fw6.ipv6.outiface,
-					cs.fw6.ipv6.outiface_mask);
-			break;
-
-		case 'v':
-			if (!verbose)
-				set_option(&cs.options, OPT_VERBOSE,
-					   &invflags, invert);
-			verbose++;
-			break;
-
-		case 'w':
-			if (restore) {
-				xtables_error(PARAMETER_PROBLEM,
-					      "You cannot use `-w' from "
-					      "ip6tables-restore");
-			}
-			wait = parse_wait_time(argc, argv);
-			break;
-
-		case 'W':
-			if (restore) {
-				xtables_error(PARAMETER_PROBLEM,
-					      "You cannot use `-W' from "
-					      "ip6tables-restore");
-			}
-			parse_wait_interval(argc, argv, &wait_interval);
-			wait_interval_set = true;
-			break;
-
-		case 'm':
-			command_match(&cs, invert);
-			break;
-
-		case 'n':
-			set_option(&cs.options, OPT_NUMERIC, &invflags, invert);
-			break;
-
-		case 't':
-			if (invert)
-				xtables_error(PARAMETER_PROBLEM,
-					   "unexpected ! flag before --table");
-			if (restore && table_set)
-				xtables_error(PARAMETER_PROBLEM,
-					      "The -t option cannot be used in %s.\n",
-					      xt_params->program_name);
-			*table = optarg;
-			table_set = true;
-			break;
-
-		case 'x':
-			set_option(&cs.options, OPT_EXPANDED, &invflags,
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
-		case '0':
-			set_option(&cs.options, OPT_LINENUMBERS, &invflags,
-				   invert);
-			break;
-
-		case 'M':
-			xtables_modprobe_program = optarg;
-			break;
-
-		case 'c':
-
-			set_option(&cs.options, OPT_COUNTERS, &invflags,
-				   invert);
-			pcnt = optarg;
-			bcnt = strchr(pcnt + 1, ',');
-			if (bcnt)
-			    bcnt++;
-			if (!bcnt && xs_has_arg(argc, argv))
-				bcnt = argv[optind++];
-			if (!bcnt)
-				xtables_error(PARAMETER_PROBLEM,
-					"-%c requires packet and byte counter",
-					opt2char(OPT_COUNTERS));
-
-			if (sscanf(pcnt, "%llu", &cnt) != 1)
-				xtables_error(PARAMETER_PROBLEM,
-					"-%c packet counter not numeric",
-					opt2char(OPT_COUNTERS));
-			cs.fw6.counters.pcnt = cnt;
-
-			if (sscanf(bcnt, "%llu", &cnt) != 1)
-				xtables_error(PARAMETER_PROBLEM,
-					"-%c byte counter not numeric",
-					opt2char(OPT_COUNTERS));
-			cs.fw6.counters.bcnt = cnt;
-			break;
-
-		case '4':
-			/* This is not the IPv4 iptables */
-			if (line != -1)
-				return 1; /* success: line ignored */
-			fprintf(stderr, "This is the IPv6 version of ip6tables.\n");
-			exit_tryhelp(2, line);
-
-		case '6':
-			/* This is indeed the IPv6 ip6tables */
-			break;
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
-			if (command_default(&cs, &ip6tables_globals, invert))
-				/*
-				 * If new options were loaded, we must retry
-				 * getopt immediately and not allow
-				 * invert=false to be executed.
-				 */
-				continue;
-			break;
-		}
-		invert = false;
-	}
-
-	if (!wait && wait_interval_set)
-		xtables_error(PARAMETER_PROBLEM,
-			      "--wait-interval only makes sense with --wait\n");
-
-	if (strcmp(*table, "nat") == 0 &&
-	    ((policy != NULL && strcmp(policy, "DROP") == 0) ||
-	    (cs.jumpto != NULL && strcmp(cs.jumpto, "DROP") == 0)))
-		xtables_error(PARAMETER_PROBLEM,
-			"\nThe \"nat\" table is not intended for filtering, "
-		        "the use of DROP is therefore inhibited.\n\n");
-
-	for (matchp = cs.matches; matchp; matchp = matchp->next)
-		xtables_option_mfcall(matchp->match);
-	if (cs.target != NULL)
-		xtables_option_tfcall(cs.target);
-
-	/* Fix me: must put inverse options checking here --MN */
-
-	if (optind < argc)
-		xtables_error(PARAMETER_PROBLEM,
-			   "unknown arguments found on commandline");
-	if (!command)
-		xtables_error(PARAMETER_PROBLEM, "no command specified");
-	if (invert)
-		xtables_error(PARAMETER_PROBLEM,
-			   "nothing appropriate following !");
-
-	cs.fw6.ipv6.invflags = invflags;
-
-	if (command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND | CMD_CHECK)) {
-		if (!(cs.options & OPT_DESTINATION))
-			dhostnetworkmask = "::0/0";
-		if (!(cs.options & OPT_SOURCE))
-			shostnetworkmask = "::0/0";
-	}
-
-	if (shostnetworkmask)
-		xtables_ip6parse_multiple(shostnetworkmask, &saddrs,
-					  &smasks, &nsaddrs);
-
-	if (dhostnetworkmask)
-		xtables_ip6parse_multiple(dhostnetworkmask, &daddrs,
-					  &dmasks, &ndaddrs);
-
-	if ((nsaddrs > 1 || ndaddrs > 1) &&
-	    (cs.fw6.ipv6.invflags & (IP6T_INV_SRCIP | IP6T_INV_DSTIP)))
-		xtables_error(PARAMETER_PROBLEM, "! not allowed with multiple"
-			   " source or destination IP addresses");
-
-	if (command == CMD_REPLACE && (nsaddrs != 1 || ndaddrs != 1))
-		xtables_error(PARAMETER_PROBLEM, "Replacement rule does not "
-			   "specify a unique address");
-
-	generic_opt_check(command, cs.options);
+	do_parse(argc, argv, &p, &cs, &args);
+
+	command		= p.command;
+	chain		= p.chain;
+	*table		= p.table;
+	rulenum		= p.rulenum;
+	policy		= p.policy;
+	newname		= p.newname;
+	verbose		= p.verbose;
+	wait		= args.wait;
+	wait_interval	= args.wait_interval;
+	nsaddrs		= args.s.naddrs;
+	ndaddrs		= args.d.naddrs;
+	saddrs		= args.s.addr.v6;
+	daddrs		= args.d.addr.v6;
+	smasks		= args.s.mask.v6;
+	dmasks		= args.d.mask.v6;
 
 	/* Attempt to acquire the xtables lock */
 	if (!restore)
@@ -1182,26 +766,6 @@ int do_command6(int argc, char *argv[], char **table,
 	    || command == CMD_CHECK
 	    || command == CMD_INSERT
 	    || command == CMD_REPLACE) {
-		if (strcmp(chain, "PREROUTING") == 0
-		    || strcmp(chain, "INPUT") == 0) {
-			/* -o not valid with incoming packets. */
-			if (cs.options & OPT_VIANAMEOUT)
-				xtables_error(PARAMETER_PROBLEM,
-					   "Can't use -%c with %s\n",
-					   opt2char(OPT_VIANAMEOUT),
-					   chain);
-		}
-
-		if (strcmp(chain, "POSTROUTING") == 0
-		    || strcmp(chain, "OUTPUT") == 0) {
-			/* -i not valid with outgoing packets */
-			if (cs.options & OPT_VIANAMEIN)
-				xtables_error(PARAMETER_PROBLEM,
-					   "Can't use -%c with %s\n",
-					   opt2char(OPT_VIANAMEIN),
-					   chain);
-		}
-
 		if (cs.target && ip6tc_is_chain(cs.jumpto, *handle)) {
 			fprintf(stderr,
 				"Warning: using chain %s, not extension\n",
@@ -1337,6 +901,9 @@ int do_command6(int argc, char *argv[], char **table,
 	case CMD_SET_POLICY:
 		ret = ip6tc_set_policy(chain, policy, cs.options&OPT_COUNTERS ? &cs.fw6.counters : NULL, *handle);
 		break;
+	case CMD_NONE:
+	/* do_parse ignored the line (eg: -4 with ip6tables-restore) */
+		break;
 	default:
 		/* We should never reach this... */
 		exit_tryhelp(2, line);
diff --git a/iptables/xshared.c b/iptables/xshared.c
index 1bce6715c3a9a..3b363e72361e0 100644
--- a/iptables/xshared.c
+++ b/iptables/xshared.c
@@ -1836,6 +1836,10 @@ void ipv6_proto_parse(struct iptables_command_state *cs,
 	cs->fw6.ipv6.proto = args->proto;
 	cs->fw6.ipv6.invflags = args->invflags;
 
+	/* this is needed for ip6tables-legacy only */
+	args->flags |= IP6T_F_PROTO;
+	cs->fw6.ipv6.flags |= IP6T_F_PROTO;
+
 	if (is_exthdr(cs->fw6.ipv6.proto)
 	    && (cs->fw6.ipv6.invflags & XT_INV_PROTO) == 0)
 		fprintf(stderr,
-- 
2.34.1

