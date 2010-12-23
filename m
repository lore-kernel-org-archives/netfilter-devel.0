From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Thu, 23 Dec 2010 20:35:11 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012232008520.6582@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0CC3BB.8030801@googlemail.com> <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu> <4D0D2CF4.5070201@googlemail.com> <alpine.DEB.2.00.1012190105460.11753@blackhole.kfki.hu>
 <4D0E0E2A.3090604@googlemail.com> <4D0E22A5.8090808@conversis.de> <4D0E3B34.7090105@googlemail.com> <alpine.DEB.2.00.1012221146060.3482@blackhole.kfki.hu> <4D11F384.3070908@googlemail.com> <alpine.DEB.2.00.1012231558390.6044@blackhole.kfki.hu>
 <4D138C02.3050905@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Dennis Jacobfeuerborn <dennisml@conversis.de>,
	netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:49330 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab0LWTfM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Dec 2010 14:35:12 -0500
In-Reply-To: <4D138C02.3050905@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 23 Dec 2010, Mr Dash Four wrote:

> > The algorithm does not allow to ignore the protocol part. That's the reason
> > why double lookup would be needed if such syntactic sugar as 'tcpudp' were
> > introduced. Lets assume we store in the artifical set above two elements:
> > 
> > 192.168.0.1,tcpudp:53
> > 192.168.0.1,tcp:80
> > 
> > Now, assuming that first 'tcpudp' is looked up, to match the first element,
> > we need one lookup. To check the existence of the second element, we have to
> > use two lookups: first with '192.168.0.1,tcpudp:80' (nomatch),
> > then with '192.168.0.1,tcp:80'. And to check the existence of any
> > non-matching element (say 192.168.0.1,udp:123) needs again two lookups.
> >   
> Then your matching algorithm is wrong!

You are free to design and implement a better one.
 
> Using your example above, I'd add the following change: the protocol specifier
> could be converted (internally) to a number: 1 - tcp (1 in binary form), 2 -
> udp (10 in binary form), 3 - 'tcp and udp' (11 in binary form). When you need
> to match against a real protocol (which, if I am not mistaken, can only be
> either tcp or udp), then you can use binary 'and' operation (&) with one
> simple statement to determine whether there is a match. Using your example
> above, we will have the following (internal) representation:
> 
> 192.168.0.1,3,53
> 192.168.0.1,1,80
> 
> Thus, to check for 192.168.0.1:53 (tcp) - there will be a match as when you
> apply 1) ip match; and 2) protocol match - i.e. 1 & 3 (1 & 11) you will get
> >0, therefore protocol matches; and 3) port match, there is a match on all 3
> elements, hence return a complete match. Just one lookup needed.

Yes, assuming that first you lookup the IP address, then lookup the 
protocoll and then the port. That's three successive lookups, not one.

The implementation behind ipset looks up the  (ipaddr, proto, port) triple 
in one step. Such packing don't work there.
 
> > > You already mentioned DNS, I'd add DHCP to that list as well as VPN, IPSec
> > > and Kerberos traffic, which could be either tcp or udp on the same port
> > > numbers.     
> > 
> > DHCP uses UDP only.
> You are mistaken - DHCPv6 (client as well as server configurations) uses both
> TCP and UDP protocols on the same port numbers.

I run dibbler DHCPv6 server. It listens on UDP with IPv6 only:

# lsof -i6|grep dibbler
dibbler-s 18060   root    5u  IPv6 13581079       UDP [ff02::1:2]:547 
dibbler-s 18060   root    6u  IPv6 13581082       UDP [ff02::1:2]:547 

The clients (Linux, Windows) work flawlessly without TCP.

> >  VPN (e.g OpenVPN) can be configured to use UDP or TCP, but not both at the
> > same time.
> You are assuming that I will have a single machine on which VPN is running,
> which, again, is an isolated case. When I have a central hub, which controls
> multiple subnets VPN packets can originate from (or be destined to) the same
> port numbers using TCP as well as UDP protocols.
> 
> >  For ipset point of view, IPSec is an independent (actually, two, AH and
> > ESP) protocol. Kerberos uses a couple of TCP and UDP ports, but not both
> > with the same port number (except for changing password under Windows, if
> > you have to support both the old and new interfaces).
> >   
> Again, not true and you are assuming I am running a single machine - that is
> not the case at all.
> 
> Kerberos remote login, change password (except klogin which uses tcp only),
> administration and kreg can all be ran using either tcp or udp on the same
> port numbers. As for IPSec - the situation is exactly the same - port 1293
> with either tcp or udp utilised.

I do not assume you run a single server. The point is, you know the IP 
addresses, protocols, ports. Had you iptables rules you had to enter so 
many rules as the addresses, protocols, ports dictate.
 
> > > VOIP (including STUN, RTP and SIP) is another example - not only the port
> > > numbers vary wildly within (usually) pre-defined group, but could utilise
> > > tcp as well as the udp protocol on these ports. IRC
> > >     
> > 
> > STUN uses a single port over TCP and UDP.
> Yep, that's right - both protocols could be used on the same port.
> 
> >  RTP may run over TCP but the majority of the applications uses UDP only.
> Again, utilising TCP is not as uncommon as you might think - TCP gives you
> better line quality when you have good (optical for example) network and it is
> also the preferred option when you utilise encrypted data streams. Same goes
> for SIP.
> 
> >  SIP is complex... IRC uses TCP only.
> >   
> IRC on Port 194, protocols could be either TCP or UDP, again, depending on the
> configuration. AOL instant messenger also utilises both tcp and udp protocols
> on the same port (531). 
> 
> > >  or even LDAP. Various databases (MySQL, PostgreSQL and Oracle to name a
> > > few) also utilise both protocols on the same port numbers.
> > >     
> > 
> > LDAP and *SQL use TCP only.
> >   
> Wrong again! Check the documentation for the databases I mentioned properly
> and you will see that MySQL could use 3306 utilising both tcp and udp
> protocols, PostgreSQL can also utilise both protocols on its common port
> (5432) and with the case of Oracle - although the commonly used Oracle port is
> 1521 it also utilises ports 2483 (for insecure) and 2484 (for secure) client
> connections replacing the 'old' 1521 port for insecure client connections.

Our mySQL servers seem to listen on TCP only. Out of curiosity I checked 
the manuals and it states TCP only for listening on.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
