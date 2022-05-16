Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23587C433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 May 2022 11:17:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbiEPLRc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 May 2022 07:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiEPLR3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 May 2022 07:17:29 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A8195326F5
        for <netfilter-devel@vger.kernel.org>; Mon, 16 May 2022 04:17:26 -0700 (PDT)
Date:   Mon, 16 May 2022 13:17:23 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ritaro Takenaka <ritarot634@gmail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: nf_flowtable: move dst_check to packet path
Message-ID: <YoIywy8+ZKN1PlMQ@salvia>
References: <20220511122423.556499-1-ritarot634@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220511122423.556499-1-ritarot634@gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, May 11, 2022 at 09:24:24PM +0900, Ritaro Takenaka wrote:
> Fixes sporadic IPv6 packet loss when flow offloading is enabled.
> 
> IPv6 route GC and flowtable GC are not synchronized.
> When dst_cache becomes stale and a packet passes through the flow before
> the flowtable GC teardowns it, the packet can be dropped.
> 
> So, it is necessary to check dst every time in packet path.
> 
> Signed-off-by: Ritaro Takenaka <ritarot634@gmail.com>
> ---
>  net/netfilter/nf_flow_table_core.c | 23 +----------------------
>  net/netfilter/nf_flow_table_ip.c   | 17 +++++++++++++++++
>  2 files changed, 18 insertions(+), 22 deletions(-)
> 
> diff --git a/net/netfilter/nf_flow_table_core.c b/net/netfilter/nf_flow_table_core.c
> index 3db256da919b..1d99afaf22c1 100644
> --- a/net/netfilter/nf_flow_table_core.c
> +++ b/net/netfilter/nf_flow_table_core.c
> @@ -438,32 +438,11 @@ nf_flow_table_iterate(struct nf_flowtable *flow_table,
>  	return err;
>  }
>  
> -static bool flow_offload_stale_dst(struct flow_offload_tuple *tuple)
> -{
> -	struct dst_entry *dst;
> -
> -	if (tuple->xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
> -	    tuple->xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {
> -		dst = tuple->dst_cache;
> -		if (!dst_check(dst, tuple->dst_cookie))
> -			return true;
> -	}
> -
> -	return false;
> -}
> -
> -static bool nf_flow_has_stale_dst(struct flow_offload *flow)
> -{
> -	return flow_offload_stale_dst(&flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple) ||
> -	       flow_offload_stale_dst(&flow->tuplehash[FLOW_OFFLOAD_DIR_REPLY].tuple);
> -}
> -
>  static void nf_flow_offload_gc_step(struct nf_flowtable *flow_table,
>  				    struct flow_offload *flow, void *data)
>  {
>  	if (nf_flow_has_expired(flow) ||
> -	    nf_ct_is_dying(flow->ct) ||
> -	    nf_flow_has_stale_dst(flow))
> +	    nf_ct_is_dying(flow->ct))
>  		set_bit(NF_FLOW_TEARDOWN, &flow->flags);
>  
>  	if (test_bit(NF_FLOW_TEARDOWN, &flow->flags)) {
> diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
> index 32c0eb1b4821..402742dd054c 100644
> --- a/net/netfilter/nf_flow_table_ip.c
> +++ b/net/netfilter/nf_flow_table_ip.c
> @@ -367,6 +367,14 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
>  	if (nf_flow_state_check(flow, iph->protocol, skb, thoff))
>  		return NF_ACCEPT;
>  
> +	if (tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
> +	    tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {

Probably restore:

static inline bool nf_flow_dst_check(...)
{
        if (tuplehash->tuple.xmit_type != FLOW_OFFLOAD_XMIT_NEIGH &&
            tuplehash->tuple.xmit_type != FLOW_OFFLOAD_XMIT_XFRM)
                return true;

        return dst_check(...);
}

and use it.

BTW, could you also search for the Fixes: tag?

Thanks.

> +		if (!dst_check(tuplehash->tuple.dst_cache, 0)) {
> +			flow_offload_teardown(flow);
> +			return NF_ACCEPT;
> +		}
> +	}
> +
>  	if (skb_try_make_writable(skb, thoff + hdrsize))
>  		return NF_DROP;
>  
> @@ -624,6 +632,15 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
>  	if (nf_flow_state_check(flow, ip6h->nexthdr, skb, thoff))
>  		return NF_ACCEPT;
>  
> +	if (tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_NEIGH ||
> +	    tuplehash->tuple.xmit_type == FLOW_OFFLOAD_XMIT_XFRM) {
> +		if (!dst_check(tuplehash->tuple.dst_cache,
> +			       tuplehash->tuple.dst_cookie)) {
> +			flow_offload_teardown(flow);
> +			return NF_ACCEPT;
> +		}
> +	}
> +
>  	if (skb_try_make_writable(skb, thoff + hdrsize))
>  		return NF_DROP;
>  
> -- 
> 2.34.1
> 
