Return-Path: <SRS0=JGmF=W2=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99201C3A5A3
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Aug 2019 04:17:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7274621897
	for <netfilter-devel@archiver.kernel.org>; Fri, 30 Aug 2019 04:17:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726849AbfH3ERh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 30 Aug 2019 00:17:37 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:42659 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726219AbfH3ERh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 30 Aug 2019 00:17:37 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id A43344171B;
        Fri, 30 Aug 2019 12:17:22 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v7 1/8] netfilter:nf_flow_table: Refactor flow_offload_tuple to destination
Date:   Fri, 30 Aug 2019 12:17:15 +0800
Message-Id: <1567138642-11446-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1567138642-11446-1-git-send-email-wenxu@ucloud.cn>
References: <1567138642-11446-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVkpVS05MS0tLS09KS0tDWVdZKFlBSU
        I3V1ktWUFJV1kJDhceCFlBWTU0KTY6NyQpLjc#WQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PBA6EAw4Szg0DzJWFC0NLzYC
        IzUKFC9VSlVKTk1MSkhDTU9JTExPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUxMQ003Bg++
X-HM-Tid: 0a6ce0bdfafc2086kuqya43344171b
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

Add struct flow_offload_dst to support more offload method to replace
dst_cache which only work for route offload.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v7: rebase with upstream fix

 include/net/netfilter/nf_flow_table.h | 12 ++++++++++--
 net/netfilter/nf_flow_table_core.c    | 24 ++++++++++++------------
 net/netfilter/nf_flow_table_ip.c      |  4 ++--
 net/netfilter/nft_flow_offload.c      | 10 +++++-----
 4 files changed, 29 insertions(+), 21 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 609df33..f58e09c 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -36,6 +36,10 @@ enum flow_offload_tuple_dir {
 	FLOW_OFFLOAD_DIR_MAX = IP_CT_DIR_MAX
 };
 
+struct flow_offload_dst {
+	struct dst_entry		*dst_cache;
+};
+
 struct flow_offload_tuple {
 	union {
 		struct in_addr		src_v4;
@@ -58,7 +62,7 @@ struct flow_offload_tuple {
 
 	u16				mtu;
 
-	struct dst_entry		*dst_cache;
+	struct flow_offload_dst		dst;
 };
 
 struct flow_offload_tuple_rhash {
@@ -88,8 +92,12 @@ struct nf_flow_route {
 	} tuple[FLOW_OFFLOAD_DIR_MAX];
 };
 
+struct nf_flow_dst {
+	struct nf_flow_route route;
+};
+
 struct flow_offload *flow_offload_alloc(struct nf_conn *ct,
-					struct nf_flow_route *route);
+					struct nf_flow_dst *flow_dst);
 void flow_offload_free(struct flow_offload *flow);
 
 int flow_offload_add(struct nf_flowtable *flow_table, struct flow_offload *flow);
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 80a8f9ae..e9bc756 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -24,13 +24,13 @@ struct flow_offload_entry {
 
 static void
 flow_offload_fill_dir(struct flow_offload *flow, struct nf_conn *ct,
-		      struct nf_flow_route *route,
+		      struct nf_flow_dst *flow_dst,
 		      enum flow_offload_tuple_dir dir)
 {
 	struct flow_offload_tuple *ft = &flow->tuplehash[dir].tuple;
 	struct nf_conntrack_tuple *ctt = &ct->tuplehash[dir].tuple;
-	struct dst_entry *other_dst = route->tuple[!dir].dst;
-	struct dst_entry *dst = route->tuple[dir].dst;
+	struct dst_entry *other_dst = flow_dst->route.tuple[!dir].dst;
+	struct dst_entry *dst = flow_dst->route.tuple[dir].dst;
 
 	ft->dir = dir;
 
@@ -53,11 +53,11 @@ struct flow_offload_entry {
 	ft->dst_port = ctt->dst.u.tcp.port;
 
 	ft->iifidx = other_dst->dev->ifindex;
-	ft->dst_cache = dst;
+	ft->dst.dst_cache = dst;
 }
 
 struct flow_offload *
-flow_offload_alloc(struct nf_conn *ct, struct nf_flow_route *route)
+flow_offload_alloc(struct nf_conn *ct, struct nf_flow_dst *flow_dst)
 {
 	struct flow_offload_entry *entry;
 	struct flow_offload *flow;
@@ -72,16 +72,16 @@ struct flow_offload *
 
 	flow = &entry->flow;
 
-	if (!dst_hold_safe(route->tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst))
+	if (!dst_hold_safe(flow_dst->route.tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst))
 		goto err_dst_cache_original;
 
-	if (!dst_hold_safe(route->tuple[FLOW_OFFLOAD_DIR_REPLY].dst))
+	if (!dst_hold_safe(flow_dst->route.tuple[FLOW_OFFLOAD_DIR_REPLY].dst))
 		goto err_dst_cache_reply;
 
 	entry->ct = ct;
 
-	flow_offload_fill_dir(flow, ct, route, FLOW_OFFLOAD_DIR_ORIGINAL);
-	flow_offload_fill_dir(flow, ct, route, FLOW_OFFLOAD_DIR_REPLY);
+	flow_offload_fill_dir(flow, ct, flow_dst, FLOW_OFFLOAD_DIR_ORIGINAL);
+	flow_offload_fill_dir(flow, ct, flow_dst, FLOW_OFFLOAD_DIR_REPLY);
 
 	if (ct->status & IPS_SRC_NAT)
 		flow->flags |= FLOW_OFFLOAD_SNAT;
@@ -91,7 +91,7 @@ struct flow_offload *
 	return flow;
 
 err_dst_cache_reply:
-	dst_release(route->tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst);
+	dst_release(flow_dst->route.tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst);
 err_dst_cache_original:
 	kfree(entry);
 err_ct_refcnt:
@@ -153,8 +153,8 @@ void flow_offload_free(struct flow_offload *flow)
 {
 	struct flow_offload_entry *e;
 
-	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst_cache);
-	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst_cache);
+	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst.dst_cache);
+	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst.dst_cache);
 	e = container_of(flow, struct flow_offload_entry, flow);
 	if (flow->flags & FLOW_OFFLOAD_DYING)
 		nf_ct_delete(e->ct, 0, 0);
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index d68c801..3ff7b04 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -260,7 +260,7 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
-	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst_cache;
+	rt = (struct rtable *)flow->tuplehash[dir].tuple.dst.dst_cache;
 	outdev = rt->dst.dev;
 
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
@@ -488,7 +488,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 
 	dir = tuplehash->tuple.dir;
 	flow = container_of(tuplehash, struct flow_offload, tuplehash[dir]);
-	rt = (struct rt6_info *)flow->tuplehash[dir].tuple.dst_cache;
+	rt = (struct rt6_info *)flow->tuplehash[dir].tuple.dst.dst_cache;
 	outdev = rt->dst.dev;
 
 	if (unlikely(nf_flow_exceeds_mtu(skb, flow->tuplehash[dir].tuple.mtu)))
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 060a4ed..2dd0d3e 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -74,7 +74,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	struct nf_flowtable *flowtable = &priv->flowtable->data;
 	struct tcphdr _tcph, *tcph = NULL;
 	enum ip_conntrack_info ctinfo;
-	struct nf_flow_route route;
+	struct nf_flow_dst flow_dst;
 	struct flow_offload *flow;
 	enum ip_conntrack_dir dir;
 	struct nf_conn *ct;
@@ -111,10 +111,10 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 		goto out;
 
 	dir = CTINFO2DIR(ctinfo);
-	if (nft_flow_route(pkt, ct, &route, dir) < 0)
+	if (nft_flow_route(pkt, ct, &flow_dst.route, dir) < 0)
 		goto err_flow_route;
 
-	flow = flow_offload_alloc(ct, &route);
+	flow = flow_offload_alloc(ct, &flow_dst);
 	if (!flow)
 		goto err_flow_alloc;
 
@@ -127,13 +127,13 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (ret < 0)
 		goto err_flow_add;
 
-	dst_release(route.tuple[!dir].dst);
+	dst_release(flow_dst.route.tuple[!dir].dst);
 	return;
 
 err_flow_add:
 	flow_offload_free(flow);
 err_flow_alloc:
-	dst_release(route.tuple[!dir].dst);
+	dst_release(flow_dst.route.tuple[!dir].dst);
 err_flow_route:
 	clear_bit(IPS_OFFLOAD_BIT, &ct->status);
 out:
-- 
1.8.3.1

