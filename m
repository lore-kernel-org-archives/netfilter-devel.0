From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC v2] netfilter: add connlabel conntrack extension
Date: Thu, 15 Nov 2012 13:13:57 +0100
Message-ID: <20121115121357.GB31335@1984>
References: <1351860231-5434-1-git-send-email-fw@strlen.de>
 <20121112065001.GB11330@1984>
 <20121112124705.GC20678@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38238 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1423623Ab2KOMOG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 07:14:06 -0500
Content-Disposition: inline
In-Reply-To: <20121112124705.GC20678@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

On Mon, Nov 12, 2012 at 01:47:05PM +0100, Florian Westphal wrote:
> Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
> > > new file mode 100644
> > > index 0000000..eab398b
> > > --- /dev/null
> > > +++ b/net/netfilter/nf_conntrack_labels.c
> > > @@ -0,0 +1,143 @@
> > > +#include <linux/ctype.h>
> > > +#include <linux/export.h>
> > > +#include <linux/jhash.h>
> > > +#include <linux/spinlock.h>
> > > +#include <linux/types.h>
> > > +#include <linux/slab.h>
> > > +
> > > +#include <net/netfilter/nf_conntrack_ecache.h>
> > > +#include <net/netfilter/nf_conntrack_labels.h>
> > > +
> > > +static int labels_set_realloc(struct nf_conn_labels *l,
> > > +			      struct __nf_conn_labels_rcu_ptr *oldptr, u16 bit)
> > 
> > I think we can simplify this code if we use the CT target to set the
> > number of labels that we'll use, so we skip allocations in runtime and
> > possible reallocation.
> > 
> > ... -t raw -j CT --labels 32
> 
> I'm not convinced yet ;-)
> 
> I think we should avoid to make users fiddle with CT target options
> just to get certain functionality working.

I agree that we should try to keep things easy for users.

Still, since the conntrack helper discussion during the last workshop,
I think that users should explicitly enable conntrack features they
want via iptables.

In that direction, I've been toying with some patches to explicitly
enable connectiong tracking via the CT target, ie. instead of tracking
everything by default and using NOTRACK to say what you don't what
(like we do now), tell what you want to track via some explict rule.
PF people are doing it that way.

Still that's an important semantic change so we'll have to keep some
compatibility mode for some time (we would do the conntrack lookup in
the raw table, and follow-up rules will find the ct object). That also
would change the assumption that "you have no ct object in the raw
table" to "you get the ct object just after the -j CT
--enable-tracking rule".

Note that we would have to rename (via aliasing) the raw table to
make it become a filter table in the PREROUTING chain once that
semantic change happens.

As result of that change, it would allow us to remove the current
template logic from:

1) attach the template
2) use the template in nf_conntrack_in() to set on features we requested

to:

1) lookup/create ct object and attach features requested by the user
   all at once.

I'm going to find some spare time to send a RFC patch for this.

> Alternative would be to keep track of highest bit requested in a "-m connlabel"
> rule to figure out the needed size.
> 
> In any case, it would require adding "u16 len" to the extension area; else
> we can't figure out how many bytes are valid, i.e.:
> 
> struct nf_conn_labels {
> +       u16 size;		/* length of label storage */
> +	unsigned long bits[];	/* variable-sized label storage */
> +};
> 
> it would increase minimum length needed but it would avoid
> the rcu dances done by the current scheme.
> 
> It this is ok for you I'll make this change to see how many LOC are
> saved by this.

If we simplify the current connlabel code it would be great. And so
far, the only way I can think to obtain that is to explictly specify
via the CT target the length of the label.

Regards.
