From: Jaco Kroon <jaco@uls.co.za>
Subject: Re: [NETFILTER]: xt_TCPMSS: Consider reverse route's MTU in clamp-to-pmtu
Date: Thu, 24 Jan 2008 05:47:35 +0200
Message-ID: <47980A57.2020702@uls.co.za>
References: <Pine.LNX.4.64.0801232155020.12676@fbirervta.pbzchgretzou.qr> <4797BFE3.6090603@trash.net> <Pine.LNX.4.64.0801232341160.12676@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp02.isdsl.net ([196.26.208.200]:51613 "EHLO smtp02.isdsl.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752850AbYAXEKg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 23:10:36 -0500
In-Reply-To: <Pine.LNX.4.64.0801232341160.12676@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 23 2008 23:29, Patrick McHardy wrote:
>   
>>> +static u_int32_t tcpmss_reverse_mtu4(const struct iphdr *iph)
>>> +{
>>> +	struct flowi fl = {.nl_u = {.ip4_u = {
>>> +		.daddr = iph->saddr,
>>> +		.tos   = RT_TOS(iph->tos),
>>>   
>>>       
>> This doesn't make much sense, we don't know the ToS value
>> that will be used in the reverse direction.
>>     
>
> Usually it will be the same TOS with default setups.
> Interactive SSH sessions for example set IPTOS_LOWDELAY,
> on both sides.
>   
_Usually_.  I've seen cases (especially with VoIP) where TOS in one
direction is 0x10 and then 0x68 in the other.  However, this is on top
of udp, for which this patch has no effect.
>   
>> use routing rules based on source address, iif etc., so I
>> think we should make this optional.
>>     
>
> iif yes; should be a matter of in->ifindex or so.
>   
I'd reckon that's a definite "yes, we should fill in iif and saddr"! 
This should cover 99.99% of cases where this is useful, and the only
potentially problematic case I can envision is with asymmetric routing
between the gateway this is running on and the final destination.  And
chances are that even in those cases the oif of two different incoming
routes are going to be the same.

In asymmetric routing you'd probably be using --set anyway though.  Is
there perhaps a custom clamp value available, eg --clamp-to-mtu 1200? 
This could be useful for those cases, as well as what we know as
"business dsl" configurations where the setup looks something like:

[ inet ]-----dsl----[bdsl-router]--ether--[LAN-gateway]

In these cases the bdsl router is often closed off to the local
administrator and run by the ISP, and I for one have been having fights
with at least one of these providers who just can't get the MSS field
clamped correctly.  So far the only way for me to get that right was to
drop my mtu on the router side to that of the lowest mtu value that I
can find with snmp on the router.  Often as low as, or close to, 1200.

Regards,
Jaco
