From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: inconsistent address treatment.
Date: Fri, 24 Dec 2010 10:34:08 -0500
Message-ID: <4D14BD70.4090007@earthlink.net>
References: <4D1358C0.4060704@earthlink.net> <alpine.LNX.2.01.1012232253090.28085@obet.zrqbmnf.qr> <4D13D0AC.3030106@earthlink.net> <alpine.LNX.2.01.1012240944000.13607@obet.zrqbmnf.qr>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, pascal.mail@plouf.fr.eu.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-junco.atl.sa.earthlink.net ([209.86.89.63]:58073 "EHLO
	elasmtp-junco.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752331Ab0LXPeK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Dec 2010 10:34:10 -0500
In-Reply-To: <alpine.LNX.2.01.1012240944000.13607@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/24/2010 03:46 AM, Jan Engelhardt wrote:
> On Thursday 2010-12-23 23:43, Stephen Clark wrote:
>    
>> On 12/23/2010 04:53 PM, Jan Engelhardt wrote:
>>      
>>> On Thursday 2010-12-23 15:12, Stephen Clark wrote:
>>>
>>>        
>>>> Why the inconsistency in the way addresses are treated. I can use -d
>>>> 2.2.2.2/32
>>>> but not --to-source 205.201.149.214/32
>>>>
>>>> iptables -t nat -A POSTROUTING -o eth1 -s 10.0.128.0/17 -d 2.2.2.2/32 -j SNAT
>>>> --to-source 205.201.149.214/32
>>>>
>>>>          
>>> What inconsistency?
>>>
>>>        
>> If you try the above command you get a complaint about
>>
>> --to-source 205.201.149.214/32
>> you have to use
>> --to-source 205.201.149.214
>>      
> Ah "that" sort of "inconsensitency". No, that is not an inconsistency.
> -d takes an addr[/mask] or a addr[/prefixlen] or a list thereof, while
> -m iprange and DNAT's --to-source take addr[-addr].
>
> Each is subtly different. And documented.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>    
Just because it is documented doesn't mean it is not inconsistent.

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



