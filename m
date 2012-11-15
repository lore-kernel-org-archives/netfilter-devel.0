From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC v2] netfilter: add connlabel conntrack extension
Date: Thu, 15 Nov 2012 14:09:27 +0100
Message-ID: <20121115130927.GB4929@1984>
References: <1351860231-5434-1-git-send-email-fw@strlen.de>
 <20121112065001.GB11330@1984>
 <20121112124705.GC20678@breakpoint.cc>
 <20121115121357.GB31335@1984>
 <20121115125002.GI20678@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58074 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767704Ab2KONJd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:09:33 -0500
Content-Disposition: inline
In-Reply-To: <20121115125002.GI20678@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 15, 2012 at 01:50:02PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Nov 12, 2012 at 01:47:05PM +0100, Florian Westphal wrote:
> > > Alternative would be to keep track of highest bit requested in a "-m connlabel"
> > > rule to figure out the needed size.
> > > 
> > > In any case, it would require adding "u16 len" to the extension area; else
> > > we can't figure out how many bytes are valid, i.e.:
> > > 
> > > struct nf_conn_labels {
> > > +       u16 size;		/* length of label storage */
> > > +	unsigned long bits[];	/* variable-sized label storage */
> > > +};
> > > 
> > > it would increase minimum length needed but it would avoid
> > > the rcu dances done by the current scheme.
> > > 
> > > It this is ok for you I'll make this change to see how many LOC are
> > > saved by this.
> > 
> > If we simplify the current connlabel code it would be great. And so
> > far, the only way I can think to obtain that is to explictly specify
> > via the CT target the length of the label.
> 
> I've turned it into a var-length extension, so all the rcu dances
> and runtime reallocs are gone.
> 
> I'll be sending the first non-rfc version of the patchset soon.
> 
> Minor drawback: I had to reduce it to 128 labels max, else the
> extension offset array (u8 offset[]) will overflow if too many
> extensions are enabled.

Good point. That reminds me that we should add some bugtrap to
net/netfilter/nf_conntrack_extend.c to check for such possible
overflows.

> At the moment the 128 labels max constraint is no problem at all,
> and we can increase it later if we reduce total possible extension
> size (or use u16 for length/offset tracking).

Sure.
