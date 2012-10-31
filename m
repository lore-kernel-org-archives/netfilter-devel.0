From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset restore behavior with newer glibc
Date: Wed, 31 Oct 2012 20:07:44 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1210312005580.14998@blackhole.kfki.hu>
References: <50915160.1090908@akamai.com> <alpine.LNX.2.01.1210311737030.20899@nerf07.vanv.qr> <alpine.DEB.2.00.1210311904120.14824@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Josh Hunt <johunt@akamai.com>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:58624 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759780Ab2JaTHq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2012 15:07:46 -0400
In-Reply-To: <alpine.DEB.2.00.1210311904120.14824@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 31 Oct 2012, Jozsef Kadlecsik wrote:

> On Wed, 31 Oct 2012, Jan Engelhardt wrote:
> 
> > On Wednesday 2012-10-31 17:27, Josh Hunt wrote:
> > 
> > > When doing an ipset restore with newer versions of glibc I'm seeing 
> > > some extra syscall overhead that I was not seeing with glibc 2.4. I 
> > > was wondering if anyone has seen such behavior and could help me 
> > > understand what is going on?
> > >
> > > Here is a snippet of strace during the restore with glibc 2.4:
> > > http://pastebin.com/qxkPF7FB and one with glibc 2.7:
> > > http://pastebin.com/wga9SN0E
> > > I've also seen similar behavior with glibc 2.11.
> > >
> > > You'll notice that with the newer version a second netlink socket is created
> > > and it appears some data is sent and info received back from the kernel
> > 
> > I have observed such as well in other programs as well. Without
> > looking into this too deeply, I suspect that a program, or a library
> > on its behalf, is using the interface name<->index resolution
> > functions if_nametoindex(3) et al, for which netlink is used in
> > sufficiently new glibc where socket ioctls were (probably) used
> > previously. Could this be it?
> 
> ipset does not check interface names (except the length of the string), so 
> does not call if_nametoindex.
> 
> The extra syscalls come from "getaddrinfo", which is used by ipset to 
> parse every IP address. In eglibc 2.11 the implementation of "getaddrinfo" 
> contains the comment and the uncoditional call:
> 
>   /* We might need information about what interfaces are available.
>      Also determine whether we have IPv4 or IPv6 interfaces or both.  We
>      cannot cache the results since new interfaces could be added at
>      any time.  */
>   __check_pf (&seen_ipv4, &seen_ipv6, &in6ai, &in6ailen);
> 
> And indeed, __check_pf opens up a netlink socket, makes a request then 
> closes it.
> 
> I haven't checked the source code of glibc itself but I suppose it works 
> the same way.

It seems to me, the best is to add a stripped down version of 
"getaddrinfo" to ipset itself. That'll be the first library workaround...

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
