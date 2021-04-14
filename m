Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C72C433ED
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Apr 2021 11:54:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A34C06121E
	for <netfilter-devel@archiver.kernel.org>; Wed, 14 Apr 2021 11:54:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbhDNLyx (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 14 Apr 2021 07:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233708AbhDNLyZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Apr 2021 07:54:25 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E744C061574
        for <netfilter-devel@vger.kernel.org>; Wed, 14 Apr 2021 04:54:03 -0700 (PDT)
Received: from localhost ([::1]:49682 helo=tatos)
        by orbyte.nwl.cc with esmtp (Exim 4.94)
        (envelope-from <phil@nwl.cc>)
        id 1lWe5o-0003rX-9A; Wed, 14 Apr 2021 13:54:00 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: [nft PATCH] mnl: Increase BATCH_PAGE_SIZE to support huge rulesets
Date:   Wed, 14 Apr 2021 13:53:51 +0200
Message-Id: <20210414115351.29613-1-phil@nwl.cc>
X-Mailer: git-send-email 2.31.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Apply the same change from iptables-nft to nftables to keep them in
sync with regards to max supported transaction sizes.

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 src/mnl.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/src/mnl.c b/src/mnl.c
index c7ff728204502..284484fca77bc 100644
--- a/src/mnl.c
+++ b/src/mnl.c
@@ -160,11 +160,11 @@ static int check_genid(const struct nlmsghdr *nlh)
  * Batching
  */
 
-/* selected batch page is 256 Kbytes long to load ruleset of
- * half a million rules without hitting -EMSGSIZE due to large
- * iovec.
+/* Selected batch page is 2 Mbytes long to support loading a ruleset of 3.5M
+ * rules matching on source and destination address as well as input and output
+ * interfaces. This is what legacy iptables supports.
  */
-#define BATCH_PAGE_SIZE getpagesize() * 32
+#define BATCH_PAGE_SIZE 2 * 1024 * 1024
 
 struct nftnl_batch *mnl_batch_init(void)
 {
-- 
2.31.0

