From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libxtables: Introduce xtables_afinfo
Date: Mon, 09 Feb 2009 16:39:16 +0100
Message-ID: <49904E24.9090104@trash.net>
References: <1234026339.4441.24.camel@dogo.mojatatu.com>	 <alpine.LSU.2.00.0902071957040.12855@fbirervta.pbzchgretzou.qr> <1234035818.4441.36.camel@dogo.mojatatu.com> <4990411F.5060509@trash.net> <49904E0F.4090406@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: hadi@cyberus.ca, Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:57583 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520AbZBIPjT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 10:39:19 -0500
In-Reply-To: <49904E0F.4090406@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> jamal wrote:
>>> On Sat, 2009-02-07 at 20:05 +0100, Jan Engelhardt wrote:
>>>> ess.
>>>>
>>>> This afinfo thing has been a red LED beam in my eye. I just do not 
>>>> think
>>>> iproute2-m_ipt should have to deal with afinfo at all.
>>>> ..
>>>> So I now also dealt with that and moved it according to what I think 
>>>> is right - see latest git commit in mine; [77f48c2]
>>>
>>> Ok, tried that looks good. I prefer the approach you have. So
>>> discard the patch i posted.
>>
>> I'm a bit unsynced right now because I lost a harddisk and couldn't
>> follow emails. Could you resend the agreed-upon patches that you
>> want me to apply please?
> 
> Jan has sent them to netfilter-users instead of netfilter-devel by 
> mistake there this morning. Look there.

The reason why I'm asking is that I have a huge amount of mails
to catch up with and want to avoid reading through long threads
just to find out that the patch has been withdrawn at the end.

So I prefer a resubmission in any case.
