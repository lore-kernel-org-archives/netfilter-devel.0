Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0734AC636CA
	for <netfilter-devel@archiver.kernel.org>; Sat, 17 Jul 2021 08:28:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DE0C8613C0
	for <netfilter-devel@archiver.kernel.org>; Sat, 17 Jul 2021 08:28:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231920AbhGQIb2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 17 Jul 2021 04:31:28 -0400
Received: from mail.netfilter.org ([217.70.188.207]:46236 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230081AbhGQIb2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Jul 2021 04:31:28 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7D0476164A
        for <netfilter-devel@vger.kernel.org>; Sat, 17 Jul 2021 10:28:10 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 1/2] netfilter: flowtable: avoid possible false sharing
Date:   Sat, 17 Jul 2021 10:28:29 +0200
Message-Id: <20210717082830.7169-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The flowtable follows the same timeout approach as conntrack, use the
same idiom as in cc16921351d8 ("netfilter: conntrack: avoid same-timeout
update") but also include the fix provided by e37542ba111f ("netfilter:
conntrack: avoid possible false sharing").

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_core.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 1e50908b1b7e..551976e4284c 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -331,7 +331,11 @@ EXPORT_SYMBOL_GPL(flow_offload_add);
 void flow_offload_refresh(struct nf_flowtable *flow_table,
 			  struct flow_offload *flow)
 {
-	flow->timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
+	u32 timeout;
+
+	timeout = nf_flowtable_time_stamp + flow_offload_get_timeout(flow);
+	if (READ_ONCE(flow->timeout) != timeout)
+		WRITE_ONCE(flow->timeout, timeout);
 
 	if (likely(!nf_flowtable_hw_offload(flow_table)))
 		return;
-- 
2.30.2

