Return-Path: <SRS0=sICu=SR=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE566C10F12
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 21:36:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A68E52070D
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Apr 2019 21:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728084AbfDOVg1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Apr 2019 17:36:27 -0400
Received: from mail.us.es ([193.147.175.20]:48254 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728070AbfDOVg0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Apr 2019 17:36:26 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 593CA2EFEB0
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 23:36:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3F74ADA70F
        for <netfilter-devel@vger.kernel.org>; Mon, 15 Apr 2019 23:36:24 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 33A41DA708; Mon, 15 Apr 2019 23:36:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 06D95DA70A;
        Mon, 15 Apr 2019 23:36:22 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 15 Apr 2019 23:36:22 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from salvia.here (sys.soleta.eu [212.170.55.40])
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPA id AB5AC4265A31;
        Mon, 15 Apr 2019 23:36:21 +0200 (CEST)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, fw@strlen.de,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        herbert@gondor.apana.org.au
Subject: [PATCH net-next 01/10] net: ipv4: add skbuff fraglist split iterator
Date:   Mon, 15 Apr 2019 23:36:02 +0200
Message-Id: <20190415213611.21863-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20190415213611.21863-1-pablo@netfilter.org>
References: <20190415213611.21863-1-pablo@netfilter.org>
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds skbuff fraglist split iterator. The API consists of:

* ip_fraglist_init(), that initializes the internal state of the
  fraglist iterator.
* ip_fraglist_prepare(), that restores the IPv4 on the fragment.
* ip_fraglist_next(), that retrieves the fragment from the fraglist and
  updates the internal state of the iterator to point to the next
  fragment in the fraglist.

The ip_fraglist_iter object stores the internal state of the iterator.

This code has been extracted from ip_do_fragment(). Symbols are also
exported to allow to reuse this iterator from the bridge codepath for
refragmentation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/ip.h     | 23 ++++++++++++++
 net/ipv4/ip_output.c | 88 ++++++++++++++++++++++++++++++++--------------------
 2 files changed, 78 insertions(+), 33 deletions(-)

diff --git a/include/net/ip.h b/include/net/ip.h
index 2d3cce7c3e8a..be899677504b 100644
--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -165,6 +165,29 @@ int ip_output(struct net *net, struct sock *sk, struct sk_buff *skb);
 int ip_mc_output(struct net *net, struct sock *sk, struct sk_buff *skb);
 int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		   int (*output)(struct net *, struct sock *, struct sk_buff *));
+
+struct ip_fraglist_iter {
+	struct sk_buff	*frag_list;
+	struct sk_buff	*frag;
+	struct iphdr	*iph;
+	int		offset;
+	unsigned int	hlen;
+};
+
+void ip_fraglist_init(struct sk_buff *skb, struct iphdr *iph,
+		      unsigned int hlen, struct ip_fraglist_iter *iter);
+void ip_fraglist_prepare(struct sk_buff *skb, struct ip_fraglist_iter *iter);
+
+static inline struct sk_buff *ip_fraglist_next(struct ip_fraglist_iter *iter)
+{
+	struct sk_buff *skb = iter->frag;
+
+	iter->frag = skb->next;
+	skb_mark_not_on_list(skb);
+
+	return skb;
+}
+
 void ip_send_check(struct iphdr *ip);
 int __ip_local_out(struct net *net, struct sock *sk, struct sk_buff *skb);
 int ip_local_out(struct net *net, struct sock *sk, struct sk_buff *skb);
diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
index 4e42c1974ba2..c03194eb1376 100644
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -559,6 +559,54 @@ static int ip_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	return ip_do_fragment(net, sk, skb, output);
 }
 
+void ip_fraglist_init(struct sk_buff *skb, struct iphdr *iph,
+		      unsigned int hlen, struct ip_fraglist_iter *iter)
+{
+	unsigned int first_len = skb_pagelen(skb);
+
+	iter->frag_list = skb_shinfo(skb)->frag_list;
+	iter->frag = iter->frag_list;
+	skb_frag_list_init(skb);
+
+	iter->offset = 0;
+	iter->iph = iph;
+	iter->hlen = hlen;
+
+	skb->data_len = first_len - skb_headlen(skb);
+	skb->len = first_len;
+	iph->tot_len = htons(first_len);
+	iph->frag_off = htons(IP_MF);
+	ip_send_check(iph);
+}
+EXPORT_SYMBOL(ip_fraglist_init);
+
+void ip_fraglist_prepare(struct sk_buff *skb, struct ip_fraglist_iter *iter)
+{
+	unsigned int hlen = iter->hlen;
+	struct iphdr *iph = iter->iph;
+	struct sk_buff *frag;
+
+	frag = iter->frag;
+	frag->ip_summed = CHECKSUM_NONE;
+	skb_reset_transport_header(frag);
+	__skb_push(frag, hlen);
+	skb_reset_network_header(frag);
+	memcpy(skb_network_header(frag), iph, hlen);
+	iter->iph = ip_hdr(frag);
+	iph = iter->iph;
+	iph->tot_len = htons(frag->len);
+	ip_copy_metadata(frag, skb);
+	if (iter->offset == 0)
+		ip_options_fragment(frag);
+	iter->offset += skb->len - hlen;
+	iph->frag_off = htons(iter->offset >> 3);
+	if (frag->next)
+		iph->frag_off |= htons(IP_MF);
+	/* Ready, complete checksum */
+	ip_send_check(iph);
+}
+EXPORT_SYMBOL(ip_fraglist_prepare);
+
 /*
  *	This IP datagram is too large to be sent in one piece.  Break it up into
  *	smaller pieces (each of size equal to IP header plus
@@ -576,6 +624,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 	int offset;
 	__be16 not_last_frag;
 	struct rtable *rt = skb_rtable(skb);
+	struct ip_fraglist_iter iter;
 	int err = 0;
 
 	/* for offloaded checksums cleanup checksum before fragmentation */
@@ -640,49 +689,22 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 		}
 
 		/* Everything is OK. Generate! */
-
-		err = 0;
-		offset = 0;
-		frag = skb_shinfo(skb)->frag_list;
-		skb_frag_list_init(skb);
-		skb->data_len = first_len - skb_headlen(skb);
-		skb->len = first_len;
-		iph->tot_len = htons(first_len);
-		iph->frag_off = htons(IP_MF);
-		ip_send_check(iph);
+		ip_fraglist_init(skb, iph, hlen, &iter);
 
 		for (;;) {
 			/* Prepare header of the next frame,
 			 * before previous one went down. */
-			if (frag) {
-				frag->ip_summed = CHECKSUM_NONE;
-				skb_reset_transport_header(frag);
-				__skb_push(frag, hlen);
-				skb_reset_network_header(frag);
-				memcpy(skb_network_header(frag), iph, hlen);
-				iph = ip_hdr(frag);
-				iph->tot_len = htons(frag->len);
-				ip_copy_metadata(frag, skb);
-				if (offset == 0)
-					ip_options_fragment(frag);
-				offset += skb->len - hlen;
-				iph->frag_off = htons(offset>>3);
-				if (frag->next)
-					iph->frag_off |= htons(IP_MF);
-				/* Ready, complete checksum */
-				ip_send_check(iph);
-			}
+			if (iter.frag)
+				ip_fraglist_prepare(skb, &iter);
 
 			err = output(net, sk, skb);
 
 			if (!err)
 				IP_INC_STATS(net, IPSTATS_MIB_FRAGCREATES);
-			if (err || !frag)
+			if (err || !iter.frag)
 				break;
 
-			skb = frag;
-			frag = skb->next;
-			skb_mark_not_on_list(skb);
+			skb = ip_fraglist_next(&iter);
 		}
 
 		if (err == 0) {
@@ -690,7 +712,7 @@ int ip_do_fragment(struct net *net, struct sock *sk, struct sk_buff *skb,
 			return 0;
 		}
 
-		kfree_skb_list(frag);
+		kfree_skb_list(iter.frag_list);
 
 		IP_INC_STATS(net, IPSTATS_MIB_FRAGFAILS);
 		return err;
-- 
2.11.0

