From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf_nat_core just using l3proto_find_get
Date: Tue, 11 Mar 2008 15:05:57 +0100
Message-ID: <47D691C5.7010907@trash.net>
References: <Pine.LNX.4.64.0802080309220.25157@fbirervta.pbzchgretzou.qr> <47BACA14.8000006@trash.net> <Pine.LNX.4.64.0803102259100.21961@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep20-int.chello.at ([62.179.121.40]:46967 "EHLO
	viefep20-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101AbYCKOGA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Mar 2008 10:06:00 -0400
In-Reply-To: <Pine.LNX.4.64.0803102259100.21961@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Feb 19 2008 13:22, Patrick McHardy wrote:
>> Jan Engelhardt wrote:
>>> I just noticed that nf_nat_core.c uses
>>>
>>>         l3proto = nf_ct_l3proto_find_get((u_int16_t)AF_INET);
>>>
>>> in its nf_nat_init() function. Why is not it using
>>> nf_ct_l3proto_module_try_get here?
>> There is no such function, nf_ct_l3proto_find_get() takes a
>> module reference.
>>
> Hm?
> 
> [...]
> 
> leading to the original question why nf_nat_core does not use
> nf_ct_l3proto_try_module_get.


Why should it? There's no need for manual module loading since
there already is a symbol dependency.
