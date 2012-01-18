From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.11 released
Date: Wed, 18 Jan 2012 23:53:56 +0000
Message-ID: <4F175B94.60001@googlemail.com>
References: <alpine.DEB.2.00.1201141542490.26282@blackhole.kfki.hu> <4F130A03.7080208@googlemail.com> <alpine.DEB.2.00.1201151825570.29134@blackhole.kfki.hu> <4F131551.2090608@googlemail.com> <alpine.DEB.2.00.1201152100050.29766@blackhole.kfki.hu> <4F135552.4070804@googlemail.com> <alpine.DEB.2.00.1201160914550.30763@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1201160914550.30763@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


> ipset is a tool to build up so called sets inside the Linux kernel.
I think I know what ipset is, thank you.

>  The 
> sets have any use in the kernel side only and there the kernel matches 
> single IP addresses and never whole networks.
>   
OK, I don't have intimate knowledge of the ipset code and its internal 
workings, but it obviously accepts IP ranges since if I have a hash:net 
set containing 10.1.0.0/16 for example and then test for that exact IP 
range (10.1.0.0/16) then the test returns true, so ipset obviously 
processes this IP range and returns a good result. How is that done if 
the kernel "matches single IP addresses and never whole networks" then?

One other thing: *if* ipset can only accept single IP addresses instead 
of IP ranges (I don't believe this to be the case, but anyway, if it 
does), then you could process a single IP address in a loop containing 
the whole range to be tested (10.1.12.0/24 in my example - i.e. looping 
from 10.1.12.0 until 10.1.12.255 inclusive) and bail out as soon as 
there is no match, which would then return 'false' (i.e. no match). You 
could even speed things up a bit by implementing batch processing of IP 
ranges internally (via a single kernel APIs instead of looping via ipset 
and calling the kernel API each time for a single IP address check).

I know this implementation is a bit crude, but since this testing takes 
place in userspace then this delay won't matter *that* much. How doable 
is that?

