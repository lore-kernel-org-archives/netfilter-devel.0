From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: nf_ct_expect: fix possible access to
 uninitialized timer
Date: Thu, 16 Aug 2012 04:14:25 +0200 (MEST)
Message-ID: <Pine.GSO.4.63.1208160413220.13364@stinky-local.trash.net>
References: <1344991422-2514-1-git-send-email-pablo@netfilter.org>
 <Pine.GSO.4.63.1208150304530.2602@stinky-local.trash.net> <20120815171413.GA14637@1984>
 <Pine.GSO.4.63.1208160114300.14109@stinky-local.trash.net> <20120816011723.GA15129@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63762 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab2HPCO2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Aug 2012 22:14:28 -0400
In-Reply-To: <20120816011723.GA15129@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 16 Aug 2012, Pablo Neira Ayuso wrote:

> On Thu, Aug 16, 2012 at 01:15:24AM +0200, Patrick McHardy wrote:
> [...]
>>>> Once question remains though - if the scenario you describe happens and
>>>> we're just refreshing an existing expectation, should that one actually
>>>> get unexpected by the nf_ct_unexpect_related() call?
>>>>
>>>> The intention is to remove the expectation with that tuple, the refreshing
>>>> is just an optimization, so I think that would make sense.
>>>
>>> Yes, that's another possibility that look better to me as the expect
>>> object would be always inserted.
>>
>> So we'd just remove the refreshing, kill the old expectation and insert
>> the new one instead?
>
> Agreed. Patch attached.
>

Looks fine. We probably still have another bug though, will have another
look tommorrow.

Acked-by: Patrick McHardy <kaber@trash.net>
