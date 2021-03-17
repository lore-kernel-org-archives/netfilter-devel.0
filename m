Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64FE0C43333
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 15:49:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BC6C564F9F
	for <netfilter-devel@archiver.kernel.org>; Wed, 17 Mar 2021 15:49:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232013AbhCQPso (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 17 Mar 2021 11:48:44 -0400
Received: from mail.netfilter.org ([217.70.188.207]:48136 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbhCQPsM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 17 Mar 2021 11:48:12 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id 7501E63560
        for <netfilter-devel@vger.kernel.org>; Wed, 17 Mar 2021 16:16:46 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 6/6] netfilter: flowtable: refresh timeout after dst and writable checks
Date:   Wed, 17 Mar 2021 16:16:41 +0100
Message-Id: <20210317151641.19637-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210317151641.19637-1-pablo@netfilter.org>
References: <20210317151641.19637-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Refresh the timeout (and retry hardware offload) once the skbuff dst
is confirmed to be current and after the skbuff is made writable.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: new patch in this batch

 net/netfilter/nf_flow_table_ip.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 3a8423899def..3be58b6d60af 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -246,8 +246,6 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
 		return NF_ACCEPT;
 
-	flow_offload_refresh(flow_table, flow);
-
 	if (!dst_check(&rt->dst, 0)) {
 		flow_offload_teardown(flow);
 		return NF_ACCEPT;
@@ -256,6 +254,8 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	if (skb_try_make_writable(skb, thoff + hdrsize))
 		return NF_DROP;
 
+	flow_offload_refresh(flow_table, flow);
+
 	iph = ip_hdr(skb);
 	nf_flow_nat_ip(flow, skb, thoff, dir, iph);
 
@@ -466,8 +466,6 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 				sizeof(*ip6h)))
 		return NF_ACCEPT;
 
-	flow_offload_refresh(flow_table, flow);
-
 	if (!dst_check(&rt->dst, 0)) {
 		flow_offload_teardown(flow);
 		return NF_ACCEPT;
@@ -476,6 +474,8 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	if (skb_try_make_writable(skb, sizeof(*ip6h) + hdrsize))
 		return NF_DROP;
 
+	flow_offload_refresh(flow_table, flow);
+
 	ip6h = ipv6_hdr(skb);
 	nf_flow_nat_ipv6(flow, skb, dir, ip6h);
 
-- 
2.20.1

