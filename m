Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1CC15C433EF
	for <netfilter-devel@archiver.kernel.org>; Tue, 11 Jan 2022 15:04:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243605AbiAKPEm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 11 Jan 2022 10:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244280AbiAKPEl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 11 Jan 2022 10:04:41 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6DC8C06173F
        for <netfilter-devel@vger.kernel.org>; Tue, 11 Jan 2022 07:04:40 -0800 (PST)
Received: from localhost ([::1]:59120 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1n7IhT-0007Ub-2x; Tue, 11 Jan 2022 16:04:39 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v2 05/11] xtables: Pass xtables_args to check_inverse()
Date:   Tue, 11 Jan 2022 16:04:23 +0100
Message-Id: <20220111150429.29110-6-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220111150429.29110-1-phil@nwl.cc>
References: <20220111150429.29110-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It holds the accessed family field as well and is more generic than
nft_handle.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index db0cec2461741..5e8c027b8471e 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -158,10 +158,10 @@ static void check_empty_interface(struct xtables_args *args, const char *arg)
 	fprintf(stderr, "%s", msg);
 }
 
-static void check_inverse(struct nft_handle *h, const char option[],
+static void check_inverse(struct xtables_args *args, const char option[],
 			  bool *invert, int *optidx, int argc)
 {
-	switch (h->family) {
+	switch (args->family) {
 	case NFPROTO_ARP:
 		break;
 	default:
@@ -364,7 +364,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			 * Option selection
 			 */
 		case 'p':
-			check_inverse(h, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_PROTOCOL,
 				   &args->invflags, invert);
 
@@ -387,14 +387,14 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			break;
 
 		case 's':
-			check_inverse(h, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_SOURCE,
 				   &args->invflags, invert);
 			args->shostnetworkmask = argv[optind - 1];
 			break;
 
 		case 'd':
-			check_inverse(h, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_DESTINATION,
 				   &args->invflags, invert);
 			args->dhostnetworkmask = argv[optind - 1];
@@ -410,21 +410,21 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 #endif
 
 		case 2:/* src-mac */
-			check_inverse(h, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_S_MAC, &args->invflags,
 				   invert);
 			args->src_mac = argv[optind - 1];
 			break;
 
 		case 3:/* dst-mac */
-			check_inverse(h, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_D_MAC, &args->invflags,
 				   invert);
 			args->dst_mac = argv[optind - 1];
 			break;
 
 		case 'l':/* hardware length */
-			check_inverse(h, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_H_LENGTH, &args->invflags,
 				   invert);
 			args->arp_hlen = argv[optind - 1];
@@ -433,21 +433,21 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 		case 8: /* was never supported, not even in arptables-legacy */
 			xtables_error(PARAMETER_PROBLEM, "not supported");
 		case 4:/* opcode */
-			check_inverse(h, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_OPCODE, &args->invflags,
 				   invert);
 			args->arp_opcode = argv[optind - 1];
 			break;
 
 		case 5:/* h-type */
-			check_inverse(h, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_H_TYPE, &args->invflags,
 				   invert);
 			args->arp_htype = argv[optind - 1];
 			break;
 
 		case 6:/* proto-type */
-			check_inverse(h, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_P_TYPE, &args->invflags,
 				   invert);
 			args->arp_ptype = argv[optind - 1];
@@ -461,7 +461,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 
 		case 'i':
 			check_empty_interface(args, optarg);
-			check_inverse(h, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_VIANAMEIN,
 				   &args->invflags, invert);
 			xtables_parse_interface(argv[optind - 1],
@@ -471,7 +471,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 
 		case 'o':
 			check_empty_interface(args, optarg);
-			check_inverse(h, optarg, &invert, &optind, argc);
+			check_inverse(args, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_VIANAMEOUT,
 				   &args->invflags, invert);
 			xtables_parse_interface(argv[optind - 1],
-- 
2.34.1

