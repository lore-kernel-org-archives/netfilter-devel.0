From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Fix ipt_REJECT problem with nf_bridge
Date: Thu, 12 Mar 2009 11:35:13 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903121133590.24554@fbirervta.pbzchgretzou.qr>
References: <9b2db90b0902260048j514b6ab0w63038bd11ab3f8f6@mail.gmail.com>  <9b2db90b0903092229l1a02e8abtaf3e94a3a5ed641e@mail.gmail.com>  <49B5FE06.1010204@snapgear.com>  <9b2db90b0903110229k14d0622flb7c4bfeecb02ca1a@mail.gmail.com>
 <9b2db90b0903110444w47a99705qe0f22c21cdd0263d@mail.gmail.com> <49B85FA6.9040601@snapgear.com> <alpine.LSU.2.00.0903120341520.31440@fbirervta.pbzchgretzou.qr> <49B8A5E3.7070909@snapgear.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Nir Tzachar <nir.tzachar@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47162 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753372AbZCLKfR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Mar 2009 06:35:17 -0400
In-Reply-To: <49B8A5E3.7070909@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-03-12 07:04, Philip Craig wrote:
>Jan Engelhardt wrote:
>> FYI: This is talking about "pure"-bridged traffic, i.e. traffic that will
>> go from one bridge port to another without touching the "routing decision"
>> box in [1]. In iptables terminology, that's
>> 
>> 	FORWARD -i br0 -o br0
>> 
>> style traffic. Since the RST packet REJECT creates goes through
>> OUTPUT, so I would assume no forwarding would take place, and the
>> ip_forward flag not be relevant. The BRNF_BRIDGED clause therefore
>> seems wrong because it will always be a non-local saddr.
>
>I can understand this better now based on your explanation :-)
>But I think this clause is okay.
>
>The addr_type == RTN_LOCAL path works for pure bridged traffic
>because ip_route_me_harder() avoids routing using saddr if
>saddr is foreign.
>
>We can't specify addr_type != RTN_LOCAL for the pure bridging case,
>because that tries to route the RST as though we received it
>from the network, which will fail if ip forwarding is disabled.
>
So what about the OP's observation that nskb->nf_bridge == NULL?
Just because the incoming packet came in over a bridge does
not mean the RST is going over one too, and that being the
deciding factor for RTN_LOCAL or not, is it?
