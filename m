Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0BF8C7618B
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 15:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAD602238C
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 15:19:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389167AbfGYPTZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 11:19:25 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:53762 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388736AbfGYPTZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 11:19:25 -0400
Received: from localhost ([::1]:38620 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.91)
        (envelope-from <phil@nwl.cc>)
        id 1hqfWd-0004TQ-A3; Thu, 25 Jul 2019 17:19:23 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: [iptables PATCH 1/2] nft: Set errno in nft_rule_flush()
Date:   Thu, 25 Jul 2019 17:19:13 +0200
Message-Id: <20190725151914.28723-1-phil@nwl.cc>
X-Mailer: git-send-email 2.22.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

When trying to flush a non-existent chain, errno gets set in
nft_xtables_config_load(). That is an unintended side-effect and when
support for xtables.conf is later removed, iptables-nft will emit the
generic "Incompatible with this kernel." error message instead of "No
chain/target/match by that name." as it should.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 iptables/nft.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/iptables/nft.c b/iptables/nft.c
index cd42af70b54ef..9f8df5414d4c4 100644
--- a/iptables/nft.c
+++ b/iptables/nft.c
@@ -1804,8 +1804,10 @@ int nft_rule_flush(struct nft_handle *h, const char *chain, const char *table,
 
 	if (chain) {
 		c = nftnl_chain_list_lookup_byname(list, chain);
-		if (!c)
+		if (!c) {
+			errno = ENOENT;
 			return 0;
+		}
 
 		__nft_rule_flush(h, table, chain, verbose, false);
 		flush_rule_cache(c);
-- 
2.22.0

