Return-Path: <SRS0=psrB=5C=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61545C2BB1D
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Mar 2020 02:04:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AD8D20674
	for <netfilter-devel@archiver.kernel.org>; Tue, 17 Mar 2020 02:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgCQCEp (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Mar 2020 22:04:45 -0400
Received: from cmccmta2.chinamobile.com ([221.176.66.80]:3534 "EHLO
        cmccmta2.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725783AbgCQCEp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Mar 2020 22:04:45 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.1]) by rmmx-syy-dmz-app05-12005 (RichMail) with SMTP id 2ee55e702fde376-ec129; Tue, 17 Mar 2020 10:03:10 +0800 (CST)
X-RM-TRANSID: 2ee55e702fde376-ec129
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[223.105.0.241])
        by rmsmtp-syy-appsvr01-12001 (RichMail) with SMTP id 2ee15e702fdd10e-ec706;
        Tue, 17 Mar 2020 10:03:10 +0800 (CST)
X-RM-TRANSID: 2ee15e702fdd10e-ec706
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [PATCH v2 2/2] netfilter: nf_flow_table: reload ip{v6}h in nf_flow_tuple_ip{v6}
Date:   Tue, 17 Mar 2020 10:02:53 +0800
Message-Id: <1584410573-6812-2-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584410573-6812-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
References: <1584410573-6812-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since pskb_may_pull may change skb->data, so we need to reload ip{v6}h at
the right place.

Fixes: a908fdec3dda ("netfilter: nf_flow_table: move ipv6 offload hook
code to nf_flow_table")
Fixes: 7d2086871762 ("netfilter: nf_flow_table: move ipv4 offload hook
code to nf_flow_table")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
---
v2: collapse the patches
---
 net/netfilter/nf_flow_table_ip.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 942bda5..610c60a 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -190,6 +190,7 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
 		return -1;
 
+	iph = ip_hdr(skb);
 	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 
 	tuple->src_v4.s_addr	= iph->saddr;
@@ -452,6 +453,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
 		return -1;
 
+	ip6h = ipv6_hdr(skb);
 	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 
 	tuple->src_v6		= ip6h->saddr;
-- 
1.8.3.1



