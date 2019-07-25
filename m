Return-Path: <SRS0=uZng=VW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA974C76191
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 11:13:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7B75821901
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Jul 2019 11:13:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403888AbfGYLNE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Jul 2019 07:13:04 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:19972 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403879AbfGYLNE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Jul 2019 07:13:04 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 690BA41D7B;
        Thu, 25 Jul 2019 19:12:57 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v6 5/8] netfilter:nf_flow_table_core: Support bridge family flow offload
Date:   Thu, 25 Jul 2019 19:12:53 +0800
Message-Id: <1564053176-28605-6-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1564053176-28605-1-git-send-email-wenxu@ucloud.cn>
References: <1564053176-28605-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSUlMS0tLSUhNTkpKSUhZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OVE6MCo5PTg0FFYfQg48Pw4D
        Sj0wFE5VSlVKTk1PS05ISkxMT0NCVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQU1PSks3Bg++
X-HM-Tid: 0a6c28d584612086kuqy690ba41d7b
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

With nf_conntrack_bridge function. The bridge family can do
conntrack it self. The flow offload function based on the
conntrack. This patch add bridge family operation in
nf_flow_table_core

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v6: no change

 include/net/netfilter/nf_flow_table.h | 31 +++++++++++++++++--
 net/netfilter/nf_flow_table_core.c    | 58 +++++++++++++++++++++++++++++------
 2 files changed, 78 insertions(+), 11 deletions(-)

diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index d40d409..dcf197a 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -33,8 +33,23 @@ enum flow_offload_tuple_dir {
 	FLOW_OFFLOAD_DIR_MAX = IP_CT_DIR_MAX
 };
 
+enum flow_offload_tuple_type {
+	FLOW_OFFLOAD_TYPE_INET,
+	FLOW_OFFLOAD_TYPE_BRIDGE,
+};
+
+struct dst_br_port {
+	struct net_device *dev;
+	u16	dst_vlan_tag;
+	u16	vlan_proto;
+};
+
 struct flow_offload_dst {
-	struct dst_entry		*dst_cache;
+	enum flow_offload_tuple_type type;
+	union {
+		struct dst_entry		*dst_cache;
+		struct dst_br_port		dst_port;
+	};
 };
 
 struct flow_offload_tuple {
@@ -52,6 +67,7 @@ struct flow_offload_tuple {
 	};
 
 	int				iifidx;
+	u16				vlan_tag;
 
 	u8				l3proto;
 	u8				l4proto;
@@ -89,8 +105,19 @@ struct nf_flow_route {
 	} tuple[FLOW_OFFLOAD_DIR_MAX];
 };
 
+struct nf_flow_forward {
+	struct {
+		struct dst_br_port	dst_port;
+		u16 vlan_tag;
+	} tuple[FLOW_OFFLOAD_DIR_MAX];
+};
+
 struct nf_flow_dst {
-	struct nf_flow_route route;
+	enum flow_offload_tuple_type type;
+	union {
+		struct nf_flow_route route;
+		struct nf_flow_forward forward;
+	};
 };
 
 struct flow_offload *flow_offload_alloc(struct nf_conn *ct,
diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
index 2bec409..08c1ca4 100644
--- a/net/netfilter/nf_flow_table_core.c
+++ b/net/netfilter/nf_flow_table_core.c
@@ -36,6 +36,21 @@ struct flow_offload_entry {
 	return dst;
 }
 
+static struct dst_br_port *
+flow_offload_fill_bridge_dst(struct flow_offload_tuple *ft,
+			     struct nf_flow_forward *forward,
+			     enum flow_offload_tuple_dir dir)
+{
+	struct dst_br_port other_dst_port = forward->tuple[!dir].dst_port;
+	struct dst_br_port dst_port = forward->tuple[dir].dst_port;
+
+	ft->iifidx = other_dst_port.dev->ifindex;
+	ft->dst.dst_port = dst_port;
+	ft->vlan_tag = forward->tuple[dir].vlan_tag;
+
+	return &ft->dst.dst_port;
+}
+
 static void
 flow_offload_fill_dir(struct flow_offload *flow, struct nf_conn *ct,
 		      struct nf_flow_dst *flow_dst,
@@ -43,16 +58,29 @@ struct flow_offload_entry {
 {
 	struct flow_offload_tuple *ft = &flow->tuplehash[dir].tuple;
 	struct nf_conntrack_tuple *ctt = &ct->tuplehash[dir].tuple;
+	struct dst_br_port *dst_port;
 	struct dst_entry *dst;
 
-	dst = flow_offload_fill_inet_dst(ft, &flow_dst->route, dir);
+	switch (flow_dst->type) {
+	case FLOW_OFFLOAD_TYPE_INET:
+		dst = flow_offload_fill_inet_dst(ft, &flow_dst->route, dir);
+		break;
+	case FLOW_OFFLOAD_TYPE_BRIDGE:
+		dst_port = flow_offload_fill_bridge_dst(ft, &flow_dst->forward, dir);
+		break;
+	}
+
+	ft->dst.type = flow_dst->type;
 	ft->dir = dir;
 
 	switch (ctt->src.l3num) {
 	case NFPROTO_IPV4:
 		ft->src_v4 = ctt->src.u3.in;
 		ft->dst_v4 = ctt->dst.u3.in;
-		ft->mtu = ip_dst_mtu_maybe_forward(dst, true);
+		if (flow_dst->type == FLOW_OFFLOAD_TYPE_INET)
+			ft->mtu = ip_dst_mtu_maybe_forward(dst, true);
+		else
+			ft->mtu = dst_port->dev->mtu;
 		break;
 	case NFPROTO_IPV6:
 		ft->src_v6 = ctt->src.u3.in6;
@@ -67,13 +95,13 @@ struct flow_offload_entry {
 	ft->dst_port = ctt->dst.u.tcp.port;
 }
 
-static int flow_offload_dst_hold(struct nf_flow_dst *flow_dst)
+static int flow_offload_dst_hold(struct nf_flow_route *route)
 {
-	if (!dst_hold_safe(flow_dst->route.tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst))
+	if (!dst_hold_safe(route->tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst))
 		return -1;
 
-	if (!dst_hold_safe(flow_dst->route.tuple[FLOW_OFFLOAD_DIR_REPLY].dst)) {
-		dst_release(flow_dst->route.tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst);
+	if (!dst_hold_safe(route->tuple[FLOW_OFFLOAD_DIR_REPLY].dst)) {
+		dst_release(route->tuple[FLOW_OFFLOAD_DIR_ORIGINAL].dst);
 		return -1;
 	}
 
@@ -96,7 +124,8 @@ struct flow_offload *
 
 	flow = &entry->flow;
 
-	if (flow_offload_dst_hold(flow_dst))
+	if (flow_dst->type == FLOW_OFFLOAD_TYPE_INET &&
+	    flow_offload_dst_hold(&flow_dst->route))
 		goto err_dst_cache;
 
 	entry->ct = ct;
@@ -156,8 +185,19 @@ static void flow_offload_fixup_ct_state(struct nf_conn *ct)
 
 static void flow_offload_dst_release(struct flow_offload *flow)
 {
-	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst.dst_cache);
-	dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst.dst_cache);
+	enum flow_offload_tuple_type type = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst.type;
+
+	switch (type) {
+	case FLOW_OFFLOAD_TYPE_INET:
+		dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst.dst_cache);
+		dst_release(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst.dst_cache);
+		break;
+
+	case FLOW_OFFLOAD_TYPE_BRIDGE:
+		dev_put(flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.dst.dst_port.dev);
+		dev_put(flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple.dst.dst_port.dev);
+		break;
+	}
 }
 
 void flow_offload_free(struct flow_offload *flow)
-- 
1.8.3.1

