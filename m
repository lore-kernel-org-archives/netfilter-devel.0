Return-Path: <SRS0=RCn+=2A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FD2AC43603
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Dec 2019 07:26:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0F52C206D5
	for <netfilter-devel@archiver.kernel.org>; Tue, 10 Dec 2019 07:26:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfLJH0f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 10 Dec 2019 02:26:35 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:36299 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727137AbfLJH0f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 10 Dec 2019 02:26:35 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id C0851416F3;
        Tue, 10 Dec 2019 15:26:26 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v3 4/4] netfilter: nf_flow_table_offload: add tunnel encap/decap action offload support
Date:   Tue, 10 Dec 2019 15:26:25 +0800
Message-Id: <1575962785-14812-5-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1575962785-14812-1-git-send-email-wenxu@ucloud.cn>
References: <1575962785-14812-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVS0NJS0tLS0pMSk1NSk9ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MC46KDo6HDgzSElNSBwYMAoY
        CBoKC0NVSlVKTkxOQk1JTENNQ0xDVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhOTks3Bg++
X-HM-Tid: 0a6eeeb3bbed2086kuqyc0851416f3
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch add tunnel encap decap action offload in the flowtable
offload.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v2: make decap/encap action before redirect action
v3: no change

 net/netfilter/nf_flow_table_offload.c | 47 +++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 840fc69..17d2ac0 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -476,6 +476,45 @@ static void flow_offload_redirect(const struct flow_offload *flow,
 	dev_hold(rt->dst.dev);
 }
 
+static void flow_offload_encap_tunnel(const struct flow_offload *flow,
+				      enum flow_offload_tuple_dir dir,
+				      struct nf_flow_rule *flow_rule)
+{
+	struct flow_action_entry *entry;
+	struct dst_entry *dst;
+
+	dst = flow->tuplehash[dir].tuple.dst_cache;
+	if (dst->lwtstate) {
+		struct ip_tunnel_info *tun_info;
+
+		tun_info = lwt_tun_info(dst->lwtstate);
+		if (tun_info && (tun_info->mode & IP_TUNNEL_INFO_TX)) {
+			entry = flow_action_entry_next(flow_rule);
+			entry->id = FLOW_ACTION_TUNNEL_ENCAP;
+			entry->tunnel = tun_info;
+		}
+	}
+}
+
+static void flow_offload_decap_tunnel(const struct flow_offload *flow,
+				      enum flow_offload_tuple_dir dir,
+				      struct nf_flow_rule *flow_rule)
+{
+	struct flow_action_entry *entry;
+	struct dst_entry *dst;
+
+	dst = flow->tuplehash[!dir].tuple.dst_cache;
+	if (dst->lwtstate) {
+		struct ip_tunnel_info *tun_info;
+
+		tun_info = lwt_tun_info(dst->lwtstate);
+		if (tun_info && (tun_info->mode & IP_TUNNEL_INFO_TX)) {
+			entry = flow_action_entry_next(flow_rule);
+			entry->id = FLOW_ACTION_TUNNEL_DECAP;
+		}
+	}
+}
+
 int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule)
@@ -496,6 +535,10 @@ int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
 	    flow->flags & FLOW_OFFLOAD_DNAT)
 		flow_offload_ipv4_checksum(net, flow, flow_rule);
 
+	flow_offload_decap_tunnel(flow, dir, flow_rule);
+
+	flow_offload_encap_tunnel(flow, dir, flow_rule);
+
 	flow_offload_redirect(flow, dir, flow_rule);
 
 	return 0;
@@ -519,6 +562,10 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
 		flow_offload_port_dnat(net, flow, dir, flow_rule);
 	}
 
+	flow_offload_decap_tunnel(flow, dir, flow_rule);
+
+	flow_offload_encap_tunnel(flow, dir, flow_rule);
+
 	flow_offload_redirect(flow, dir, flow_rule);
 
 	return 0;
-- 
1.8.3.1

