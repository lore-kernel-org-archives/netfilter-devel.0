From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Mon, 27 Dec 2010 15:49:31 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012271517330.11100@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0CC3BB.8030801@googlemail.com> <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu> <4D0D2CF4.5070201@googlemail.com> <alpine.DEB.2.00.1012190105460.11753@blackhole.kfki.hu>
 <4D0E0E2A.3090604@googlemail.com> <4D0E22A5.8090808@conversis.de> <4D0E3B34.7090105@googlemail.com> <alpine.DEB.2.00.1012221146060.3482@blackhole.kfki.hu> <4D11F384.3070908@googlemail.com> <alpine.DEB.2.00.1012231558390.6044@blackhole.kfki.hu>
 <4D138C02.3050905@googlemail.com> <alpine.DEB.2.00.1012232008520.6582@blackhole.kfki.hu> <4D13CBD8.3090007@googlemail.com> <alpine.DEB.2.00.1012232337070.7027@blackhole.kfki.hu> <alpine.DEB.2.00.1012232354510.7109@blackhole.kfki.hu> <4D13D60C.3020304@googlemail.com>
 <alpine.DEB.2.00.1012261125100.9618@blackhole.kfki.hu> <4D17475B.9000909@googlemail.com> <alpine.DEB.2.00.1012262034390.10148@blackhole.kfki.hu> <4D17B730.8040505@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dennis Jacobfeuerborn <dennisml@conversis.de>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:47172 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753507Ab0L0Ote (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Dec 2010 09:49:34 -0500
In-Reply-To: <4D17B730.8040505@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 26 Dec 2010, Mr Dash Four wrote:

> > > You are expanding the command line port ranges (80-82 in your example
> > > above)
> > > to add the underlying elements. Could you not do a similar arrangement for
> > > the
> > > protocol as well?
> > >     
> > That won't go: tcp and udp are not the possible protocols alone, so by any
> > reasonable syntax, '*' or 'all' should have to mean all protocols from
> > /etc/protocols.
> >   
> Whatever the appropriate place holder is - 'all', '*', '@', '$$$$$$' etc. etc
> - as long as it does the job at the end it won't matter.

It does matter. Non-intuitive syntax and notation are bad. Moreover, the 
notation should be open to handle other protocols too (see below).
 
> > What I could come up as something similar in effect is to make possible to
> > use a copy of /etc/services maintained by the administrator of the given
> > ipset installation and whatever protocols and ports a service name is
> > resolved to from that file, use those.
> >   
> I wasn't aware that there are more than 2 (tcp and udp) protocols on which I
> could define/use ports!

sctp, udplite.

ICMP and ICMPv6 already interpreted as "proto":"port" by ipset, regardless 
that "port" is actually type and code.

> > However such a feature won't be added tomorrow. Nor this year (:-) or the
> > very near future.
> >   
> What are your plans?

Double check and triple check both the kernel and userspace of ipset 5. 
Get more feedback, especially from uncommon architecture. Submit for 
kernel inclusion. After that new features can be added.
 
> > For the "net" (sub)type of sets the different prefixes in the set is
> > recorded. When testing (adding/deleting) entries, the IP part of the entry
> > is masked with the prefixes one by one and looked up until a match is found
> > or the list is exhausted - that's why the speed is linearly slows down with
> > the different number of prefixes added to the set. An example:
> > 
> > # ipset create test hash:net
> > # ipset add test 192.168.0.0/30
> > # ipset add test 192.168.1.0/24
> > 
> > There are two different prefixes in the set, 30, 24. So when the command is
> > issued
> > 
> > # ipset test test 192.168.0.1
> > 
> > the address 192.168.0.1 is masked with /30 and the result is looked up and
> > the match is reported:
> >   
> So, in other words 'internally' you store something like (using your example
> above) 192.168.0.0 (the IP part), 30 (the prefix), tcp, 80 in the structure,
> is that right?

Yes, exactly.

> Do you then use the mask of each member of that set (30 and 24 in your example
> above) until you get a match? In other words, you 'walk through' every
> internally stored element and try their mask and then lookup for a match, is
> that how you do it?

Besides the elements, the different prefixes are also stored in the set. 
So the test set in the example "knows" that the prefixes 30 and 24 occur 
only and use only those to find a match, starting from the most speficic 
prefix to the least one.

> > However, the problem with iptree(map) is that it's susceptible when used as
> > a container to block attackers dynamically by the SET target: it's trivial
> > to mount an attack by which the worst tree structure is forced to be
> > created.
> Could you expand on that bit please? What do you mean?

The iptree(map) sets store the elements in a tree structure which follows 
the dotted decimal notation of the IPv4 addresses. Let's assume, someone 
catches attackers by a given match and stores their IP addresses in the 
iptree type of set called "attackers":

# If some matches are true, it's an attacker, store the address
...... -j SET attackers src
# Drop known attackers
.... -m set attackers src -j DROP

What I referred to was that it's not hard to send forged packets, which 
create the widest and least filled in (i.e. worst) tree structure. It does 
not slow down the set but pushes it to the worst memory usage case.

I regard it as a weakness of the type: an attacker must not be able to 
trigger any worst case situation of a set type intentionally.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
