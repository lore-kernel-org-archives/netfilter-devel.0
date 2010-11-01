From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: clone packet with new destination address
Date: Mon, 01 Nov 2010 10:29:49 -0400
Message-ID: <4CCECEDD.2030107@earthlink.net>
References: <4CC1843F.8050903@earthlink.net> <AANLkTi=Y6zdmj4hngEaJPjZjNTTWaWMERfKR=dGSkY9b@mail.gmail.com> <AANLkTi=T3QwJp-yVT3GNk46mjmudQ5CrE71YnMqWfsOh@mail.gmail.com> <4CCEB69B.5080905@earthlink.net> <alpine.LNX.2.01.1011011405480.4499@obet.zrqbmnf.qr>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Changli Gao <xiaosuo@gmail.com>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-junco.atl.sa.earthlink.net ([209.86.89.63]:53400 "EHLO
	elasmtp-junco.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758032Ab0KAO34 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Nov 2010 10:29:56 -0400
In-Reply-To: <alpine.LNX.2.01.1011011405480.4499@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/01/2010 09:09 AM, Jan Engelhardt wrote:
> On Monday 2010-11-01 13:46, Stephen Clark wrote:
>    
>>> Oh, iptables can also do it. Please see iptables target TEE and
>>> RAWNAT in xtables-addons. http://xtables-addons.sourceforge.net/
>>>        
>> In testing this it looks like, to me anyhow, that the cloned packet
>> gets sent to the new gw with the original destination address, so
>> now the destination address has to get fixed up on the gw, this
>> seems pretty kludgy to me. Why can't the cloned packet simply have
>> its destination address replaced with the new destination address?
>>      
> Because that would incur a loss of information (namely, the
> destination address).
>
>    
>> This seems to me like it would make a lot more sense, instead of
>> having to make changes to the packet on two different systems.
>>      
> You can do the changes on a single machine if you want to.
>
>    
I am not sure on how to go about doing that, looking at the code for TEE 
it looks
like the cloned packet bypasses any of the remaining iptables chains. So 
where
would I change the destination address? Also if I am mistaken and it 
does hit
one of the remaining iptables chains how do I tell it is not the 
original but the
cloned packet I want to change to the new destination address?

Anyway thanks for your response.

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



