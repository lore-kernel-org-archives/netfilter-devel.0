From: Philip Craig <philipc@snapgear.com>
Subject: Re: libnl: Unmatched NL_ACT_DEL and NL_ACT_CHANGE
Date: Tue, 07 Jul 2009 15:29:42 +1000
Message-ID: <4A52DD46.5090501@snapgear.com>
References: <200907051144.51967.volker@openbios.org> <4A51E024.8090402@trash.net> <200907061417.41282.volker@openbios.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Volker Poplawski <volker@openbios.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rex.securecomputing.com ([203.24.151.4]:57124 "EHLO
	cyberguard.com.au" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751824AbZGGF3k (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:29:40 -0400
In-Reply-To: <200907061417.41282.volker@openbios.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Volker Poplawski wrote:
> On Monday 06 July 2009 13:29:40 you wrote:
>> Volker Poplawski wrote:
>>> Hi all.
>>>
>>> Could s.o. please  have a look at my (short) code at
>>> http://pastie.org/534637
>>>
>>> (maybe compile it with g++ -Wall test.c -o test -I ... -L ... -lnl
>>> -lnl-genl - lnl-nf -lnl-route)
>>>
>>> What the code does is to listen to changes in the ct-table using libnl.
>>> It keeps score of reported ctId in a lookup table.
>>>
>>> Problem is: I'm getting a lot of NL_ACT_CHANGE & NL_ACT_DEL without
>>> having seen a matching NL_ACT_NEW. (Also there seems to be no initial
>>> cache fill)
>>>
>>> kernel 2.6.27 (opensuse 11.1), libnl 2.0 (git master)
>> I think I know whats happening - the ct objects don't define the
>> attribute(s) distinguishing different entries, so cache_include()
>> doesn't recognize them as new.
>>
>> Does this patch make any difference?

Yes that improves it.  We probably want to change libnl so that we
can specify a set of optional attributes to compare, so that
nl_object_identical does something like this:

	if ((a->ce_mask & req_attrs) != req_attrs ||
	    (b->ce_mask & req_attrs) != req_attrs)
		return 0;

	if ((a->ce_mask & opt_attrs) != (b->ce_mask & opt_attrs))
		return 0;
	...
	return !(ops->oo_compare(a, b, (req_attrs | a->ce_mask & opt_attrs), 0));


This would let it work on older kernels that don't include the id too.

> Yes it does,  NL_ACT_DEL , _CHANGE and _DEL are now matching -- for ct-entries 
> created after i made my call to nl_cache_mngr_add( ... "netfilter/ct"... )
> 
> However, i still don't get a NL_ACT_DEL on already existing connections 
> (CHANGE and DEL though)

I assume you meant you don't get NL_ACT_NEW events for existing
connections.  That's just how libnl works in general.  You can use
nl_cache_get_first/nl_cache_get_next to populate your hashtable
before you start polling.

