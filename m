Return-Path: <SRS0=psrB=5C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7F4DC3F2CE
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Mar 2020 02:03:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9BD3020674
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Mar 2020 02:03:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgCQCDi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Mar 2020 22:03:38 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:9062 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725995AbgCQCDi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Mar 2020 22:03:38 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.19]) by rmmx-syy-dmz-app12-12012 (RichMail) with SMTP id 2eec5e702fd7356-ec074; Tue, 17 Mar 2020 10:03:04 +0800 (CST)
X-RM-TRANSID: 2eec5e702fd7356-ec074
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[223.105.0.241])
        by rmsmtp-syy-appsvr10-12010 (RichMail) with SMTP id 2eea5e702fd7558-f80c0;
        Tue, 17 Mar 2020 10:03:04 +0800 (CST)
X-RM-TRANSID: 2eea5e702fd7558-f80c0
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [PATCH v2 1/2] netfilter: nf_flow_table: reload ip{v6}h in nf_flow_nat_ip{v6}
Date:   Tue, 17 Mar 2020 10:02:52 +0800
Message-Id: <1584410573-6812-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since nf_flow_snat_port and nf_flow_snat_ip{v6} call pskb_may_pull()
which may change skb->data, so we need to reload ip{v6}h at the right
palce.

Fixes: a908fdec3dda ("netfilter: nf_flow_table: move ipv6 offload hook
code to nf_flow_table")
Fixes: 7d2086871762 ("netfilter: nf_flow_table: move ipv4 offload hook
code to nf_flow_table")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
---
v2: collapse the patches
---
 net/netfilter/nf_flow_table_ip.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 5272721..942bda5 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -146,11 +146,12 @@ static int nf_flow_nat_ip(const struct flow_offload *flow, struct sk_buff *skb,
 
 	if (test_bit(NF_FLOW_SNAT, &flow->flags) &&
 	    (nf_flow_snat_port(flow, skb, thoff, iph->protocol, dir) < 0 ||
-	     nf_flow_snat_ip(flow, skb, iph, thoff, dir) < 0))
+	     nf_flow_snat_ip(flow, skb, ip_hdr(skb), thoff, dir) < 0))
 		return -1;
+	iph = ip_hdr(skb);
 	if (test_bit(NF_FLOW_DNAT, &flow->flags) &&
 	    (nf_flow_dnat_port(flow, skb, thoff, iph->protocol, dir) < 0 ||
-	     nf_flow_dnat_ip(flow, skb, iph, thoff, dir) < 0))
+	     nf_flow_dnat_ip(flow, skb, ip_hdr(skb), thoff, dir) < 0))
 		return -1;
 
 	return 0;
@@ -417,11 +418,12 @@ static int nf_flow_nat_ipv6(const struct flow_offload *flow,
 
 	if (test_bit(NF_FLOW_SNAT, &flow->flags) &&
 	    (nf_flow_snat_port(flow, skb, thoff, ip6h->nexthdr, dir) < 0 ||
-	     nf_flow_snat_ipv6(flow, skb, ip6h, thoff, dir) < 0))
+	     nf_flow_snat_ipv6(flow, skb, ipv6_hdr(skb), thoff, dir) < 0))
 		return -1;
+	ip6h = ipv6_hdr(skb);
 	if (test_bit(NF_FLOW_DNAT, &flow->flags) &&
 	    (nf_flow_dnat_port(flow, skb, thoff, ip6h->nexthdr, dir) < 0 ||
-	     nf_flow_dnat_ipv6(flow, skb, ip6h, thoff, dir) < 0))
+	     nf_flow_dnat_ipv6(flow, skb, ipv6_hdr(skb), thoff, dir) < 0))
 		return -1;
 
 	return 0;
-- 
1.8.3.1



