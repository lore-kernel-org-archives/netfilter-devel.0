From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: cttimeout: remove VLA usage
Date: Tue, 13 Mar 2018 15:59:47 +0100
Message-ID: <20180313145947.tpekwvyioaft5auc@salvia>
References: <20180312231442.GA22071@embeddedgus>
 <1520899118.2049.24.camel@perches.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <garsilva@embeddedor.com>
To: Joe Perches <joe@perches.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1520899118.2049.24.camel@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Mar 12, 2018 at 04:58:38PM -0700, Joe Perches wrote:
> On Mon, 2018-03-12 at 18:14 -0500, Gustavo A. R. Silva wrote:
> > In preparation to enabling -Wvla, remove VLA and replace it
> > with dynamic memory allocation.
> > 
> > From a security viewpoint, the use of Variable Length Arrays can be
> > a vector for stack overflow attacks. Also, in general, as the code
> > evolves it is easy to lose track of how big a VLA can get. Thus, we
> > can end up having segfaults that are hard to debug.
> > 
> > Also, fixed as part of the directive to remove all VLAs from
> []
> > diff --git a/net/netfilter/nfnetlink_cttimeout.c b/net/netfilter/nfnetlink_cttimeout.c
> []
> > @@ -51,19 +51,27 @@ ctnl_timeout_parse_policy(void *timeouts,
> >  			  const struct nf_conntrack_l4proto *l4proto,
> >  			  struct net *net, const struct nlattr *attr)
> >  {
> > +	struct nlattr **tb;
> >  	int ret = 0;
> >  
> > -	if (likely(l4proto->ctnl_timeout.nlattr_to_obj)) {
> > -		struct nlattr *tb[l4proto->ctnl_timeout.nlattr_max+1];
> > +	if (!l4proto->ctnl_timeout.nlattr_to_obj)
> > +		return 0;
> 
> Why not
> 	if unlikely(!...)

This is control plane code - not packet path - I think we should just
let the compiler decide on this one, not really need to provide an
explicit hint here.
