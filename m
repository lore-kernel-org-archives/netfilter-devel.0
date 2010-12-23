From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: inconsistent address treatment.
Date: Thu, 23 Dec 2010 17:43:56 -0500
Message-ID: <4D13D0AC.3030106@earthlink.net>
References: <4D1358C0.4060704@earthlink.net> <alpine.LNX.2.01.1012232253090.28085@obet.zrqbmnf.qr>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:33561 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751608Ab0LWWyq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Dec 2010 17:54:46 -0500
In-Reply-To: <alpine.LNX.2.01.1012232253090.28085@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12/23/2010 04:53 PM, Jan Engelhardt wrote:
> On Thursday 2010-12-23 15:12, Stephen Clark wrote:
>
>    
>> Hello,
>>
>> Why the inconsistency in the way addresses are treated. I can use -d 2.2.2.2/32
>> but not --to-source 205.201.149.214/32
>>
>> iptables -t nat -A POSTROUTING -o eth1 -s 10.0.128.0/17 -d 2.2.2.2/32 -j SNAT
>> --to-source 205.201.149.214/32
>>      
> What inconsistency?
>    
If you try the above command you get a complaint about

--to-source 205.201.149.214/32
you have to use
--to-source 205.201.149.214

iptables 1.4.5.
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>    


-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



