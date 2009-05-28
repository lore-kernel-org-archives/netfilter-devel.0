From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP simultaneous open using iptables NAT?
Date: Thu, 28 May 2009 23:24:08 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0905282225200.28204@blackhole.kfki.hu>
References: <4ddb24250905271506qb50323etf3f7deb4e240ff72@mail.gmail.com>  <alpine.DEB.2.00.0905281014090.26723@blackhole.kfki.hu>  <4ddb24250905281258i68374aa6w858aaf088b96c1b9@mail.gmail.com> <4ddb24250905281300l5ca0a6fcse1f38d36f3d9abb8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Saatvik Agarwal <saatvik.agarwal@stanford.edu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4ddb24250905281300l5ca0a6fcse1f38d36f3d9abb8@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 28 May 2009, Saatvik Agarwal wrote:

> On 5/28/09, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> >  On Wed, 27 May 2009, Saatvik Agarwal wrote:
> >
> >  > For my research project in school, I am trying to establish TCP
> >  > connections when both hosts are behind full-cone NATs using TCP's
> >  > simultaneous open functionality. Unfortunately, it seems that iptables
> >   > does not support TCP simultaneous open. For my test environment, I
> >  > simulate a full-cone NAT using iptables. My iptables rule is exactly
> >  > as follows:
> >  >
> >  > iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
> >
> >
> > That rule cannot simulate full-cone NAT, because netfilter implements
> >  port-restricted cone NAT.
> 
> Would both SNAT and DNAT together simulate a full-cone NAT?

I think you could emulate full-cone NAT that way. But of course it is not 
a viable solution in practice because every rule has to be set up in 
advance and one can't handle all hosts behind the firewall.

As soon as you want to deal with more than one host behind the firewall, 
you'll hit the *practical* problem of clashing (the issue which is simply 
ignored in those BEHAVE RFCs). And because you haven't got as many IP 
addresses at the external side of the firewall as inside to map the 
internal addesses to (that is the very reason why NAT was needed), 
clashing will happen.

> >   > According to the BEHAVE requirements outlined in IETF RFC 5382, TCP
> >  > simultaneous open must be supported by "well behaved NATs". So is
> >  > there a mistake in my rules or does iptables not support simultaneous
> >   > open?
> >
> > The connection tracking subsystem does not support TCP simultaneous open.
> >
> >  As far as I'm concerned, I do not care whatever RFC is created in trying
> >  to push NAT over its limits - that is just a totally wrong track. NAT was
> >   invented solely to slow down the depletion of the IPv4 address space in
> >  the hope to give more time introducing and *deploying* IPv6 world-wide.
> >  And everyone was fully aware that NAT breaks one of the key concempts of
> >   IP, the end-to-end connectivity. These "NAT behavioral requirements" RFCs
> >  are the results of that breakage (and written exclusively from the point
> >  of view of the application designers).
> 
> Agreed. I was trying to develop a NAT traversal library solely for 
> application developers.

Application developers would do much more good for themselves by designing 
their applications with IPv6 support and clearly declaring: "Hey, if you 
have got IPv6 connectivity, you get the full power of the application, 
otherwise you may have to live with limitations, when being behind NAT." 
That way they could help in backing and spreading IPv6.

Please note, we (where I mean the whole Internet) are already too late in 
the transition to IPv6 - the IPv4 address space will have been depleted 
sooner than IPv6 will be deployed everywhere. And the "solutions" for the 
interregnum when there won't be allocatable IPv4 addresses and IPv6 is 
still not there everywhere are worse and worse. Which one would like to 
choose anyone?:

- Multilevel NATs at the ISPs (how will any NAT traversal cope with 
  *that*?)
- Much more stronger binding to the ISP - newcomers are forced to use
  the servers of the ISP to run any of their public services
- IPv4 address market (which is limited to the regions, otherwise the core 
  routers won't be able to cope with the inflation of the routing tables)

Don't need to pick: any or all of them will come, because we are too late. 
So in order to *minimize* the damage, everyone should work on the 
transition to IPv6 and not waste time on "fixing" the unfixable NAT.

> I guess I'll test with actual NATs/routers instead of iptables.

I'd be glad to see some summary on your findings with other NAT 
implementations.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
