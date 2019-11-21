Return-Path: <SRS0=7szD=ZN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B119CC432C0
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 09:54:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93F292067D
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Nov 2019 09:54:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726990AbfKUJyV (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Nov 2019 04:54:21 -0500
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:49242 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726132AbfKUJyV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Nov 2019 04:54:21 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 25D4841D12;
        Thu, 21 Nov 2019 17:54:18 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v2 4/4] netfilter: nf_flow_table_offload: add tunnel encap/decap action offload support
Date:   Thu, 21 Nov 2019 17:54:16 +0800
Message-Id: <1574330056-5377-5-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574330056-5377-1-git-send-email-wenxu@ucloud.cn>
References: <1574330056-5377-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSk9KS0tLS0hJT0lPQkhZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6OlE6Shw6STg*LQ8yFk44CTwX
        IxhPFENVSlVKTkxPSEhLS05DSUhPVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhOSUM3Bg++
X-HM-Tid: 0a6e8d6245bb2086kuqy25d4841d12
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch add tunnel encap decap action offload in the flowtable
offload.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v2: put encap/decap action before redirect action

 net/netfilter/nf_flow_table_offload.c | 47 +++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 656095c..36a5103 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -469,6 +469,45 @@ static void flow_offload_redirect(const struct flow_offload *flow,
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
@@ -489,6 +528,10 @@ int nf_flow_rule_route_ipv4(struct net *net, const struct flow_offload *flow,
 	    flow->flags & FLOW_OFFLOAD_DNAT)
 		flow_offload_ipv4_checksum(net, flow, flow_rule);
 
+	flow_offload_encap_tunnel(flow, dir, flow_rule);
+
+	flow_offload_decap_tunnel(flow, dir, flow_rule);
+
 	flow_offload_redirect(flow, dir, flow_rule);
 
 	return 0;
@@ -512,6 +555,10 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
 		flow_offload_port_dnat(net, flow, dir, flow_rule);
 	}
 
+	flow_offload_encap_tunnel(flow, dir, flow_rule);
+
+	flow_offload_decap_tunnel(flow, dir, flow_rule);
+
 	flow_offload_redirect(flow, dir, flow_rule);
 
 	return 0;
-- 
1.8.3.1

