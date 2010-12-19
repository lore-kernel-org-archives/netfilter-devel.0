From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sun, 19 Dec 2010 01:34:43 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012190105460.11753@blackhole.kfki.hu>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <4D0CC3BB.8030801@googlemail.com> <alpine.DEB.2.00.1012182050280.11577@blackhole.kfki.hu> <4D0D2CF4.5070201@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:55253 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290Ab0LSAep (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 19:34:45 -0500
In-Reply-To: <4D0D2CF4.5070201@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, 18 Dec 2010, Mr Dash Four wrote:

> Would it be possible to have 'something', which disregards the protocol on
> port matching?
> 
> By 'something' I mean either omission of the protocol, or 'all' to be
> specified instead of the protocol to mean no matching on protocol would be
> made (in other words the protocol to be disregarded). This will be especially
> useful for sets with quite a few number of members and will avoid unnecessary
> duplication - as things stand I have to add the same number of members for
> both tcp and udp protocols when I don't need any protocol matching - just the
> subnets and port numbers I specified. Is this doable?

Use set types without port sub-part, like hash:net or hash:ip, etc.
I don't really see why you would want to use a type with port and then 
ignore it.

> > In order to support kernel versions below 2.6.31, I had to add a lot of
> > #ifdefs in xt_set.c to support the countless API changes in netfilter
> > targets and matches. Hm, maybe I could support kernel releases from 2.6.24.
> > Below 2.6.24 there are missing netlink definitions as Jan mentioned.
> >   
> The way I see it, it is best to leave 4.x tree for versions up to 2.6.24 and
> leave 5.x for newer versions and then decide whether the netlink patch should
> be applied (my understanding is that if the kernel version is >= 2.6.31 the
> patch definitely needs to be applied - is that right?).

The patch need to be applied below as well. And another version is 
required for kernels before the osf match was applied.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
