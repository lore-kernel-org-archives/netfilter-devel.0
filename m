Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D577C197A0
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Nov 2023 16:30:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229948AbjKTQaR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Nov 2023 11:30:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjKTQaR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Nov 2023 11:30:17 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C654A7
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Nov 2023 08:30:14 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1r57A4-0007GA-Uh; Mon, 20 Nov 2023 17:30:12 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next] netfilter: flowtable: reorder nf_flowtable struct members
Date:   Mon, 20 Nov 2023 17:29:58 +0100
Message-ID: <20231120163002.9781-1-fw@strlen.de>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Place the read-mostly parts accessed by the datapath first.

In particular, we do access ->flags member (to see if HW offload
is enabled) for every single packet, but this is placed in the 5th
cacheline.

priority could stay where it is, but move it too to cover a hole.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 include/net/netfilter/nf_flow_table.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index fe1507c1db82..36351e441316 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -72,12 +72,13 @@ enum nf_flowtable_flags {
 };
 
 struct nf_flowtable {
-	struct list_head		list;
-	struct rhashtable		rhashtable;
-	int				priority;
+	unsigned int			flags;		/* readonly in datapath */
+	int				priority;	/* control path (padding hole) */
+	struct rhashtable		rhashtable;	/* datapath, read-mostly members come first */
+
+	struct list_head		list;		/* slowpath parts */
 	const struct nf_flowtable_type	*type;
 	struct delayed_work		gc_work;
-	unsigned int			flags;
 	struct flow_block		flow_block;
 	struct rw_semaphore		flow_block_lock; /* Guards flow_block */
 	possible_net_t			net;
-- 
2.41.0

