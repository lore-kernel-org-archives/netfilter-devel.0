Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C24534F486;
	Tue, 17 Mar 2026 11:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773747563; cv=none; b=gtxRJRnH/0lpyI0fk3CZJhEJzgEfoHUrJbpeSdOnLGRuoc0RQOrataff7Fd7d0fktZtLHVQxVcpNy11ru8kR5PqiFhdunYf2DsjWk1g/bFzDxZE9t8TDQaBP9g1r+3pquQgWIHOlqN9F9a11p9hBVbn6PIsQIZNqFtTI8QUAVUM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773747563; c=relaxed/simple;
	bh=kdQ+1+afZ0cU27XQrMbqyykm1KyvnmBwhXqTYx7wVyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YOptF6cPxvUsDaqGTY616P8duOty2OE0G9swzcpzMHuoKntEZ+wUyb3VHuUBByuEHBh/pibfViehRWcEHlxT+rHfJrZmOwNWAbA709gHbvjOfXbm2727jLIrIHCciyzQFK0AfdTdLoF2AiNKsu6EGmUjTg82Wi45939dI2xS1Ys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=X3VWJmPc; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="X3VWJmPc"
Received: from netfilter.org (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with UTF8SMTPSA id 5E2C560275;
	Tue, 17 Mar 2026 12:39:20 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1773747560;
	bh=P33V43oP3dkCUdsRMCD8YrJZ9UrUUPnTwpPVsaX6Q9U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X3VWJmPc3wHHLmTk7yNGFmtyTNGuIZoIdvaMlyfbKfjthmfm+ND6C63mEIPFS4VJa
	 o2hHxkWo0hWSDfjlelLylNrjpmGfILY7FlfcEImF1cmRzRtWI66Zs/8DUXxgl54XrD
	 bmg20HqxJbOwuBWQXXmGZVzHB+Ufe1B0s0vpxtZuwayc6sbpLEZidRVVLqZhrpSs3a
	 bab6ThnxoQd5xckRS32kUp09SDjEyr/oN2BH35NvVHPK0lTbrYeex8FSA7/WfJl+2n
	 ADdK3j3XJQEaes2kT38+bCwv9mC73UVwODFkuZVwcrLqOEMeSseWC0AHN0Gtm5d7Sb
	 5ZP7nonEKc8Gg==
Date: Tue, 17 Mar 2026 12:39:17 +0100
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Cc: davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
	pabeni@redhat.com, edumazet@google.com, fw@strlen.de,
	horms@kernel.org, steffen.klassert@secunet.com,
	antony.antony@secunet.com
Subject: Re: [PATCH net-next,RFC 0/8] netfilter: flowtable bulking
Message-ID: <abk9ZQoc7GxfgODn@chamomile>
References: <20260317112917.4170466-1-pablo@netfilter.org>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260317112917.4170466-1-pablo@netfilter.org>

Missing links:

[1] https://lore.kernel.org/netdev/20180614141947.3580-1-pablo@netfilter.org/
[2] https://linux-ipsec.org/2025-linux-kernel-flowtable-bulk-forwarding-and-xfrm-pcpu-forwarding-testing-results.html

On Tue, Mar 17, 2026 at 12:29:09PM +0100, Pablo Neira Ayuso wrote:
> Hi,
>  
> Back in 2018 [1], a new fast forwarding combining the flowtable and
> GRO/GSO was proposed, however, "GRO is specialized to optimize the
> non-forwarding case", so it was considered "counter-intuitive to base a
> fast forwarding path on top of it".
>  
> Then, Steffen Klassert proposed the idea of adding a new engine for the
> flowtable that operates on the skb list that is provided after the NAPI
> cycle. The idea is to process this skb list to create bulks grouped by
> the ethertype, output device, next hop and tos/dscp. Then, add a
> specialized xmit path that can deal with these skb bulks. Note that GRO
> needs to be disabled so this new forwarding engine obtains the list of
> skbs that resulted from the NAPI cycle.
>  
> Before grouping skbs in bulks, there is a flowtable lookup to check if
> this flow is already in the flowtable, otherwise, the packet follows
> slow path. In case the flowtable lookup returns an entry, then this
> packet follows fast path: the ttl is decremented, the corresponding NAT
> mangling on the packet and layer 2/3 tunnel encapsulation (layer 2:
> vlan/pppoe, layer 3: ipip) are performed.
>  
> The fast forwarding path is enabled through explicit user policy, so the
> user needs to request this behaviour from control plane, the following
> example shows how to place flows in the new fast forwarding path from
> the forward chain:
> 
>  table x {
>         flowtable f {
>                 hook early_ingress priority 0; devices = { eth0, eth1 }
>         }
>  
>         chain y {
>                 type filter hook forward priority 0;
>                 ip protocol tcp flow offload @f counter
>         }
>  }
>  
>  
> The example above sets up a fastpath for TCP flows that are placed in
> the flowtable 'f', this flowtable is hooked at the new early_ingress
> hook.  The initial TCP packets that match this rule from the standard
> fowarding path create an entry in the flowtable.
>  
> Note that tcpdump only shows the packets in the tx path, since this
> new early_ingress hook happens before the ingress tap.
> 
> The patch series contains 8 patches:
> 
> - #1 and #2 adds the basic RX flowtable bulking infrastructure for
>   IPv4 and IPv6.
> - #3 adds the early_ingress netfilter hook.
> - #4 adds a helper function to prepare for the netfilter chain for
>   the early_ingress hook.
> - #5 adds the early_ingress filter chain.
> - #6 and #7 add helper functions to reuse TX path codebase.
> - #8 adds the custom TX path for listified skbs and updates
>   the flowtable bulking to use it.
> 
> = Benchmark numbers =
> 
> Using the following testbed with 4 hosts with this topology:
>  
>  | sunset |-----| west |====| east |----| sunrise |
>  
> And this hardware:
>  
> * Supermicro H13SSW Motherboard
> * AMD EPYC 9135 16-Core Processor (a.k.a. Bergamo, or Zen 5)
> * NIC: Mellanox MT28800 ConnectX-5 Ex (100Gbps NIc)
> * NIC: Broadcom BCM57508 NetXtreme-E (only on sunrise, 100Gbps NIc)
>  
> With 128 byte packets:
>  
> * From ~2 Mpps (baseline) to ~4 Mpps with 1 flow.
> * From ~10.6 Mpps (baseline) to ~15.7 Mpps with 10 flows.
>  
> Antony Antony collected performance numbers and made a report describing
> this the benchmarking[2]. This report includes numbers from the IPsec
> support which is not included in this series.
>
> Comments welcome, thanks.
> 
> Pablo Neira Ayuso (8):
>   netfilter: flowtable: Add basic bulking infrastructure for early ingress hook
>   netfilter: flowtable: Add IPv6 bulking infrastructure for early ingress hook
>   netfilter: nf_tables: add flowtable early_ingress support
>   netfilter: nf_tables: add nft_set_pktinfo_ingress()
>   netfilter: nf_tables: add early ingress chain
>   net: add dev_dst_drop() helper function
>   net: add dev_noqueue_xmit_list() helper function
>   net: add dev_queue_xmit_list() and use it
> 
>  include/linux/netdevice.h             |   2 +
>  include/net/netfilter/nf_flow_table.h |  13 +-
>  net/core/dev.c                        | 297 ++++++++++++++++----
>  net/netfilter/nf_flow_table_inet.c    |  81 ++++++
>  net/netfilter/nf_flow_table_ip.c      | 384 ++++++++++++++++++++++++++
>  net/netfilter/nf_tables_api.c         |  12 +-
>  net/netfilter/nft_chain_filter.c      | 164 +++++++++--
>  7 files changed, 872 insertions(+), 81 deletions(-)
> 
> -- 
> 2.47.3
> 
> 
