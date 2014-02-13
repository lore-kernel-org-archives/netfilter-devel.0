From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH ipset 1/2] lib: fix ifname 'physdev:' prefix parsing
Date: Thu, 13 Feb 2014 12:22:08 +0100 (CET)
Message-ID: <alpine.DEB.2.10.1402131218300.17109@blackhole.kfki.hu>
References: <1392197240-9389-1-git-send-email-fw@strlen.de> <alpine.DEB.2.10.1402131105220.16734@blackhole.kfki.hu> <20140213110101.GF25153@breakpoint.cc>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:59918 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198AbaBMLWM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:22:12 -0500
In-Reply-To: <20140213110101.GF25153@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 13 Feb 2014, Florian Westphal wrote:

> Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> > 
> > On Wed, 12 Feb 2014, Florian Westphal wrote:
> > 
> > > hash:net,iface supports matching on the bridge port as well,
> > > but userspace currently doesn't handle it correctly as it passes
> > > in 'physdev:eth0' instead of 'eth0'+IPSET_OPT_PHYSDEV.
> > 
> > I think the userspace does handle the case: looking at your patch, it's
> > exactly the same as the original one. It is nicer, so I'm happy to apply 
> > it, but the description - as far as I see - doesn't fit.
> 
> It will expand to
> 
> if (strcmp("physdev:eth0", "physdev:") == 0)
> 
> which is not true.

Ohh, right. And then the whole string is passed to the kernel and 
therefore the "physdev:" part is kept at listing.

Patch is applied, thanks!

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
