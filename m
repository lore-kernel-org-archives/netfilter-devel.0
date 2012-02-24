From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] netfilter: fix soft lockup when netlink adds new
 entries
Date: Fri, 24 Feb 2012 10:59:59 +0100
Message-ID: <20120224095959.GA9127@1984>
References: <1329832437-8733-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1329832437-8733-2-git-send-email-kadlec@blackhole.kfki.hu>
 <20120221145234.GB25826@1984>
 <alpine.DEB.2.00.1202211601090.8952@blackhole.kfki.hu>
 <20120223101250.GA3547@1984>
 <alpine.DEB.2.00.1202231334060.12151@blackhole.kfki.hu>
 <20120223154646.GA4790@1984>
 <alpine.DEB.2.00.1202232137220.13020@blackhole.kfki.hu>
 <20120224012449.GA7005@1984>
 <alpine.DEB.2.00.1202240850220.14113@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Zambo Marcell <marcell.zambo@gmail.com>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40454 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756690Ab2BXKAI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:00:08 -0500
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1202240850220.14113@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Feb 24, 2012 at 09:06:37AM +0100, Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> On Fri, 24 Feb 2012, Pablo Neira Ayuso wrote:
> 
> > On Thu, Feb 23, 2012 at 09:44:21PM +0100, Jozsef Kadlecsik wrote:
> > > OK, here it comes:
> > > 
> > > The previous patch with the title "netfilter: fix soft lockup
> > > when netlink adds new entries" introduced a race: conntrack and
> > > ctnetlink could insert the same entry twice into the hash table.
> > > The patch eliminates the race condition by using the same checking
> > > as conntrack confirm does.
> > > 
> > > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > > ---
> > >  include/net/netfilter/nf_conntrack.h |    2 +
> > >  net/netfilter/nf_conntrack_core.c    |   41 ++++++++++++++++++++++++++++++++++
> > >  net/netfilter/nf_conntrack_netlink.c |    9 +++----
> > >  3 files changed, 47 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> > > index 8a2b0ae..48bfe75 100644
> > > --- a/include/net/netfilter/nf_conntrack.h
> > > +++ b/include/net/netfilter/nf_conntrack.h
> > > @@ -210,6 +210,8 @@ __nf_conntrack_find(struct net *net, u16 zone,
> > >  		    const struct nf_conntrack_tuple *tuple);
> > >  
> > >  extern void nf_conntrack_hash_insert(struct nf_conn *ct);
> > > +extern int nf_conntrack_hash_check_insert(struct net *net, u16 zone,
> > > +					  struct nf_conn *ct);
> > 
> > nf_conntrack_hash_insert has no clients anymore after this change.
> > 
> > We have two choices here:
> > 
> > 1) Expand nf_conntrack_hash_insert to perform the checking inside. You can
> > use the same prototype btw, net and zone can be extracted from the ct.
> 
> It's a void function and we need a result: if the insert fails the
> newly allocated entry must be destroyed and error reported to the user.
>
> > 2) For better code readability (and we save one exported symbol), add
> > the code that you propose for nf_conntrack_hash_check_insert to
> > nf_conntrack_netlink.c. I don't think we would ever have another client
> > of nf_conntrack_hash_insert.
> 
> That'd need exporting hash_conntrack and __nf_conntrack_hash_insert from
> nf_conntrack_core.c. That was the reason why I instead introduced a new
> function.

I see. Go ahead then.

Thanks Jozsef.
