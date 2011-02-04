From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 7/8] libxtables: symbol visibility
Date: Fri, 04 Feb 2011 14:30:02 +0100
Message-ID: <4D4BFF5A.3020303@trash.net>
References: <1296824935-4606-1-git-send-email-jengelh@medozas.de> <1296824935-4606-8-git-send-email-jengelh@medozas.de> <4D4BFB75.4080803@trash.net> <alpine.LNX.2.01.1102041421530.5968@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46715 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559Ab1BDNaR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Feb 2011 08:30:17 -0500
In-Reply-To: <alpine.LNX.2.01.1102041421530.5968@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 04.02.2011 14:22, Jan Engelhardt wrote:
> On Friday 2011-02-04 14:13, Patrick McHardy wrote:
> 
>> On 04.02.2011 14:08, Jan Engelhardt wrote:
>>> -void xtables_free_opts(int unused)
>>> +EXPORT_SYMBOL void xtables_free_opts(int unused)
>>
>> This is pretty ugly in my opinion. Please do something like this:
>>
>> #define EXPORT_SYMBOL(x)        typeof(x) (x)
>> __attribute__((visibility("default")))
>>
>> so you can use EXPORT_SYMBOL as in the kernel.
> 
> But that is redundancy nonplusultra.

Who cares? Its a lot nicer to look at and people are used to using
it this way. In fact Pablo just changed libmnl to the same style.

> The reason why EXPORT_SYMBOL is a 
> separate statement is because it is much more than just a function 
> attribute inside the kernel.

That might be one reason.
