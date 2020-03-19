Return-Path: <SRS0=bD7Q=5E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2AC0C4332B
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Mar 2020 04:52:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 808B2206D7
	for <netfilter-devel@archiver.kernel.org>; Thu, 19 Mar 2020 04:52:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbgCSEwv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 19 Mar 2020 00:52:51 -0400
Received: from m9784.mail.qiye.163.com ([220.181.97.84]:63164 "EHLO
        m9784.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725812AbgCSEwv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 19 Mar 2020 00:52:51 -0400
Received: from localhost.localdomain (unknown [123.59.132.129])
        by m9784.mail.qiye.163.com (Hmail) with ESMTPA id 8827B41897;
        Thu, 19 Mar 2020 12:52:45 +0800 (CST)
From:   wenxu@ucloud.cn
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next] netfilter: nf_flow_table_offload: fix potential NULL pointer dereference for dst_cache in handling lwtstate
Date:   Thu, 19 Mar 2020 12:52:45 +0800
Message-Id: <1584593565-23692-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: git-send-email 1.8.3.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZSVVJQ0tCQkJDQkNCSktOSVlXWShZQU
        lCN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MFE6SAw6TDgzQxw0FxJDPyo8
        AR4wFAJVSlVKTkNPTkJITk1OTUhIVTMWGhIXVQweFQMOOw4YFxQOH1UYFUVZV1kSC1lBWUpJSFVO
        QlVKSElVSklCWVdZCAFZQUlJSkw3Bg++
X-HM-Tid: 0a70f122f77e2086kuqy8827b41897
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: wenxu <wenxu@ucloud.cn>

All the handler in flow_offload_work_handler can be used by both
nft-flowtable and act_ct-flowtable. Flowtable in act_ct zero the
dst_cache ptr in the flow_offload.

Signed-off-by: wenxu <wenxu@ucloud.cn>
---
 net/netfilter/nf_flow_table_offload.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_flow_table_offload.c b/net/netfilter/nf_flow_table_offload.c
index ca40dfa..9460369 100644
--- a/net/netfilter/nf_flow_table_offload.c
+++ b/net/netfilter/nf_flow_table_offload.c
@@ -92,7 +92,7 @@ static int nf_flow_rule_match(struct nf_flow_match *match,
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_TCP, tcp);
 	NF_FLOW_DISSECTOR(match, FLOW_DISSECTOR_KEY_PORTS, tp);
 
-	if (other_dst->lwtstate) {
+	if (other_dst && other_dst->lwtstate) {
 		tun_info = lwt_tun_info(other_dst->lwtstate);
 		nf_flow_rule_lwt_match(match, tun_info);
 	}
@@ -483,7 +483,7 @@ static void flow_offload_encap_tunnel(const struct flow_offload *flow,
 	struct dst_entry *dst;
 
 	dst = flow->tuplehash[dir].tuple.dst_cache;
-	if (dst->lwtstate) {
+	if (dst && dst->lwtstate) {
 		struct ip_tunnel_info *tun_info;
 
 		tun_info = lwt_tun_info(dst->lwtstate);
@@ -503,7 +503,7 @@ static void flow_offload_decap_tunnel(const struct flow_offload *flow,
 	struct dst_entry *dst;
 
 	dst = flow->tuplehash[!dir].tuple.dst_cache;
-	if (dst->lwtstate) {
+	if (dst && dst->lwtstate) {
 		struct ip_tunnel_info *tun_info;
 
 		tun_info = lwt_tun_info(dst->lwtstate);
-- 
1.8.3.1

