From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH net] netfilter: bridge: Don't sabotage nf_hook calls from
 an l3mdev
Date: Thu, 20 Sep 2018 18:25:28 +0200
Message-ID: <20180920162528.trzf65jjwxehgqz6@salvia>
References: <20180917152036.30674-1-dsahern@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        ndsouza@ciena.com, idosch@mellanox.com, fw@strlen.de,
        David Ahern <dsahern@gmail.com>
To: dsahern@kernel.org
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180917152036.30674-1-dsahern@kernel.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Sep 17, 2018 at 08:20:36AM -0700, dsahern@kernel.org wrote:
> From: David Ahern <dsahern@gmail.com>
> 
> For starters, the bridge netfilter code registers operations that
> are invoked any time nh_hook is called. Specifically, ip_sabotage_in
> watches for nested calls for NF_INET_PRE_ROUTING when a bridge is in
> the stack.
> 
> Packet wise, the bridge netfilter hook runs first. br_nf_pre_routing
> allocates nf_bridge, sets in_prerouting to 1 and calls NF_HOOK for
> NF_INET_PRE_ROUTING. It's finish function, br_nf_pre_routing_finish,
> then resets in_prerouting flag to 0 and the packet continues up the
> stack. The packet eventually makes it to the VRF driver and it invokes
> nf_hook for NF_INET_PRE_ROUTING in case any rules have been added against
> the vrf device.
> 
> Because of the registered operations the call to nf_hook causes
> ip_sabotage_in to be invoked. That function sees the nf_bridge on the
> skb and that in_prerouting is not set. Thinking it is an invalid nested
> call it steals (drops) the packet.
> 
> Update ip_sabotage_in to recognize that the bridge or one of its upper
> devices (e.g., vlan) can be enslaved to a VRF (L3 master device) and
> allow the packet to go through the nf_hook a second time.

Applied.
