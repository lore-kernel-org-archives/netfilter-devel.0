From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER]: Move extensions' arguments into compound structure
 (1/2)
Date: Sun, 05 Oct 2008 18:36:02 +0200
Message-ID: <48E8ECF2.7050008@trash.net>
References: <alpine.LNX.1.10.0810031851430.13861@fbirervta.pbzchgretzou.qr> <48E8CF70.9090309@trash.net> <alpine.LNX.1.10.0810051036170.21891@fbirervta.pbzchgretzou.qr> <48E8D493.5@trash.net> <alpine.LNX.1.10.0810051054460.21891@fbirervta.pbzchgretzou.qr> <48E8D957.3000803@trash.net> <alpine.LNX.1.10.0810051216090.21891@fbirervta.pbzchgretzou.qr> <48E8EAA0.8010606@trash.net> <alpine.LNX.1.10.0810051226410.21891@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48909 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760036AbYJEQgI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Oct 2008 12:36:08 -0400
In-Reply-To: <alpine.LNX.1.10.0810051226410.21891@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Sunday 2008-10-05 12:26, Patrick McHardy wrote:
>>>
>>> Constructing the xt_match_param for example in ipt_do_table() instead
>>> of do_match() would mean that iff some extension trashed, say,
>>> par->in, then all future extensions would get that new value, which
>>> is of course not what we wanted.
>> It isn't what we want? Why does it change the global value then?
> 
> For example, ebt_snat does this:
> 
> bool ebt_snat_tg_check(table, e, target, data, hookmask)
> {
> 	if (hookmask & base_chain_bit && tmp == EBT_RETURN)
> 		return false;
> 	hookmask &= ~base_chain_bit;
> 	if (hookmask & yada)
> 		whatever;
> 	else
> 		foo;
> }
> 
> hookmask was coiped to the function by use of the stack (the usual stuff),
> but with the argument consolidation, it now reads like:
> 
> 	par->hookmask &= ~base_chain_bit;
> 
> which means that the caller will see the altered hook mask. This is why
> the struct is thrown away everytime.

OK, so ebt_snat_tg_check has to use a local copy.

>>> Requesting verdict from you. :)
>>> Make it const so that extensions don't tamper with it?
>> Preferrably, yes.
>>
> Perfect.

Great.
