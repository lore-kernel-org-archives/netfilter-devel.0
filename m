Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 069F1C433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 17:37:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C19A561444
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 17:37:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242218AbhD1Rhz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 13:37:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242177AbhD1Rhw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 13:37:52 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EFAC061573
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Apr 2021 10:37:06 -0700 (PDT)
Received: from localhost ([::1]:34718 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lbo7T-0007A9-0X; Wed, 28 Apr 2021 19:37:03 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 4/5] ebtables-translate: Use shared ebt_get_current_chain() function
Date:   Wed, 28 Apr 2021 19:36:55 +0200
Message-Id: <20210428173656.16851-5-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210428173656.16851-1-phil@nwl.cc>
References: <20210428173656.16851-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Drop the local reimplementation. It was barely different enough to
be buggy:

| % ebtables-nft -A foo -o eth0 -j ACCEPT
| % xtables-nft-multi ebtables-translate -A foo -o eth0 -j ACCEPT
| ebtables-translate v1.8.5 (nf_tables): Use -o only in OUTPUT, FORWARD and POSTROUTING chains
| Try `ebtables-translate -h' or 'ebtables-translate --help' for more information.

With this change, output is as expected:

| % xtables-nft-multi ebtables-translate -A foo -o eth0 -j ACCEPT
| nft add rule bridge filter foo oifname "eth0" counter accept

This is roughly the same issue fixed in commit e1ccd979e6849 ("ebtables:
fix over-eager -o checks on custom chains").

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/xtables-eb-translate.c | 18 +-----------------
 1 file changed, 1 insertion(+), 17 deletions(-)

diff --git a/iptables/xtables-eb-translate.c b/iptables/xtables-eb-translate.c
index 04b3dfa0bf455..0539a829d3ff8 100644
--- a/iptables/xtables-eb-translate.c
+++ b/iptables/xtables-eb-translate.c
@@ -64,22 +64,6 @@ static int parse_rule_number(const char *rule)
 	return rule_nr;
 }
 
-static int get_current_chain(const char *chain)
-{
-	if (strcmp(chain, "PREROUTING") == 0)
-		return NF_BR_PRE_ROUTING;
-	else if (strcmp(chain, "INPUT") == 0)
-		return NF_BR_LOCAL_IN;
-	else if (strcmp(chain, "FORWARD") == 0)
-		return NF_BR_FORWARD;
-	else if (strcmp(chain, "OUTPUT") == 0)
-		return NF_BR_LOCAL_OUT;
-	else if (strcmp(chain, "POSTROUTING") == 0)
-		return NF_BR_POST_ROUTING;
-
-	return -1;
-}
-
 /*
  * The original ebtables parser
  */
@@ -240,7 +224,7 @@ static int do_commandeb_xlate(struct nft_handle *h, int argc, char *argv[], char
 					      "Multiple commands are not allowed");
 			command = c;
 			chain = optarg;
-			selected_chain = get_current_chain(chain);
+			selected_chain = ebt_get_current_chain(chain);
 			p.chain = chain;
 			flags |= OPT_COMMAND;
 
-- 
2.31.0

