Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.216.245.30
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794036349;
	b=sfbsffnQCLM0DfWi/WFBhEShY2twnucDRYYZAzB2BBintestRbZTCorbDwBs5kQdOH8A
	 yaNlSEjFYLrIbv/2LoWZLQJIWDJ8cFqDXdXGCr4/LMXB43J9dXMb+Zs+XGTx/aBtyEXNC
	 e9oSrVXmm4EFw4auvm6PumqLFs328ns+WbqZFSbicdJr7jTrWdNq6pL42+zcpEa5vfZyi
	 owyl2kKBHqRt85ui8P5vev+xtgGyBxK5c1uxK7li85zaC/5iRK0c8fvtFQGkH7aw/b5HC
	 LigMbbhkOxD6A6Jbp4uvSkbi/H2dVtjS+AdekkFEdWfqg94xFX653rxOj5EdbrCeQ8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794036349;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=SNDereXwlb4/dZxRH96h3UJKC884sqCQjQ+XSkDhBBk=;
	b=X6ZOVjjJVXDeUNYrPdSlb2MK29PSTjLPj5mJDDNk5kzpqL+tDeOboI0qKGOUTMzSiMGh
	 /c0D8NKrnUazM132JMxUjm9vMcEWxkOiLlbb9X2w0nidMhx0yurCC8nEBKF4y6wJTJhR+
	 yehU38sbTzXB4+JifuVUfhXVyBwFwCpT7W2Prfh/btepoK2NmabJenuR4wqYlBWsiUYpZ
	 d5U6CdvJX15pxVhCbcWu0KaPcrZprnjlWlBwSSR+YJci5K6Nc62w15/MmWbWbK5OPHWVA
	 cM8cDa5aBZl0sl8RLofKeBPJcr6K7Fyq3K538rTvCUZkbb7fzJ/bAcEuRMzHgjDbluQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=strlen.de;
	spf=pass smtp.mailfrom=strlen.de;
	arc=none smtp.remote-ip=91.216.245.30
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [91.216.245.30])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 208D2606A326;
	Sat,  7 Nov 2026 07:25:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 208D2606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=strlen.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=strlen.de
Received: by Chamillionaire.breakpoint.cc (Postfix, from userid 1003)
	id ACFA2604DD; Sat, 07 Nov 2026 08:25:45 +0100 (CET)
Date: Sat, 7 Nov 2026 08:25:41 +0100
From: Florian Westphal <fw@strlen.de>
To: Kyle Zeng <kylebot@openai.com>
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>, coreteam@netfilter.org,
	bridge@lists.linux.dev, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, outbounddisclosures@openai.com
Subject: Re: [PATCH] netfilter: br_netfilter: reject unsafe neighbour devices
 for DNAT
Message-ID: <au7SdYQrIqAQOU24@strlen.de>
References: <20261030042155.73844-1-kylebot@openai.com>
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261030042155.73844-1-kylebot@openai.com>

Kyle Zeng <kylebot@openai.com> wrote:
> The IPv4 and IPv6 bridge prerouting callbacks classify DNAT traffic using
> the logical input device saved in skb->dev. The physical input port can
> have a different bridge master when prerouting resumes, for example after
> an NFQUEUE verdict. Netfilter reassembly can also combine the first
> fragment's bridge information with a different fragment's input device.
> 
> br_nf_pre_routing_finish_bridge() replaces skb->dev with the port's
> current bridge master, but looks up the neighbour using the existing
> route. This can put an skb with skb->dev pointing to bridge B on an
> unresolved neighbour of bridge A. Deleting B and resolving the neighbour
> on A then causes a use-after-free in __dev_queue_xmit().
> 
> Before calling the neighbour output method, check that the neighbour
> keeps skb->dev alive. A neighbour holds its device, and a VLAN device
> also holds its real device, so allow a VLAN whose real device is the
> bridge. Release the neighbour and drop the skb on a mismatch.
> 
> Doing this in the shared continuation covers both protocol families,
> including a queue in the remaining bridge prerouting hooks. Leave the
> cached-header path unchanged since it does not enqueue the skb.
> 
> Signed-off-by: Kyle Zeng <kylebot@openai.com>
> ---
> I have a reproducer for this issue and can share via DM
> 
>  net/bridge/br_netfilter_hooks.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/net/bridge/br_netfilter_hooks.c b/net/bridge/br_netfilter_hooks.c
> index e15355ff215a..726a2d17ed3a 100644
> --- a/net/bridge/br_netfilter_hooks.c
> +++ b/net/bridge/br_netfilter_hooks.c
> @@ -307,6 +307,18 @@ int br_nf_pre_routing_finish_bridge(struct net *net, struct sock *sk, struct sk_
>  
>  			ret = br_handle_frame_finish(net, sk, skb);
>  		} else {
> +			struct net_device *dev = neigh->dev;
> +
> +			/* The neighbour queue must keep skb->dev alive. A VLAN
> +			 * device also holds a reference to its real device.
> +			 */
> +			if (is_vlan_dev(dev))
> +				dev = vlan_dev_real_dev(dev);
> +			if (dev != skb->dev) {
> +				neigh_release(neigh);
> +				goto free_skb;
> +			}
> +

I don't understand the vlan check. Why is that needed?
The call to br_nf_pre_routing_finish_bridge is gated via:

 405                         if (skb_dst(skb)->dev == dev) {
 406                                 skb->dev = br_indev;
 407                                 nf_bridge_update_protocol(skb);
 408                                 nf_bridge_push_encap_header(skb);
 409                                 br_nf_hook_thresh(NF_BR_PRE_ROUTING,
 410                                                   net, sk, skb, skb->dev,
 411                                                   NULL,
 412                                                   br_nf_pre_routing_finish_bridge);


... so this patch ought to be sufficient?

--- a/net/bridge/br_netfilter_hooks.c
+++ b/net/bridge/br_netfilter_hooks.c
@@ -283,6 +283,10 @@ int br_nf_pre_routing_finish_bridge(struct net *net, struct sock *sk, struct sk_
        if (!skb->dev)
                goto free_skb;
        dst = skb_dst(skb);
+
+       if (dst->dev != skb->dev)
+               goto free_skb;
+
        neigh = dst_neigh_lookup_skb(dst, skb);

(I can't see how neigh->dev != skb->dev after the extra test).
