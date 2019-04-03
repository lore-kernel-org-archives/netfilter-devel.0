Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC134C10F0B
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 15:40:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9934F2054F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 15:40:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726978AbfDCPkR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 11:40:17 -0400
Received: from mail.us.es ([193.147.175.20]:56752 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726886AbfDCPkP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 11:40:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A6BAB17AE47
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2019 17:40:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 8A76CDA720
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2019 17:40:11 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 88EB4DA710; Wed,  3 Apr 2019 17:40:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2751CDA717;
        Wed,  3 Apr 2019 17:40:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Apr 2019 17:40:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id D25704265A31;
        Wed,  3 Apr 2019 17:40:08 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, eric.dumazet@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH net-next,RFC 4/8] net: ipv4: split skbuff into fragments transformer
Date:   Wed,  3 Apr 2019 17:39:57 +0200
Message-Id: <20190403154001.8177-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190403154001.8177-1-pablo@netfilter.org>
References: <20190403154001.8177-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch exposes a new API to refragment a skbuff. The allows you to
split either linear skbuff or force the refragmentation of an existing
fraglist.

The API consists of:

* ip_frag_init(), that initializes the internal state of the transformer.
* ip_frag_next(), that allows you to fetch the next fragment. This function
  internally allocates the skbuff that represents the fragment, it pushes
  the IPv4 and transport headers, and it also copies the payload for this
  fragment.

The ip_frag_state object stores the internal state of the splitter.

This code has been extracted from ip_do_fragment(). Symbols are also
exported to allow to reuse this transformer from the bridge codepath for
refragmentation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip.h     |  16 +++++
 net/ipv4/ip_output.c | 200 ++++++++++++++++++++++++++++-----------------------
 2 files changed, 128 insertions(+), 88 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index cc3d83680f4f..94f654e6bd41 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -188,6 +188,22 @@ static inline struct sk_buff *ip_fraglist_next(struct ip_fraglist_iter *iter)
 	return skb;
 }
 
+struct ip_frag_state {
+	struct iphdr	*iph;
+	unsigned int	hlen;
+	unsigned int	ll_rs;
+	unsigned int	mtu;
+	unsigned int	left;
+	int		offset;
+	int		ptr;
+	__be16		not_last_frag;
+};
+
+void ip_frag_init(struct sk_buff *skb, unsigned int hlen, unsigned int ll_rs,
+		  unsigned int mtu, struct ip_frag_state *state);
+struct sk_buff *ip_frag_next(struct sk_buff *skb,
+			     struct ip_frag_state *state);
+
 void ip_send_check(struct iphdr *ip);
 int __ip_local_out(struct net *net, struct sock *sk, struct sk_buff *skb);
 int ip_local_out(struct net *net, struct sock *sk, struct sk_buff *skb);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index d53fa795feb4..ab39bbfe8197 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -610,6 +610,111 @@ void ip_fraglist_prepare(struct sk_buff *skb, struct ip_fraglist_iter *iter)
 }
 EXPORT_SYMBOL(ip_fraglist_prepare);
 
+void ip_frag_init(struct sk_buff *skb, unsigned int hlen,
+		  unsigned int ll_rs, unsigned int mtu,
+		  struct ip_frag_state *state)
+{
+	struct iphdr *iph = ip_hdr(skb);
+
+	state->hlen = hlen;
+	state->ll_rs = ll_rs;
+	state->mtu = mtu;
+
+	state->left = skb->len - hlen;	/* Space per frame */
+	state->ptr = hlen;		/* Where to start from */
+
+	state->offset = (ntohs(iph->frag_off) & IP_OFFSET) << 3;
+	state->not_last_frag = iph->frag_off & htons(IP_MF);
+}
+EXPORT_SYMBOL(ip_frag_init);
+
+struct sk_buff *ip_frag_next(struct sk_buff *skb, struct ip_frag_state *state)
+{
+	unsigned int len = state->left;
+	struct sk_buff *skb2;
+	struct iphdr *iph;
+
+	len = state->left;
+	/* IF: it doesn't fit, use 'mtu' - the data space left */
+	if (len > state->mtu)
+		len = state->mtu;
+	/* IF: we are not sending up to and including the packet end
+	   then align the next start on an eight byte boundary */
+	if (len < state->left)	{
+		len &= ~7;
+	}
+
+	/* Allocate buffer */
+	skb2 = alloc_skb(len + state->hlen + state->ll_rs, GFP_ATOMIC);
+	if (!skb2)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 *	Set up data on packet
+	 */
+
+	ip_copy_metadata(skb2, skb);
+	skb_reserve(skb2, state->ll_rs);
+	skb_put(skb2, len + state->hlen);
+	skb_reset_network_header(skb2);
+	skb2->transport_header = skb2->network_header + state->hlen;
+
+	/*
+	 *	Charge the memory for the fragment to any owner
+	 *	it might possess
+	 */
+
+	if (skb->sk)
+		skb_set_owner_w(skb2, skb->sk);
+
+	/*
+	 *	Copy the packet header into the new buffer.
+	 */
+
+	skb_copy_from_linear_data(skb, skb_network_header(skb2), state->hlen);
+
+	/*
+	 *	Copy a block of the IP datagram.
+	 */
+	if (skb_copy_bits(skb, state->ptr, skb_transport_header(skb2), len))
+		BUG();
+	state->left -= len;
+
+	/*
+	 *	Fill in the new header fields.
+	 */
+	iph = ip_hdr(skb2);
+	iph->frag_off = htons((state->offset >> 3));
+
+	if (IPCB(skb)->flags & IPSKB_FRAG_PMTU)
+		iph->frag_off |= htons(IP_DF);
+
+	/* ANK: dirty, but effective trick. Upgrade options only if
+	 * the segment to be fragmented was THE FIRST (otherwise,
+	 * options are already fixed) and make it ONCE
+	 * on the initial skb, so that all the following fragments
+	 * will inherit fixed options.
+	 */
+	if (state->offset == 0)
+		ip_options_fragment(skb);
+
+	/*
+	 *	Added AC : If we are fragmenting a fragment that's not the
+	 *		   last fragment then keep MF on each bit
+	 */
+	if (state->left > 0 || state->not_last_frag)
+		iph->frag_off |= htons(IP_MF);
+	state->ptr += len;
+	state->offset += len;
+
+	iph->tot_len = htons(len + state->hlen);
+
+	ip_send_check(iph);
+
+	return skb2;
+}
+EXPORT_SYMBOL(ip_frag_next);
+
 /*
  *	This IP datagram is too large to be sent in one piece.  Break it up into
  *	smaller pieces (each of size equal to IP header plus
@@ -621,13 +726,11 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		   int (*output)(struct net *, struct sock *, struct sk_buff *))
 {
 	struct iphdr *iph;
-	int ptr;
 	struct sk_buff *skb2;
-	unsigned int mtu, hlen, left, len, ll_rs;
-	int offset;
-	__be16 not_last_frag;
 	struct rtable *rt = skb_rtable(skb);
+	unsigned int mtu, hlen, ll_rs;
 	struct ip_fraglist_iter iter;
+	struct ip_frag_state state;
 	int err = 0;
 
 	/* for offloaded checksums cleanup checksum before fragmentation */
@@ -731,105 +834,26 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	}
 
 slow_path:
-	iph = ip_hdr(skb);
-
-	left = skb->len - hlen;		/* Space per frame */
-	ptr = hlen;		/* Where to start from */
-
 	/*
 	 *	Fragment the datagram.
 	 */
 
-	offset = (ntohs(iph->frag_off) & IP_OFFSET) << 3;
-	not_last_frag = iph->frag_off & htons(IP_MF);
+	ip_frag_init(skb, hlen, ll_rs, mtu, &state);
 
 	/*
 	 *	Keep copying data until we run out.
 	 */
 
-	while (left > 0) {
-		len = left;
-		/* IF: it doesn't fit, use 'mtu' - the data space left */
-		if (len > mtu)
-			len = mtu;
-		/* IF: we are not sending up to and including the packet end
-		   then align the next start on an eight byte boundary */
-		if (len < left)	{
-			len &= ~7;
-		}
-
-		/* Allocate buffer */
-		skb2 = alloc_skb(len + hlen + ll_rs, GFP_ATOMIC);
-		if (!skb2) {
-			err = -ENOMEM;
+	while (state.left > 0) {
+		skb2 = ip_frag_next(skb, &state);
+		if (IS_ERR(skb2)) {
+			err = PTR_ERR(skb2);
 			goto fail;
 		}
 
 		/*
-		 *	Set up data on packet
-		 */
-
-		ip_copy_metadata(skb2, skb);
-		skb_reserve(skb2, ll_rs);
-		skb_put(skb2, len + hlen);
-		skb_reset_network_header(skb2);
-		skb2->transport_header = skb2->network_header + hlen;
-
-		/*
-		 *	Charge the memory for the fragment to any owner
-		 *	it might possess
-		 */
-
-		if (skb->sk)
-			skb_set_owner_w(skb2, skb->sk);
-
-		/*
-		 *	Copy the packet header into the new buffer.
-		 */
-
-		skb_copy_from_linear_data(skb, skb_network_header(skb2), hlen);
-
-		/*
-		 *	Copy a block of the IP datagram.
-		 */
-		if (skb_copy_bits(skb, ptr, skb_transport_header(skb2), len))
-			BUG();
-		left -= len;
-
-		/*
-		 *	Fill in the new header fields.
-		 */
-		iph = ip_hdr(skb2);
-		iph->frag_off = htons((offset >> 3));
-
-		if (IPCB(skb)->flags & IPSKB_FRAG_PMTU)
-			iph->frag_off |= htons(IP_DF);
-
-		/* ANK: dirty, but effective trick. Upgrade options only if
-		 * the segment to be fragmented was THE FIRST (otherwise,
-		 * options are already fixed) and make it ONCE
-		 * on the initial skb, so that all the following fragments
-		 * will inherit fixed options.
-		 */
-		if (offset == 0)
-			ip_options_fragment(skb);
-
-		/*
-		 *	Added AC : If we are fragmenting a fragment that's not the
-		 *		   last fragment then keep MF on each bit
-		 */
-		if (left > 0 || not_last_frag)
-			iph->frag_off |= htons(IP_MF);
-		ptr += len;
-		offset += len;
-
-		/*
 		 *	Put this fragment into the sending queue.
 		 */
-		iph->tot_len = htons(len + hlen);
-
-		ip_send_check(iph);
-
 		err = output(net, sk, skb2);
 		if (err)
 			goto fail;
-- 
2.11.0

