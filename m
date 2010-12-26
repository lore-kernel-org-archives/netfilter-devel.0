From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sun, 26 Dec 2010 21:44:16 +0000
Message-ID: <4D17B730.8040505@googlemail.com>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0CC3BB.8030801@googlemail.com> <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu> <4D0D2CF4.5070201@googlemail.com> <alpine.DEB.2.00.1012190105460.11753@blackhole.kfki.hu> <4D0E0E2A.3090604@googlemail.com> <4D0E22A5.8090808@conversis.de> <4D0E3B34.7090105@googlemail.com> <alpine.DEB.2.00.1012221146060.3482@blackhole.kfki.hu> <4D11F384.3070908@googlemail.com> <alpine.DEB.2.00.1012231558390.6044@blackhole.kfki.hu> <4D138C02.3050905@googlemail.com> <alpine.DEB.2.00.1012232008520.6582@blackhole.kfki.hu> <4D13CBD8.3090007@googlemail.com> <alpine.DEB.2.00.1012232337070.7027@blackhole.kfki.hu> <alpine.DEB.2.00.1012232354510.7109@blackhole.kfki.hu> <4D13D60C.3020304@googlemail.com> <alpine.DEB.2.00.1012261125100.9618@black
 hole.kfki.hu> <4D17475B.9000909@googlemail.com> <alpine.DEB.2.00.1012262034390.10148@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dennis Jacobfeuerborn <dennisml@conversis.de>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1012262034390.10148@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


>> You are expanding the command line port ranges (80-82 in your example above)
>> to add the underlying elements. Could you not do a similar arrangement for the
>> protocol as well?
>>     
> That won't go: tcp and udp are not the possible protocols alone, so by any 
> reasonable syntax, '*' or 'all' should have to mean all protocols from 
> /etc/protocols.
>   
Whatever the appropriate place holder is - 'all', '*', '@', '$$$$$$' 
etc. etc - as long as it does the job at the end it won't matter.

>> It is not a perfect solution by any stretch, but at least it will save me the
>> hassle, as with the introduction of the port ranges, of executing the
>> statement twice each time I want to include net and port ranges without being
>> interested in the protocol match.
>>     
>
> What I could come up as something similar in effect is to make possible to 
> use a copy of /etc/services maintained by the administrator of the given 
> ipset installation and whatever protocols and ports a service name is
> resolved to from that file, use those.
>   
I wasn't aware that there are more than 2 (tcp and udp) protocols on 
which I could define/use ports!

> However such a feature won't be added tomorrow. Nor this year (:-) or the 
> very near future.
>   
What are your plans?

> For the "net" (sub)type of sets the different prefixes in the set is 
> recorded. When testing (adding/deleting) entries, the IP part of the entry 
> is masked with the prefixes one by one and looked up until a match is 
> found or the list is exhausted - that's why the speed is linearly slows 
> down with the different number of prefixes added to the set. An example:
>
> # ipset create test hash:net
> # ipset add test 192.168.0.0/30
> # ipset add test 192.168.1.0/24
>
> There are two different prefixes in the set, 30, 24. So when the command 
> is issued
>
> # ipset test test 192.168.0.1
>
> the address 192.168.0.1 is masked with /30 and the result is looked up 
> and the match is reported:
>   
So, in other words 'internally' you store something like (using your 
example above) 192.168.0.0 (the IP part), 30 (the prefix), tcp, 80 in 
the structure, is that right?
Do you then use the mask of each member of that set (30 and 24 in your 
example above) until you get a match? In other words, you 'walk through' 
every internally stored element and try their mask and then lookup for a 
match, is that how you do it?


>> Is this slowdown more than when I use iptreemap set for example? How does the
>> new set (hash) performance compares against the 'old' iptreemap/treemap sets
>> used in 4.x?
>>     
>
> I never measured the speed difference between the two types. A good guess 
> is that iptreemap is faster.
Thought so!

> However, the problem with iptree(map) is that 
> it's susceptible when used as a container to block attackers dynamically 
> by the SET target: it's trivial to mount an attack by which the worst tree 
> structure is forced to be created.
Could you expand on that bit please? What do you mean?

