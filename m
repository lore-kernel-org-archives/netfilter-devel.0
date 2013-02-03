From: Florian Westphal <fw@strlen.de>
Subject: Re: api: add connlabel api and attribute
Date: Sun, 3 Feb 2013 13:02:45 +0100
Message-ID: <20130203120245.GA32074@breakpoint.cc>
References: <1358980701-3747-3-git-send-email-fw@strlen.de>
 <20130202204811.GA32078@breakpoint.cc>
 <20130203095921.GA3560@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38221 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751695Ab3BCMCq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Feb 2013 07:02:46 -0500
Content-Disposition: inline
In-Reply-To: <20130203095921.GA3560@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > The existing setters all copy their argument, but the current connlabel
> > setter only assigns the pointer, i.e., 'ownership' of the bitmask object
> > is then tied to conntrack object.  This may not be whats expected.
> > 
> > Should I make this change:
> > 
> > set_attr_connlabels(struct nf_conntrack *ct, const void *value, size_t len)
> > {
> > -  ct->connlabels = (void *) value;
> > +  ct->connlabels = nfct_bitmask_clone(value);
> > }
> > 
> > to avoid this or not?
> 
> To attach expectations to master conntracks, we pass the object via
> the setter without cloning it.

Oh? Sorry, I failed to spot that.  But perfect, so there is no need
to make this change.

> So my suggestion is to document how it works and leave it as is. BTW,
> make sure that object is released in the nfct_destroy path if you do
> so.

pushed to -next.

Thanks for your suggestions, i've added a doc-comment to
nfct_bitmask_destroy() about this.
