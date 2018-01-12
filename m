From: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Subject: [PATCH nf-next] netfilter: ipv6: nf_defrag: Always pass on packets to stack
Date: Thu, 11 Jan 2018 23:04:33 -0700
Message-ID: <1515737073-32344-2-git-send-email-subashab@codeaurora.org>
References: <1515737073-32344-1-git-send-email-subashab@codeaurora.org>
Cc: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To: pablo@netfilter.org, netfilter-devel@vger.kernel.org, fw@strlen.de
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44576 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754259AbeALGFF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 12 Jan 2018 01:05:05 -0500
In-Reply-To: <1515737073-32344-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

ipv6_defrag pulls network headers before fragment header. In case of
an error, the netfilter layer is currently dropping these packets.
This results in failure of some IPv6 standards tests which passed on
older kernels due to the netfilter framework using cloning.

The test case run here is a check for ICMPv6 error message replies
when some invalid IPv6 fragments are sent. This specific test case is
listed in https://www.ipv6ready.org/docs/Core_Conformance_Latest.pdf
in the Extension Header Processing Order section.

A packet with unrecognized option Type 11 is sent and the test expects
an ICMP error in line with RFC2460 section 4.2 -

11 - discard the packet and, only if the packet's Destination
     Address was not a multicast address, send an ICMP Parameter
     Problem, Code 2, message to the packet's Source Address,
     pointing to the unrecognized Option Type.

Since netfilter layer now drops all invalid IPv6 frag packets, we no
longer see the ICMP error message and fail the test case.

To fix this, clone the packet and allow it to be processed by the defrag
queue. In case defrag holds onto the packet, drop the original skb. If
defrag is unable to process it, free this cloned skb and pass on the
original skb.

Signed-off-by: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
---
 net/ipv6/netfilter/nf_conntrack_reasm.c   | 15 +++++++++++++--
 net/ipv6/netfilter/nf_defrag_ipv6_hooks.c |  4 ++--
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/net/ipv6/netfilter/nf_conntrack_reasm.c b/net/ipv6/netfilter/nf_conntrack_reasm.c
index 977d890..a44c8b2 100644
--- a/net/ipv6/netfilter/nf_conntrack_reasm.c
+++ b/net/ipv6/netfilter/nf_conntrack_reasm.c
@@ -574,17 +574,26 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 	struct ipv6hdr *hdr;
 	u8 prevhdr;
 
+	skb = skb_clone(skb, GFP_ATOMIC);
+	if (!skb)
+		return -ENOMEM;
+
 	/* Jumbo payload inhibits frag. header */
 	if (ipv6_hdr(skb)->payload_len == 0) {
 		pr_debug("payload len = 0\n");
+		kfree(skb);
 		return 0;
 	}
 
-	if (find_prev_fhdr(skb, &prevhdr, &nhoff, &fhoff) < 0)
+	if (find_prev_fhdr(skb, &prevhdr, &nhoff, &fhoff) < 0) {
+		kfree(skb);
 		return 0;
+	}
 
-	if (!pskb_may_pull(skb, fhoff + sizeof(*fhdr)))
+	if (!pskb_may_pull(skb, fhoff + sizeof(*fhdr))) {
+		kfree(skb);
 		return -ENOMEM;
+	}
 
 	skb_set_transport_header(skb, fhoff);
 	hdr = ipv6_hdr(skb);
@@ -595,6 +604,7 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 		     skb->dev ? skb->dev->ifindex : 0, ip6_frag_ecn(hdr));
 	if (fq == NULL) {
 		pr_debug("Can't find and can't create new queue\n");
+		kfree(skb);
 		return -ENOMEM;
 	}
 
@@ -602,6 +612,7 @@ int nf_ct_frag6_gather(struct net *net, struct sk_buff *skb, u32 user)
 
 	if (nf_ct_frag6_queue(fq, skb, fhdr, nhoff) < 0) {
 		ret = -EINVAL;
+		kfree(skb);
 		goto out_unlock;
 	}
 
diff --git a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
index c87b483..08717cd 100644
--- a/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
+++ b/net/ipv6/netfilter/nf_defrag_ipv6_hooks.c
@@ -72,9 +72,9 @@ static unsigned int ipv6_defrag(void *priv,
 				 nf_ct6_defrag_user(state->hook, skb));
 	/* queued */
 	if (err == -EINPROGRESS)
-		return NF_STOLEN;
+		return NF_DROP;
 
-	return err == 0 ? NF_ACCEPT : NF_DROP;
+	return NF_ACCEPT;
 }
 
 static const struct nf_hook_ops ipv6_defrag_ops[] = {
-- 
1.9.1

