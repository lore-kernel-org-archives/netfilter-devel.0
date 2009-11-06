From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH][BRIDGE-NETFILTER] fix REJECT for bridged traffic
Date: Fri, 06 Nov 2009 18:46:26 +0100
Message-ID: <4AF460F2.30300@trash.net>
References: <4AF1D08C.2030907@pandora.be> <4AF2E21B.4050801@trash.net> <4AF32544.2060709@pandora.be> <4AF448C8.80701@trash.net> <4AF45DFB.3070606@pandora.be> <4AF45E91.9050203@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030603000104050306000503"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34444 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752688AbZKFRqX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Nov 2009 12:46:23 -0500
In-Reply-To: <4AF45E91.9050203@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030603000104050306000503
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Patrick McHardy wrote:
> Bart De Schuymer wrote:
>> Patrick McHardy schreef:
>>> Yes, we need to save it at some point. My idea was that we might be able
>>> to save it in PREROUTING instead of POSTROUTING and only do
>>>
>>> nskb->nf_bridge = nf_bridge_get(oskb->nf_bridge)
>>>
>>> in ipt_REJECT and probably also the ICMP code. MAC NAT could be handled
>>> by updating the bridge info simultaneously.
>>>
>>>   
>> The code creates a new skbuf and the correct source MAC address is lost
>> if you don't attach it to the skbuf at that time.
> 
> That's what I'm doing above.
> 
>> How will you know in
>> PREROUTING what SMAC to use if you didn't save it when you created the
>> skbuf?
> 
> I'm not sure I understand what you're getting at. The above
> line of code would do exactly that, attach the nf_bridge
> data from the original packet to the newly created one.
> But for this to work we need to make sure its valid in all
> hooks, hence my suggestion to save it in PREROUTING instead
> of POSTROUTING.

This patch demonstrates the idea. Its not compile tested
and incomplete, just to make more clear what I'm suggesting.

--------------030603000104050306000503
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 0c68fbd..410b0dc 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1952,10 +1952,11 @@ static inline void nf_bridge_put(struct nf_bridge_info *nf_bridge)
 	if (nf_bridge && atomic_dec_and_test(&nf_bridge->use))
 		kfree(nf_bridge);
 }
-static inline void nf_bridge_get(struct nf_bridge_info *nf_bridge)
+static inline struct nf_bridge_info *nf_bridge_get(struct nf_bridge_info *nf_bridge)
 {
 	if (nf_bridge)
 		atomic_inc(&nf_bridge->use);
+	return nf_bridge;
 }
 #endif /* CONFIG_BRIDGE_NETFILTER */
 static inline void nf_reset(struct sk_buff *skb)
diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
index a16a234..0732b3b 100644
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -567,6 +567,8 @@ static unsigned int br_nf_pre_routing(unsigned int hook, struct sk_buff *skb,
 			return NF_ACCEPT;
 #endif
 		nf_bridge_pull_encap_header_rcsum(skb);
+		nf_bridge_save_header(skb);
+
 		return br_nf_pre_routing_ipv6(hook, skb, in, out, okfn);
 	}
 #ifdef CONFIG_SYSCTL
@@ -579,6 +581,7 @@ static unsigned int br_nf_pre_routing(unsigned int hook, struct sk_buff *skb,
 		return NF_ACCEPT;
 
 	nf_bridge_pull_encap_header_rcsum(skb);
+	nf_bridge_save_header(skb);
 
 	if (!pskb_may_pull(skb, sizeof(struct iphdr)))
 		goto inhdr_error;
@@ -863,7 +866,6 @@ static unsigned int br_nf_post_routing(unsigned int hook, struct sk_buff *skb,
 	}
 
 	nf_bridge_pull_encap_header(skb);
-	nf_bridge_save_header(skb);
 
 	NF_HOOK(pf, NF_INET_POST_ROUTING, skb, NULL, realoutdev,
 		br_nf_dev_queue_xmit);
diff --git a/net/bridge/netfilter/ebt_dnat.c b/net/bridge/netfilter/ebt_dnat.c
index 6b49ea9..3f4acfa 100644
--- a/net/bridge/netfilter/ebt_dnat.c
+++ b/net/bridge/netfilter/ebt_dnat.c
@@ -23,6 +23,7 @@ ebt_dnat_tg(struct sk_buff *skb, const struct xt_target_param *par)
 		return EBT_DROP;
 
 	memcpy(eth_hdr(skb)->h_dest, info->mac, ETH_ALEN);
+	/* update nf_bridge info */
 	return info->target;
 }
 
diff --git a/net/bridge/netfilter/ebt_snat.c b/net/bridge/netfilter/ebt_snat.c
index 8d04d4c..edd4682 100644
--- a/net/bridge/netfilter/ebt_snat.c
+++ b/net/bridge/netfilter/ebt_snat.c
@@ -25,6 +25,7 @@ ebt_snat_tg(struct sk_buff *skb, const struct xt_target_param *par)
 		return EBT_DROP;
 
 	memcpy(eth_hdr(skb)->h_source, info->mac, ETH_ALEN);
+	/* update nf_bridge info */
 	if (!(info->target & NAT_ARP_BIT) &&
 	    eth_hdr(skb)->h_proto == htons(ETH_P_ARP)) {
 		const struct arphdr *ap;
diff --git a/net/ipv4/netfilter/ipt_REJECT.c b/net/ipv4/netfilter/ipt_REJECT.c
index c93ae44..f66a7cc 100644
--- a/net/ipv4/netfilter/ipt_REJECT.c
+++ b/net/ipv4/netfilter/ipt_REJECT.c
@@ -107,6 +107,8 @@ static void send_reset(struct sk_buff *oldskb, int hook)
 	   )
 		addr_type = RTN_LOCAL;
 
+	nskb->nf_bridge = nf_bridge_get(oldskb->nf_bridge);
+
 	/* ip_route_me_harder expects skb->dst to be set */
 	skb_dst_set(nskb, dst_clone(skb_dst(oldskb)));
 

--------------030603000104050306000503--
