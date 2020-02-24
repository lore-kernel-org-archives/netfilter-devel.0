Return-Path: <SRS0=eo3W=4M=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FDEAC35679
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 05:29:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 01F4120661
	for <netfilter-devel@archiver.kernel.org>; Mon, 24 Feb 2020 05:29:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgBXF3i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 24 Feb 2020 00:29:38 -0500
Received: from m9785.mail.qiye.163.com ([220.181.97.85]:43317 "EHLO
        m9785.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726810AbgBXF3i (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 24 Feb 2020 00:29:38 -0500
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9785.mail.qiye.163.com (Hmail) with ESMTPA id 3D5A05C18AC;
        Mon, 24 Feb 2020 13:22:56 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next v5 4/4] netfilter: flowtable: add tunnel encap/decap action offload support
Date:   Mon, 24 Feb 2020 13:22:55 +0800
Message-Id: <1582521775-25176-5-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1582521775-25176-1-git-send-email-wenxu@ucloud.cn>
References: <1582521775-25176-1-git-send-email-wenxu@ucloud.cn>
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZVklVSkJMS0tLSU1OSklKT01ZV1koWU
        FJQjdXWS1ZQUlXWQkOFx4IWUFZNTQpNjo3JCkuNz5ZBg++
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6P1E6Dxw5DDg8DiwDEBkSHUMP
        LhlPCUpVSlVKTkNJTklKTExNSEtNVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUhPTkk3Bg++
X-HM-Tid: 0a7075a5f88d2087kuqy3d5a05c18ac
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

This patch add tunnel encap decap action offload in the flowtable
offload.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
v5: no change

 net/netfilter/nf_flow_table_offload.c | 47 +++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index 413f98a..a706d6e 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -504,10 +504,53 @@ static void flow_offload_redirect(const struct flow_offload *flow,
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
 {
+	flow_offload_decap_tunnel(flow, dir, flow_rule);
+
+	flow_offload_encap_tunnel(flow, dir, flow_rule);
+
 	if (flow_offload_eth_src(net, flow, dir, flow_rule) < 0 ||
 	    flow_offload_eth_dst(net, flow, dir, flow_rule) < 0)
 		return -1;
@@ -534,6 +577,10 @@ int nf_flow_rule_route_ipv6(struct net *net, const struct flow_offload *flow,
 			    enum flow_offload_tuple_dir dir,
 			    struct nf_flow_rule *flow_rule)
 {
+	flow_offload_decap_tunnel(flow, dir, flow_rule);
+
+	flow_offload_encap_tunnel(flow, dir, flow_rule);
+
 	if (flow_offload_eth_src(net, flow, dir, flow_rule) < 0 ||
 	    flow_offload_eth_dst(net, flow, dir, flow_rule) < 0)
 		return -1;
-- 
1.8.3.1

