From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 1/1] netfilter: fix soft lockup when netlink adds new
 entries
Date: Fri, 24 Feb 2012 11:09:44 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1202241104580.14329@blackhole.kfki.hu>
References: <1329832437-8733-1-git-send-email-kadlec@blackhole.kfki.hu> <1329832437-8733-2-git-send-email-kadlec@blackhole.kfki.hu> <20120221145234.GB25826@1984> <alpine.DEB.2.00.1202211601090.8952@blackhole.kfki.hu> <20120223101250.GA3547@1984>
 <alpine.DEB.2.00.1202231334060.12151@blackhole.kfki.hu> <20120223154646.GA4790@1984> <alpine.DEB.2.00.1202232137220.13020@blackhole.kfki.hu> <20120224012449.GA7005@1984> <alpine.DEB.2.00.1202240850220.14113@blackhole.kfki.hu> <20120224095959.GA9127@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org,
	Zambo Marcell <marcell.zambo@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:36230 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709Ab2BXKJp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Feb 2012 05:09:45 -0500
In-Reply-To: <20120224095959.GA9127@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 24 Feb 2012, Pablo Neira Ayuso wrote:

> On Fri, Feb 24, 2012 at 09:06:37AM +0100, Jozsef Kadlecsik wrote:
> > 
> > On Fri, 24 Feb 2012, Pablo Neira Ayuso wrote:
> > 
> > > On Thu, Feb 23, 2012 at 09:44:21PM +0100, Jozsef Kadlecsik wrote:
> > > > OK, here it comes:
> > > > 
> > > > The previous patch with the title "netfilter: fix soft lockup
> > > > when netlink adds new entries" introduced a race: conntrack and
> > > > ctnetlink could insert the same entry twice into the hash table.
> > > > The patch eliminates the race condition by using the same checking
> > > > as conntrack confirm does.
> > > > 
> > > > Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
> > > > ---
> > > >  include/net/netfilter/nf_conntrack.h |    2 +
> > > >  net/netfilter/nf_conntrack_core.c    |   41 ++++++++++++++++++++++++++++++++++
> > > >  net/netfilter/nf_conntrack_netlink.c |    9 +++----
> > > >  3 files changed, 47 insertions(+), 5 deletions(-)
> > > > 
> > > > diff --git a/include/net/netfilter/nf_conntrack.h b/include/net/netfilter/nf_conntrack.h
> > > > index 8a2b0ae..48bfe75 100644
> > > > --- a/include/net/netfilter/nf_conntrack.h
> > > > +++ b/include/net/netfilter/nf_conntrack.h
> > > > @@ -210,6 +210,8 @@ __nf_conntrack_find(struct net *net, u16 zone,
> > > >  		    const struct nf_conntrack_tuple *tuple);
> > > >  
> > > >  extern void nf_conntrack_hash_insert(struct nf_conn *ct);
> > > > +extern int nf_conntrack_hash_check_insert(struct net *net, u16 zone,
> > > > +					  struct nf_conn *ct);
> > > 
> > > nf_conntrack_hash_insert has no clients anymore after this change.
[...]
> I see. Go ahead then.

OK, and I remove nf_conntrack_hash_insert then, and use a single ct 
argument because as you noted net and zone can be extracted from the ct.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
