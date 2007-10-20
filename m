From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Add xt_tos
Date: Sat, 20 Oct 2007 17:50:32 +0200
Message-ID: <471A23C8.4090501@trash.net>
References: <Pine.LNX.4.64.0710201344220.1997@fbirervta.pbzchgretzou.qr> <471A1DD6.6010103@trash.net> <Pine.LNX.4.64.0710201736260.1997@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34372 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755793AbXJTPvc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Oct 2007 11:51:32 -0400
In-Reply-To: <Pine.LNX.4.64.0710201736260.1997@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
> On Oct 20 2007 17:25, Patrick McHardy wrote:
>   
>> Jan Engelhardt wrote:
>>     
>>> Convert ipt_tos to xt_tos, adding support for IPv6.
>>>
>>> +MODULE_ALIAS("ipt_tos");
>>> +MODULE_ALIAS("ip6t_tos");
>>>       
>> Looks good, but I think this breaks bisection since you remove ipt_tos
>> in a later patch. I'll fold those together and queue it up for 2.6.25.
>> Thanks Jan.
>>
>>     
> Someone please test it :)
> I do not think it breaks compilation bisection.
>   

Not compilation, but after installation there will be two ipt_TOS modules
(well, one alias and one module). Better to do that in one step IMO.

