Return-Path: <SRS0=uBOy=5A=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD42EC2BB1D
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Mar 2020 14:16:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9FE26205C9
	for <netfilter-devel@archiver.kernel.org>; Sun, 15 Mar 2020 14:16:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728757AbgCOOQM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 15 Mar 2020 10:16:12 -0400
Received: from cmccmta3.chinamobile.com ([221.176.66.81]:3995 "EHLO
        cmccmta3.chinamobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727778AbgCOOQM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 15 Mar 2020 10:16:12 -0400
Received: from spf.mail.chinamobile.com (unknown[172.16.121.13]) by rmmx-syy-dmz-app09-12009 (RichMail) with SMTP id 2ee95e6e389bf93-cac14; Sun, 15 Mar 2020 22:15:55 +0800 (CST)
X-RM-TRANSID: 2ee95e6e389bf93-cac14
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG: 00000000
Received: from localhost (unknown[223.105.0.241])
        by rmsmtp-syy-appsvr07-12007 (RichMail) with SMTP id 2ee75e6e38888e7-22076;
        Sun, 15 Mar 2020 22:15:55 +0800 (CST)
X-RM-TRANSID: 2ee75e6e38888e7-22076
From:   Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Subject: [PATCH 3/4] netfilter: nf_flow_table: reload ipv6h in nf_flow_tuple_ipv6
Date:   Sun, 15 Mar 2020 22:15:04 +0800
Message-Id: <1584281705-26228-3-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1584281705-26228-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
References: <1584281705-26228-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Since pskb_may_pull may change skb->data, so we need to reload ipv6h at
the right place.

Fixes: a908fdec3dda ("netfilter: nf_flow_table: move ipv6 offload hook
code to nf_flow_table")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
---
 net/netfilter/nf_flow_table_ip.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 942bda5..954737f 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -452,6 +452,7 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
 		return -1;
 
+	ip6h = ipv6_hdr(skb);
 	ports = (struct flow_ports *)(skb_network_header(skb) + thoff);
 
 	tuple->src_v6		= ip6h->saddr;
-- 
1.8.3.1



