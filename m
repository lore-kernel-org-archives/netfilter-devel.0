From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 12/31] netfilter: cttimeout: remove superfluous check on
 layer 4 netlink functions
Date: Fri, 2 Nov 2018 00:26:00 +0100
Message-ID: <20181101232600.mdgzmaccrhb73fho@salvia>
References: <20181008230125.2330-1-pablo@netfilter.org>
 <20181008230125.2330-13-pablo@netfilter.org>
 <46a2d5fe-ca45-c07b-2e2d-2ec99412dcb9@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
To: fw@strlen.de
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <46a2d5fe-ca45-c07b-2e2d-2ec99412dcb9@gmail.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Eric,

On Thu, Nov 01, 2018 at 07:57:26AM -0700, Eric Dumazet wrote:
> On 10/08/2018 04:01 PM, Pablo Neira Ayuso wrote:
[...]
> > @@ -412,21 +406,15 @@ cttimeout_default_fill_info(struct net *net, struct sk_buff *skb, u32 portid,
> >  	    nla_put_u8(skb, CTA_TIMEOUT_L4PROTO, l4proto->l4proto))
> >  		goto nla_put_failure;
> >  
> > -	if (likely(l4proto->ctnl_timeout.obj_to_nlattr)) {
> > -		struct nlattr *nest_parms;
> > -		int ret;
> > -
> > -		nest_parms = nla_nest_start(skb,
> > -					    CTA_TIMEOUT_DATA | NLA_F_NESTED);
> > -		if (!nest_parms)
> > -			goto nla_put_failure;
> > +	nest_parms = nla_nest_start(skb, CTA_TIMEOUT_DATA | NLA_F_NESTED);
> > +	if (!nest_parms)
> > +		goto nla_put_failure;
> >  
> > -		ret = l4proto->ctnl_timeout.obj_to_nlattr(skb, NULL);
> > -		if (ret < 0)
> > -			goto nla_put_failure;
> > +	ret = l4proto->ctnl_timeout.obj_to_nlattr(skb, NULL);
> 
> Hi Pablo
> 
> None of the obj_to_nlattr handlers can handle a NULL pointer.
> What is the intent here ?

It seems this was accidentally set to NULL here.

commit c779e849608a875448f6ffc2a5c2a15523bdcd00
Author: Florian Westphal <fw@strlen.de>
Date:   Fri Jun 29 07:46:50 2018 +0200

    netfilter: conntrack: remove get_timeout() indirection

Just sent patches to fix this to nf-devel ML.

Thanks for reporting !
