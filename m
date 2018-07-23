From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netlink: fix memory leak of dump
Date: Mon, 23 Jul 2018 11:38:55 +0200
Message-ID: <20180723093855.c4ncixsnkee6r34v@salvia>
References: <20180722143354.23722-1-cscnull@gmail.com>
 <20180722163925.gdfkndldatsoae6x@breakpoint.cc>
 <20180722.100755.19840167505550163.davem@davemloft.net>
 <20180722180910.wcwhantwpm2nfxet@breakpoint.cc>
 <20180723091551.mwhltw4ujm4bylvj@salvia>
 <20180723092818.ztsfsnqzxgzrauim@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, cscnull@gmail.com,
        kadlec@blackhole.kfki.hu, johannes.berg@intel.com, Jason@zx2c4.com,
        ktkhai@virtuozzo.com, lucien.xin@gmail.com,
        xiyou.wangcong@gmail.com, dsahern@gmail.com,
        netfilter-devel@vger.kernel.org, tom@quantonium.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180723092818.ztsfsnqzxgzrauim@breakpoint.cc>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jul 23, 2018 at 11:28:18AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
> > > --- a/net/netfilter/nf_tables_api.c
> > > +++ b/net/netfilter/nf_tables_api.c
> > > @@ -5010,6 +5013,22 @@ nft_obj_filter_alloc(const struct nlattr * const nla[])
> > >  	return filter;
> > >  }
> > >  
> > > +static int nf_tables_dump_obj_start(struct netlink_callback *cb)
> > > +{
> > > +	const struct nlattr * const *nla = cb->data;
> 
> On-Stack input.
> I can't see how its wrong, ->start() happens from same context as
> netlink_dump_start so its valid.
> 
> > > +	struct nft_obj_filter *filter = NULL;
> > > +
> > > +	if (nla[NFTA_OBJ_TABLE] ||
> > > +	    nla[NFTA_OBJ_TYPE]) {
> > > +		filter = nft_obj_filter_alloc(nla);
> > > +		if (IS_ERR(filter))
> > > +			return -ENOMEM;
> > > +	}
> > > +
> > > +	cb->data = filter;
> 
> And this replaced the on-stack input with dynamically
> allocated one, which will be free'd via ->done().
> 
> > >  /* called with rcu_read_lock held */
> > >  static int nf_tables_getobj(struct net *net, struct sock *nlsk,
> > >  			    struct sk_buff *skb, const struct nlmsghdr *nlh,
> > > @@ -5028,21 +5047,13 @@ static int nf_tables_getobj(struct net *net, struct sock *nlsk,
> > >  
> > >  	if (nlh->nlmsg_flags & NLM_F_DUMP) {
> > >  		struct netlink_dump_control c = {
> > > +			.start = nf_tables_dump_obj_start,
> > >  			.dump = nf_tables_dump_obj,
> > >  			.done = nf_tables_dump_obj_done,
> > >  			.module = THIS_MODULE,
> > > +			.data = (void *)nla,
> > 
> > You cannot do this.
> > 
> > nla is allocated in this stack.
> 
> Yes.
> 
> > the nla will not be available in the second recv(), it won't be there.
> 
> Its replaced in ->start().
> 
> As David pointed out, once ->start() returns 0 we set cb_running, i.e.
> only after successful ->start() netlink core will call ->dump() again.
> 
> So I see no problem setting ->data to onstack cookie and then
> duplicating it to heap via kmemdup in ->start().
> 
> As far as I can see netlink core offers all functionality already,
> so we only need to switch netfilter to make use of it.
> 
> If you disagree please let me know, otherwise I will cook up
> a patch along this pattern for net/netfilter/*.

Why not just call ->done from netlink_dump_start() when it fails?
