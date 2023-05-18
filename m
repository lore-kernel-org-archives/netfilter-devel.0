Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CB64C7EE23
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 May 2023 10:08:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbjERKIa (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 May 2023 06:08:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230303AbjERKI1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 May 2023 06:08:27 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBC11BD6;
        Thu, 18 May 2023 03:08:25 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1pzaYV-0005pm-Lq; Thu, 18 May 2023 12:08:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netdev@vger.kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH net-next 7/9] netfilter: flowtable: simplify route logic
Date:   Thu, 18 May 2023 12:07:57 +0200
Message-Id: <20230518100759.84858-8-fw@strlen.de>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230518100759.84858-1-fw@strlen.de>
References: <20230518100759.84858-1-fw@strlen.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

Grab reference to dst from skbuff earlier to simplify route caching.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
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
2.40.1

