Return-Path: <SRS0=uN83=25=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E250C282DD
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 23:17:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59B7F20692
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jan 2020 23:17:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727652AbgAHXRm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jan 2020 18:17:42 -0500
Received: from correo.us.es ([193.147.175.20]:43170 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727237AbgAHXRY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jan 2020 18:17:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4A363FF9C7
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 00:17:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3E29CDA709
        for <netfilter-devel@vger.kernel.org>; Thu,  9 Jan 2020 00:17:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 30D1CDA799; Thu,  9 Jan 2020 00:17:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29E80DA703;
        Thu,  9 Jan 2020 00:17:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 09 Jan 2020 00:17:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 0336A426CCB9;
        Thu,  9 Jan 2020 00:17:19 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 3/9] netfilter: nf_flow_table_offload: fix incorrect ethernet dst address
Date:   Thu,  9 Jan 2020 00:17:07 +0100
Message-Id: <20200108231713.100458-4-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200108231713.100458-1-pablo@netfilter.org>
References: <20200108231713.100458-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Ethernet destination for original traffic takes the source ethernet address
in the reply direction. For reply traffic, this takes the source
ethernet address of the original direction.

Fixes: c29f74e0df7a ("netfilter: nf_flow_table: hardware offload support")
Signed-off-by: wenxu <wenxu@ucloud.cn>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_offload.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 0d72e5ccb47b..ee9edbe50d4f 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -166,14 +166,16 @@ static int flow_offload_eth_dst(struct net *net,
 				enum flow_offload_tuple_dir dir,
 				struct nf_flow_rule *flow_rule)
 {
-	const struct flow_offload_tuple *tuple = &flow->tuplehash[dir].tuple;
 	struct flow_action_entry *entry0 = flow_action_entry_next(flow_rule);
 	struct flow_action_entry *entry1 = flow_action_entry_next(flow_rule);
+	const void *daddr = &flow->tuplehash[!dir].tuple.src_v4;
+	const struct dst_entry *dst_cache;
 	struct neighbour *n;
 	u32 mask, val;
 	u16 val16;
 
-	n = dst_neigh_lookup(tuple->dst_cache, &tuple->dst_v4);
+	dst_cache = flow->tuplehash[dir].tuple.dst_cache;
+	n = dst_neigh_lookup(dst_cache, daddr);
 	if (!n)
 		return -ENOENT;
 
-- 
2.11.0

