From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] netfilter: bridge: honor frag_max_size when
 refragmenting
Date: Thu, 9 Mar 2017 23:15:28 +0100
Message-ID: <20170309221528.GA17890@breakpoint.cc>
References: <20170309220340.12713-1-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:44568 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753324AbdCIWPm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 Mar 2017 17:15:42 -0500
Content-Disposition: inline
In-Reply-To: <20170309220340.12713-1-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Florian Westphal <fw@strlen.de> wrote:
> consider a bridge with mtu 9000, but end host sending smaller
> packets to another host with mtu < 9000.
> 
> In this case, after reassembly, bridge+defrag would refragment,
> and then attempt to send the reassembled packet as long as it
> was below 9k.
> 
> Instead we have to cap by the largest fragment size seen.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>
> ---
>  No Fixes tag, seems this problem has always existed.
>  tested in kvm with both ipv4 and ipv6 and following setup:
> 
>  client (mtu 1500)  --- bridge(mtu 9k) --- client (mtu 1500)
> 
>  bridge (incl. all ports) have 9k mtu.
> 
>  without this patch, ping/ping6 only works for sizes <= 1500
>  and > 9000.

grrr.  it breaks the normal path...

> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> index 95087e6e8258..81889afee212 100644
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c
> @@ -721,18 +721,19 @@ static unsigned int nf_bridge_mtu_reduction(const struct sk_buff *skb)
>  
>  static int br_nf_dev_queue_xmit(struct net *net, struct sock *sk, struct sk_buff *skb)
>  {
> -	struct nf_bridge_info *nf_bridge;
> -	unsigned int mtu_reserved;
> +	struct nf_bridge_info *nf_bridge = nf_bridge_info_get(skb);
> +	unsigned int mtu, mtu_reserved;
>  
>  	mtu_reserved = nf_bridge_mtu_reduction(skb);
> +	mtu = nf_bridge->frag_max_size;

This can be 0, I'll send a v2.
