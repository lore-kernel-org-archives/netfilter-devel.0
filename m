From: Florian Westphal <fw@strlen.de>
Subject: Re: nft typeof keywork patch
Date: Wed, 13 Sep 2017 17:27:28 +0200
Message-ID: <20170913152728.GB2453@breakpoint.cc>
References: <20170912172527.GC25977@breakpoint.cc>
 <20170913115823.GA2297@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60492 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751588AbdIMPaf (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2017 11:30:35 -0400
Content-Disposition: inline
In-Reply-To: <20170913115823.GA2297@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Tue, Sep 12, 2017 at 07:25:27PM +0200, Florian Westphal wrote:
> > I am looking into adding 'string' type for sets.
> > To do this I'd need to add the typeof command that you mentioned
> > last year:
> > https://marc.info/?l=netfilter-devel&m=145683813130409&w=2

[..]

> Missing part is to add a UDATA_SET_TYPEOF to store the original
> datatype. So, we dumping back the ruleset, we get same listing.

Wait, so
    nft add set ip filter set1 { typeof ip saddr;}

then it should not list
    nft add set ip filter set1 { type ipv4_addr;}

but the exact input using the typeof()?

I wonder how to encode this, especially given we also need to support
concatenation, e.g.

nft add set ip f s { type ipv4_addr .  typeof meta iifname . typeof tcp dport ;}

> See UDATA_SET_KEYBYTEORDER and UDATA_SET_DATABYTEORDER for instance.

They don't need to store a vector.

For the above we'd need to store the exact text input string to rebuild
cmdline.

I think this needs to store something like this in the kernel:
":4-meta iifname:16-tcp dport:2'.

and nft needs to chew through this to learn the typeof and the size of
the datatype.

Alternatively we need infra in nft to obtain the template that
was used to derive the size from the input string ("meta iifname").

I guess the latter should also be doable.  If we do this then we'd
only need to store something like "-meta iifname-tcp dport" to help
with splitting the key into its components.

> > meta mark set typeof(meta mark) ip saddr
> 
> Casting is something we should definitely explore, yes. Question here
> is that we would need to annotate somewhere that the user has
> specified typeof(), or any cast, so we dump back exactly what the user
> is asking for. Probably this needs userdata area for expressions.

Yes, seems like above needs to annotate payload expression (ip saddr)
with the typecast info.  Alternatively however this MIGHT be able to
be detectable on userspace side, e.g.

meta mark set ip saddr

We know that meta mark wants the packet mark, so we could infer
that user forced an override of the type mismatch, and that can
be determined by looking at the expressions' data type.
