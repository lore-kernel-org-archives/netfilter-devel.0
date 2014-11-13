From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: bridge: unshare bridge info before change it
Date: Thu, 13 Nov 2014 15:13:17 +0100
Message-ID: <20141113141317.GA3470@salvia>
References: <1411976114-16812-1-git-send-email-gaofeng@cn.fujitsu.com>
 <54582195.20209@cn.fujitsu.com>
 <20141104190055.GA27683@salvia>
 <545984E6.5050801@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52020 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933066AbaKMOLV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Nov 2014 09:11:21 -0500
Content-Disposition: inline
In-Reply-To: <545984E6.5050801@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 05, 2014 at 10:01:10AM +0800, Gao feng wrote:
> On 11/05/2014 03:00 AM, Pablo Neira Ayuso wrote:
> > This doesn't apply cleanly. We modularized br_netfilter by the time
> > you sent this, see 54dc125. You'll have to rebase this patch.
> 
> Get.
> 
> > 
> > Moreover, could you develop what you're noticing a bit more? Thanks.
> > 
> 
> first we setup NFQUEUE rule on ipv4 PREROUTING chain.
> 
> when gso packet came in from bridge, br_nf_pre_routing will
> allocate nf_bridge_info for this gso packet. and call setup_pre_routing
> to setup nf_bridge_info.(such as nf_bridge->mask |= BRNF_NF_BRIDGE_PREROUTING)
> 
> then this packet goes to ipv4 prerouting chain, nfqnl_enqueue_packet
> will call skb_segment to segment this gso packet. in skb_segment, the new
> packets will copy gso packet's header(__copy_skb_header), so there will
> be many packets share the same nf_bridge_info.
> 
> When these segmented packets being reinjected into kernel, they will continue
> going through bridge netfilter, br_nf_pre_routing_finish will clean the
> BRNF_NF_BRIDGE_PREROUTING for the first packet, setup it for the secondary
> packet, clean it for the third packet...
> 
> if the dest of these packets is local machine, they will come into br_pass_frame_up.
> then go to ipv4 prerouting chain again through netif_receive_skb. so ip_sabotage_in
> will not stop half of these packet.

I see, so this is manifesting when the packet follows the bridge input path.
Please, include this in the patch description.

> I only met the BRNF_NF_BRIDGE_PREROUTING flag problem, the other flags of nf_bridge_info's
> mask may cause problem too.
> 
> One solution is allocate new bridge_info in nfqnl_enqueue_packet for segmented packet,
> but __copy_skb_header may be called in the scene I described above, So I decide to
> allocate new bridge_info before we change it.

I think the changes should be restricted to the br_netfilter scope.  I
don't come up with any smaller / better solution at this moment, so
please rebase and resubmit.

BTW, br_netfilter seems to be using this:

nf_bridge->mask ^= ...

to always unset a bit that was previously set? In that case, I would
rename the function to _unset instead of _change, and use &~, at quick
look the use of xor for this there seems sloppy to me.

Thanks for your patience.
