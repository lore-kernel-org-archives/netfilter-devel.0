From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 5/9] netfilter: conntrack: small refactoring of
 conntrack seq_printf
Date: Wed, 4 May 2016 11:19:46 +0200
Message-ID: <20160504091946.GA1401@salvia>
References: <1461863628-23350-1-git-send-email-fw@strlen.de>
 <1461863628-23350-6-git-send-email-fw@strlen.de>
 <20160503181250.GA4508@salvia>
 <20160503222736.GK2395@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160503222736.GK2395@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, May 04, 2016 at 12:27:36AM +0200, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > -	if (NF_CT_DIRECTION(hash))
> > > -		goto release;
> > > -	if (nf_ct_l3num(ct) != AF_INET)
> > > +	/* check if we raced w. object reuse */
> > > +	if (!nf_ct_is_confirmed(ct) ||
> > 
> > This refactoring includes this new check, is this intentional?
> 
> Hmm, yes and no.
> 
> I should have put it in an extra commit :-/
> 
> Without this, we might erronously print a conntrack that is NEW
> and which isn't confirmed yet.
> 
> We won't crash since seq_print doesn't depend on extensions being
> set up properly, but it seems better to only display those conntracks
> that are part of the conntrack hash table (i.e., have the confirmed bit
> set).

I see, a conntrack that shouldn't be printed be sneak in the listing.

> Let me know if you want me to respin this as a separate fix, thanks!

I will just append a notice on the commit message before applying.
