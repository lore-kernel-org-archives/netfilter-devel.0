From: Patrick McHardy <kaber@trash.net>
Subject: Re: [oops] in text matching
Date: Sun, 25 Nov 2007 16:38:48 +0100
Message-ID: <47499708.5070502@trash.net>
References: <1194525620.6845.5.camel@ierdnac>  <47330FE1.9020008@trash.net>	 <1194547827.3298.5.camel@ierdnac>  <4735AAC6.7040605@trash.net> <1194936719.10588.0.camel@ierdnac> <47394ABA.3070109@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: andrei.popa@i-neo.ro, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:62182 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753118AbXKYPj1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Nov 2007 10:39:27 -0500
In-Reply-To: <47394ABA.3070109@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy wrote:
> Andrei Popa wrote:
>> On Sat, 2007-11-10 at 13:57 +0100, Patrick McHardy wrote:
>>> Andrei Popa wrote:
>>>> The oops is reproducible by this script (yyy are some IP addresses):
>>>>
>>>> ...
>>>> #$IPT -I INPUT -p tcp --dport 80 -m string --algo bm --string "$MyNick"
>>>> -j DROP
>>>
>>> I could reproduce it with an empty string - is $MyNick defined?
>>
>> it's not defined.
>>
>>> Please try this patch.
>>
>> it's ok now:
>>
>> test ~ # iptables -I INPUT -p tcp --dport 80 -m string --algo bm
>> --string "$MyNick" -j DROP
>> iptables: Invalid argument
> 
> 
> Thanks, thats whats expected. The patch is suboptimal though
> since it should really allow patterns of length zero. Pablo,
> the naive approach would be to ignore patlen == 0 in the
> initialization path and return the current position in bm_find().
> But I'm guessing there's a better way to handle this case,
> could you look into this please? Thanks.


Pablo? I would prefer to get this fixed before 2.6.24, unless
there's a better fix I'm going to include my patch to reject
pattern lengths of 0. Thanks.

