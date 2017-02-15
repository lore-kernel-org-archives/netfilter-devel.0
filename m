From: Florian Westphal <fw@strlen.de>
Subject: Re: [RFC nf-next] netfilter: ct: add helper assignment support
Date: Wed, 15 Feb 2017 23:19:03 +0100
Message-ID: <20170215221903.GB32431@breakpoint.cc>
References: <20170215162536.982-1-fw@strlen.de>
 <20170215170558.GA22564@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:38062 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752674AbdBOWUH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Feb 2017 17:20:07 -0500
Content-Disposition: inline
In-Reply-To: <20170215170558.GA22564@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > Note from myself, i dislike L3PROTO, it would be nicer to be able
> > to handle this via the table family but I did not yet find a way
> > to detect this from the obj->init() function.
> 
> We can pass nft_ctx to obj->init().

OK, I can make that change then, no problem.

> > Its needed for nf_conntrack_helper_try_module_get().
> > 
> > This also begs the question of how one would handle
> > NFPROTO_INET, in that case we'd want both v4 and v6, but that
> > would require stashing two struct nf_conntrack_helper in
> > priv area.
> 
> Still, someone may want to only enable helper for IPv4 in the inet
> chain, right? It's a bit of corner case but this attribute provides
> slight more flexibility.

But assignment can be limited via nft ... meta nfproto ipv4, no?

> Probably, we should handle NFPROTO_INET as a real family at some
> point, so user doesn't have to specify twice the same configuration to
> attach helpers from inet chains.

Yes, that what I wanted to avoid ...

> On a different front, but related, I've been considering to handle the
> NFPROTO_INET family from the netfilter/core, so we can get rid of the
> existing specific code in nf_tables to handle this pseudofamily.
> Actually, just handle it as a real family. I have a patchset here in a
> branch I made to do this, I would need to revisit it.

Sounds good to me, although I am not sure how you're going to pull this
off ;)

> > Any ideas/suggestions?
> > 
> > +	NFTA_CT_HELPER_L4PROTO,
> 
> Fine by now. We can place here more attributes, such as expectation
> timeouts and specific per-helper setting (eg. ftp loose).  Just a
> matter of adding more attributes later on, no problem.

Right, I wanted to be sure that this is the right direction before
doing this.

> > +	if (nla_strlcpy(name, tb[NFTA_CT_HELPER_NAME], sizeof(name)) >= sizeof(name))
> > +		return -EINVAL;
> 
> nla_policy already ensures we don't go over helper name size.

Right, I'll remove the conditional, thanks Pablo.
