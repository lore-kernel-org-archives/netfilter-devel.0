From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: IS Mapping ipset to iptable chains possible
Date: Fri, 1 Oct 2010 11:53:05 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1010011150580.11563@blackhole.kfki.hu>
References: <AANLkTin81gLzh3iHbONkeAckWxc++WZtmuHXeFuMN6VT@mail.gmail.com> <alpine.DEB.2.00.1010010918510.11563@blackhole.kfki.hu> <AANLkTi=sX5DO2zGFESnxnwmZ4WZPEXr2F8khSd1BBADF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Anand Raj Manickam <anandrm@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:47578 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755054Ab0JAJxH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Oct 2010 05:53:07 -0400
In-Reply-To: <AANLkTi=sX5DO2zGFESnxnwmZ4WZPEXr2F8khSd1BBADF@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 1 Oct 2010, Anand Raj Manickam wrote:

> On Fri, Oct 1, 2010 at 12:50 PM, Jozsef Kadlecsik
> <kadlec@blackhole.kfki.hu> wrote:
> > On Fri, 1 Oct 2010, Anand Raj Manickam wrote:
> >
> >> I m just learning to use ipsets .
> >> I have a basic doubt
> >>
> >> Suppose i create a ipset
> >>
> >> ipset -N test ipmap --network 192.168.0.0/16
> >>
> >> add a few ips
> >> #ipset -A test 192.168.0.1
> >> ..
> >>
> >> if i want to have 1 chain per ip
> >>
> >> 192.168.0.1 to CHAIN1
> >> ..
> >> 192.168.0.100 to CHAIN100
> >
> > If you mean to store the IP addresses in a set and use it to "jump" to the
> > chains, then no, that's not possible.
> 
> Do you think its a good idea to create a ipset type ..
> 
> ipset -N test ipmapchain --network 192.168.0.0/16
> 
> ipset -A test 192.168.0.1 CHAIN1
> ..
> ipset -A test 192.168.0.100 CHAIN100
> 
> mabbe a new
> 
> iptables -A FORWARD -m set  --set test src,dst,chain
> 
> Please correct me if there are complications on this  idea or its
> nonsense to do this ;-)

It is not possible to create such a set type: there's no API, 
infrastructure to refer to a chain outside from netfilter.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
