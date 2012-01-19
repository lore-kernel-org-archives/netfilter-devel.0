From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.11 released
Date: Thu, 19 Jan 2012 22:00:35 +0000
Message-ID: <4F189283.4000401@googlemail.com>
References: <alpine.DEB.2.00.1201141542490.26282@blackhole.kfki.hu> <4F130A03.7080208@googlemail.com> <alpine.DEB.2.00.1201151825570.29134@blackhole.kfki.hu> <4F131551.2090608@googlemail.com> <alpine.DEB.2.00.1201152100050.29766@blackhole.kfki.hu> <4F135552.4070804@googlemail.com> <alpine.DEB.2.00.1201160914550.30763@blackhole.kfki.hu> <4F175B94.60001@googlemail.com> <alpine.DEB.2.00.1201191154330.7547@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1201191154330.7547@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


>> One other thing: *if* ipset can only accept single IP addresses instead 
>> of IP ranges (I don't believe this to be the case, but anyway, if it 
>> does), then you could process a single IP address in a loop containing 
>> the whole range to be tested (10.1.12.0/24 in my example - i.e. looping 
>> from 10.1.12.0 until 10.1.12.255 inclusive) and bail out as soon as 
>> there is no match, which would then return 'false' (i.e. no match). You 
>> could even speed things up a bit by implementing batch processing of IP 
>> ranges internally (via a single kernel APIs instead of looping via ipset 
>> and calling the kernel API each time for a single IP address check).
>>
>> I know this implementation is a bit crude, but since this testing takes 
>> place in userspace then this delay won't matter *that* much. How doable 
>> is that?
>>     
>
> The userspace testing is passed to the kernel for execution. There's no
> shadow or backup or whatever set in userspace. The sets exist in kernel 
> space and therefore all operations happen there.
>   
So, is the above doable in any shape or form or not?

> Why do you need such tests at all?
>   
Various reasons. Two common uses (at least in my case) would be to test 
ip range against quite a large set of registered subnets (taken from the 
geoip database and sorted using my own criteria). The tested ip range is 
either candidate to 1). ban that network, in which case I do not want 
duplicates if the existing range is already there; or 2) include the ip 
range in a separate set, making sure that it is not already in the 
'banned' set and also that it is not already included in the 'customer' 
set (which although limited, has quite significant number of set members 
- usually small subnets).

Because the ip range in ipset is not working correctly, I had to first 
manually go over the testing ranges. Later on I devised a small shell 
script doing what I just described in my previous post (quoted above), 
but it is quite ugly and inefficient - it would be much better if ip 
range testing in ipset was functioning properly, saving me all this hassle.
