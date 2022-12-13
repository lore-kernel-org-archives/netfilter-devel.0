Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A957C4332F
	for <netfilter-devel@archiver.kernel.org>; Tue, 13 Dec 2022 14:10:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235919AbiLMOK0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 13 Dec 2022 09:10:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235822AbiLMOJ6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 13 Dec 2022 09:09:58 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D778D2126A;
        Tue, 13 Dec 2022 06:09:31 -0800 (PST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
Subject: [PATCH net 1/3] netfilter: flowtable: really fix NAT IPv6 offload
Date:   Tue, 13 Dec 2022 15:09:21 +0100
Message-Id: <20221213140923.154594-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20221213140923.154594-1-pablo@netfilter.org>
References: <20221213140923.154594-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Qingfang DENG <dqfext@gmail.com>

The for-loop was broken from the start. It translates to:

	for (i = 0; i < 4; i += 4)

which means the loop statement is run only once, so only the highest
32-bit of the IPv6 address gets mangled.

Fix the loop increment.

Fixes: 0e07e25b481a ("netfilter: flowtable: fix NAT IPv6 offload mangling")
Fixes: 5c27d8d76ce8 ("netfilter: nf_flow_table_offload: add IPv6 support")
Signed-off-by: Qingfang DENG <dqfext@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 0fdcdb2c9ae4..4d9b99abe37d 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -383,12 +383,12 @@ static void flow_offload_ipv6_mangle(struct nf_flow_rule *flow_rule,
 				     const __be32 *addr, const __be32 *mask)
 {
 	struct flow_action_entry *entry;
-	int i, j;
+	int i;
 
-	for (i = 0, j = 0; i < sizeof(struct in6_addr) / sizeof(u32); i += sizeof(u32), j++) {
+	for (i = 0; i < sizeof(struct in6_addr) / sizeof(u32); i++) {
 		entry = flow_action_entry_next(flow_rule);
 		flow_offload_mangle(entry, FLOW_ACT_MANGLE_HDR_TYPE_IP6,
-				    offset + i, &addr[j], mask);
+				    offset + i * sizeof(u32), &addr[i], mask);
 	}
 }
 
-- 
2.30.2

