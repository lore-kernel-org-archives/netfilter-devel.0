From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH] nf_nat_packet: Clear skb hash after modifying packet
 headers.
Date: Fri, 29 Apr 2016 11:12:12 +0200
Message-ID: <20160429091212.GL17538@breakpoint.cc>
References: <1461187870-54322-1-git-send-email-jarno@ovn.org>
 <20160429090959.GA7236@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jarno Rajahalme <jarno@ovn.org>, netfilter-devel@vger.kernel.org,
	kernel-janitors@vger.kernel.org, dev@openvswitch.org, fw@strlen.de
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160429090959.GA7236@salvia>
Sender: kernel-janitors-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Apr 20, 2016 at 02:31:10PM -0700, Jarno Rajahalme wrote:
> > Clear the skb hash when it does not reflect the actual header values
> > any more.
> > 
> > Signed-off-by: Jarno Rajahalme <jarno@ovn.org>
> > ---
> >  net/netfilter/nf_nat_core.c | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
> > index 06a9f45..3c2302f 100644
> > --- a/net/netfilter/nf_nat_core.c
> > +++ b/net/netfilter/nf_nat_core.c
> > @@ -505,6 +505,7 @@ unsigned int nf_nat_packet(struct nf_conn *ct,
> >  		if (!l3proto->manip_pkt(skb, 0, l4proto, &target, mtype))
> >  			return NF_DROP;
> >  	}
> > +	skb_clear_hash(skb);
> >  	return NF_ACCEPT;
> >  }
> 
> Cc'ing Florian.
> 
> This seems to affect the new tracing infrastructure for nf_tables:

Right.

Jarno, what is your patch trying to fix?
