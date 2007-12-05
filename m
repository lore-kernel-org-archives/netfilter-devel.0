From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: nf_inet_address (was: NF [PATCH 2/4] xt_TEE)
Date: Wed, 5 Dec 2007 18:24:58 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712051822360.10753@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711252004220.9477@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0711252005460.9477@fbirervta.pbzchgretzou.qr>
 <474A749B.8000303@trash.net> <Pine.LNX.4.64.0711262105080.22369@fbirervta.pbzchgretzou.qr>
 <474B60E1.6060002@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40851 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751752AbXLERY7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Dec 2007 12:24:59 -0500
In-Reply-To: <474B60E1.6060002@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Nov 27 2007 01:12, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>>On Nov 26 2007 08:24, Patrick McHardy wrote:
>>   
>>>Jan Engelhardt wrote:
>>>>+struct xt_tee_target_info {
>>>>+	union {
>>>>+		/* Address of gateway */
>>>>+		u_int32_t gateway_v4;
>>>>+		u_int32_t gateway_v6[4];
>>>
>>> These should be __be32 or simply use in_addr/in6_addr. At some
>>> point it would be good to have a nf_inet_addr type (or something
>>> net/-wide) so we don't have to introduce more and more of these.
>>
>> In include/net/netfilter/nf_conntrack_tuple.h there is
>> nf_conntrack_address, which would be perfectly suited for the task.
>> But I am not sure if I can use that, since it would have to be
>> exported to userspacce (would probably need to move the union to
>> include/linux/netfilter/ too). Thoughts?
>
> And the name doesn't really match. I'd prefer to type for all of
> netfilter and then have conntrack use that one.
>
About nf_inet_addr; does any userspace program depend on 
nf_conntrack_address? If so, I would have to add some #defines to remain 
compat.
