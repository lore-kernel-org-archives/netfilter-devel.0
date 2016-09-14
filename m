From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC] nftables: reverse path filtering for nft
Date: Wed, 14 Sep 2016 19:45:15 +0200
Message-ID: <20160914174515.GA4925@breakpoint.cc>
References: <20160910200102.GA11377@breakpoint.cc>
 <20160912120437.GA9323@salvia>
 <20160912122107.GB27566@breakpoint.cc>
 <20160912185228.GA10862@salvia>
 <20160912190025.GB11685@breakpoint.cc>
 <20160912191438.GA11229@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:39656 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1757740AbcINRpS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 14 Sep 2016 13:45:18 -0400
Content-Disposition: inline
In-Reply-To: <20160912191438.GA11229@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Sep 12, 2016 at 09:00:25PM +0200, Florian Westphal wrote:
> > Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > >         fib lookup ip daddr . oif
> > > 
> > > As you are basically looking for the route based on IPv4 address and
> > > the output interface, so this boils down to:
> > > 
> > >         fib lookup $expr $flags
> > 
> > How would the kernel disentangle the register data?
> 
> What I'm proposing is to represent this as a concatenation, since this
> represents the tuple that you use to look up for route.
> 
> > (i.e., how do i know where in the sreg e.g. the daddr is
> >  that i need to stuff in the flowi struct?)
> 
> You can iterate over the concatenation compound from the
> netlink_linearize path, it is just a list of expressions. Then, you
> can set the NFTA_FIB_* netlink attribute using them.

I found this to be ugly and cumbersome, I'd propose following
syntax instead:

FIB     fib_type     fib_family   '{' fib_addr fib_key_flags '}'

The {} are needed because I'd like to use 'mark' and 'oif' in flags but
these can also be expressions, i.e. I need something that tells
the parser when end of FIB flags are reached (so instead of { }
it could also use single ';' or something else ...)

This gives following examples:

 fib oif { saddr }  # ip route get $saddr, place ifindex into register)
 fib oif { saddr mark,saddr,oif } # same, but populate flowi .saddr,mark,oif
  				    members as well

 fib oif { daddr mark,saddr,oif } # same, except that flowi.daddr is set
				  # to iph->daddr)

so fib_addr is the direction (if you ask for daddr, flowi.daddr is
set to iph->daddr, else iph->saddr).

If you specifiy oif flag, flowi.oif is set to skb->dev.
(Needed for ipv6 to allow strict filtering/ limit results).

Alternative would be to toss 'oif' flag name and use opposite
('loose'), like in iptables.

Yet another alternative would be to use the sysctl we have for this
(net.ipv4.conf.all.rp_filter) but I'd like to avoid it.

The family is optional, it would later allow to e.g. ask for
inet fib lookups from bridge family, and to ask for MAC FIB
lookups for bridge family ('fib oif bridge { saddr }').

If you prefer original "." for this it would be easy to change
but using "," seems more in line with other flag parameters
that nft has.

> From the evaluation step, you would need to validate that the
> expressions that we're using in the concatenation fit into flowi
> struct, otherwise tell the user that they are not supported.

That works (I have a patch) but it requires strcmp() voodoo to find
out what the user asked for initially.

For reference, above grammar looks like this:

fib_expr                :       FIB     fib_type        fib_family   '{' fib_addr       fib_key_flags '}'
                        {
                                $$ = fib_expr_alloc(&@$, $2, $3);
                                $$->fib.addr = $5;
                                $$->fib.flags = $6;
                        }
                        ;

fib_type                :       OIF     { $$ = NFT_FIBTYPE_OIF; }
                        ;

fib_addr                :       SADDR { $$ = IPHDR_SADDR; }
                        |       DADDR { $$ = IPHDR_DADDR; }
                        ;
fib_family              :       /* empty */             { $$ = PROTO_BASE_NETWORK_HDR; }
                        |       INET                    { $$ = PROTO_BASE_NETWORK_HDR; }
                        ;

fib_key_flag            :       MARK    { $$ = NFTA_FIB_F_MARK; }
                        |       SADDR   { $$ = NFTA_FIB_F_SADDR; }
                        |       DSCP    { $$ = NFTA_FIB_F_DSCP; }
                        |       OIF     { $$ = NFTA_FIB_F_OIF; }
                        |       { $$ = 0; }
                        ;

fib_key_flags           :       fib_key_flag
                        |       fib_key_flag COMMA fib_key_flags
                        {
                                $$ = $1 | $3;
                        }
                        ;

So parser handles everything and I don't have to throw 'unsupported expression'
errors from eval step either.

For -m addrtype support, this might look like this:
fib addrtype { saddr oif }

I think it can re-use all of this and I don't see any problems so far.

Let me know and I will start working on kernel side for this.
