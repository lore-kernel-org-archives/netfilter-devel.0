From: Amos Jeffries <squid3@treenet.co.nz>
Subject: Re: [PATCH 00/11] TProxy for IPv6
Date: Fri, 04 Sep 2009 18:07:08 +1200
Message-ID: <4AA0AE8C.30203@treenet.co.nz>
References: <cover.1251295408.git.bazsi@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu,
	Harry Mason <harry.mason@smoothwall.net>
To: Balazs Scheidler <bazsi@balabit.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ip-58-28-153-233.static-xdsl.xnet.co.nz ([58.28.153.233]:51443
	"EHLO treenet.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935408AbZIDGQN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Sep 2009 02:16:13 -0400
In-Reply-To: <cover.1251295408.git.bazsi@balabit.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Balazs Scheidler wrote:
> [ Sorry if this reaches you twice, I sent to the wrong address the first time ]
> 
> I've just pushed a set of patches that implement TProxy for IPv6 to
> 
> http://git.balabit.hu/bazsi/tproxy-2.6.git
> 
> The patches are also posted in reply to this mail.
> 
> Although some work is still needed, basic testing shows that it works all
> right.  
> 
> The accompanying iptables patches are available at
> 
> http://git.balabit.hu/bazsi/iptables-tproxy.git
> 
> There are some things left to do:
> 
>   * the recognition of related ICMPv6 packets missing (from xt_socket.c)
> 
>   * I should probably split xt_TPROXY/xt_socket to IPv4 and IPv6 modules, as
>     right now those depend on both stacks at the same time.
> 
> I'm on a holiday right now, thus I might not respond to comments in a timely
> manner, however I'm interested in any comments/feedback nevertheless.
> 
> Harry, I didn't remember that you actually wanted to work on TProxy for
> IPv6, I just vaguely remembered that there was someone asking for IPv6
> support, thus I implemented this without being in the know.  If you started
> hacking, I hope that we didn't completely duplicate effort.  I'd appreciate
> help in the missing bits and/or testing whichever fits you best.
> 
> Also, I have written a Python test script to test TProxy functionality
> automatically both for IPv4 and IPv6, I can post that as well if anyone is
> interested.

I'm interested :)

Now that you have done this I'm going to have to find a robust userland 
run-time test to see if the underlying TPROXY is v4-only or v6-enabled. 
If anyone has suggestions they would be welcome.

Thank you very much by the way.


Amos Jeffries
Squid Proxy Project

