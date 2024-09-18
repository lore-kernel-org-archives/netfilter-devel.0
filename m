Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [213.95.27.120])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1206FC5
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 20:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.27.120
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726692801; cv=none; b=UD4q+SrIckGmrfsryl4Tsc13GI9JG6+acy3iuScWXSCwCEzuX9w0hf4F024ulLJEW2kdO+htomdW6h9iAChWmcnNrNcI/yw08EY6uyPvM5jxxN+HA2+dBlcbZssu6VHnhE7TcRQXY3NizscGOVT92W0Aicg8/3Qh3fFzJnM9e80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726692801; c=relaxed/simple;
	bh=UF78Z/BrTCLTViVEdUXXMmgF/EjGy7NM7jRW/mtpTJY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jXh6ltiQo+4NlU0z9iJfrQKGz3N0RWr2FrJw3aAgoncR2HKLkd8tOS8sdoJX81rFWz2OLG1LRf+Ej/9oyoPi1cX7BxQBkmzi2rYT5/uWUE6OYJ+ueZ19PjzBsJD1BPeYSoLfjS6pPOPab35NCSvZEkrM/YskjHw8ss1NJsHQ/5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=gnumonks.org; arc=none smtp.client-ip=213.95.27.120
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gnumonks.org
Received: from [78.30.37.63] (port=39460 helo=gnumonks.org)
	by ganesha.gnumonks.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <pablo@gnumonks.org>)
	id 1sr1fj-001uJg-W6; Wed, 18 Sep 2024 22:53:14 +0200
Date: Wed, 18 Sep 2024 22:53:10 +0200
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Cc: netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: reroute reinjected
 packets from postrouting
Message-ID: <Zus9trdyfiTNk2NI@calendula>
References: <20240912185832.11962-1-pablo@netfilter.org>
 <CABhP=tY2ceRAiZd3UCN3LqU8ZSO1G1W236XW+2rC6QhpeA9dsw@mail.gmail.com>
 <CABhP=taUnE6nxQ1ZPradgk7iNt3M_LCcFoM251OhpEJsasCoSw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABhP=taUnE6nxQ1ZPradgk7iNt3M_LCcFoM251OhpEJsasCoSw@mail.gmail.com>
X-Spam-Score: -1.8 (-)

On Tue, Sep 17, 2024 at 11:01:31PM +0100, Antonio Ojea wrote:
> On Fri, 13 Sept 2024 at 07:24, Antonio Ojea
> <antonio.ojea.garcia@gmail.com> wrote:
> >
> > On Thu, 12 Sept 2024 at 20:58, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >
> > > 368982cd7d1b ("netfilter: nfnetlink_queue: resolve clash for unconfirmed
> > > conntracks") adjusts NAT again in case that packet loses race to confirm
> > > the conntrack entry.
> > >
> > > The reinject path triggers a route lookup again for the output hook, but
> > > not for the postrouting hook where queue to userspace is also possible.
> > >
> > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > Reported-by: Antonio Ojea <antonio.ojea.garcia@gmail.com>
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > ---
> > > I tried but I am not managing to make a selftest that runs reliable.
> > > I can reproduce it manually and validate that this works.
> > >
> > > ./nft_queue -d 1000 helps by introducing a delay of 1000ms in the
> > > userspace queue processing which helps trigger the race more easily,
> > > socat needs to send several packets in the same UDP flow.
> > >
> > > @Antonio: Could you try this patch meanwhile there is a testcase for
> > > this.
> >
> > Let me test it and report back
> >
> 
> Ok, I finally managed to get this tested, and it does not seem to
> solve the problem, it keeps dnating twice after the packet is enqueued
> by nfqueue

I really don't understand why my patch did not work.

In this new test run you have use postrouting/filter chain, but it
does not call nf_reroute as in the previous trace.

Does program issues the NF_STOP verdict instead?

[...]
> 10.244.0.3:39492->10.244.0.2:53(udp) ip_output
> 21:44:13.069 0xffff97ff83662280 0   <empty>:3552     2007044037796
> 10.244.0.3:39492->10.244.0.2:53(udp) nf_hook_slow
> 21:44:13.070 0xffff97ff83662280 0   <empty>:3552     2007044038241
> 10.244.0.3:39492->10.244.0.2:53(udp) nft_do_chain_inet
> 21:44:13.070 0xffff97ff83662280 0   <empty>:3552     2007044040343
> 10.244.0.3:39492->10.244.0.2:53(udp) nf_queue
> --- snipped other skbs ---
> 21:44:13.149 0xffff97ff83662280 0   <empty>:1463     2007052515236
> 10.244.0.3:39492->10.244.0.2:53(udp) nf_conntrack_update
> 21:44:13.149 0xffff97ff83662280 0   <empty>:1463     2007052538616
> 10.244.0.3:39492->10.244.0.2:53(udp) nf_nat_manip_pkt
> 21:44:13.149 0xffff97ff83662280 0   <empty>:1463     2007052539511
> 10.244.0.3:39492->10.244.0.2:53(udp) nf_nat_ipv4_manip_pkt
> 21:44:13.150 0xffff97ff83662280 0   <empty>:1463     2007052540123
> 10.244.0.3:39492->10.244.0.2:53(udp) skb_ensure_writable
> 21:44:13.150 0xffff97ff83662280 0   <empty>:1463     2007052540589
> 10.244.0.3:39492->10.244.0.2:53(udp) l4proto_manip_pkt
> 21:44:13.150 0xffff97ff83662280 0   <empty>:1463     2007052540875
> 10.244.0.3:39492->10.244.0.2:53(udp) skb_ensure_writable
> 21:44:13.150 0xffff97ff83662280 0   <empty>:1463     2007052541326
> 10.244.0.3:39492->10.244.0.2:53(udp) nf_csum_update
> 21:44:13.151 0xffff97ff83662280 0   <empty>:1463     2007052541944
> 10.244.0.3:39492->10.244.0.2:53(udp) inet_proto_csum_replace4
> 21:44:13.151 0xffff97ff83662280 0   <empty>:1463     2007052542259
> 10.244.0.3:39492->10.244.0.2:53(udp) inet_proto_csum_replace4  <<<<
> DNATed twice
> 21:44:13.151 0xffff97ff83662280 0   <empty>:1463     2007052543321
> 10.244.0.3:39492->10.244.0.4:53(udp) ip_route_me_harder
> 21:44:13.151 0xffff97ff83662280 0   <empty>:1463     2007052545374
> 10.244.0.3:39492->10.244.0.4:53(udp) __xfrm_decode_session
> 21:44:13.151 0xffff97ff83662280 0   <empty>:1463     2007052546324
> 10.244.0.3:39492->10.244.0.4:53(udp) nf_nat_ipv4_out
> 21:44:13.151 0xffff97ff83662280 0   <empty>:1463     2007052546676
> 10.244.0.3:39492->10.244.0.4:53(udp) nf_nat_inet_fn
> 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052547186
> 10.244.0.3:39492->10.244.0.4:53(udp) selinux_ip_postroute
> 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052547732
> 10.244.0.3:39492->10.244.0.4:53(udp) selinux_ip_postroute_compat
> 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052548217
> 10.244.0.3:39492->10.244.0.4:53(udp) nf_confirm
> 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052548744
> 10.244.0.3:39492->10.244.0.4:53(udp) ip_finish_output
> 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052549162
> 10.244.0.3:39492->10.244.0.4:53(udp) __ip_finish_output
> 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052549614
> 10.244.0.3:39492->10.244.0.4:53(udp) ip_finish_output2
> 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052550159
> 10.244.0.3:39492->10.244.0.4:53(udp) __dev_queue_xmit
> 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052550656
> 10.244.0.3:39492->10.244.0.4:53(udp) netdev_core_pick_tx
> 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052551436
> 10.244.0.3:39492->10.244.0.4:53(udp) validate_xmit_skb
> 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052551882
> 10.244.0.3:39492->10.244.0.4:53(udp) netif_skb_features
> 21:44:13.153 0xffff97ff83662280 0   <empty>:1463     2007052552291
> 10.244.0.3:39492->10.244.0.4:53(udp) passthru_features_check
> 21:44:13.153 0xffff97ff83662280 0   <empty>:1463     2007052552672
> 10.244.0.3:39492->10.244.0.4:53(udp) skb_network_protocol
> 21:44:13.153 0xffff97ff83662280 0   <empty>:1463     2007052553191
> 10.244.0.3:39492->10.244.0.4:53(udp) skb_csum_hwoffload_help
> 21:44:13.154 0xffff97ff83662280 0   <empty>:1463     2007052553566
> 10.244.0.3:39492->10.244.0.4:53(udp) validate_xmit_xfrm
> 21:44:13.155 0xffff97ff83662280 0   <empty>:1463     2007052554026
> 10.244.0.3:39492->10.244.0.4:53(udp) dev_hard_start_xmit
> 21:44:13.155 0xffff97ff83662280 0   <empty>:1463     2007052554482
> 10.244.0.3:39492->10.244.0.4:53(udp) veth_xmit
> 21:44:13.155 0xffff97ff83662280 0   <empty>:1463     2007052555156
> 10.244.0.3:39492->10.244.0.4:53(udp) __dev_forward_skb
> 21:44:13.155 0xffff97ff83662280 0   <empty>:1463     2007052555604
> 10.244.0.3:39492->10.244.0.4:53(udp) __dev_forward_skb2
> 21:44:13.155 0xffff97ff83662280 0   <empty>:1463     2007052556045
> 10.244.0.3:39492->10.244.0.4:53(udp) skb_scrub_packet
> 21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052556449
> 10.244.0.3:39492->10.244.0.4:53(udp) eth_type_trans
> 21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052557536
> 10.244.0.3:39492->10.244.0.4:53(udp) __netif_rx
> 21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052559424
> 10.244.0.3:39492->10.244.0.4:53(udp) netif_rx_internal
> 21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052559872
> 10.244.0.3:39492->10.244.0.4:53(udp) enqueue_to_backlog
> 21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052560827
> 10.244.0.3:39492->10.244.0.4:53(udp) __netif_receive_skb_one_core
> 21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052561410
> 10.244.0.3:39492->10.244.0.4:53(udp) ip_rcv
> 21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052561845
> 10.244.0.3:39492->10.244.0.4:53(udp) ip_rcv_core
> 21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052564056
> 10.244.0.3:39492->10.244.0.4:53(udp)
> kfree_skb_reason(SKB_DROP_REASON_OTHERHOST)
