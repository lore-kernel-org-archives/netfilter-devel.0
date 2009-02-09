From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libxtables: Introduce xtables_afinfo
Date: Mon, 09 Feb 2009 16:38:55 +0100
Message-ID: <49904E0F.4090406@netfilter.org>
References: <1234026339.4441.24.camel@dogo.mojatatu.com>	 <alpine.LSU.2.00.0902071957040.12855@fbirervta.pbzchgretzou.qr> <1234035818.4441.36.camel@dogo.mojatatu.com> <4990411F.5060509@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: hadi@cyberus.ca, Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49142 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754369AbZBIPcB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Feb 2009 10:32:01 -0500
In-Reply-To: <4990411F.5060509@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> jamal wrote:
>> On Sat, 2009-02-07 at 20:05 +0100, Jan Engelhardt wrote:
>>> ess.
>>>
>>> This afinfo thing has been a red LED beam in my eye. I just do not think
>>> iproute2-m_ipt should have to deal with afinfo at all.
>>> ..
>>> So I now also dealt with that and moved it according to what I think 
>>> is right - see latest git commit in mine; [77f48c2]
>>
>> Ok, tried that looks good. I prefer the approach you have. So
>> discard the patch i posted.
> 
> I'm a bit unsynced right now because I lost a harddisk and couldn't
> follow emails. Could you resend the agreed-upon patches that you
> want me to apply please?

Jan has sent them to netfilter-users instead of netfilter-devel by 
mistake there this morning. Look there.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
