Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9447C4360F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 15:40:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92E032054F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 15:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfDCPkQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 11:40:16 -0400
Received: from mail.us.es ([193.147.175.20]:56860 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726924AbfDCPkP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 11:40:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 669E51878BC
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2019 17:40:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 58E75DA702
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2019 17:40:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 4E244DA716; Wed,  3 Apr 2019 17:40:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 20E84DA703;
        Wed,  3 Apr 2019 17:40:11 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Apr 2019 17:40:11 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D46F64265A31;
        Wed,  3 Apr 2019 17:40:10 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, eric.dumazet@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH net-next,RFC 7/8] net: ipv4: place cb handling away from fragment transformer
Date:   Wed,  3 Apr 2019 17:40:00 +0200
Message-Id: <20190403154001.8177-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190403154001.8177-1-pablo@netfilter.org>
References: <20190403154001.8177-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Deal with the IPCB() area away from the fragment transformer.

The bridge codebase has its own control buffer layout, move specific IP
control buffer into function.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/ip_output.c | 34 ++++++++++++++++++++++------------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 1dc731d7be0e..bb0a13f78b43 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -635,6 +635,25 @@ void ip_frag_init(struct sk_buff *skb, unsigned int hlen,
 }
 EXPORT_SYMBOL(ip_frag_init);
 
+static void ip_frag_ipcb(struct sk_buff *from, struct sk_buff *to,
+			 bool first_frag, struct ip_frag_state *state)
+{
+	/* Copy the flags to each fragment. */
+	IPCB(to)->flags = IPCB(from)->flags;
+
+	if (IPCB(from)->flags & IPSKB_FRAG_PMTU)
+		state->iph->frag_off |= htons(IP_DF);
+
+	/* ANK: dirty, but effective trick. Upgrade options only if
+	 * the segment to be fragmented was THE FIRST (otherwise,
+	 * options are already fixed) and make it ONCE
+	 * on the initial skb, so that all the following fragments
+	 * will inherit fixed options.
+	 */
+	if (first_frag)
+		ip_options_fragment(from);
+}
+
 struct sk_buff *ip_frag_next(struct sk_buff *skb, struct ip_frag_state *state)
 {
 	unsigned int len = state->left;
@@ -693,18 +712,6 @@ struct sk_buff *ip_frag_next(struct sk_buff *skb, struct ip_frag_state *state)
 	iph = ip_hdr(skb2);
 	iph->frag_off = htons((state->offset >> 3));
 
-	if (IPCB(skb)->flags & IPSKB_FRAG_PMTU)
-		iph->frag_off |= htons(IP_DF);
-
-	/* ANK: dirty, but effective trick. Upgrade options only if
-	 * the segment to be fragmented was THE FIRST (otherwise,
-	 * options are already fixed) and make it ONCE
-	 * on the initial skb, so that all the following fragments
-	 * will inherit fixed options.
-	 */
-	if (state->offset == 0)
-		ip_options_fragment(skb);
-
 	/*
 	 *	Added AC : If we are fragmenting a fragment that's not the
 	 *		   last fragment then keep MF on each bit
@@ -854,11 +861,14 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	 */
 
 	while (state.left > 0) {
+		bool first_frag = (state.offset == 0);
+
 		skb2 = ip_frag_next(skb, &state);
 		if (IS_ERR(skb2)) {
 			err = PTR_ERR(skb2);
 			goto fail;
 		}
+		ip_frag_ipcb(skb, skb2, first_frag, &state);
 
 		/*
 		 *	Put this fragment into the sending queue.
-- 
2.11.0

