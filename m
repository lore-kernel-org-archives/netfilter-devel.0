From: Patrick McHardy <kaber@trash.net>
Subject: Re: netfilter: xtables: Combine ipt_TTL and ip6t_HL source
Date: Mon, 26 Jan 2009 14:23:12 +0100
Message-ID: <497DB940.3030007@trash.net>
References: <38bcb3ec0901201437t6ba198c8w83ecea8e3e6d4cde@mail.gmail.com> <alpine.LSU.2.00.0901210747500.14993@fbirervta.pbzchgretzou.qr> <4976D7E3.7040603@trash.net> <20090121.122022.108101243.davem@davemloft.net> <4978247D.4060006@trash.net> <alpine.LSU.2.00.0901222050210.7246@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, t.james.king@gmail.com,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43722 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751190AbZAZNXO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Jan 2009 08:23:14 -0500
In-Reply-To: <alpine.LSU.2.00.0901222050210.7246@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Thursday 2009-01-22 08:47, Patrick McHardy wrote:
>> David Miller wrote:
>>> From: Patrick McHardy <kaber@trash.net>
>>> Date: Wed, 21 Jan 2009 09:08:03 +0100
>>>
>>>> Please resubmit once Dave starts accepting patches into net-next.git.
>>> I'll probably publish my net-next-2.6 tree later today.
>> I forgot to add: and once the netfilter regressions have been fixed :)
>>
> Are the still any open?

I'm still waiting for a fix for the NFPROTO_UNSPEC proc regression.
Or did I miss something?

