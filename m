From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 3/3] netfilter: bridge: copy back VLAN header for
 bridge packet queued to userspace
Date: Fri, 15 Jan 2016 12:02:18 +0100
Message-ID: <20160115110218.GA2361@salvia>
References: <1452847734-3766-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1452847734-3766-4-git-send-email-stephane.ml.bryant@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Stephane Bryant <stephane.ml.bryant@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46063 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754387AbcAOLC1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Jan 2016 06:02:27 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C8F2B1324C0
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Jan 2016 12:02:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B753FDA843
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Jan 2016 12:02:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 6A99EDA803
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Jan 2016 12:02:20 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1452847734-3766-4-git-send-email-stephane.ml.bryant@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 15, 2016 at 09:48:54AM +0100, Stephane Bryant wrote:
> From: stephane <stephane.ml.bryant@gmail.com>
> 
> For bridge packets queued to userspace, this uses the skb tci info
> to reinstate the VLAN header, and conversely parses and removes it
> to fill the tci info on the way back.
> 
> Signed-off-by: Stephane Bryant <stephane.ml.bryant@gmail.com>
> ---
>  net/netfilter/nfnetlink_queue.c | 72 ++++++++++++++++++++++++++++++-----------
>  1 file changed, 54 insertions(+), 18 deletions(-)
> 
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
> index b299236..07723f9 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -548,7 +548,26 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  
>  		nla = (struct nlattr *)skb_put(skb, sizeof(*nla));
>  		nla->nla_type = NFQA_PAYLOAD;
> -		nla->nla_len = nla_attr_size(data_len);
> +		nla->nla_len =
> +			nla_attr_size(data_len + mac_header_len + vlan_len);
> +		if (mac_header_len > 0) {
> +			unsigned char *mac_header;
> +
> +			mac_header = skb_put(skb, mac_header_len + vlan_len);
> +			memcpy(mac_header, skb_mac_header(entskb),
> +			       mac_header_len);
> +			if (vlan_len > 0) {
> +				struct vlan_ethhdr *veth =
> +					(struct vlan_ethhdr *)mac_header;
> +
> +				u16 proto = veth->h_vlan_proto;
> +
> +				veth->h_vlan_proto = entskb->vlan_proto;
> +				veth->h_vlan_TCI =
> +					htons(skb_vlan_tag_get(entskb));
> +				veth->h_vlan_encapsulated_proto = proto;
> +			}
> +		}

For the specific case of nfnetlink_queue, I would expose the vlan
information through a new netlink attribute NFQA_VLAN (similar to what
we do for NFQA_HWADDR for the layer 3).

>  		if (skb_zerocopy(skb, entskb, data_len, hlen))
>  			goto nla_put_failure;
> @@ -556,9 +575,6 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
>  
>  	nlh->nlmsg_len = skb->len;
>  
> -	if (mac_header_len > 0)
> -		skb_pull(entskb, mac_header_len);
> -
>  	return skb;
>  
>  nla_put_failure:
> @@ -1087,24 +1103,44 @@ static int nfqnl_recv_verdict(struct net *net, struct sock *ctnl,
>  
>  	if (nfqa[NFQA_PAYLOAD]) {
>  		u16 payload_len = nla_len(nfqa[NFQA_PAYLOAD]);
> +		unsigned char *payload = nla_data(nfqa[NFQA_PAYLOAD]);
>  		int diff = 0;
>  		int mac_header_len = 0;
> +
>  #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
>  		if ((entry->state.pf == PF_BRIDGE) &&
>  		    (entry->skb->dev &&
>  		     (entry->skb->data > skb_mac_header(entry->skb)))) {
> -			/* push back the mac header into the data so that
> -			 * it gets copied in before mangling
> -			 */
> -			mac_header_len = (int)(entry->skb->data -
> -					       skb_mac_header(entry->skb));
> +			struct vlan_ethhdr *veth =
> +				(struct vlan_ethhdr *)payload;
> +
> +			mac_header_len = (int)
> +				(entry->skb->data - skb_mac_header(entry->skb));
> +			/* push back mac header before mangling */
>  			skb_push(entry->skb, mac_header_len);
> -	}
> +			/* check for VLAN in NFQA_PAYLOAD */
> +			if ((payload_len >= VLAN_ETH_HLEN) &&
> +			    ((veth->h_vlan_proto == htons(ETH_P_8021Q)) ||
> +			     (veth->h_vlan_proto == htons(ETH_P_8021AD)))) {
> +				entry->skb->vlan_proto = veth->h_vlan_proto;
> +				entry->skb->vlan_tci =
> +					ntohs(veth->h_vlan_TCI) |
> +					VLAN_TAG_PRESENT;
> +				memmove(payload + VLAN_HLEN, payload,
> +					2 * ETH_ALEN);
> +				entry->skb->protocol =
> +					veth->h_vlan_encapsulated_proto;
> +				payload += VLAN_HLEN;
> +				payload_len -= VLAN_HLEN;
> +			} else {
> +				entry->skb->vlan_tci &= ~VLAN_TAG_PRESENT;
> +				entry->skb->protocol = veth->h_vlan_proto;
> +			}
> +		}

I'm awar it's more work, but it would be good to reduce ifdef pollution
by placing all this bridge netfilter code wrapped into functions under
one single ifdef in this file to improve maintainability.
