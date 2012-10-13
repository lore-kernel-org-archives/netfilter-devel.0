From: Stephen Clark <sclark46@earthlink.net>
Subject: Re: ipsec nat issue
Date: Sat, 13 Oct 2012 18:53:27 -0400
Message-ID: <5079F0E7.9000905@earthlink.net>
References: <50787C14.7060009@earthlink.net> <alpine.LNX.2.01.1210122226130.11967@nerf07.vanv.qr> <5078D3B4.6030107@earthlink.net>
Reply-To: sclark46@earthlink.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@inai.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: sclark46@earthlink.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from elasmtp-banded.atl.sa.earthlink.net ([209.86.89.70]:60859 "EHLO
	elasmtp-banded.atl.sa.earthlink.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754244Ab2JMXI0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 13 Oct 2012 19:08:26 -0400
In-Reply-To: <5078D3B4.6030107@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry for the noise.

I had started the ping before I added the NAT rule so
either conntrack or the route cache was keeping the packet from
going thru the SNAT. I stopped the ping for a while then started
it back up and everything worked as I expected.

On 10/12/2012 10:36 PM, Stephen Clark wrote:
> On 10/12/2012 04:28 PM, Jan Engelhardt wrote:
>> On Friday 2012-10-12 22:22, Stephen Clark wrote:
>>
>>> Hello,
>>>
>>> I have the following setup:
>>>
>>> ipsec tunnel 10.255.3.128/25 - pub add1<->  pub add2 - 10.255.5.128/25
>>>
>>> trying to SNAT remote private address 10.255.5.128/25 to make it 
>>> appear like it
>>> was local 10.255.3.254
>> The left endpoint has 10.255.3.128/25 declared as local, so if the left
>> side is to respond to packets which have 10.255.3.254 as source address,
>> that reply will be delivered on its own side (the left side), and never
>> the tunnel.
>>
>> This is like trying to SNAT all your home traffic that is supposed to go
>> to the internet to 192.168.1.1 -- unroutable for the Internet.
>>
> Hi Jan,
>
> The ping is initiated from the right side of the tunnel trying to ping 
> a device on the left subnet. The device on the left
> subnet at 10.255.3.129 doesn't know about the right subnet at 
> 10.255.5.128/25 so I want to make the packets coming
> from the right subnet of 10.255.5.128/25 appear as if they came from 
> the left address of 10.255.3.254. I would expect
> that when the echo response came back from 10.255.3.129 it would be 
> unSNATed so the destination address would now
> be 10.255.5.254 and it would go back thru the vpn tunnel to the right 
> side.
>
> I don't see this as any different than when I use SNAT from my private 
> network to my public network except
> I using two private addresses.
>
>


-- 

"They that give up essential liberty to obtain temporary safety,
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty
decreases."  (Thomas Jefferson)



