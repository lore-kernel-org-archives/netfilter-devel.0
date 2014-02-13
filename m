From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH ipset 1/2] lib: fix ifname 'physdev:' prefix parsing
Date: Thu, 13 Feb 2014 12:01:01 +0100
Message-ID: <20140213110101.GF25153@breakpoint.cc>
References: <1392197240-9389-1-git-send-email-fw@strlen.de>
 <alpine.DEB.2.10.1402131105220.16734@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42823 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751687AbaBMLBE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 13 Feb 2014 06:01:04 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1402131105220.16734@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> Hi Florian,
> 
> On Wed, 12 Feb 2014, Florian Westphal wrote:
> 
> > hash:net,iface supports matching on the bridge port as well,
> > but userspace currently doesn't handle it correctly as it passes
> > in 'physdev:eth0' instead of 'eth0'+IPSET_OPT_PHYSDEV.
> 
> I think the userspace does handle the case: looking at your patch, it's
> exactly the same as the original one. It is nicer, so I'm happy to apply 
> it, but the description - as far as I see - doesn't fit.

It will expand to

if (strcmp("physdev:eth0", "physdev:") == 0)

which is not true.
