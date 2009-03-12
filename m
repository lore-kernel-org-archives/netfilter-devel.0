From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Fix ipt_REJECT problem with nf_bridge
Date: Thu, 12 Mar 2009 04:25:03 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903120341520.31440@fbirervta.pbzchgretzou.qr>
References: <9b2db90b0902260048j514b6ab0w63038bd11ab3f8f6@mail.gmail.com>  <9b2db90b0903092229l1a02e8abtaf3e94a3a5ed641e@mail.gmail.com>  <49B5FE06.1010204@snapgear.com>  <9b2db90b0903110229k14d0622flb7c4bfeecb02ca1a@mail.gmail.com>
 <9b2db90b0903110444w47a99705qe0f22c21cdd0263d@mail.gmail.com> <49B85FA6.9040601@snapgear.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Nir Tzachar <nir.tzachar@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35896 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbZCLDZH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Mar 2009 23:25:07 -0400
In-Reply-To: <49B85FA6.9040601@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-03-12 02:04, Philip Craig wrote:
>Nir Tzachar wrote:

>>       if (hook != NF_INET_FORWARD
>>#ifdef CONFIG_BRIDGE_NETFILTER
>>            || (nskb->nf_bridge && nskb->nf_bridge->mask & BRNF_BRIDGED)
>>#endif
>>           )
>>                addr_type = RTN_LOCAL;
>>
>>but, as nskb was newly allocated just a few line back, the
>>oldskb->nf_bridge was never copied, so nskb->nf_bridge is always NULL.
>>The following patch corrects the problem. Please review and apply.
>>
>>I have checked the change you proposed (checking oldskb instead of
>>nskb) , and indeed it works. Should I resubmit a patch for it?
>
>Yes please, but it will need someone that knows more about
>routing internals than me to review it still.

Ok, let me step in then.

(Terminology. Plain packet: whatever triggers RST. RST packet: what
REJECT will send)

If I read the comments in ip_route_me_harder correctly, RTN_LOCAL
must not be used when ipt_REJECT generates the RST packet with a
source address that does not belong to the firewall itself. In other
words, if it is forwarded (hence the NF_INET_FORWARD check).

If hook is INPUT or OUTPUT, saddr will be ours anyway (except maybe
in TPROXY setups, yayay, don't wanna think about that right now ;-)
so RTN_LOCAL is ok.

Now look at (hook == NF_INET_FORWARD && BRNF_BRIDGED). For a plain
packet to arrive in the FORWARD chain, daddr must not be local. So
when the address tuple is reversed for the RST packet, saddr will not
be a local address.

This is the commit that originally introduced the BRNF_BRIDGED clause:

commit dbf3813cdabe3c0336667bbf3347652cb897e365 (v2.6.5-rc3-27-gdbf3813)
Author: Bart De Schuymer <bdschuym@pandora.be>
Date:   Tue Mar 30 23:18:10 2004 -0800

    [NETFILTER]: Do not require ip_forwarding for reset on a bridge.
    
    Currently, to be able to send a reset in the FORWARD chain of iptables
    for bridged traffic, ip forwarding must be enabled. This causes confusion
    and in some situations people really don't want to enable ip forwarding.
    The patch below lets the user send reset packets for bridged frames in
    the FORWARD chain, with ip forwarding disabled (as long as there is a
    route).

FYI: This is talking about "pure"-bridged traffic, i.e. traffic that will
go from one bridge port to another without touching the "routing decision"
box in [1]. In iptables terminology, that's

	FORWARD -i br0 -o br0

style traffic. Since the RST packet REJECT creates goes through
OUTPUT, so I would assume no forwarding would take place, and the
ip_forward flag not be relevant. The BRNF_BRIDGED clause therefore
seems wrong because it will always be a non-local saddr.

[1] http://jengelh.medozas.de/images/nf-packet-flow.png
