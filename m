From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ipset: Increase the number of maximal sets
 automatically as needed
Date: Tue, 27 Nov 2012 15:09:25 +0100
Message-ID: <20121127140925.GA9089@1984>
References: <alpine.DEB.2.00.1211202017260.27297@blackhole.kfki.hu>
 <20121127104856.GA27734@1984>
 <alpine.DEB.2.00.1211271207300.14623@blackhole.kfki.hu>
 <20121127113353.GA30478@1984>
 <alpine.DEB.2.00.1211271246020.14623@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48606 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886Ab2K0OJc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:09:32 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1211271246020.14623@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 27, 2012 at 12:55:00PM +0100, Jozsef Kadlecsik wrote:
[...]
> > > > Why not just some specific operation to set a new ip_set_max value and
> > > > readjust the array of sets in that case? Thus, the user is in full
> > > > control of the maximum number of sets and we don't have to assume
> > > > anything.
> > > 
> > > That'd need another knob - this way the array is increased as needed.
> > > The user doesn't have to count the required sets in advance, just create.
> > 
> > Yes, that would require some new netlink command. I tend to prefer
> > explicit configuration options. My concern is that day someone will
> > come and say that 2^16 are not enough for them. Then, we'll have to
> > add some explicit upper limit and allow to modify it.
> 
> That'd be non trivial, because the whole array should then be replaced 
> with something else for faster access from user space when the set is 
> searched by name. The kernel always refers to the index.

I think the index is fine as a way to search.

> > But I'm all fine if you like it this way. We can just document that
> > the new maximum amount of sets 65536.
> 
> It's "documented" in the input range of the "Maximum number of IP 
> sets" configuration parameter in Kconfig. Should I add it explicitely to 
> the help text? Or directly to the title line?

Some information in the changelog would be sufficient.

Thanks.
