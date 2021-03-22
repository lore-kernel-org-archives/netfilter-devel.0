Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC302C433E9
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Mar 2021 23:57:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7AA71619AA
	for <netfilter-devel@archiver.kernel.org>; Mon, 22 Mar 2021 23:57:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhCVX5L (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 22 Mar 2021 19:57:11 -0400
Received: from mail.netfilter.org ([217.70.188.207]:58342 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230452AbhCVX4s (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 22 Mar 2021 19:56:48 -0400
Received: from localhost.localdomain (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id DB4C7630C3;
        Tue, 23 Mar 2021 00:56:33 +0100 (CET)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net-next 05/10] netfilter: flowtable: move skb_try_make_writable() before NAT in IPv4
Date:   Tue, 23 Mar 2021 00:56:23 +0100
Message-Id: <20210322235628.2204-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20210322235628.2204-1-pablo@netfilter.org>
References: <20210322235628.2204-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

For consistency with the IPv6 flowtable datapath and to make sure the
skbuff is writable right before the NAT header updates.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 2b8ee5dcef64..95adf74515ea 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -266,10 +266,6 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 
 	iph = ip_hdr(skb);
 	thoff = iph->ihl * 4;
-	if (skb_try_make_writable(skb, thoff + hdrsize))
-		return NF_DROP;
-
-	iph = ip_hdr(skb);
 	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
 		return NF_ACCEPT;
 
@@ -280,6 +276,10 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 		return NF_ACCEPT;
 	}
 
+	if (skb_try_make_writable(skb, thoff + hdrsize))
+		return NF_DROP;
+
+	iph = ip_hdr(skb);
 	if (nf_flow_nat_ip(flow, skb, thoff, dir, iph) < 0)
 		return NF_DROP;
 
-- 
2.20.1

