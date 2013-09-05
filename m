From: Oliver <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH v2] netfilter: ipset: refactor hash types to use address/cidr arrays.
Date: Fri, 06 Sep 2013 01:31:23 +0200
Message-ID: <1894701.xWd9IXYenT@gentoovm>
References: <1378232143-27406-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa> <24199506.ar3DiBo0cH@gentoovm> <alpine.DEB.2.00.1309041915390.8534@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:42604 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3IFBOa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Sep 2013 21:14:30 -0400
In-Reply-To: <alpine.DEB.2.00.1309041915390.8534@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 04 September 2013 19:20:35 Jozsef Kadlecsik wrote:

<snip>

> > > 
> > > -mtype_add_cidr(struct htype *h, u8 cidr, u8 nets_length)
> > > +mtype_add_cidr(struct htype *h, u8 cidr, u8 nets_length, u8 n)
> > 
> > Ok, I see what you were envisioning now - I'm not entirely sure if the
> > benefit of not having to modify the existing hash structs outweighs the
> > cost of having to insert special cases in the generic header -
> > especially now considering each hash only consists of a single struct
> > for each address family.
> 
> I committed and pushed it to the ipset git tree. The special cases are
> going to be enabled by #ifdef conditions, so the common case is kept as
> simple as possible.

Alright, I took a look at the changes - I'll wait for the extension cleanup 
then send out a rebased version of hash:net,net since that's presumably going 
to be the difference between having to declare struct combinations for the 
various extensions versus not having to do it. I'm very intrigued to see what 
you can come up with that's shorter than my rework :P

On a related note - I was thinking about the impact of recursively walking the 
CIDRs and it did occur to me that this operation is very parallelisable - 
however, I found that when I ran ipset -T on the set, the in-kernel code is 
running in an interrupt context (somehow, I couldn't see what made it like 
that), which means it's not possible to spin up kthreads (unless there's 
something that I don't know about) - when testing of an ipset is called via 
xt_set, is that also running in an interrupt context? if not, it could be 
parallelised quite nicely, which I anticipate would give some gains on 
multicore systems, and especially for IPv6, one would think.

Kind Regards,
Oliver.
