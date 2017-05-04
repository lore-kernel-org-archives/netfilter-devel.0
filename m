From: Phil Sutter <phil@nwl.cc>
Subject: Re: [nf-next PATCH] netfilter: nf_tables: Return info of added rules
 back to user space
Date: Thu, 4 May 2017 16:47:16 +0200
Message-ID: <20170504144716.GC20805@orbyte.nwl.cc>
References: <20170504123417.22088-1-phil@nwl.cc>
 <20170504133544.GB5607@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:47343 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751765AbdEDOrS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 May 2017 10:47:18 -0400
Content-Disposition: inline
In-Reply-To: <20170504133544.GB5607@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 04, 2017 at 03:35:44PM +0200, Pablo Neira Ayuso wrote:
> On Thu, May 04, 2017 at 02:34:17PM +0200, Phil Sutter wrote:
> > This allows user space to reliably match kernel generated handles with
> > added rules for reference.
> > 
> > Signed-off-by: Phil Sutter <phil@nwl.cc>
> > ---
> >  net/netfilter/nf_tables_api.c | 19 ++++++++++++++++++-
> >  1 file changed, 18 insertions(+), 1 deletion(-)
> > 
> > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > index 1c6482d2c4dcf..71bce5d024409 100644
> > --- a/net/netfilter/nf_tables_api.c
> > +++ b/net/netfilter/nf_tables_api.c
> > @@ -2142,6 +2142,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
> >  	struct nft_userdata *udata;
> >  	struct nft_trans *trans = NULL;
> >  	struct nft_expr *expr;
> > +	struct sk_buff *skb2;
> >  	struct nft_ctx ctx;
> >  	struct nlattr *tmp;
> >  	unsigned int size, i, n, ulen = 0, usize = 0;
> > @@ -2281,8 +2282,24 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
> >  		goto err3;
> >  	}
> >  	chain->use++;
> > -	return 0;
> >  
> > +	skb2 = alloc_skb(NLMSG_GOODSIZE, GFP_KERNEL);
> > +	if (!skb2) {
> > +		err = -ENOMEM;
> > +		goto err4;
> > +	}
> > +	err = nf_tables_fill_rule_info(skb2, net, NETLINK_CB(skb).portid,
> > +				       nlh->nlmsg_seq, NFT_MSG_NEWRULE, 0,
> > +				       nfmsg->nfgen_family, table, chain, rule);
> > +	if (err < 0)
> > +		goto err5;
> > +
> > +	return nlmsg_unicast(nlsk, skb2, NETLINK_CB(skb).portid);
> 
> You can achieve this already via NLM_F_ECHO.

Oh, thanks for the pointer!

Cheers, Phil
