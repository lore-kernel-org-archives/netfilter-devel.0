From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.13 released
Date: Mon, 02 Jul 2012 15:28:38 +0100
Message-ID: <4FF1B016.7010807@googlemail.com>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu> <4FF02A93.8080603@googlemail.com> <alpine.DEB.2.00.1207011405160.2289@blackhole.kfki.hu> <4FF04038.4080306@googlemail.com> <alpine.DEB.2.00.1207011434010.2486@blackhole.kfki.hu> <4FF04647.7060807@googlemail.com> <alpine.DEB.2.00.1207011446260.2486@blackhole.kfki.hu> <4FF04DDA.3020609@googlemail.com> <alpine.DEB.2.00.1207011646110.2749@blackhole.kfki.hu> <f1ffdaf291ae86a1e111d3edbae4cfa3@treenet.co.nz> <alpine.DEB.2.00.1207020916030.4335@blackhole.kfki.hu> <4FF19E01.6090400@googlemail.com> <alpine.DEB.2.00.1207021513540.4335@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Amos Jeffries <squid3@treenet.co.nz>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40260 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab2GBO2n (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jul 2012 10:28:43 -0400
In-Reply-To: <alpine.DEB.2.00.1207021513540.4335@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


>>> Maybe ASCII art helps better to explain the different views:
>>>
>>> - Mr Dash Four
>>>
>>>                      -----------
>>>   pkt comes in ----- | machine | ----- pkt goes out
>>>                    ^ ----------- ^
>>>                  destination   source
>>>
>>> - my view follows how the subsytem sees the interfaces
>>>
>>>                              ------------------
>>>   pkt comes in --- interface | ipset subsytem | interface --- pkt goes out
>>>                            ^ ------------------ ^
>>>                        source               destination
>>>
>>>   
>>>       
>> How do you explain that the same "ipset subsystem" treats the IP address 
>> of the "source" interface (according to your diagram above) as 
>> "destination" when I match the same (incoming) packet above?
>>     
>
> The source and destination IP addresses come of course from the packets. 
> They have nothing to do with the interfaces - one can route any (sort of) 
> packet with any source/destination IP addresses to whatever interface.
>
> Do you skip routers and think of end hosts only, where the 
> destination/source IP address is that of the receiving/sending interface?
>   
I see you are avoiding my questions as per usual, so I'll ask them 
again, for the last time:-

1) Why is it that the same "ipset subsystem" in your diagram above 
doesn't seem to apply the same criteria and treats the IP address of the 
"source" interface as a "destination" (not "source"), in order to get a 
match for the same type of (incoming) packet; and

2) How do you explain that the same designation ("destination") applies 
for everything else in that "ipset system" (not to mention 
iptables/netfilter) with the notable exception of hash:net,iface set for 
the same type of match (incoming packet)?

