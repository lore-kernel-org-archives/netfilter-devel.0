Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21CD1C433EF
	for <netfilter-devel@archiver.kernel.org>; Fri, 24 Dec 2021 17:18:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353290AbhLXRS4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 24 Dec 2021 12:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbhLXRS4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Dec 2021 12:18:56 -0500
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1F5CC061401
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Dec 2021 09:18:55 -0800 (PST)
Received: from localhost ([::1]:59098 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1n0oDW-0004xK-5k; Fri, 24 Dec 2021 18:18:54 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 04/11] xtables: Pass xtables_args to check_empty_interface()
Date:   Fri, 24 Dec 2021 18:17:47 +0100
Message-Id: <20211224171754.14210-5-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211224171754.14210-1-phil@nwl.cc>
References: <20211224171754.14210-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

It holds the accessed family field as well and is more generic than
nft_handle.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index 837b399aba5b3..db0cec2461741 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -145,14 +145,14 @@ list_rules(struct nft_handle *h, const char *chain, const char *table,
 	return nft_cmd_rule_list_save(h, chain, table, rulenum, counters);
 }
 
-static void check_empty_interface(struct nft_handle *h, const char *arg)
+static void check_empty_interface(struct xtables_args *args, const char *arg)
 {
 	const char *msg = "Empty interface is likely to be undesired";
 
 	if (*arg != '\0')
 		return;
 
-	if (h->family != NFPROTO_ARP)
+	if (args->family != NFPROTO_ARP)
 		xtables_error(PARAMETER_PROBLEM, msg);
 
 	fprintf(stderr, "%s", msg);
@@ -460,7 +460,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			break;
 
 		case 'i':
-			check_empty_interface(h, optarg);
+			check_empty_interface(args, optarg);
 			check_inverse(h, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_VIANAMEIN,
 				   &args->invflags, invert);
@@ -470,7 +470,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			break;
 
 		case 'o':
-			check_empty_interface(h, optarg);
+			check_empty_interface(args, optarg);
 			check_inverse(h, optarg, &invert, &optind, argc);
 			set_option(&cs->options, OPT_VIANAMEOUT,
 				   &args->invflags, invert);
-- 
2.34.1

