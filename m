From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH RFC v2] netfilter: add connlabel conntrack extension
Date: Thu, 15 Nov 2012 14:06:10 +0100
Message-ID: <20121115130610.GA4929@1984>
References: <1351860231-5434-1-git-send-email-fw@strlen.de>
 <20121112065001.GB11330@1984>
 <20121112124705.GC20678@breakpoint.cc>
 <20121115121357.GB31335@1984>
 <50A4E5A5.2000607@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
To: Stephen Clark <sclark46@earthlink.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57182 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2993433Ab2KONGS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 08:06:18 -0500
Content-Disposition: inline
In-Reply-To: <50A4E5A5.2000607@earthlink.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 15, 2012 at 07:52:53AM -0500, Stephen Clark wrote:
> On 11/15/2012 07:13 AM, Pablo Neira Ayuso wrote:
> >Hi Florian,
> >
> >On Mon, Nov 12, 2012 at 01:47:05PM +0100, Florian Westphal wrote:
> >>Pablo Neira Ayuso<pablo@netfilter.org>  wrote:
> >>>>diff --git a/net/netfilter/nf_conntrack_labels.c b/net/netfilter/nf_conntrack_labels.c
> >>>>new file mode 100644
> >>>>index 0000000..eab398b
> >>>>--- /dev/null
> >>>>+++ b/net/netfilter/nf_conntrack_labels.c
> >>>>@@ -0,0 +1,143 @@
> >>>>+#include<linux/ctype.h>
> >>>>+#include<linux/export.h>
> >>>>+#include<linux/jhash.h>
> >>>>+#include<linux/spinlock.h>
> >>>>+#include<linux/types.h>
> >>>>+#include<linux/slab.h>
> >>>>+
> >>>>+#include<net/netfilter/nf_conntrack_ecache.h>
> >>>>+#include<net/netfilter/nf_conntrack_labels.h>
> >>>>+
> >>>>+static int labels_set_realloc(struct nf_conn_labels *l,
> >>>>+			      struct __nf_conn_labels_rcu_ptr *oldptr, u16 bit)
> >>>I think we can simplify this code if we use the CT target to set the
> >>>number of labels that we'll use, so we skip allocations in runtime and
> >>>possible reallocation.
> >>>
> >>>... -t raw -j CT --labels 32
> >>I'm not convinced yet ;-)
> >>
> >>I think we should avoid to make users fiddle with CT target options
> >>just to get certain functionality working.
> >I agree that we should try to keep things easy for users.
> >
> >Still, since the conntrack helper discussion during the last workshop,
> >I think that users should explicitly enable conntrack features they
> >want via iptables.
> >
> >In that direction, I've been toying with some patches to explicitly
> >enable connectiong tracking via the CT target, ie. instead of tracking
> >everything by default and using NOTRACK to say what you don't what
> >(like we do now), tell what you want to track via some explict rule.
> >PF people are doing it that way.
> >
> >Still that's an important semantic change so we'll have to keep some
> >compatibility mode for some time
>
> Yeah, like forever!! Do you realize what a drastic change this would
> be? How many users actually use NOTRACK, and if they do it is for a
> very specific case. Most users expect CONNTRACK to happen.

Aware of it. I already mentioned that we would need to add some
compatibility mode to have dual working mode, relying on the compat
behaviour by default, so noone would be affected.
