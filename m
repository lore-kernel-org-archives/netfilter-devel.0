From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: inconsistent address treatment.
Date: Sun, 26 Dec 2010 13:35:32 -0500
Message-ID: <4D178AF4.7040801@earthlink.net>
References: <4D1358C0.4060704@earthlink.net> <4D13A863.70600@plouf.fr.eu.org> <4D13D0FF.1010900@earthlink.net> <4D1457D5.3040305@plouf.fr.eu.org> <4D14BD05.8020509@earthlink.net> <alpine.LNX.2.01.1012242242440.30415@obet.zrqbmnf.qr> <4D1730B7.3090805@treenet.co.nz> <alpine.LNX.2.01.1012261345210.31198@obet.zrqbmnf.qr>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Amos Jeffries <squid3@treenet.co.nz>,
	Pascal Hambourg <pascal.mail@plouf.fr.eu.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-junco.atl.sa.earthlink.net ([209.86.89.63]:34138 "EHLO
	elasmtp-junco.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752325Ab0LZSfn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Dec 2010 13:35:43 -0500
In-Reply-To: <alpine.LNX.2.01.1012261345210.31198@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/26/2010 07:47 AM, Jan Engelhardt wrote:
> On Sunday 2010-12-26 13:10, Amos Jeffries wrote:
>
>    
>> On 25/12/10 10:48, Jan Engelhardt wrote:
>>      
>>> On Friday 2010-12-24 16:32, Stephen Clark wrote:
>>>        
>>>>>>> Because -d takes a prefix and --to-source takes an address range.
>>>>>>>                
>>>>>> So? you can't parse
>>>>>> 205.201.149.214/32-205.201.149.218/32
>>>>>>              
>>>>> a.b.c.d/32 is a prefix notation, even though it represents a single
>>>>> address. IMO it does not make sense to use a prefix notation in an
>>>>> interval, so I don't see why the parser should handle it. AFAICS, other
>>>>> commands such as 'ip' from iproute don't accept /32 prefixes where a
>>>>> single address is expected either.
>>>>>            
>>>> Well It is just one more idiosyncrasy one has to remember, when to me there
>>>> is no obvious reason
>>>>          
>>> Historical reasons.
>>>
>>> Possible extra explanations:
>>>
>>> - DNAT was added later than the -s argument, and someone thought
>>>    it's better to use a range, since a range can be more expressive
>>>    than addr[/prefixlen] for the same memory usage.
>>> - On the other hand, since iptables also accepts addr[/mask], and it
>>>    also allows /masks that are not representable as a /prefixlen, it
>>>    is not necessarily specifying a contiguous range which may be
>>>    useless to use with DNAT to some.
>>>        
>> FWIW: we (Squid project) use the syntax "ip[-ip][/mask]". This is simple enough
>> to parse and is a bit more flexible.
>>      
> Indeed, but we don't have the space for it ;-)
> There are just two uint32s available in the current struct ipt_ip,
> so it's either ip-ip or ip/mask.
> Of course, in the near future, the ipv4 match can be extended just like
> other extensions (revision bump).
>
>    
That is a reasonable answer.


-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



