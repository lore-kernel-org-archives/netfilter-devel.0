From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: [PATCH 00/11] TProxy for IPv6
Date: Tue, 08 Sep 2009 18:42:26 +0000
Message-ID: <1252435346.32029.44.camel@bzorp.balabit>
References: <cover.1251295408.git.bazsi@balabit.hu>
	 <4AA0AE8C.30203@treenet.co.nz>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, tproxy@lists.balabit.hu,
	Harry Mason <harry.mason@smoothwall.net>
To: Amos Jeffries <squid3@treenet.co.nz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from support.balabit.hu ([195.70.41.86]:34091 "EHLO lists.balabit.hu"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752483AbZIHSmb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Sep 2009 14:42:31 -0400
Received: from balabit.hu (unknown [10.80.0.254])
	by lists.balabit.hu (Postfix) with ESMTP id 50DE413A1DB
	for <netfilter-devel@vger.kernel.org>; Tue,  8 Sep 2009 20:42:31 +0200 (CEST)
In-Reply-To: <4AA0AE8C.30203@treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 2009-09-04 at 18:07 +1200, Amos Jeffries wrote:
> Balazs Scheidler wrote:
> > [ Sorry if this reaches you twice, I sent to the wrong address the first time ]
> > 
> > I've just pushed a set of patches that implement TProxy for IPv6 to
> > 
> > http://git.balabit.hu/bazsi/tproxy-2.6.git
> > 
> > The patches are also posted in reply to this mail.
> > 
> > Although some work is still needed, basic testing shows that it works all
> > right.  
> > 
> > The accompanying iptables patches are available at
> > 
> > http://git.balabit.hu/bazsi/iptables-tproxy.git
> > 
> > There are some things left to do:
> > 
> >   * the recognition of related ICMPv6 packets missing (from xt_socket.c)
> > 
> >   * I should probably split xt_TPROXY/xt_socket to IPv4 and IPv6 modules, as
> >     right now those depend on both stacks at the same time.
> > 
> > I'm on a holiday right now, thus I might not respond to comments in a timely
> > manner, however I'm interested in any comments/feedback nevertheless.
> > 
> > Harry, I didn't remember that you actually wanted to work on TProxy for
> > IPv6, I just vaguely remembered that there was someone asking for IPv6
> > support, thus I implemented this without being in the know.  If you started
> > hacking, I hope that we didn't completely duplicate effort.  I'd appreciate
> > help in the missing bits and/or testing whichever fits you best.
> > 
> > Also, I have written a Python test script to test TProxy functionality
> > automatically both for IPv4 and IPv6, I can post that as well if anyone is
> > interested.
> 
> I'm interested :)
> 
> Now that you have done this I'm going to have to find a robust userland 
> run-time test to see if the underlying TPROXY is v4-only or v6-enabled. 
> If anyone has suggestions they would be welcome.
> 
> Thank you very much by the way.

The script I wrote is not a runtime test, it is a functional test that
tests various TPROXY scenarios for proper functionality.

It basically assumes that:
  1) you run it on the 'client' host, and it has ssh connectivity to the
'tproxy' host
  2) it assumes that IP/route configuration is already prepared
  3) it uses hardwired IP addresses, but generates iptables/ip6tables
rules automatically

I used a virtual machine running on my development computer to do the
testing.

IPV6 topology:

dead:1::1/64 is the client
dead:1::2/64 is the proxy box
dead:2::1/64 is the server behind the proxy box

The script basically copies an agent script to the other box
(test-agent.py) and uses that to change iptables config/start listeners
as needed. Then initiates tcp/udp connections to the target host and
checks if the proper listener received the new connection or a bogus
one.

I'm not that responsive these days, but I'm glad to help.

Last but not least, here's the gitweb interface:

http://git.balabit.hu/?p=bazsi/tproxy-test.git;a=summary

and the git URL

git://git.balabit.hu/bazsi/tproxy-test.git


-- 
Bazsi


