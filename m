From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [NETFILTER]: xt_TCPMSS: Consider reverse route's MTU in
 clamp-to-pmtu
Date: Wed, 23 Jan 2008 23:43:42 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801232341160.12676@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801232155020.12676@fbirervta.pbzchgretzou.qr>
 <4797BFE3.6090603@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, jaco@uls.co.za
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:50743 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752313AbYAWWnn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 17:43:43 -0500
In-Reply-To: <4797BFE3.6090603@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Jan 23 2008 23:29, Patrick McHardy wrote:
>> +static u_int32_t tcpmss_reverse_mtu4(const struct iphdr *iph)
>> +{
>> +	struct flowi fl = {.nl_u = {.ip4_u = {
>> +		.daddr = iph->saddr,
>> +		.tos   = RT_TOS(iph->tos),
>>   
>
> This doesn't make much sense, we don't know the ToS value
> that will be used in the reverse direction.

Usually it will be the same TOS with default setups.
Interactive SSH sessions for example set IPTOS_LOWDELAY,
on both sides.

> use routing rules based on source address, iif etc., so I
> think we should make this optional.

iif yes; should be a matter of in->ifindex or so.


thanks,
Jan

