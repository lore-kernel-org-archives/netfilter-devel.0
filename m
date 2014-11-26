From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 08/10] netfilter: ipset: Introduce RCU in all set types
 instead of rwlock per set
Date: Wed, 26 Nov 2014 18:18:08 +0100
Message-ID: <20141126171808.GC3585@salvia>
References: <1416862012-31139-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1416862012-31139-9-git-send-email-kadlec@blackhole.kfki.hu>
 <20141126131434.GA1671@salvia>
 <alpine.DEB.2.10.1411261538080.9422@blackhole.kfki.hu>
 <20141126154113.GD24801@breakpoint.cc>
 <alpine.DEB.2.10.1411261659030.9422@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53450 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752639AbaKZRP7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Nov 2014 12:15:59 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1411261659030.9422@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 26, 2014 at 05:01:39PM +0100, Jozsef Kadlecsik wrote:
> On Wed, 26 Nov 2014, Florian Westphal wrote:
> > 
> > I don't see why you'd need a special function otherwise, unless you
> > want some explicit documentation as to where you're changing/updating
> > content of structures protected by rcu.  But, in those sections you
> > already need to hold some type of lock, so I don't think its needed.
> 
> Hm, you are both right - I clean up this part as it's totally unnecessary, 
> these are not pointers, even indirectly.

Thanks.

Please, I'd appreciate if you send smaller batches for nf-next for
easier review. So instead of large batches, more frequent pull
requests if possible.
