From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH] netfilter: bridge: unshare bridge info before change
 it
Date: Wed, 5 Nov 2014 10:01:10 +0800
Message-ID: <545984E6.5050801@cn.fujitsu.com>
References: <1411976114-16812-1-git-send-email-gaofeng@cn.fujitsu.com> <54582195.20209@cn.fujitsu.com> <20141104190055.GA27683@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:39597 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751506AbaKECBQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Nov 2014 21:01:16 -0500
In-Reply-To: <20141104190055.GA27683@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/05/2014 03:00 AM, Pablo Neira Ayuso wrote:
> On Tue, Nov 04, 2014 at 08:45:09AM +0800, Gao feng wrote:
>> On 09/29/2014 03:35 PM, Gao feng wrote:
>>> Many packets may share the same bridge information,
>>> we should unshare the bridge info before we change it,
>>> otherwise other packets will go to PF_INET(6)/PRE_ROUTING
>>> second time or the pkt_type of other packets will be
>>> incorrect.
>>>
>>> The problem occurs when we do nfqueue after br_nf_pre_routing
>>> and before bf_nf_pre_routing_finish, if the packet is gso,
>>> the new segs will share the same bridge info. and netfilter
>>> may use skb_clone, this will cause many packets share the
>>> same bridge info too.
>>>
>>> Signed-off-by: Gao feng <gaofeng@cn.fujitsu.com>
>>> ---
>>
>> any comments?
> 
> This doesn't apply cleanly. We modularized br_netfilter by the time
> you sent this, see 54dc125. You'll have to rebase this patch.

Get.

> 
> Moreover, could you develop what you're noticing a bit more? Thanks.
> 

first we setup NFQUEUE rule on ipv4 PREROUTING chain.

when gso packet came in from bridge, br_nf_pre_routing will
allocate nf_bridge_info for this gso packet. and call setup_pre_routing
to setup nf_bridge_info.(such as nf_bridge->mask |= BRNF_NF_BRIDGE_PREROUTING)

then this packet goes to ipv4 prerouting chain, nfqnl_enqueue_packet
will call skb_segment to segment this gso packet. in skb_segment, the new
packets will copy gso packet's header(__copy_skb_header), so there will
be many packets share the same nf_bridge_info.

When these segmented packets being reinjected into kernel, they will continue
going through bridge netfilter, br_nf_pre_routing_finish will clean the
BRNF_NF_BRIDGE_PREROUTING for the first packet, setup it for the secondary
packet, clean it for the third packet...

if the dest of these packets is local machine, they will come into br_pass_frame_up.
then go to ipv4 prerouting chain again through netif_receive_skb. so ip_sabotage_in
will not stop half of these packet.

I only met the BRNF_NF_BRIDGE_PREROUTING flag problem, the other flags of nf_bridge_info's
mask may cause problem too.

One solution is allocate new bridge_info in nfqnl_enqueue_packet for segmented packet,
but __copy_skb_header may be called in the scene I described above, So I decide to
allocate new bridge_info before we change it.
