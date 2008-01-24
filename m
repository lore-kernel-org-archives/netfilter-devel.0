From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: xt_TCPMSS: Consider reverse route's MTU in clamp-to-pmtu
Date: Thu, 24 Jan 2008 08:53:45 +0100
Message-ID: <47984409.9020204@trash.net>
References: <Pine.LNX.4.64.0801232155020.12676@fbirervta.pbzchgretzou.qr> <4797BFE3.6090603@trash.net> <Pine.LNX.4.64.0801232341160.12676@fbirervta.pbzchgretzou.qr> <47980A57.2020702@uls.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jaco Kroon <jaco@uls.co.za>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35032 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYAXHyg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 02:54:36 -0500
In-Reply-To: <47980A57.2020702@uls.co.za>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jaco Kroon wrote:
> Jan Engelhardt wrote:
>> On Jan 23 2008 23:29, Patrick McHardy wrote:
>>   
>>>> +static u_int32_t tcpmss_reverse_mtu4(const struct iphdr *iph)
>>>> +{
>>>> +	struct flowi fl = {.nl_u = {.ip4_u = {
>>>> +		.daddr = iph->saddr,
>>>> +		.tos   = RT_TOS(iph->tos),
>>>>   
>>>>       
>>> This doesn't make much sense, we don't know the ToS value
>>> that will be used in the reverse direction.
>>>     
>> Usually it will be the same TOS with default setups.
>> Interactive SSH sessions for example set IPTOS_LOWDELAY,
>> on both sides.
>>   
> _Usually_.  I've seen cases (especially with VoIP) where TOS in one
> direction is 0x10 and then 0x68 in the other.  However, this is on top
> of udp, for which this patch has no effect.
>>   
>>> use routing rules based on source address, iif etc., so I
>>> think we should make this optional.
>>>     
>> iif yes; should be a matter of in->ifindex or so.
>>   
> I'd reckon that's a definite "yes, we should fill in iif and saddr"! 


saddr and iif don't work without more complicated changes since
we'd have to use input routing.

> This should cover 99.99% of cases where this is useful, and the only
> potentially problematic case I can envision is with asymmetric routing
> between the gateway this is running on and the final destination.  And
> chances are that even in those cases the oif of two different incoming
> routes are going to be the same.


The problem is that we can't determine all keys used in the
reverse direction, which becomes obvious if you think of
mark based routing. So I'm wondering how many setups this
would break. Leaving the routing as it is and making it
optional looks safer, with the downside that most users
probably want this and won't notice the new option.

