From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] nf_nat_packet: Clear skb hash after modifying packet
 headers.
Date: Sat, 30 Apr 2016 09:57:43 +0200
Message-ID: <20160430075743.GA26902@breakpoint.cc>
References: <1461187870-54322-1-git-send-email-jarno@ovn.org>
 <20160429090959.GA7236@salvia>
 <20160429091212.GL17538@breakpoint.cc>
 <BF2D351F-29C4-49BA-9C97-231BB513DD23@ovn.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	dev@openvswitch.org
To: Jarno Rajahalme <jarno@ovn.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:44447 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751954AbcD3H5t (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Apr 2016 03:57:49 -0400
Content-Disposition: inline
In-Reply-To: <BF2D351F-29C4-49BA-9C97-231BB513DD23@ovn.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jarno Rajahalme <jarno@ovn.org> wrote:
> In the OVS datapath we clear the skb hash whenever we change any of the fields that may be used to compute it. This guarantees that any given flow will get the same hash value when assigning packets to bond interfaces based on the skb hash. If the hash is not cleared, some packets may use the pre-nat hash provided by a nic, for example, while others may not have the nic provided hash and compute a new one post-nat. Also, if DNAT is used for load balancing, the hash should be computed after the NAT for the difference in the destination address to make a difference in the hash value.
> 
> We could also clear the hash in the OVS datapath code after calling into nf nat, but could that still have the same issue with affecting the nf_tables tracing (of which I know nothing about)?

No, that would not affect nft.

Note that we could also remove the skb_get_hash() usage in nf trace (we
want to compute a pseudo-id that doesn't change while skb travels the
netfilter hooks).

For now I'd prefer if the hash reset would happen in OVS.
