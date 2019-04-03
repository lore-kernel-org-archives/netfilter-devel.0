Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDE8EC4360F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 15:40:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 977CF2054F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 15:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbfDCPkR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 11:40:17 -0400
Received: from mail.us.es ([193.147.175.20]:56830 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726905AbfDCPkP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 11:40:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 96B2F1878C1
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2019 17:40:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 860C8DA712
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2019 17:40:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 7AA48DA70A; Wed,  3 Apr 2019 17:40:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6ED2DDA709;
        Wed,  3 Apr 2019 17:40:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Apr 2019 17:40:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 2BA8E4265A31;
        Wed,  3 Apr 2019 17:40:10 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, eric.dumazet@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH net-next,RFC 6/8] net: ipv4: place cb handling away from fraglist iterator
Date:   Wed,  3 Apr 2019 17:39:59 +0200
Message-Id: <20190403154001.8177-7-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190403154001.8177-1-pablo@netfilter.org>
References: <20190403154001.8177-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Deal with the IPCB() area away from the fraglist iterator.

The bridge codebase has its own control buffer layout, move specific
IP control buffer into function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/ip_output.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index ab39bbfe8197..1dc731d7be0e 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -526,9 +526,6 @@ static void ip_copy_metadata(struct sk_buff *to, struct sk_buff *from)
 
 	skb_copy_hash(to, from);
 
-	/* Copy the flags to each fragment. */
-	IPCB(to)->flags = IPCB(from)->flags;
-
 #ifdef CONFIG_NET_SCHED
 	to->tc_index = from->tc_index;
 #endif
@@ -583,6 +580,18 @@ void ip_fraglist_init(struct sk_buff *skb, struct iphdr *iph,
 }
 EXPORT_SYMBOL(ip_fraglist_init);
 
+static void ip_fraglist_ipcb_prepare(struct sk_buff *skb,
+				     struct ip_fraglist_iter *iter)
+{
+	struct sk_buff *to = iter->frag;
+
+	/* Copy the flags to each fragment. */
+	IPCB(to)->flags = IPCB(skb)->flags;
+
+	if (iter->offset == 0)
+		ip_options_fragment(to);
+}
+
 void ip_fraglist_prepare(struct sk_buff *skb, struct ip_fraglist_iter *iter)
 {
 	unsigned int hlen = iter->hlen;
@@ -599,8 +608,6 @@ void ip_fraglist_prepare(struct sk_buff *skb, struct ip_fraglist_iter *iter)
 	iph = iter->iph;
 	iph->tot_len = htons(frag->len);
 	ip_copy_metadata(frag, skb);
-	if (iter->offset == 0)
-		ip_options_fragment(frag);
 	iter->offset += skb->len - hlen;
 	iph->frag_off = htons(iter->offset >> 3);
 	if (frag->next)
@@ -800,8 +807,10 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		for (;;) {
 			/* Prepare header of the next frame,
 			 * before previous one went down. */
-			if (iter.frag)
+			if (iter.frag) {
+				ip_fraglist_ipcb_prepare(skb, &iter);
 				ip_fraglist_prepare(skb, &iter);
+			}
 
 			err = output(net, sk, skb);
 
-- 
2.11.0

