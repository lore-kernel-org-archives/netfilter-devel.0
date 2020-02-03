Return-Path: <SRS0=ffOv=3X=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0705C33CAC
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 12:06:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A36AE20721
	for <netfilter-devel@archiver.kernel.org>; Mon,  3 Feb 2020 12:06:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbgBCMG1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 3 Feb 2020 07:06:27 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:57882 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727794AbgBCMG1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 3 Feb 2020 07:06:27 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1iyaUj-0003sw-I8; Mon, 03 Feb 2020 13:06:25 +0100
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: flowtable: always init block_offload struct
Date:   Mon,  3 Feb 2020 13:06:18 +0100
Message-Id: <20200203120618.2574-1-fw@strlen.de>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

nftables test case
tests/shell/testcases/flowtable/0001flowtable_0

results in a crash. After the refactor, if we leave early via
nf_flowtable_hw_offload(), then "struct flow_block_offload" is left
in an uninitialized state, but later users assume its initialised.

Fixes: a7965d58ddab02 ("netfilter: flowtable: add nf_flow_table_offload_cmd()")
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 I can't test this with HW offload, but at least it gets rid of
 the crash for me.

 net/netfilter/nf_flow_table_offload.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index c8b70ffeef0c..f909938e8dc4 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -846,12 +846,6 @@ static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 {
 	int err;
 
-	if (!nf_flowtable_hw_offload(flowtable))
-		return 0;
-
-	if (!dev->netdev_ops->ndo_setup_tc)
-		return -EOPNOTSUPP;
-
 	memset(bo, 0, sizeof(*bo));
 	bo->net		= dev_net(dev);
 	bo->block	= &flowtable->flow_block;
@@ -860,6 +854,12 @@ static int nf_flow_table_offload_cmd(struct flow_block_offload *bo,
 	bo->extack	= extack;
 	INIT_LIST_HEAD(&bo->cb_list);
 
+	if (!nf_flowtable_hw_offload(flowtable))
+		return 0;
+
+	if (!dev->netdev_ops->ndo_setup_tc)
+		return -EOPNOTSUPP;
+
 	err = dev->netdev_ops->ndo_setup_tc(dev, TC_SETUP_FT, bo);
 	if (err < 0)
 		return err;
-- 
2.24.1

