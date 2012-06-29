From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/3] nfnetlink: Unlock a previously locked rcu_read in
 nfnetlink_rcv_msg
Date: Fri, 29 Jun 2012 13:13:39 +0200
Message-ID: <20120629111339.GB15598@1984>
References: <1340888269-4926-1-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1340888269-4926-4-git-send-email-tomasz.bursztyka@linux.intel.com>
 <1340890210.13187.100.camel@edumazet-glaptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33517 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751252Ab2F2LNn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jun 2012 07:13:43 -0400
Content-Disposition: inline
In-Reply-To: <1340890210.13187.100.camel@edumazet-glaptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 28, 2012 at 03:30:10PM +0200, Eric Dumazet wrote:
> On Thu, 2012-06-28 at 15:57 +0300, Tomasz Bursztyka wrote:
> > Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
> > ---
> >  net/netfilter/nfnetlink.c |    4 +++-
> >  1 files changed, 3 insertions(+), 1 deletions(-)
> > 
> > diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
> > index 4acdd76..a6366ae 100644
> > --- a/net/netfilter/nfnetlink.c
> > +++ b/net/netfilter/nfnetlink.c
> > @@ -169,8 +169,10 @@ replay:
> >  
> >  		err = nla_parse(cda, ss->cb[cb_id].attr_count,
> >  				attr, attrlen, ss->cb[cb_id].policy);
> > -		if (err < 0)
> > +		if (err < 0) {
> > +			rcu_read_unlock();
> >  			return err;
> > +		}
> >  
> >  		if (nc->call_rcu) {
> >  			err = nc->call_rcu(net->nfnl, skb, nlh,
> 
> Nice catch, thanks.
> 
> Please someone add in changelog to ease stable team work :
> 
> Bug added in commit 6b75e3e8d664a9a (netfilter: nfnetlink: add RCU in
> nfnetlink_rcv_msg())
> 
> Acked-by: Eric Dumazet <edumazet@google.com>

Applied, thanks.
