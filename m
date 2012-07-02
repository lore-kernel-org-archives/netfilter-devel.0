From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [ANNOUNCE] ipset 6.13 released
Date: Mon, 02 Jul 2012 14:11:29 +0100
Message-ID: <4FF19E01.6090400@googlemail.com>
References: <alpine.DEB.2.00.1206292201340.29738@blackhole.kfki.hu> <4FF02A93.8080603@googlemail.com> <alpine.DEB.2.00.1207011405160.2289@blackhole.kfki.hu> <4FF04038.4080306@googlemail.com> <alpine.DEB.2.00.1207011434010.2486@blackhole.kfki.hu> <4FF04647.7060807@googlemail.com> <alpine.DEB.2.00.1207011446260.2486@blackhole.kfki.hu> <4FF04DDA.3020609@googlemail.com> <alpine.DEB.2.00.1207011646110.2749@blackhole.kfki.hu> <f1ffdaf291ae86a1e111d3edbae4cfa3@treenet.co.nz> <alpine.DEB.2.00.1207020916030.4335@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Amos Jeffries <squid3@treenet.co.nz>, netfilter@vger.kernel.org,
	netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:57326 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751278Ab2GBNLe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:11:34 -0400
In-Reply-To: <alpine.DEB.2.00.1207020916030.4335@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> Maybe ASCII art helps better to explain the different views:
>
> - Mr Dash Four
>
>                      -----------
>   pkt comes in ----- | machine | ----- pkt goes out
>                    ^ ----------- ^
>                  destination   source
>
> - my view follows how the subsytem sees the interfaces
>
>                              ------------------
>   pkt comes in --- interface | ipset subsytem | interface --- pkt goes out
>                            ^ ------------------ ^
>                        source               destination
>
>   
How do you explain that the same "ipset subsystem" treats the IP address 
of the "source" interface (according to your diagram above) as 
"destination" when I match the same (incoming) packet above?

In other words, when I match a packet arriving on the "source" interface 
(again, according to the diagram above) against the IP address this 
"source" interface belongs to, I have to use "dst" designation, not 
"src", but when I match it against the interface then I have to use 
"src" instead? Also, how do you explain that the same designation 
(destination) applies for everything else but the hash:net,iface set for 
the same type of match (incoming packet)?

Give me a reasonable and coherent explanation and I'll accept your argument.

> "src" and "dst" are generic keywords of the set match and SET target of 
> iptables/ip6tables and independent of the set types. The match and target 
> have no idea what is "src" and "dst", the given set interprets them 
> according to the type.
>   
Regardless of whether the set match and SET target use these two 
keywords, across the whole netfilter terminology, there is consistency 
applied with the notable exception of the hash:net,iface and the "iface" 
part in particular.

