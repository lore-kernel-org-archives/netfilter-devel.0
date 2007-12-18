From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 00/64]: Netfilter update
Date: Tue, 18 Dec 2007 12:33:44 +0100
Message-ID: <4767B018.50109@trash.net>
References: <20071217234612.23601.6979.sendpatchset@localhost.localdomain> <20071217.225126.26533748.davem@davemloft.net> <4767A199.3040308@trash.net> <4767AFC8.2050906@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52764 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245AbXLRLdy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Dec 2007 06:33:54 -0500
In-Reply-To: <4767AFC8.2050906@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote:
> Patrick McHardy wrote:
>> David Miller wrote:
>>> Some of those default=m cases are marked EXPERIMENTAL.  Either the
>>> default=m or the EXPERIMENTAL are bogus, in each case.  Most of the
>>> time it's the latter, and if you could fix these I'd appreciate it.
>>
>> Sure, I'll include a patch in my next update. Its a good opportunity
>> to go through all netfilter EXPERIMENTAL marks, I bet there are
>> more that could be removed.
> 
> maybe ctnetlink? :-)
> 

Already done :)
