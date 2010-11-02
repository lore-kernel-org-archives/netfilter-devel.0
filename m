From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: clone packet with new destination address
Date: Tue, 02 Nov 2010 09:44:29 -0400
Message-ID: <4CD015BD.2000408@earthlink.net>
References: <4CC1843F.8050903@earthlink.net> <AANLkTi=Y6zdmj4hngEaJPjZjNTTWaWMERfKR=dGSkY9b@mail.gmail.com> <AANLkTi=T3QwJp-yVT3GNk46mjmudQ5CrE71YnMqWfsOh@mail.gmail.com> <4CCEB69B.5080905@earthlink.net> <alpine.LNX.2.01.1011011405480.4499@obet.zrqbmnf.qr> <4CCECEDD.2030107@earthlink.net> <alpine.LNX.2.01.1011012015340.655@obet.zrqbmnf.qr>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Changli Gao <xiaosuo@gmail.com>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-curtail.atl.sa.earthlink.net ([209.86.89.64]:54726 "EHLO
	elasmtp-curtail.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803Ab0KBNog (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Nov 2010 09:44:36 -0400
In-Reply-To: <alpine.LNX.2.01.1011012015340.655@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/01/2010 03:29 PM, Jan Engelhardt wrote:
> On Monday 2010-11-01 15:29, Stephen Clark wrote:
>    
>> On 11/01/2010 09:09 AM, Jan Engelhardt wrote:
>>      
>>>        
>>>> This seems to me like it would make a lot more sense, instead of
>>>> having to make changes to the packet on two different systems.
>>>>          
>>> You can do the changes on a single machine if you want to.
>>>        
>>
>> I am not sure on how to go about doing that, looking at the code for
>> TEE it looks like the cloned packet bypasses any of the remaining
>> iptables chains. So where would I change the destination address?
>>      
> Right. You need a kernel>= 2.6.35 (xt_TEE is included)
> for cloned packets to go through the tables again.
>
>    
>> Also if I am mistaken and it does hit one of the remaining iptables
>> chains how do I tell it is not the original but the cloned packet I
>> want to change to the new destination address?
>>      
> Good question. Given the possibilities I think an extra route towards
> the logging server that specifies a realm value, that is then
> matchable in -A OUTPUT -m realm, is in order.
>
>    
Hmm...,

Sounds like maybe an easier way to do this is to use libipq and the 
QUEUE target to
select the packets of interest - then make a copy of the packet in 
userspace and
use a raw socket to send the copy with the new destination address on 
its way.

Does this sound reasonable?

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



