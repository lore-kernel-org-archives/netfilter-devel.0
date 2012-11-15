From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC v2] netfilter: add connlabel conntrack extension
Date: Thu, 15 Nov 2012 13:50:02 +0100
Message-ID: <20121115125002.GI20678@breakpoint.cc>
References: <1351860231-5434-1-git-send-email-fw@strlen.de>
 <20121112065001.GB11330@1984>
 <20121112124705.GC20678@breakpoint.cc>
 <20121115121357.GB31335@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40241 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423250Ab2KOMuD convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 07:50:03 -0500
Content-Disposition: inline
In-Reply-To: <20121115121357.GB31335@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Nov 12, 2012 at 01:47:05PM +0100, Florian Westphal wrote:
> > Alternative would be to keep track of highest bit requested in a "-m connlabel"
> > rule to figure out the needed size.
> > 
> > In any case, it would require adding "u16 len" to the extension area; else
> > we can't figure out how many bytes are valid, i.e.:
> > 
> > struct nf_conn_labels {
> > +       u16 size;		/* length of label storage */
> > +	unsigned long bits[];	/* variable-sized label storage */
> > +};
> > 
> > it would increase minimum length needed but it would avoid
> > the rcu dances done by the current scheme.
> > 
> > It this is ok for you I'll make this change to see how many LOC are
> > saved by this.
> 
> If we simplify the current connlabel code it would be great. And so
> far, the only way I can think to obtain that is to explictly specify
> via the CT target the length of the label.

I've turned it into a var-length extension, so all the rcu dances
and runtime reallocs are gone.

I'll be sending the first non-rfc version of the patchset soon.

Minor drawback: I had to reduce it to 128 labels max, else the
extension offset array (u8 offset[]) will overflow if too many
extensions are enabled.

At the moment the 128 labels max constraint is no problem at all,
and we can increase it later if we reduce total possible extension
size (or use u16 for length/offset tracking).
