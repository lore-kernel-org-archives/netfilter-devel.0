Return-Path: <SRS0=TL01=WX=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 557B8C3A5A3
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 19:15:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3187E2184D
	for <netfilter-devel@archiver.kernel.org>; Tue, 27 Aug 2019 19:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730347AbfH0TPj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 27 Aug 2019 15:15:39 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:40086 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728972AbfH0TPi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 27 Aug 2019 15:15:38 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@breakpoint.cc>)
        id 1i2gwK-0005Q5-Ro; Tue, 27 Aug 2019 21:15:36 +0200
From:   Florian Westphal <fw@strlen.de>
To:     <netfilter-devel@vger.kernel.org>
Cc:     Florian Westphal <fw@strlen.de>
Subject: [PATCH nf] netfilter: nf_flow_table: clear skb tstamp before xmit
Date:   Tue, 27 Aug 2019 21:23:45 +0200
Message-Id: <20190827192345.12661-1-fw@strlen.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

If 'fq' qdisc is used and a program has requested timestamps,
skb->tstamp needs to be cleared, else fq will treat these as
'transmit time'.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/nf_flow_table_ip.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index d68c801dd614..b9e7dd6e60ce 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -228,7 +228,6 @@ static unsigned int nf_flow_xmit_xfrm(struct sk_buff *skb,
 {
 	skb_orphan(skb);
 	skb_dst_set_noref(skb, dst);
-	skb->tstamp = 0;
 	dst_output(state->net, state->sk, skb);
 	return NF_STOLEN;
 }
@@ -284,6 +283,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
 	iph = ip_hdr(skb);
 	ip_decrease_ttl(iph);
+	skb->tstamp = 0;
 
 	if (unlikely(dst_xfrm(&rt->dst))) {
 		memset(skb->cb, 0, sizeof(struct inet_skb_parm));
@@ -512,6 +512,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	flow->timeout = (u32)jiffies + NF_FLOW_TIMEOUT;
 	ip6h = ipv6_hdr(skb);
 	ip6h->hop_limit--;
+	skb->tstamp = 0;
 
 	if (unlikely(dst_xfrm(&rt->dst))) {
 		memset(skb->cb, 0, sizeof(struct inet6_skb_parm));
-- 
2.21.0

