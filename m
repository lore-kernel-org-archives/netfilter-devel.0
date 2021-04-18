Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52D4EC43462
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Apr 2021 21:04:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2E9876100B
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Apr 2021 21:04:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235718AbhDRVE7 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Apr 2021 17:04:59 -0400
Received: from mail.netfilter.org ([217.70.188.207]:34996 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbhDRVE4 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Apr 2021 17:04:56 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id D742763E8B;
        Sun, 18 Apr 2021 23:03:57 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 08/14] netfilter: flowtable: Add FLOW_OFFLOAD_XMIT_UNSPEC xmit type
Date:   Sun, 18 Apr 2021 23:04:09 +0200
Message-Id: <20210418210415.4719-9-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210418210415.4719-1-pablo@netfilter.org>
References: <20210418210415.4719-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

It could be xmit type was not set and would default to FLOW_OFFLOAD_XMIT_NEIGH
and in this type the gc expect to have a route info.
Fix that by adding FLOW_OFFLOAD_XMIT_UNSPEC which defaults to 0.

Fixes: 8b9229d15877 ("netfilter: flowtable: dst_check() from garbage collector path")
Signed-off-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h | 3 ++-
 net/netfilter/nf_flow_table_core.c    | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index d46e422c9d10..51d8eb99764d 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -92,7 +92,8 @@ enum flow_offload_tuple_dir {
 #define FLOW_OFFLOAD_DIR_MAX	IP_CT_DIR_MAX
 
 enum flow_offload_xmit_type {
-	FLOW_OFFLOAD_XMIT_NEIGH		= 0,
+	FLOW_OFFLOAD_XMIT_UNSPEC	= 0,
+	FLOW_OFFLOAD_XMIT_NEIGH,
 	FLOW_OFFLOAD_XMIT_XFRM,
 	FLOW_OFFLOAD_XMIT_DIRECT,
 };
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 76573bae6664..39c02d1aeedf 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -130,6 +130,9 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		flow_tuple->dst_cache = dst;
 		flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple);
 		break;
+	default:
+		WARN_ON_ONCE(1);
+		break;
 	}
 	flow_tuple->xmit_type = route->tuple[dir].xmit_type;
 
-- 
2.30.2

