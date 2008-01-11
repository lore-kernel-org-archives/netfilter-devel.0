From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/27] Remove CONFIG_COMPAT code in xt_hashlimit, xt_limit
Date: Fri, 11 Jan 2008 10:36:12 +0100
Message-ID: <4787388C.8090709@trash.net>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0801022126330.14900@fbirervta.pbzchgretzou.qr> <477E4496.4050604@trash.net> <Pine.LNX.4.64.0801102357590.425@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:47028 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714AbYAKJkr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Jan 2008 04:40:47 -0500
In-Reply-To: <Pine.LNX.4.64.0801102357590.425@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Jan 4 2008 15:37, Patrick McHardy wrote:
>>>     [NETFILTER]: Remove CONFIG_COMPAT code in xt_hashlimit, xt_limit
>>>     
>>>     The kernel parts of the structures do not need to be fixed nor
>>>     compat-converted; all other fields already use fixed types, so the
>>>     compat code is not needed.
>> Did you test this? It definitely seems necessary since pointers have
>> different size and allignment requirements on 64 bit.
> 
> Hm you were right. I removed the compat from hashlimit and promptly got
> 
> 	invalid size 64 != 52
> 
> but then again I wonder why xt_connlimit works without compat.

Because it uses __attribute__((aligned(8)))

> 
>> In the hashlimit case we have a 4 byte hole before the hinfo pointer
>> on 64 bit which is not present on 32 bit, limit uses an unsigned long
>> which has different size and also has a hole before the master pointer
>> on 64 bit.
>>
> Even if that hole was not there, it would be
> 
> 	64 != 56
> 
> or so, no?

Additionally pointer sizes differ, which makes up for another 2*4 bytes.

