From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sun, 26 Dec 2010 21:09:33 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012262034390.10148@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0CC3BB.8030801@googlemail.com> <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu> <4D0D2CF4.5070201@googlemail.com> <alpine.DEB.2.00.1012190105460.11753@blackhole.kfki.hu>
 <4D0E0E2A.3090604@googlemail.com> <4D0E22A5.8090808@conversis.de> <4D0E3B34.7090105@googlemail.com> <alpine.DEB.2.00.1012221146060.3482@blackhole.kfki.hu> <4D11F384.3070908@googlemail.com> <alpine.DEB.2.00.1012231558390.6044@blackhole.kfki.hu>
 <4D138C02.3050905@googlemail.com> <alpine.DEB.2.00.1012232008520.6582@blackhole.kfki.hu> <4D13CBD8.3090007@googlemail.com> <alpine.DEB.2.00.1012232337070.7027@blackhole.kfki.hu> <alpine.DEB.2.00.1012232354510.7109@blackhole.kfki.hu> <4D13D60C.3020304@googlemail.com>
 <alpine.DEB.2.00.1012261125100.9618@blackhole.kfki.hu> <4D17475B.9000909@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dennis Jacobfeuerborn <dennisml@conversis.de>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:53841 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202Ab0LZUJf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 26 Dec 2010 15:09:35 -0500
In-Reply-To: <4D17475B.9000909@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 26 Dec 2010, Mr Dash Four wrote:

> > > OK, does that differ if I have hash:net,port set (I presume when listing
> > > with
> > > ipset -L you will show the net ranges -
> > > 192.168.0.0-192.168.0.0,tcp:80-82), is
> > > that right?
> > 
> > For net types the networks are not exploded, of course:
> > 
> > # ipset create test hash:net,port # ipset add test 192.168.0.0/30,tcp:80-82
> > # ipset list test
> > Name: test
> > Type: hash:net,port
> > Header: family inet hashsize 1024 maxelem 65536
> > Size in memory: 16856
> > References: 0
> > Members:
> > 192.168.0.0/30,tcp:80
> > 192.168.0.0/30,tcp:82
> > 192.168.0.0/30,tcp:81                                                             
> OK, it is much clearer to me now.
> 
> You are expanding the command line port ranges (80-82 in your example above)
> to add the underlying elements. Could you not do a similar arrangement for the
> protocol as well?
> 
> For example, if I execute "ipset add test 192.168.0.0/30,*:80-82" (or "all"
> instead of "*" if that is not possible) could you not expand that to represent
> the following elements:
> 
> 192.168.0.0/30,tcp,80
> ..
> 192.168.0.0/30,tcp,82
> 192.168.0.0/30,udp,80
> ..
> 192.168.0.0/30,udp,82

That won't go: tcp and udp are not the possible protocols alone, so by any 
reasonable syntax, '*' or 'all' should have to mean all protocols from 
/etc/protocols.
 
> It is not a perfect solution by any stretch, but at least it will save me the
> hassle, as with the introduction of the port ranges, of executing the
> statement twice each time I want to include net and port ranges without being
> interested in the protocol match.

What I could come up as something similar in effect is to make possible to 
use a copy of /etc/services maintained by the administrator of the given 
ipset installation and whatever protocols and ports a service name is
resolved to from that file, use those.

However such a feature won't be added tomorrow. Nor this year (:-) or the 
very near future.
 
> As an aside note: since this is a hash set I am assuming that you use hashes
> to do the match as hash matching is very fast. I also presume that is the main
> reason you expand the port ranges so that you can calculate the hashes for
> that particular element and then match it with the real
> ip/subnet,protocol,port.

Yes, that's the reason for the expansion.
 
> If that is the case how do you match subnets? In other words (using your
> example above) how do you match (the calculated hash for) 192.168.0.2,tcp:80
> against (the calculated hash for) 192.168.0.0/30,tcp:80 - they, on the face of
> it, will differ!

For the "net" (sub)type of sets the different prefixes in the set is 
recorded. When testing (adding/deleting) entries, the IP part of the entry 
is masked with the prefixes one by one and looked up until a match is 
found or the list is exhausted - that's why the speed is linearly slows 
down with the different number of prefixes added to the set. An example:

# ipset create test hash:net
# ipset add test 192.168.0.0/30
# ipset add test 192.168.1.0/24

There are two different prefixes in the set, 30, 24. So when the command 
is issued

# ipset test test 192.168.0.1

the address 192.168.0.1 is masked with /30 and the result is looked up 
and the match is reported:

192.168.0.1 is in set test.

If we want to test 192.168.1.1, then first it's masked with /30. Because 
there's no match, it's masked again by /24 then and now it's found:

root@teg:~/ipset/src# ./ipset test test 192.168.1.1                             
192.168.1.1 is in set test.

> > However please note, the "net" types slow down linearly with the number of
> > different network prefixes in the set.
> >   
> Is this slowdown more than when I use iptreemap set for example? How does the
> new set (hash) performance compares against the 'old' iptreemap/treemap sets
> used in 4.x?

I never measured the speed difference between the two types. A good guess 
is that iptreemap is faster. However, the problem with iptree(map) is that 
it's susceptible when used as a container to block attackers dynamically 
by the SET target: it's trivial to mount an attack by which the worst tree 
structure is forced to be created. Therefore iptree(map) was dropped at
ipset-5.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
