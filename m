From: Patrick McHardy <kaber@trash.net>
Subject: Re: libnl: Unmatched NL_ACT_DEL and NL_ACT_CHANGE
Date: Fri, 10 Jul 2009 12:40:02 +0200
Message-ID: <4A571A82.3080609@trash.net>
References: <200907051144.51967.volker@openbios.org> <4A51E024.8090402@trash.net> <200907061417.41282.volker@openbios.org> <4A52DD46.5090501@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Volker Poplawski <volker@openbios.org>,
	netfilter-devel@vger.kernel.org
To: Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:35973 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbZGJKkH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jul 2009 06:40:07 -0400
In-Reply-To: <4A52DD46.5090501@snapgear.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Philip Craig wrote:
> Volker Poplawski wrote:
>> On Monday 06 July 2009 13:29:40 you wrote:
>>> Volker Poplawski wrote:
>>>> Hi all.
>>>>
>>>> Could s.o. please  have a look at my (short) code at
>>>> http://pastie.org/534637
>>>>
>>>> (maybe compile it with g++ -Wall test.c -o test -I ... -L ... -lnl
>>>> -lnl-genl - lnl-nf -lnl-route)
>>>>
>>>> What the code does is to listen to changes in the ct-table using libnl.
>>>> It keeps score of reported ctId in a lookup table.
>>>>
>>>> Problem is: I'm getting a lot of NL_ACT_CHANGE & NL_ACT_DEL without
>>>> having seen a matching NL_ACT_NEW. (Also there seems to be no initial
>>>> cache fill)
>>>>
>>>> kernel 2.6.27 (opensuse 11.1), libnl 2.0 (git master)
>>> I think I know whats happening - the ct objects don't define the
>>> attribute(s) distinguishing different entries, so cache_include()
>>> doesn't recognize them as new.
>>>
>>> Does this patch make any difference?
> 
> Yes that improves it.  We probably want to change libnl so that we
> can specify a set of optional attributes to compare, so that
> nl_object_identical does something like this:
> 
> 	if ((a->ce_mask & req_attrs) != req_attrs ||
> 	    (b->ce_mask & req_attrs) != req_attrs)
> 		return 0;
> 
> 	if ((a->ce_mask & opt_attrs) != (b->ce_mask & opt_attrs))
> 		return 0;
> 	...
> 	return !(ops->oo_compare(a, b, (req_attrs | a->ce_mask & opt_attrs), 0));
> 
> 
> This would let it work on older kernels that don't include the id too.

Good point, we didn't include the ID in event messages in older
kernels. We should also compare the tuples anyways, which should
work on both old and new kernels since the ID won't be available
for both compared objects and thus there's no difference if I read
the code correctly.



