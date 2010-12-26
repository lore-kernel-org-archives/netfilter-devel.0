From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sun, 26 Dec 2010 13:47:07 +0000
Message-ID: <4D17475B.9000909@googlemail.com>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0CC3BB.8030801@googlemail.com> <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu> <4D0D2CF4.5070201@googlemail.com> <alpine.DEB.2.00.1012190105460.11753@blackhole.kfki.hu> <4D0E0E2A.3090604@googlemail.com> <4D0E22A5.8090808@conversis.de> <4D0E3B34.7090105@googlemail.com> <alpine.DEB.2.00.1012221146060.3482@blackhole.kfki.hu> <4D11F384.3070908@googlemail.com> <alpine.DEB.2.00.1012231558390.6044@blackhole.kfki.hu> <4D138C02.3050905@googlemail.com> <alpine.DEB.2.00.1012232008520.6582@blackhole.kfki.hu> <4D13CBD8.3090007@googlemail.com> <alpine.DEB.2.00.1012232337070.7027@blackhole.kfki.hu> <alpine.DEB.2.00.1012232354510.7109@blackhole.kfki.hu> <4D13D60C.3020304@googlemail.com> <alpine.DEB.2.00.1012261125100.9618@black
 hole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Dennis Jacobfeuerborn <dennisml@conversis.de>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1012261125100.9618@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


>> OK, does that differ if I have hash:net,port set (I presume when listing with
>> ipset -L you will show the net ranges - 192.168.0.0-192.168.0.0,tcp:80-82), is
>> that right?
>>     
>
> For net types the networks are not exploded, of course:
>
> # ipset create test hash:net,port 
> # ipset add test 192.168.0.0/30,tcp:80-82
> # ipset list test
> Name: test                                                                      
> Type: hash:net,port                                                             
> Header: family inet hashsize 1024 maxelem 65536                                 
> Size in memory: 16856                                                           
> References: 0                                                                   
> Members:                                                                        
> 192.168.0.0/30,tcp:80                                                           
> 192.168.0.0/30,tcp:82                                                           
> 192.168.0.0/30,tcp:81                                                           
>   
OK, it is much clearer to me now.

You are expanding the command line port ranges (80-82 in your example 
above) to add the underlying elements. Could you not do a similar 
arrangement for the protocol as well?

For example, if I execute "ipset add test 192.168.0.0/30,*:80-82" (or 
"all" instead of "*" if that is not possible) could you not expand that 
to represent the following elements:

192.168.0.0/30,tcp,80
..
192.168.0.0/30,tcp,82
192.168.0.0/30,udp,80
..
192.168.0.0/30,udp,82

It is not a perfect solution by any stretch, but at least it will save 
me the hassle, as with the introduction of the port ranges, of executing 
the statement twice each time I want to include net and port ranges 
without being interested in the protocol match.

As an aside note: since this is a hash set I am assuming that you use 
hashes to do the match as hash matching is very fast. I also presume 
that is the main reason you expand the port ranges so that you can 
calculate the hashes for that particular element and then match it with 
the real ip/subnet,protocol,port.

If that is the case how do you match subnets? In other words (using your 
example above) how do you match (the calculated hash for) 
192.168.0.2,tcp:80 against (the calculated hash for) 
192.168.0.0/30,tcp:80 - they, on the face of it, will differ!

> However please note, the "net" types slow down linearly with the number of 
> different network prefixes in the set.
>   
Is this slowdown more than when I use iptreemap set for example? How 
does the new set (hash) performance compares against the 'old' 
iptreemap/treemap sets used in 4.x?

