Return-Path: <SRS0=s0US=5F=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7D7FC4332B
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Mar 2020 13:51:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B7DE120722
	for <netfilter-devel@archiver.kernel.org>; Fri, 20 Mar 2020 13:51:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726897AbgCTNvm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 20 Mar 2020 09:51:42 -0400
Received: from correo.us.es ([193.147.175.20]:41510 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726840AbgCTNvm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 20 Mar 2020 09:51:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 11DAD172C89
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2020 14:51:09 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 01AEDDA72F
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Mar 2020 14:51:09 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id EB938DA3A3; Fri, 20 Mar 2020 14:51:08 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1EBB6DA736;
        Fri, 20 Mar 2020 14:51:07 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 20 Mar 2020 14:51:07 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (unknown [90.77.255.23])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id EE53142EE38E;
        Fri, 20 Mar 2020 14:51:06 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 1/4] netfilter: flowtable: reload ip{v6}h in nf_flow_nat_ip{v6}
Date:   Fri, 20 Mar 2020 14:51:31 +0100
Message-Id: <20200320135134.436907-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200320135134.436907-1-pablo@netfilter.org>
References: <20200320135134.436907-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

Since nf_flow_snat_port and nf_flow_snat_ip{v6} call pskb_may_pull()
which may change skb->data, so we need to reload ip{v6}h at the right
place.

Fixes: a908fdec3dda ("netfilter: nf_flow_table: move ipv6 offload hook code to nf_flow_table")
Fixes: 7d2086871762 ("netfilter: nf_flow_table: move ipv4 offload hook code to nf_flow_table")
Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 9e563fd3da0f..22caab7bb755 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -146,11 +146,13 @@ static int nf_flow_nat_ip(const struct flow_offload *flow, struct sk_buff *skb,
 
 	if (test_bit(NF_FLOW_SNAT, &flow->flags) &&
 	    (nf_flow_snat_port(flow, skb, thoff, iph->protocol, dir) < 0 ||
-	     nf_flow_snat_ip(flow, skb, iph, thoff, dir) < 0))
+	     nf_flow_snat_ip(flow, skb, ip_hdr(skb), thoff, dir) < 0))
 		return -1;
+
+	iph = ip_hdr(skb);
 	if (test_bit(NF_FLOW_DNAT, &flow->flags) &&
 	    (nf_flow_dnat_port(flow, skb, thoff, iph->protocol, dir) < 0 ||
-	     nf_flow_dnat_ip(flow, skb, iph, thoff, dir) < 0))
+	     nf_flow_dnat_ip(flow, skb, ip_hdr(skb), thoff, dir) < 0))
 		return -1;
 
 	return 0;
@@ -426,11 +428,13 @@ static int nf_flow_nat_ipv6(const struct flow_offload *flow,
 
 	if (test_bit(NF_FLOW_SNAT, &flow->flags) &&
 	    (nf_flow_snat_port(flow, skb, thoff, ip6h->nexthdr, dir) < 0 ||
-	     nf_flow_snat_ipv6(flow, skb, ip6h, thoff, dir) < 0))
+	     nf_flow_snat_ipv6(flow, skb, ipv6_hdr(skb), thoff, dir) < 0))
 		return -1;
+
+	ip6h = ipv6_hdr(skb);
 	if (test_bit(NF_FLOW_DNAT, &flow->flags) &&
 	    (nf_flow_dnat_port(flow, skb, thoff, ip6h->nexthdr, dir) < 0 ||
-	     nf_flow_dnat_ipv6(flow, skb, ip6h, thoff, dir) < 0))
+	     nf_flow_dnat_ipv6(flow, skb, ipv6_hdr(skb), thoff, dir) < 0))
 		return -1;
 
 	return 0;
-- 
2.11.0

