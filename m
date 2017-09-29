From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: ipset: Fix race between dump and swap
Date: Fri, 29 Sep 2017 12:15:44 +0200
Message-ID: <20170929101544.GA2427@salvia>
References: <20170927090627.26355-1-ross.lagerwall@citrix.com>
 <alpine.DEB.2.11.1709281230100.24013@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Ross Lagerwall <ross.lagerwall@citrix.com>,
        netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from [213.95.27.120] ([213.95.27.120]:58893 "EHLO
        ganesha.gnumonks.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1751994AbdI2KRT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 29 Sep 2017 06:17:19 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.11.1709281230100.24013@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 28, 2017 at 12:31:02PM +0200, Jozsef Kadlecsik wrote:
> On Wed, 27 Sep 2017, Ross Lagerwall wrote:
> 
> > Fix a race between ip_set_dump_start() and ip_set_swap().
> > The race is as follows:
> > * Without holding the ref lock, ip_set_swap() checks ref_netlink of the
> >   set and it is 0.
> > * ip_set_dump_start() takes a reference on the set.
> > * ip_set_swap() does the swap (even though it now has a non-zero
> >   reference count).
> > * ip_set_dump_start() gets the set from ip_set_list again which is now a
> >   different set since it has been swapped.
> > * ip_set_dump_start() calls __ip_set_put_netlink() and hits a BUG_ON due
> >   to the reference count being 0.
> > 
> > Fix this race by extending the critical region in which the ref lock is
> > held to include checking the ref counts.
> > 
> > The race can be reproduced with the following script:
> >   while :; do
> >     ipset destroy hash_ip1
> >     ipset destroy hash_ip2
> >     ipset create hash_ip1 hash:ip family inet hashsize 1024 \
> >         maxelem 500000
> >     ipset create hash_ip2 hash:ip family inet hashsize 300000 \
> >         maxelem 500000
> >     ipset create hash_ip3 hash:ip family inet hashsize 1024 \
> >         maxelem 500000
> >     ipset save &
> >     ipset swap hash_ip3 hash_ip2
> >     ipset destroy hash_ip3
> >     wait
> >   done
> > 
> > Signed-off-by: Ross Lagerwall <ross.lagerwall@citrix.com>
> 
> Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> 
> Good catch, Pablo please apply in the nf tree. Thanks!

Thanks a lot Jozsef. This is applied in the nf tree.
