From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH v2] netfilter: bridge: unshare bridge info before change
 it
Date: Thu, 20 Nov 2014 09:22:27 +0800
Message-ID: <546D4253.1060008@cn.fujitsu.com>
References: <1416366453-12090-1-git-send-email-gaofeng@cn.fujitsu.com> <20141119130751.GA10748@salvia> <20141119133204.GA12162@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:50090 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754910AbaKTBWc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Nov 2014 20:22:32 -0500
In-Reply-To: <20141119133204.GA12162@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/19/2014 09:32 PM, Pablo Neira Ayuso wrote:
> On Wed, Nov 19, 2014 at 02:07:51PM +0100, Pablo Neira Ayuso wrote:
>> > On Wed, Nov 19, 2014 at 11:07:32AM +0800, Gao feng wrote:
>>> > > diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
>>> > > index c755e49..dca7337 100644
>>> > > --- a/include/linux/netfilter_bridge.h
>>> > > +++ b/include/linux/netfilter_bridge.h
>>> > > @@ -81,14 +81,64 @@ static inline unsigned int nf_bridge_mtu_reduction(const struct sk_buff *skb)
>>> > >  	return 0;
>>> > >  }
>>> > >  
>>> > > +static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
>>> > > +{
>>> > > +	skb->nf_bridge = kzalloc(sizeof(struct nf_bridge_info), GFP_ATOMIC);
>>> > > +	if (likely(skb->nf_bridge))
>>> > > +		atomic_set(&(skb->nf_bridge->use), 1);
>>> > > +
>>> > > +	return skb->nf_bridge;
>>> > > +}
>>> > > +
>>> > > +static inline struct nf_bridge_info *nf_bridge_unshare(struct sk_buff *skb)
>>> > > +{
>>> > > +	struct nf_bridge_info *nf_bridge = skb->nf_bridge;
>>> > > +
>>> > > +	if (atomic_read(&nf_bridge->use) > 1) {
>>> > > +		struct nf_bridge_info *tmp = nf_bridge_alloc(skb);
>> > 
>> > nf_bridge_alloc() overwrites the original skb->nf_bridge when
>> > unsharing, so this leaks and likely breaks other things.
> I took over your patch and gave it another spin.
> 
> Specifically, I added some helper functions to handle the skb->pkttype
> mangling (see nf_br_mangle_pkttype(), nf_br_restore_pkttype().
> Also fixed the problem above, compile tested only.
> 
> Not your fault, this br_netfilter code is not in good shape, but I
> would like not to get it worse.
> 
> Would you take this over and split it in smaller patches? I'd suggest:
> 

Looks good,I will take this over if you have no objection to my comment below.

> 1) Cleanup patch to use &=~ instead of ^=. The existing code looks
> fine, but I think a bug may invert the bits when use xor to handle
> flags.
> 
> 2) Patch to move nf_bridge_alloc() and so on to the header file, to
> prepare the unshare fix.
> 
> 3) Patch to add the pkttype helper functions.
> 
> 4) Your unshare fix for br_netfilter.
> 
> Would you work on that? Thanks.
> 
> 
> 0001-netfilter-bridge-unshare-bridge-info-before-change-i.patch
> 
> 
>>From 6fd546e3866fe5a60be84aebd5fbc1e93ef14f46 Mon Sep 17 00:00:00 2001
> From: Gao feng <gaofeng@cn.fujitsu.com>
> Date: Wed, 19 Nov 2014 11:07:32 +0800
> Subject: [PATCH] netfilter: bridge: unshare bridge info before change it
> 
> Many packets may share the same bridge information, we should unshare
> the bridge info before we change it, otherwise other packets will go to
> PF_INET(6)/PRE_ROUTING second time or the pkt_type of other packets
> will be incorrect.
> 
> The problem occurs in below case.
> 
> Firstly setup NFQUEUE rule on ipv4 PREROUTING chain.
> 
> When gso packet came in from bridge, br_nf_pre_routing will
> allocate nf_bridge_info for this gso packet and call setup_pre_routing
> to setup nf_bridge_info (such as nf_bridge->mask |= BRNF_NF_BRIDGE_PREROUTING)
> 
> Then this packet goes to ipv4 prerouting chain, nfqnl_enqueue_packet
> will call skb_segment to segment this gso packet. in skb_segment, the
> new packets will copy gso packet's header(__copy_skb_header), so there
> will be many packets share the same nf_bridge_info.
> 
> When these segmented packets being reinjected into kernel, they will
> continue going through bridge netfilter, br_nf_pre_routing_finish will
> clean the BRNF_NF_BRIDGE_PREROUTING for the first packet, setup it for
> the secondary packet, clean it for the third packet...
> 
> If the dest of these packets is local machine, they will come into
> br_pass_frame_up. then go to ipv4 prerouting chain again through
> netif_receive_skb. so ip_sabotage_in will not stop half of these
> packets.
> 
> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> ---
> NOTE: This still needs another review. The patch is rather large and it would
> be good to split this in smaller chunks for easier review.
> 
>  include/linux/netfilter_bridge.h |   57 +++++++++++++++-
>  net/bridge/br_netfilter.c        |  135 +++++++++++++++++---------------------
>  2 files changed, 116 insertions(+), 76 deletions(-)
> 
> diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
> index c755e49..cad76d6 100644
> --- a/include/linux/netfilter_bridge.h
> +++ b/include/linux/netfilter_bridge.h
> @@ -81,14 +81,67 @@ static inline unsigned int nf_bridge_mtu_reduction(const struct sk_buff *skb)
>  	return 0;
>  }
>  
> +static inline struct nf_bridge_info *nf_bridge_alloc(struct sk_buff *skb)
> +{
> +	struct nf_bridge_info *nf_bridge;
> +
> +	nf_bridge = kzalloc(sizeof(struct nf_bridge_info), GFP_ATOMIC);
> +	if (nf_bridge == NULL)
> +		return NULL;
> +
> +	atomic_set(&nf_bridge->use, 1);
> +
> +	return nf_bridge;
> +}
> +
> +static inline struct nf_bridge_info *nf_bridge_unshare(struct sk_buff *skb)
> +{
> +	if (atomic_read(&skb->nf_bridge->use) > 1) {
> +		struct nf_bridge_info *clone = nf_bridge_alloc(skb);
> +
> +		if (clone) {
> +			memcpy(clone, skb->nf_bridge,
> +			       sizeof(struct nf_bridge_info));
> +			atomic_set(&clone->use, 1);
> +		}
> +		nf_bridge_put(skb->nf_bridge);

You haven't assign clone to the skb->nf_bridge. the other place still access the
original skb->nf_bridge and you already release the skb->nf_bridge here. ant the
cloned nf_bridge will never be freed.

I still think my patch has no problem. the nf_bridge_unshare means if one packet
wants to change the shared nfbridge, then allocate a new one for this packet.

