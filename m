Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29A7AC433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Oct 2021 12:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 121616058D
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Oct 2021 12:27:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235622AbhJOM3B (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Oct 2021 08:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235602AbhJOM2v (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Oct 2021 08:28:51 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C905C061762
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Oct 2021 05:26:45 -0700 (PDT)
Received: from localhost ([::1]:33854 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mbMIN-0002UM-Sl; Fri, 15 Oct 2021 14:26:43 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 08/13] arptables: Use standard data structures when parsing
Date:   Fri, 15 Oct 2021 14:26:03 +0200
Message-Id: <20211015122608.12474-9-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211015122608.12474-1-phil@nwl.cc>
References: <20211015122608.12474-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the compound data structures introduced for dedicated parsing
routines in other families instead of the many local variables. This
allows to standardize code a bit for sharing a common parser later.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-arp.c | 280 ++++++++++++++++++++---------------------
 1 file changed, 138 insertions(+), 142 deletions(-)

diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 2e4bb3f2313c8..1075b6be74e98 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -419,17 +419,13 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 			.arhrd_mask = 65535,
 		},
 	};
+	struct nft_xt_cmd_parse p = {
+		.table = *table,
+	};
+	struct xtables_args args = {
+		.family = h->family,
+	};
 	int invert = 0;
-	unsigned int nsaddrs = 0, ndaddrs = 0;
-	struct in_addr *saddrs = NULL, *smasks = NULL;
-	struct in_addr *daddrs = NULL, *dmasks = NULL;
-
-	int c, verbose = 0;
-	const char *chain = NULL;
-	const char *shostnetworkmask = NULL, *dhostnetworkmask = NULL;
-	const char *policy = NULL, *newname = NULL;
-	unsigned int rulenum = 0, options = 0, command = 0;
-	const char *pcnt = NULL, *bcnt = NULL;
 	int ret = 1;
 	struct xtables_target *t;
 
@@ -447,34 +443,34 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 	opterr = 0;
 
 	opts = xt_params->orig_opts;
-	while ((c = getopt_long(argc, argv, xt_params->optstring,
+	while ((cs.c = getopt_long(argc, argv, xt_params->optstring,
 					   opts, NULL)) != -1) {
-		switch (c) {
+		switch (cs.c) {
 			/*
 			 * Command selection
 			 */
 		case 'A':
-			add_command(&command, CMD_APPEND, CMD_NONE,
+			add_command(&p.command, CMD_APPEND, CMD_NONE,
 				    invert);
-			chain = optarg;
+			p.chain = optarg;
 			break;
 
 		case 'D':
-			add_command(&command, CMD_DELETE, CMD_NONE,
+			add_command(&p.command, CMD_DELETE, CMD_NONE,
 				    invert);
-			chain = optarg;
+			p.chain = optarg;
 			if (xs_has_arg(argc, argv)) {
-				rulenum = parse_rulenumber(argv[optind++]);
-				command = CMD_DELETE_NUM;
+				p.rulenum = parse_rulenumber(argv[optind++]);
+				p.command = CMD_DELETE_NUM;
 			}
 			break;
 
 		case 'R':
-			add_command(&command, CMD_REPLACE, CMD_NONE,
+			add_command(&p.command, CMD_REPLACE, CMD_NONE,
 				    invert);
-			chain = optarg;
+			p.chain = optarg;
 			if (xs_has_arg(argc, argv))
-				rulenum = parse_rulenumber(argv[optind++]);
+				p.rulenum = parse_rulenumber(argv[optind++]);
 			else
 				xtables_error(PARAMETER_PROBLEM,
 					      "-%c requires a rule number",
@@ -482,36 +478,36 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 			break;
 
 		case 'I':
-			add_command(&command, CMD_INSERT, CMD_NONE,
+			add_command(&p.command, CMD_INSERT, CMD_NONE,
 				    invert);
-			chain = optarg;
+			p.chain = optarg;
 			if (xs_has_arg(argc, argv))
-				rulenum = parse_rulenumber(argv[optind++]);
-			else rulenum = 1;
+				p.rulenum = parse_rulenumber(argv[optind++]);
+			else p.rulenum = 1;
 			break;
 
 		case 'L':
-			add_command(&command, CMD_LIST, CMD_ZERO,
+			add_command(&p.command, CMD_LIST, CMD_ZERO,
 				    invert);
-			if (optarg) chain = optarg;
+			if (optarg) p.chain = optarg;
 			else if (xs_has_arg(argc, argv))
-				chain = argv[optind++];
+				p.chain = argv[optind++];
 			break;
 
 		case 'F':
-			add_command(&command, CMD_FLUSH, CMD_NONE,
+			add_command(&p.command, CMD_FLUSH, CMD_NONE,
 				    invert);
-			if (optarg) chain = optarg;
+			if (optarg) p.chain = optarg;
 			else if (xs_has_arg(argc, argv))
-				chain = argv[optind++];
+				p.chain = argv[optind++];
 			break;
 
 		case 'Z':
-			add_command(&command, CMD_ZERO, CMD_LIST,
+			add_command(&p.command, CMD_ZERO, CMD_LIST,
 				    invert);
-			if (optarg) chain = optarg;
+			if (optarg) p.chain = optarg;
 			else if (xs_has_arg(argc, argv))
-				chain = argv[optind++];
+				p.chain = argv[optind++];
 			break;
 
 		case 'N':
@@ -523,25 +519,25 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 				xtables_error(PARAMETER_PROBLEM,
 						"chain name may not clash "
 						"with target name\n");
-			add_command(&command, CMD_NEW_CHAIN, CMD_NONE,
+			add_command(&p.command, CMD_NEW_CHAIN, CMD_NONE,
 				    invert);
-			chain = optarg;
+			p.chain = optarg;
 			break;
 
 		case 'X':
-			add_command(&command, CMD_DELETE_CHAIN, CMD_NONE,
+			add_command(&p.command, CMD_DELETE_CHAIN, CMD_NONE,
 				    invert);
-			if (optarg) chain = optarg;
+			if (optarg) p.chain = optarg;
 			else if (xs_has_arg(argc, argv))
-				chain = argv[optind++];
+				p.chain = argv[optind++];
 			break;
 
 		case 'E':
-			add_command(&command, CMD_RENAME_CHAIN, CMD_NONE,
+			add_command(&p.command, CMD_RENAME_CHAIN, CMD_NONE,
 				    invert);
-			chain = optarg;
+			p.chain = optarg;
 			if (xs_has_arg(argc, argv))
-				newname = argv[optind++];
+				p.newname = argv[optind++];
 			else
 				xtables_error(PARAMETER_PROBLEM,
 					      "-%c requires old-chain-name and "
@@ -550,11 +546,11 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 			break;
 
 		case 'P':
-			add_command(&command, CMD_SET_POLICY, CMD_NONE,
+			add_command(&p.command, CMD_SET_POLICY, CMD_NONE,
 				    invert);
-			chain = optarg;
+			p.chain = optarg;
 			if (xs_has_arg(argc, argv))
-				policy = argv[optind++];
+				p.policy = argv[optind++];
 			else
 				xtables_error(PARAMETER_PROBLEM,
 					      "-%c requires a chain and a policy",
@@ -566,25 +562,25 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 				optarg = argv[optind];
 
 			xt_params->print_help(NULL);
-			command = CMD_NONE;
+			p.command = CMD_NONE;
 			break;
 		case 's':
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_SOURCE, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_SOURCE, &cs.arp.arp.invflags,
 				   invert);
-			shostnetworkmask = argv[optind-1];
+			args.shostnetworkmask = argv[optind-1];
 			break;
 
 		case 'd':
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_DESTINATION, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_DESTINATION, &cs.arp.arp.invflags,
 				   invert);
-			dhostnetworkmask = argv[optind-1];
+			args.dhostnetworkmask = argv[optind-1];
 			break;
 
 		case 2:/* src-mac */
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_S_MAC, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_S_MAC, &cs.arp.arp.invflags,
 				   invert);
 			if (xtables_parse_mac_and_mask(argv[optind - 1],
 			    cs.arp.arp.src_devaddr.addr, cs.arp.arp.src_devaddr.mask))
@@ -594,7 +590,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 
 		case 3:/* dst-mac */
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_D_MAC, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_D_MAC, &cs.arp.arp.invflags,
 				   invert);
 
 			if (xtables_parse_mac_and_mask(argv[optind - 1],
@@ -605,7 +601,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 
 		case 'l':/* hardware length */
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_H_LENGTH, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_H_LENGTH, &cs.arp.arp.invflags,
 				   invert);
 			getlength_and_mask(argv[optind - 1], &cs.arp.arp.arhln,
 					   &cs.arp.arp.arhln_mask);
@@ -622,7 +618,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 			xtables_error(PARAMETER_PROBLEM, "not supported");
 		case 4:/* opcode */
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_OPCODE, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_OPCODE, &cs.arp.arp.invflags,
 				   invert);
 			if (get16_and_mask(argv[optind - 1], &cs.arp.arp.arpop,
 					   &cs.arp.arp.arpop_mask, 10)) {
@@ -639,7 +635,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 
 		case 5:/* h-type */
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_H_TYPE, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_H_TYPE, &cs.arp.arp.invflags,
 				   invert);
 			if (get16_and_mask(argv[optind - 1], &cs.arp.arp.arhrd,
 					   &cs.arp.arp.arhrd_mask, 16)) {
@@ -651,7 +647,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 
 		case 6:/* proto-type */
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_P_TYPE, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_P_TYPE, &cs.arp.arp.invflags,
 				   invert);
 			if (get16_and_mask(argv[optind - 1], &cs.arp.arp.arpro,
 					   &cs.arp.arp.arpro_mask, 0)) {
@@ -662,14 +658,14 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 			break;
 
 		case 'j':
-			set_option(&options, OPT_JUMP, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_JUMP, &cs.arp.arp.invflags,
 				   invert);
 			command_jump(&cs, optarg);
 			break;
 
 		case 'i':
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_VIANAMEIN, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_VIANAMEIN, &cs.arp.arp.invflags,
 				   invert);
 			xtables_parse_interface(argv[optind-1],
 						cs.arp.arp.iniface,
@@ -678,7 +674,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 
 		case 'o':
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&options, OPT_VIANAMEOUT, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_VIANAMEOUT, &cs.arp.arp.invflags,
 				   invert);
 			xtables_parse_interface(argv[optind-1],
 						cs.arp.arp.outiface,
@@ -686,16 +682,16 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 			break;
 
 		case 'v':
-			if (!verbose)
-				set_option(&options, OPT_VERBOSE,
+			if (!p.verbose)
+				set_option(&cs.options, OPT_VERBOSE,
 					   &cs.arp.arp.invflags, invert);
-			verbose++;
+			p.verbose++;
 			break;
 
 		case 'm': /* ignored by arptables-legacy */
 			break;
 		case 'n':
-			set_option(&options, OPT_NUMERIC, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_NUMERIC, &cs.arp.arp.invflags,
 				   invert);
 			break;
 
@@ -719,7 +715,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 			exit(0);
 
 		case '0':
-			set_option(&options, OPT_LINENUMBERS, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_LINENUMBERS, &cs.arp.arp.invflags,
 				   invert);
 			break;
 
@@ -729,22 +725,22 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 
 		case 'c':
 
-			set_option(&options, OPT_COUNTERS, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_COUNTERS, &cs.arp.arp.invflags,
 				   invert);
-			pcnt = optarg;
+			args.pcnt = optarg;
 			if (xs_has_arg(argc, argv))
-				bcnt = argv[optind++];
+				args.bcnt = argv[optind++];
 			else
 				xtables_error(PARAMETER_PROBLEM,
 					      "-%c requires packet and byte counter",
 					      opt2char(OPT_COUNTERS));
 
-			if (sscanf(pcnt, "%llu", &cs.arp.counters.pcnt) != 1)
+			if (sscanf(args.pcnt, "%llu", &cs.arp.counters.pcnt) != 1)
 			xtables_error(PARAMETER_PROBLEM,
 				"-%c packet counter not numeric",
 				opt2char(OPT_COUNTERS));
 
-			if (sscanf(bcnt, "%llu", &cs.arp.counters.bcnt) != 1)
+			if (sscanf(args.bcnt, "%llu", &cs.arp.counters.bcnt) != 1)
 				xtables_error(PARAMETER_PROBLEM,
 					      "-%c byte counter not numeric",
 					      opt2char(OPT_COUNTERS));
@@ -767,7 +763,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 
 		default:
 			if (cs.target) {
-				xtables_option_tpcall(c, argv,
+				xtables_option_tpcall(cs.c, argv,
 						      invert, cs.target, &cs.arp);
 			}
 			break;
@@ -785,127 +781,127 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 		xtables_error(PARAMETER_PROBLEM,
 			      "nothing appropriate following !");
 
-	if (command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND)) {
-		if (!(options & OPT_DESTINATION))
-			dhostnetworkmask = "0.0.0.0/0";
-		if (!(options & OPT_SOURCE))
-			shostnetworkmask = "0.0.0.0/0";
+	if (p.command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND)) {
+		if (!(cs.options & OPT_DESTINATION))
+			args.dhostnetworkmask = "0.0.0.0/0";
+		if (!(cs.options & OPT_SOURCE))
+			args.shostnetworkmask = "0.0.0.0/0";
 	}
 
-	if (shostnetworkmask)
-		xtables_ipparse_multiple(shostnetworkmask, &saddrs,
-					 &smasks, &nsaddrs);
+	if (args.shostnetworkmask)
+		xtables_ipparse_multiple(args.shostnetworkmask, &args.s.addr.v4,
+					 &args.s.mask.v4, &args.s.naddrs);
 
-	if (dhostnetworkmask)
-		xtables_ipparse_multiple(dhostnetworkmask, &daddrs,
-					 &dmasks, &ndaddrs);
+	if (args.dhostnetworkmask)
+		xtables_ipparse_multiple(args.dhostnetworkmask, &args.d.addr.v4,
+					 &args.d.mask.v4, &args.d.naddrs);
 
-	if ((nsaddrs > 1 || ndaddrs > 1) &&
+	if ((args.s.naddrs > 1 || args.d.naddrs > 1) &&
 	    (cs.arp.arp.invflags & (IPT_INV_SRCIP | IPT_INV_DSTIP)))
 		xtables_error(PARAMETER_PROBLEM, "! not allowed with multiple"
 				" source or destination IP addresses");
 
-	if (command == CMD_REPLACE && (nsaddrs != 1 || ndaddrs != 1))
+	if (p.command == CMD_REPLACE && (args.s.naddrs != 1 || args.d.naddrs != 1))
 		xtables_error(PARAMETER_PROBLEM, "Replacement rule does not "
 						 "specify a unique address");
 
-	if (chain && strlen(chain) > ARPT_FUNCTION_MAXNAMELEN)
+	if (p.chain && strlen(p.chain) > ARPT_FUNCTION_MAXNAMELEN)
 		xtables_error(PARAMETER_PROBLEM,
 				"chain name `%s' too long (must be under %i chars)",
-				chain, ARPT_FUNCTION_MAXNAMELEN);
-
-	if (command == CMD_APPEND
-	    || command == CMD_DELETE
-	    || command == CMD_INSERT
-	    || command == CMD_REPLACE) {
-		if (strcmp(chain, "PREROUTING") == 0
-		    || strcmp(chain, "INPUT") == 0) {
+				p.chain, ARPT_FUNCTION_MAXNAMELEN);
+
+	if (p.command == CMD_APPEND
+	    || p.command == CMD_DELETE
+	    || p.command == CMD_INSERT
+	    || p.command == CMD_REPLACE) {
+		if (strcmp(p.chain, "PREROUTING") == 0
+		    || strcmp(p.chain, "INPUT") == 0) {
 			/* -o not valid with incoming packets. */
-			if (options & OPT_VIANAMEOUT)
+			if (cs.options & OPT_VIANAMEOUT)
 				xtables_error(PARAMETER_PROBLEM,
 					      "Can't use -%c with %s\n",
 					      opt2char(OPT_VIANAMEOUT),
-					      chain);
+					      p.chain);
 		}
 
-		if (strcmp(chain, "POSTROUTING") == 0
-		    || strcmp(chain, "OUTPUT") == 0) {
+		if (strcmp(p.chain, "POSTROUTING") == 0
+		    || strcmp(p.chain, "OUTPUT") == 0) {
 			/* -i not valid with outgoing packets */
-			if (options & OPT_VIANAMEIN)
+			if (cs.options & OPT_VIANAMEIN)
 				xtables_error(PARAMETER_PROBLEM,
 						"Can't use -%c with %s\n",
 						opt2char(OPT_VIANAMEIN),
-						chain);
+						p.chain);
 		}
 	}
 
-	switch (command) {
+	switch (p.command) {
 	case CMD_APPEND:
-		ret = append_entry(h, chain, *table, &cs, 0,
-				   nsaddrs, saddrs, smasks,
-				   ndaddrs, daddrs, dmasks,
-				   options&OPT_VERBOSE, true);
+		ret = append_entry(h, p.chain, p.table, &cs, 0,
+				   args.s.naddrs, args.s.addr.v4, args.s.mask.v4,
+				   args.d.naddrs, args.d.addr.v4, args.d.mask.v4,
+				   cs.options&OPT_VERBOSE, true);
 		break;
 	case CMD_DELETE:
-		ret = delete_entry(chain, *table, &cs,
-				   nsaddrs, saddrs, smasks,
-				   ndaddrs, daddrs, dmasks,
-				   options&OPT_VERBOSE, h);
+		ret = delete_entry(p.chain, p.table, &cs,
+				   args.s.naddrs, args.s.addr.v4, args.s.mask.v4,
+				   args.d.naddrs, args.d.addr.v4, args.d.mask.v4,
+				   cs.options&OPT_VERBOSE, h);
 		break;
 	case CMD_DELETE_NUM:
-		ret = nft_cmd_rule_delete_num(h, chain, *table, rulenum - 1, verbose);
+		ret = nft_cmd_rule_delete_num(h, p.chain, p.table, p.rulenum - 1, p.verbose);
 		break;
 	case CMD_REPLACE:
-		ret = replace_entry(chain, *table, &cs, rulenum - 1,
-				    saddrs, smasks, daddrs, dmasks,
-				    options&OPT_VERBOSE, h);
+		ret = replace_entry(p.chain, p.table, &cs, p.rulenum - 1,
+				    args.s.addr.v4, args.s.mask.v4, args.d.addr.v4, args.d.mask.v4,
+				    cs.options&OPT_VERBOSE, h);
 		break;
 	case CMD_INSERT:
-		ret = append_entry(h, chain, *table, &cs, rulenum - 1,
-				   nsaddrs, saddrs, smasks,
-				   ndaddrs, daddrs, dmasks,
-				   options&OPT_VERBOSE, false);
+		ret = append_entry(h, p.chain, p.table, &cs, p.rulenum - 1,
+				   args.s.naddrs, args.s.addr.v4, args.s.mask.v4,
+				   args.d.naddrs, args.d.addr.v4, args.d.mask.v4,
+				   cs.options&OPT_VERBOSE, false);
 		break;
 	case CMD_LIST:
-		ret = list_entries(h, chain, *table,
-				   rulenum,
-				   options&OPT_VERBOSE,
-				   options&OPT_NUMERIC,
-				   /*options&OPT_EXPANDED*/0,
-				   options&OPT_LINENUMBERS);
+		ret = list_entries(h, p.chain, p.table,
+				   p.rulenum,
+				   cs.options&OPT_VERBOSE,
+				   cs.options&OPT_NUMERIC,
+				   /*cs.options&OPT_EXPANDED*/0,
+				   cs.options&OPT_LINENUMBERS);
 		break;
 	case CMD_FLUSH:
-		ret = nft_cmd_rule_flush(h, chain, *table, options & OPT_VERBOSE);
+		ret = nft_cmd_rule_flush(h, p.chain, p.table, cs.options & OPT_VERBOSE);
 		break;
 	case CMD_ZERO:
-		ret = nft_cmd_chain_zero_counters(h, chain, *table,
-					      options & OPT_VERBOSE);
+		ret = nft_cmd_chain_zero_counters(h, p.chain, p.table,
+					      cs.options & OPT_VERBOSE);
 		break;
 	case CMD_LIST|CMD_ZERO:
-		ret = list_entries(h, chain, *table, rulenum,
-				   options&OPT_VERBOSE,
-				   options&OPT_NUMERIC,
-				   /*options&OPT_EXPANDED*/0,
-				   options&OPT_LINENUMBERS);
+		ret = list_entries(h, p.chain, p.table, p.rulenum,
+				   cs.options&OPT_VERBOSE,
+				   cs.options&OPT_NUMERIC,
+				   /*cs.options&OPT_EXPANDED*/0,
+				   cs.options&OPT_LINENUMBERS);
 		if (ret)
-			ret = nft_cmd_chain_zero_counters(h, chain, *table,
-						      options & OPT_VERBOSE);
+			ret = nft_cmd_chain_zero_counters(h, p.chain, p.table,
+						      cs.options & OPT_VERBOSE);
 		break;
 	case CMD_NEW_CHAIN:
-		ret = nft_cmd_chain_user_add(h, chain, *table);
+		ret = nft_cmd_chain_user_add(h, p.chain, p.table);
 		break;
 	case CMD_DELETE_CHAIN:
-		ret = nft_cmd_chain_del(h, chain, *table,
-					options & OPT_VERBOSE);
+		ret = nft_cmd_chain_del(h, p.chain, p.table,
+					cs.options & OPT_VERBOSE);
 		break;
 	case CMD_RENAME_CHAIN:
-		ret = nft_cmd_chain_user_rename(h, chain, *table, newname);
+		ret = nft_cmd_chain_user_rename(h, p.chain, p.table, p.newname);
 		break;
 	case CMD_SET_POLICY:
-		ret = nft_cmd_chain_set(h, *table, chain, policy, NULL);
+		ret = nft_cmd_chain_set(h, p.table, p.chain, p.policy, NULL);
 		if (ret < 0)
 			xtables_error(PARAMETER_PROBLEM, "Wrong policy `%s'\n",
-				      policy);
+				      p.policy);
 		break;
 	case CMD_NONE:
 		break;
@@ -914,15 +910,15 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 		exit_tryhelp(2);
 	}
 
-	free(saddrs);
-	free(smasks);
-	free(daddrs);
-	free(dmasks);
+	free(args.s.addr.v4);
+	free(args.s.mask.v4);
+	free(args.d.addr.v4);
+	free(args.d.mask.v4);
 
 	nft_clear_iptables_command_state(&cs);
 	xtables_free_opts(1);
 
-/*	if (verbose > 1)
+/*	if (p.verbose > 1)
 		dump_entries(*handle);*/
 
 	return ret;
-- 
2.33.0

