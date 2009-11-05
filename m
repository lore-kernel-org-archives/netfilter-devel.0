From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH][BRIDGE-NETFILTER] fix REJECT for bridged traffic
Date: Thu, 05 Nov 2009 20:19:32 +0100
Message-ID: <4AF32544.2060709@pandora.be>
References: <4AF1D08C.2030907@pandora.be> <4AF2E21B.4050801@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070403050309080605090907"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from brigitte.telenet-ops.be ([195.130.137.66]:60038 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758429AbZKETTj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Nov 2009 14:19:39 -0500
In-Reply-To: <4AF2E21B.4050801@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------070403050309080605090907
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Patrick McHardy schreef:
> Bart De Schuymer wrote:
>   
>> Hi,
>>
>> The attached patch does the following:
>> 1. fix a bug introduced in commit
>> 9d02002d2dc2c7423e5891b97727fde4d667adf1 (2/10/2006) which made
>> ipt_REJECT stop work for bridged traffic (use of nskb instead of oldskb)
>> 2. use the correct source MAC address for the response (bug reported in
>> bug 531 of netfilter's bugzilla)
>>
>> Tested for plain IP traffic and IP traffic encapsulated inside a VLAN
>> header (should also work for PPPoE encapsulated IP traffic).
>>
>>
>> --- linux-2.6.31-uml/net/bridge/br_netfilter.c.fixed	2009-11-02 21:22:00.000000000 +0100
>> +++ linux-2.6.31-uml/net/bridge/br_netfilter.c	2009-11-03 22:18:41.000000000 +0100
>> @@ -775,6 +766,13 @@ static unsigned int br_nf_local_out(unsi
>>  		return NF_DROP;
>>  
>>  	nf_bridge = skb->nf_bridge;
>> +	/* Enable complete transparency for e.g. ipt_REJECT */
>> +	if (nf_bridge->mask & BRNF_COPY_MAC_SADDR) {
>> +		skb_copy_to_linear_data_offset(skb, -8, nf_bridge->data, 6);
>>     
>
> Please use the proper ETH_*LEN values. I guess that would be
> skb_copy_to_linear_data_offset(skb, -(ETH_HLEN - ETH_ALEN),
>                                nf_bridge->data, ETH_ALEN)
>
>   
Done, see attached patch.

>> +		nf_bridge_put(nf_bridge);
>> +		skb->nf_bridge = NULL;
>> +		return NF_ACCEPT;
>>     
>
> Shouldn't packets with BRNF_BRIDGED_DNAT continue through NF_BR_FORWARD
> like they used to?
>
>   
Yes. It is impossible for an skbuff to have both flags set.

>> +	}
>>  	if (!(nf_bridge->mask & BRNF_BRIDGED_DNAT))
>>  		return NF_ACCEPT;
>>  
>> --- linux-2.6.31-uml/net/ipv4/netfilter/ipt_REJECT.c.ori	2009-10-31 19:31:54.000000000 +0100
>> +++ linux-2.6.31-uml/net/ipv4/netfilter/ipt_REJECT.c	2009-11-03 21:55:08.000000000 +0100
>> @@ -100,11 +100,19 @@ static void send_reset(struct sk_buff *o
>>  						    sizeof(struct tcphdr), 0));
>>  
>>  	addr_type = RTN_UNSPEC;
>> -	if (hook != NF_INET_FORWARD
>>  #ifdef CONFIG_BRIDGE_NETFILTER
>> -	    || (nskb->nf_bridge && nskb->nf_bridge->mask & BRNF_BRIDGED)
>> +	if (oldskb->nf_bridge && oldskb->nf_bridge->mask & BRNF_BRIDGED) {
>> +		int daddr_offset = -14 - nf_bridge_encap_header_len(oldskb);
>> +
>> +		addr_type = RTN_LOCAL;
>> +		if (!nf_bridge_alloc(nskb))
>> +			goto free_nskb;
>> +		nskb->nf_bridge->mask |= BRNF_COPY_MAC_SADDR;
>> +		skb_copy_from_linear_data_offset(oldskb, daddr_offset,
>> +						 nskb->nf_bridge->data, 6);
>>     
>
> Also proper ETH_* values please. But I'm wondering, we already save
> the entire header in br_nf_post_routing(). Can't that be done earlier
> so the upper layers don't have to care about this stuff and can simply
> attach the original nf_bridge reference?
>
>   
If you don't save the correct MAC address for the newly created skbuff 
in ipt_REJECT, there is no way to get it back later. Furthermore, if you 
save the header too early, MAC SNAT and DNAT might have changed the 
header and you have to resave the header anyway.
> I'm also wondering - how are ICMP rejects handled?
>
>   
Good question :-)
ICMP packets currently get sent with a source IP and MAC address of the 
bridge. If the bridge doesn't have an IP address but does have a 
suitable route, the source address is 0.0.0.0. I'll look into fixing this.

>> +	} else
>>  #endif
>> -	   )
>> +	if (hook != NF_INET_FORWARD)
>>  		addr_type = RTN_LOCAL;
>>     
>
> We used to route all bridged packets as RTN_LOCAL for some reason
> which I'm not sure of. This is not necessary anymore?
>
>   
Yes it is still necessary and it's in the patch. There used to be 
special code for bridge-netfilter in send_reset because we didn't want 
to enforce ip_forward to be enabled to be able to send the reset answers 
(there used to be a comment about that in ipt_REJECT). However, the 
commit I mentioned above rewrote the send_reset function and enabling 
ip_forward isn't enough anymore: it doesn't work without RTN_LOCAL.

cheers,
Bart

-- 
Bart De Schuymer
www.artinalgorithms.be


--------------070403050309080605090907
Content-Type: text/plain;
 name="ipt_REJECT_use_correct_SMAC.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="ipt_REJECT_use_correct_SMAC.diff"

--- linux-2.6.31-uml/include/linux/netfilter_bridge.h.ori	2009-11-02 20:58:59.000000000 +0100
+++ linux-2.6.31-uml/include/linux/netfilter_bridge.h	2009-11-02 19:58:09.000000000 +0100
@@ -44,6 +44,7 @@ enum nf_br_hook_priorities {
 #define BRNF_DONT_TAKE_PARENT		0x04
 #define BRNF_BRIDGED			0x08
 #define BRNF_NF_BRIDGE_PREROUTING	0x10
+#define BRNF_COPY_MAC_SADDR		0x20
 
 
 /* Only used in br_forward.c */
@@ -77,6 +78,15 @@ static inline unsigned int nf_bridge_pad
 	return 0;
 }
 
+static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
+{
+	skb->nf_bridge = kzalloc(sizeof(struct nf_bridge_info), GFP_ATOMIC);
+	if (likely(skb->nf_bridge))
+		atomic_set(&(skb->nf_bridge->use), 1);
+
+	return skb->nf_bridge;
+}
+
 struct bridge_skb_cb {
 	union {
 		__be32 ipv4;
--- linux-2.6.31-uml/net/bridge/br_netfilter.c.fixed	2009-11-02 21:22:00.000000000 +0100
+++ linux-2.6.31-uml/net/bridge/br_netfilter.c	2009-11-05 19:30:17.000000000 +0100
@@ -145,15 +145,6 @@ static inline struct net_device *bridge_
 	return port ? port->br->dev : NULL;
 }
 
-static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
-{
-	skb->nf_bridge = kzalloc(sizeof(struct nf_bridge_info), GFP_ATOMIC);
-	if (likely(skb->nf_bridge))
-		atomic_set(&(skb->nf_bridge->use), 1);
-
-	return skb->nf_bridge;
-}
-
 static inline struct nf_bridge_info *nf_bridge_unshare(struct sk_buff *skb)
 {
 	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
@@ -775,6 +766,14 @@ static unsigned int br_nf_local_out(unsi
 		return NF_DROP;
 
 	nf_bridge = skb->nf_bridge;
+	/* Enable complete transparency for e.g. ipt_REJECT */
+	if (nf_bridge->mask & BRNF_COPY_MAC_SADDR) {
+		skb_copy_to_linear_data_offset(skb, -(ETH_HLEN - ETH_ALEN),
+					       nf_bridge->data, ETH_ALEN);
+		nf_bridge_put(nf_bridge);
+		skb->nf_bridge = NULL;
+		return NF_ACCEPT;
+	}
 	if (!(nf_bridge->mask & BRNF_BRIDGED_DNAT))
 		return NF_ACCEPT;
 
--- linux-2.6.31-uml/net/ipv4/netfilter/ipt_REJECT.c.ori	2009-10-31 19:31:54.000000000 +0100
+++ linux-2.6.31-uml/net/ipv4/netfilter/ipt_REJECT.c	2009-11-05 19:29:58.000000000 +0100
@@ -100,11 +100,19 @@ static void send_reset(struct sk_buff *o
 						    sizeof(struct tcphdr), 0));
 
 	addr_type = RTN_UNSPEC;
-	if (hook != NF_INET_FORWARD
 #ifdef CONFIG_BRIDGE_NETFILTER
-	    || (nskb->nf_bridge && nskb->nf_bridge->mask & BRNF_BRIDGED)
+	if (oldskb->nf_bridge && oldskb->nf_bridge->mask & BRNF_BRIDGED) {
+		int daddr_offset = -ETH_HLEN - nf_bridge_encap_header_len(oldskb);
+
+		addr_type = RTN_LOCAL;
+		if (!nf_bridge_alloc(nskb))
+			goto free_nskb;
+		nskb->nf_bridge->mask |= BRNF_COPY_MAC_SADDR;
+		skb_copy_from_linear_data_offset(oldskb, daddr_offset,
+						 nskb->nf_bridge->data, ETH_ALEN);
+	} else
 #endif
-	   )
+	if (hook != NF_INET_FORWARD)
 		addr_type = RTN_LOCAL;
 
 	/* ip_route_me_harder expects skb->dst to be set */

--------------070403050309080605090907--
