From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next] netfilter: conntrack: don't acquire lock during
 seq_printf
Date: Thu, 14 Apr 2016 14:39:12 +0200
Message-ID: <20160414123912.GE3192@breakpoint.cc>
References: <1460402069-22101-1-git-send-email-fw@strlen.de>
 <20160414094346.GA2056@salvia>
 <20160414100542.GA2644@salvia>
 <20160414111656.GC3192@breakpoint.cc>
 <20160414122759.GA11700@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:41916 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754530AbcDNMjP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2016 08:39:15 -0400
Content-Disposition: inline
In-Reply-To: <20160414122759.GA11700@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Apr 14, 2016 at 01:16:56PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > >  net/netfilter/nf_conntrack_proto_sctp.c | 8 +-------
> > > >  net/netfilter/nf_conntrack_proto_tcp.c  | 8 +-------
> > > >  2 files changed, 2 insertions(+), 14 deletions(-)
> > > > 
> > > > diff --git a/net/netfilter/nf_conntrack_proto_sctp.c b/net/netfilter/nf_conntrack_proto_sctp.c
> > > > index 9578a7c..1d7ab96 100644
> > > > --- a/net/netfilter/nf_conntrack_proto_sctp.c
> > > > +++ b/net/netfilter/nf_conntrack_proto_sctp.c
> > > > @@ -191,13 +191,7 @@ static void sctp_print_tuple(struct seq_file *s,
> > > >  /* Print out the private part of the conntrack. */
> > > >  static void sctp_print_conntrack(struct seq_file *s, struct nf_conn *ct)
> > > >  {
> > > > -	enum sctp_conntrack state;
> > > > -
> > > > -	spin_lock_bh(&ct->lock);
> > > > -	state = ct->proto.sctp.state;
> > > 
> > > Don't we need at least READ_ONCE() here?
> > 
> > Why?
> > 
> > seq_printf(s, "%s ", sctp_conntrack_names[ct->proto.sctp.state]);
> > 
> > I think thats fine, where do you see a problem?
> 
> ct->proto.sctp.state may be modified from another cpu while reading
> this, is this read guaranteed to be atomic in any arch?

Yes, safe on all.  Only problem would be if we change
sctp.state to u64, we'd have to add locking for 32bit arches.

I can add a compiletime_assert_atomic_type() for this but I think its
not needed.

I don't feel strongly about it; if you prefer locking here just mark patch
as rejected.
