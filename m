Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EE0FC433F5
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Sep 2021 15:44:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64ACC61155
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Sep 2021 15:44:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234371AbhIOPpo (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Sep 2021 11:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234300AbhIOPpo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Sep 2021 11:45:44 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91C17C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Sep 2021 08:44:25 -0700 (PDT)
Received: from localhost ([::1]:40030 helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1mQX5B-0000Oo-On; Wed, 15 Sep 2021 17:44:21 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [iptables PATCH] ebtables: Avoid dropping policy when flushing
Date:   Wed, 15 Sep 2021 17:44:13 +0200
Message-Id: <20210915154413.32598-1-phil@nwl.cc>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Unlike nftables, ebtables' user-defined chains have policies -
ebtables-nft implements those internally as invisible last rule. In
order to recreate them after a flush command, a rule cache is needed.

https://bugzilla.netfilter.org/show_bug.cgi?id=1558
Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft-cmd.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/iptables/nft-cmd.c b/iptables/nft-cmd.c
index 87e66905655d6..efe6840f78ed7 100644
--- a/iptables/nft-cmd.c
+++ b/iptables/nft-cmd.c
@@ -167,7 +167,9 @@ int nft_cmd_rule_flush(struct nft_handle *h, const char *chain,
 	if (!cmd)
 		return 0;
 
-	if (chain || verbose)
+	if (h->family == NFPROTO_BRIDGE)
+		nft_cache_level_set(h, NFT_CL_RULES, cmd);
+	else if (chain || verbose)
 		nft_cache_level_set(h, NFT_CL_CHAINS, cmd);
 	else
 		nft_cache_level_set(h, NFT_CL_TABLES, cmd);
-- 
2.33.0

