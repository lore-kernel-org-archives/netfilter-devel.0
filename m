From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH v3 nf-next 5/7] netfilter: add and use nf_ct_set helper
Date: Mon, 23 Jan 2017 17:10:26 +0100
Message-ID: <20170123161026.GA13546@breakpoint.cc>
References: <1485174530-7678-1-git-send-email-fw@strlen.de>
 <1485174530-7678-6-git-send-email-fw@strlen.de>
 <20170123125403.GA1962@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50636 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750742AbdAWQLI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 23 Jan 2017 11:11:08 -0500
Content-Disposition: inline
In-Reply-To: <20170123125403.GA1962@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jan 23, 2017 at 01:28:48PM +0100, Florian Westphal wrote:
> > diff --git a/net/netfilter/core.c b/net/netfilter/core.c
> > index 0c629fdf90e1..ce6adfae521a 100644
> > --- a/net/netfilter/core.c
> > +++ b/net/netfilter/core.c
> > @@ -375,7 +375,7 @@ void nf_ct_attach(struct sk_buff *new, const struct sk_buff *skb)
> >  {
> >  	void (*attach)(struct sk_buff *, const struct sk_buff *);
> >  
> > -	if (skb_nfct(skb)) {
> > +	if (skb->nfct) {
> 
> I guess this slipped through accidentally. No need to resent, I can
> amend it here.

Hmm, let me review this.  I thin the skb_nfct() conversion is erroneous.
(Q: If original is UNTRRACKED, should the reply packet that is being
 attached be UNTRACKED or INVALID?)

I think its "UNTRACKED", and then this needs testing of skb->_nfct .

(at least once the untracked object gets removed).
