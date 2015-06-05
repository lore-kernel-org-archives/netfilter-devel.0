From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] netfilter: bridge: restore vlan tag when refragmenting
Date: Fri, 05 Jun 2015 07:37:01 -0700
Message-ID: <1433515021.1895.57.camel@edumazet-glaptop2.roam.corp.google.com>
References: <1433503633-16312-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:34281 "EHLO
	mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422814AbbFEOhE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jun 2015 10:37:04 -0400
Received: by qkoo18 with SMTP id o18so41506855qko.1
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jun 2015 07:37:02 -0700 (PDT)
In-Reply-To: <1433503633-16312-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2015-06-05 at 13:27 +0200, Florian Westphal wrote:
> If bridge netfilter is used with both
> bridge-nf-call-iptables and bridge-nf-filter-vlan-tagged enabled
> then ip fragments in VLAN frames are sent without the vlan header.
> 
> This has never worked reliably.  Turns out this relied on pre-3.5
> behaviour where skb frag_list was used to store ip fragments;
> ip_fragment() then re-used these skbs.
> 
> But since commit 3cc4949269e01f39443d0fcfffb5bc6b47878d45
> ("ipv4: use skb coalescing in defragmentation") this is no longer
> the case.  ip_do_fragment now needs to allocate new skbs, but these
> don't contain the vlan tag information anymore.
> 
> Fix it by storing vlan information of the ressembled skb in the
> br netfilter percpu frag area, and restore them for each of the
> fragments.
> 
> Fixes: 3cc4949269e01f3 ("ipv4: use skb coalescing in defragmentation")
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  net/bridge/br_netfilter.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
> index 46660a2..0d9ad4a 100644
> --- a/net/bridge/br_netfilter.c
> +++ b/net/bridge/br_netfilter.c
> @@ -115,6 +115,8 @@ struct brnf_frag_data {
>  	char mac[NF_BRIDGE_MAX_MAC_HEADER_LENGTH];
>  	u8 encap_size;
>  	u8 size;
> +	u16 vlan_tci;
> +	__be16 vlan_proto;
>  };
>  
>  static DEFINE_PER_CPU(struct brnf_frag_data, brnf_frag_data_storage);
> @@ -837,6 +839,11 @@ static int br_nf_push_frag_xmit(struct sock *sk, struct sk_buff *skb)
>  		return 0;
>  	}
>  
> +	if (data->vlan_tci) {
> +		skb->vlan_tci = data->vlan_tci;
> +		skb->vlan_proto = data->vlan_proto;
> +	}
> +
>  	skb_copy_to_linear_data_offset(skb, -data->size, data->mac, data->size);
>  	__skb_push(skb, data->encap_size);
>  
> @@ -890,6 +897,9 @@ static int br_nf_dev_queue_xmit(struct sock *sk, struct sk_buff *skb)
>  		nf_bridge_update_protocol(skb);
>  
>  		data = this_cpu_ptr(&brnf_frag_data_storage);
> +
> +		data->vlan_tci = skb->vlan_tci;
> +		data->vlan_proto = skb->vlan_proto;
>  		data->encap_size = nf_bridge_encap_header_len(skb);
>  		data->size = ETH_HLEN + data->encap_size;
>  

I am curious :

IP defrag unit does not care about vlan, so how do we ensure all frags
have same vlan characteristics ?

Thanks Florian !


