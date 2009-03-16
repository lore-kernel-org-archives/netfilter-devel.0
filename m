From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fix ipt_REJECT problem with nf_bridge
Date: Mon, 16 Mar 2009 16:11:16 +0100
Message-ID: <49BE6C14.9030802@trash.net>
References: <9b2db90b0902260048j514b6ab0w63038bd11ab3f8f6@mail.gmail.com>  <9b2db90b0903092229l1a02e8abtaf3e94a3a5ed641e@mail.gmail.com>  <49B5FE06.1010204@snapgear.com>  <9b2db90b0903110229k14d0622flb7c4bfeecb02ca1a@mail.gmail.com> <9b2db90b0903110444w47a99705qe0f22c21cdd0263d@mail.gmail.com> <49B85FA6.9040601@snapgear.com> <alpine.LSU.2.00.0903120341520.31440@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Philip Craig <philipc@snapgear.com>,
	Nir Tzachar <nir.tzachar@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47833 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752669AbZCPPLU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Mar 2009 11:11:20 -0400
In-Reply-To: <alpine.LSU.2.00.0903120341520.31440@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> If I read the comments in ip_route_me_harder correctly, RTN_LOCAL
> must not be used when ipt_REJECT generates the RST packet with a
> source address that does not belong to the firewall itself. In other
> words, if it is forwarded (hence the NF_INET_FORWARD check).

Correct.

> If hook is INPUT or OUTPUT, saddr will be ours anyway (except maybe
> in TPROXY setups, yayay, don't wanna think about that right now ;-)
> so RTN_LOCAL is ok.
> 
> Now look at (hook == NF_INET_FORWARD && BRNF_BRIDGED). For a plain
> packet to arrive in the FORWARD chain, daddr must not be local. So
> when the address tuple is reversed for the RST packet, saddr will not
> be a local address.
> 
> This is the commit that originally introduced the BRNF_BRIDGED clause:
> 
> commit dbf3813cdabe3c0336667bbf3347652cb897e365 (v2.6.5-rc3-27-gdbf3813)
> Author: Bart De Schuymer <bdschuym@pandora.be>
> Date:   Tue Mar 30 23:18:10 2004 -0800
> 
>     [NETFILTER]: Do not require ip_forwarding for reset on a bridge.
>     
>     Currently, to be able to send a reset in the FORWARD chain of iptables
>     for bridged traffic, ip forwarding must be enabled. This causes confusion
>     and in some situations people really don't want to enable ip forwarding.
>     The patch below lets the user send reset packets for bridged frames in
>     the FORWARD chain, with ip forwarding disabled (as long as there is a
>     route).
> 
> FYI: This is talking about "pure"-bridged traffic, i.e. traffic that will
> go from one bridge port to another without touching the "routing decision"
> box in [1]. In iptables terminology, that's
> 
> 	FORWARD -i br0 -o br0
> 
> style traffic. Since the RST packet REJECT creates goes through
> OUTPUT, so I would assume no forwarding would take place, and the
> ip_forward flag not be relevant. The BRNF_BRIDGED clause therefore
> seems wrong because it will always be a non-local saddr.

Packets with non-local saddrs are routed similar to forward packets
(meaning the use ip_route_input and set an input device for policy
routing). This is also where the forwarding check kicks in.

We should actually be able to avoid these hacks nowadays since
routing allows to override the "output must use local source"
check using FLOWI_FLAG_ANYSRC.
