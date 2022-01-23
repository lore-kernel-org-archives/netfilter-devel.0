Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DD4CC433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 23 Jan 2022 14:24:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232277AbiAWOYI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 23 Jan 2022 09:24:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232290AbiAWOYI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 23 Jan 2022 09:24:08 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D9AC06173B
        for <netfilter-devel@vger.kernel.org>; Sun, 23 Jan 2022 06:24:07 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1nBdmn-0001Oz-4z; Sun, 23 Jan 2022 15:24:05 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>,
        kernel test robot <oliver.sang@intel.com>
Subject: [PATCH nf] netfilter: nft_ct: fix use after free when attaching zone template
Date:   Sun, 23 Jan 2022 15:24:00 +0100
Message-Id: <20220123142400.533506-1-fw@strlen.de>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The conversion erronously removed the refcount increment.
In case we can use the percpu template, we need to increment
the refcount, else it will be released when the skb gets freed.

In case the slowpath is taken, the new template already has a
refcount of 1.

Fixes: 719774377622 ("netfilter: conntrack: convert to refcount_t api")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nft_ct.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_ct.c b/net/netfilter/nft_ct.c
index 518d96c8c247..5adf8bb628a8 100644
--- a/net/netfilter/nft_ct.c
+++ b/net/netfilter/nft_ct.c
@@ -260,9 +260,12 @@ static void nft_ct_set_zone_eval(const struct nft_expr *expr,
 	ct = this_cpu_read(nft_ct_pcpu_template);
 
 	if (likely(refcount_read(&ct->ct_general.use) == 1)) {
+		refcount_inc(&ct->ct_general.use);
 		nf_ct_zone_add(ct, &zone);
 	} else {
-		/* previous skb got queued to userspace */
+		/* previous skb got queued to userspace, allocate temporary
+		 * one until percpu template can be reused.
+		 */
 		ct = nf_ct_tmpl_alloc(nft_net(pkt), &zone, GFP_ATOMIC);
 		if (!ct) {
 			regs->verdict.code = NF_DROP;
-- 
2.34.1

