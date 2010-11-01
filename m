From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: clone packet with new destination address
Date: Mon, 01 Nov 2010 11:16:04 -0400
Message-ID: <4CCED9B4.6070108@earthlink.net>
References: <4CC1843F.8050903@earthlink.net> <AANLkTi=Y6zdmj4hngEaJPjZjNTTWaWMERfKR=dGSkY9b@mail.gmail.com> <AANLkTi=T3QwJp-yVT3GNk46mjmudQ5CrE71YnMqWfsOh@mail.gmail.com> <4CCEB69B.5080905@earthlink.net> <alpine.LNX.2.01.1011011405480.4499@obet.zrqbmnf.qr> <4CCECEDD.2030107@earthlink.net> <AANLkTiny3XRc7-OPrUzvzp_=0wd4KJ+GAhPQEkQrSwjR@mail.gmail.com>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-kukur.atl.sa.earthlink.net ([209.86.89.65]:33803 "EHLO
	elasmtp-kukur.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753479Ab0KAPYK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Nov 2010 11:24:10 -0400
In-Reply-To: <AANLkTiny3XRc7-OPrUzvzp_=0wd4KJ+GAhPQEkQrSwjR@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 11/01/2010 11:00 AM, Changli Gao wrote:
> On Mon, Nov 1, 2010 at 10:29 PM, Stephen Clark<sclark46@earthlink.net>  wrote:
>    
>> I am not sure on how to go about doing that, looking at the code for TEE it
>> looks
>> like the cloned packet bypasses any of the remaining iptables chains.
>>      
> It isn't true. The cloned packet only bypasses the iptables rule where
> it is generated.
>
>    
>> So
>> where
>> would I change the destination address? Also if I am mistaken and it does
>> hit
>> one of the remaining iptables chains how do I tell it is not the original
>> but the
>> cloned packet I want to change to the new destination address?
>>
>>      
> I think you can use the RAWSNAT xtables-addon to change the
> destination address. Since the new skb is attached to untracked ct,
> you can use match conntrack --ctstate UNTRACKED to filter it out.
>
>    
Hi Changli,

Thank you very much for the reply, But wouldn't it be RAWDNAT since  I 
want to
change the destination address?

Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



