Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 953C7C25B47
	for <netfilter-devel@archiver.kernel.org>; Wed, 25 Oct 2023 10:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233782AbjJYKIb (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 25 Oct 2023 06:08:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbjJYKIa (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 25 Oct 2023 06:08:30 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 28AB311F;
        Wed, 25 Oct 2023 03:08:28 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, fw@strlen.de
Subject: [PATCH net 2/2] net/sched: act_ct: additional checks for outdated flows
Date:   Wed, 25 Oct 2023 12:08:19 +0200
Message-Id: <20231025100819.2664-3-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20231025100819.2664-1-pablo@netfilter.org>
References: <20231025100819.2664-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Vlad Buslov <vladbu@nvidia.com>

Current nf_flow_is_outdated() implementation considers any flow table flow
which state diverged from its underlying CT connection status for teardown
which can be problematic in the following cases:

- Flow has never been offloaded to hardware in the first place either
because flow table has hardware offload disabled (flag
NF_FLOWTABLE_HW_OFFLOAD is not set) or because it is still pending on 'add'
workqueue to be offloaded for the first time. The former is incorrect, the
later generates excessive deletions and additions of flows.

- Flow is already pending to be updated on the workqueue. Tearing down such
flows will also generate excessive removals from the flow table, especially
on highly loaded system where the latency to re-offload a flow via 'add'
workqueue can be quite high.

When considering a flow for teardown as outdated verify that it is both
offloaded to hardware and doesn't have any pending updates.

Fixes: 41f2c7c342d3 ("net/sched: act_ct: Fix promotion of offloaded unreplied tuple")
Reviewed-by: Paul Blakey <paulb@nvidia.com>
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/sched/act_ct.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 0d44da4e8c8e..fb52d6f9aff9 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -281,6 +281,8 @@ static int tcf_ct_flow_table_fill_actions(struct net *net,
 static bool tcf_ct_flow_is_outdated(const struct flow_offload *flow)
 {
 	return test_bit(IPS_SEEN_REPLY_BIT, &flow->ct->status) &&
+	       test_bit(IPS_HW_OFFLOAD_BIT, &flow->ct->status) &&
+	       !test_bit(NF_FLOW_HW_PENDING, &flow->flags) &&
 	       !test_bit(NF_FLOW_HW_ESTABLISHED, &flow->flags);
 }
 
-- 
2.30.2

