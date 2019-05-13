Return-Path: <SRS0=R8c+=TN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD172C04AB3
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 09:57:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AE09F20989
	for <netfilter-devel@archiver.kernel.org>; Mon, 13 May 2019 09:57:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbfEMJ5F (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 13 May 2019 05:57:05 -0400
Received: from mail.us.es ([193.147.175.20]:34208 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728709AbfEMJ4o (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 May 2019 05:56:44 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id B57B94DE72B
        for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2019 11:56:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9E4EFDA718
        for <netfilter-devel@vger.kernel.org>; Mon, 13 May 2019 11:56:40 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 92C9FDA781; Mon, 13 May 2019 11:56:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 45474DA70F;
        Mon, 13 May 2019 11:56:38 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 13 May 2019 11:56:38 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 080424265A31;
        Mon, 13 May 2019 11:56:37 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: [PATCH 04/13] netfilter: nf_flow_table: check ttl value in flow offload data path
Date:   Mon, 13 May 2019 11:56:21 +0200
Message-Id: <20190513095630.32443-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190513095630.32443-1-pablo@netfilter.org>
References: <20190513095630.32443-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

nf_flow_offload_ip_hook() and nf_flow_offload_ipv6_hook() do not check
ttl value. So, ttl value overflow may occur.

Fixes: 97add9f0d66d ("netfilter: flow table support for IPv4")
Fixes: 0995210753a2 ("netfilter: flow table support for IPv6")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nf_flow_table_ip.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 1d291a51cd45..46022a2867d7 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -181,6 +181,9 @@ static int nf_flow_tuple_ip(struct sk_buff *skb, const struct net_device *dev,
 	    iph->protocol != IPPROTO_UDP)
 		return -1;
 
+	if (iph->ttl <= 1)
+		return -1;
+
 	thoff = iph->ihl * 4;
 	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
 		return -1;
@@ -411,6 +414,9 @@ static int nf_flow_tuple_ipv6(struct sk_buff *skb, const struct net_device *dev,
 	    ip6h->nexthdr != IPPROTO_UDP)
 		return -1;
 
+	if (ip6h->hop_limit <= 1)
+		return -1;
+
 	thoff = sizeof(*ip6h);
 	if (!pskb_may_pull(skb, thoff + sizeof(*ports)))
 		return -1;
-- 
2.11.0

