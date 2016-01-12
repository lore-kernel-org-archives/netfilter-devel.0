From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf] ipset: allow a 0 netmask with hash_netiface type
Date: Tue, 12 Jan 2016 20:53:23 +0100
Message-ID: <20160112195323.GB17166@breakpoint.cc>
References: <1452614825-19749-1-git-send-email-fw@strlen.de>
 <alpine.DEB.2.10.1601122046240.19324@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:58709 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751626AbcALTx0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jan 2016 14:53:26 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1601122046240.19324@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik <kadlec@blackhole.kfki.hu> wrote:
> Hi Florian,
> 
> On Tue, 12 Jan 2016, Florian Westphal wrote:
> 
> > Jozsef says:
> >  The correct behaviour is that if we have
> >  ipset create test1 hash:net,iface
> >  ipset add test1 0.0.0.0/0,eth0
> >  iptables -A INPUT -m set --match-set test1 src,src
> > 
> >  then the rule should match for any traffic coming in through eth0.
> > 
> > This removes the -EINVAL runtime test to make matching work
> > in case packet arrived via the specified interface.
> 
> No, the patch actually would break the set type. In order to support /0 
> prefixes, cidr + 1 is stored internally. Zero value means "empty 
> slot/bucket".

Hmm, but matching is broken currently, the rule quoted above never
matches.  And its exaclty because of if (e.cidr == 0) is true.

Tested with nf-next tree.
Before patch: never matches
After patch: matches for all packets from eth0
