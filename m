From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH 2/2] netfilter: connlabels: move set helper to
 xt_connlabel
Date: Fri, 22 Jul 2016 17:17:22 +0200
Message-ID: <20160722151722.GA14547@breakpoint.cc>
References: <1469098277-1227-1-git-send-email-fw@strlen.de>
 <1469098277-1227-3-git-send-email-fw@strlen.de>
 <20160722150926.GA21470@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49618 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751883AbcGVPd2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Jul 2016 11:33:28 -0400
Content-Disposition: inline
In-Reply-To: <20160722150926.GA21470@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Jul 21, 2016 at 12:51:17PM +0200, Florian Westphal wrote:
> > xt_connlabel is the only user so move it.
> > 
> > Signed-off-by: Florian Westphal <fw@strlen.de>
> > ---
> >  include/net/netfilter/nf_conntrack_labels.h |  2 --
> >  net/netfilter/nf_conntrack_labels.c         | 17 -----------------
> >  net/netfilter/xt_connlabel.c                | 29 ++++++++++++++++-------------
> >  3 files changed, 16 insertions(+), 32 deletions(-)
> >
> [...]
> > @@ -40,10 +32,21 @@ connlabel_mt(const struct sk_buff *skb, struct xt_action_param *par)
> >  	if (ct == NULL || nf_ct_is_untracked(ct))
> >  		return invert;
> >  
> > -	if (info->options & XT_CONNLABEL_OP_SET)
> > -		return (nf_connlabel_set(ct, info->bit) == 0) ^ invert;
> > +	labels = nf_ct_labels_find(ct);
> > +	if (!labels)
> > +		return invert;
> > +
> > +	if (test_bit(info->bit, labels->bits))
> > +		return !invert;
> > +
> > +	if (info->options & XT_CONNLABEL_OP_SET) {
> > +		if (!test_and_set_bit(info->bit, labels->bits))
> > +			nf_conntrack_event_cache(IPCT_LABEL, ct);
> > +
> > +		return !invert;
> > +	}
> 
> This patch inverts the existing logic, right? So this is first testing
> for the bit, then setting it.

No, this should have no user-visible change (if it does thats a bug);
nf_connlabel_set() also had a test_bit().

The only change after the patches are applied is that if we have
a valid conntrack with the extension present then a set op will
always succeed (before we had to test if the label->bit[] area was large
enough).

