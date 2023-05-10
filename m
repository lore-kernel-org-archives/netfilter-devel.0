Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B5C2C7EE22
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 May 2023 07:37:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235899AbjEJHg6 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 May 2023 03:36:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjEJHg5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2023 03:36:57 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 059DC1BFD
        for <netfilter-devel@vger.kernel.org>; Wed, 10 May 2023 00:36:52 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/3] netfilter: flowtable: simplify route logic
Date:   Wed, 10 May 2023 09:36:42 +0200
Message-Id: <20230510073644.105679-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Grab reference to dst from skbuff earlier to simplify route caching.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_flow_table.h |  4 ++--
 net/netfilter/nf_flow_table_core.c    | 24 +++---------------------
 net/netfilter/nft_flow_offload.c      | 12 ++++++++----
 3 files changed, 13 insertions(+), 27 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index ebb28ec5b6fa..546fc4a9b939 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -263,8 +263,8 @@ nf_flow_table_offload_del_cb(struct nf_flowtable *flow_table,
 	up_write(&flow_table->flow_block_lock);
 }
 
-int flow_offload_route_init(struct flow_offload *flow,
-			    const struct nf_flow_route *route);
+void flow_offload_route_init(struct flow_offload *flow,
+			     const struct nf_flow_route *route);
 
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow);
 void flow_offload_refresh(struct nf_flowtable *flow_table,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 04bd0ed4d2ae..b46dd897f2c5 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -125,9 +125,6 @@ static int flow_offload_fill_route(struct flow_offload *flow,
 		break;
 	case FLOW_OFFLOAD_XMIT_XFRM:
 	case FLOW_OFFLOAD_XMIT_NEIGH:
-		if (!dst_hold_safe(route->tuple[dir].dst))
-			return -1;
-
 		flow_tuple->dst_cache = dst;
 		flow_tuple->dst_cookie = flow_offload_dst_cookie(flow_tuple);
 		break;
@@ -148,27 +145,12 @@ static void nft_flow_dst_release(struct flow_offload *flow,
 		dst_release(flow->tuplehash[dir].tuple.dst_cache);
 }
 
-int flow_offload_route_init(struct flow_offload *flow,
+void flow_offload_route_init(struct flow_offload *flow,
 			    const struct nf_flow_route *route)
 {
-	int err;
-
-	err = flow_offload_fill_route(flow, route, FLOW_OFFLOAD_DIR_ORIGINAL);
-	if (err < 0)
-		return err;
-
-	err = flow_offload_fill_route(flow, route, FLOW_OFFLOAD_DIR_REPLY);
-	if (err < 0)
-		goto err_route_reply;
-
+	flow_offload_fill_route(flow, route, FLOW_OFFLOAD_DIR_ORIGINAL);
+	flow_offload_fill_route(flow, route, FLOW_OFFLOAD_DIR_REPLY);
 	flow->type = NF_FLOW_OFFLOAD_ROUTE;
-
-	return 0;
-
-err_route_reply:
-	nft_flow_dst_release(flow, FLOW_OFFLOAD_DIR_ORIGINAL);
-
-	return err;
 }
 EXPORT_SYMBOL_GPL(flow_offload_route_init);
 
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index e860d8fe0e5e..5ef9146e74ad 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -250,9 +250,14 @@ static int nft_flow_route(const struct nft_pktinfo *pkt,
 		break;
 	}
 
+	if (!dst_hold_safe(this_dst))
+		return -ENOENT;
+
 	nf_route(nft_net(pkt), &other_dst, &fl, false, nft_pf(pkt));
-	if (!other_dst)
+	if (!other_dst) {
+		dst_release(this_dst);
 		return -ENOENT;
+	}
 
 	nft_default_forward_path(route, this_dst, dir);
 	nft_default_forward_path(route, other_dst, !dir);
@@ -349,8 +354,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (!flow)
 		goto err_flow_alloc;
 
-	if (flow_offload_route_init(flow, &route) < 0)
-		goto err_flow_add;
+	flow_offload_route_init(flow, &route);
 
 	if (tcph) {
 		ct->proto.tcp.seen[0].flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
@@ -361,12 +365,12 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (ret < 0)
 		goto err_flow_add;
 
-	dst_release(route.tuple[!dir].dst);
 	return;
 
 err_flow_add:
 	flow_offload_free(flow);
 err_flow_alloc:
+	dst_release(route.tuple[dir].dst);
 	dst_release(route.tuple[!dir].dst);
 err_flow_route:
 	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
-- 
2.30.2

