Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F05DA13A244
	for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 21:43:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726695784; cv=none; b=jiOjvtQImbYLwblpSLZsVMbl8K3PCkTAS/PvHVi6qAe2Kn3KG1yMRQDbFLQ4pFtVYuvxUKkpm+HywmSyWMXUE2Tch6MX+4Yn406Jm3JsMdU1+BroEiRoz7B7LLuxIRyG7mv/96ZgJhtiOMS3lpxA/Ljmg8Q6BUQpqQCDZlz5Z4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726695784; c=relaxed/simple;
	bh=n8/GS2tBwunXmjHB/yrthyH20AFBrdxgJNhF1c1pDqk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FQCeTrDSmKXdupbQBWOO+MfWRPEPkbt6abC3da0OERoUeC4rJXt2/y9dU0lF8CS68VE/eZ7MxFIaCAnXs33J0cp0b1/lEGHCwuteM35GZIVzj7LCFoZchKgkAi22lGro3tvmv57dqw+xVLch4vMN675ZOC+Oyio13fBtNNgK9kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GEbpMFab; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GEbpMFab"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-39f49600297so766305ab.1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 14:43:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726695782; x=1727300582; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2sa2H3Goj04TCdJOFjHfQ5/nrX6khYJpZF4RpcBHBpA=;
        b=GEbpMFabgBIB1tMOJb3VQ2DI6CgrIhjC/lQQN74e5MhnjhUzDz9FrgLPIsVko5gBxd
         KRZZ0zUFJQfgBjOLPZUMQtqMkYeDqUwtCSOeSpt6T8iyMbX2kr7w5laQPrV1eoi7BTo6
         cQjyr2gAJ3kvwHnajCgFz7Rf5KSDhMbmt3BuTaTDT9nI3zI72hiKkp5wWpZk1BEBgtqn
         4UAQNTjrWm8uNYmIdw8T05xQVf0M4AsHbH5NZrTwc19ihgWfemSFe/w3qXLPeC/4LmF5
         9h2uvuiGAEEr6PiFZ03el2CZBw7Spr3vcd8b5hY16VrvQPY35clv4bm+YXLqb4B+Racb
         Bf6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726695782; x=1727300582;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2sa2H3Goj04TCdJOFjHfQ5/nrX6khYJpZF4RpcBHBpA=;
        b=JwJ+SzFwqmIvvPjJo+8qIg2iV0E2cBqrTzMGgxzLAou3of1QAE95t1rFC189tztW64
         jZKqE4/+pGbEuRWrBVL7fQRwJRF29fEYW6uV2odpqeuCgy/FtqT6M1Wbzif/KKa4zgqh
         LExYUkEWLcnHsZ5EMCVX8dGxHvq0vBKuvUF1xvBh4eUhs0+z9ZnwxMp9RpUe3863cCUc
         gQmh27Bky/fBsRlW/5hD2mnchhHNIJESrob/gj/Ql8ljFbocArfbMmZvxwKec4KlYfRy
         MFReyJOjjDey5XqkK+LiJzXM18fGosmtQfVtSlcRdONnQbrrePGgRduOODrQcCxQAOMd
         bxfg==
X-Gm-Message-State: AOJu0YyeksYAYu1BSaacC9ehabv9Nhc1Q9xV8hqKtghuMb87zVxw9hmY
	GeM+gm9iIjidzz4r40NfGPALkJU37wwmXPw0YXmEh2RdIbCpuzrYI5brCc0hJT7ZAgYf4qINWxb
	UEr/D4Bk9o6rCKxE2yPBvV47oMFowYpnzHK4=
X-Google-Smtp-Source: AGHT+IFRaq4cPaKg9P/GO9U0IKQfQpracDvUK2gqAy+7P2Cx+nd6htw0fwMzecY7Ymu4t9UsCHABSw2WEHgyim7Y43k=
X-Received: by 2002:a92:c26d:0:b0:3a0:9aff:5047 with SMTP id
 e9e14a558f8ab-3a09aff51e7mr117698255ab.22.1726695781819; Wed, 18 Sep 2024
 14:43:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240912185832.11962-1-pablo@netfilter.org> <CABhP=tY2ceRAiZd3UCN3LqU8ZSO1G1W236XW+2rC6QhpeA9dsw@mail.gmail.com>
 <CABhP=taUnE6nxQ1ZPradgk7iNt3M_LCcFoM251OhpEJsasCoSw@mail.gmail.com> <Zus9trdyfiTNk2NI@calendula>
In-Reply-To: <Zus9trdyfiTNk2NI@calendula>
From: Antonio Ojea <antonio.ojea.garcia@gmail.com>
Date: Wed, 18 Sep 2024 22:42:25 +0100
Message-ID: <CABhP=tbVrpr1MuYSubw4LKUNP=_PFap3CN9bc3M_mzo6yxeqpw@mail.gmail.com>
Subject: Re: [PATCH nf] netfilter: nfnetlink_queue: reroute reinjected packets
 from postrouting
To: Pablo Neira Ayuso <pablo@netfilter.org>
Cc: netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 18 Sept 2024 at 21:53, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Tue, Sep 17, 2024 at 11:01:31PM +0100, Antonio Ojea wrote:
> > On Fri, 13 Sept 2024 at 07:24, Antonio Ojea
> > <antonio.ojea.garcia@gmail.com> wrote:
> > >
> > > On Thu, 12 Sept 2024 at 20:58, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > >
> > > > 368982cd7d1b ("netfilter: nfnetlink_queue: resolve clash for unconfirmed
> > > > conntracks") adjusts NAT again in case that packet loses race to confirm
> > > > the conntrack entry.
> > > >
> > > > The reinject path triggers a route lookup again for the output hook, but
> > > > not for the postrouting hook where queue to userspace is also possible.
> > > >
> > > > Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > > > Reported-by: Antonio Ojea <antonio.ojea.garcia@gmail.com>
> > > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > > > ---
> > > > I tried but I am not managing to make a selftest that runs reliable.
> > > > I can reproduce it manually and validate that this works.
> > > >
> > > > ./nft_queue -d 1000 helps by introducing a delay of 1000ms in the
> > > > userspace queue processing which helps trigger the race more easily,
> > > > socat needs to send several packets in the same UDP flow.
> > > >
> > > > @Antonio: Could you try this patch meanwhile there is a testcase for
> > > > this.
> > >
> > > Let me test it and report back
> > >
> >
> > Ok, I finally managed to get this tested, and it does not seem to
> > solve the problem, it keeps dnating twice after the packet is enqueued
> > by nfqueue
>
> I really don't understand why my patch did not work.
>
> In this new test run you have use postrouting/filter chain, but it
> does not call nf_reroute as in the previous trace.
>
> Does program issues the NF_STOP verdict instead?
>

The program is the same and the environment the same, I just change
the kernel of the VM.
I have observed different drops reasons, see my original comment
https://bugzilla.netfilter.org/show_bug.cgi?id=1766#c0 has
SKB_DROP_REASON_IP_RPFILTER and SKB_DROP_REASON_NEIGH_FAILED, and in
this trace we have SKB_DROP_REASON_OTHERHOST ... , can it be possible
you fixed one scenario with your patch but not the others?

> [...]
> > 10.244.0.3:39492->10.244.0.2:53(udp) ip_output
> > 21:44:13.069 0xffff97ff83662280 0   <empty>:3552     2007044037796
> > 10.244.0.3:39492->10.244.0.2:53(udp) nf_hook_slow
> > 21:44:13.070 0xffff97ff83662280 0   <empty>:3552     2007044038241
> > 10.244.0.3:39492->10.244.0.2:53(udp) nft_do_chain_inet
> > 21:44:13.070 0xffff97ff83662280 0   <empty>:3552     2007044040343
> > 10.244.0.3:39492->10.244.0.2:53(udp) nf_queue
> > --- snipped other skbs ---
> > 21:44:13.149 0xffff97ff83662280 0   <empty>:1463     2007052515236
> > 10.244.0.3:39492->10.244.0.2:53(udp) nf_conntrack_update
> > 21:44:13.149 0xffff97ff83662280 0   <empty>:1463     2007052538616
> > 10.244.0.3:39492->10.244.0.2:53(udp) nf_nat_manip_pkt
> > 21:44:13.149 0xffff97ff83662280 0   <empty>:1463     2007052539511
> > 10.244.0.3:39492->10.244.0.2:53(udp) nf_nat_ipv4_manip_pkt
> > 21:44:13.150 0xffff97ff83662280 0   <empty>:1463     2007052540123
> > 10.244.0.3:39492->10.244.0.2:53(udp) skb_ensure_writable
> > 21:44:13.150 0xffff97ff83662280 0   <empty>:1463     2007052540589
> > 10.244.0.3:39492->10.244.0.2:53(udp) l4proto_manip_pkt
> > 21:44:13.150 0xffff97ff83662280 0   <empty>:1463     2007052540875
> > 10.244.0.3:39492->10.244.0.2:53(udp) skb_ensure_writable
> > 21:44:13.150 0xffff97ff83662280 0   <empty>:1463     2007052541326
> > 10.244.0.3:39492->10.244.0.2:53(udp) nf_csum_update
> > 21:44:13.151 0xffff97ff83662280 0   <empty>:1463     2007052541944
> > 10.244.0.3:39492->10.244.0.2:53(udp) inet_proto_csum_replace4
> > 21:44:13.151 0xffff97ff83662280 0   <empty>:1463     2007052542259
> > 10.244.0.3:39492->10.244.0.2:53(udp) inet_proto_csum_replace4  <<<<
> > DNATed twice
> > 21:44:13.151 0xffff97ff83662280 0   <empty>:1463     2007052543321
> > 10.244.0.3:39492->10.244.0.4:53(udp) ip_route_me_harder
> > 21:44:13.151 0xffff97ff83662280 0   <empty>:1463     2007052545374
> > 10.244.0.3:39492->10.244.0.4:53(udp) __xfrm_decode_session
> > 21:44:13.151 0xffff97ff83662280 0   <empty>:1463     2007052546324
> > 10.244.0.3:39492->10.244.0.4:53(udp) nf_nat_ipv4_out
> > 21:44:13.151 0xffff97ff83662280 0   <empty>:1463     2007052546676
> > 10.244.0.3:39492->10.244.0.4:53(udp) nf_nat_inet_fn
> > 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052547186
> > 10.244.0.3:39492->10.244.0.4:53(udp) selinux_ip_postroute
> > 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052547732
> > 10.244.0.3:39492->10.244.0.4:53(udp) selinux_ip_postroute_compat
> > 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052548217
> > 10.244.0.3:39492->10.244.0.4:53(udp) nf_confirm
> > 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052548744
> > 10.244.0.3:39492->10.244.0.4:53(udp) ip_finish_output
> > 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052549162
> > 10.244.0.3:39492->10.244.0.4:53(udp) __ip_finish_output
> > 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052549614
> > 10.244.0.3:39492->10.244.0.4:53(udp) ip_finish_output2
> > 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052550159
> > 10.244.0.3:39492->10.244.0.4:53(udp) __dev_queue_xmit
> > 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052550656
> > 10.244.0.3:39492->10.244.0.4:53(udp) netdev_core_pick_tx
> > 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052551436
> > 10.244.0.3:39492->10.244.0.4:53(udp) validate_xmit_skb
> > 21:44:13.152 0xffff97ff83662280 0   <empty>:1463     2007052551882
> > 10.244.0.3:39492->10.244.0.4:53(udp) netif_skb_features
> > 21:44:13.153 0xffff97ff83662280 0   <empty>:1463     2007052552291
> > 10.244.0.3:39492->10.244.0.4:53(udp) passthru_features_check
> > 21:44:13.153 0xffff97ff83662280 0   <empty>:1463     2007052552672
> > 10.244.0.3:39492->10.244.0.4:53(udp) skb_network_protocol
> > 21:44:13.153 0xffff97ff83662280 0   <empty>:1463     2007052553191
> > 10.244.0.3:39492->10.244.0.4:53(udp) skb_csum_hwoffload_help
> > 21:44:13.154 0xffff97ff83662280 0   <empty>:1463     2007052553566
> > 10.244.0.3:39492->10.244.0.4:53(udp) validate_xmit_xfrm
> > 21:44:13.155 0xffff97ff83662280 0   <empty>:1463     2007052554026
> > 10.244.0.3:39492->10.244.0.4:53(udp) dev_hard_start_xmit
> > 21:44:13.155 0xffff97ff83662280 0   <empty>:1463     2007052554482
> > 10.244.0.3:39492->10.244.0.4:53(udp) veth_xmit
> > 21:44:13.155 0xffff97ff83662280 0   <empty>:1463     2007052555156
> > 10.244.0.3:39492->10.244.0.4:53(udp) __dev_forward_skb
> > 21:44:13.155 0xffff97ff83662280 0   <empty>:1463     2007052555604
> > 10.244.0.3:39492->10.244.0.4:53(udp) __dev_forward_skb2
> > 21:44:13.155 0xffff97ff83662280 0   <empty>:1463     2007052556045
> > 10.244.0.3:39492->10.244.0.4:53(udp) skb_scrub_packet
> > 21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052556449
> > 10.244.0.3:39492->10.244.0.4:53(udp) eth_type_trans
> > 21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052557536
> > 10.244.0.3:39492->10.244.0.4:53(udp) __netif_rx
> > 21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052559424
> > 10.244.0.3:39492->10.244.0.4:53(udp) netif_rx_internal
> > 21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052559872
> > 10.244.0.3:39492->10.244.0.4:53(udp) enqueue_to_backlog
> > 21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052560827
> > 10.244.0.3:39492->10.244.0.4:53(udp) __netif_receive_skb_one_core
> > 21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052561410
> > 10.244.0.3:39492->10.244.0.4:53(udp) ip_rcv
> > 21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052561845
> > 10.244.0.3:39492->10.244.0.4:53(udp) ip_rcv_core
> > 21:44:13.156 0xffff97ff83662280 0   <empty>:1463     2007052564056
> > 10.244.0.3:39492->10.244.0.4:53(udp)
> > kfree_skb_reason(SKB_DROP_REASON_OTHERHOST)
