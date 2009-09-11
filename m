From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: [PATCH 00/11] TProxy for IPv6
Date: Sat, 12 Sep 2009 00:12:28 +1200
Message-ID: <4AAA3EAC.8080206@treenet.co.nz>
References: <cover.1251295408.git.bazsi@balabit.hu>	 <4AA0AE8C.30203@treenet.co.nz> <1252435346.32029.44.camel@bzorp.balabit>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu,
	Harry Mason <harry.mason@smoothwall.net>
To: Balazs Scheidler <bazsi@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:41033
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842AbZIKMMi (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 11 Sep 2009 08:12:38 -0400
In-Reply-To: <1252435346.32029.44.camel@bzorp.balabit>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Balazs Scheidler wrote:
> On Fri, 2009-09-04 at 18:07 +1200, Amos Jeffries wrote:
>> Balazs Scheidler wrote:
>>> [ Sorry if this reaches you twice, I sent to the wrong address the first time ]
>>>
>>> I've just pushed a set of patches that implement TProxy for IPv6 to
>>>
>>> http://git.balabit.hu/bazsi/tproxy-2.6.git
>>>
>>> The patches are also posted in reply to this mail.
>>>
>>> Although some work is still needed, basic testing shows that it works all
>>> right.  
>>>
>>> The accompanying iptables patches are available at
>>>
>>> http://git.balabit.hu/bazsi/iptables-tproxy.git
>>>
>>> There are some things left to do:
>>>
>>>   * the recognition of related ICMPv6 packets missing (from xt_socket.c)
>>>
>>>   * I should probably split xt_TPROXY/xt_socket to IPv4 and IPv6 modules, as
>>>     right now those depend on both stacks at the same time.
>>>
>>> I'm on a holiday right now, thus I might not respond to comments in a timely
>>> manner, however I'm interested in any comments/feedback nevertheless.
>>>
>>> Harry, I didn't remember that you actually wanted to work on TProxy for
>>> IPv6, I just vaguely remembered that there was someone asking for IPv6
>>> support, thus I implemented this without being in the know.  If you started
>>> hacking, I hope that we didn't completely duplicate effort.  I'd appreciate
>>> help in the missing bits and/or testing whichever fits you best.
>>>
>>> Also, I have written a Python test script to test TProxy functionality
>>> automatically both for IPv4 and IPv6, I can post that as well if anyone is
>>> interested.
>> I'm interested :)
>>
>> Now that you have done this I'm going to have to find a robust userland 
>> run-time test to see if the underlying TPROXY is v4-only or v6-enabled. 
>> If anyone has suggestions they would be welcome.
>>
>> Thank you very much by the way.
> 
> The script I wrote is not a runtime test, it is a functional test that
> tests various TPROXY scenarios for proper functionality.
> 
> It basically assumes that:
>   1) you run it on the 'client' host, and it has ssh connectivity to the
> 'tproxy' host
>   2) it assumes that IP/route configuration is already prepared
>   3) it uses hardwired IP addresses, but generates iptables/ip6tables
> rules automatically
> 
> I used a virtual machine running on my development computer to do the
> testing.
> 
> IPV6 topology:
> 
> dead:1::1/64 is the client
> dead:1::2/64 is the proxy box
> dead:2::1/64 is the server behind the proxy box
> 
> The script basically copies an agent script to the other box
> (test-agent.py) and uses that to change iptables config/start listeners
> as needed. Then initiates tcp/udp connections to the target host and
> checks if the proper listener received the new connection or a bogus
> one.
> 
> I'm not that responsive these days, but I'm glad to help.
> 
> Last but not least, here's the gitweb interface:
> 
> http://git.balabit.hu/?p=bazsi/tproxy-test.git;a=summary
> 
> and the git URL
> 
> git://git.balabit.hu/bazsi/tproxy-test.git
> 

I thought is was something like that. Thanks.
This is going to be helpful testing the various distro packages to see 
whats they have turned on/off. The newest FAQ for our users.

AYJ
