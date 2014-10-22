From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [patch] netfilter: ipset: off by one in ip_set_nfnl_get_byindex()
Date: Wed, 22 Oct 2014 14:11:25 +0200
Message-ID: <20141022121125.GA25804@salvia>
References: <20141021082812.GB28426@mwanda>
 <alpine.DEB.2.10.1410211146160.27469@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	Jiri Kosina <jkosina@suse.cz>,
	Ilia Mirkin <imirkin@alum.mit.edu>,
	Sergey Popovich <popovich_sergei@mail.ru>,
	Joe Perches <joe@perches.com>,
	Anton Danilov <littlesmilingcloud@gmail.com>,
	stephen hemminger <stephen@networkplumber.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	kernel-janitors@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1410211146160.27469@blackhole.kfki.hu>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, Oct 21, 2014 at 11:51:12AM +0200, Jozsef Kadlecsik wrote:
> On Tue, 21 Oct 2014, Dan Carpenter wrote:
> 
> > The ->ip_set_list[] array is initialized in ip_set_net_init() and it
> > has ->ip_set_max elements so this check should be >= instead of >
> > otherwise we are off by one.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > I am not very familiar with this code, so please review cautiously.
> > This is an old bug which should go to -stable.
> > 
> > diff --git a/net/netfilter/ipset/ip_set_core.c b/net/netfilter/ipset/ip_set_core.c
> > index 912e5a0..86f9d76 100644
> > --- a/net/netfilter/ipset/ip_set_core.c
> > +++ b/net/netfilter/ipset/ip_set_core.c
> > @@ -659,7 +659,7 @@ ip_set_nfnl_get_byindex(struct net *net, ip_set_id_t index)
> >  	struct ip_set *set;
> >  	struct ip_set_net *inst = ip_set_pernet(net);
> >  
> > -	if (index > inst->ip_set_max)
> > +	if (index >= inst->ip_set_max)
> >  		return IPSET_INVALID_ID;
> >  
> >  	nfnl_lock(NFNL_SUBSYS_IPSET);
> > 
> 
> Absolutely right and it should go to stable too!
> 
> Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Applied, thanks.

My script says this applies cleanly to:

3.14.x
3.16.x
3.17.x

So I'll enqueue this for those.
