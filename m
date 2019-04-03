Return-Path: <SRS0=21Bs=SF=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E22E6C4360F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 15:40:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A01192054F
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 Apr 2019 15:40:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfDCPkZ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 Apr 2019 11:40:25 -0400
Received: from mail.us.es ([193.147.175.20]:56758 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726948AbfDCPkR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 Apr 2019 11:40:17 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 6B8911878D2
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2019 17:40:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5C13BDA70C
        for <netfilter-devel@vger.kernel.org>; Wed,  3 Apr 2019 17:40:13 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 51D09DA703; Wed,  3 Apr 2019 17:40:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BF7D0DA702;
        Wed,  3 Apr 2019 17:40:09 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 03 Apr 2019 17:40:09 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id 784434265A31;
        Wed,  3 Apr 2019 17:40:09 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     fw@strlen.de, eric.dumazet@gmail.com, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: [PATCH net-next,RFC 5/8] net: ipv6: split skbuff into fragments transformer
Date:   Wed,  3 Apr 2019 17:39:58 +0200
Message-Id: <20190403154001.8177-6-pablo@netfilter.org>
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

* ip6_frag_init(), that initializes the internal state of the transformer.
* ip6_frag_next(), that allows you to fetch the next fragment. This function
  internally allocates the skbuff that represents the fragment, it pushes
  the IPv6 and transport headers, and it also copies the payload for this
  fragment.

The ip6_frag_state object stores the internal state of the splitter.

This code has been extracted from ip6_fragment(). Symbols are also
exported to allow to reuse this transformer from the bridge codepath for
refragmentation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ipv6.h    |  19 ++++++
 net/ipv6/ip6_output.c | 183 +++++++++++++++++++++++++++++---------------------
 2 files changed, 126 insertions(+), 76 deletions(-)

diff --git a/include/net/ipv6.h b/include/net/ipv6.h
index acefbc718abe..21bb830e9679 100644
--- a/include/net/ipv6.h
+++ b/include/net/ipv6.h
@@ -179,6 +179,25 @@ static inline struct sk_buff *ip6_fraglist_next(struct ip6_fraglist_iter *iter)
 	return skb;
 }
 
+struct ip6_frag_state {
+	u8		*prevhdr;
+	unsigned int	hlen;
+	unsigned int	mtu;
+	unsigned int	left;
+	int		offset;
+	int		ptr;
+	int		hroom;
+	int		troom;
+	__be32		frag_id;
+	u8		nexthdr;
+};
+
+void ip6_frag_init(struct sk_buff *skb, unsigned int hlen, unsigned int mtu,
+		   unsigned short needed_tailroom, int hdr_room, u8 *prevhdr,
+		   u8 nexthdr, __be32 frag_id, struct ip6_frag_state *state);
+struct sk_buff *ip6_frag_next(struct sk_buff *skb,
+			      struct ip6_frag_state *state);
+
 #define IP6_REPLY_MARK(net, mark) \
 	((net)->ipv6.sysctl.fwmark_reflect ? (mark) : 0)
 
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 006b954bee89..8fae19e492ed 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -659,6 +659,103 @@ void ip6_fraglist_prepare(struct sk_buff *skb,
 }
 EXPORT_SYMBOL(ip6_fraglist_prepare);
 
+void ip6_frag_init(struct sk_buff *skb, unsigned int hlen, unsigned int mtu,
+		   unsigned short needed_tailroom, int hdr_room, u8 *prevhdr,
+		   u8 nexthdr, __be32 frag_id, struct ip6_frag_state *state)
+{
+	state->prevhdr = prevhdr;
+	state->nexthdr = nexthdr;
+	state->frag_id = frag_id;
+
+	state->hlen = hlen;
+	state->mtu = mtu;
+
+	state->left = skb->len - hlen;	/* Space per frame */
+	state->ptr = hlen;		/* Where to start from */
+
+	state->hroom = hdr_room;
+	state->troom = needed_tailroom;
+
+	state->offset = 0;
+}
+EXPORT_SYMBOL(ip6_frag_init);
+
+struct sk_buff *ip6_frag_next(struct sk_buff *skb, struct ip6_frag_state *state)
+{
+	u8 *prevhdr = state->prevhdr, *fragnexthdr_offset;
+	struct sk_buff *frag;
+	struct frag_hdr *fh;
+	unsigned int len;
+
+	len = state->left;
+	/* IF: it doesn't fit, use 'mtu' - the data space left */
+	if (len > state->mtu)
+		len = state->mtu;
+	/* IF: we are not sending up to and including the packet end
+	   then align the next start on an eight byte boundary */
+	if (len < state->left)
+		len &= ~7;
+
+	/* Allocate buffer */
+	frag = alloc_skb(len + state->hlen + sizeof(struct frag_hdr) +
+			 state->hroom + state->troom, GFP_ATOMIC);
+	if (!frag)
+		return ERR_PTR(-ENOMEM);
+
+	/*
+	 *	Set up data on packet
+	 */
+
+	ip6_copy_metadata(frag, skb);
+	skb_reserve(frag, state->hroom);
+	skb_put(frag, len + state->hlen + sizeof(struct frag_hdr));
+	skb_reset_network_header(frag);
+	fh = (struct frag_hdr *)(skb_network_header(frag) + state->hlen);
+	frag->transport_header = (frag->network_header + state->hlen +
+				  sizeof(struct frag_hdr));
+
+	/*
+	 *	Charge the memory for the fragment to any owner
+	 *	it might possess
+	 */
+	if (skb->sk)
+		skb_set_owner_w(frag, skb->sk);
+
+	/*
+	 *	Copy the packet header into the new buffer.
+	 */
+	skb_copy_from_linear_data(skb, skb_network_header(frag), state->hlen);
+
+	fragnexthdr_offset = skb_network_header(frag);
+	fragnexthdr_offset += prevhdr - skb_network_header(skb);
+	*fragnexthdr_offset = NEXTHDR_FRAGMENT;
+
+	/*
+	 *	Build fragment header.
+	 */
+	fh->nexthdr = state->nexthdr;
+	fh->reserved = 0;
+	fh->identification = state->frag_id;
+
+	/*
+	 *	Copy a block of the IP datagram.
+	 */
+	BUG_ON(skb_copy_bits(skb, state->ptr, skb_transport_header(frag),
+			     len));
+	state->left -= len;
+
+	fh->frag_off = htons(state->offset);
+	if (state->left > 0)
+		fh->frag_off |= htons(IP6_MF);
+	ipv6_hdr(frag)->payload_len = htons(frag->len - sizeof(struct ipv6hdr));
+
+	state->ptr += len;
+	state->offset += len;
+
+	return frag;
+}
+EXPORT_SYMBOL(ip6_frag_next);
+
 int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		 int (*output)(struct net *, struct sock *, struct sk_buff *))
 {
@@ -666,11 +763,10 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	struct rt6_info *rt = (struct rt6_info *)skb_dst(skb);
 	struct ipv6_pinfo *np = skb->sk && !dev_recursion_level() ?
 				inet6_sk(skb->sk) : NULL;
-	struct frag_hdr *fh;
-	unsigned int mtu, hlen, left, len;
-	int hroom, troom;
+	struct ip6_frag_state state;
+	unsigned int mtu, hlen;
+	int hroom, err = 0;
 	__be32 frag_id;
-	int ptr, offset = 0, err = 0;
 	u8 *prevhdr, nexthdr = 0;
 
 	err = ip6_find_1stfragopt(skb, &prevhdr);
@@ -790,91 +886,26 @@ int ip6_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	}
 
 slow_path:
-	left = skb->len - hlen;		/* Space per frame */
-	ptr = hlen;			/* Where to start from */
-
 	/*
 	 *	Fragment the datagram.
 	 */
 
-	troom = rt->dst.dev->needed_tailroom;
+	ip6_frag_init(skb, hlen, mtu, rt->dst.dev->needed_tailroom,
+		      LL_RESERVED_SPACE(rt->dst.dev), prevhdr, nexthdr, frag_id,
+		      &state);
 
 	/*
 	 *	Keep copying data until we run out.
 	 */
-	while (left > 0)	{
-		u8 *fragnexthdr_offset;
-
-		len = left;
-		/* IF: it doesn't fit, use 'mtu' - the data space left */
-		if (len > mtu)
-			len = mtu;
-		/* IF: we are not sending up to and including the packet end
-		   then align the next start on an eight byte boundary */
-		if (len < left)	{
-			len &= ~7;
-		}
 
-		/* Allocate buffer */
-		frag = alloc_skb(len + hlen + sizeof(struct frag_hdr) +
-				 hroom + troom, GFP_ATOMIC);
-		if (!frag) {
-			err = -ENOMEM;
+	while (state.left > 0) {
+		frag = ip6_frag_next(skb, &state);
+		if (IS_ERR(frag)) {
+			err = PTR_ERR(frag);
 			goto fail;
 		}
 
 		/*
-		 *	Set up data on packet
-		 */
-
-		ip6_copy_metadata(frag, skb);
-		skb_reserve(frag, hroom);
-		skb_put(frag, len + hlen + sizeof(struct frag_hdr));
-		skb_reset_network_header(frag);
-		fh = (struct frag_hdr *)(skb_network_header(frag) + hlen);
-		frag->transport_header = (frag->network_header + hlen +
-					  sizeof(struct frag_hdr));
-
-		/*
-		 *	Charge the memory for the fragment to any owner
-		 *	it might possess
-		 */
-		if (skb->sk)
-			skb_set_owner_w(frag, skb->sk);
-
-		/*
-		 *	Copy the packet header into the new buffer.
-		 */
-		skb_copy_from_linear_data(skb, skb_network_header(frag), hlen);
-
-		fragnexthdr_offset = skb_network_header(frag);
-		fragnexthdr_offset += prevhdr - skb_network_header(skb);
-		*fragnexthdr_offset = NEXTHDR_FRAGMENT;
-
-		/*
-		 *	Build fragment header.
-		 */
-		fh->nexthdr = nexthdr;
-		fh->reserved = 0;
-		fh->identification = frag_id;
-
-		/*
-		 *	Copy a block of the IP datagram.
-		 */
-		BUG_ON(skb_copy_bits(skb, ptr, skb_transport_header(frag),
-				     len));
-		left -= len;
-
-		fh->frag_off = htons(offset);
-		if (left > 0)
-			fh->frag_off |= htons(IP6_MF);
-		ipv6_hdr(frag)->payload_len = htons(frag->len -
-						    sizeof(struct ipv6hdr));
-
-		ptr += len;
-		offset += len;
-
-		/*
 		 *	Put this fragment into the sending queue.
 		 */
 		err = output(net, sk, frag);
-- 
2.11.0

