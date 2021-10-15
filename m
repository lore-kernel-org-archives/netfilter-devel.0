Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1620C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Oct 2021 12:27:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 916B760E05
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Oct 2021 12:27:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238978AbhJOM30 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Oct 2021 08:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238957AbhJOM3J (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Oct 2021 08:29:09 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADE2C061764
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Oct 2021 05:27:03 -0700 (PDT)
Received: from localhost ([::1]:33872 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mbMIe-0002Ui-1w; Fri, 15 Oct 2021 14:27:01 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH v3 12/13] xtables: arptables accepts empty interface names
Date:   Fri, 15 Oct 2021 14:26:07 +0200
Message-Id: <20211015122608.12474-13-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211015122608.12474-1-phil@nwl.cc>
References: <20211015122608.12474-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The empty string passed as interface name is simply ignored by legacy
arptables. Make the new common parser print a warning but accept it.
Calling xtables_parse_interface() with an empty string is safe.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables.c | 23 +++++++++++++++--------
 1 file changed, 15 insertions(+), 8 deletions(-)

diff --git a/iptables/xtables.c b/iptables/xtables.c
index dc67affc19dbe..075506f07dd5b 100644
--- a/iptables/xtables.c
+++ b/iptables/xtables.c
@@ -260,6 +260,19 @@ list_rules(struct nft_handle *h, const char *chain, const char *table,
 	return nft_cmd_rule_list_save(h, chain, table, rulenum, counters);
 }
 
+static void check_empty_interface(struct nft_handle *h, const char *arg)
+{
+	const char *msg = "Empty interface is likely to be undesired";
+
+	if (*arg != '\0')
+		return;
+
+	if (h->family != NFPROTO_ARP)
+		xtables_error(PARAMETER_PROBLEM, msg);
+
+	fprintf(stderr, "%s", msg);
+}
+
 void do_parse(struct nft_handle *h, int argc, char *argv[],
 	      struct nft_xt_cmd_parse *p, struct iptables_command_state *cs,
 	      struct xtables_args *args)
@@ -493,10 +506,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 
 
 		case 'i':
-			if (*optarg == '\0')
-				xtables_error(PARAMETER_PROBLEM,
-					"Empty interface is likely to be "
-					"undesired");
+			check_empty_interface(h, optarg);
 			set_option(&cs->options, OPT_VIANAMEIN,
 				   &args->invflags, invert);
 			xtables_parse_interface(optarg,
@@ -505,10 +515,7 @@ void do_parse(struct nft_handle *h, int argc, char *argv[],
 			break;
 
 		case 'o':
-			if (*optarg == '\0')
-				xtables_error(PARAMETER_PROBLEM,
-					"Empty interface is likely to be "
-					"undesired");
+			check_empty_interface(h, optarg);
 			set_option(&cs->options, OPT_VIANAMEOUT,
 				   &args->invflags, invert);
 			xtables_parse_interface(optarg,
-- 
2.33.0

