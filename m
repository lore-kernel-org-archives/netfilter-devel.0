From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v2 nf-next] netfilter: nft_ct: allow to set ctnetlink
 event types of a connection
Date: Sat, 15 Apr 2017 18:53:15 +0200
Message-ID: <20170415165315.GC1707@breakpoint.cc>
References: <20170415102604.29236-1-fw@strlen.de>
 <CAML_gOcrkR6SOqcWrEk=+=QhVb+YZuLg1n6duXk=UsSV0zaAMg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Liping Zhang <zlpnobody@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:57406 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754121AbdDOQyZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Apr 2017 12:54:25 -0400
Content-Disposition: inline
In-Reply-To: <CAML_gOcrkR6SOqcWrEk=+=QhVb+YZuLg1n6duXk=UsSV0zaAMg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Liping Zhang <zlpnobody@gmail.com> wrote:
> 2017-04-15 18:26 GMT+08:00 Florian Westphal <fw@strlen.de>:
> [...]
> > +#ifdef CONFIG_NF_CONNTRACK_EVENTS
> > +       case NFT_CT_EVENTMASK: {
> > +               struct nf_conntrack_ecache *e = nf_ct_ecache_find(ct);
> > +               u16 ctmask = nft_reg_load16(&regs->data[priv->sreg]);
> 
> Hmm, I find that in nft utility, this ctmask is defined as a 32 bit value.

Right, it was deliberate to not have to extend it later on in case we
get more event values in future.

> So using nft_reg_load16 maybe wrong. In order to avoid ambiguity,
> I think it's better to convert it to "u32 ctmask = regs->data[priv->sreg];".

Agree, thats what I'll do, thanks Liping.
