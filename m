Return-Path: <SRS0=BqdC=T5=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75A81C28CC0
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 11:26:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 539FA20B1F
	for <netfilter-devel@archiver.kernel.org>; Wed, 29 May 2019 11:26:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbfE2L0N (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 29 May 2019 07:26:13 -0400
Received: from mail.us.es ([193.147.175.20]:53024 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726875AbfE2LZy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 29 May 2019 07:25:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3349CC1B63
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 13:25:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2086DDA70B
        for <netfilter-devel@vger.kernel.org>; Wed, 29 May 2019 13:25:52 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 15B3ADA705; Wed, 29 May 2019 13:25:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E93F6DA706;
        Wed, 29 May 2019 13:25:49 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 May 2019 13:25:49 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id A8C254265A32;
        Wed, 29 May 2019 13:25:49 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com
Subject: [PATCH net-next,v3 5/9] net: ipv4: place control buffer handling away from fragmentation iterators
Date:   Wed, 29 May 2019 13:25:35 +0200
Message-Id: <20190529112539.2126-6-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190529112539.2126-1-pablo@netfilter.org>
References: <20190529112539.2126-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Deal with the IPCB() area away from the iterators.

The bridge codebase has its own control buffer layout, move specific
IP control buffer handling into the IPv4 codepath.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/ipv4/ip_output.c | 55 +++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 37 insertions(+), 18 deletions(-)

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index c3f139843eca..8bae773cafbd 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -525,9 +525,6 @@ static void ip_copy_metadata(struct sk_buff *to, struct sk_buff *from)
 
 	skb_copy_hash(to, from);
 
-	/* Copy the flags to each fragment. */
-	IPCB(to)->flags = IPCB(from)->flags;
-
 #ifdef CONFIG_NET_SCHED
 	to->tc_index = from->tc_index;
 #endif
@@ -582,6 +579,18 @@ void ip_fraglist_init(struct sk_buff *skb, struct iphdr *iph,
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
@@ -598,8 +607,6 @@ void ip_fraglist_prepare(struct sk_buff *skb, struct ip_fraglist_iter *iter)
 	iph = iter->iph;
 	iph->tot_len = htons(frag->len);
 	ip_copy_metadata(frag, skb);
-	if (iter->offset == 0)
-		ip_options_fragment(frag);
 	iter->offset += skb->len - hlen;
 	iph->frag_off = htons(iter->offset >> 3);
 	if (frag->next)
@@ -627,6 +634,25 @@ void ip_frag_init(struct sk_buff *skb, unsigned int hlen,
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
@@ -685,18 +711,6 @@ struct sk_buff *ip_frag_next(struct sk_buff *skb, struct ip_frag_state *state)
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
@@ -799,8 +813,10 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		for (;;) {
 			/* Prepare header of the next frame,
 			 * before previous one went down. */
-			if (iter.frag)
+			if (iter.frag) {
+				ip_fraglist_ipcb_prepare(skb, &iter);
 				ip_fraglist_prepare(skb, &iter);
+			}
 
 			err = output(net, sk, skb);
 
@@ -844,11 +860,14 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
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

