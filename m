Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 701C6C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Oct 2021 12:27:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 527BB61090
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Oct 2021 12:27:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235611AbhJOM30 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Oct 2021 08:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238783AbhJOM3S (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Oct 2021 08:29:18 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97430C061766
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Oct 2021 05:27:08 -0700 (PDT)
Received: from localhost ([::1]:33878 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mbMIl-0002Uo-0F; Fri, 15 Oct 2021 14:27:07 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 09/13] nft-arp: Introduce post_parse callback
Date:   Fri, 15 Oct 2021 14:26:04 +0200
Message-Id: <20211015122608.12474-10-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211015122608.12474-1-phil@nwl.cc>
References: <20211015122608.12474-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This accomplishes the same tasks as e.g. nft_ipv4_post_parse() plus some
arptables-specific bits.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-arp.c     | 150 +++++++++++++++++++++++++++++++++++++++-
 iptables/nft-shared.h  |   3 +
 iptables/xtables-arp.c | 153 +++++++----------------------------------
 3 files changed, 178 insertions(+), 128 deletions(-)

diff --git a/iptables/nft-arp.c b/iptables/nft-arp.c
index fbaf1a6d52184..b37ffbb592023 100644
--- a/iptables/nft-arp.c
+++ b/iptables/nft-arp.c
@@ -546,6 +546,154 @@ static void nft_arp_save_chain(const struct nftnl_chain *c, const char *policy)
 	printf(":%s %s\n", chain, policy ?: "-");
 }
 
+static int getlength_and_mask(const char *from, uint8_t *to, uint8_t *mask)
+{
+	char *dup = strdup(from);
+	char *p, *buffer;
+	int i, ret = -1;
+
+	if (!dup)
+		return -1;
+
+	if ( (p = strrchr(dup, '/')) != NULL) {
+		*p = '\0';
+		i = strtol(p+1, &buffer, 10);
+		if (*buffer != '\0' || i < 0 || i > 255)
+			goto out_err;
+		*mask = (uint8_t)i;
+	} else
+		*mask = 255;
+	i = strtol(dup, &buffer, 10);
+	if (*buffer != '\0' || i < 0 || i > 255)
+		goto out_err;
+	*to = (uint8_t)i;
+	ret = 0;
+out_err:
+	free(dup);
+	return ret;
+
+}
+
+static int get16_and_mask(const char *from, uint16_t *to,
+			  uint16_t *mask, int base)
+{
+	char *dup = strdup(from);
+	char *p, *buffer;
+	int i, ret = -1;
+
+	if (!dup)
+		return -1;
+
+	if ( (p = strrchr(dup, '/')) != NULL) {
+		*p = '\0';
+		i = strtol(p+1, &buffer, base);
+		if (*buffer != '\0' || i < 0 || i > 65535)
+			goto out_err;
+		*mask = htons((uint16_t)i);
+	} else
+		*mask = 65535;
+	i = strtol(dup, &buffer, base);
+	if (*buffer != '\0' || i < 0 || i > 65535)
+		goto out_err;
+	*to = htons((uint16_t)i);
+	ret = 0;
+out_err:
+	free(dup);
+	return ret;
+}
+
+static void nft_arp_post_parse(int command,
+			       struct iptables_command_state *cs,
+			       struct xtables_args *args)
+{
+	cs->arp.arp.invflags = args->invflags;
+
+	memcpy(cs->arp.arp.iniface, args->iniface, IFNAMSIZ);
+	memcpy(cs->arp.arp.iniface_mask, args->iniface_mask, IFNAMSIZ);
+
+	memcpy(cs->arp.arp.outiface, args->outiface, IFNAMSIZ);
+	memcpy(cs->arp.arp.outiface_mask, args->outiface_mask, IFNAMSIZ);
+
+	cs->arp.counters.pcnt = args->pcnt_cnt;
+	cs->arp.counters.bcnt = args->bcnt_cnt;
+
+	if (command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND)) {
+		if (!(cs->options & OPT_DESTINATION))
+			args->dhostnetworkmask = "0.0.0.0/0";
+		if (!(cs->options & OPT_SOURCE))
+			args->shostnetworkmask = "0.0.0.0/0";
+	}
+
+	if (args->shostnetworkmask)
+		xtables_ipparse_multiple(args->shostnetworkmask,
+					 &args->s.addr.v4, &args->s.mask.v4,
+					 &args->s.naddrs);
+	if (args->dhostnetworkmask)
+		xtables_ipparse_multiple(args->dhostnetworkmask,
+					 &args->d.addr.v4, &args->d.mask.v4,
+					 &args->d.naddrs);
+
+	if ((args->s.naddrs > 1 || args->d.naddrs > 1) &&
+	    (cs->arp.arp.invflags & (ARPT_INV_SRCIP | ARPT_INV_TGTIP)))
+		xtables_error(PARAMETER_PROBLEM,
+			      "! not allowed with multiple"
+			      " source or destination IP addresses");
+
+	if (args->src_mac &&
+	    xtables_parse_mac_and_mask(args->src_mac,
+				       cs->arp.arp.src_devaddr.addr,
+				       cs->arp.arp.src_devaddr.mask))
+		xtables_error(PARAMETER_PROBLEM,
+			      "Problem with specified source mac");
+	if (args->dst_mac &&
+	    xtables_parse_mac_and_mask(args->dst_mac,
+				       cs->arp.arp.tgt_devaddr.addr,
+				       cs->arp.arp.tgt_devaddr.mask))
+		xtables_error(PARAMETER_PROBLEM,
+			      "Problem with specified destination mac");
+	if (args->arp_hlen) {
+		getlength_and_mask(args->arp_hlen, &cs->arp.arp.arhln,
+				   &cs->arp.arp.arhln_mask);
+
+		if (cs->arp.arp.arhln != 6)
+			xtables_error(PARAMETER_PROBLEM,
+				      "Only harware address length of 6 is supported currently.");
+	}
+	if (args->arp_opcode) {
+		if (get16_and_mask(args->arp_opcode, &cs->arp.arp.arpop,
+				   &cs->arp.arp.arpop_mask, 10)) {
+			int i;
+
+			for (i = 0; i < NUMOPCODES; i++)
+				if (!strcasecmp(arp_opcodes[i],
+						args->arp_opcode))
+					break;
+			if (i == NUMOPCODES)
+				xtables_error(PARAMETER_PROBLEM,
+					      "Problem with specified opcode");
+			cs->arp.arp.arpop = htons(i+1);
+		}
+	}
+	if (args->arp_htype) {
+		if (get16_and_mask(args->arp_htype, &cs->arp.arp.arhrd,
+				   &cs->arp.arp.arhrd_mask, 16)) {
+			if (strcasecmp(args->arp_htype, "Ethernet"))
+				xtables_error(PARAMETER_PROBLEM,
+					      "Problem with specified hardware type");
+			cs->arp.arp.arhrd = htons(1);
+		}
+	}
+	if (args->arp_ptype) {
+		if (get16_and_mask(args->arp_ptype, &cs->arp.arp.arpro,
+				   &cs->arp.arp.arpro_mask, 0)) {
+			if (strcasecmp(args->arp_ptype, "ipv4"))
+				xtables_error(PARAMETER_PROBLEM,
+					      "Problem with specified protocol type");
+			cs->arp.arp.arpro = htons(0x800);
+		}
+	}
+}
+
 static void nft_arp_init_cs(struct iptables_command_state *cs)
 {
 	cs->arp.arp.arhln = 6;
@@ -565,7 +713,7 @@ struct nft_family_ops nft_family_ops_arp = {
 	.print_rule		= nft_arp_print_rule,
 	.save_rule		= nft_arp_save_rule,
 	.save_chain		= nft_arp_save_chain,
-	.post_parse		= NULL,
+	.post_parse		= nft_arp_post_parse,
 	.rule_to_cs		= nft_rule_to_iptables_command_state,
 	.init_cs		= nft_arp_init_cs,
 	.clear_cs		= nft_clear_iptables_command_state,
diff --git a/iptables/nft-shared.h b/iptables/nft-shared.h
index cb1c3fffe63b4..339c46e7f5b06 100644
--- a/iptables/nft-shared.h
+++ b/iptables/nft-shared.h
@@ -218,6 +218,9 @@ struct xtables_args {
 	const char	*shostnetworkmask, *dhostnetworkmask;
 	const char	*pcnt, *bcnt;
 	struct addr_mask s, d;
+	const char	*src_mac, *dst_mac;
+	const char	*arp_hlen, *arp_opcode;
+	const char	*arp_htype, *arp_ptype;
 	unsigned long long pcnt_cnt, bcnt_cnt;
 };
 
diff --git a/iptables/xtables-arp.c b/iptables/xtables-arp.c
index 1075b6be74e98..de7c381788a37 100644
--- a/iptables/xtables-arp.c
+++ b/iptables/xtables-arp.c
@@ -108,54 +108,6 @@ struct xtables_globals arptables_globals = {
 	.print_help		= printhelp,
 };
 
-/***********************************************/
-/* ARPTABLES SPECIFIC NEW FUNCTIONS ADDED HERE */
-/***********************************************/
-
-static int getlength_and_mask(char *from, uint8_t *to, uint8_t *mask)
-{
-	char *p, *buffer;
-	int i;
-
-	if ( (p = strrchr(from, '/')) != NULL) {
-		*p = '\0';
-		i = strtol(p+1, &buffer, 10);
-		if (*buffer != '\0' || i < 0 || i > 255)
-			return -1;
-		*mask = (uint8_t)i;
-	} else
-		*mask = 255;
-	i = strtol(from, &buffer, 10);
-	if (*buffer != '\0' || i < 0 || i > 255)
-		return -1;
-	*to = (uint8_t)i;
-	return 0;
-}
-
-static int get16_and_mask(char *from, uint16_t *to, uint16_t *mask, int base)
-{
-	char *p, *buffer;
-	int i;
-
-	if ( (p = strrchr(from, '/')) != NULL) {
-		*p = '\0';
-		i = strtol(p+1, &buffer, base);
-		if (*buffer != '\0' || i < 0 || i > 65535)
-			return -1;
-		*mask = htons((uint16_t)i);
-	} else
-		*mask = 65535;
-	i = strtol(from, &buffer, base);
-	if (*buffer != '\0' || i < 0 || i > 65535)
-		return -1;
-	*to = htons((uint16_t)i);
-	return 0;
-}
-
-/*********************************************/
-/* ARPTABLES SPECIFIC NEW FUNCTIONS END HERE */
-/*********************************************/
-
 static void
 exit_tryhelp(int status)
 {
@@ -566,132 +518,97 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 			break;
 		case 's':
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_SOURCE, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_SOURCE, &args.invflags,
 				   invert);
 			args.shostnetworkmask = argv[optind-1];
 			break;
 
 		case 'd':
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_DESTINATION, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_DESTINATION, &args.invflags,
 				   invert);
 			args.dhostnetworkmask = argv[optind-1];
 			break;
 
 		case 2:/* src-mac */
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_S_MAC, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_S_MAC, &args.invflags,
 				   invert);
-			if (xtables_parse_mac_and_mask(argv[optind - 1],
-			    cs.arp.arp.src_devaddr.addr, cs.arp.arp.src_devaddr.mask))
-				xtables_error(PARAMETER_PROBLEM, "Problem with specified "
-						"source mac");
+			args.src_mac = argv[optind - 1];
 			break;
 
 		case 3:/* dst-mac */
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_D_MAC, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_D_MAC, &args.invflags,
 				   invert);
-
-			if (xtables_parse_mac_and_mask(argv[optind - 1],
-			    cs.arp.arp.tgt_devaddr.addr, cs.arp.arp.tgt_devaddr.mask))
-				xtables_error(PARAMETER_PROBLEM, "Problem with specified "
-						"destination mac");
+			args.dst_mac = argv[optind - 1];
 			break;
 
 		case 'l':/* hardware length */
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_H_LENGTH, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_H_LENGTH, &args.invflags,
 				   invert);
-			getlength_and_mask(argv[optind - 1], &cs.arp.arp.arhln,
-					   &cs.arp.arp.arhln_mask);
-
-			if (cs.arp.arp.arhln != 6) {
-				xtables_error(PARAMETER_PROBLEM,
-					      "Only harware address length of"
-					      " 6 is supported currently.");
-			}
-
+			args.arp_hlen = argv[optind - 1];
 			break;
 
 		case 8: /* was never supported, not even in arptables-legacy */
 			xtables_error(PARAMETER_PROBLEM, "not supported");
 		case 4:/* opcode */
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_OPCODE, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_OPCODE, &args.invflags,
 				   invert);
-			if (get16_and_mask(argv[optind - 1], &cs.arp.arp.arpop,
-					   &cs.arp.arp.arpop_mask, 10)) {
-				int i;
-
-				for (i = 0; i < NUMOPCODES; i++)
-					if (!strcasecmp(arp_opcodes[i], optarg))
-						break;
-				if (i == NUMOPCODES)
-					xtables_error(PARAMETER_PROBLEM, "Problem with specified opcode");
-				cs.arp.arp.arpop = htons(i+1);
-			}
+			args.arp_opcode = argv[optind - 1];
 			break;
 
 		case 5:/* h-type */
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_H_TYPE, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_H_TYPE, &args.invflags,
 				   invert);
-			if (get16_and_mask(argv[optind - 1], &cs.arp.arp.arhrd,
-					   &cs.arp.arp.arhrd_mask, 16)) {
-				if (strcasecmp(argv[optind-1], "Ethernet"))
-					xtables_error(PARAMETER_PROBLEM, "Problem with specified hardware type");
-				cs.arp.arp.arhrd = htons(1);
-			}
+			args.arp_htype = argv[optind - 1];
 			break;
 
 		case 6:/* proto-type */
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_P_TYPE, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_P_TYPE, &args.invflags,
 				   invert);
-			if (get16_and_mask(argv[optind - 1], &cs.arp.arp.arpro,
-					   &cs.arp.arp.arpro_mask, 0)) {
-				if (strcasecmp(argv[optind-1], "ipv4"))
-					xtables_error(PARAMETER_PROBLEM, "Problem with specified protocol type");
-				cs.arp.arp.arpro = htons(0x800);
-			}
+			args.arp_ptype = argv[optind - 1];
 			break;
 
 		case 'j':
-			set_option(&cs.options, OPT_JUMP, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_JUMP, &args.invflags,
 				   invert);
 			command_jump(&cs, optarg);
 			break;
 
 		case 'i':
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_VIANAMEIN, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_VIANAMEIN, &args.invflags,
 				   invert);
 			xtables_parse_interface(argv[optind-1],
-						cs.arp.arp.iniface,
-						cs.arp.arp.iniface_mask);
+						args.iniface,
+						args.iniface_mask);
 			break;
 
 		case 'o':
 			check_inverse(optarg, &invert, &optind, argc);
-			set_option(&cs.options, OPT_VIANAMEOUT, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_VIANAMEOUT, &args.invflags,
 				   invert);
 			xtables_parse_interface(argv[optind-1],
-						cs.arp.arp.outiface,
-						cs.arp.arp.outiface_mask);
+						args.outiface,
+						args.outiface_mask);
 			break;
 
 		case 'v':
 			if (!p.verbose)
 				set_option(&cs.options, OPT_VERBOSE,
-					   &cs.arp.arp.invflags, invert);
+					   &args.invflags, invert);
 			p.verbose++;
 			break;
 
 		case 'm': /* ignored by arptables-legacy */
 			break;
 		case 'n':
-			set_option(&cs.options, OPT_NUMERIC, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_NUMERIC, &args.invflags,
 				   invert);
 			break;
 
@@ -715,7 +632,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 			exit(0);
 
 		case '0':
-			set_option(&cs.options, OPT_LINENUMBERS, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_LINENUMBERS, &args.invflags,
 				   invert);
 			break;
 
@@ -725,7 +642,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 
 		case 'c':
 
-			set_option(&cs.options, OPT_COUNTERS, &cs.arp.arp.invflags,
+			set_option(&cs.options, OPT_COUNTERS, &args.invflags,
 				   invert);
 			args.pcnt = optarg;
 			if (xs_has_arg(argc, argv))
@@ -781,25 +698,7 @@ int do_commandarp(struct nft_handle *h, int argc, char *argv[], char **table,
 		xtables_error(PARAMETER_PROBLEM,
 			      "nothing appropriate following !");
 
-	if (p.command & (CMD_REPLACE | CMD_INSERT | CMD_DELETE | CMD_APPEND)) {
-		if (!(cs.options & OPT_DESTINATION))
-			args.dhostnetworkmask = "0.0.0.0/0";
-		if (!(cs.options & OPT_SOURCE))
-			args.shostnetworkmask = "0.0.0.0/0";
-	}
-
-	if (args.shostnetworkmask)
-		xtables_ipparse_multiple(args.shostnetworkmask, &args.s.addr.v4,
-					 &args.s.mask.v4, &args.s.naddrs);
-
-	if (args.dhostnetworkmask)
-		xtables_ipparse_multiple(args.dhostnetworkmask, &args.d.addr.v4,
-					 &args.d.mask.v4, &args.d.naddrs);
-
-	if ((args.s.naddrs > 1 || args.d.naddrs > 1) &&
-	    (cs.arp.arp.invflags & (IPT_INV_SRCIP | IPT_INV_DSTIP)))
-		xtables_error(PARAMETER_PROBLEM, "! not allowed with multiple"
-				" source or destination IP addresses");
+	h->ops->post_parse(p.command, &cs, &args);
 
 	if (p.command == CMD_REPLACE && (args.s.naddrs != 1 || args.d.naddrs != 1))
 		xtables_error(PARAMETER_PROBLEM, "Replacement rule does not "
-- 
2.33.0

