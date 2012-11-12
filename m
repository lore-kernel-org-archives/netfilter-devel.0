From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH RFC v2] netfilter: add connlabel conntrack extension
Date: Mon, 12 Nov 2012 13:47:05 +0100
Message-ID: <20121112124705.GC20678@breakpoint.cc>
References: <1351860231-5434-1-git-send-email-fw@strlen.de>
 <20121112065001.GB11330@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:54333 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751949Ab2KLMrG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Nov 2012 07:47:06 -0500
Content-Disposition: inline
In-Reply-To: <20121112065001.GB11330@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
> > new file mode 100644
> > index 0000000..eab398b
> > --- /dev/null
> > +++ b/net/netfilter/nf_conntrack_labels.c
> > @@ -0,0 +1,143 @@
> > +#include <linux/ctype.h>
> > +#include <linux/export.h>
> > +#include <linux/jhash.h>
> > +#include <linux/spinlock.h>
> > +#include <linux/types.h>
> > +#include <linux/slab.h>
> > +
> > +#include <net/netfilter/nf_conntrack_ecache.h>
> > +#include <net/netfilter/nf_conntrack_labels.h>
> > +
> > +static int labels_set_realloc(struct nf_conn_labels *l,
> > +			      struct __nf_conn_labels_rcu_ptr *oldptr, u16 bit)
> 
> I think we can simplify this code if we use the CT target to set the
> number of labels that we'll use, so we skip allocations in runtime and
> possible reallocation.
> 
> ... -t raw -j CT --labels 32

I'm not convinced yet ;-)

I think we should avoid to make users fiddle with CT target options
just to get certain functionality working.

Alternative would be to keep track of highest bit requested in a "-m connlabel"
rule to figure out the needed size.

In any case, it would require adding "u16 len" to the extension area; else
we can't figure out how many bytes are valid, i.e.:

struct nf_conn_labels {
+       u16 size;		/* length of label storage */
+	unsigned long bits[];	/* variable-sized label storage */
+};

it would increase minimum length needed but it would avoid
the rcu dances done by the current scheme.

It this is ok for you I'll make this change to see how many LOC are
saved by this.
