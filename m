From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: clone packet with new destination address
Date: Fri, 22 Oct 2010 10:16:14 -0400
Message-ID: <4CC19CAE.1030306@earthlink.net>
References: <4CC1843F.8050903@earthlink.net> <AANLkTi=Y6zdmj4hngEaJPjZjNTTWaWMERfKR=dGSkY9b@mail.gmail.com> <AANLkTi=T3QwJp-yVT3GNk46mjmudQ5CrE71YnMqWfsOh@mail.gmail.com>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:43141 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754278Ab0JVOQT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Oct 2010 10:16:19 -0400
In-Reply-To: <AANLkTi=T3QwJp-yVT3GNk46mjmudQ5CrE71YnMqWfsOh@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10/22/2010 09:36 AM, Changli Gao wrote:
> On Fri, Oct 22, 2010 at 9:24 PM, Changli Gao<xiaosuo@gmail.com>  wrote:
>    
>> On Fri, Oct 22, 2010 at 8:31 PM, Stephen Clark<sclark46@earthlink.net>  wrote:
>>      
>>> Hello,
>>>
>>> Problem:
>>> I have a two monitoring servers behind a a linux firewall, one is primary
>>> and one is backup.
>>> In the field we have units sending udp informational packet to the primary
>>> server. On the
>>> linux firewall I would like to copy this packet and change the destination
>>> address of the copied
>>> packet to point to the backup server. Is there a way to do this without
>>> writing any code?
>>>
>>> NOTE:
>>> Currently the firewall is FreeBSD and we accomplish this rather easily using
>>> ipfw along with natd, but we want to move to linux for our firewall.
>>>
>>>        
>> I think you can use tc action mirred to mirror the packets to a fake
>> NIC device ifb, and use tc action nat to dnat the packets received
>> from ifb.
>>
>>      
> Oh, iptables can also do it. Please see iptables target TEE and RAWNAT
> in xtables-addons. http://xtables-addons.sourceforge.net/
>
>    
Not to seem dumb - but I tried xtables TEE without any success. Could 
you provide a detailed
example?

Thanks,
Steve

-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



