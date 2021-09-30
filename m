Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E576C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 14:05:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 557EE60F9B
	for <netfilter-devel@archiver.kernel.org>; Thu, 30 Sep 2021 14:05:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351744AbhI3OGs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 30 Sep 2021 10:06:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351734AbhI3OGr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 30 Sep 2021 10:06:47 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18951C06176A
        for <netfilter-devel@vger.kernel.org>; Thu, 30 Sep 2021 07:05:05 -0700 (PDT)
Received: from localhost ([::1]:51696 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mVwgJ-0007QV-F8; Thu, 30 Sep 2021 16:05:03 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 16/17] xtables: Support '!' betwen option and argument
Date:   Thu, 30 Sep 2021 16:04:18 +0200
Message-Id: <20210930140419.6170-17-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210930140419.6170-1-phil@nwl.cc>
References: <20210930140419.6170-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Accept this for arptables only for now, iptables dropped support for it
long time ago.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables.c | 63 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 50 insertions(+), 13 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index c77d76c89a543..dba497b85064a 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -262,6 +262,31 @@ list_rules(struct nft_handle *h, const char *chain, const char *table,
 	return nft_cmd_rule_list_save(h, chain, table, rulenum, counters);
 }
 
+static void check_inverse(struct nft_handle *h, const char option[],
+			  bool *invert, int *optidx, int argc)
+{
+	switch (h->family) {
+	case NFPROTO_ARP:
+		break;
+	default:
+		return;
+	}
+
+	if (!option || strcmp(option, "!"))
+		return false;
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
 void do_parse(struct nft_handle *h, int argc, char *argv[],
 	      struct nft_xt_cmd_parse *p, struct iptables_command_state *cs,
 	      struct xtables_args *args)
@@ -447,14 +472,16 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			 * Option selection
 			 */
 		case 'p':
+			check_inverse(h, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_PROTOCOL,
 				   &args->invflags, invert);
 
 			/* Canonicalize into lower case */
-			for (cs->protocol = optarg; *cs->protocol; cs->protocol++)
+			for (cs->protocol = argv[optind - 1];
+			     *cs->protocol; cs->protocol++)
 				*cs->protocol = tolower(*cs->protocol);
 
-			cs->protocol = optarg;
+			cs->protocol = argv[optind - 1];
 			args->proto = xtables_parse_protocol(cs->protocol);
 
 			if (args->proto == 0 &&
@@ -468,15 +495,17 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			break;
 
 		case 's':
+			check_inverse(h, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_SOURCE,
 				   &args->invflags, invert);
-			args->shostnetworkmask = optarg;
+			args->shostnetworkmask = argv[optind - 1];
 			break;
 
 		case 'd':
+			check_inverse(h, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_DESTINATION,
 				   &args->invflags, invert);
-			args->dhostnetworkmask = optarg;
+			args->dhostnetworkmask = argv[optind - 1];
 			break;
 
 #ifdef IPT_F_GOTO
@@ -489,47 +518,53 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 #endif
 
 		case 2:/* src-mac */
+			check_inverse(h, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_S_MAC, &args->invflags,
 				   invert);
-			args->src_mac = optarg;
+			args->src_mac = argv[optind - 1];
 			break;
 
 		case 3:/* dst-mac */
+			check_inverse(h, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_D_MAC, &args->invflags,
 				   invert);
-			args->dst_mac = optarg;
+			args->dst_mac = argv[optind - 1];
 			break;
 
 		case 'l':/* hardware length */
+			check_inverse(h, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_H_LENGTH, &args->invflags,
 				   invert);
-			args->arp_hlen = optarg;
+			args->arp_hlen = argv[optind - 1];
 			break;
 
 		case 8: /* was never supported, not even in arptables-legacy */
 			xtables_error(PARAMETER_PROBLEM, "not supported");
 		case 4:/* opcode */
+			check_inverse(h, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_OPCODE, &args->invflags,
 				   invert);
-			args->arp_opcode = optarg;
+			args->arp_opcode = argv[optind - 1];
 			break;
 
 		case 5:/* h-type */
+			check_inverse(h, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_H_TYPE, &args->invflags,
 				   invert);
-			args->arp_htype = optarg;
+			args->arp_htype = argv[optind - 1];
 			break;
 
 		case 6:/* proto-type */
+			check_inverse(h, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_P_TYPE, &args->invflags,
 				   invert);
-			args->arp_ptype = optarg;
+			args->arp_ptype = argv[optind - 1];
 			break;
 
 		case 'j':
 			set_option(&cs->options, OPT_JUMP, &args->invflags,
 				   invert);
-			command_jump(cs, optarg);
+			command_jump(cs, argv[optind - 1]);
 			break;
 
 		case 'i':
@@ -537,9 +572,10 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
+			check_inverse(h, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_VIANAMEIN,
 				   &args->invflags, invert);
-			xtables_parse_interface(optarg,
+			xtables_parse_interface(argv[optind - 1],
 						args->iniface,
 						args->iniface_mask);
 			break;
@@ -549,9 +585,10 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 				xtables_error(PARAMETER_PROBLEM,
 					"Empty interface is likely to be "
 					"undesired");
+			check_inverse(h, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_VIANAMEOUT,
 				   &args->invflags, invert);
-			xtables_parse_interface(optarg,
+			xtables_parse_interface(argv[optind - 1],
 						args->outiface,
 						args->outiface_mask);
 			break;
-- 
2.33.0

